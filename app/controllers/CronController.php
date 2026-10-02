<?php
use Phalcon\Mvc\Controller;

class CronController extends Controller
{

	public function onConstruct()
	{
		// Remove a construção do layout - deixando somente o conteúdo carregado neste Controller
		$this->view->disable();


		 // pra remover o cache e forçar a carregar uma página nova
	    header("Expires: Tue, 03 Jul 2001 06:00:00 GMT");
	    header("Last-Modified: " . gmdate("D, d M Y H:i:s") . " GMT");
	    header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
	    header("Cache-Control: post-check=0, pre-check=0", false);
	    header("Pragma: no-cache");
	    header("Connection: close");


	}



	public function indexAction()
	{
		//echo 'index function';

	}



	public function proccess_paymentAction($id_order = false)
	{
		if ( $id_order ) {
			$ProccessPayment = new ProccessPayment();
			$result = $ProccessPayment->proccess($id_order);
		}

		$LogOrderProccessPayment = new LogOrderProccessPayment();
		$LogOrderProccessPayment->id_order = $id_order;
		$LogOrderProccessPayment->id_orders_payment = null;
		$LogOrderProccessPayment->response = print_r($result, true);
		$LogOrderProccessPayment->obs = 'Executado pela CRON';
		$LogOrderProccessPayment->created_at = date('Y-m-d H:i:s');
		$LogOrderProccessPayment->save();
	}






	public function send_multibancoAction($id_order = null)
	{
		if ( $id_order )
		{
			$order = Orders::findFirst($id_order);

			if ( $order->id == $id_order )
			{
				$LogOrderProccessPayment = LogOrderProccessPayment::findFirst(
					[
						"id_order = :id_order: ",
						"bind" => [
							"id_order"    => $id_order
						]
					]
				);
				$customer = $order->Customers;

				if ( $order->send_to_email )
				{
					$email = $order->send_to_email;
					$name = $order->send_to_email;
					if ( $customer ) {
						$name = $customer->name;
					}

					$param = array('order' => $order, 'LogOrderProccessPayment' => $LogOrderProccessPayment, 'customer' => $customer);
					$sendMail = $this->getDI()->getMail()->send(
					array(
						$email => $name // destinatario
					),
					'Confirmação de Reserva', // assunto
					'multibanco', // template
					$param // array de parametros para ser usado no template
					);

					if ( $sendMail ) {
						return array(
							"success" => true
						);
					}else {
						return array(
								"success" => false,
								"message" => print_r($sendMail)
							);
					}
				} else if ( $order->send_to_sms )
				{
					$cell_number = $order->send_to_sms;
					require_once(BASE_PATH . '/app/library/SMS.php');
					//$sendSMS = new SMS('teste');
					$sendSMS = new SMS('producao');
					$multibanco = json_decode($LogOrderProccessPayment->response, true);

					$order_value = number_format($order->value_total, 2, ',', '.');
					$amount = $order_value;
					$entity = $multibanco['curl']['resultDetails']['ptmntEntty'];
					$reference = $multibanco['curl']['resultDetails']['pmtRef'];
					$reference = substr($reference, 0, 3) . ' ' . substr($reference, 3, 3) . ' ' . substr($reference, 6);
					$date_end =  date('Y-m-d H:i:s', strtotime($multibanco['curl']['resultDetails']['refLmtDtTm']));
					$date_end = $this->getDI()->getFormatdates()->format($date_end, '25/01/2000 17:00h') ;

					$message = "Le Billet
Junto enviamos os dados para o pagamento da sua reserva

Entidade: $entity
Referencia: $reference
Valor: € $amount
Validade: $date_end

Obrigado.";
					$sendSMS = $sendSMS->send($cell_number, $message);
					if ( isset($sendSMS['curl']['status']) AND $sendSMS['curl']['status'] == 'OK' ) {
						return array(
									"success" => true
								);
					} else {
						return array(
									"success" => false,
									"message" => json_encode( $sendSMS['curl'] )
								);
					}


				} else if ( $order->send_to_whatsapp )
				{
					$multibanco = json_decode($LogOrderProccessPayment->response, true);

					$order_value = number_format($order->value_total, 2, ',', '.');
					$amount = $order_value;
					$entity = $multibanco['curl']['resultDetails']['ptmntEntty'];
					$reference = $multibanco['curl']['resultDetails']['pmtRef'];
					$reference = substr($reference, 0, 3) . ' ' . substr($reference, 3, 3) . ' ' . substr($reference, 6);
					$date_end =  date('Y-m-d H:i:s', strtotime($multibanco['curl']['resultDetails']['refLmtDtTm']));
					$date_end = $this->getDI()->getFormatdates()->format($date_end, '25/01/2000 17:00h') ;

					$message = "Olá

👇 *Enviamos os dados para pagamento Multibanco*

Entidade:  *{$entity}*
Referência:  *{$reference}*
Valor:  *€ {$amount}*

Validade: {$date_end}

_Reserva temporária: {$id_order}_


⏳ Depois de efetuado o pagamento, receberá a confirmação com seus bilhetes

⚠️ Tanto este documento como o talão de multibanco não poderão ser utilizados como título de entrada

✉️ Para qualquer esclarecimento, contacte-nos https://lebillet.my/helpdesk


_Obrigado por ter escolhido a LeBillet._";

					require_once(BASE_PATH . '/app/library/WhatsApp.php');
					// $sendWhatsapp = new WhatsApp('ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', '+552731800700');
					$sendWhatsapp = new WhatsApp();
					$whatsapp = $order->send_to_whatsapp;
					$whatsapp = str_replace(array(".", "-", "_", " ", "/", "(", ")"), "", $whatsapp);
					// Em PORTUGAL - valida o Whatsapp, adiciona o código do pais  +351
					if ( COMPANY == 'lebillet_pt' )
					{
						if ( substr($whatsapp, 0, 4) != '+351' ) {
							$whatsapp = '+351' . $whatsapp;
						}
					}
					$sendWhatsapp = $sendWhatsapp->send($whatsapp, $message);
				}



			}
		}
	}



	public function send_orderAction($id_order = null, $preload = true)
	{
		if ( $id_order )
		{
			$order = Orders::findFirst($id_order);

			if ( $order->id == $id_order )
			{
				$send = array('success' => false, 'message' => 'Sending failed');
			/*
							if ( $preload == true )
							{
								$url_preload = $this->url->get() . 'cron/preloadTickets/' . $id_order;
								$preload_ticket = "wget ". $url_preload . "  > /dev/null &";
								$exec = exec($preload_ticket);
							}
			*/

				$sales = Sales::findFirst('id_order = ' . $order->id);
				if($sales){
					//if($sales->id_event == 1 || $sales->id_event == 785){
						
						
					//}
				}

                                $apiSend = $this->send_tickets_to_apiAction($id_order);
                                //$send['api_send'] = json_decode($apiSend, true);

				$CartLib = new CartLib();
				$send = $CartLib->sendEmailOrder($id_order);
				$send = $CartLib->sendWhatsappOrder($id_order);
				/* if ( $order->send_to_email )
				{
					$send = $CartLib->sendEmailOrder($id_order);
				} else if ( $order->send_to_sms )
				{
					$send = $CartLib->sendSMSOrder($id_order);
				} else if ( $order->send_to_whatsapp )
				{
					$send = $CartLib->sendWhatsappOrder($id_order);
				} else
				{
					$send = $CartLib->sendEmailOrder($id_order);
				} */

				return json_encode($send);

			} else {
				return json_encode(array('success' => false, 'message' => 'Order not found'));
			}

		}
		return json_encode(array('success' => false, 'message' => 'Order not found'));

	}


/**
 * Envia os dados dos ingressos para a API externa
 * @param int $id_order ID da ordem
 * @return array Resultado das operações de envio
 */
public function send_tickets_to_apiAction($id_order = null)
{
    if (!$id_order) {
        return json_encode(['success' => false, 'message' => 'Order ID not found']);
    }

    $order = Orders::findFirst($id_order);
    if (!$order) {
        return json_encode(['success' => false, 'message' => 'Order not found']);
    }

    // Verificar se o gerador de código de barras está disponível
    $barcodeGeneratorAvailable = class_exists('Picqer\Barcode\BarcodeGeneratorHTML');

    $results = [];
    $curlHandles = [];
    $multiCurl = curl_multi_init();
    
    // Iterar sobre todas as vendas da ordem
    foreach ($order->OrderSale as $orderSale) {
        $sale = $orderSale->Sales;
        $event = $sale->Events;
        
        // Iterar sobre todos os itens de venda (ingressos)
        foreach ($sale->SalesItems as $ticket) {
            // Extrair o código EAN (se disponível)
            $ean = '';
            if (isset($ticket->code_ean)) {
                $ean = $ticket->code_ean;
            } else if (isset($ticket->ticket) && strlen($ticket->ticket) >= 7) {
                // Se não tiver code_ean específico, podemos usar o número do ticket como alternativa
                // ou qualquer outra lógica de negócio que você tenha para gerar códigos EAN
                $ean = $ticket->ticket;
            }
            
            // Construir os dados do ingresso para enviar à API
            $ticketData = [
                'id_event' => $ticket->id_event,
                'id_ticket' => $ticket->ticket,
                'eventName' => $event->name,
                'venue' => $event->Places->name,
                'location' => $event->Cities->name . ' - ' . $event->Regions->acronym,
                'eventDate' => $this->getDI()->getFormatdates()->format($event->date_start, '25/Jan/2000'),
                'eventTime' => $this->getDI()->getFormatdates()->format($event->date_start, '17:00h'),
                'price' => number_format($ticket->value_product / $ticket->fraction, 2, '.', ''),
                'ticketType' => '',
                'productName' => $ticket->Products->name,
                'productLabel' => ($ticket->id_product_seat > 1) ? $ticket->ProductsSeats->label : '',
                'productGenre' => ($ticket->Products->id_genre > 1) ? $ticket->Products->ProductsGenres->name : '',
                'productType' => ($ticket->id_product_type > 1) ? $ticket->ProductsTypes->name : '',
            ];
            
            // Adicionar tipo de ingresso (se disponível)
            if ($ticket->Products->id_genre > 1) {
                $ticketData['ticketType'] = $ticket->Products->ProductsGenres->name;
            }
            if ($ticket->id_product_type > 1) {
                if ($ticket->Products->id_genre > 1) {
                    $ticketData['ticketType'] .= ' - ';
                }
                $ticketData['ticketType'] .= $ticket->ProductsTypes->name;
            }
            
            // Adicionar nome do cliente (se disponível)
            if ($order->Customers) {
                $ticketData['customerName'] = $order->Customers->name;
            } else {
                $ticketData['customerName'] = '';
            }
            
            $ticketData['customerName'] = $ticket->Products->name;

            // Adicionar número do ingresso e código de barras EAN
            $ticketData['ticketNumber'] = $ticket->ticket;
            $ticketData['barcode'] = $ean;
            
            // Adicionar detalhes da empresa (organizador do evento)
            $ticketData['company'] = $event->Organizers->name;
            $ticketData['companyDetails'] = [];
            
            // Detalhes da empresa - adicione ou remova conforme necessário
            if (!empty($event->Organizers->doc)) {
                $ticketData['companyDetails'][] = $event->Organizers->doc;
            }
            
            // Exemplo para adicionar mais detalhes da empresa, se você tiver esses campos
            if (isset($event->Organizers->type)) {
                $ticketData['companyDetails'][] = $event->Organizers->type;
            }
            
            if (isset($event->Organizers->legal_name)) {
                $ticketData['companyDetails'][] = $event->Organizers->legal_name;
            }
            
            // Se não tiver dados suficientes, podemos incluir strings fixas como no seu exemplo
            if (empty($ticketData['companyDetails'])) {
                $ticketData['companyDetails'] = [
                    "TECNOLOGIA",
                    "SOCIEDADE",
                    "UNIPESSOAL LDA",
                    $event->Organizers->doc ?? "516085115"
                ];
            }
            
            // Adicionar URL da imagem do evento (se disponível)
            if ($event->logo) {
                $ticketData['eventImageUrl'] = $this->config->application->completeUrl . 'img/shows/' . $event->logo;
            } else {
                $ticketData['eventImageUrl'] = '';
            }
            
            // Preparar e configurar requisição cURL
            $ch = curl_init();
            curl_setopt($ch, CURLOPT_URL, 'https://sgy4bwtay6ezuj5f52nruok2mu0jhepd.lambda-url.us-east-1.on.aws/');
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($ticketData));
            curl_setopt($ch, CURLOPT_HTTPHEADER, [
                'Content-Type: application/json',
                'x-api-token: 1234'
            ]);
            
            // Registrar os dados que estamos enviando (opcional, para debug)
            $ticketData['raw_data'] = json_encode($ticketData);
            
            // Adicionar à pilha multi_curl
            curl_multi_add_handle($multiCurl, $ch);
            $curlHandles[$ticket->ticket] = [
                'handle' => $ch,
                'data' => $ticketData
            ];
        }
    }
    
    // Executar as requisições em paralelo
    $running = null;
    do {
        curl_multi_exec($multiCurl, $running);
    } while ($running);
    
    // Processar resultados
    foreach ($curlHandles as $ticketId => $info) {
        $ch = $info['handle'];
        $response = curl_multi_getcontent($ch);
        $statusCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $results[$ticketId] = [
            'data' => $info['data'],
            'response' => $response,
            'status_code' => $statusCode
        ];
        curl_multi_remove_handle($multiCurl, $ch);
    }
    
    // Fechar recursos
    curl_multi_close($multiCurl);
    
    // Opcional: Salvar um log da operação
    if (method_exists($this, 'logTicketApiSend')) {
        $this->logTicketApiSend($id_order, $results);
    }
    
    return json_encode([
        'success' => true, 
        'message' => 'Tickets data sent to API',
        'results' => $results
    ]);
}




	public function send_faturaAction($fatura = null, $id_sale = null)
	{
		if ( $fatura  && $id_sale)
		{
			$CartLib = new CartLib();
			$send = $CartLib->sendEmailFatura($fatura, $id_sale);

			return json_encode($send);

		}
		return json_encode(array('success' => false, 'message' => 'File not found'));

	}

	public function send_faturaOrgAction($fatura = null, $name, $nif, $morada, $email)
	{
		if ( $fatura )
		{
			$CartLib = new CartLib();
			$send = $CartLib->sendEmailFaturaOrg($fatura, $name, $nif, $morada, $email);

			return json_encode($send);

		}
		return json_encode(array('success' => false, 'message' => 'File not found'));

	}

	public function send_multibanco_sibsAction($id_order = null, $preload = true)
	{

		if ( $id_order )
		{
			$order = Orders::findFirst($id_order);
			
			if ( $order->id == $id_order )
			{
				$CartLib = new CartLib();
				$entity = $_GET['entity'];
				$expireDate = $_GET['expireDate'];
				$reference = $_GET['reference'];
				$value = $_GET['value'];
				$send = $CartLib->sendEmailMultiBanco($id_order, $entity, $expireDate, $reference, $value);
				return json_encode($send);
			}{
				return json_encode(array('success' => false, 'message' => 'Order not found'));
			}
		}
		return json_encode(array('success' => false, 'message' => 'Order not found'));

	}




	public function send_sms_orderAction($id_order = null, $preload = true)
	{
		if ( $id_order ) {
/*
			if ( $preload == true )
			{
				$url_preload = $this->url->get() . 'cron/preloadTickets/' . $id_order;
				$preload_ticket = "wget ". $url_preload . "  > /dev/null &";
				$exec = exec($preload_ticket);
			}
*/

			$CartLib = new CartLib();
			$sendSMS = $CartLib->sendSMSOrder($id_order);

			return json_encode($sendSMS);
		}
		return json_encode(array('success' => false, 'message' => 'Order not found'));

	}

	public function send_sms_twilioAction($preload = true)
	{
		$to = isset($_GET['to'])? $_GET['to'] : false;
		$code = isset($_GET['msg'])? $_GET['msg'] : false;
	 
		if ( $to ) {
			$to = "+".$to;
			$CartLib = new CartLib();
			$sendSms = $CartLib->sendSmsTwilio($to, $code);

			return json_encode($sendSms);
		}
		
		return json_encode(array('success' => false, 'message' => 'Number not found'));

	}


	public function send_whatsapp_orderAction($id_order = null, $preload = true)
	{
		if ( $id_order ) {
/*
			if ( $preload == true )
			{
				$url_preload = $this->url->get() . 'cron/preloadTickets/' . $id_order;
				$preload_ticket = "wget ". $url_preload . "  > /dev/null &";
				$exec = exec($preload_ticket);
			}
*/

			$CartLib = new CartLib();
			$sendWhatsapp = $CartLib->sendWhatsappOrder($id_order);

			return json_encode($sendWhatsapp);
		}
		return json_encode(array('success' => false, 'message' => 'Order not found'));

	}

	public function send_whatsapp_order_newAction($id_order = null, $preload = true)
	{
		if ( $id_order ) {
			/*
						if ( $preload == true )
						{
							$url_preload = $this->url->get() . 'cron/preloadTickets/' . $id_order;
							$preload_ticket = "wget ". $url_preload . "  > /dev/null &";
							$exec = exec($preload_ticket);
						}
			*/

			$CartLib = new CartLib();
			$sendWhatsapp = $CartLib->sendWhatsappOrderNew($id_order);

			return json_encode($sendWhatsapp);
		}
		return json_encode(array('success' => false, 'message' => 'Order not found'));

	}

	public function send_whatsapp_mensage_newAction($number = null, $preload = true)
	{
		if ( $number ) {

			$CartLib = new CartLib();
			$sendWhatsapp = $CartLib->sendWhatsappMensageNew($number);
			return json_encode($sendWhatsapp);
		}
		return json_encode(array('success' => false, 'message' => 'Number not found'));

	}
	





	public function send_email_orderAction($id_order = null, $preload = true)
	{
		if ( $id_order ) {
		/*
					if ( $preload == true )
					{
						$url_preload = $this->url->get() . 'cron/preloadTickets/' . $id_order;
						$preload_ticket = "wget ". $url_preload . "  > /dev/null &";
						$exec = exec($preload_ticket);
					}
		*/


			$CartLib = new CartLib();
			$sendMail = $CartLib->sendEmailOrder($id_order);

			echo 'sendMail<pre>';
			print_r($sendMail);
			echo '</pre>';
		}
		/*  // MUITO LOG, nunca foi usado isto
		$LogOrderEmailSent = new LogOrderEmailSent();
		$LogOrderEmailSent->id_order = $id_order;
		$LogOrderEmailSent->email_to = print_r($sendMail, true);
		$LogOrderEmailSent->obs = 'Executado pela CRON';
		$LogOrderEmailSent->created_at = date('Y-m-d H:i:s');
		$LogOrderEmailSent->save();
		*/
	}

	public function send_email_orders_cronAction($preload = true)
	{
		$CartLib = new CartLib();
		$sendMail = $CartLib->sendEmailOrdersVerify();

		echo 'sendMail<pre>';
		print_r($sendMail);
		echo '</pre>';
	}
	


	public function view_orderAction($id_order = null)
	{
		$order = Orders::findFirst($id_order);
		$this->view->order = $order;

		$this->view->enable();
		$this->view->pick("emailTemplates/" . $this->config->company->template_email_order_confirmation);

		$this->view->setRenderLevel(
			Phalcon\Mvc\View::LEVEL_ACTION_VIEW
		);
	}






	public function preloadTicketsAction($id_order = null)
	{
		// para não rodar mais isso - testando a geração lá em outro servidor
		return true;


		/*
		Mudamos o template do email, para inserir os ingressos no corpo do email
		É gerado uma imagem do ingresso e inserido no corpo no email
		Em compras com mais de 1 ingresso, as vezes não carrega todas imagens na primeira tentativa
		Então fazemos uma requisição para a imagem, assim ela é carregada antes
		*/
		$cont = 0;
		$order = Orders::findFirst($id_order);
		$path_tickets = $this->di->get('pathSite') . 'public/tickets/';
		foreach ( $order->OrderSale AS $sales) {
			$sale = $sales->Sales;
			$event = $sale->Events;
			$products = $sale->SalesItems;
			foreach ( $products AS $product )
			{
				$ticket_url = base64_encode($product->id_event . '#' . $product->ticket);
				$ticket_name = $product->id_event . '_' . $product->ticket . '.png';

				$img_ticket = $this->url->get() . 'ticket/' . $ticket_url;
				//$img_ticket = 'http://localhost/tickets/site/ticket/' . $ticket_url;

				$path = $path_tickets . $ticket_name;

				if ( !file_exists($path) )
				{
					// Usar mais de 1 API - para ser mais rapido e não estourar limites das API
					if ( $cont % 2 == 0 ) {
						$url_qr_code = 'http://api.qrserver.com/v1/create-qr-code/?data=' . $product->ticket . '&size=200x200';
					} else {
						$url_qr_code = 'https://chart.googleapis.com/chart?chs=200x200&cht=qr&chl=' . $product->ticket . '&choe=UTF-8&chld=L|0';
					}

					$qr_code = file_get_contents($url_qr_code);
					if ( $qr_code ) { // Capturou o QRCODE
						$file_put_contents = file_put_contents($path_tickets . 'qr_code_' . $ticket_name, $qr_code );

						if ( $file_put_contents ) { // Salvou no servidor

							// Gera a imagem do ticket
							$file_get = file_get_contents($img_ticket);

							//$preload_ticket = "wget ". $img_ticket . "  > /dev/null &";
							//$exec = exec($preload_ticket);
						}
					}

					//$sql = " INSERT INTO _log (value) VALUES ('$path'); ";
					//$this->db->execute($sql);
				}
				$cont++;
			}
		}
	}








	public function tinify_checkAction()
	{
		$this->view->enable();
		$this->view->setRenderLevel(
			Phalcon\Mvc\View::LEVEL_ACTION_VIEW
		);
		$keys = array(
			'tecnologia+1@lebillet.com.br' => 'CmnH1PHPW816BSb6rpgwTCKj0gc73kl9',
			'tecnologia+2@lebillet.com.br' => 'C796RWYkz483FScpHysC9BSW72y9l1mp',
			'tecnologia+3@lebillet.com.br' => '2rPKkfBxyjHbt90qwdqfWY41LZyQhH0N',
			'tecnologia+4@lebillet.com.br' => 'qtqcGMfPDBSjVBvgmdQdSdmtmP1QDLJw',
			'tecnologia+5@lebillet.com.br' => 'yM5Cs66g0fBLgzRxdTGdWxD3pK3zb0yX',
			'tecnologia+6@lebillet.com.br' => 'vhDDbLn9ZlQfCsDZvcvLVJw6DF4d29Nj',

			'tecnologia+7@lebillet.com.br' => '1zWGTcHvf96kxS3rlwZYXdMKH1qLTbp8',
			'tecnologia+8@lebillet.com.br' => 'XGH9mkKlNlGftV5S1zr2P3GRdm1KfYxg',
			'juscelino+tiny@tiktx.com' => '5zN0plldptz19SVMvwR6jJXGM4VJKnzP',
			'noreply@tiktx.com' => 'sbsb5Jzx7P94p9mVHm4M4mLtc8G7GM4r',
			'info+tiny@tiktx.com' => 'lgKTY00dlTd8hhmmRBrfY20Zjl8PHNJY',
			'tecnologia@lebillet.com.br' => 'dv254ktyLSXWw5T9PKFLSMdc7DJq64CT',

			'tiktx.co@gmail.com' => 'JXTz6Wm34qkjJVDC0zH0SKXVtWYmFLVd',
			'tiktx.co+1@gmail.com' => 'KNWV6tcJ1ffmyqb2vYMmlYj886kyCKPB',
			'tiktx.co+2@gmail.com' => 'ZXKGm8ZlbrC33Mvzjtl2Hskl6wkgSYDB',
			'tiktx.co+3@gmail.com' => '9VjhPHT6S8ywFV3Thcct9v8xyXQCzQ4v',
			'tiktx.co+4@gmail.com' => '0GS1KTqK1T8H3nwSxTWngxq7g5s6jq6P',
			'tiktx.co+5@gmail.com' => 'TdSWpRpcMJCPxBCQrZJqcTwGJVlpXsGf',


			'lebillet.com.br+1@gmail.com' => 'y8WxNL8D0Hd4Ft88Rbx8fkblyP165CN8',
			'lebillet.com.br+2@gmail.com' => 'fzkJ7VVgK8PS5qf6MdWSVvF5n34S0xnC',
			'lebillet.com.br+3@gmail.com' => 'zt9z5XgxL9tHmjMnn2HK8P3BhsS6jnBc',
			'lebillet.com.br+4@gmail.com' => 'hx4BrfM95JWZ1Cr71DvPBMrcj30CKCRS',
			'lebillet.com.br+5@gmail.com' => 'fThM3xRqC7L2LFZdNM05t4nWMZ3X0QS0',
			'lebillet.com.br+6@gmail.com' => 'v3LHN7yF8kXsv8FP0kYqQm1SJdwnsRrF',


			'lebillet.com.br+tiny1@gmail.com' => 'Dz3sxgTVkWRFn3ZXpgQLRMXZL7PYF548',
			'lebillet.com.br+tiny2@gmail.com' => '7BngNG4HvhyScJQXS2mx74VyqgC9N9gP',
			'lebillet.com.br+tiny3@gmail.com' => 'b6cgwGFs2l7Yrczl6YtPRfKLwwbqDWFH',
			'lebillet.com.br+tiny4@gmail.com' => 'D24K9G3w5x7WGRS1vWvhxZbVQB3VwV4G',
			'lebillet.com.br+tiny5@gmail.com' => 'TFl7zQ3Jl8fphTTBJjz5Kr7Ny8byTfcQ',
			'lebillet.com.br+tiny6@gmail.com' => 'mkTWp10SfZZ6BSzjJkWdT3p5ByGtf166',



		);




		try {
			require_once(BASE_PATH . '/app/library/Tinify/Exception.php');
			require_once(BASE_PATH . '/app/library/Tinify/ResultMeta.php');
			require_once(BASE_PATH . '/app/library/Tinify/Result.php');
			require_once(BASE_PATH . '/app/library/Tinify/Source.php');
			require_once(BASE_PATH . '/app/library/Tinify/Client.php');
			require_once(BASE_PATH . '/app/library/Tinify.php');


			foreach ( $keys AS $key => $val )
			{
				\Tinify\setKey($val);

				// Precisa disto para retornar o compressionCount mesmo sem enviar qualquer imagem
			    \Tinify\validate();

			    echo "<hr><p> $val - <b> $key </b> </p>";
				$compressionsThisMonth = \Tinify\compressionCount();
				echo  "<h2>  $compressionsThisMonth  </h2>";
			}




		} catch(\Tinify\AccountException $e) {
			print("The error message is: " . $e->getMessage());
    // Verify your API key and account limit.
		} catch(\Tinify\ClientException $e) {
			print("The error message is: " . $e->getMessage());
    // Check your source image and request options.
		} catch(\Tinify\ServerException $e) {
			print("The error message is: " . $e->getMessage());
    // Temporary issue with the Tinify API.
		} catch(\Tinify\ConnectionException $e) {
			print("The error message is: " . $e->getMessage());
    // A network connection error occurred.
		} catch(Exception $e) {
    // Something else went wrong, unrelated to the Tinify API.
			echo 'Exception $e<pre>';
			print_r($e);
			echo '</pre>';

		}




	}








	public function tinifyAction($path_img = false)
	{
		$this->view->enable();
		$this->view->setRenderLevel(
			Phalcon\Mvc\View::LEVEL_ACTION_VIEW
		);

		$keys = array(
			'tecnologia+1@lebillet.com.br' => 'CmnH1PHPW816BSb6rpgwTCKj0gc73kl9',
			'tecnologia+2@lebillet.com.br' => 'C796RWYkz483FScpHysC9BSW72y9l1mp',
			'tecnologia+3@lebillet.com.br' => '2rPKkfBxyjHbt90qwdqfWY41LZyQhH0N',
			'tecnologia+4@lebillet.com.br' => 'qtqcGMfPDBSjVBvgmdQdSdmtmP1QDLJw',
			'tecnologia+5@lebillet.com.br' => 'yM5Cs66g0fBLgzRxdTGdWxD3pK3zb0yX',
			'tecnologia+6@lebillet.com.br' => 'vhDDbLn9ZlQfCsDZvcvLVJw6DF4d29Nj',

			'tecnologia+7@lebillet.com.br' => '1zWGTcHvf96kxS3rlwZYXdMKH1qLTbp8',
			'tecnologia+8@lebillet.com.br' => 'XGH9mkKlNlGftV5S1zr2P3GRdm1KfYxg',
			'juscelino+tiny@tiktx.com' => '5zN0plldptz19SVMvwR6jJXGM4VJKnzP',
			'noreply@tiktx.com' => 'sbsb5Jzx7P94p9mVHm4M4mLtc8G7GM4r',
			'info+tiny@tiktx.com' => 'lgKTY00dlTd8hhmmRBrfY20Zjl8PHNJY',
			'tecnologia@lebillet.com.br' => 'dv254ktyLSXWw5T9PKFLSMdc7DJq64CT',

			'tiktx.co@gmail.com' => 'JXTz6Wm34qkjJVDC0zH0SKXVtWYmFLVd',
			'tiktx.co+1@gmail.com' => 'KNWV6tcJ1ffmyqb2vYMmlYj886kyCKPB',
			'tiktx.co+2@gmail.com' => 'ZXKGm8ZlbrC33Mvzjtl2Hskl6wkgSYDB',
			'tiktx.co+3@gmail.com' => '9VjhPHT6S8ywFV3Thcct9v8xyXQCzQ4v',
			'tiktx.co+4@gmail.com' => '0GS1KTqK1T8H3nwSxTWngxq7g5s6jq6P',
			'tiktx.co+5@gmail.com' => 'TdSWpRpcMJCPxBCQrZJqcTwGJVlpXsGf',


			'lebillet.com.br+1@gmail.com' => 'y8WxNL8D0Hd4Ft88Rbx8fkblyP165CN8',
			'lebillet.com.br+2@gmail.com' => 'fzkJ7VVgK8PS5qf6MdWSVvF5n34S0xnC',
			'lebillet.com.br+3@gmail.com' => 'zt9z5XgxL9tHmjMnn2HK8P3BhsS6jnBc',
			'lebillet.com.br+4@gmail.com' => 'hx4BrfM95JWZ1Cr71DvPBMrcj30CKCRS',
			'lebillet.com.br+5@gmail.com' => 'fThM3xRqC7L2LFZdNM05t4nWMZ3X0QS0',
			'lebillet.com.br+6@gmail.com' => 'v3LHN7yF8kXsv8FP0kYqQm1SJdwnsRrF',


			'lebillet.com.br+tiny1@gmail.com' => 'Dz3sxgTVkWRFn3ZXpgQLRMXZL7PYF548',
			'lebillet.com.br+tiny2@gmail.com' => '7BngNG4HvhyScJQXS2mx74VyqgC9N9gP',
			'lebillet.com.br+tiny3@gmail.com' => 'b6cgwGFs2l7Yrczl6YtPRfKLwwbqDWFH',
			'lebillet.com.br+tiny4@gmail.com' => 'D24K9G3w5x7WGRS1vWvhxZbVQB3VwV4G',
			'lebillet.com.br+tiny5@gmail.com' => 'TFl7zQ3Jl8fphTTBJjz5Kr7Ny8byTfcQ',
			'lebillet.com.br+tiny6@gmail.com' => 'mkTWp10SfZZ6BSzjJkWdT3p5ByGtf166',

		);




		try {
			require_once(BASE_PATH . '/app/library/Tinify/Exception.php');
			require_once(BASE_PATH . '/app/library/Tinify/ResultMeta.php');
			require_once(BASE_PATH . '/app/library/Tinify/Result.php');
			require_once(BASE_PATH . '/app/library/Tinify/Source.php');
			require_once(BASE_PATH . '/app/library/Tinify/Client.php');
			require_once(BASE_PATH . '/app/library/Tinify.php');


			// Distribui as chaves para ficar no limite de 500 da API
			$minute = date('i');
			if (  $minute < 10 ) {

				$key = "Dz3sxgTVkWRFn3ZXpgQLRMXZL7PYF548";

			} elseif ( $minute < 20 ) {

				$key = "7BngNG4HvhyScJQXS2mx74VyqgC9N9gP";

			} elseif (  $minute < 30 ) {

				$key = "b6cgwGFs2l7Yrczl6YtPRfKLwwbqDWFH";

			} elseif (  $minute < 40 ) {

				$key = "D24K9G3w5x7WGRS1vWvhxZbVQB3VwV4G";

			} elseif (  $minute < 50 ) {

				$key = "TFl7zQ3Jl8fphTTBJjz5Kr7Ny8byTfcQ";

			} else {

				$key = "mkTWp10SfZZ6BSzjJkWdT3p5ByGtf166";
			}



			if ( isset($_REQUEST['key']) ) {
				$key = $_REQUEST['key'];
			}


			echo 'key tinify<pre>';
			print_r($key);
			echo '</pre>';

			\Tinify\setKey($key);


			// Precisa disto para retornar o compressionCount mesmo sem enviar qualquer imagem
		    \Tinify\validate();



			$compressionsThisMonth = \Tinify\compressionCount();
			echo 'compressionsThisMonth<pre>';
			print_r($compressionsThisMonth);
			echo '</pre>';



			if ( $path_img )
			{
				$path_img = base64_decode($path_img);

				echo '$path_img<pre>';
				print_r($path_img);
				echo '</pre>';


				$source = \Tinify\fromFile($path_img);
				$source->toFile($path_img);
			}


		} catch(\Tinify\AccountException $e) {
			print("The error message is: " . $e->getMessage());
    // Verify your API key and account limit.
		} catch(\Tinify\ClientException $e) {
			print("The error message is: " . $e->getMessage());
    // Check your source image and request options.
		} catch(\Tinify\ServerException $e) {
			print("The error message is: " . $e->getMessage());
    // Temporary issue with the Tinify API.
		} catch(\Tinify\ConnectionException $e) {
			print("The error message is: " . $e->getMessage());
    // A network connection error occurred.
		} catch(Exception $e) {
    // Something else went wrong, unrelated to the Tinify API.
			echo 'Exception $e<pre>';
			print_r($e);
			echo '</pre>';


			$param = array('e' => $e);

			$sendMail = $this->getDI()->getMail()->send(
			array(
				'juscelino.iene@gmail.com' => 'Juscelino' // destinatario
			),
			'Erro no Tiny.png', // assunto
			'tinypng', // template
			$param // array de parametros para ser usado no template
			);
		}



	}

	public function redirectSibsAction($url = null){
		$url = $_GET['url'];
		header('Location: https://checkout.lebillet.eu/' . $url);
		exit;
	}



}

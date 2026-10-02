<?php

use Phalcon\Mvc\Controller;

class OrderController extends Controller
{


    public function indexAction($id_order = null, $template = false)
    {

        $decrypt = $this->crypt->decryptBase64(base64_decode($id_order));


        $order = Orders::findFirst("id = '$decrypt'");


        if ($order and $order->id = $decrypt) {

            if ($order->id_orders_status != 2 && $order->id_orders_payment_status != 3 && $order->id_payment_type != 127) {
                $this->flash->error($this->t->_('Ingresso será liberado após o pagamento total da compra'));
                return $this->dispatcher->forward(array(
                    'controller' => 'helpdesk',
                    'action' => 'index'
                ));
            }

            $sql = "
				SELECT
					e.date_start,
					e.id
				FROM
				   sales_items as si
				INNER JOIN events as e ON si.id_event = e.id
				WHERE si.id_order = $order->id
			";
            $event = $this->db->fetchOne($sql);

            $data_inicio = new DateTime($event['date_start']);
            $data_fim = new DateTime();
            $dateInterval = $data_inicio->diff($data_fim);
            if ($dateInterval->days > 2) {
                /* $this->flash->error($this->t->_('Prezado(a) cliente,<br><br>

				Gostaríamos de informar que para garantir uma experiência segura e evitar falsificações e fraudes, os ingressos para o evento estarão disponíveis somente <b>48 horas</b> antes do início do mesmo. Essa medida foi adotada visando a proteção dos nossos clientes.<br><br>
				
				Para acessar seus ingressos, você poderá visualizá-los em sua conta no site da Lebillet ou através do link que foi enviado para você por e-mail, SMS. <br><br>
				
				Caso surja qualquer dúvida ou necessidade de assistência, nossa equipe estará pronta para ajudar. Basta entrar em contato conosco através do chat em nosso site, onde teremos o prazer de fornecer o suporte necessário. <br><br>
				
				Agradecemos pela compreensão e esperamos que você aproveite o evento ao máximo! '));
				return $this->dispatcher->forward(array(
					'controller' => 'helpdesk',
					'action' => 'index'
				)); */
            }

            if ($order->id_payment_type == 127 || $order->id_orders_payment_status == 9) {
                $this->view->order = $order;
                $sale = $order->Sales[0];
                if (isset($sale->Events->type_currency)) {
                    $type_currency = $sale->Events->type_currency;
                    $GLOBALS['type_currency'] = $type_currency;
                }

                if ($order->id_orders_payment_status == 1) {
                    $this->flash->error($this->t->_('O tempo limite para o pagamento passou, infelizmente não é possível acessar o pedido'));
                    return $this->dispatcher->forward(array(
                        'controller' => 'helpdesk',
                        'action' => 'index'
                    ));
                }
            } else {
                $this->urlFiles = $this->di->get('urlFiles');
                $this->view->urlFiles = $this->urlFiles;


                $a4 = false;
                if (isset($_REQUEST['a4'])) {
                    $a4 = true;
                }
                $this->view->order = $order;
                $this->view->a4 = $a4;

                $this->view->enable();
                if ($order->id_orders_status == 10) {
                    $this->view->pick("emailTemplates/facial-biometrics");
                } elseif ($template == true) {
                    $apiSend = $this->send_tickets_to_apiAction($decrypt);
                    $this->view->pick("emailTemplates/ingresso-aws");
                } else {
                    if (isset($_REQUEST['old'])) {
                        echo $decrypt;
                        $this->view->pick("emailTemplates/" . $this->config->company->template_email_order_confirmation);
                    } else {
                        //$this->view->pick("emailTemplates/" . $this->config->company->template_email_order_confirmation);
                        $apiSend = $this->send_tickets_to_apiAction($decrypt);
                        $this->view->pick("emailTemplates/ingresso-aws");
                    }
                }

                $this->view->setRenderLevel(
                    Phalcon\Mvc\View::LEVEL_ACTION_VIEW
                );
            }
        } else {
            // SE NÃO BATER O ID , já abre na página de contato
            $this->flash->error($this->t->_('Order not found'));
            return $this->dispatcher->forward(array(
                'controller' => 'helpdesk',
                'action' => 'index'
            ));
        }
    }



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


                if (isset($ticket->Events->label_date) and strlen($ticket->Events->label_date) > 2) {
                    $eventDateticket = $ticket->Events->label_date;
                    $eventTimeTicket =  ' ';
                } else {
                    $eventDateticket = $this->getDI()->getFormatdates()->format($ticket->Events->date_start, '25/Jan/2000');
                    $eventTimeTicket = $this->getDI()->getFormatdates()->format($event->date_start, '17:00h');
                }



                // Construir os dados do ingresso para enviar à API

                $productSLabel =  ($event->ticket_type == 2) ? str_replace(':', '-', $ticket->ProductsSeats->label) : $ticket->ProductsSeats->label;
                $ticketData = [
                    'id_event' => $ticket->id_event,
                    'id_ticket' => $ticket->ticket,
                    'eventName' => $event->name,
                    'venue' => $event->Places->name,
                    'location' => $event->Cities->name . ' - ' . $event->Regions->acronym,
                    'eventDate' => $eventDateticket,
                    'eventTime' => $eventTimeTicket,
                    'price' => number_format($ticket->value_product / $ticket->fraction, 2, '.', ''),
                    'ticketType' => '',
                    'ticket_type' => $event->ticket_type,
                    'productName' => $ticket->Products->name,
                    'productLabel' => ($ticket->id_product_seat > 1) ? $productSLabel : '',
                    'productGenre' => ($ticket->Products->id_genre > 1) ? $ticket->Products->ProductsGenres->name : '',
                    'productType' => ($ticket->id_product_type > 1) ? $ticket->ProductsTypes->name : '',
		    'companyLogoUrl' => 'https://imagens-publico.s3.us-east-1.amazonaws.com/logo_ticket.png',
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
                   // $ticketData['eventImageUrl'] = $this->config->application->completeUrl . 'img/shows/' . $event->logo;
		    $ticketData['eventImageUrl'] = 'https://lebillet.eu/' . 'img/shows/' . $event->logo;
                } else {
                    $ticketData['eventImageUrl'] = '';
                }




	//teste imagem de bilhete
	if($ticket->Products->id == 2132333333  ){
 		$ticketData['eventImageUrl'] = 'https://www.festivalcrato.pt/assets/img/bilhetes/passe%20geral.jpg.jpeg';
	}


	//Imagens personalizadas evento crato
        if($ticket->Products->id == 11022  ){
                $ticketData['eventImageUrl'] = 'https://www.festivalcrato.pt/assets/img/bilhetes/passe%20geral.jpg.jpeg';
        }

        if($ticket->Products->id == 11023  ){
                $ticketData['eventImageUrl'] = 'https://www.festivalcrato.pt/assets/img/bilhetes/passe%20geral%20com%20campismo.jpg.jpeg';
        }

        if($ticket->Products->id == 11024 ){
                $ticketData['eventImageUrl'] = 'https://www.festivalcrato.pt/assets/img/bilhetes/passe%20di%C3%A1rio%2026%401%2C5x.jpg.jpeg';
        }

        if($ticket->Products->id == 11025  ){
                $ticketData['eventImageUrl'] = 'https://www.festivalcrato.pt/assets/img/bilhetes/bilhete%20di%C3%A1rio%2027.jpg.jpeg';
        }




                $urlBil = 'https://sgy4bwtay6ezuj5f52nruok2mu0jhepd.lambda-url.us-east-1.on.aws/';

                if ($event->ticket_type == 3) {

                    if($event->id == "1665" or $event->id == "1"){
		       $ticketData['neo_arena'] = 1;
                    }
                    $urlBil = 'https://44lwlgjypb5bhhwc5rfpfxklbu0dusjq.lambda-url.us-east-1.on.aws/';
                }

                // Preparar e configurar requisição cURL
                $ch = curl_init();
                curl_setopt($ch, CURLOPT_URL, $urlBil);
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
}

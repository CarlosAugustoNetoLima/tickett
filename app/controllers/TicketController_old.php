<?php

class TicketController extends ControllerBase
{
	public function initialize()
	{
		$this->view->setRenderLevel(
			Phalcon\Mvc\View::LEVEL_ACTION_VIEW
		);
	}



	public function indexAction($hash = null)
	{
		$hash_decode = base64_decode($hash);

		// Listando todas as variáveis
		list($id_event, $id_ticket) = explode('#', $hash_decode);


		if ( $id_ticket AND $id_event ) {
			$ticket = SalesItems::findFirst(
				[
					"ticket = :id_ticket: AND id_event = :id_event: ",
					"bind" => [
						"id_ticket" => $id_ticket,
						"id_event" => $id_event
					]
				]
			);

			
			if ( $ticket AND $ticket->status == 1 ) {



				/* Verifica se tem o EXTRA DATA obrigatório para este ticket e se ele esta preenchido
				* Só mostra o eticket se os dados obrigatórios estiverem preenchidos
				*/
				$sql = "
					SELECT COUNT(1)  qty
					FROM events_extra_data
					WHERE id_event = '$ticket->id_event'
					AND (id_product IS NULL OR id_product = '$ticket->id_product' )
					AND (id_product_type IS NULL OR id_product_type = '$ticket->id_product_type' )
					-- AND (required_start IS NULL OR required_start >= NOW() )
					-- AND (required_end IS NULL OR required_end <= NOW() )
				    AND id_extra_data NOT IN
					    (SELECT
					        id_extra_data
					    FROM
					        ticket_extra_data
					    WHERE id_event = '$ticket->id_event'
					        AND ticket = '$ticket->ticket' )
					";
				$query_extra_data = $this->db->fetchOne($sql);
				$img_extra_data = false;
				if ( $query_extra_data['qty'] > 0 ) { // Possui dado extra que ainda não foi preenchido
					return $this->response->redirect('ticket/extra_data/' . $hash);

					$img_extra_data = true;
				}

				/* Fim - Verifica se tem EXTRA DATA */

				/* Gera o Ticket e exibe o PDF */
				// Pra salvar com algo legível
				$ticket_name = $id_event . '_' . $id_ticket;
				// Caminho para salvar o PDF
				//$path = BASE_PATH . "/public/tickets/{$hash}.pdf";
				// Caminho para salar a imagem
				$path = $this->di->get('pathSite') . "public/tickets/{$ticket_name}.png";
				$params = array(
					'wkhtmltopdf' => $this->config->application->wkhtmltopdf,
					'wkhtmltoimage' => $this->config->application->wkhtmltoimage,
					'url' => $this->config->application->completeUrl . 'ticket/slim/' . $hash,
					'path' => $path
				);

				// Isto é para gerar o PDF da versão A4, aquela folha grande com os dados do evento e do comprador
				if ( isset($_REQUEST['a4']) ) {
					$params['url'] = $this->config->application->completeUrl . 'ticket/show/' . $hash;
				}

				if ( isset($_REQUEST['debug_params']) ) {
					echo 'params<pre>';
					print_r($params);
					echo '</pre>';
					exit();
				}

				if ( $img_extra_data )
				{
					$path = $this->di->get('pathSite') . "public/img/check.png";

				} else if ( !file_exists($path) )
				{
					$generate = $this->generate( $params );

				}

				// Alguns tickets parece não gerar na primeira tentativa
				// Então tentei isto pra forçar novamente a geração do mesmo
				if ( !file_exists($path) )
				{
					//sleep(0.5);   Isto parece travar o servidor  e ai precisa reiniciar o PHP
					$generate = $this->generate( $params );
				}


				/* if($id_ticket == 7615683){
					echo 'params<pre>';
					var_dump($params);
					var_dump($generate);
					var_dump($path);
				} */

				if ( file_exists($path) )
				{
					
					//header("Content-Type: application/pdf");
					header("Content-Type: image/png");
					header("Content-Length: " . filesize($path));
					//header("Content-Disposition: inline; filename=" . $ticket->Events->name . " - " . $ticket->ticket . ".pdf");
					header("Content-Disposition: inline; filename=" . $ticket->Events->name . " - " . $ticket->ticket . ".png");
					readfile($path);
					exit();
					/* FIM - Gera o Ticket e exibe o PDF */
				} else {
					// Se não gerou o ticket, tenta novamente
					// E vai tentando até conseguir PORRA
					//return $this->response->redirect('ticket/' . $hash);
					//exit();


						if ( isset($_REQUEST['debugTicket']) ) {
							echo 'Não existe o arquivo';
							exit();
						}

				}


			} elseif ( $ticket->status <> 1) {

					//header("Content-Type: application/pdf");
					$path = $this->di->get('pathSite') . "/public/img/not_active.jpg";
					header("Content-Type: image/png");
					header("Content-Length: " . filesize($path));
					//header("Content-Disposition: inline; filename=" . $ticket->Events->name . " - " . $ticket->ticket . ".pdf");
					header("Content-Disposition: inline; filename=" . $ticket->Events->name . " - " . $ticket->ticket . ".png");
					readfile($path);
					exit();
			}



		} else {
			return 'Ticket Not Found';
		}



	}









	public function extra_dataAction($hash = null)
	{
		$hash_decode = base64_decode($hash);
		list($id_event, $id_ticket) = explode('#', $hash_decode);
		if ( $id_ticket AND $id_event ) {
			$ticket = SalesItems::findFirst(
				[
					"ticket = :id_ticket: AND id_event = :id_event: ",
					"bind" => [
						"id_ticket" => $id_ticket,
						"id_event" => $id_event
					]
				]
			);
			if ( $ticket ) {



				/* Se for um POST pode estar salvando os dados */
				if ( $this->request->isPost() ) {
					 $extra_data    = $this->request->getPost("extra_data");

					 /* Percorre cada dado extra postado */
				 	foreach ( $extra_data as $key => $value )
				 	{
				 		$value = trim(strip_tags($value));
				 		if ( strlen($value) > 0 )
				 		{
							$sql = "
								REPLACE INTO ticket_extra_data (
								    id_event,
								    ticket,
								    id_extra_data,
								    value
								)
								VALUES
								    (?, ?, ?, ?)
								";
								/* Salva cada dado extra */
							$this->db->execute($sql, array($id_event, $id_ticket, $key, trim($value) )  );
				 		}
				 	}

				 	/* Redireciona pra pagina inicial - Que irá verificar se esta tudo preenchido e mostrar o PDF */
				 	return $this->response->redirect('ticket/' . $hash);
				}




				$this->view->ticket = $ticket;

				$phql = "
					SELECT eed.*
					FROM EventsExtraData eed
					WHERE eed.id_event = '$ticket->id_event'
					AND (eed.id_product IS NULL OR eed.id_product = '$ticket->id_product' )
					AND (eed.id_product_type IS NULL OR eed.id_product_type = '$ticket->id_product_type' )
					";
				$EventsExtraData = $this->modelsManager->executeQuery( $phql );
				$this->view->EventsExtraData = $EventsExtraData;
			} else {
				return 'Ticket Not Found';
			}

		}
	}





















	public function generate($params)
	{
		$path = $params['path'];
		$url = $params['url'];
		$wkhtmltopdf = $params['wkhtmltopdf'];
		$wkhtmltoimage = $params['wkhtmltoimage'];

		// PDF
		// $command_exec =  $wkhtmltopdf . ' ' . $url . ' "' . $path . '" ';

		// IMAGEM
		$command_exec =   $wkhtmltoimage . ' --width 350 --quality 50 ' . $url . ' "' . $path . '" ';


		// Vai executar a IMAGEM, mas depois pode ser utilizado pra gerar o PDF tbm
		$return = exec($command_exec, $output, $return_var);

		return $return;
	}





	public function showAction($hash )
	{
		$hash = base64_decode($hash);

		// Listando todas as variáveis
		list($id_event, $id_ticket) = explode('#', $hash);


		if ( $id_ticket AND $id_event ) {
			$ticket = SalesItems::findFirst(
				[
					"ticket = :id_ticket: AND id_event = :id_event: ",
					"bind" => [
						"id_ticket" => $id_ticket,
						"id_event" => $id_event
					]
				]
			);
			$this->view->ticket = $ticket;

			$this->view->barCode = null;
			if(isset($ticket->code_ean)){
				$generator = new Picqer\Barcode\BarcodeGeneratorHTML();
				$barCode = $generator->getBarcode($ticket->code_ean, $generator::TYPE_CODE_128, 2);
				$this->view->barCode = $barCode;
			}

		}
	}







	public function slimAction($hash )
	{
		$hash = base64_decode($hash);

		// Listando todas as variáveis
		list($id_event, $id_ticket) = explode('#', $hash);


		if ( $id_ticket AND $id_event ) {
			$ticket = SalesItems::findFirst(
				[
					"ticket = :id_ticket: AND id_event = :id_event: ",
					"bind" => [
						"id_ticket" => $id_ticket,
						"id_event" => $id_event
					]
				]
			);
			$this->view->product = $ticket;
		}
	}






}







// ISTO FAZ PEGAR O CONTEÚDO HTML E SALVAR NUMA VARIAVEL
// Foi dificil conseguir, entao estou salvando aqui pra usar mais tarde
//$this->view->disable();
/*
$view = clone $this->view;
$view->start();
$view->setRenderLevel(Phalcon\Mvc\View::LEVEL_ACTION_VIEW);
$view->render('ticket', 'index');
$view->finish();
$content = $view->getContent();
*/


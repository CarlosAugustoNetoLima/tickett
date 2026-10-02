<?php

class AccountController extends ControllerBase
{

	private $customer = null;


	/**
	 * Inicializa o Controller
	 * Valida se o usuário esta logado  (rediciona pro login se for preciso)
	 * Também trata o layout do controller
	 */
	public function initialize()
	{
		$title = $this->config->company->name . ' | ' . $this->t->_('account');
		$this->view->metaTitle = $title;
		$this->view->metaDescription = $title;


		// echo '$this->dispatcher->getActionName()<pre>';
		// print_r($this->dispatcher->getActionName());
		// echo '</pre>';

		if (!$this->IS_API) {
			$customer = $this->session->get('customer');
			if ($customer) {
				$this->customer = $customer;
				/*  Como tem o arquivo "/view/layouts/account.volt", por padrão assume ele como layout deste CONTROLLER
				Mas vou deixar o script aqui, para mais tarde servir como consulta, pois pode ser útil em outro momento
				$this->view->setRenderLevel(
					//View::LEVEL_ACTION_VIEW /views/account/index.volt
					//View::LEVEL_LAYOUT  /views/layouts/account.volt
					//View::LEVEL_MAIN_LAYOUT  /views/index.volt
				);
				*/
			} else {
				// Isto é pra desabilitar layouts/account.volt (senao fica aparecendo o menu lateral na pagina de login)
				$this->view->disableLevel(
					[
						Phalcon\Mvc\View::LEVEL_LAYOUT      => true
					]
				);

				$action = $this->dispatcher->getActionName();
				if (!in_array($action, array('login', 'register', 'remember_password', 'payment_error', 'payment_pending'))) {
					return $this->response->redirect('account/login');
				}
			}
			$this->view->customer = $customer;
		}
	}


	public function payment_errorAction() {}
	public function payment_pendingAction() {}

	public function indexAction()
	{

		if (isset($this->customer->id)) {

			$orders = Orders::find(
				[
					"id_customer = :id_customer: AND id_orders_payment_status <> 7 ",
					"bind" => [
						"id_customer" => $this->customer->id
					],
					"order" => 'id DESC',
					"limit" => 10
				]
			);
			$this->view->orders = $orders;
		} else {
			return $this->response->redirect('account/login');
		}
	}



	public function getAddressAction()
	{
		$this->view->disable();
		$this->response->setContentType('application/json', 'UTF-8'); // Isto faz retornar um JSON

		$msg['status'] = 'error';
		$zip    = $this->request->getPost('zip');
		if (strlen($zip) > 4) {
			$ZipCode = new ZipCodeClass();
			$getAddress = $ZipCode->getAddress($zip);
			if (count($getAddress) > 0) {
				$msg['status'] = 'success';
				$msg['result'] = $getAddress[0];
			} else {
				$msg['status'] = 'not_found';
				$msg['msg'] = $this->t->_('Zip Code not found. Complete the address');
			}
		} else {
			$msg['msg'] = $this->t->_('Inform the Zip Code');
		}
		return json_encode($msg);
	}




	public function ordersAction()
	{

		if (isset($this->customer->id)) {

			$orders = Orders::find(
				[
					"id_customer = :id_customer: ",
					"bind" => [
						"id_customer" => $this->customer->id
					],
					"order" => 'id DESC'
				]
			);
			$this->view->orders = $orders;
		} else {
			return $this->response->redirect('account/login');
		}
	}


	public function orderAction($id_order = null, $msg = null)
	{
		
		if(isset($msg)){
			$this->flashSession->success($this->t->_('Compra finalizada com sucesso !'));

			$url = $this->di->get('urlCheckout') . 'payment/paymentMyposActiveOrder/' . $id_order;
			//$commandExec = "wget ". $url . "  > /dev/null &";
    		//$exec = exec($commandExec);

			$curl = curl_init();

			curl_setopt_array($curl, array(
			CURLOPT_URL => $url,
			CURLOPT_RETURNTRANSFER => true,
			CURLOPT_ENCODING => '',
			CURLOPT_MAXREDIRS => 10,
			CURLOPT_TIMEOUT => 0,
			CURLOPT_FOLLOWLOCATION => true,
			CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
			CURLOPT_CUSTOMREQUEST => 'GET',
			));

			$response = curl_exec($curl);
			curl_close($curl);
		}

		if (isset($this->customer->id)) {
			// tem usuario logado, senão redireciona pro login
		} else {
			return $this->response->redirect('account/login');
		}


		$customer_name  = $this->request->getPost('name');
		$idSalesItems  = $this->request->getPost('idSalesItems');

		if ($customer_name and strlen($customer_name) > 0 && $idSalesItems and strlen($idSalesItems) > 5) {
			$salesItems = SalesItems::findFirst('id = ' . $idSalesItems);
			$salesItems->customer_name = $customer_name;
			$salesItems->ticket = $this->ticketGenerate($salesItems->id_event, $salesItems->id_product, $salesItems->id_product_type, true, false) ;;
			$salesItems->save();
			$this->flashSession->success($this->t->_('Nome alterado com sucesso'));
		}


		$id_sale  = $this->request->getPost('sale');
		if ($id_sale and strlen($id_sale) > 5) {

			$id_sale = $this->crypt->decryptBase64(base64_decode($id_sale));
			if ($id_sale) {
				$sale = Sales::findFirst(array("id = $id_sale"));

				if ($sale and $sale->id == $id_sale) {

					$event = $sale->Events;

					//  os dados de configuração do CANCELAMENTO
					$cancellation = json_decode($event->cancellation, true);
					$cancellation['days_after_purchase'] = isset($cancellation['days_after_purchase']) ? $cancellation['days_after_purchase'] : 7;
					$cancellation['days_before_event'] = isset($cancellation['days_before_event']) ? $cancellation['days_before_event'] : 2;
					$cancellation['type'] = isset($cancellation['type']) ? $cancellation['type'] : 1;

					if (isset($cancellation['able']) and $cancellation['able']) {

						$now = date('Y-m-d H:i:s');

						$str = strtotime($now) - strtotime($sale->created_at);
						$days_purchase = floor($str / 3600 / 24);

						$str = strtotime($event->date_start) - strtotime($now);
						$days_event = floor($str / 3600 / 24);

						if ($days_purchase <= $cancellation['days_after_purchase']  and  $days_event >= $cancellation['days_before_event']) {

							// PICPAY nao faz estorno parcial - por isso muda pra INTEGRAL
							if ($sale->id_payment_type == 20) {
								$cancellation['type'] = 4;
							}


							// Compras com até 7 dias, cancelamento total sem reter taxa
							// Isto por causa da regra do CDC de poder cancelar com 7 dias sem custos
							if ($days_purchase < 7) {
								$cancellation['type'] = 4;
							}


							$cancel_value = $sale->value_product + $sale->value_interest +  $sale->value_interest_tax - $sale->value_discount;

							if ($cancellation['type'] == '1') { /* Somente Produto */
								// cancela o valor do produto e dos juros

							} elseif ($cancellation['type'] == '2') { /* Produto + Taxa */
								$cancel_value += $sale->value_product_tax  + $sale->value_fee  + $sale->value_fee_tax  + $sale->value_fee_org  + $sale->value_fee_org_tax;
							} elseif ($cancellation['type'] == '3') { /* Produto + Entrega */
								$cancel_value +=  $sale->value_delivery +  $sale->value_delivery_tax;
							} elseif ($cancellation['type'] == '4') { /* TOTAL - Produto + Taxa + Entrega */
								$cancel_value = $sale->value_total;
							}

							$sale_cancellation = new SalesCancellation();
							$sale_cancellation->id_event = $event->id;
							$sale_cancellation->id_sale = $id_sale;
							$sale_cancellation->canceled_value = $cancel_value;
							$sale_cancellation->type = $cancellation['type'];
							$sale_cancellation->status = 1;
							$sale_cancellation->created_at = $now;
							if ($sale_cancellation->save()) {

								$sql_tmp = " UPDATE sales s SET s.status = 7 WHERE s.id = '$id_sale' ";
								$this->db->execute($sql_tmp);

								$sql_tmp = " UPDATE sales_items si SET si.status = 2 WHERE si.id_sale = '$id_sale'  ";
								$this->db->execute($sql_tmp);


								/* LOG no TICKET */
								$sql_tmp = "
									INSERT INTO ticket_log (id_event, ticket, status, info, created_at)
									SELECT si.id_event, si.ticket, '2', 'Cancelado pelo cliente', '$now' FROM sales_items si WHERE si.id_sale = '$id_sale' ;";
								$this->db->execute($sql_tmp);


								$this->flashSession->success($this->t->_('Cancellation request received.<br>We will notify you when the process is complete, this may take up to 2 business days.'));



								// Já dispara uma REQUEST pra processa o estorno na hora
								$url = $this->di->get('urlSup') . 'cron_orders/cancel_sales/' . $id_sale;
								$commandExec = "wget " . $url . "  > /dev/null &";
								$exec = exec($commandExec);




								return $this->response->redirect('account/order/' . $id_order);
							} else {
								foreach ($sale_cancellation->getMessages() as $message) {
									$this->flashSession->error($message);
								}
							}
						} else {
							$this->flashSession->error('Error while canceling');
						}
					} // if ( isset($cancellation['able']) AND $cancellation['able'] )

				} else { // if ( $sale AND $sale->id == $id_sale )
					$this->flashSession->error('Order not found');
				}
			} else { // if ( $id_sale )
				$this->flashSession->error('Order not found');
			}
		} // if ( $id_sale AND strlen($id_sale) > 5 )



		$CartLib = new CartLib();
		$order = $CartLib->getOrder($id_order, $this->customer->id);
		//public function getOrder($id_order = null, $id_user = null)


		if ($order) {
			$this->view->order = $order;
		} else {
			$this->flashSession->error('Order not found');
			return $this->dispatcher->forward(array(
				"controller" => "account",
				"action" => "orders"
			));
		}
	}





	public function profileAction()
	{

		if ($this->request->isPost()) {
			if (isset($this->customer->id)) {
				// tem usuario logado, senão redireciona pro login
			} else {
				return $this->response->redirect('account/login');
			}



			$customer = Customers::findFirst($this->customer->id);


			$save_profile    = $this->request->getPost('save_profile');
			if ($save_profile) {
				$name = trim($this->request->getPost('name'));
				$email = trim($this->request->getPost('email', 'email'));
				$mobile_country = trim($this->request->getPost('mobile_country'));
				$cell_number = trim($this->request->getPost('cell_number'));

				$id_number = trim($this->request->getPost('id_number'));
				$zipcode = trim($this->request->getPost('zipcode'));

				$name = trim(strip_tags($name));
				$email = trim(strip_tags($email));
				$id_number = trim(strip_tags($id_number));
				$mobile_country = trim(strip_tags($mobile_country));
				$cell_number = trim(strip_tags($cell_number));
				$zipcode = trim(strip_tags($zipcode));

				if ($name and $email  and $cell_number  and $id_number  and $zipcode and $mobile_country) {



					if (filter_var($email, FILTER_VALIDATE_EMAIL)) {
						$ja_existe = Customers::findFirstByEmail($email);
						if ($ja_existe and $ja_existe->id <> $customer->id) {
							$this->flashSession->error($this->t->_('Email already in use'));
						} else {

							$customer->name = $name;
							$customer->email = $email;
							$customer->cell_number = '+' . $mobile_country . ' ' . $cell_number;
							$customer->zipcode = $zipcode;

							if (strlen($id_number) > 2) {
								$customer->id_number = $id_number;
							}

							$city  = $this->request->getPost('city');
							$city = trim(strip_tags($city));
							if (strlen($city) > 1) {
								$customer->city = $city;
							}
							$region    = $this->request->getPost('region');
							$region = trim(strip_tags($region));
							if (strlen($region) > 1) {
								$customer->region = $region;
							}
							$country    = $this->request->getPost('country');
							$country = trim(strip_tags($country));
							if (strlen($country) > 1) {
								$customer->country = $country;
							}

							$address_1    = $this->request->getPost('address_1');
							$address_1 = trim(strip_tags($address_1));
							if (strlen($address_1) > 1) {
								$customer->address_1 = $address_1;
							}

							if (!$customer->save()) {
								foreach ($customer->getMessages() as $message) {
									$this->flashSession->error($message);
								}
							} else {
								$this->flashSession->success($this->t->_('Successfully changed registration'));
								$this->session->set("customer", $customer);
								$this->customer = $customer;
							}
						}
					} else {
						$this->flashSession->error($this->t->_('Invalid email'));
					}
				} else {
					$this->flashSession->error($this->t->_('All fields are required'));
				}
			}




			$save_password    = $this->request->getPost('save_password');
			if ($save_password) {
				$password    = $this->request->getPost("password");
				$newPassowrd    = $this->request->getPost("newPassowrd");
				$password = trim(strip_tags($password));
				$newPassowrd = trim(strip_tags($newPassowrd));

				if ($password and $newPassowrd) {
					if ($customer->password == $password) {
						$customer->password = $newPassowrd;
						if (!$customer->save()) {
							foreach ($customer->getMessages() as $message) {
								$this->flashSession->error($message);
							}
						} else {
							$this->flashSession->success($this->t->_('Password changed successfully'));
							$this->session->set("customer", $customer);
							$this->customer = $customer;
						}
					} else {
						$this->flashSession->error($this->t->_('Current password is incorrect'));
					}
				} else {
					$this->flashSession->error($this->t->_('All fields are required'));
				}
			}
		} // if ($this->request->isPost())

		$customer = Customers::findFirst($this->customer->id);
		$arrayNumber = explode("#", $customer->cell_number);
		$customer->mobile_country = '';

		if (sizeof($arrayNumber) > 1) {

			$customer->mobile_country = $arrayNumber[0];
			$customer->cell_number = $arrayNumber[1];
		}

		$this->view->customer = $customer;
	}

	/**
	Lógica para gerar o numero do ingresso
	*/
	public function ticketGenerate($id_event = 0, $id_product = 0, $id_type = 0, $check_stock = true, $is_migrator = false)
	{
		// Verifica se tem estoque pra este produto
		if ( $check_stock ) {
			$filter_type = ' AND id_product_type IS NULL';
			// Para o tipo definido, ou tipo genérico (NULL)
			if ( $id_type > 0 ) {
				$filter_type = " AND (id_product_type = $id_type OR  id_product_type IS NULL ) ORDER BY id_product_type DESC ";
			}
			$sql = " SELECT ticket FROM ticket_stock WHERE status = '0' AND id_event = $id_event AND id_product = $id_product  $filter_type LIMIT 1 ";
			$result_stock = $this->db->fetchOne($sql);
		} else {
			$result_stock = false;
		}

		if ( $result_stock ) {
			$ticket = $result_stock['ticket'];

			// Remove o estoque depois de utiliza-lo
			$sql = " DELETE FROM ticket_stock WHERE id_event = $id_event AND ticket = '$ticket' AND status = '0' LIMIT 1 ";
			$this->db->execute($sql);

		} else {
			// Não achou no stock, vai gerar um novo código
			// Vendas do SITE, começam com 7...9
			// Se for passaporte vai começar com 1

			$caracteres0 = "789";
			$caracteres1 = "0123456789";

			// caso já tenha verificado se é migrador antes, muda a inicial do ticket pra nao dar conflito
			if ( $is_migrator ) {
				$caracteres0 = '1';
			}


			$ticket =  substr(str_shuffle($caracteres0),0,1) . str_shuffle(substr(str_shuffle($caracteres1),0,3)) . str_shuffle(substr(str_shuffle($caracteres1),0,3)) ;

			/** CHECA SE O NUMERO JÁ EXISTE PARA O EVENTO */
			$sql = " SELECT COUNT(1) qty FROM sales_items WHERE id_event = $id_event AND ticket = '$ticket' LIMIT 1 ";
			$result = $this->db->fetchOne($sql);
			if ( $result['qty'] > 0 ) {
				return $this->ticketGenerate($id_event, $id_product, $id_type, false, $is_migrator);
			}
		}


		return $ticket;
	}
	




	public function wishlistAction() {}






	public function supportAction()
	{

		if ($this->request->isPost()) {

			$subject = $this->request->getPost('subject');
			$message = $this->request->getPost('message');

			if ($subject and $message) {
				$helpdesk = new HelpdeskOpening();
				$helpdesk->name = $this->customer->name;
				$helpdesk->email = $this->customer->email;
				$helpdesk->subject = $subject;
				$helpdesk->created_at = date('Y-m-d H:i:s');

				if (!$helpdesk->save()) {
					foreach ($helpdesk->getMessages() as $message) {
						$this->flashSession->error($message);
					}

					return $this->dispatcher->forward(array(
						'controller' => 'account',
						'action'	=> 'helpdesk',
					));
				} else {
					$helpdeskAnswers = new HelpdeskAnswers();
					$helpdeskAnswers->id_helpdesk = $helpdesk->id;
					$helpdeskAnswers->author = $helpdesk->name;
					$helpdeskAnswers->message = $message;
					$helpdeskAnswers->ip = $this->request->getClientAddress();
					$helpdeskAnswers->session = session_id();
					$helpdeskAnswers->agent = $this->request->getUserAgent();
					$helpdeskAnswers->created_at = date('Y-m-d H:i:s');
					if (!$helpdeskAnswers->save()) {
						foreach ($helpdeskAnswers->getMessages() as $message) {
							$this->flashSession->error($message);
						}
					} else {

						// Envia uma requisição para a rota a seguir
						// Lá vai validar qual ADMIN  quer receber uma notificação da atendimento
						$url = $this->di->get('urlSup') . 'pushnotifications/helpdesk/' . $helpdesk->id;
						$commandExec = "wget " . $url . "  > /dev/null &";
						$exec = exec($commandExec);
					}
				}
			} else // if ( $name AND $email AND $message )
			{
				$this->flashSession->error($this->t->_('subject_and_message_required'));
			}
		}


		$helpdesks = HelpdeskOpening::find(
			[
				"email = :email: ",
				"bind" => [
					"email" => $this->customer->email
				],
				"order" => 'id DESC'
			]
		);
		$this->view->helpdesks = $helpdesks;
	}



	public function helpdeskAction($id = null)
	{
		if (isset($this->customer->email) and $this->customer->email  and $id) {
			$helpdesk = HelpdeskOpening::findFirst(
				[
					"id = :number: AND email = :email: ",
					"bind" => [
						"number" => $id,
						"email" => $this->customer->email
					]
				]
			);
		} else {
			$helpdesk = null;
		}


		// Confere se o HELPDESK na session é o mesmo ID da URL, ai continua
		if ($helpdesk) {

			if ($this->request->isPost()) {
				$message = $this->request->getPost('message');
				if ($message and  $helpdesk and $helpdesk->id == $id) {
					$helpdeskAnswers = new HelpdeskAnswers();
					$helpdeskAnswers->id_helpdesk = $helpdesk->id;
					$helpdeskAnswers->author = $helpdesk->name;
					$helpdeskAnswers->message = $message;
					$helpdeskAnswers->ip = $this->request->getClientAddress();
					$helpdeskAnswers->session = session_id();
					$helpdeskAnswers->agent = $this->request->getUserAgent();
					$helpdeskAnswers->created_at = date('Y-m-d H:i:s');
					if (!$helpdeskAnswers->save()) {
						foreach ($helpdeskAnswers->getMessages() as $message) {
							$this->flashSession->error($message);
						}
					} else {
						$this->flashSession->success($this->t->_('we_received_your_message'));

						$helpdesk->status = 0; // 0 Novo | 1 Lido | 2 Respondido | 3 Finalizado
						$helpdesk->save();
					}
				} else {
					$this->flashSession->error($this->t->_('required_message'));
				}
			}
			$this->view->helpdesk = $helpdesk;
			//$this->view->pick("helpdesk/view");

		} else {
			$this->flashSession->error($this->t->_('helpdesk_not_found'));
			return $this->dispatcher->forward(array(
				'controller' => 'account',
				'action' => 'support'
			));
		}
	}

	public function verifyAction()
	{
		//ALTER TABLE `customers` ADD COLUMN `verify` TINYINT(1) NULL DEFAULT '0' COMMENT '0-Liberado | 1-Pendente | 2-Validação | 3-Validado | 4-Reprovado ' AFTER `country`;

		// Isto para sempre trazer o perfil atualizado
		// As vezes estava logado, fez a compra, mudou pra ANALISAR e nao muda na SESSION
		if (isset($this->customer->id)) {
			$customer = Customers::findFirst($this->customer->id);
			$this->session->set("customer", $customer);
			$this->view->customer = $customer;
		} else {
			return $this->response->redirect('account/login');
		}

		$id_customer = $this->customer->id;

		$sql = "
		SELECT
			    COUNT(1) qty
			FROM
			    sales_items si
			    INNER JOIN sales s
			        ON s.id = si.id_sale
			    INNER JOIN orders o
			        ON o.id = s.id_order
			WHERE si.status = 1
			    AND o.id_orders_status = 10
			    AND o.id_customer = $id_customer
		 ";
		$results = $this->db->fetchOne($sql);
		if ($results['qty'] > 0) {
			// Tem algum ingresso ativo e pendente de ativação
		} else {
			// Não tem nenhuma compra pendente de ativação
			$this->flashSession->notice("No momento você não possui compra pendente de ativação.");
			return $this->response->redirect('account');
		}



		if ($this->request->isPost()) {
			if ($this->request->hasFiles() == true) {

				// Cria o chamado para validação do cadastro
				$customer_name = $customer->name;
				$customer_email = $customer->email;
				$helpdesk = new HelpdeskOpening();
				$helpdesk->name = $customer_name;
				$helpdesk->email = $customer_email;
				$helpdesk->subject = "Ativação cadastro - Biometria facial";
				$helpdesk->created_at = date('Y-m-d H:i:s');
				$helpdesk->save();

				$helpdeskAnswers = new HelpdeskAnswers();
				$helpdeskAnswers->id_helpdesk = $helpdesk->id;
				$helpdeskAnswers->author = $helpdesk->name;
				$helpdeskAnswers->message = "Segue os dados para ativação desta compra.";
				$helpdeskAnswers->ip = $this->request->getClientAddress();
				$helpdeskAnswers->session = session_id();
				$helpdeskAnswers->agent = $this->request->getUserAgent();
				$helpdeskAnswers->created_at = date('Y-m-d H:i:s');
				$helpdeskAnswers->save();



				$time = 0;
				$files_upload = $this->request->getUploadedFiles();
				foreach ($files_upload as $key => $file_upload) {
					$file_extension = $file_upload->getExtension();
					if ($file_extension) {

						$path_site = $this->di->get('pathSite');   // o caminho absoluto pra pasta
						$file_name = $customer->id . '_' . $time . '_' .  time() . '.' . $file_extension;  // o nome da imagem, concatena o ID do usuario com um unique
						$path = $path_site . 'public/files_verify/' . $file_name;  // o local pra salvar a imagem

						$newFile = new CustomersVerify();
						$newFile->id_customer = $customer->id;
						$newFile->id_helpdesk = $helpdesk->id;
						$newFile->name = $file_name;
						$newFile->save();

						// isto faz o upload do arquivo
						if ($file_upload->moveTo($path)) {
							// Dispara uma requisição pra CRON otimizar a nova imagem - FODÁSTICO
							$url = $this->url->get() . 'cron/tinify/' . base64_encode($path);
							$commandExec = "wget " . $url . "  > /dev/null &";
							//$commandExec = file_get_contents($url);
							$exec = exec($commandExec);
						}
						$time++;
					}
				}

				$customer->verify = 2;
				$customer->save();
				$this->session->set("customer", $customer);



				// Envia uma requisição para a rota a seguir
				// Lá vai validar qual ADMIN  quer receber uma notificação da atendimento
				$url = $this->di->get('urlSup') . 'pushnotifications/helpdesk/' . $helpdesk->id;
				$commandExec = "wget " . $url . "  > /dev/null &";
				$exec = exec($commandExec);



				$this->flashSession->success("Solicitação de validação enviada com sucesso!");
				return $this->response->redirect('account/verify');
			}
		}
	}




























	/**
	 *  *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* LOGIN - LOGOUT E REGISTER  *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	 */

	public function logoutAction()
	{
		// Remove a session variable
		$this->session->remove("customer");

		// Destroy the whole session
		//$this->session->destroy();  // Isto aqui tbm limpa o carrinho que ta na seção

		return $this->response->redirect('');
	}



	public function remember_passwordAction()
	{
		$email = $this->request->getPost('email', 'email');
		$captcha = $this->request->getPost('captcha');
		$crypt = $this->request->getPost('crypt');
		$decrypt = $this->crypt->decryptBase64(base64_decode($crypt));



		if ($captcha == $decrypt) {

			$customer = Customers::findFirstByEmail($email);

			if ($customer) {
				$param = array('customer' => $customer);

				//function send($to, $subject, $template, $params)
				$sendMail = $this->getDI()->getMail()->send(
					array(
						$email => $customer->name
					),
					$this->config->company->full_name . ' | Senha de acesso', // assunto
					'password-recovery', // template
					$param
				);

				if ($sendMail)
					$this->flashSession->success('Senha enviada para o seu email');
				else
					$this->flashSession->error('Erro: ' . print_r($sendMail));
			} else {
				$this->flashSession->error('Email não encontrado');
			}
		} else {
			$this->flashSession->error('Responda corretamente a pergunta de verificação');
		}

		return $this->response->redirect('account/login');
	}


	public function registerAction()
	{

		if ($this->request->isPost()) {
			$nome    = trim($this->request->getPost('name'));
			$email    = trim($this->request->getPost('email'));
			$password = trim($this->request->getPost('password'));
			$cpf = trim($this->request->getPost('cpf'));

			$captcha = $this->request->getPost('captcha');
			$crypt = $this->request->getPost('crypt');
			$decrypt = $this->crypt->decryptBase64(base64_decode($crypt));

			$mobile_country = trim($this->request->getPost('mobile_country'));
			$cell_number = trim($this->request->getPost('cell_number'));

			$zipcode = trim($this->request->getPost('zipcode'));
			$country    = $this->request->getPost('country');
			$birth_date    = $this->request->getPost('birth_date');
			$birth_date = str_replace("/", "", $birth_date);

			$nome = trim(strip_tags($nome));
			$email = trim(strip_tags($email));
			$password = trim(strip_tags($password));
			$cpf = trim(strip_tags($cpf));
			$mobile_country = trim(strip_tags($mobile_country));
			$cell_number = trim(strip_tags($cell_number));
			$zipcode = trim(strip_tags($zipcode));
			$country = trim(strip_tags($country));
			$birth_date = trim(strip_tags($birth_date));


			//if ( $captcha == $decrypt )
			//{


			$cpf_ok = true;
			// no LeBillet o CPF é Obrigatório no cadastro
			if (null !== COMPANY and COMPANY == 'lebillet') {
				if ($this->validaCPF($cpf)) {
				} else {
					$cpf_ok = false;
					$this->flashSession->error($this->t->_('Informe o CPF corretamente'));
				}
			}



			if ($nome and $email and $password and $cpf_ok) {
				$customer = Customers::findFirstByEmail($email);
				if ($customer) {
					$this->flashSession->error("O email <b>$email</b> já esta sendo utilizado");
				} else {
					$customer = new Customers();
					$customer->name = $nome;
					$customer->email = $email;
					$customer->cell_number = $mobile_country . $cell_number;

					if ($cpf_ok and $cpf) {
						$customer->id_number = $cpf;
					}

					$customer->password = $password;
					$customer->created_at = date('Y-m-d H:i:s');
					$customer->save();

					if (!$customer->save()) {
						foreach ($customer->getMessages() as $message) {
							$this->flashSession->error($message);
						}
					} else {
						$this->flashSession->success("Cadastro efetuado com sucesso. Bem vindo!");
						$this->session->set("customer", $customer);

						//return $this->response->redirect('account/profile');
						return $this->response->redirect('/');
					}
				} // if ( $customer ) ELSE
			} // if ( $nome AND $email AND $password )
			else {
				$this->flashSession->error("Nome, email e senha são necessários para o cadastro");
			}
			//} else {
			//	$this->flashSession->error('Responda corretamente a pergunta de verificação');
			//}


		}


		return $this->response->redirect('account/login');
	}

	public function loginAction()
	{

		// Vai forçar a autenticação direto
		if (isset($_REQUEST['t'])) {
			$token = $_REQUEST['t'];
			$decrypt = $this->crypt->decryptBase64(base64_decode($token));
			$decrypt = explode('##', $decrypt);
			$id_customer = $decrypt[0];
			$email_customer = $decrypt[1];

			$customer = Customers::findFirst(" id = '$id_customer' AND email = '$email_customer' ");
			if ($customer) {
				// Dupla checagem de segurança - só pra garantir que os dados estão corretos
				if ($customer->id == $id_customer and $customer->email = $email_customer) {
					$this->session->set("customer", $customer);
					if (isset($_REQUEST['u'])) {
						$url = $_REQUEST['u'];
						$decrypt = $this->crypt->decryptBase64(base64_decode($url));
						return $this->response->redirect($decrypt);
					}
					return $this->response->redirect('account');
				}
			}
		}


		if ($this->request->isPost()) {
			$email    = $this->request->getPost('email');
			$password = $this->request->getPost('password');
			$helpdesk = $this->request->getPost('helpdesk');

			$customerLib = new CustomerLib();
			$customer = $customerLib->login($email, $password);

			if (!$customer) {
				return $this->flashSession->error("Login ou senha incorretos");
			}

			$this->session->set("customer", $customer);
			// $this->setSessionToCart($customer->id);

			if ($helpdesk == '1') {
				return $this->response->redirect('helpdesk');
			} else {
				return $this->response->redirect('account');
			}
		}
	}

	private function setSessionToCart($customerId)
	{
		// Verificar se tem um CART pra esta SESSION - Isto pra setar o ID do customer no carrinho
		$cart = $this->session->get('cart');
		if ($cart) {
			//$sql = "UPDATE cart SET id_customer = '" . $customer->id . "' WHERE customer_session = '" . session_id() . "' AND id_customer = '0' ";
			//  Mudei a regra, pq vai que o cara loga com outro usuario para terminar a compra? TODOOOOOO
			$sql = "UPDATE cart SET id_customer = '" . $customerId . "' WHERE customer_session = '" . session_id() . "'  ";
			// $this->db->execute($sql); // NUNCA USOU ISSO HAHAHH
		}
	}

	/**
	 *  *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* LOGIN - LOGOUT E REGISTER  *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	 */










	function validaCPF($cpf)
	{
		// Extrair somente os números
		$cpf = preg_replace('/[^0-9]/', '', (string) $cpf);

		// Verifica se foi informado todos os digitos corretamente
		if (strlen($cpf) != 11) {
			return false;
		}
		// Verifica se foi informada uma sequência de digitos repetidos. Ex: 111.111.111-11
		if (preg_match('/(\d)\1{10}/', $cpf)) {
			return false;
		}
		// Faz o calculo para validar o CPF
		for ($t = 9; $t < 11; $t++) {
			for ($d = 0, $c = 0; $c < $t; $c++) {
				$d += $cpf{
				$c} * (($t + 1) - $c);
			}
			$d = ((10 * $d) % 11) % 10;
			if ($cpf{
			$c} != $d) {
				return false;
			}
		}
		return true;
	}
}

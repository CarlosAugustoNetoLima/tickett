<?php
class SalesController extends ControllerBase
{
	private $CartLib;
	private $cart;
	private $seller = null;
	private $urlSales = null;
	private $urlCheckout = null;
	private $urlFastCheckout = null;

	public function initialize() {

		$this->urlSales = $this->di->get('urlSales');
		$this->urlCheckout = $this->di->get('urlCheckout');
		$this->urlFastCheckout = $this->di->get('urlFastCheckout');
		$this->view->urlSales  = $this->urlSales;
		$this->view->urlCheckout  = $this->urlCheckout;
		$this->view->urlFastCheckout  = $this->urlFastCheckout;
		$this->view->di  = $this->di;

		$this->view->setRenderLevel(
			Phalcon\Mvc\View::LEVEL_LAYOUT
		);

		$seller = $this->session->get('seller');
		if ( !$seller )
		{
			// Se nao tiver logado, muda o layout para aparecer só a página de login
			$this->view->setLayout('sales-login');

			if (  $this->dispatcher->getActionName() != 'login')
			{
				return $this->response->redirect($this->di->get('urlSales') . 'login');
			}
		} else {
			$this->seller = $seller;

			$cart = $this->session->get('cart');
			if ( !$cart )
			{
				$cart = array(); // Se nao tem um carrinho na sessão INICIA UM ZERADO

				$id_seller = $seller->id;
				$id_customer = null; /// **********------******- ######## ++++++++++++ isset($this->customer) ? $this->customer->id : null;
				$cart['customer'] = $id_customer; // TODO - pegar o usuario logado na SESSION

				$cart['seller'] = $id_seller;

				$cart['customer_ip'] = $this->request->getClientAddress();;  // Pega o IP do usuário
				$cart['server'] = $this->request->getServerAddress();;  // Pega o IP do servidor
				$cart['customer_agent'] = $this->request->getUserAgent();;  // Pega o IP do usuário
				$cart['customer_session'] = session_id();
				$cart['start'] = time();
				$cart['value_interest'] = 0;
				$cart['value_delivery'] = 0;
				$cart['value_product'] = 0;
				$cart['value_fee'] = 0;
				$cart['value_fee_org'] = 0;
				$cart['value_total'] = 0;
				$this->session->set("cart", $cart);
			}
			$this->cart = $cart;
			$this->CartLib = new CartLib();

			$this->view->seller = $this->seller;

			$events = $this->CartLib->getEvents($seller->id_sales_points);
			$this->view->events = $events;
		}




	}


	public function clearCartAction()
	{
		$this->session->remove("cart");
		return $this->response->redirect($this->di->get('urlSales'));
	}

	public function eventRemoveAction($id_event)
	{
		$cart = $this->CartLib->removeProductFromCart($this->cart, $id_event, null);
		$this->session->set("cart", $cart);
		return $this->response->redirect($this->di->get('urlSales'));
	}

	/**
	 * Index action
	 */
	public function indexAction()
	{
		if($this->seller) {
			$id_pdv = $this->seller->id_sales_points;
			$salesPoint = SalesPoints::find("id = $id_pdv");

		}
	}


	public function loginAction()
	{
		$this->view->reset_password = false;
		if ($this->request->isPost())
		{
			$id = $this->request->getPost('id', ['string', 'trim']);
			$password = $this->request->getPost('password', ['string', 'trim']);

			$reset_password = $this->request->getPost("reset_password");
			$email_reset_password = $this->request->getPost("email_reset_password");

			if ( $email_reset_password OR $reset_password )
			{

				$this->view->reset_password = true;
				$salesTerminal = SalesTerminal::findFirstByEmail($email_reset_password);

				if ( $salesTerminal )
				{
					$param = array('salesTerminal' => $salesTerminal, 'urlTiktX' => $this->urlTiktX);
					$sendMail = $this->getDI()->getMail()->send(
						array(
							$salesTerminal->email => $salesTerminal->name // destinatario
						),
						'tiktx.com | Bem Vindo a sua página de vendas!', // assunto
						'terminal-password-recovery', // template
						$param // array de parametros para ser usado no template
						);

					if ( $sendMail ) {
						$this->flash->success('Check your email to recover your password');
					} else {
						$this->flash->error(print_r($sendMail));
					}

				} else {
					$this->flash->error('Email not found');
				}


			} else
			{
				$sellerLib = new SellerLib();
				$seller = $sellerLib->login($id, $password);

				if(!$seller) {
					return $this->flash->error("Login ou senha incorretos");
				}

				$this->session->set("seller", $seller);
				return $this->response->redirect($this->di->get('urlSales'));
			}

		}

	}

	public function logoutAction()
	{
		$this->seller = null;
		$this->session->destroy();
		return $this->response->redirect($this->di->get('urlSales'));
	}

	public function accountAction()
	{

		if ($this->request->isPost())
		{
			$password    = $this->request->getPost("password");
			if ( strlen($password) > 2 ) {

				$this->seller->password = $password;
				if ( $this->seller->save() ) {
					$this->flash->success('Password changed successfully');
				} else {
					foreach ($event->getMessages() as $message) {
						$this->flash->error($message);
					}
				}

			} else {
				$this->flash->error('Password must be at least 3 characters');
			}
		}
	}


	public function eventAction($id = null)
	{
		$id_pdv = $this->seller->id_sales_points;
		$event = Events::findFirst($id);
		if ( $event == false ) {
			$this->flash->error('O evento buscado não foi encontrado');
			return $this->dispatcher->forward(array(
				'controller' => 'sales',
				'action' => 'index'
			));
		}
		$this->view->seller = $this->seller;
		$this->view->event = $event;
	}



	public function orderAction($id_order)
	{
		//$order = Orders::findFirst($id_order);
		//$this->view->order = $order;
	}


	public function sale_detailAction($id_order)
	{
		$this->view->setRenderLevel(
			Phalcon\Mvc\View::LEVEL_ACTION_VIEW
		);
		$order = Orders::findFirst($id_order);
		$this->view->order = $order;
	}


	public function send_emailAction()
	{
		$this->view->disable();
		$this->response->setContentType('application/json', 'UTF-8'); // Isto faz retornar um JSON

		$id_order = $this->request->get('id_order', 'int');
		$email = $this->request->get('email', 'email');

		$msg = array();
		if (  $email AND filter_var($email, FILTER_VALIDATE_EMAIL) ) {
			if ( $id_order ) {
				$order = Orders::findFirst($id_order);
				if ( $order ) {
					$order->email_sent = 0;
					$order->send_to_email = $email;
					if ( !$order->save() )
					{
						$msg['status'] = 'error';
						foreach ($order->getMessages() as $message) {
							$msg['msg'] .= $message->getMessage() . ' |';
						}
					} else
					{
						$CartLib = new CartLib();
						$sendEmailOrder = $CartLib->sendEmailOrder($order->id, $order);
						if(!$sendEmailOrder['success'])
						{
							foreach ($sendEmailOrder['message'] as $message)
							{
								$msg['status'] = 'error';
								$msg['msg'] .=  $message . ' | ';
							}
						} else
						{
							$msg['status'] = 'success';
							//$msg['msg'] =  $this->t->_('email_sent_to', array('email' => $email) );
							$msg['msg'] =  $this->t->_('email_sent');
						}
					}
				}
			}
		} else {
			$msg['status'] = 'error';
			$msg['msg'] =  $this->t->_('invalid_email');
		}
		return json_encode($msg);

	}



	public function salesAction()
	{
		$date_start = $this->request->get('date_start');
		if ( !$date_start ) {
			$date_start =  date('d/m/Y H:i:00', strtotime('-7 day'));
		}
		$this->view->date_start = $date_start;

		$date_end = $this->request->get('date_end');
		if ( !$date_end ) {
			$date_end = date('d/m/Y H:i:59');
		}
		$this->view->date_end = $date_end;

		$payment_type = $this->request->get('payment_type');
		$payment_status = $this->request->get('payment_status');
		$order_status = $this->request->get('order_status');

		$filter = '';
		if ( $payment_type ) {
			$payment_type_value = implode(',', $payment_type);
			$filter .= ' AND o.id_payment_type IN ( ' . $payment_type_value . ' ) ';
			$this->view->payment_type = $payment_type_value;
		}
		if ( $payment_status ) {
			$payment_status_value = implode(',', $payment_status);
			$filter .= ' AND o.id_orders_payment_status IN ( ' . $payment_status_value . ' ) ';
			$this->view->payment_status = $payment_status_value;
		}
		if ( $order_status ) {
			$order_status_value = implode(',', $order_status);
			$filter .= ' AND o.id_orders_status IN ( ' . $order_status_value . ' ) ';
			$this->view->order_status = $order_status_value;
		}

		$phql = "
			SELECT o.*
			FROM Orders AS o
			WHERE  o.id_sale_point = :id_sale_point:
			AND o.id_sale_terminal = :id_sale_terminal:
			AND o.created_at BETWEEN :date_start: AND :date_end:
			$filter
			ORDER BY o.id DESC
		";

		$orders = $this->modelsManager->executeQuery(
			$phql,
			[
				"id_sale_point" =>  $this->seller->id_sales_points,
				"id_sale_terminal" => $this->seller->id,
				"date_start" => preg_replace('#(\d{2})/(\d{2})/(\d{4})\s(.*)#', '$3-$2-$1 $4', $date_start),
				"date_end" => preg_replace('#(\d{2})/(\d{2})/(\d{4})\s(.*)#', '$3-$2-$1 $4', $date_end),
			]
		);
		$this->view->orders = $orders;
	}





	public function withdrawalAction()
	{
		$SalesLib = new SalesLib();

		$withdrawal_data = $this->request->get('withdrawal');
		if ( is_array($withdrawal_data) )
		{
			$withdrawalReturn = $SalesLib->withdrawal($this->seller->id_sales_points, $this->seller->id, $withdrawal_data);
			foreach ( $withdrawalReturn AS $id_event => $return ) {
				if(!$return['success']) {
					foreach ($withdrawalReturn['message'] as $message) {
						$this->flash->error("Event: $id_event - " . $message);
					}
				} else {
					$this->flash->success("Event: $id_event - Success");
				}
			}
		}

		$salesResume = $SalesLib->salesResume($this->seller->id_sales_points, $this->seller->id);
		$this->view->salesResume = $salesResume;

		$withdrawals = $SalesLib->withdrawals($this->seller->id_sales_points, $this->seller->id);
		$this->view->withdrawals = $withdrawals;

	}







	public function balanceAction()
	{
		$data_filter = array();

		$event_filter = $this->request->get('event_filter');
		$filter = '';
		if ( $event_filter ) {
			$event_filter = implode(',', $event_filter);
			$data_filter['id_event'] = $event_filter;
			$this->view->event_filter = $event_filter;
		}

		$date_start = $this->request->get('date_start');
		if ( $date_start ) {
			$this->view->date_start = $date_start;
			$date_start = preg_replace('#(\d{2})/(\d{2})/(\d{4})\s(.*)#', '$3-$2-$1 $4', $date_start);
			$data_filter['date_start'] = $date_start;
		}

		$date_end = $this->request->get('date_end');
		if ( $date_end ) {
			$this->view->date_end = $date_end;
			$date_end = preg_replace('#(\d{2})/(\d{2})/(\d{4})\s(.*)#', '$3-$2-$1 $4', $date_end);
			$data_filter['date_end'] = $date_end;
		}

		$SalesLib = new SalesLib();
		$balance = $SalesLib->balance($this->seller->id_sales_points, $this->seller->id, $data_filter);


		// echo 'balance<pre>';
		// print_r($balance);
		// echo '</pre>';

		$this->view->balance = $balance;
	}








	public function cartAction()
	{

		$cart = $this->cart;

		$event = $this->request->getPost('event', 'int');
		// Verifica se informou o evento
		if ( isset($event) AND is_numeric($event) AND $event > 0 ) {
			$event_obj = Events::findFirst($event);
			$products = $this->request->getPost("product", null);

			// Percorre todos produtos para verificar qual foi adicionado
			if ( $products AND $event_obj ) {
				foreach ( $products AS $id_product => $product ) {
					foreach ( $product AS $id_type => $type ) {
						if ( isset($type['qty']) AND $type['qty'] > 0 ) { // Verifica se informou a qty de produto, assim já ignora os que não foram informado a qty

							// getProductsFeesByPDV($pdv, $event_obj, $productId, $productType, $quantity)
							$product_temp = $this->CartLib->getProductsFeesByPDV($this->seller->id_sales_points, $event_obj, $id_product, $id_type, $type['qty']);

							// addProductToCart($cart, $id_event = 0, $product = array(), $id_customer)
							$cart = $this->CartLib->addProductToCart($cart, $event_obj->id, $product_temp, $cart['customer']);
							if ( $cart ) {
								$this->cart = $cart;
								$this->session->set("cart", $cart);
							} else {
								$this->session->remove("cart");
								$this->cart = null;
								$this->view->cart = null;
							}
						}
					}
				}
			}
		}

		if ( isset($cart['event']) AND count($cart['event']) > 0 ) {


			$sellerLib = new SellerLib();
			$payments_type = $sellerLib->getPaymentTypes($this->seller->id_sales_points);
			$this->view->payments_type = $payments_type;


			$email = $this->request->getPost('email', 'email');
			$this->view->email = $email;

			if ( $email )
			{
				$customer = Customers::findFirstByEmail($email);
				if ( $customer )
				{
					$this->view->name = $customer->name;
					$this->view->id = $customer->id_number;
					$this->view->zipcode = $customer->zipcode;

					$billing_address = $customer->CustomerBillingAddress;
					$this->view->billing_address = $billing_address;
					/*
					if ( count($billing_address) > 0 )
					{
						$billing_address = $billing_address[0];
						$this->view->full_name = $billing_address->name;
						$this->view->address_1 = $billing_address->address_1;
						$this->view->address_2 = $billing_address->address_2;
						$this->view->city = $billing_address->city;
						$this->view->region = $billing_address->region;
						$this->view->zip = $billing_address->zipcode;
						$this->view->country = $billing_address->country;
						$this->view->phone = $billing_address->phone;

						$this->view->cc_name = $billing_address->cc_name;
						//$this->view->cc_number = $billing_address->cc_number;
						$this->view->cc_expiration = $billing_address->cc_expiration;
						//$this->view->cc_cvv = $billing_address->cc_cvv;
					}
					*/
				}
			}


			$this->view->cart = $this->cart;
		} else {
			$this->view->pick("sales/cart-empty");
		}
	}






	/**
	* Finaliza a compra
	* Grava o pedido no banco de dados
	* Exibe a tela de confirmação
	*/
	public function checkoutAction() {
		$cart = $this->cart;

		$email = $this->request->getPost('email', 'email');
		$this->view->email = $email;
		$name = $this->request->getPost('name');
		$this->view->name = $name;
		$id = $this->request->getPost('id');
		$this->view->id = $id;
		$zip = $this->request->getPost('zip');
		$this->view->zip = $zip;


		$address = $this->request->getPost('address');
		$billing_address = array();
		$billing_address['full_name'] = $address['full_name'];
		$this->view->full_name = $billing_address['full_name'];
		$billing_address['address_1'] = $address['address_1'];
		$this->view->address_1 = $billing_address['address_1'];
		$billing_address['address_2'] = $address['address_2'];
		$this->view->address_2 = $billing_address['address_2'];
		$billing_address['city'] = $address['city'];
		$this->view->city = $billing_address['city'];
		$billing_address['region'] = $address['region'];
		$this->view->region = $billing_address['region'];
		$billing_address['zip'] = $address['zip'];
		$this->view->zip = $billing_address['zip'];
		$billing_address['country'] = $address['country'];
		$this->view->country = $billing_address['country'];
		$billing_address['phone'] = $address['phone'];
		$this->view->phone = $billing_address['phone'];
		$cart['billing_address'] = json_encode($billing_address);


		$cc_name = $this->request->getPost("cc_name", 'string');
		$this->view->cc_name = $cc_name;
		$cc_number = $this->request->getPost("cc_number", 'string');
		$this->view->cc_number = $cc_number;
		$cc_expiration = $this->request->getPost("cc_expiration", 'string');
		$this->view->cc_expiration = $cc_expiration;
		$cc_cvv = $this->request->getPost("cc_cvv", 'int');
		$this->view->cc_cvv = $cc_cvv;





		if ( $email AND $name AND $id AND $zip )
		{
			$customer = Customers::findFirstByEmail($email);
			if ( $customer )
			{
				#
			} else {
				$customer = new Customers();
				$customer->name = $name;
				$customer->email = $email;
				$customer->id_number = $id;
				$customer->zipcode = $zip;
				$customer->created_at = date('Y-m-d H:i:s');
				$customer->save();
			}

			$cart['customer'] = $customer->id;

			$billing_address = $this->request->getPost('billing_address');
			if ( isset($billing_address) AND $billing_address > 0 ) {

				$CustomerBillingAddress = CustomerBillingAddress::findFirst(
					[
						"id = :id: AND id_customer = :id_customer: ",
						"bind" => [
							"id" => $billing_address,
							"id_customer" => $customer->id
						]
					]
				);

				$set_cc_number = $this->request->getPost("set_cc_number");
				$set_cc_cvv = $this->request->getPost("set_cc_cvv");

				$CustomerBillingAddress->cc_number = $set_cc_number[$billing_address];
				$CustomerBillingAddress->cc_cvv = $set_cc_cvv[$billing_address];
				$CustomerBillingAddress->save();


			} else { // new Billing Address
				$CustomerBillingAddress = new CustomerBillingAddress();
				$CustomerBillingAddress->id_customer = $customer->id;
				$CustomerBillingAddress->name = $address['full_name'];
				$CustomerBillingAddress->phone = $address['phone'];
				$CustomerBillingAddress->address_1 = $address['address_1'];
				$CustomerBillingAddress->address_2 = $address['address_2'];
				$CustomerBillingAddress->city = $address['city'];
				$CustomerBillingAddress->region = $address['region'];
				$CustomerBillingAddress->country = $address['country'];
				$CustomerBillingAddress->zipcode = $address['zip'];
				$CustomerBillingAddress->cc_name = $cc_name;
				$CustomerBillingAddress->cc_number = $cc_number;
				$CustomerBillingAddress->cc_expiration = $cc_expiration;
				$CustomerBillingAddress->cc_cvv = $cc_cvv;
				$CustomerBillingAddress->created_at = date('Y-m-d H:i:s');
				$CustomerBillingAddress->save();
			}


			$cart['id_billing_address'] = $CustomerBillingAddress->id;


			$cc_name = $CustomerBillingAddress->name;
			$cc_expiration = $CustomerBillingAddress->cc_expiration;
			$cc_number = $CustomerBillingAddress->cc_number;
			$cc_cvv = $CustomerBillingAddress->cc_cvv;



		} else {
			$this->flash->error($this->t->_('identification_is_required'));
			return $this->dispatcher->forward(array(
					'controller'=> 'sales',
					'action'    => 'cart',
				));
		}




		if ( $email AND $id ) {
			$cart['send_to_email'] = $email;
			$cart['customer_id'] = $id;
		} else {
			$this->flash->error($this->t->_('email_and_id_is_required'));
			return $this->dispatcher->forward(array(
					'controller'=> 'sales',
					'action'    => 'cart',
				));
		}




		$delivery = $this->request->getPost("deliveryMethod");
		if ( $delivery AND is_array($delivery) ) {
			foreach ( $delivery as $id_event => $value) {
					$cart['event'][$id_event]['event_delivery_set']['id'] = $value;
			}
		}


		$payment = $this->request->getPost('paymentMethod', 'int');
		if ( $payment ) {
			$cart['payment_set'] = $payment; // Isto é importante - Vai persistir no $cart pra ser utilizado em finalizar a compra
			$cart = $this->CartLib->persistCart($cart);
		} else {
			$this->flash->error('Payment is Required');
			return $this->dispatcher->forward(array(
					'controller'=> 'sales',
					'action'    => 'cart',
				));
		}




		/* Forma de pgto cartao de crédito
		* Obrigatório dados de BILLING ADDRESS
		*/
		$ccData = array();
		if ( $payment == 2 )
		{

			if ( isset($CustomerBillingAddress->id) AND $CustomerBillingAddress->id > 0 ) {

				# continue

			} else {
				if ( $billing_address['full_name'] AND $billing_address['address_1']  AND $billing_address['city'] AND $billing_address['region'] AND $billing_address['zip'] AND $billing_address['country'] AND $billing_address['phone'] ) {
					#
				} else {
					$this->flash->error($this->t->_('billing_address_is_required'));
					return $this->dispatcher->forward(array(
							'controller'=> 'sales',
							'action'    => 'cart',
						));
				}
			}







			if ( $cc_name AND $cc_number AND $cc_expiration AND $cc_cvv ) {
				$ccData = array(
					'name' => $cc_name,
					'number' => $cc_number,
					'expiration' => $cc_expiration,
					'cvv' => $cc_cvv,
				);
			} else {
				$this->flash->error($this->t->_('credit_card_is_required'));
				return $this->dispatcher->forward(array(
						'controller'=> 'sales',
						'action'    => 'cart',
				));
			}

		}






		// saveOrder($cart, $id_sale_point = 1, $id_sale_terminal = 1)
		$orderReturn = $this->CartLib->saveOrder($cart, $this->seller->id,  $this->seller->id_sales_points);
		if(!$orderReturn['success']) {
			foreach ($orderReturn['message'] as $message) {
				$this->flash->error($message);
			}
			return $this->dispatcher->forward(array(
				'controller'=> 'sales',
				'action'    => 'cart',
			));
		}
		$order = $orderReturn['data'];




		// saveOrderPayment($orderId, $ccData, $payment)
		$orderPaymentReturn = $this->CartLib->saveOrderPayment($order->id, $ccData, $payment);
		if(!$orderPaymentReturn['success']) {
			foreach ($orderPaymentReturn['message'] as $message) {
				$this->flash->error($message);
			}
			return $this->dispatcher->forward(array(
				'controller'=> 'sales',
				'action'    => 'cart',
			));
		}






		// saveSales($cart, $orderId, $id_sale_point = 1, $id_sale_terminal = 1)
		$salesReturn = $this->CartLib->saveSales($cart, $order->id, $this->seller->id,  $this->seller->id_sales_points);
		if(!$salesReturn['success']) {
			foreach ($salesReturn['message'] as $message) {
				$this->flash->error($message);
			}
			return $this->dispatcher->forward(array(
				'controller'=> 'sales',
				'action'    => 'cart',
			));
		}





		// function proccessPayment($id_order = false, $async = false)
		$proccessPayment = $this->CartLib->proccessPayment($order->id); // Faz assincrono pra nao fazer o cliente esperar
		if(!$proccessPayment['success']) {
			foreach ($proccessPayment['message'] as $message) {
				$this->flash->error($message);
			}
			return $this->dispatcher->forward(array(
				'controller'=> 'sales',
				'action'    => 'cart',
			));
		}






		//function sendEmailOrder($id_order = null, $order = null, $async = false)
		$sendEmailOrder = $this->CartLib->sendEmailOrder($order->id, $order, false); // Faz assincrono pra nao fazer o cliente esperar


		$sql = 'UPDATE orders SET id_orders_status = 2 WHERE id = ' . $order->id;  // Received => Recebimento do pedido concluido
		$this->db->execute($sql);

		// Agora limpa o carrinho - Finalizou a compra
		$this->db->execute("DELETE FROM cart WHERE customer_session = '{$cart['customer_session']}' ");

		// Remove a session variable
		$this->session->remove("cart");

		$this->session->set("new_order", $order->id);
		return $this->response->redirect($this->di->get('urlSales') . 'order/' . $order->id);



	}




}

<?php

class CheckoutController extends ControllerBase
{

	private $CartLib;
	private $cart = null;
	private $customer = null;
	private $seller = null;
	private $embedded = null;
	private $config = null;
	private $event = null;
    private $id_sale_point = null;
    private $id_sale_terminal = null;
    public $ref = null; // REF => Refeencia da compra - vem pelo link, quem indicou (comissário, youtuber, facebook, o link de divulgação)

    public function initialize($token = null)
    {


    	//sleep(2);
		//$this->session->remove("cart");

		$this->view->setRenderLevel(
			Phalcon\Mvc\View::LEVEL_LAYOUT
        );

		$this->view->urlCheckout  = $this->di->get('urlCheckout');


        $token = $this->dispatcher->getParam('token');
        if ( $token ) {
			$embedded =	$this->embeddedInitialize($token);
			if ( $embedded ) {
				$this->embedded = $embedded;
			    $this->id_sale_point = $embedded->id_sale_point;
			    $this->id_sale_terminal = $embedded->id_sale_terminal;
				$config = json_decode($embedded->config);
    			$this->config = $config;
			}
        } else {
			$embedded = $this->session->get('embedded');
			if ( $embedded )
			{
				$this->embedded = $embedded;
			    $this->id_sale_point = $embedded->id_sale_point;
			    $this->id_sale_terminal = $embedded->id_sale_terminal;
				$config = json_decode($embedded->config);
    			$this->config = $config;
			}
        }



		$seller = $this->session->get('seller');
		if ( $seller )
		{
			$this->seller = $seller;
		}
		$this->view->seller = $this->seller;


		$customer = $this->session->get('customer');
		if ( $customer )
		{
			$this->customer = $customer;
		}
		$this->view->customer = $this->customer;





		$cart = $this->session->get('cart');
		if ( !$cart OR empty($cart['customer_session']) OR empty($cart['customer_ip']) )
		{
			$cart = $this->cartInitialize();
		}

		// Se o cara se logou depois de montar o carrinho - vincula o ID dele ao carrinho - para salvar no pedido
		if ( empty($cart['customer']) AND isset($customer) )
		{
			$id_customer = isset($this->customer) ? $this->customer->id : null;
			$cart['customer'] = $id_customer; // TODO - pegar o usuario logado na SESSION
		}

		$this->cart = $cart;
		$this->view->cart = $cart;
		$this->CartLib = new CartLib();


		$tmp_id_sale_point = false;
		// Verifica qual o ID_SALE_POINT esta configurado no EMBEDDED
		if ( $this->id_sale_point AND $this->id_sale_point > 0 ) {
			$tmp_id_sale_point = $this->id_sale_point;

			// Verificar se no config do embedded, precisa estar LOGADO
			if ( $this->config->login  ){
				// Se tiver um SELLER logado (comissário), verifica se é o mesmo ID_SALE_POINT
				if (  isset($seller) AND $seller AND isset($seller->id_sales_points) ) {
					if ( $tmp_id_sale_point != $seller->id_sales_points )  {
						$tmp_id_sale_point = null;
					}
				} else {
					$tmp_id_sale_point = null;
				}
			}
		}
		$this->id_sale_point = $tmp_id_sale_point;

		$id_event  = $this->request->get('event', 'int') ?: null;
		if ( $id_event AND $tmp_id_sale_point ) {
			$event = $this->CartLib->getEvents($tmp_id_sale_point, $id_event);
			if ( $event AND isset($event[0]) ) {
				$event = $event[0];
				$this->event = $event;
				$this->view->event = $event;
			}
		}


		$this->view->id_sale_point = $this->id_sale_point;


		// Se passou o parametro REF
		// Tem referencia de alguma coisa no link - comissário, facebook, youtuber, alguma referencia qualquer
		// Se mandou pelo link, seta na sessão e utiliza ela,
		// Senão, busca se já existe algo na sessão e seta ela.
		if ( isset($_REQUEST['ref']) AND strlen($_REQUEST['ref']) > 0 )
		{
			$ref = $_REQUEST['ref'];
			$this->ref = $ref;
			$this->session->set('ref', $ref);
		} else
		{
			$ref = $this->session->get('ref');
			if ( $ref ) {
				$this->ref = $ref;
			}
		}

		if ( $this->ref ) {
			$cart = $this->cart;
			$cart['ref'] = $ref;
			$this->session->set("cart", $cart);
		}




    }


    private function cartInitialize()
	{
		$cart = array(); // Se nao tem um carrinho na sessão INICIA UM ZERADO
		$id_customer = isset($this->customer) ? $this->customer->id : null;
		$cart['customer'] = $id_customer; // TODO - pegar o usuario logado na SESSION
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
		return $cart;
	}

    public function embeddedInitialize($token = null)
    {
    	$embedded = CheckoutEmbedded::findFirstByToken($token);
    	if ( $embedded )
    	{
    		// Pega as configuraçòes do embedded, que estao salvas como ARRAY e transforma em um stdClass Object
    		$config = json_decode($embedded->config);
    		$this->config = $config;
			$this->session->set("embedded", $embedded);
    	}

    	return $embedded;
    }






    public function indexAction($token = null)
    {
    	if ( $this->config->login != false AND (!$this->seller OR empty($this->seller) OR empty($this->seller->id_sales_points) ) )
    	{
			$this->view->setRenderLevel(
				Phalcon\Mvc\View::LEVEL_ACTION_VIEW
			);
			$this->view->pick("checkout/login-required");

    	} else {
			return $this->dispatcher->forward(array(
				'controller' => 'checkout',
				'action' => 'products'
			));
    	}
    }



    public function productsAction($id_event = null)
    {

		$event =  $this->event;
		if ( $event )
		{
			$id_pdv = $this->embedded->id_sale_point;
			$getProducts = new GetProducts();
			$products = $getProducts->getEventPdv($id_pdv, $event->id);

			$this->view->products = $products;

		} else {
			$this->view->setRenderLevel(
					Phalcon\Mvc\View::LEVEL_ACTION_VIEW
			);
			$this->view->pick("checkout/event-empty");
		}
	}





	public function productAddAction()
	{
		$this->view->setRenderLevel(
				Phalcon\Mvc\View::LEVEL_ACTION_VIEW
		);
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
						if ( isset($type['qty'])  ) { // Verifica se informou a qty de produto, assim já ignora os que não foram informado a qty

							if ( $type['qty'] > 0 )
							{
								// getProductsFeesByPDV($pdv, $event_obj, $productId, $productType, $quantity)
								$product_temp = $this->CartLib->getProductsFeesByPDV($this->id_sale_point, $event_obj, $id_product, $id_type, $type['qty']);

								if ( $product_temp ) {

									// Verifica se tem o produto disponivel ainda
									if ( $product_temp['available'] >= $type['qty'] ) {
										// addProductToCart($cart, $id_event = 0, $product = array(), $id_customer)
										$cart = $this->CartLib->addProductToCart($cart, $event_obj->id, $product_temp);

									} else {

									}
								}

							} else
							{
								if ( isset($cart['event'][$event_obj->id]['products'][$id_product][$id_type]) ) {
									unset($cart['event'][$event_obj->id]['products'][$id_product][$id_type]);

									if ( count($cart['event'][$event_obj->id]['products'][$id_product]) == 0  ) {
										unset($cart['event'][$event_obj->id]['products'][$id_product]);

										if ( count($cart['event'][$event_obj->id]['products']) == 0 ) {
											unset($cart['event'][$event_obj->id]);
										}
									}
								}
							}
						}
					}
				}
			}
			if ( empty($cart['event'] ) OR count($cart['event']) == 0 ) {
				$cart = $this->cartInitialize();
			}
			$cart = $this->CartLib->persistCart($cart);
			$this->cart = $cart;
			$this->session->set("cart", $cart);
		}

/*
		$getProducts = new GetProducts();
		$checkCartAvailable = $getProducts->checkCartAvailable($cart);
*/

		$this->view->cart = $cart;
		return $this->view->pick('checkout/cart-resume');
	}







	public function loginSellerAction()
	{
		$this->view->setRenderLevel(
				Phalcon\Mvc\View::LEVEL_ACTION_VIEW
		);
		$this->response->setContentType('application/json', 'UTF-8'); // Isto faz retornar um JSON
		$msg['success'] = false;

		$loginSeller = $this->request->getPost('loginSeller');
		$email = $loginSeller['email'];
		$email_data = $loginSeller['email_data'];
		$msg['email'] = $email;
		$name = $loginSeller['name'];
		$cell_number = $loginSeller['cell_number'];


		$step = $this->request->getPost('step');
		if ( $step == 1 )
		{
			if (  $email  AND filter_var($email, FILTER_VALIDATE_EMAIL)  )
			{
				$msg['success'] = true;

				$customer = Customers::findFirstByEmail($email);
				if ( $customer )
				{
					$return_customer = array(
						'name' => $customer->name,
						'email' => $customer->email,
						'cell_number' => $customer->cell_number,
						'id_number' => $customer->id_number,
						'zip' => $customer->zipcode,
						'city' => $customer->city,
						'region' => $customer->region,
						'country' => $customer->country,
					);
					$msg['customer'] = $return_customer;
				}
			}  else
			{
				$msg['msg'] = $this->t->_('This email is invalid');
			}
		}




		if ( $step == 2 )
		{
			if (  $email_data  AND filter_var($email_data, FILTER_VALIDATE_EMAIL) AND $name AND $cell_number )
			{
				$customer = Customers::findFirstByEmail($email_data);
				if ( !$customer )
				{
					$customerLib = new CustomerLib();
					$customerReturn = $customerLib->register($name, $email_data, null, null, null, $cell_number);
					if ( $customerReturn['success'] )
					{
						$customer = $customerReturn['customer'];
					} else {
						$msg['msg_register'] = $customerReturn['msg'];
					}
				}

				if ( $customer )
				{

					/** **  Caso algum dado postado seja diferente do salvo - atualiza o cadastro *** **/
					$update_registration = false;
					if ( $customer->cell_number != $cell_number ) {
						$customer->cell_number = $cell_number;
						$update_registration = true;
					}
					if ( $update_registration ) {
						$customer->updated_at = date('Y-m-d H:i:s');
						$customer->save();
					}



					$msg['success'] = true;
					$this->session->set('customer', $customer);
					$this->view->customer = $customer;

					$view = clone $this->view;
					$view->start();
					$view->setRenderLevel(Phalcon\Mvc\View::LEVEL_ACTION_VIEW);
					$view->render('checkout', 'delivery');
					$view->finish();
					$msg['html_delivery'] = $view->getContent();

					$view = clone $this->view;
					$view->start();
					$view->setRenderLevel(Phalcon\Mvc\View::LEVEL_ACTION_VIEW);
					$payments_type = SalesPointsPaymentType::find(
						[
							"id_sale_point = :id_sale_point: ",
							"bind" => [
								"id_sale_point" => $this->id_sale_point
							]
						]
					);
					$view->payments_type = $payments_type;
					$view->render('checkout', 'payment');
					$view->finish();
					$msg['html_payment'] = $view->getContent();
				}

			} else {
				$msg['msg'] = $this->t->_('identification_is_required');
			}

		}

		return json_encode($msg);
	}






	public function loginAction()
	{
		$this->response->setContentType('application/json', 'UTF-8'); // Isto faz retornar um JSON

		$this->view->setRenderLevel(
				Phalcon\Mvc\View::LEVEL_ACTION_VIEW
		);
		$msg['success'] = false;

		if ( $this->customer )
		{
			$this->view->customer =  $this->customer;
			$msg['success'] = true;

		} else {

			$login = $this->request->getPost('login');
			$register = $this->request->getPost('register');

			if ( !empty(trim($login['email'])) AND !empty(trim($login['password']))  AND filter_var($login['email'], FILTER_VALIDATE_EMAIL))
			{

				$customerLib = new CustomerLib();
				$customer = $customerLib->login($login['email'], $login['password']);
				if ( $customer )
				{
					$this->view->customer = $customer;
					$this->session->set('customer', $customer);
					$msg['success'] = true;
				} else {
					$msg['msg_login'] = $this->t->_('Incorrect Email or Password');
				}

			} else if (  !empty(trim($register['name'])) AND  !empty(trim($register['email'])) AND  !empty(trim($register['password'])) AND filter_var($register['email'], FILTER_VALIDATE_EMAIL) )
			{
				$customerLib = new CustomerLib();
				//register($name, $email, $password = null, $id_number = null, $zip = null, $cell_number = null, $city = null, $region = null, $country = null)
				$customerReturn = $customerLib->register($register['name'], $register['email'], $register['password'], $register['cell_number']);
				if ( $customerReturn['success'] )
				{
					$customer = $customerReturn['customer'];
					$this->view->customer = $customer;
					$this->session->set('customer', $customer);
					$msg['success'] = true;
				} else {
					$msg['msg_register'] = $customerReturn['msg'];
				}

			} else {
				// Nao informou os dados de login, nem os dados de register
				$msg['msg_register'] = $this->t->_('Name, Email and Password is required');
				$msg['msg_login'] = $this->t->_('Email and Password is required');
			}

		}

		if ( $msg['success'] == true )
		{
			$view = clone $this->view;
			$view->start();
			$view->setRenderLevel(Phalcon\Mvc\View::LEVEL_ACTION_VIEW);
			$view->render('checkout', 'login');
			$view->finish();
			$msg['html_login'] = $view->getContent();

			$view = clone $this->view;
			$view->start();
			$view->setRenderLevel(Phalcon\Mvc\View::LEVEL_ACTION_VIEW);
			$view->render('checkout', 'delivery');
			$view->finish();
			$msg['html_delivery'] = $view->getContent();


			$view = clone $this->view;
			$view->start();
			$view->setRenderLevel(Phalcon\Mvc\View::LEVEL_ACTION_VIEW);
			$payments_type = SalesPointsPaymentType::find(
				[
					"id_sale_point = :id_sale_point: ",
					"bind" => [
						"id_sale_point" => $this->id_sale_point
					]
				]
			);
			$view->payments_type = $payments_type;
			$view->render('checkout', 'payment');
			$view->finish();
			$msg['html_payment'] = $view->getContent();
		}

		return json_encode($msg);


	}



	public function loginRememberAction()
	{
		$this->view->disable();
		$this->response->setContentType('application/json', 'UTF-8'); // Isto faz retornar um JSON

		$msg['success'] = false;
		$email = $this->request->getPost('email', 'email');
		if ( !empty(trim($email)) AND filter_var($email, FILTER_VALIDATE_EMAIL) )
		{
			$customerLib = new CustomerLib();
			$customerReturn = $customerLib->remember($email);
			if ( $customerReturn['success'] )
			{
				$msg['success'] = true;
				$msg['msg'] = $this->t->_('Email sent');
			} else {
				$msg['msg'] = $customerReturn['msg'];
			}
		} else {
			$msg['msg'] = $this->t->_('This email is invalid');
		}
		return json_encode($msg);
	}




	public function logoutAction()
	{
		$this->view->setRenderLevel(
				Phalcon\Mvc\View::LEVEL_ACTION_VIEW
		);

		// Remove a session variable
		$this->session->remove("customer");
		$this->customer = null;
		$this->view->customer = null;
		return $this->view->pick('checkout/login');
	}






	public function deliveryAction()
	{
		$this->response->setContentType('application/json', 'UTF-8'); // Isto faz retornar um JSON

		$this->view->setRenderLevel(
				Phalcon\Mvc\View::LEVEL_ACTION_VIEW
		);
		$msg['success'] = false;

		$id_delivery = $this->request->getPost("deliveryMethod");
		$id_event = $this->request->getPost("event");
		$email = $this->request->getPost("email", 'email');

		$customer_id = (isset($this->customer) ? $this->customer->id : null);


		if (  $email AND filter_var($email, FILTER_VALIDATE_EMAIL) )
		{
			$cart = $this->CartLib->setDelivery($this->cart, $id_event, $id_delivery);
			if ( $cart )
			{
				$cart['send_to_email'] = $email;
				$cart['customer_id'] = $customer_id;
				$cart = $this->CartLib->persistCart($cart, $customer_id );

				$this->cart = $cart;
				$this->session->set('cart', $cart);
				$msg['success'] = true;
			} else {
				$msg['msg'] = $this->t->_('Error while saving delivery type');
			}
		} else {
			$msg['msg'] = $this->t->_('This email is invalid');
		}

		return json_encode($msg);

	}







	public function paymentAction()
	{
			$payments_type = SalesPointsPaymentType::find(
				[
					"id_sale_point = :id_sale_point: ",
					"bind" => [
						"id_sale_point" => $id_sale_point
					]
				]
			);
			$this->view->payments_type = $payments_type;

			$this->view->setVar("payments_type", $payments_type);
			$this->view->setParamToView("payments_type", $payments_type);

	}



	public function checkoutAction()
	{


		$this->response->setContentType('application/json', 'UTF-8'); // Isto faz retornar um JSON
		$this->view->setRenderLevel(
				Phalcon\Mvc\View::LEVEL_ACTION_VIEW
		);



		$msg['success'] = false;

		$payment = $this->request->getPost('paymentMethod');
		if ( $payment ) {
			$cart = $this->cart;
			$cart['payment_set'] = $payment; // Isto é importante - Vai persistir no $cart pra ser utilizado em finalizar a compra
			$cart = $this->CartLib->persistCart($cart);
			$this->cart = $cart;
			$this->session->set('cart', $cart);
		}

		$proccess_order = false;
		if ( $payment == 1 ) // Pgto em Dinheiro
		{
			$proccess_order = true;

		} elseif ( $payment == 7 AND $cart['value_total'] == 0 ) // Pgto em Cortesia
		{
			$proccess_order = true;

		} elseif ( $payment == 2 ) // Pgto com Cartão de Crédito
		{
			$cc_name = $this->request->getPost("cc_name", 'string');
			$cc_number = $this->request->getPost("cc_number", 'string');
			$cc_expiration = $this->request->getPost("cc_expiration", 'string');
			$cc_cvv = $this->request->getPost("cc_cvv", 'int');
			/* ---*-*-*-* PRIMEIRO VERIFICA SE TEM OS DADOS DO CARTAO DE CRÉDITO  -*-*-*-*- */
			if ( $cc_name AND $cc_number AND $cc_expiration AND $cc_cvv )
			{

				$address = $this->request->getPost('address');
				$billing_address = array();
				$billing_address['full_name'] = $address['full_name'];
				$billing_address['address_1'] = $address['address_1'];
				$billing_address['address_2'] = $address['address_2'];
				$billing_address['city'] = $address['city'];
				$billing_address['region'] = $address['region'];
				$billing_address['zip'] = $address['zip'];
				$billing_address['country'] = $address['country'];
				$this->cart['billing_address'] = json_encode($billing_address);

				/* ---*-*-*-*  VERIFICA SE TEM OS DADOS DO BILLING ADDRESS CARTAO DE CRÉDITO  -*-*-*-*- */
				/*  TESTANDO, TALVEZ NAO PRECISE DE TODOS ESTES DADOS */
				// if (  $billing_address['full_name'] AND $billing_address['address_1']  AND $billing_address['city'] AND $billing_address['region'] AND $billing_address['zip'] AND $billing_address['country'] )
				if ( $billing_address['zip'] )
				{

					$proccess_order = true;


				} else {
					//$msg['msg_billing_address'] = $this->t->_('billing_address_is_required');
					$msg['msg_billing_address'] = $this->t->_('Zipcode is required');
				}


			} else {
				$msg['msg_credit_card'] = $this->t->_('credit_card_is_required');
			}
		} else {
			$msg['msg'] = $this->t->_('Choose payment method');
		}




		if ( $proccess_order )
		{


			/* ---*-*-*-* SALVA A ORDEM DE COMPRA  -*-*-*-*- */
			// saveOrder($cart, $id_sale_point = 1, $id_sale_terminal = 1)
			$orderReturn = $this->CartLib->saveOrder($this->cart,  $this->id_sale_point,  $this->id_sale_terminal);
			if( $orderReturn['success'] )
			{
				$order = $orderReturn['data'];

				$ccData = null;
				if ( $payment == 2 ) {
					$ccData = array(
						'name' => $cc_name,
						'number' => $cc_number,
						'expiration' => $cc_expiration,
						'cvv' => $cc_cvv,
					);
				}

				/* ---*-*-*-* SALVA OS DADOS DE PAGAMENTO DESTA ORDEM DE COMPRA  -*-*-*-*- */
				// saveOrderPayment($orderId, $ccData, $payment)
				$orderPaymentReturn = $this->CartLib->saveOrderPayment($order->id, $ccData, $payment);
				if($orderPaymentReturn['success'])
				{



					/* ---*-*-*-* SALVA OS PEDIDOS - UM PARA CADA EVENTO - ASSIM PODE HAVER CARRINHO DE COMPRA  -*-*-*-*- */
					// saveSales($cart, $orderId, $id_sale_point = 1, $id_sale_terminal = 1)
					$salesReturn = $this->CartLib->saveSales($this->cart, $order->id, $this->id_sale_point,  $this->id_sale_terminal);
					if( $salesReturn['success'] )
					{




						/* ---*-*-*-* PROCESSA O PGTO DESTA ORDEM DE COMPRA   -*-*-*-*- */
						// function proccessPayment($id_order = false, $async = false)
						$proccessPayment = $this->CartLib->proccessPayment($order->id); // Faz assincrono pra nao fazer o cliente esperar
						if( $proccessPayment['success'] )
						{

							# Tudo certo até aqui - TERMINOU O PEDIDO  \o/ \o/
							$msg['success'] = true;
							$this->view->order = $order;
							$view = clone $this->view;
							$view->start();
							$view->setRenderLevel(Phalcon\Mvc\View::LEVEL_ACTION_VIEW);
							$view->render('checkout', 'success');
							$view->finish();
							$msg['html'] = $view->getContent();


							//function sendEmailOrder($id_order = null, $order = null, $async = false)
							$sendEmailOrder = $this->CartLib->sendEmailOrder($order->id, $order, true); // Faz assincrono pra nao fazer o cliente esperar

							// Received => Recebimento do pedido concluido
							$sql = 'UPDATE orders SET id_orders_status = 2 WHERE id = ' . $order->id;
							$this->db->execute($sql);

							/* Pgto OK => Muda o status das SALES
								id	name	description
								1	Creating	Recebendo o pedido
								2	Received	Pedido recebido
								3	Payment processing	Pagamento sendo processado
								4	Payment confirmed	Pagamento confirmado
								5	Delivery processing	Entrega sendo processada
								6	Confirmed delivery	Entrega confirmada
								7	Canceled	Cancelado
							*/
							$sql = 'UPDATE sales s SET s.status = 4 WHERE s.id_order = "' . $order->id . '" ';
							$this->db->execute($sql);

							// Ativa os ingressos do pedido - Os Tickets estao com status pendente
							// Muda o stauts pra 1 -> Ativo
							$sql = 'UPDATE sales_items si SET si.status = 1 WHERE si.id_sale IN ( SELECT os.id_sale FROM order_sale os WHERE os.id_order = ' . $order->id . ' )';
							$this->db->execute($sql);

							// Agora limpa o carrinho - Finalizou a compra
							$this->db->execute("DELETE FROM cart WHERE customer_session = '" . $this->cart['customer_session'] . "' ");

							// Remove a session variable
							$this->session->remove("cart");




						} else {
							foreach ($proccessPayment['message'] as $message) {
								$msg['msg'] = $message;
							}
						}




					} else {
						foreach ($salesReturn['message'] as $message) {
							$msg['msg'] = $message;
						}
					}




				} else {
					foreach ($orderPaymentReturn['message'] as $message) {
						$msg['msg'] = $message;
					}
				}




			} else {
				foreach ($orderReturn['message'] as $message) {
					$msg['msg'] = $message;
				}
			}


		}


		return json_encode($msg);

	}








	public function getAddressAction()
	{
		$this->view->disable();
		$this->response->setContentType('application/json', 'UTF-8'); // Isto faz retornar um JSON

		$msg['status'] = 'error';
		$zip    = $this->request->getPost('zip', 'string');
		if ( strlen($zip) > 4 )
		{
			$ZipCode = new ZipCode();
			$getAddress = $ZipCode->getAddress($zip);
			if ( count($getAddress) > 0 ) {
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



}
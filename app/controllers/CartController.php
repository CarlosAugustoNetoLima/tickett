<?php



class CartController extends ControllerBase
{

	private $cart = array();
	private $id_customer = 0;
	private $customer = null;
	private $CartLib;

	public function initialize()
	{

		//$this->session->remove("cart");
		$cart = $this->session->get('cart');


		// Verificar se já tem um usuário logado
		// Para add o ID dele no CART
		$customer = $this->session->get('customer');
		if ( $customer ) {
			$this->id_customer = $customer->id;
			$this->customer = $customer;

			//Qdo inicia um pedido, sem estar logado, o $cart['customer'] fica = 0, pq iniciou assim.
			// Isto é pra forçar a ter o ID do cliente no pedido, pq senao o CartLib.php nao vincula o pedido
			if ( isset($cart['customer']) ) {
				$cart['customer'] = $this->id_customer;
				$this->session->set('cart', $cart);
			}
		}
		$this->view->customer = $this->customer;


		if ( !$cart ) {
			$cart = array(); // Se nao tem um carrinho na sessão INICIA UM ZERADO
			$cart['customer'] = $this->id_customer;  // TODO - pegar o usuario logado na SESSION
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
	}




	/**
	 * Index action
	 */
	public function indexAction() {
		$cart = $this->cart;

		// Remove o evento do carrinho - Todos produtos deste evento
		$event_remove = $this->request->getPost('event_remove', 'int');
		if ( $event_remove ) {
			// removeProductFromCart($cart, $id_event, $id_customer)
			$cart = $this->CartLib->removeProductFromCart($cart, $event_remove, $this->id_customer);
			if ( $cart ) {
				$this->cart = $cart;
				$this->session->set("cart", $cart);
			} else {
				$this->session->remove("cart");
				$this->cart = null;
			}
		}



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
							$product_temp = $this->CartLib->getProductsFeesByPDV(1, $event_obj, $id_product, $id_type, $type['qty']);

							// addProductToCart($cart, $id_event = 0, $product = array(), $id_customer)
							$cart = $this->CartLib->addProductToCart($cart, $event_obj->id, $product_temp, $this->id_customer);
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
			// TODO  :(
			// Tem que decidir se vai ter forma de pgto diferente por evento
			$payment_types = PaymentTypes::find();
			$this->view->payment_types = $payment_types;

			$this->view->cart = $this->cart;
		} else {
			$this->view->pick("cart/empty");
		}


	}


	public function setPaymentAction() {
		$this->view->setRenderLevel(
				Phalcon\Mvc\View::LEVEL_ACTION_VIEW
		);
		$payment = $this->request->getPost('payment', 'int');
		$cart = $this->cart;
		if ( $payment ) {

			$cart['payment_set'] = $payment; // Isto é importante - Vai persistir no $cart pra ser utilizado em finalizar a compra

			$cart = $this->CartLib->persistCart($cart, $this->id_customer);
			if ( $cart ) {
				$this->cart = $cart;
				$this->session->set("cart", $cart);
			} else {
				$this->session->remove("cart");
				$this->cart = null;
				$this->view->cart = null;
			}

			$this->view->cart = $this->cart;
			if ( in_array($payment, array(2) )) {
				# Cartão de Crédito
				return $this->view->pick('cart/payment-data-credit-card');

			} else if ( in_array($payment, array(6) )) {
				# Boleto
				return $this->view->pick('cart/payment-data-billet');

			} elseif (in_array($payment, array(4) )) {
				# PayPal
				return $this->view->pick('cart/payment-data-paypal');

			} else {
				# Default
				return $this->view->pick('cart/payment-data-default');
			}

		} else { // A forma de entrega enviada, nao esta disponivel para o evento selecionado - talvez tentaram burlar o esquema
			return 'Forma de pagamento não esta disponível';
		}
	}



	/*
	* Seta a forma de pagamento no evento escolhido
	* Isto grava o valor na session $cart
	* Tbm atualiza todo o valor do $cart
	* Ainda retorna o resumo do carrinho para exibir os valores atualizados ao usuário
	*/
	public function setDeliveryAction() {
		$this->view->setRenderLevel(
				Phalcon\Mvc\View::LEVEL_ACTION_VIEW
		);

		$event = $this->request->getPost('event', 'int');
		$delivery = $this->request->getPost('delivery', 'int');

		$cart = $this->CartLib->setDelivery($this->cart, $event, $delivery);

		if(!$cart) {
			return 'Forma de entrega não esta disponível';
		}

		$cart = $this->CartLib->persistCart($cart, $this->id_customer);
		if($cart) {
			$this->cart = $cart;
			$this->session->set("cart", $cart);
		} else {
			$this->session->remove("cart");
			$this->cart = null;
			$this->view->cart = null;
		}

		$this->view->cart = $this->cart;
		return $this->view->pick('cart/cart-resume');
	}





	/**
	* Finaliza a compra
	* Grava o pedido no banco de dados
	* Exibe a tela de confirmação
	*/
	public function checkoutAction() {
		$delivery = $this->request->getPost("deliveryMethod");
		$payment = $this->request->getPost("paymentMethod");

		$customer = Customers::findFirst($this->id_customer);

		$cc_name = $this->request->getPost("cc_name", 'string');
		$cc_number = $this->request->getPost("cc_number", 'string');
		$cc_expiration = $this->request->getPost("cc_expiration", 'string');
		$cc_cvv = $this->request->getPost("cc_cvv", 'int');

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
		$this->cart['billing_address'] = json_encode($billing_address);

		if ( isset($address['address_1'])) {

			$CustomerBillingAddress = CustomerBillingAddress::findFirst(
				[
					"address_1 = :address_1: AND id_customer = :id_customer: ",
					"bind" => [
						"address_1" => $address['address_1'],
						"id_customer" => $customer->id
					]
				]
			);

			if($CustomerBillingAddress) {
				$CustomerBillingAddress->cc_number = $cc_number;
				$CustomerBillingAddress->cc_cvv = $cc_cvv;
				$CustomerBillingAddress->save();

			} else {
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
		} else {
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

		$this->cart['id_billing_address'] = $CustomerBillingAddress->id;

		// Percorre o array com as formas de entrega, para ver se todas estão preenchidas - senao recusa o pedido
		$all_delivery_checked = false;
		if ( $delivery AND is_array($delivery) ) {
			$all_delivery_checked = true;
			foreach ( $delivery as $key => $value) {
				if ( !is_numeric($value) OR $value < 1 OR $value == null ) {
					$all_delivery_checked = false;
				} else {
					$setDeliveryReturn = $this->CartLib->setDelivery($this->cart, $key, $value);
					if ( $setDeliveryReturn ) {
						$cart = $this->CartLib->persistCart($setDeliveryReturn, $this->id_customer);
						$this->cart = $cart;
						$this->session->set('cart', $cart);
					} else {
						$this->flash->error('Selecione a forma de entrega');
						return $this->dispatcher->forward(array(
									'controller'=> 'cart',
									'action'	=> 'index',
								));
					}
				}
			}
		}


		if ( $all_delivery_checked ) {
			$this->view->delivery_set = true;
		} else {
			$this->flash->error('Selecione a forma de entrega');
			return $this->dispatcher->forward(array(
						'controller'=> 'cart',
						'action'	=> 'index',
					));
		}

		// Verifica se informou as formas de entrega e a forma de pgto
		if ( $payment  ) {

			$cart = $this->cart;

			$cart['payment_set'] = $payment;


			if ( $billing_address['full_name'] AND $billing_address['address_1']  AND $billing_address['city'] AND $billing_address['region'] AND $billing_address['zip'] AND $billing_address['country'] AND $billing_address['phone'] ) {



				if ( $cc_name AND $cc_number AND $cc_expiration AND $cc_cvv ) {

					// saveOrder($cart, $id_sale_point = 1, $id_sale_terminal = 1)
					$orderReturn = $this->CartLib->saveOrder($cart);
					if(!$orderReturn['success']) {
						foreach ($orderReturn['message'] as $message) {
							$this->flash->error($message);
						}
						return $this->dispatcher->forward(array(
							'controller'=> 'cart',
							'action'	=> 'index',
						));
					}
					$order = $orderReturn['data'];



					// saveOrderPayment($orderId, $ccData, $payment)
					$ccData = array(
									'name' => $cc_name,
									'number' => $cc_number,
									'expiration' => $cc_expiration,
									'cvv' => $cc_cvv,
								);
					$orderPaymentReturn = $this->CartLib->saveOrderPayment($order->id, $ccData, $payment);
					if(!$orderPaymentReturn['success']) {
						foreach ($orderPaymentReturn['message'] as $message) {
							$this->flash->error($message);
						}
						return $this->dispatcher->forward(array(
							'controller'=> 'cart',
							'action'	=> 'index',
						));
					}

				} else { // if ( $cc_name AND $cc_number AND $cc_expiration AND $cc_cvv )

					$this->flash->error($this->t->_('credit_card_is_required'));
					return $this->dispatcher->forward(array(
							'controller'=> 'cart',
							'action'	=> 'index',
						));
				}



				// saveSales($cart, $orderId, $id_sale_point = 1, $id_sale_terminal = 1)
				$salesReturn = $this->CartLib->saveSales($cart, $order->id);
				if(!$salesReturn['success']) {
					foreach ($salesReturn['message'] as $message) {
						$this->flash->error($message);
					}
					return $this->dispatcher->forward(array(
						'controller'=> 'cart',
						'action'	=> 'index',
					));
				}





				// function proccessPayment($id_order = false, $async = false)
				$proccessPayment = $this->CartLib->proccessPayment($order->id, false); // Faz assincrono pra nao fazer o cliente esperar
				if(!$proccessPayment['success']) {
					foreach ($proccessPayment['message'] as $message) {
						$this->flash->error($message);
					}
					return $this->dispatcher->forward(array(
						'controller'=> 'cart',
						'action'	=> 'index',
					));
				}





				//function sendEmailOrder($id_order = null, $order = null, $async = false)
				$sendEmailOrder = $this->CartLib->sendEmailOrder($order->id, $order, true); // Faz assincrono pra nao fazer o cliente esperar




				$sql = 'UPDATE orders SET id_orders_status = 2 WHERE id = ' . $order->id;  // Received => Recebimento do pedido concluido
				$this->db->execute($sql);


				// Agora limpa o carrinho - Finalizou a compra
				$this->db->execute("DELETE FROM cart WHERE customer_session = '{$cart['customer_session']}' ");

				// Remove a session variable
				$this->session->remove("cart");

				$this->session->set("new_order", $order->id);
				return $this->response->redirect('account/order/' . $order->id);






			} else { // if ( $billing_address['full_name'] AND $billing_address['address_1']  AND $billing_address['city'] AND $billing_address['region'] AND $billing_address['zip'] AND $billing_address['country'] AND $billing_address['phone'] ) {
				$this->flash->error('Billing Address is Required');
				return $this->dispatcher->forward(array(
							'controller'=> 'cart',
							'action'	=> 'index',
						));
			}





		} else { // if ( $delivery AND $payment )
			$this->flash->error('Informe os dados de pagamento');
			return $this->dispatcher->forward(array(
						'controller'=> 'cart',
						'action'	=> 'index',
					));
		}


	}

}

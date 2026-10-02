<?php

use Phalcon\Http\Response;

class ApiCartController extends ApiControllerBase
{
	private $cartLib;
    private $session_id = null;

	public function initialize()
	{

        $session_id = $this->session->getId();
        $this->session_id = $session_id;
        $this->view->session_id = $session_id;

		$customer = $this->session->get('customer');
		if ( $customer )
		{
			$this->customer = $customer;
        }

        $seller = $this->session->get('seller');
		if ( $seller )
		{
			$this->seller = $seller;
		}

		$cart = $this->session->get('cart');
		if ( !$cart )
		{
			$cart = array(); // Se nao tem um carrinho na sessão INICIA UM ZERADO

			$id_customer = isset($this->customer) ? $this->customer->id : null;
			$cart['customer'] = $id_customer; // TODO - pegar o usuario logado na SESSION

			$id_seller = isset($this->seller) ? $this->seller->id : null;
			$cart['seller'] = $id_seller;

			$cart['customer_ip'] = $this->request->getClientAddress();;  // Pega o IP do usuário
			$cart['server'] = $this->request->getServerAddress();;  // Pega o IP do servidor
			$cart['customer_agent'] = $this->request->getUserAgent();;  // Pega o IP do usuário
			$cart['customer_session'] = $this->session_id;
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

		$this->cartLib = new CartLib();
	}

	public function indexAction()
	{
		$events = isset($this->requestBody->events) ? $this->requestBody->events : '';
		$pdv = isset($this->requestBody->pdv) ? $this->requestBody->pdv : '';
		$pos = isset($this->requestBody->pos) ? $this->requestBody->pos : '';

		if(!is_array($events) || empty($pdv) || empty($pos)) {
			$this->response->setStatusCode(404, "Not Found");
			$this->response->setContent(json_encode("Missing parameters"));
			$this->response->send();
			return;
		}

		$this->cart['pdv'] = $pdv;
		$this->cart['pos'] = $pos;

		$lotController = new LotControl();

		foreach($events as $event) {
			$event_obj = Events::findFirst($event->id);

			if(!is_array($event->products)) {
				$this->response->setContent(json_encode("Products must by an array"));
				$this->response->send();
				return;
			}

			foreach($event->products as $product) {

				$product_temp = $this->cartLib->getProductsFeesByPDV($pdv, $event_obj, $product->id, $product->type, $product->quantity);
				$lotController->verify($product_temp);

				if(!$lotController->verify($product_temp)) {
					$this->response->setContent(json_encode(array(
							"success" => false,
							"event" => $event_obj->name,
							"product" => $product_temp['name'],
							"message" => "Lote {$product_temp['lot']} com saldo insuficiente."
						)));
					$this->response->send();
					return;
				}

				$product_temp['productsSeat'] = $product->productsSeat;
				$this->addProduct($event_obj->id, $product_temp);
			}
		}

		$cart = $this->cart;
		$id_customer = isset($this->customer) ? $this->customer : 0;
		$cart = $this->cartLib->persistCart($cart, $id_customer);

		if($cart) {
			$this->cart = $cart;
			$this->session->set("cart", $cart);
		} else {
			$this->session->remove("cart");
			$this->cart = null;
		}

		$this->response->setContent(json_encode(array(
			"success" => true,
			"cart" => $this->cart
		)));
		$this->response->send();
	}

	public function statusAction()
	{
		$this->response->setContent(json_encode(array(
			"success" => true,
			"cart" => $this->cart
		)));
		$this->response->send();
	}

	/* public function createAction()
	{
	} */

	public function removeAction()
	{
	}

	public function round_up ($value, $places=0) {
		if ($places < 0) { $places = 0; }
		$mult = pow(10, $places);
		return ceil($value * $mult) / $mult;
	}


	public function calcInstallmentsAction() {
		$max_installment = 0; // Para saber qual será a parcela máxima
		$event_pieces = null;

		$events = isset($this->cart['event']) ? $this->cart['event'] : array();
		foreach ( $events AS $id_event => $event ) // Percorre todos eventos no carrinho
		{
			// EVITAR QUEBRAS
			if ( !isset($event['interest_rate']) ) $event['interest_rate'] = 0;
			if ( !isset($event['value_interest']) ) $event['value_interest'] = 0;
			if ( !isset($event['value_interest_tax']) ) $event['value_interest_tax'] = 0;
			if ( !isset($event['max_installment_without_interest']) ) $event['max_installment_without_interest'] = 0;
			if ( !isset($event['max_installment_with_interest']) ) $event['max_installment_with_interest'] = 0;


			// Pega as variáveis sobre juros, que vem da consulta de produtos no ProductsLib.php::getAllProducts
			// Valor total do evento, sem os juros, pq já pode ter sido somado ao valor total
			$event_value = ($event['value_total'] - $event['value_interest'] - $event['value_interest_tax']);
			$interest_rate = ($event['interest_rate'] AND $event['interest_rate'] > 0 ) ? $event['interest_rate'] : 0;

			$max_installment_without_interest = $event['max_installment_without_interest'];
			if ( !$max_installment_without_interest ) $max_installment_without_interest = 1;
			if ( $max_installment_without_interest == null ) $max_installment_without_interest = 1;

			$max_installment_with_interest = ($event['max_installment_with_interest'] AND $event['max_installment_with_interest'] > 0 ) ? $event['max_installment_with_interest'] : 1;
			if ( !$max_installment_with_interest ) $max_installment_with_interest = 1;
			if ( $max_installment_with_interest == null ) $max_installment_with_interest = 1;

			// Isto é para saber qual é a maior parcela possível entre todos eventos
			if ( $max_installment < $max_installment_without_interest ) {
				$max_installment = $max_installment_without_interest;
			}
			if ( $max_installment < $max_installment_with_interest ) {
				$max_installment = $max_installment_with_interest;
			}

			// Percorre as parcelas, para fazer o calculo de juros em cada uma delas
			for ( $installment = 1; $installment <= $max_installment; $installment++ ) {
				// Para parcelas sem juros
				if ($installment <= $max_installment_without_interest OR $interest_rate == 0) {
					$piece_value = $this->round_up(($event_value / $installment), 2);
					$total_value = ($piece_value * $installment);
					$total_interest = ($total_value - $event_value);
				} else {
					// Para parcelas com juros
					$interest = ($interest_rate / 100);
					$total_value = 0;
					for ($n = 1; $n <= $installment; $n++) {
						$total_value += ($event_value / $installment) + ($event_value / $installment * $interest * $n);
					}
					$piece_value = $this->round_up(($total_value / $installment), 2);
					$total_value = ($piece_value * $installment);
					$total_interest = ($total_value - $event_value);
				}

				if ($piece_value < 5 && $installment > 1) {
					continue;
				}


				// Guarda os valores da parcela, para depois jogar no array do evento
				$pieces[] = array(
					'installment' => $installment,
					'piece_value' => $piece_value,
					'total_value' => $total_value,
					'total_interest' => $total_interest,
				);
			}
			// Joga os valores de cada parcela do evento, dentro do array do evento
			$event_pieces = $pieces;
		}

		$this->response->setContent(json_encode(array(
			"success" => !!$event_pieces,
			"installments" => $event_pieces
		)));
		$this->response->send();
	}

	public function setDeliveryAction()	{


        $request = print_r( $this->request->getRawBody() , true) ;
        $ip = $this->request->getClientAddress();
        $session = $this->session_id;
        $agent = $this->request->getUserAgent();


		/***** LOG PRA DEBUGAR A POS  **********/
		/***** LOG PRA DEBUGAR A POS  **********/
		// $request = print_r( $this->request->getRawBody() , true) ;
		$request = print_r($this->cart, true);
		$sql = "
				INSERT INTO _log_api (url,ip,session,agent,request)
				VALUES ('api-cart/setDelivery  CART INICIAL', ?, ?, ?, ?)
				";
        $this->db->execute($sql, array($ip, $session, $agent, $request) );
		/***** LOG PRA DEBUGAR A POS  **********/
		/***** LOG PRA DEBUGAR A POS  **********/

		if ( isset($this->cart['order_id']) )
		{
			// O $CART ainda não foi salvo, não virou uma ORDER
			// Então não pode ter um ORDER_ID  nele
			// Isso aacontece qdo o app oscila a conexão e manda duas request do setDelivery,
			// Por isso duplica a SALE dentro da ORDER
			// Então agora meti essa gambiarra aqui pra evitar essa duplicação


			$sql = "
					INSERT INTO _log_api (url,ip,session,agent,request)
					VALUES ('api-cart/setDelivery  --- EVITOU DUPLICAR #" . $this->cart['order_id'] . "', ?, ?, ?, ?)
					";
            $this->db->execute($sql, array($ip, $session, $agent, $request) );


				$this->response->setStatusCode(404, "Not Found");
				$this->response->setContent(json_encode("Conexão oscilou. Refaça a compra"));
				$this->response->send();
				return;


			$this->response->setContent(json_encode(array(
				"success" => false,
				"message" => 'Conexão oscilou. Refaça a compra',
			)));
			$this->response->send();
			return;
		}





		$event = isset($this->requestBody->event) ? $this->requestBody->event : '';
		$delivery = isset($this->requestBody->delivery) ? $this->requestBody->delivery : '';
		$destination = isset($this->requestBody->destination) ? $this->requestBody->destination : '';
		$productsSeats = isset($this->requestBody->productsSeats) ? $this->requestBody->productsSeats : '';

		if(empty($event) || empty($delivery)) {
			$this->response->setStatusCode(404, "Not Found");
			$this->response->setContent(json_encode("Missing delivery type"));
			$this->response->send();
			return;
		}

		//Correção na build da getnet
		if (empty($destination) && $delivery == 6) { $delivery = 5; }

		if (in_array($delivery, ["6", "7", "10"])) {
			if(empty($destination)) {
				$this->response->setStatusCode(404, "Not Found");
				$this->response->setContent(json_encode("Missing delivery destination"));
				$this->response->send();
				return;
			}
		}

		$this->cart['payment_set'] = null;
		$cart = $this->cart;
		$cart = $this->cartLib->setDelivery($cart, $event, $delivery, $destination);

		if(!$cart) {
			$this->response->setContent(json_encode(array(
				"success" => false,
				"message" => "Forma de entrega inválida"
			)));
			$this->response->send();
			return;
		}

		$orderReturn = $this->cartLib->saveOrder($cart, $cart['pdv'], $cart['pos']);
		if(!$orderReturn['success']) {
			$this->response->setContent(json_encode(array(
				"success" => false,
				"message" => $orderReturn['message']
			)));
			$this->response->send();
			return;
		}
		$salesReturn = $this->cartLib->saveSales($cart, $orderReturn['data']->id, $cart['pdv'], $cart['pos']);
		if(!$salesReturn['success']) {
			$this->response->setContent(json_encode(array(
				"success" => false,
				"message" => $salesReturn['message']
			)));
			$this->response->send();
			return;
		}
		$cart["order_id"] = $orderReturn["data"]->id;



		$id_customer = isset($this->customer) ? $this->customer : 0;
		$cart = $this->cartLib->persistCart($cart, $id_customer);

		if($cart) {
			$this->cart = $cart;
			$this->session->set("cart", $cart);
		} else {
			$this->session->remove("cart");
			$this->cart = null;
			$this->view->cart = null;
		}

		$this->response->setContent(json_encode(array(
			"success" => true,
			"order" => $orderReturn['data']->id,
			"message" => "Forma de entrega alterada"
		)));
		$this->response->send();
	}

	public function registerPaymentAction()
	{
		$cart = $this->cart;
		/**
		 * ------- result --------
		 * 0 SUCESSO Transação efetuada com sucesso
		 * 1 NEGADA Transação negada pelo servidor (emissor, bandeira, ... )
		 * 2 CANCELADA Transação cancelada (pelo servidor ou usuário)
		 * 3 FALHA Falha ao completar a transação (internet, servidor, emissor, ... )
		 * 4 DESCONHECIDO Erro desconhecido
		 * ------- details -------
		 * Texto com detalhes da transação
		 * ------- type ----------
		 * 02 - Débito  					--> 16
		 * 05 - PIX  						--> 25
		 * 11 - Crédito a vista				--> 15
		 * 12 - Crédito parcelado Lojista	--> 15
		 * 13 - Crédito parcelado Emissor	--> 15
		 * 03 - Voucher
		 * ------- inputType -----
		 * 021 - tarja magnética
		 * 051 - chip
		 * 071 - chip sem contato
		 * 801 - tarja magnética - fallback
		 * -------- nsu ----------
		 * Código de autorização da transação da Getnet – ele é único por terminal
		 */

		$event = isset($this->requestBody->event) ? $this->requestBody->event : '';
		$result = isset($this->requestBody->result) ? $this->requestBody->result : '';
		$details = isset($this->requestBody->details) ? $this->requestBody->details : '';
		$amount = isset($this->requestBody->amount) ? $this->requestBody->amount : '';
		$type = isset($this->requestBody->type) ? $this->requestBody->type : '';
		$inputType = isset($this->requestBody->inputType) ? $this->requestBody->inputType : '';
		$nsu = isset($this->requestBody->nsu) ? $this->requestBody->nsu : '';
		$authorizationCode = isset($this->requestBody->authorizationCode) ? $this->requestBody->authorizationCode : '';
		$cardBin = isset($this->requestBody->cardBin) ? $this->requestBody->cardBin : '';
		$cardLastDigits = isset($this->requestBody->cardLastDigits) ? $this->requestBody->cardLastDigits : '';
		$cvNumber = isset($this->requestBody->cvNumber) ? $this->requestBody->cvNumber : '';
		$installments = isset($this->requestBody->installments) ? $this->requestBody->installments : '';
		$brand = isset($this->requestBody->brand) ? $this->requestBody->brand : '';

		$cart['registerPayment'] = [
			'event' => $event,
			'result' => $result,
			'details' => $details,
			'amount' => $amount,
			'type' => $this->mapPOSPaymentType($type),
			'inputType' => $inputType,
			'nsu' => $nsu,
			'authorizationCode' => $authorizationCode,
			'cardBin' => $cardBin,
			'cardLastDigits' => $cardLastDigits,
			'cvNumber' => $cvNumber,
			'installments' => $installments,
			'brand' => $brand,
		];
		$this->session->set("cart", $cart);

		$this->response->setContent(json_encode(array(
			"success" => true,
			"message" => "Pagamento registrado"
		)));
		$this->response->send();
	}

	private function mapPOSPaymentType($paymentType) {
		/**
		 * A POS da PAGSEGURO considera os seguintes valores
		 * 02 - Débito  					--> 16
		 * 05 - PIX  						--> 25
		 * 11 - Crédito a vista				--> 15
		 * 12 - Crédito parcelado Lojista	--> 15
		 * 13 - Crédito parcelado Emissor	--> 15
		 */
		switch (intval($paymentType)) {
			case 2:
				return 16;	// Débito
			case 5:
				return 25;	// PIX
			case 11:
			case 12:
			case 13:
				return 15;	// Crédito
			default:
				$paymentTypes = $this->cartLib->getPaymentTypes();
				if (in_array(intval($paymentType), $paymentTypes)) {
					return intval($paymentType);
				} else {
					return 1;
				}
		}
	}

	public function checkoutAction()
	{

		$log = true;
		$request = print_r( $this->request->getRawBody() , true) ;
        $ip = $this->request->getClientAddress();
        $session = $this->session_id;
        $agent = $this->request->getUserAgent();

		if ( $log ) {
			$request = print_r( $this->request->getRawBody() , true) ;
			$sql = "
					 INSERT INTO _log_api (url,ip,session,agent,request)
                    VALUES ('api-cart/checkoutAction  Chegou no endpoint 1', ?, ?, ?, ?)
                    ";
            $this->db->execute($sql, array($ip, $session, $agent, $request) );
		}


		$events = isset($this->requestBody->events) ? $this->requestBody->events : '';
		$payment = isset($this->requestBody->payment) ? $this->requestBody->payment : '';

		if(!is_array($events) || empty($payment)) {


			if ( $log ) {
				$request = 'Missing parameters';
				$sql = "
						 INSERT INTO _log_api (url,ip,session,agent,request)
                    VALUES ('api-cart/checkoutAction 2', ?, ?, ?, ?)
                    ";
            	$this->db->execute($sql, array($ip, $session, $agent, $request) );
			}



			$this->response->setStatusCode(404, "Not Found");
			$this->response->setContent(json_encode("Missing parameters"));
			$this->response->send();
			return;
		}

		$this->cart['payment_set'] = $this->mapPOSPaymentType($payment);
		$cart = $this->cart;

		$totalProduct = 0;
		$events = $cart['event'];
			foreach($events as $event){
				$products = $event['products'];
				
				foreach($products as $product){
					foreach($product as $p){
						
						$sales = $this->cartLib->getTotalSalesEvent($p['id'], $event['event']);
							foreach($sales as $sale){
								if($sale['current_lot'] == $sale['lot_number'] && $sale['sales_limit'] > 0 && $sale['sales_limit'] != null){
									if($sale['sales'] > $sale['sales_limit'] && $sale['sales'] > $sale['fraction'] && $sale['sales'] > $sale['products_seats_count']){
										$totalProduct += 1;
									}
								}
							}

							if(isset($p['productsSeat'])){
								foreach($p['productsSeat'] as $ps){
									$this->db->execute(" UPDATE products_seats SET status = '4' WHERE id = '" . $ps->idProductSeat. "'");
								}
							}
					}
				}
			}
			
			if($totalProduct > 0){
				//$this->response->setContent(json_encode(array(
				//	"success" => false,
				//	"message" => "O carrinho possui ingressos esgotados"
				//)));
				//$this->response->send();
				//return;
			}

		$update_installments = '';
		$cardData = null;
		if (isset($cart['registerPayment'])) {
			$cart['payment_set'] = $this->mapPOSPaymentType($cart['registerPayment']['type']);
			$cardData['name'] = 'Comprador via POS';
			$cardData['number'] = $cart['registerPayment']['cardBin'] . '** **** ' . $cart['registerPayment']['cardLastDigits'];
			$cardData['expiration'] = '';
			$cardData['cvv'] = isset($cart['registerPayment']['cvNumber']) ? $cart['registerPayment']['cvNumber'] : '';
			$update_installments = ", installments = " . $cart['registerPayment']['installments'];
		}

		// Isso aqui pq tava aparecendo erro no log de variavel indefinida
		$cart['pdv'] = isset($cart['pdv']) ? $cart['pdv'] : null;
		$cart['pos'] = isset($cart['pos']) ? $cart['pos'] : null;
		$orderReturn = $this->cartLib->saveOrder($cart, $cart['pdv'], $cart['pos']);
		if(!$orderReturn['success']) {
			$this->response->setContent(json_encode(array(
				"success" => false,
				"message" => $orderReturn['message']
			)));

			if ( $log ) {
				$request = print_r( json_encode(array(
				"success" => false,
				"message" => $orderReturn['message']
				)) , true) ;
				$sql = "
						 INSERT INTO _log_api (url,ip,session,agent,request)
                    VALUES ('api-cart/checkoutAction 3', ?, ?, ?, ?)
                    ";
            	$this->db->execute($sql, array($ip, $session, $agent, $request) );
			}

			$this->response->send();
			return;
		}

		$orderPaymentReturn = $this->cartLib->saveOrderPayment($orderReturn['data']->id, $cardData, $cart['payment_set']);
		if(!$orderPaymentReturn['success']) {
			$this->response->setContent(json_encode(array(
				"success" => false,
				"message" => $orderPaymentReturn['message']
			)));

			if ( $log ) {
				$request = print_r( json_encode(array(
				"success" => false,
				"message" => $orderPaymentReturn['message']
				)) , true) ;
				$sql = "
						 INSERT INTO _log_api (url,ip,session,agent,request)
                    VALUES ('api-cart/checkoutAction 4', ?, ?, ?, ?)
                    ";
            	$this->db->execute($sql, array($ip, $session, $agent, $request) );
			}

			$this->response->send();
			return;
		} else {


			if ( $log ) {
				$request = " UPDATE sales SET id_payment_type = '" . $cart['payment_set'] . "' WHERE id_order = '" . $orderReturn['data']->id . "' " ;
				$sql = "
						 INSERT INTO _log_api (url,ip,session,agent,request)
                    VALUES ('api-cart/checkoutAction 5', ?, ?, ?, ?)
                    ";
            	$this->db->execute($sql, array($ip, $session, $agent, $request) );
			}

			// Atualiz a forma de pgto - TEM ALGO ERRADO AQUI, antes registrava e agora aprecisa fazer isso pq parou de savlar
			$this->db->execute(" UPDATE sales SET id_payment_type = '" . $cart['payment_set'] . "' WHERE id_order = '" . $orderReturn['data']->id . "' ");
			$this->db->execute(" UPDATE sales_items SET id_payment_type = '" . $cart['payment_set'] . "' WHERE id_order = '" . $orderReturn['data']->id . "' ");
		}

		
		
		if (isset($cart['registerPayment'])) {

			if ( $log ) {
				$request = 'savePOSOrderPayment($cart, $orderReturn[data]->id) ' ;
				$sql = "
						 INSERT INTO _log_api (url,ip,session,agent,request)
                    VALUES ('api-cart/checkoutAction 6', ?, ?, ?, ?)
                    ";
            	$this->db->execute($sql, array($ip, $session, $agent, $request) );
			}

			$this->savePOSOrderPayment($cart, $orderReturn['data']->id);
		}

		$sql = "UPDATE orders SET
			id_orders_payment_status = 3,
			id_orders_status = 2
			$update_installments
			WHERE id = " . $orderReturn['data']->id;  // Received => Recebimento do pedido concluido
		$this->db->execute($sql);

		$value_total = isset($this->requestBody->value_total) ? $this->requestBody->value_total : '';
		$value_tax = isset($this->requestBody->value_tax) ? $this->requestBody->value_tax : '';


		if(!empty($value_total) && !empty($value_tax)){
			$sql = "SELECT * FROM sales_items WHERE id_order = '" . $orderReturn['data']->id . "'";
			$query_result = $this->db->fetchAll($sql);
			$value_fee_total = 0;
			foreach($query_result as $s){
				$value_fee_total = $value_fee_total + $s['value_fee'];
			}

			$sql = "SELECT * FROM fee_pgseg WHERE installment = '" . $cart['registerPayment']['installments'] . "'";
			$feePgseg = $this->db->fetchOne($sql);
			$costFee = 0;
			if(isset($feePgseg) && $orderReturn['data']->id_payment_type == 15){
				$costFee = ($value_total * $feePgseg['fee']) / 100;
			}

			$paymentT = $orderReturn['data']->id_payment_type;
			if($value_total == 0){
				$paymentT = 7;
			}

$this->db->execute(" UPDATE orders SET id_orders_status = '2', id_orders_payment_status = '3', value_total = '".$value_total."', value_tax = '".$value_tax."', id_payment_type = '".$paymentT."' WHERE id = '" . $orderReturn['data']->id . "' ");
			$this->db->execute(" UPDATE sales SET status = 4, value_total = '".$value_total."', value_interest = '".$value_tax."', value_fee = '".$value_fee_total."', id_payment_type = '".$paymentT."', cost_fee = '".$costFee."'".$update_installments." WHERE id_order = '" . $orderReturn['data']->id . "' ");
			$this->db->execute(" UPDATE sales_items SET status = 1, id_payment_type = '".$paymentT."' WHERE id_order = '" . $orderReturn['data']->id . "' ");
		}


			if ( $log ) {
				$request = $sql ;
				$sql = "
						 INSERT INTO _log_api (url,ip,session,agent,request)
                    VALUES ('api-cart/checkoutAction 7', ?, ?, ?, ?)
                    ";
            	$this->db->execute($sql, array($ip, $session, $agent, $request) );
			}



		// Agora limpa o carrinho - Finalizou a compra
		$this->db->execute("DELETE FROM cart WHERE customer_session = '{$cart['customer_session']}' ");

		$this->session->remove("cart");

		$this->response->setContent(json_encode(array(
			"success" => true,
			"order" => $orderReturn['data']->id,
			"seller" => $cart['seller']
		)));


		if ( $log ) {
			$request = print_r( json_encode(array(
				"success" => true,
				"order" => $orderReturn['data']->id,
				"seller" => $cart['seller']
			)) , true) ;
			$sql = "
					 INSERT INTO _log_api (url,ip,session,agent,request)
					VALUES ('api-cart/checkoutAction  8', ?, ?, ?, ?)
					";
            $this->db->execute($sql, array($ip, $session, $agent, $request) );
		}


		$this->response->send();
	}

	public function createAction()
	{

		$log = true;
		$request = print_r( $this->request->getRawBody() , true) ;
        $ip = $this->request->getClientAddress();
        $session = $this->session_id;
        $agent = $this->request->getUserAgent();

		if ( $log ) {
			$request = print_r( $this->request->getRawBody() , true) ;
			$sql = "
					 INSERT INTO _log_api (url,ip,session,agent,request)
                    VALUES ('api-cart/checkoutAction  Chegou no endpoint 1', ?, ?, ?, ?)
                    ";
            $this->db->execute($sql, array($ip, $session, $agent, $request) );
		}


		$events = isset($this->requestBody->events) ? $this->requestBody->events : '';
		$payment = isset($this->requestBody->payment) ? $this->requestBody->payment : '';

		if(!is_array($events) || empty($payment)) {
			if ( $log ) {
				$request = 'Missing parameters';
				$sql = "
						 INSERT INTO _log_api (url,ip,session,agent,request)
                    VALUES ('api-cart/checkoutAction 2', ?, ?, ?, ?)
                    ";
            	$this->db->execute($sql, array($ip, $session, $agent, $request) );
			}

			$this->response->setStatusCode(404, "Not Found");
			$this->response->setContent(json_encode("Missing parameters"));
			$this->response->send();
			return;
		}

		$this->cart['payment_set'] = $this->mapPOSPaymentType($payment);
		$cart = $this->cart;

		$totalProduct = 0;
		$events = $cart['event'];
			foreach($events as $event){
				$products = $event['products'];
				
				foreach($products as $product){
					foreach($product as $p){
						
						$sales = $this->cartLib->getTotalSalesEvent($p['id'], $event['event']);
							foreach($sales as $sale){
								if($sale['current_lot'] == $sale['lot_number'] && $sale['sales_limit'] > 0 && $sale['sales_limit'] != null){
									if($sale['sales'] > $sale['sales_limit'] && $sale['sales'] > $sale['fraction'] && $sale['sales'] > $sale['products_seats_count']){
										$totalProduct += 1;
									}
								}
							}
					}
				}
			}
			
			if($totalProduct > 0){
				//$this->response->setContent(json_encode(array(
				//	"success" => false,
				//	"message" => "O carrinho possui ingressos esgotados"
				//)));
				//$this->response->send();
				//return;
			}

		$update_installments = '';
		$cardData = null;
		if (isset($cart['registerPayment'])) {
			$cart['payment_set'] = $this->mapPOSPaymentType($cart['registerPayment']['type']);
			$cardData['name'] = 'Comprador via POS';
			$cardData['number'] = $cart['registerPayment']['cardBin'] . '** **** ' . $cart['registerPayment']['cardLastDigits'];
			$cardData['expiration'] = '';
			$cardData['cvv'] = isset($cart['registerPayment']['cvNumber']) ? $cart['registerPayment']['cvNumber'] : '';
			$update_installments = ", installments = " . $cart['registerPayment']['installments'];
		}

		// Isso aqui pq tava aparecendo erro no log de variavel indefinida
		$cart['pdv'] = isset($cart['pdv']) ? $cart['pdv'] : null;
		$cart['pos'] = isset($cart['pos']) ? $cart['pos'] : null;
		$orderReturn = $this->cartLib->saveOrderCreate($cart, $cart['pdv'], $cart['pos']);
		if(!$orderReturn['success']) {
			$this->response->setContent(json_encode(array(
				"success" => false,
				"message" => $orderReturn['message']
			)));

			if ( $log ) {
				$request = print_r( json_encode(array(
				"success" => false,
				"message" => $orderReturn['message']
				)) , true) ;
				$sql = "
						 INSERT INTO _log_api (url,ip,session,agent,request)
                    VALUES ('api-cart/checkoutAction 3', ?, ?, ?, ?)
                    ";
            	$this->db->execute($sql, array($ip, $session, $agent, $request) );
			}

			$this->response->send();
			return;
		}

		$orderPaymentReturn = $this->cartLib->saveOrderPayment($orderReturn['data']->id, $cardData, $cart['payment_set']);
		if(!$orderPaymentReturn['success']) {
			$this->response->setContent(json_encode(array(
				"success" => false,
				"message" => $orderPaymentReturn['message']
			)));

			if ( $log ) {
				$request = print_r( json_encode(array(
				"success" => false,
				"message" => $orderPaymentReturn['message']
				)) , true) ;
				$sql = "
						 INSERT INTO _log_api (url,ip,session,agent,request)
                    VALUES ('api-cart/checkoutAction 4', ?, ?, ?, ?)
                    ";
            	$this->db->execute($sql, array($ip, $session, $agent, $request) );
			}

			$this->response->send();
			return;
		} else {


			if ( $log ) {
				$request = " UPDATE sales SET id_payment_type = '" . $cart['payment_set'] . "' WHERE id_order = '" . $orderReturn['data']->id . "' " ;
				$sql = "
						 INSERT INTO _log_api (url,ip,session,agent,request)
                    VALUES ('api-cart/checkoutAction 5', ?, ?, ?, ?)
                    ";
            	$this->db->execute($sql, array($ip, $session, $agent, $request) );
			}

			// Atualiz a forma de pgto - TEM ALGO ERRADO AQUI, antes registrava e agora aprecisa fazer isso pq parou de savlar
			$this->db->execute(" UPDATE sales SET id_payment_type = '" . $cart['payment_set'] . "' WHERE id_order = '" . $orderReturn['data']->id . "' ");
			$this->db->execute(" UPDATE sales_items SET id_payment_type = '" . $cart['payment_set'] . "' WHERE id_order = '" . $orderReturn['data']->id . "' ");
		}

		if (isset($cart['registerPayment'])) {

			if ( $log ) {
				$request = 'savePOSOrderPayment($cart, $orderReturn[data]->id) ' ;
				$sql = "
						 INSERT INTO _log_api (url,ip,session,agent,request)
                    VALUES ('api-cart/checkoutAction 6', ?, ?, ?, ?)
                    ";
            	$this->db->execute($sql, array($ip, $session, $agent, $request) );
			}

			$this->savePOSOrderPayment($cart, $orderReturn['data']->id);
		}

			if ( $log ) {
				$request = $sql ;
				$sql = "
						 INSERT INTO _log_api (url,ip,session,agent,request)
                    VALUES ('api-cart/checkoutAction 7', ?, ?, ?, ?)
                    ";
            	$this->db->execute($sql, array($ip, $session, $agent, $request) );
			}

		$this->response->setContent(json_encode(array(
			"success" => true,
			"order" => $orderReturn['data']->id,
			"seller" => $cart['seller']
		)));


		if ( $log ) {
			$request = print_r( json_encode(array(
				"success" => true,
				"order" => $orderReturn['data']->id,
				"seller" => $cart['seller']
			)) , true) ;
			$sql = "
					 INSERT INTO _log_api (url,ip,session,agent,request)
					VALUES ('api-cart/checkoutAction  8', ?, ?, ?, ?)
					";
            $this->db->execute($sql, array($ip, $session, $agent, $request) );
		}


		$this->response->send();
	}

	protected function addProduct($event = 0, $product = array())
	{
		$cart = $this->cart;
		$cart['event'][$event]['event'] = $event;
		$cart['event'][$event]['max_installment_without_interest'] = $product['max_installment_without_interest'];
		$cart['event'][$event]['max_installment_with_interest'] = $product['max_installment_with_interest'];
		$cart['event'][$event]['event_name'] = $product['event_name'];
		$cart['event'][$event]['event_delivery'] = $product['delivery'];
		$cart['event'][$event]['products'][$product['id']][$product['id_type']] = $product;
		$this->cart = $cart;
		$this->session->set("cart", $cart);
	}

	private function savePOSOrderPayment($cart, $id_order)
	{
		$amount = $cart['registerPayment']['amount'];
		$id_payment_type = $cart['registerPayment']['type'];
		$cc_authcode = $cart['registerPayment']['authorizationCode'];
		$cc_transactionid = $cart['registerPayment']['nsu'];
		$cc_response = $cart['registerPayment']['details'];

		$cc_name = 'Comprador via POS';
		$cc_number = $cart['registerPayment']['cardBin'] . '** **** ' . $cart['registerPayment']['cardLastDigits'];

		$sql = "UPDATE orders_payment SET
			amount = $amount,
			id_payment_type = $id_payment_type,
			cc_authcode = '$cc_authcode',
			cc_transactionid = '$cc_transactionid',
			cc_response = '$cc_response'
			WHERE id_order = $id_order
			AND cc_number = '$cc_number'
			AND cc_name = '$cc_name'
			;";

		$this->db->execute($sql);
	}
	
	public function savefaturaAction(){
		$idOrder = isset($this->requestBody->idOrder) ? $this->requestBody->idOrder : null;
		$name = isset($this->requestBody->name) ? $this->requestBody->name : null;
		$nif = isset($this->requestBody->nif) ? $this->requestBody->nif : null;
		$morada = isset($this->requestBody->morada) ? $this->requestBody->morada : null;
		$email = isset($this->requestBody->email) ? $this->requestBody->email : null;
		
		if(isset($idOrder) && isset($name) && isset($nif) && isset($morada) && isset($email)){
			$sales = Sales::findFirst('id_order = ' . $idOrder);
			if($sales){
				//if($sales->id_event == 64 || $sales->id_event == 1 || $sales->id_event == 785){
					$newCustomer = new CustomerSaft();
					$newCustomer->name = $name;
					$newCustomer->nif = $nif;
					$newCustomer->morada = $morada;
					$newCustomer->id_order = $idOrder;
					$newCustomer->email = $email;
					
					if($newCustomer->save()){
						$url = $this->di->get('urlSup') . 'cron_saft/processNew/' . $sales->id;
						$sendFatura = "wget ". $url . "  > /dev/null &";
						$exec = exec($sendFatura);

						$this->response->setContent(json_encode(array(
							"success" => true,
							"msg" => 'Fatura enviada com sucesso'
						)));
					}else{
						$this->response->setContent(json_encode(array(
							"success" => false,
							"msg" => 'Erro ao salvar customer saft'
						)));
					}
				//}
			}else{
				$this->response->setContent(json_encode(array(
					"success" => false,
					"msg" => 'Sales não encontrada'
				)));
			}
			


		}else{	
			$this->response->setContent(json_encode(array(
				"success" => false,
				"msg" => 'Favor preencher todos os campos'
			)));
		}

		$this->response->send();
		return;
	}
}
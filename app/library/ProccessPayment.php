<?php
use Phalcon\Mvc\User\Component;


class ProccessPayment extends Component
{
	private $order = null;

	public function proccess($id_order = false)
	{
		$result = false;
		$order = false;

		if ( $id_order ) {
			$order = Orders::findFirst(
				[
					"id = :id: ",
					"bind" => [
						"id"    => $id_order
					]
				]
			);
		}


		if ( $order AND  $order->id_payment_type == 2 )
		{
			$result = $this->CreditCard($order);
		} else {
			// Se nao for cartao
			// É dinheiro  ou cortesia
			// Entao ja muda pra retorna OK
			$result = array(
						"success" => true,
						"response_code" => 100 // Mesmo numero do cartao quando é autorizado
					);
		}



		return $result;

	}




	/**
	* Processa transacoes de cartao de credito com o OnePayment
	* https://secure.networkmerchants.com/gw/merchants/resources/integration/integration_portal.php#integration_overview
	*/
	private function CreditCard($order)
	{
		$gw = new gwapi;
		// function setLogin($username, $password) {
		//$gw->setLogin("demo", "password");
		$gw->setLogin("tiktx", "Alc2xpd9");

		$orderid = $order->id;
		$orderdescription = 'Order in TiktX';
		//$tax = 0;
		$shipping = 0;
		$ponumber = 0;
		$ipaddress = $_SERVER['REMOTE_ADDR'];
		$amount = $order->value_total;
		$tax = $order->value_tax;

		if ( isset($order->send_to_email) AND $order->send_to_email ) {
			//$firstname = $order->send_to_email;
			$email = $order->send_to_email;
		} else {
			//$firstname = $order->Customers->name;
			$email = $order->Customers->email;
		}


		// Isto aqui, pq uma ORDER pode ter mais de uma ORDERSxPAYMENT (ou nao??) ai pego o primeiro registro
		$OrdersPayment = $order->OrdersPayment;
		$OrderPayment = $OrdersPayment[0];
		$ccnumber = preg_replace('/\s+/', '', $OrderPayment->cc_number);
		$ccexp = preg_replace('/\s+/', '', $OrderPayment->cc_expiration);
		$cvv = preg_replace('/\s+/', '', $OrderPayment->cc_cvv);




		$billing_address = isset($order->CustomerBillingAddress) ? $order->CustomerBillingAddress : false;
		if ( $billing_address ) {
			$billing_address = $billing_address->toArray();
			$full_name = $billing_address['name'];
			$firstname = $full_name;
			$phone = isset($billing_address['phone']) ? $billing_address['phone'] : null;
			$address1 = $billing_address['address_1'];
			$address2 = $billing_address['address_2'];
			$city = $billing_address['city'];
			$state = $billing_address['region'];
			$country = $billing_address['country'];
			$zip = $billing_address['zipcode'];
		} else {
			$billing_address = (array)json_decode($order->billing_address);
			if ( is_array($billing_address) ) {
				$full_name = $billing_address['full_name'];
				$firstname = $full_name;
				$phone = isset($billing_address['phone']) ? $billing_address['phone'] : null;
				$address1 = $billing_address['address_1'];
				$address2 = $billing_address['address_2'];
				$city = $billing_address['city'];
				$state = $billing_address['region'];
				$country = $billing_address['country'];
				$zip = $billing_address['zip'];
			}
		}

		/*********
		Qdo nao tiver os dados de BILLING ADDRESS, seta como 0, pq o gateway exige os dados, mas aparentemente não valida
		*********/
		if ( !isset($firstname) OR strlen($firstname) < 2  ) $firstname = $OrderPayment->cc_name;
		if ( !isset($firstname) OR strlen($firstname) < 2  ) $firstname = 'Titkx - Compra sem cadastro';
		if ( !isset($address1) OR strlen($address1) < 2  ) $address1 = '0';
		if ( !isset($address2) OR strlen($address2) < 2  ) $address2 = '0';
		if ( !isset($city) OR strlen($city) < 2  ) $city = '0';
		if ( !isset($state) OR strlen($state) < 2  ) $state = '0';
		if ( !isset($zip) OR strlen($zip) < 2  ) $zip = '0';
		if ( !isset($country) OR strlen($country) < 2  ) $country = '0';
		if ( !isset($phone) OR strlen($phone) < 2  ) $phone = '0';
		if ( !isset($email) OR strlen($email) < 2  ) $email = '0';



		// function setBilling($firstname, $lastname, $company, $address1, $address2, $city, $state, $zip, $country, $phone, $fax, $email, $website)
		$gw->setBilling($firstname, null, null, $address1, $address2, $city, $state, $zip, $country, $phone, null, $email, null);
		//$gw->setBilling("John","Smith","Acme, Inc.","123 Main St","Suite 200", "Beverly Hills", "CA","90210","US","555-555-5555","555-555-5556","support@example.com","www.example.com");

		// function setShipping($firstname, $lastname, $company, $address1, $address2, $city, $state, $zip, $country, $email)
		$gw->setShipping($firstname, null, null, $address1, $address2, $city, $state, $zip, $country, $email);
		//$gw->setShipping("Mary","Smith","na","124 Shipping Main St","Suite Ship", "Beverly Hills","CA","90210","US","support@example.com");

		// function setOrder($orderid, $orderdescription, $tax, $shipping, $ponumber, $ipaddress)
		$gw->setOrder($orderid, $orderdescription, $tax, $shipping, $ponumber, $ipaddress);
		//$gw->setOrder("1234","Big Order",1, 2, "PO1234","65.192.14.10");



		// function doSale($amount, $ccnumber, $ccexp, $cvv="")
		$r = $gw->doSale($amount, $ccnumber, $ccexp, $cvv);
		//$r = $gw->doSale("50.00","4111111111111111","1010");

		$result = $gw->responses;

		// Qdo aprovado, altera o status da ORDER e oculta os digitos do cartao pra caso de segurança
		if ( $result['response_code'] == 100 )
		{
			$OrderPayment->updated_at = date('Y-m-d H:i:s');

			$OrderPayment->status = 2;

			$sql = " UPDATE orders SET id_orders_payment_status = 3 WHERE id = " . $order->id;  // Payment received
		} else {
			$sql = " UPDATE orders SET id_orders_payment_status = 7 WHERE id = " . $order->id;   // Error - Erro na transação
		}
		$this->db->execute($sql);

		$OrderPayment->cc_number = $this->maskCreditCard($OrderPayment->cc_number);  // Mantem os 4 primeiros e 4 ultimos digitos, oculta o resto
		$OrderPayment->cc_cvv = '***'; // Oculta o CVV

	    $OrderPayment->cc_authcode = $result['authcode'];
	    $OrderPayment->cc_transactionid = $result['transactionid'];
		$OrderPayment->cc_response = json_encode($result);
		$OrderPayment->updated_at = date('Y-m-d H:i:s');
		$OrderPayment->save();



		$LogOrderProccessPayment = new LogOrderProccessPayment();
		$LogOrderProccessPayment->id_order = $order->id;
		$LogOrderProccessPayment->id_orders_payment = $OrderPayment->id;
		$LogOrderProccessPayment->response = print_r($result, true);
		$LogOrderProccessPayment->obs = 'Transacionado pelo ProccessPayment';
		$LogOrderProccessPayment->created_at = date('Y-m-d H:i:s');
		$LogOrderProccessPayment->save();


		// echo '<pre>';
		// print_r( $gw->responses);
		// echo '</pre>';
		return $result;
	}


	function maskCreditCard($cc) {

		$cc_length = strlen($cc);

		for ($i = 6; $i < $cc_length - 4; $i++) {
			if ($cc[$i] == '-' OR $cc[$i] == ' ') {
				continue;
			}
			$cc[$i] = '*';
		}
		return $cc;
	}
}
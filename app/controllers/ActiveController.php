<?php
class ActiveController extends ControllerBase
{
	private $customer = null;



	public function onConstruct()
	{

		// Verifica se esta logado - PROTEÇÃO!!!
		$customer = $this->session->get('customer');
		if ( !$customer )
		{

				$action = $this->dispatcher->getActionName();
				if ( !in_array( $action, array('login') )  )
				{
					return $this->response->redirect('account/login')->send();
					return false;
					return;
					exit();
				}
		}
		$this->customer = $customer;
		$this->view->customer =  $customer;

	}



	public function orderAction($id_order = null)
	{
		$CartLib = new CartLib();
		$order = $CartLib->getOrder($id_order, $this->customer->id);
		//public function getOrder($id_order = null, $id_user = null)




		if ( $order AND  $order->id == $id_order )
		{


			if ( $this->request->isPost() )
			{
				$post_value = trim($this->request->getPost('post_value'));
				if ( $post_value AND strlen($post_value) > 1 )
				{
					$value_active = trim($this->request->getPost('value_active'));
					if ( $value_active AND $value_active > 0 )
					{
						$orderActive = OrdersActive::findFirst(array(" id_order = $id_order ", 'order' => 'finished_in ASC'));
						$orderActive->attempts =  ( $orderActive->attempts + 1 );
						$orderActive->save();

						// Para tratar o valor e comprar
						$value_active = preg_replace('/[^0-9]/', '', $value_active);
						$amount = preg_replace('/[^0-9]/', '', $orderActive->amount);
						if ( $value_active == $amount )
						{

							$data['orderActive'] = $orderActive;
							$data['order'] = $order;
							if ( $this->confirmPagSeguro($data) )
							{
								// Cancelar o pgto e ativar a conta deu certo
								// Direciona para a compra
								$this->flashSession->success($this->t->_('The purchase was successfully validated'));
								return $this->response->redirect("account/order/$id_order")->send();
							}


						} else { // if ( $value_active == $orderActive->value_active )
							$this->flashSession->error($this->t->_('The value entered is incorrect'));
						}

					} else { // if ( $value_active AND strlen($value_active) > 2 )
						$this->flashSession->error($this->t->_('Enter the value'));
					}
				} // if ( $post_value AND strlen($post_value) > 1 )


				$post_cvv = trim($this->request->getPost('post_cvv'));
				if ( $post_cvv AND strlen($post_cvv) > 1 )
				{
					$cc_cvv = trim($this->request->getPost('cc_cvv'));
					if ( $cc_cvv AND strlen($cc_cvv) > 2 )
					{
						$value_active = number_format(mt_rand(1, 9) . '.' .  mt_rand(0, 100), 2);
						$data['value_active'] = $value_active;

						$data['order'] = $order;
						$data['cc_cvv'] = $cc_cvv;

						if ( $this->paymentPagSeguro($data) )
						{
							$this->flashSession->success('Informe qual foi o valor');
							//$this->flashSession->success($this->t->_('The purchase was successfully validated'));
						}

					} else { // if ( $cc_cvv AND strlen($cc_cvv) > 2 )
						$this->flashSession->error($this->t->_('Enter the entire code'));
					}
				} // if ( $post_cvv AND strlen($cc_cvv) > 1 )


			}


			$this->view->order = $order;

			$orderActive = OrdersActive::findFirst(array(" id_order = $id_order ", 'order' => 'finished_in ASC'));
			$this->view->orderActive = $orderActive;




		} else
		{
			$this->flashSession->error($this->t->_('Order not found'));
			return $this->dispatcher->forward(array(
				"controller" => "account",
				"action" => "orders"
			));
		}
	}











	private function confirmPagSeguro($data = array() )
	{

		$order = $data['order'];
		$id_order = $order->id;
		$orderActive = $data['orderActive'];
		$amount = $orderActive->amount;
		$payment_id = $orderActive->cc_transactionid;

		$post = json_encode(array(
			  "amount" => [
			    "value" =>  (int) str_replace('.', '', $amount)
			  ]
			));


		$url = "https://api.pagseguro.com/charges/$payment_id/cancel";
		$token = '42ffe103-095b-43ef-b8da-a4877340fa0beeba28664436bc8afeb3d31f01b153318c47-5320-40f7-9188-9c182cce0f90';

		$header = array();
		$header[] = 'Cache-Control: no-cache';
		$header[] = 'Content-Type: application/json';
		$header[] = "Authorization: Bearer " . $token;
		$header[] = "x-api-version: 4.0";

		$curl = curl_init();
		curl_setopt($curl, CURLOPT_URL, $url);
		curl_setopt($curl, CURLOPT_HTTPHEADER, $header);
        curl_setopt($curl, CURLOPT_POST, true);
		curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($curl, CURLOPT_MAXREDIRS, 10);
		curl_setopt($curl, CURLOPT_TIMEOUT, 30);
		curl_setopt($curl, CURLOPT_FOLLOWLOCATION, true);
		curl_setopt($curl, CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_1_1);
		curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "POST");
		curl_setopt($curl, CURLOPT_POSTFIELDS, $post);

		curl_setopt($curl, CURLOPT_HEADER, 0);
		curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, 0);



		$return = json_decode(curl_exec($curl), true, 512, JSON_BIGINT_AS_STRING);
		$response['curl'] = $return;


		$LogOrderProccessPayment = new LogOrderProccessPayment();
		$LogOrderProccessPayment->id_order = $order->id;
		$LogOrderProccessPayment->response = print_r($response, true);
		$LogOrderProccessPayment->obs = 'ActiveController - confirmPagSeguro';
		$LogOrderProccessPayment->created_at = date('Y-m-d H:i:s');
		$LogOrderProccessPayment->save();


		// Verifica se houve erros e exibe a mensagem de erro
		if($errno = curl_errno($curl)) {
			$error_message = curl_strerror($errno);
			$info['curl_errno'] =  "cURL error ({$errno}):\n {$error_message}";
		}


		$info['curl_error'] =  curl_error($curl);
		$info['info'] =  curl_getinfo($curl);
		//$info['header'] = curl_getinfo($curl, CURLINFO_HEADER_OUT);
		//$info['url'] = $url;
		$info['headers'] = $headers;
		$info['dados'] = $post;
		$response['info'] = $info;


		curl_close($curl);
		// Cancelou com sucesso
		if ( isset($response['curl']['status']) AND $response['curl']['status'] == 'CANCELED'  ) {



			$sql = " UPDATE orders SET id_orders_status = 2 WHERE id = '$id_order' LIMIT 1";
			$this->db->execute($sql);

			$sql = " UPDATE sales SET status = 4 WHERE id_order = '$id_order' ";
			$this->db->execute($sql);

			/* LOG no TICKET */
			$now = date('Y-m-d H:i:s');
			$sql_tmp = "
				INSERT INTO ticket_log (id_event, ticket, status, info, created_at)
				SELECT si.id_event, si.ticket, null, 'Análise aprovada com teste no cartão', '$now'  FROM sales_items si WHERE si.id_sale IN (SELECT id FROM sales WHERE id_order = '$id_order');";
			$this->db->execute($sql_tmp);



			$orderActive->cc_response = print_r($response, true);
			$orderActive->finished_in = date('Y-m-d H:i:s');

			if ( $orderActive->save() )
			{
				return true;
			}

		} else {
			$this->flashSession->error($this->t->_('Failed to cancel test value'));
		}


		return false;
	}












	private function paymentPagSeguro($data = array() )
	{
		$order = $data['order'];
		$cc_cvv = $data['cc_cvv'];
		$value_active = $data['value_active'];


		$payment = $order->OrdersPayment;
		$payment = $payment[0];

		$cc_name = $payment->cc_name;
		$cc_number = preg_replace('/\s+/', '', $payment->cc_number);
		$cc_expiration = $payment->cc_expiration;

		$expiration_date = explode('/', $cc_expiration);
		$expiration_month = trim($expiration_date[0]);
		$expiration_year = trim($expiration_date[1]);
		if ( strlen($expiration_year) == 2 ) {
			$expiration_year = '20' . $expiration_year;
		}



		$post = json_encode(array(
			"reference_id" => $order->id,
			"description" => "Ativar Pedido #" . $order->id,
			"amount" => [
				"value" => str_replace('.', '', $value_active),
				"currency" => "BRL"
			],
			"payment_method" => [
				"type" => "CREDIT_CARD",
				"installments" => 1,
				"capture" => true,
				"card" => [
					"number" => $cc_number,
					"exp_month" => $expiration_month,
					"exp_year" => $expiration_year,
					"security_code" => preg_replace('/\s+/', '', $cc_cvv),
					"holder" => [
						"name" => $cc_name
					]
				]
			]
		));


		$url_api = 'https://api.pagseguro.com/charges';
		$token = '42ffe103-095b-43ef-b8da-a4877340fa0beeba28664436bc8afeb3d31f01b153318c47-5320-40f7-9188-9c182cce0f90';

		$header = array();
		$header[] = 'Cache-Control: no-cache';
		$header[] = 'Content-Type: application/json';
		$header[] = "Authorization: Bearer " . $token;
		$header[] = "x-api-version: 1.0";

		$curl = curl_init();
		curl_setopt($curl, CURLOPT_URL, $url_api);
		curl_setopt($curl, CURLOPT_HTTPHEADER, $header);
	    curl_setopt($curl, CURLOPT_POST, true);
		curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($curl, CURLOPT_MAXREDIRS, 10);
		curl_setopt($curl, CURLOPT_TIMEOUT, 30);
		curl_setopt($curl, CURLOPT_FOLLOWLOCATION, true);
		curl_setopt($curl, CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_1_1);
		curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "POST");
		curl_setopt($curl, CURLOPT_POSTFIELDS, $post);

		curl_setopt($curl, CURLOPT_HEADER, 0);
		curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, 0);

		$body = curl_exec($curl);

		// Verifica se houve erros e exibe a mensagem de erro
		if($errno = curl_errno($curl)) {
			$error_message = curl_strerror($errno);
			$body .= "cURL error ({$errno}):\n {$error_message}";
		}
		curl_close($curl);
		$result = json_decode($body, true);


		$LogOrderProccessPayment = new LogOrderProccessPayment();
		$LogOrderProccessPayment->id_order = $order->id;
		$LogOrderProccessPayment->response = print_r($result, true);
		$LogOrderProccessPayment->obs = 'ActiveController - paymentPagSeguro';
		$LogOrderProccessPayment->created_at = date('Y-m-d H:i:s');
		$LogOrderProccessPayment->save();


		if ( isset($result['status']) AND $result['status'] == 'PAID' )
		{
			$cc_authcode = $result['payment_response']['reference'];
			$cc_transactionid = $result['id'];

			$orderActive = new OrdersActive();
			$orderActive->id_order = $order->id;
			$orderActive->amount = $value_active;
			$orderActive->cc_authcode = $cc_authcode;
			$orderActive->cc_transactionid = $cc_transactionid;
			$orderActive->cc_response = print_r($result, true);
			$orderActive->created_at = date('Y-m-d H:i:s');

			if ( $orderActive->save() )
			{
				return true;

			} else {
				$this->flashSession->error('Erro ao salvar a operação');
				foreach ($customer->getMessages() as $message) {
					$this->flashSession->error($message);
				}
			}


		} else {
			// Nao processou o pgto
			$error_messages = 'Erro na transação com o gateway de pagamento. Tente com outro cartão ou repita a operação mais tarde.';
			if ( isset($result['payment_response']['message']) )
			{
				$error_messages = $result['payment_response']['message'];
			} else if ( isset($result['error_messages']['message']) )
			{
				$error_messages = $result['error_messages']['message'];
			}
			$this->flashSession->error($error_messages);

		}

		return false;
	}



}
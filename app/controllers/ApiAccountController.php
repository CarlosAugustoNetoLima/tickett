<?php

use Phalcon\Http\Response;

class ApiAccountController extends ApiControllerBase
{
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
	}

    public function loginAction()
    {
        $email = isset($this->requestBody->email) ? $this->requestBody->email : '';
        $password = isset($this->requestBody->password) ? $this->requestBody->password : '';

        if(empty($email) || empty($password)) {
            $this->response->setStatusCode(404, "Not Found");
            $this->response->setContent(json_encode("Missing parameters"));
            $this->response->send();
            return;
        }

        $customerLib = new CustomerLib();
        $customer = $customerLib->login($email, $password);

        if(!$customer) {
            $this->response->setContent(json_encode(array(
                "success" => false,
                "message" => "Login ou senha incorretos"
            )));
            $this->response->send();
            return;
        }

        $this->session->set("customer", $customer);

        $this->response->setContent(json_encode(array(
            "success" => true,
            "session" => session_id(),
            "customer" => $this->session->get('customer')->id,
            "message" => "login efetuado com sucesso"
        )));
        $this->response->send();
    }

    public function logoutAction()
    {
        $this->session->remove("customer");
        $this->session->remove("cart");
    }

    public function remember_passwordAction()
	{
        $email = isset($this->requestBody->email) ? $this->requestBody->email : '';
        $customer = Customers::findFirstByEmail($email);

        if (!$customer) {
            $this->response->setContent(
                json_encode(array("success" => false))
            );
            $this->response->send();
        }

        $param = array('customer' => $customer );

        //function send($to, $subject, $template, $params)
        $sendMail = $this->getDI()->getMail()->send(
            array($email => $customer->name),
            $this->config->company->full_name . ' | Senha de acesso', // assunto
            'password-recovery', // template
            $param
        );

        if (!$sendMail ) {
            $this->response->setContent(
                json_encode(array("success" => false))
            );
            $this->response->send();
            return;
        }

        $this->response->setContent(
            json_encode(array("success" => true))
        );
        $this->response->send();
	}

    public function orderAction($id_order)
    {

        $log = true;
        $request = print_r( $this->request->getRawBody() , true) ;
        $ip = $this->request->getClientAddress();
        $session = $this->session_id;
        $agent = $this->request->getUserAgent();
        $valueFee = isset($_GET['valueFee']) ? $_GET['valueFee'] : 0;
        $orderStatus = isset($_GET['orderStatus']) ? $_GET['orderStatus'] : 2;

        if ( $log ) {
            $sql = "
                    INSERT INTO _log_api (url,ip,session,agent,request)
                    VALUES ('api-account/orderAction  Chegou no endpoint 1', ?, ?, ?, ?)
                    ";
            $this->db->execute($sql, array($ip, $session, $agent, $request) );
        }


        $cartLib = new CartLib();
        $cart = $this->session->get('cart');

        if (isset($this->customer)) {
            $order = $cartLib->getOrder($id_order, $this->customer->id);
        } else if ( isset($this->seller) )  {
            $order = $cartLib->getOrderByTerminal($id_order, $this->seller->id);
        } else {
            //  esse ELSE foi pq alguma merda ocorre na requisição do APP e faz perder a sessão, logo nao tem o $customer nem $seller
            $order = $cartLib->getOrder($id_order);
        }

        if(!isset($order->sales)) {


            if ( $log ) {
                $customer = isset($this->customer) ? $this->customer->id : ' null ' ;
                $seller = isset($this->seller) ? $this->seller->id : ' null ' ;
                $request = "Pedido $id_order não encontrado : Customer $customer / Seller: $seller ";
                $sql = "
                        INSERT INTO _log_api (url,ip,session,agent,request)
                        VALUES ('api-account/orderAction  2', ?, ?, ?, ?)
                        ";
                    $this->db->execute($sql, array($ip, $session, $agent, $request) );
            }


            $this->response->setContent(
                json_encode(array(
                "success" => false,
                "message" => "Pedido não encontrado"
            )));
            $this->response->send();
            return;
        }

        if($order->send_to_email && $order->email_sent == 0) {
            $url = $this->url->get() . "cron/send_email_order/" . $order->id;
            $commandExec = "wget ". $url . "  > /dev/null &";
			exec($commandExec);
        } else if($order->send_to_whatsapp && $order->whatsapp_sent == 0) {
            $url = $this->url->get() . "cron/send_whatsapp_order/" . $order->id;
            $commandExec = "wget ". $url . "  > /dev/null &";
			exec($commandExec);
        }

        $order->sales = $order->OrderSale;
        $tickets = array();

        foreach ($order->OrderSale as $sale) {
            $sale = $sale->Sales;
            foreach($sale->SalesItems as $product) {
                $value = $product->value_product +
                        $product->value_product_tax +
                        $product->value_fee +
                        $product->value_fee_tax +
                        $product->value_fee_org +
                        $product->value_fee_org_tax;

                $images = [];
                foreach($sale->Events->EventsImages as $image) {
                    $images[] = "img/shows/{$image->name}";
                }

                  $productSeat = '';
                if(isset($product->ProductsSeats->row)){
                    $productSeat = $product->ProductsSeats->row. ' - ' .$product->ProductsSeats->seat;
                }

                array_push($tickets, array(
                    "order" => $order->id,
                    "createdAt" => $order->created_at,
                    "formattedCreatedAt" => date("d/m/Y H:i", strtotime($order->created_at)) . "h",
                    "salesPoint"=> $order->id_sale_point,
                    "terminal" => $order->id_sale_terminal,
                    "sale" => $sale->id,
                    "id_identifier" => $sale->id_identifier,
                    "id_event" => $sale->Events->id,
                    "event" => $sale->Events->name,
                    "label_date" => $sale->Events->label_date,
                    "logo" => $sale->Events->logo,
                    "logo_pos" => $sale->Events->logo_pos,
                    "images" => $images,
                    "city" => $sale->Events->Cities->name,
                    "place" => $sale->Events->Places->name,
                    "opening" => $sale->Events->date_opening,
                    "formattedOpening" => date("d/m/Y H:i", strtotime($sale->Events->date_opening)) . "h",
                    "instructions" => $sale->Events->instructions,
                    "parental_rating" => $sale->Events->parental_rating ?: '',
                    "code" => $product->ticket,
                    "value" => formatMoney($value),
                    "productName" => $product->Products->name,
                    "productGenre" => $product->Products->ProductsGenres->name,
                    "productType" => $product->ProductsTypes->name,
                    "productDescription" => $product->Products->description,
                     "productSeat" => $productSeat,
                    "footer" => "",
                    "organizer" => $sale->Events->Organizers->name
                ));
            }
        }

        $id_order = $order->id;
        $sql = "UPDATE orders SET id_orders_status = $orderStatus WHERE id = '$id_order'"; // Ativa pedido
		$this->db->execute($sql);

        if ( $log ) {
            $request = $sql ;
            $sql = "
                    INSERT INTO _log_api (url,ip,session,agent,request)
                    VALUES ('api-account/orderAction  3', ?, ?, ?, ?)
                    ";
                $this->db->execute($sql, array($ip, $session, $agent, $request) );
        }

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
        $valueTotalOrder = $valueFee + $order->value_total;
		$sql = 'UPDATE sales s SET s.status = 4, s.value_fee = "'.$valueFee.'", s.value_total = "'.$valueTotalOrder.'", s.installments = "'.$order->installments.'" WHERE s.id_order = "' . $id_order . '" ';
		$this->db->execute($sql);

            if ( $log ) {
                $request = $sql ;
                $sql = "
                     INSERT INTO _log_api (url,ip,session,agent,request)
                    VALUES ('api-account/orderAction  4', ?, ?, ?, ?)
                    ";
                $this->db->execute($sql, array($ip, $session, $agent, $request) );
            }

		// Ativa os ingressos do pedido - Os Tickets estao com status pendente
		// Muda o stauts pra 1 -> Ativo
		# $sql = 'UPDATE sales_items si SET si.status = 1 WHERE si.id_sale IN ( SELECT os.id_sale FROM order_sale os WHERE os.id_order = ' . $id_order . ' )';
        $sql = " UPDATE sales_items si SET si.status = 1 WHERE si.id_order =  '$id_order' ";
        $this->db->execute($sql);

            if ( $log ) {
                $request = $sql ;
                $sql = "
                     INSERT INTO _log_api (url,ip,session,agent,request)
                    VALUES ('api-account/orderAction  5', ?, ?, ?, ?)
                    ";
                $this->db->execute($sql, array($ip, $session, $agent, $request) );
            }

        if(isset($tickets[0]['id_identifier'])) {
            $sqlIdentifier = "SELECT * FROM identifier where id = {$tickets[0]['id_identifier']} AND printed_at IS NULL";
            $identifier = $this->db->fetchOne($sqlIdentifier);

            if($identifier) {
                // Muda o stauts pra 3 -> Pendente
                $sql = 'UPDATE sales_items si SET si.status = 5 WHERE si.id_sale = ' . $tickets[0]['sale'] . ' ';
                $this->db->execute($sql);

                $now = date('Y-m-d H:i:s');
                $sql = 'UPDATE identifier SET printed_at = "' . $now . '", id_sale = ' . $tickets[0]['sale'] . ' WHERE id = "' . $tickets[0]['id_identifier'].'"';
                $this->db->execute($sql);
            }

            if ( $log ) {
                $request = $sql ;
                $sql = "
                        INSERT INTO _log_api (url,request)
                        VALUES ('api-account/orderAction  6',?)
                        ";
                $this->db->execute($sql, array($request) );
            }
        }



        if ( $log ) {
                $request = print_r( json_encode(array(
                "success" => true,
                "order" => $order,
                "tickets" => $tickets
            )) , true) ;
            $sql = "
                    INSERT INTO _log_api (url,ip,session,agent,request)
                    VALUES ('api-account/orderAction  7', ?, ?, ?, ?)
                    ";
                $this->db->execute($sql, array($ip, $session, $agent, $request) );
        }


        $this->response->setContent(
            json_encode(array(
            "success" => true,
            "order" => $order,
            "tickets" => $tickets
        )));
        $this->response->send();
    }
}
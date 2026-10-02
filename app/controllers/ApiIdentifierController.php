<?php

use Phalcon\Http\Response;

class ApiIdentifierController extends ApiControllerBase
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

    }

    private function getProducts(string $idIdentifier)
    {
        $getProducts = new GetProducts();
        $products = $getProducts->getEventPdvByIdentifier($idIdentifier);
        if ($products) {
            $id = $products['event_id'];
            $events = Events::find(["id = $id"]);
            $result = [];
            foreach ($events as $event) {
                $event->id_place = $event->Places;
                $event->id_city = $event->Cities;
                $event->id_region = $event->Regions;
                $event->id_organizer = $event->Organizers;

                $eventArray = $event->toArray();
                foreach($event->EventsImages as $image) {
                    $eventArray['images'][] = "img/shows/{$image->name}";
                }

                if(!isset($eventArray['images'])) {
                    $eventArray['images'][] = "img/shows/alexandre_pires1.jpg";
                }

                $result[] = $eventArray;
            }
            $products['session'] = $this->session_id;
            $products['event'] = $result[0];
            $products['fee_value'] = 0;
            $products['fee_tax'] = 0;
            $products['fee_org_value'] = 0;
            $products['fee_org_tax'] = 0;
            $products['success'] = true;
            return $products;
        }

        return array("success" => false, "message" => "Localizador inválido ou já utilizado");
    }

    public function searchAction()
    {
        $idIdentifier = isset($this->requestBody->id_identifier) ? $this->requestBody->id_identifier : '';

        if(empty($idIdentifier)) {
            $this->response->setContent(json_encode(array(
                "success" => false,
                "message" => "São necessários os parâmetros 'email' e 'password'"
            )));
            $this->response->send();
            return;
        }

		$products = $this->getProducts($idIdentifier);

        $this->response->setContent(json_encode($products));
        $this->response->send();
    }

    public function applyAction()
    {
        $this->cartLib = new CartLib();
        $idIdentifier = isset($this->requestBody->id_identifier) ? $this->requestBody->id_identifier : '';
        $pdv = isset($this->requestBody->pdv) ? $this->requestBody->pdv : '';
		$pos = isset($this->requestBody->pos) ? $this->requestBody->pos : '';

        if(empty($idIdentifier)) {
            $this->response->setContent(json_encode(array(
                "success" => false,
                "message" => "São necessários os parâmetros 'email' e 'password'"
            )));
            $this->response->send();
            return;
        }

        $product = $this->getProducts($idIdentifier);
        if (!$product['success']) {
            $this->response->setContent(json_encode(array(
                "success" => false,
                "message" => "Error"
            )));
            $this->session->remove("cart");
            $this->response->send();
            return;
        }

        $this->createCart($product['event_id'], $product, $pdv, $pos);
        $orderReturn = $this->saveSalesAndOrder($this->cart);
        if (!$orderReturn) {
            $this->response->setContent(json_encode(array(
                "success" => false,
                "message" => "Error"
            )));
            $this->session->remove("cart");
            $this->response->send();
            return;
        }

        // Agora limpa o carrinho - Finalizou a compra
        $this->db->execute("DELETE FROM cart WHERE customer_session = '{$this->cart['customer_session']}' ");

        $sqlIdentifier = "SELECT * FROM ticket.identifier where code = '{$idIdentifier}' AND id_sale IS NULL;";
		$query_sqlIdentifier = $this->db->fetchOne($sqlIdentifier);

        $sql = 'UPDATE sales s SET s.id_identifier = "' . $query_sqlIdentifier['id'] . '" WHERE s.id_order = "' . $orderReturn['data']->id . '" ';
        $this->db->execute($sql);

		$this->response->setContent(json_encode(array(
			"success" => true,
			"order" => $orderReturn['data']->id,
            "seller" => $pdv,
            "session" => $this->session_id
        )));
        $this->session->remove("cart");
		$this->response->send();
    }

    private function createCart($event = 0, $product = array(), $pdv, $pos)
	{
        $cart = $this->cart;
		$cart['event'][$event]['event'] = $event;
		$cart['event'][$event]['event_name'] = $product['event_name'];
		$cart['event'][$event]['event_delivery'] = $product['delivery'];
        $cart['event'][$event]['products'][$product['id']][$product['type_id']] = $product;
        $cart['pdv'] = $pdv;
        $cart['pos'] = $pos;
        $cart = $this->cartLib->setDelivery($cart, $event, 6);
        $cart['payment_set'] = 1;

        $cart = $this->cartLib->persistCart($cart, 0);

		if($cart) {
			$this->cart = $cart;
            $this->session->set("cart", $cart);
		}
    }

    private function saveSalesAndOrder($cart)
    {
        $orderReturn = $this->cartLib->saveOrder($cart, $cart['pdv'], $cart['pos']);
		if(!$orderReturn['success']) {
			$this->response->setContent(json_encode(array(
				"success" => false,
				"message" => $orderReturn['message']
			)));
			$this->response->send();
			return;
        }

        $salesReturn = $this->cartLib->saveSales($cart, $orderReturn['data']->id, $cart['pdv'], $cart['pos'], true);
		if(!$salesReturn['success']) {
			$this->response->setContent(json_encode(array(
				"success" => false,
				"message" => $salesReturn['message']
			)));
			$this->response->send();
			return;
		}

		$orderPaymentReturn = $this->cartLib->saveOrderPayment($orderReturn['data']->id, null, $cart['payment_set']);
		if(!$orderPaymentReturn['success']) {
			$this->response->setContent(json_encode(array(
				"success" => false,
				"message" => $orderPaymentReturn['message']
			)));
			$this->response->send();
			return;
        }
        $orderReturn['sales_id'] = $salesReturn['sales_id'];

        return $orderReturn;
    }
}
<?php

use Phalcon\Http\Response;

class ApiOrderController extends ApiControllerBase
{
    private $id_customer = 0;
	private $cartLib;

	public function initialize()
	{
		$customer = $this->session->get('customer');
		if ( $customer )
		{
			$this->id_customer = $customer->id;
			$this->customer = $customer;
        }
        $this->cartLib = new CartLib();
    }

    public function indexAction()
    {
        $orderId = isset($this->requestBody->order_id) ? $this->requestBody->order_id : '';

        if(empty($orderId)) {
            $this->response->setStatusCode(404, "Not Found");
            $this->response->setContent(json_encode("Missing parameters"));
            $this->response->send();
            return;
        }

        $order = $this->cartLib->getOder($orderId, $this->id_customer);
        $orderSales = OrderSale::find(["id_order = $order->id"]);
        $this->response->setContent(json_encode(array(
            "success" => true,
            "order" => $orderSales
        )));
        $this->response->send();
        return;
    }
}
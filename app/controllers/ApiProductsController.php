<?php

use Phalcon\Http\Response;

class ApiProductsController extends ApiControllerBase
{
    public function indexAction()
    {

    }

    public function searchAction()
    {
        $pdv = isset($this->requestBody->id_pdv) ? $this->requestBody->id_pdv : '';
        $idEvent = isset($this->requestBody->id_event) ? $this->requestBody->id_event : '';

        if(empty($pdv) || empty($idEvent)) {
            $this->response->setStatusCode(404, "Not Found");
            $this->response->setContent(json_encode("Missing parameters"));
            $this->response->send();
            return;
        }

		$getProducts = new GetProducts();
        $products = $getProducts->getEventPdv($pdv, $idEvent);

        $this->response->setContent(json_encode($products));
        $this->response->send();
    }    
    
    public function productSeatAction(){
        $idProduct = isset($this->requestBody->id_product) ? $this->requestBody->id_product : ''; 

        if(empty($idProduct)) {
            $this->response->setStatusCode(404, "Not Found");
            $this->response->setContent(json_encode("Missing parameters"));
            $this->response->send();
            return;
        }

        $getProducts = new GetProducts();
        $products = $getProducts->getProductSeats($idProduct);

        $this->response->setContent(json_encode($products));
        $this->response->send();
    }
}
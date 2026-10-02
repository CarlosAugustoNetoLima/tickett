<?php

use Phalcon\Mvc\Model\Criteria;

class ProductsController extends ControllerBase
{
	/**
	 * Index action
	 */
	public function indexAction()
	{

		$products = Products::find();
		$this->view->products = $products;
	}

	public function searchAction()
	{
		$pdv = $_POST['id_pdv'];
		$id_event = $_POST['id_event'];

		$getProducts = new GetProducts();
		$products = $getProducts->getEventPdv($pdv, $id_event);

		if(count($products) != 0 && $this->IS_API){
            echo json_encode($products);
        }
	}
}

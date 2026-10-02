<?php
use Phalcon\Mvc\User\Component;


class SellerLib extends Component
{
	public function login($id, $password, $serial = null)
	{
		if ( is_numeric($id) )
		{
			$seller = SalesTerminal::findFirst(
					[
						"id = :id: AND password = :password: ",
						"bind" => [
							"id" => $id,
							"password" => $password
						]
					]
				);

		} else {
			if ($serial) {
				$seller = SalesTerminal::findFirst(
					[
						"email = :email: AND password = :password: AND serial = :serial",
						"bind" => [
							"email" => $id,
							"password" => $password,
							"serial" => $serial
						]
					]
				);
			} else {
				$seller = SalesTerminal::findFirst(
					[
						"email = :email: AND password = :password: ",
						"bind" => [
							"email" => $id,
							"password" => $password
						]
					]
				);
			}
		}

		if ($seller) {
			return $seller;
		}

		return false;
	}



	public function getPaymentTypes($id_sale_point = null)
	{
		$payments = SalesPointsPaymentType::find(
			[
				"id_sale_point = :id_sale_point: ",
				"bind" => [
					"id_sale_point" => $id_sale_point
				]
			]
		);
		return $payments;
	}






}
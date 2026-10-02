<?php

use Phalcon\Mvc\User\Component;


class LotControl extends Component
{



	/**
	* $data = array(
					id_product,
					id_product_type,
					id_sale_point,
					product_lot,
				)
	*/
	public function verify($data)
	{
		return $this->checkLimit($data);
	}




	public function checkLimit($data)
	{
		$id_product = isset($data['id'])  ? $data['id'] : 'null';
		$id_product_group = isset($data['id_group'])  ? ' OR id_product_group = ' . $data["id_group"] . ' '  : '' ;
		$id_product_type = isset($data['id_type'])  ? ' OR id_product_type = ' . $data["id_type"] . ' '  : '' ;
		$id_sale_point = isset($data['id_sale_point'])  ? ' OR id_sale_point = ' . $data["id_sale_point"] . ' '  : '' ;
		$product_lot = isset($data['product_lot'])  ? ' OR product_lot = ' . $data["product_lot"] . ' '  : '' ;

		// Checa todos valores, e ordena pelos mais importantes, entao considera  aqtd para venda deste registro
		$sql = "
			SELECT
			    *,
			    SUM(
			        (CASE  WHEN id_product IS NOT NULL   THEN 1 ELSE 0 END ) +
			        (CASE  WHEN id_product_group IS NOT NULL   THEN 5 ELSE 0 END ) +
			        (CASE  WHEN id_product_type IS NOT NULL   THEN 8 ELSE 0 END ) +
			        (CASE  WHEN id_sale_point IS NOT NULL   THEN 13 ELSE 0 END ) +
			        (CASE  WHEN product_lot IS NOT NULL   THEN 3 ELSE 0 END )
			    ) priority
			FROM
			    products_sales_limit
			WHERE id_product = '$id_product'
			    AND ( id_product_group IS NULL
			    		$id_product_group
			    )
			    AND ( id_product_type  IS NULL
			        	$id_product_type
			    )
			    AND ( id_sale_point  IS NULL
			       		$id_sale_point
			    )
			    AND (  product_lot  IS NULL
			        	$product_lot
			    )
			    GROUP BY id
			    ORDER BY priority DESC
			    LIMIT 1
		    ";
	    $query_result = $this->db->fetchOne($sql);

		return $query_result['sales_limit'] ?: 999999;



	} // public function checkLimit($data)







}
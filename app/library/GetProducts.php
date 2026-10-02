<?php
use Phalcon\Mvc\User\Component;


class GetProducts extends Component
{

	/**
	Função para trazer os produtos conforme o PDV e EVENTO
	Depois alteramos para deixa-la global ao restante do sistema
	*/
	public function getEventPdv($pdv = false, $event = false, $id_product = false, $id_type = false, $lot = false)
	{

		// Só para garantir que não dê erro e traga uns produtos loucos com preço errado
		if ( is_numeric($pdv) AND $pdv > 0   AND  is_numeric($event) AND $event > 0 )
		{
			$sql_where = '';
			if ( $id_product )
				$sql_where .= " AND pl.id_product = '{$id_product}' ";

			if ( $id_type )
				$sql_where .= " AND pl.id_type = '{$id_type}' ";

			if ( $lot )
				$sql_where .= " AND pl.lot_number = '{$lot}' ";


			$sql = "
					SELECT distinctrow
					    p.id id,
					    p.name name,
					    pg.id genre_id,
					    pg.name genre,
					    pt.id type_id,
					    pt.name type_name,
					    p.current_lot current_lot,
					    p.fraction fraction,
					    pl.lot_name lot_name,
							pl.price price,
					    pl.id_product_group,
					    ( CASE WHEN pl.tax > 0  THEN pl.tax ELSE 0 END ) AS tax,
					    ( CASE WHEN fv.duty > 0  THEN fv.duty ELSE 0 END ) AS duty,
					    fv.type duty_type,
					    ( CASE WHEN fv.type = 1  THEN (pl.price * (fv.duty / 100)) ELSE (CASE WHEN fv.duty > 0 THEN fv.duty  ELSE 0 END) END ) AS duty_value,
					    ( CASE WHEN fv.tax > 0  THEN fv.tax ELSE 0 END ) AS duty_tax,
					    fv.tax_type duty_tax_type,
					    ( CASE WHEN fv.tax IS NULL THEN 0 WHEN fv.tax_type = 1  THEN (fv.tax * (fv.tax / 100)) ELSE (CASE WHEN fv.tax > 0 THEN fv.tax  ELSE 0 END) END ) AS duty_tax_value,
					    ( CASE WHEN fov.duty > 0  THEN fov.duty ELSE 0 END ) AS duty_org,
					    fov.type duty_org_type,
					    ( CASE WHEN fov.type = 1  THEN (pl.price * (fov.duty / 100)) ELSE (CASE WHEN fov.duty > 0 THEN fov.duty  ELSE 0 END) END ) AS duty_org_value,
					    ( CASE WHEN fov.tax > 0  THEN fov.tax ELSE 0 END ) AS duty_org_tax,
					    fov.tax_type duty_org_tax_type,
					    ( CASE WHEN fov.tax_type = 1  THEN (fov.tax * (fov.tax / 100)) ELSE  (CASE WHEN fov.tax > 0 THEN fov.tax  ELSE 0 END) END ) AS duty_org_tax_value,
						pl.date_start date_start,
					    pl.date_end date_end,
						(SELECT COUNT(1) FROM sales_items si INNER JOIN orders AS o ON si.id_order = o.id WHERE si.id_product = ps.id_product AND si.product_lot = pl.lot_number AND si.status IN (1) AND o.id_orders_status = 2 AND o.id_orders_payment_status = 3) sales_product_qty,
						(SELECT sales_limit FROM products_sales_limit psl WHERE psl.id_product = pl.id_product AND psl.product_lot = pl.lot_number AND psl.id_product_type IS NULL LIMIT 1 ) sales_limit_product,
						(SELECT COUNT(1) FROM products_seats AS prs WHERE p.id = prs.id_product) seats

					FROM
					products_sales ps
					INNER JOIN products p
						ON ps.id_product = p.id
					LEFT JOIN products_genres pg
						ON pg.id = p.id_genre
					LEFT JOIN products_lots pl
						ON (
							pl.id_product = ps.id_product
							AND pl.id_event = ps.id_event
							AND pl.id_type = ps.id_type
							AND pl.lot_number = p.current_lot
						)
					LEFT JOIN products_types pt
						ON pt.id = pl.id_type
					LEFT JOIN fees f
						ON f.id = ps.id_fee
					LEFT JOIN fee_values fv
						ON (
							fv.id_fee = f.id
							AND pl.price >= fv.start_value
							AND pl.price <= fv.end_value
						)
					LEFT JOIN fees_org fo
						ON fo.id = ps.id_fee_org
					LEFT JOIN fee_org_values fov
						ON (
							fov.id_fee = fo.id
							AND pl.price >= fov.start_value
							AND pl.price <= fov.end_value
						)
				WHERE ps.id_sale_point = '{$pdv}'
					AND ps.id_event = '{$event}'
					{$sql_where}
				ORDER BY p.priority DESC, p.name, pt.name
				";

// echo '<pre>';
// print_r($sql);
// echo '</pre>';
			if ( $id_product AND $id_type )
			{
				$query_products = $this->db->fetchOne($sql);
				$data = array(
					'id_product' => $query_products['id'],
					'id_product_group' =>  $query_products['id_product_group'],
					'id_product_type' =>  $query_products['type_id'],
					'id_sale_point' =>  $pdv,
					'product_lot' => $query_products['current_lot']
				);
				$query_products['available'] = $this->getAvailable($data);
			} else
			{
				$query_products = $this->db->fetchAll($sql);
				foreach ($query_products as $key => $value) {
					$data = array(
						'id_product' => $value['id'],
						'id_product_group' =>  $value['id_product_group'],
						'id_product_type' =>  $value['type_id'],
						'id_sale_point' =>  $pdv,
						'product_lot' => $value['current_lot'],
					);

					if ( $value['sales_limit_product'] > 0 ) {
						$query_products[$key]['available'] =  $value['sales_limit_product'] - $value['sales_product_qty'] ;
					}else{
						$query_products[$key]['available'] = $this->getAvailable($data);
					}
				}
			}

			return $query_products;
		}
		return false;
	}


	public function getEventPdvByIdentifier($identifier)
	{
		$sqlIdentifier = "SELECT * FROM ticket.identifier where code = '{$identifier}' AND id_sale IS NULL;";
		$query_sqlIdentifier = $this->db->fetchOne($sqlIdentifier);
		if (!$query_sqlIdentifier) {
			return false;
		}

		$event = $query_sqlIdentifier['id_event'];
		$id_product = $query_sqlIdentifier['id_product'];
		$id_type = $query_sqlIdentifier['id_product_type'];
		$lot = $query_sqlIdentifier['id_lot'];

		$price = $query_sqlIdentifier['price'];
		$quantity = $query_sqlIdentifier['quantity'];
		$created_by = $query_sqlIdentifier['created_by'];
		$description = $query_sqlIdentifier['description'];

		// Só para garantir que não dê erro e traga uns produtos loucos com preço errado
		if ( is_numeric($event) AND $event > 0 )
		{
			$sql_where = '';
			if ( $id_product )
				$sql_where .= " AND pl.id_product = '{$id_product}' ";

			if ( $id_type )
				$sql_where .= " AND pl.id_type = '{$id_type}' ";

			if ( $lot )
				$sql_where .= " AND pl.lot_number = '{$lot}' ";


			$sql = "
					SELECT distinctrow
					    p.id id,
							p.name name,
							es.name as event_name,
							es.max_installment_without_interest,
							es.max_installment_with_interest,
					    pg.id genre_id,
					    pg.name genre,
					    pt.id type_id,
					    pt.name type_name,
					    p.current_lot current_lot,
					    p.fraction fraction,
					    pl.lot_name lot_name,
							pl.price price,
							ifnull(identifier.fee, 0) as fee,
					    pl.id_product_group,
					    0 AS tax,
					    0 AS duty,
					    fv.type duty_type,
					    0 AS duty_value,
					    0 AS duty_tax,
					    fv.tax_type duty_tax_type,
					    0 AS duty_tax_value,
					    0 AS duty_org,
					    fov.type duty_org_type,
					    0 AS duty_org_value,
					    0 AS duty_org_tax,
					    fov.tax_type duty_org_tax_type,
					    0 AS duty_org_tax_value,
							pl.date_start date_start,
							pl.date_end date_end

					FROM
					products_sales ps
					INNER JOIN products p
						ON ps.id_product = p.id
					INNER JOIN events es
						ON es.id = ps.id_event
					LEFT JOIN products_genres pg
						ON pg.id = p.id_genre
					LEFT JOIN products_lots pl
						ON (
							pl.id_product = ps.id_product
							AND pl.id_event = ps.id_event
							AND pl.id_type = ps.id_type
						)
					LEFT JOIN products_types pt
						ON pt.id = pl.id_type
					LEFT JOIN fees f
						ON f.id = ps.id_fee
					LEFT JOIN identifier identifier
						ON (identifier.id_product = p.id
						AND identifier.id_event = p.id_event
						AND identifier.id_product_type = pt.id)
					LEFT JOIN fee_values fv
						ON (
							fv.id_fee = f.id
							AND pl.price >= fv.start_value
							AND pl.price <= fv.end_value
						)
					LEFT JOIN fees_org fo
						ON fo.id = ps.id_fee_org
					LEFT JOIN fee_org_values fov
						ON (
							fov.id_fee = fo.id
							AND pl.price >= fov.start_value
							AND pl.price <= fov.end_value
						)
				WHERE ps.id_event = '{$event}'
					{$sql_where}
				ORDER BY p.priority DESC, p.name, pt.name
				";

// echo '<pre>';
// print_r($sql);
// echo '</pre>';
			if ( $id_product AND $id_type )
			{
				$query_products = $this->db->fetchOne($sql);
				$data = array(
					'id_product' => $query_products['id'],
					'id_product_group' =>  $query_products['id_product_group'],
					'id_product_type' =>  $query_products['type_id'],
					'product_lot' => $query_products['current_lot']
				);
				$query_products['tax'] += $query_products['fee'];
				$query_products['session'] = session_id();
				$query_products['qty'] = $quantity;
				$query_products['identifier'] = $identifier;
				$query_products['success'] = true;
				$query_products['available'] = (int)$quantity;
				$query_products['event_id'] = $event;
				$query_products['created_by'] = $created_by;
				$query_products['description'] = $description;
				$query_products['lot'] = $lot;
				$query_products['delivery'] = $this->deliveryType($event);
			} else
			{
				$query_products = $this->db->fetchAll($sql);
				foreach ($query_products as $key => $value) {
					$data = array(
						'id_product' => $value['id'],
						'id_product_group' =>  $value['id_product_group'],
						'id_product_type' =>  $value['type_id'],
						'product_lot' => $value['current_lot']
					);
					$query_products[$key]['tax'] += $query_products['fee'];
					$query_products[$key]['available'] = $this->getAvailable($data);
				}
			}

			return $query_products;
		}
		return false;
	}




	/*
	Analisa todo o carrinho $cart
	Para verificar o estoque, se todos produtos estão disponíveis
	*/
	public function checkCartAvailable($cart)
	{
		// echo 'cart<pre>';
		// print_r($cart);
		// echo '</pre>';
		foreach($cart['event'] AS $id_event => $event)
		{
			foreach ( $event['products'] AS $id_product => $product )
			{
				foreach ( $product AS $id_type => $type )
				{
					for ( $cont = 1; $cont <= $type['qty']; $cont++ ) {
					}
				}
			}
		}

//		exit();

	}




	/*
	Tras a qtd disponível para o produto passado pelo $data
	*/
	public function getAvailable($data)
	{
		// Primeiro consulta a regra de lotes, a quantidade máxima para venda para este produto
		$checkSalesLimit = $this->checkSalesLimit($data);

		// Se nao tiver limite, nem precisa consultar o quanto vendeu, é ilimitado mesmo
		if ( $checkSalesLimit['sales_limit'] > 0 )
		{
			// Depois, com base na regra acima, cria um array contendo os campos que correspondem a regra
			// Entao faz a busca pra contar quantos vendeu que atendem a esta regra
			// Se na regra tem o PDV, consulta só vendas do PDV,
			// Se na regra tem o tipo do produto, consulta só vendas deste tipo
			// Se tem regra por lote, ai consulta só vendas deste lote...
			$data = array();
			$data['id_product'] = $checkSalesLimit['id_product'];

			if ( $checkSalesLimit['id_product_type'] )
				$data['id_product_type'] = $checkSalesLimit['id_product_type'];

			if ( $checkSalesLimit['id_sale_point'] )
				$data['id_sale_point'] = $checkSalesLimit['id_sale_point'];

			if ( $checkSalesLimit['product_lot'] )
				$data['product_lot'] = $checkSalesLimit['product_lot'];

			$sumSalesActive = $this->sumSalesActive($data);
			$availabe = $checkSalesLimit['sales_limit']  - $sumSalesActive;
		} else {
			$availabe = 999999; // Se nao tem limite, entao pode vender 1 milhao de produtos
		}
		return $availabe;
	}



	public function checkSalesLimit($data)
	{
		$id_product = isset($data['id_product'])  ? $data['id_product'] : 'null';
		$id_product_group = isset($data['id_product_group'])  ? ' OR id_product_group = ' . $data["id_product_group"] . ' '  : '' ;
		$id_product_type = isset($data['id_product_type'])  ? ' OR id_product_type = ' . $data["id_product_type"] . ' '  : '' ;
		$id_sale_point = isset($data['id_sale_point'])  ? ' OR id_sale_point = ' . $data["id_sale_point"] . ' '  : '' ;
		$product_lot = isset($data['product_lot'])  ? ' OR product_lot = ' . $data["product_lot"] . ' '  : '' ;

		// Checa todos valores, e ordena pelos mais importantes, entao considera  aqtd para venda deste registro
		$sql = "
			SELECT
			    *,
			    SUM(
			        (CASE  WHEN id_sale_point IS NOT NULL   THEN 13 ELSE 0 END ) +
			        (CASE  WHEN id_product_type IS NOT NULL   THEN 8 ELSE 0 END ) +
			        (CASE  WHEN id_product_group IS NOT NULL   THEN 5 ELSE 0 END ) +
			        (CASE  WHEN product_lot IS NOT NULL   THEN 3 ELSE 0 END ) +
			        (CASE  WHEN id_product IS NOT NULL   THEN 1 ELSE 0 END )
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
		return $query_result;
	} // public function checkLimit($data)




	public function sumSalesActive($data)
	{
		$id_product = isset($data['id_product'])  ? $data['id_product'] : 'null';
		$id_product_type = isset($data['id_product_type'])  ? ' AND si.id_product_type = ' . $data["id_product_type"] . ' '  : '' ;
		$product_lot = isset($data['product_lot'])  ? ' AND si.product_lot = ' . $data["product_lot"] . ' '  : '' ;
		$id_sale_point = isset($data['id_sale_point'])  ? ' AND id_sale_point = ' . $data["id_sale_point"] . ' '  : '' ;

		$inner_sales = '';
		if ( isset($data["id_sale_point"]) ){
			$inner_sales = ' INNER JOIN sales s ON s.id = si.id_sale ';
		}

		$sql = "
			    SELECT
			        COUNT(1) qty
			    FROM
			        sales_items si
			        $inner_sales
			    WHERE si.id_product = $id_product
			        $id_product_type
			        $product_lot
			        $id_sale_point
			        AND si.status IN (1)
			        ";
		$query_result = $this->db->fetchOne($sql);
		return $query_result['qty'];
	}




	/**
	Calcula a taxa conforme o tipo da configuração do PDV x Evento
	*/
	public function calcTax($price = 0 , $duty = 0 , $duty_type = 0)
	{
		// Se a tava for ZERO, já retorna 0. Nem tem o que calcular
		if ( $duty == 0 )
		{
			$tax = 0;

		} else
		{
			// Duty type =>  1 - Porcentual | 2 - Fixo
			if ( $duty_type == 1 )
			{
				$tax = $price * ( $duty / 100 );
			} else
			{
				$tax = $duty;
			}

		}
		return $tax;
	}


	/**
	Retorna as forma de entrega por evento
	 -- No futuro pode ser alterado para ter formas de entrega diferente por produto tbm
	*/
	public function deliveryType($id_event = 0, $id_product = false)
	{

		$sql = "
			SELECT
				dt.id,
				dt.name,
				ed.resume,
				ed.description,
				(CASE WHEN ed.value > 0 THEN ed.value ELSE 0 END) value,
				(CASE WHEN ed.value_tax > 0 THEN ed.value_tax ELSE 0 END) value_tax
			FROM
				events_deliveries ed
				INNER JOIN delivery_types dt
					ON dt.id = ed.id_delivery_type
			WHERE ed.id_event = '{$id_event}'
		";
		$query_delivery_type = $this->db->fetchAll($sql);
		$return = array();

		if ( $query_delivery_type AND count($query_delivery_type)  > 0 )
		{
			// tem formas de pgto para o evento
			// Se nao tiver, tras o email por padrao
		} else {
			$query_delivery_type = array([
						            'id' => 6,
						            'name' => 'Email',
						            'title' => null,
						            'resume' => null,
						            'description' => null,
						            'value' => 0,
						            'value_tax' => 0,
						            'qty' => 1,
								]);
		}


		foreach ( $query_delivery_type AS $delivery_types )
		{
			$return[$delivery_types['id']] = $delivery_types;
		}

		return $return;
	}

}
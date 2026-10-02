<?php

use Phalcon\Mvc\User\Component;


class SalesLib extends Component
{




	/**
	* Faz a sangria
	* Salva os valores sangrados
	*/
	public function withdrawal($id_sale_point, $id_sale_terminal, $withdrawal_data)
	{
		$msg = array();
		foreach ( $withdrawal_data AS $id_event => $data_payment )
		{
			foreach ($data_payment as $id_payment_type => $data )
			{
				$withdrawal = new TerminalWithdrawal();
				$withdrawal->id_sale_point = $id_sale_point;
				$withdrawal->id_sale_terminal = $id_sale_terminal;
				$withdrawal->id_event = $id_event;
				$withdrawal->id_payment_type = $id_payment_type;
				$withdrawal->value_product = isset($data['value_product'])  ? $data['value_product'] : 0;
				$withdrawal->value_product_tax = isset($data['value_product_tax'])  ? $data['value_product_tax'] : 0;
				$withdrawal->value_fee = isset($data['value_fee'])  ? $data['value_fee'] : 0;
				$withdrawal->value_fee_tax = isset($data['value_fee_tax'])  ? $data['value_fee_tax'] : 0;
				$withdrawal->value_fee_org = isset($data['value_fee_org'])  ? $data['value_fee_org'] : 0;
				$withdrawal->value_fee_org_tax = isset($data['value_fee_org_tax'])  ? $data['value_fee_org_tax'] : 0;
				$withdrawal->value_total = $withdrawal->value_product + $withdrawal->value_product_tax + $withdrawal->value_fee + $withdrawal->value_fee_tax + $withdrawal->value_fee_org + $withdrawal->value_fee_org_tax;
				$withdrawal->created_at = date('Y-m-d H:i:s');
				if ( !$withdrawal->save() )
				{
					$msg[$id_event] = array(
							"success" => false,
							"message" => $withdrawal->getMessages()
						);

				}else
				{
					$msg[$id_event] = array(
						"success" => true
					);
				}
			}
		}
		return $msg;
	}





	/**
	* Busca os valores sangrados no pdv/pos
	*/
	public function withdrawals($id_sale_point, $id_sale_terminal)
	{
		$sql = "
		SELECT
			tw.id_event,
		    tw.id_payment_type,
		    SUM(tw.value_product) value_product,
		    SUM(tw.value_product_tax) value_product_tax,
		    SUM(tw.value_fee) value_fee,
		    SUM(tw.value_fee_tax) value_fee_tax,
		    SUM(tw.value_fee_org) value_fee_org,
		    SUM(tw.value_fee_org_tax) value_fee_org_tax,
		    SUM(tw.value_total) value_total
		FROM
		    terminal_withdrawal tw
		WHERE tw.id_sale_point = $id_sale_point
		    AND tw.id_sale_terminal =  $id_sale_terminal
		GROUP BY tw.id_payment_type, tw.id_event
		";
		$withdrawals = $this->db->fetchAll($sql);
		return $withdrawals;
	}





	/**
	* Soma as vedas no pdv/pos por forma de pgto
	*/
	public function salesResume($id_sale_point, $id_sale_terminal)
	{
		$sql = "
		SELECT
			s.id_event,
			e.name name_event,
		    s.id_payment_type,
		    pt.name name_payment_type,
		    SUM(si.value_product) value_product,
		    SUM(si.value_product_tax) value_product_tax,
		    SUM(si.value_fee) value_fee,
		    SUM(si.value_fee_tax) value_fee_tax,
		    SUM(si.value_fee_org) value_fee_org,
		    SUM(si.value_fee_org_tax) value_fee_org_tax,
		    SUM(si.value_product + si.value_product_tax + si.value_fee + si.value_fee_tax + si.value_fee_org + si.value_fee_org_tax) value_total
		FROM
		    sales_items si
		    INNER JOIN sales s
		        ON s.id = si.id_sale
		    INNER JOIN payment_types pt
		        ON pt.id = s.id_payment_type
		    INNER JOIN events e
		    	ON e.id = s.id_event
		WHERE s.id_sale_point = $id_sale_point
		    AND s.id_sale_terminal =  $id_sale_terminal
		    AND si.status IN (1)
		GROUP BY s.id_payment_type, s.id_event
		";
		$salesResume = $this->db->fetchAll($sql);
		return $salesResume;
	}






	/**
	* Soma os valores de venda do pdv/pos
	* Pode filtrar por data
	* Pode filtrar por evento
	* Agrupa por pagamento e evento
	*/
	public function balance($id_sale_point, $id_sale_terminal, $data = array())
	{

		$id_event = isset($data['id_event'])  ? ' AND si.id_event IN (' . $data["id_event"] . ') '  : '' ;
		$date_start = isset($data['date_start'])  ? ' AND si.created_at >= "' . $data["date_start"] . '" '  : '  ' ;
		$date_end = isset($data['date_end'])  ? ' AND si.created_at <= "' . $data["date_end"] . '" '  : '  ' ;


		$sql = "
			SELECT
			    si.id_event,
			    e.name name_event,
			    s.id_payment_type,
			    pt.name name_payment_type,
			    COUNT(1) qty,
			    SUM(si.value_product) value_product,
			    SUM(
			        si.value_product_tax + si.value_fee_tax + si.value_fee_org_tax
			    ) value_tax,
			    SUM(si.value_fee + si.value_fee_org) value_fee
			FROM
			    sales_items si
			    INNER JOIN sales s
			        ON s.id = si.id_sale
			    INNER JOIN payment_types pt
			        ON pt.id = s.id_payment_type
			    INNER JOIN events e
			        ON e.id = si.id_event
			WHERE s.id_sale_point = $id_sale_point
			    AND s.id_sale_terminal =  $id_sale_terminal
			    AND si.status IN (1)
			    $id_event
			    $date_start
			    $date_end
			GROUP BY s.id_payment_type,
			    si.id_event
			ORDER BY e.id,
			    pt.id
		";
		$balance = $this->db->fetchAll($sql);
		return $balance;
	}






}
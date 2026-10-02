<?php

use Phalcon\Mvc\User\Component;


class CartLib extends Component
{

	public function getPaymentTypes()
	{
		$sql = "SELECT id FROM payment_types";
		$paymentTypes = $this->db->fetchAll($sql);
		$ids = [];
		foreach ($paymentTypes as $type) {
			$ids[] = intval($type['id']);
		}
		return $ids;
	}

	public function getEvents($id_sale_point = null, $id_event = null)
	{
		$now = date('Y-m-d H:i:s');
		if ($id_sale_point) {
			$sql_id_event = $id_event ? " AND id = '$id_event' " : '';
			//$sales_end_site = $id_sale_point == 1 ? " AND date_sales_end > NOW() " : ''; // se for o site, respeita o fim das vendas - depois precisa ajustar para funcionar nos terminais tbm
			$sales_end_site = " AND date_sales_end > '" . $now . "' "; // se for o site, respeita o fim das vendas - depois precisa ajustar para funcionar nos terminais tbm
			$sql = "
				SELECT
				    *
				FROM
				    events
				WHERE 1 AND date_sales_end > '" . $now . "'
				    -- $sales_end_site
				    $sql_id_event
				    AND id IN
				    (SELECT
				        id_event
				    FROM
				        products_sales
				    WHERE id_sale_point = {$id_sale_point}
						GROUP BY id_event )
				ORDER BY date_sales_start desc
			";
			$events_model = new Events();
			$events = new Phalcon\Mvc\Model\Resultset\Simple(null, $events_model, $events_model->getReadConnection()->query($sql));
			return $events;
		}
	}

	public function getEventReport($id_pos = null, $id_sale_point = null, $id_event = null, $periodoDe = "", $periodoAte = "")
	{
		if ($id_sale_point) {
			$sql = "
			SELECT DISTINCT pt.id AS payment_type, pt.name, s.id_sale_point, sp.name, ROUND(SUM(si.value_product / si.fraction), 2) value, ROUND(SUM(si.value_fee / si.fraction), 2) value_fee FROM sales_items AS si  
			INNER JOIN payment_types as pt ON si.id_payment_type = pt.id 
			INNER JOIN sales as s ON si.id_sale = s.id 
			INNER JOIN sales_points as sp ON s.id_sale_point = sp.id 
			INNER JOIN orders as ord ON s.id_order = ord.id
			WHERE ord.id_orders_status in (1,2) AND ord.id_orders_payment_status = 3 AND si.value_product > 0 AND  si.id_event = $id_event AND si.id_payment_type IN (1, 15, 16, 25, 8) AND si.status = 1 AND s.id_sale_terminal = " . $id_pos . "  AND s.id_sale_point = $id_sale_point " . $periodoDe . $periodoAte . " GROUP BY pt.name ORDER BY pt.name";

			$result = $this->db->prepare($sql);
			$result->execute();

			return $result->fetchaLL(PDO::FETCH_ASSOC);
		}
	}


	/**
	 * Retorna a Ordem de Compra
	 * Pode ser específico pelo ID da Ordem e do Usuário
	 * Ou somente pelo Id da Ordem
	 */
	public function getOrder($id_order = null, $id_user = null)
	{
		if ($id_order and $id_user) {
			return Orders::findFirst(
				[
					"id = :id: AND id_customer = :id_customer: ",
					"bind" => [
						"id" => $id_order,
						"id_customer" => $id_user
					]
				]
			);
		} elseif ($id_order) {
			return Orders::findFirst($id_order);
		}
	}

	public function getOrderByterminal($id_order = null, $id_terminal = null)
	{
		if ($id_order and $id_terminal) {
			return Orders::findFirst(
				[
					"id = :id: AND id_sale_terminal = :id_sale_terminal: ",
					"bind" => [
						"id" => $id_order,
						"id_sale_terminal" => $id_terminal
					]
				]
			);
		} elseif ($id_order) {
			return Orders::findFirst($id_order);
		}
	}


	/**
	 * Se passar o $id_sale e $id_customer busca pelos dois indices
	 * SE passar só o $id_sale, já tras a venda, nao importa qual seja o $id_customer
	 */
	public function getSale($id_sale = null, $id_customer = null)
	{
		if ($id_sale and $id_customer) {
			return Sales::findFirst(
				[
					"id = :id: AND id_customer = :id_customer: ",
					"bind" => [
						"id" => $id_sale,
						"id_customer" => $id_customer
					]
				]
			);
		} elseif ($id_sale) {
			return Sales::findFirst($id_sale);
		}
	}




	/** Cria as ordens de compra
	 * Se nao passar o $id_sale_point e/ou  $id_sale_terminal, considera que a venda é do site
	 */
	public function saveOrder($cart, $id_sale_point = 1, $id_sale_terminal = 1)
	{
		if (isset($cart['order_id'])) {
			$order = Orders::findFirst($cart['order_id']);
			if (!$order) {
				$order = new Orders();
			}
		} else {
			$order = new Orders();
		}
		// Se tem o código do cliente, salva - SEnao deixa nullo - Neste caso será um pedido do PDV
		if (isset($cart['customer']) and  $cart['customer'] > 0) {
			$order->id_customer = $cart['customer'];
		}
		$order->id_payment_type = $cart['payment_set'];
		$order->id_sale_point = $id_sale_point;
		$order->id_sale_terminal = $id_sale_terminal;
		//$order->id_orders_payment_status = 1; // Pending
		$order->id_orders_status = 1; // Creating => Sendo criada pelo sistema - Isto nao deve aparecer para o usuário se o fluxo estiver correto
		//$order->email_sent = 0; // 0 -> nao | 1 -> sim
		$order->value_total = $cart['value_total'];

		$order->value_tax = isset($cart['value_tax']) ? $cart['value_tax'] : null;  // Isso pq tava dando no log, variavel indefinida

		$order->created_at = date('Y-m-d H:i:s');

		if (isset($cart['send_to_email']) and $cart['send_to_email']) {
			$order->send_to_email = $cart['send_to_email'];
		}
		if (isset($cart['send_to_whatsapp']) and $cart['send_to_whatsapp']) {
			$order->send_to_whatsapp = $cart['send_to_whatsapp'];
		}
		if (isset($cart['customer_id']) and $cart['customer_id']) {
			$order->customer_id = $cart['customer_id'];
		}
		if (isset($cart['id_billing_address']) and $cart['id_billing_address']) {
			$order->id_billing_address = $cart['id_billing_address'];
		}
		if (isset($cart['billing_address']) and $cart['billing_address']) {
			$order->billing_address = $cart['billing_address'];
		}
		if (isset($cart['ref']) and $cart['ref']) {
			$order->ref = $cart['ref'];
		}

		if (!$order->save()) {
			return array(
				"success" => false,
				"message" => $order->getMessages()
			);
		}

		return array(
			"success" => true,
			"data" => $order
		);
	}


	public function saveOrderCreate($cart, $id_sale_point = 1, $id_sale_terminal = 1)
	{


		if (isset($cart['order_id'])) {
			$order = Orders::findFirst($cart['order_id']);
			if (!$order) {
				$order = new Orders();
			}
		} else {
			$order = new Orders();
		}
		// Se tem o código do cliente, salva - SEnao deixa nullo - Neste caso será um pedido do PDV
		if (isset($cart['customer']) and  $cart['customer'] > 0) {
			$order->id_customer = $cart['customer'];
		}
		$order->id_payment_type = $cart['payment_set'];
		$order->id_sale_point = $id_sale_point;
		$order->id_sale_terminal = $id_sale_terminal;
		//$order->id_orders_payment_status = 1; // Pending
		$order->id_orders_status = 1; // Creating => Sendo criada pelo sistema - Isto nao deve aparecer para o usuário se o fluxo estiver correto
		//$order->email_sent = 0; // 0 -> nao | 1 -> sim
		$order->value_total = $cart['value_total'];

		$order->value_tax = isset($cart['value_tax']) ? $cart['value_tax'] : null;  // Isso pq tava dando no log, variavel indefinida

		$order->created_at = date('Y-m-d H:i:s');

		if (isset($cart['send_to_email']) and $cart['send_to_email']) {
			$order->send_to_email = $cart['send_to_email'];
		}
		if (isset($cart['send_to_whatsapp']) and $cart['send_to_whatsapp']) {
			$order->send_to_whatsapp = $cart['send_to_whatsapp'];
		}
		if (isset($cart['customer_id']) and $cart['customer_id']) {
			$order->customer_id = $cart['customer_id'];
		}
		if (isset($cart['id_billing_address']) and $cart['id_billing_address']) {
			$order->id_billing_address = $cart['id_billing_address'];
		}
		if (isset($cart['billing_address']) and $cart['billing_address']) {
			$order->billing_address = $cart['billing_address'];
		}
		if (isset($cart['ref']) and $cart['ref']) {
			$order->ref = $cart['ref'];
		}

		if (!$order->save()) {
			return array(
				"success" => false,
				"message" => $order->getMessages()
			);
		}

		return array(
			"success" => true,
			"data" => $order
		);
	}


	/**
	 * Salva os dados de pgto da ORDEM
	 * Precisa passar array com os dados do cartao de crédito
	 * Por hora só aceita cartão de crédito, depois esta função precisará ser modificada
	 */
	public function saveOrderPayment($id_order, $ccData = null, $payment)
	{
		$order_payment = new OrdersPayment();
		$order_payment->id_order = $id_order;
		$order_payment->id_payment = null;
		$order_payment->id_payment_type = $payment;
		$order_payment->expiration_date = null;

		if (is_array($ccData) and count($ccData) == 4) {
			$order_payment->cc_name = $ccData['name'];
			$order_payment->cc_number = $ccData['number'];
			$order_payment->cc_expiration = $ccData['expiration'];
			$order_payment->cc_cvv = $ccData['cvv'];
		}

		if (!$order_payment->save()) {
			return array(
				"success" => false,
				"message" => $order_payment->getMessages()
			);
		}

		return array(
			"success" => true,
			"data" => $order_payment
		);
	}






	/**
	 * Salva a VENDA - UMA para cada evento no carrinho
	 * Em seguida já chama a função para salvar a relação entre Order x Sale
	 * Na sequencia chama funcão para salvar os itens da venda
	 * Se nao passar o $id_sale_point e/ou  $id_sale_terminal, considera que a venda é do site
	 */
	public function saveSales($cart, $id_order, $id_sale_point = 1, $id_sale_terminal = 1)
	{
		foreach ($cart['event'] as $id_event => $event) {
			$id_payment_type = $cart['payment_set'];
			$sale = new Sales();
			$sale->id_order = $id_order;
			$sale->id_event = $id_event;
			if ($cart['customer']) {
				$sale->id_customer = $cart['customer'];
			}
			$sale->id_sale_point = $id_sale_point;
			$sale->id_sale_terminal = $id_sale_terminal;
			$sale->id_payment_type = $id_payment_type;
			$sale->id_delivery_type = isset($event['event_delivery_set']['id']) ? $event['event_delivery_set']['id'] : 5;
			$sale->value_product = $event['value_product'];
			$sale->value_product_tax = $event['value_product_tax'];
			$sale->value_fee = $event['value_fee'];
			$sale->value_fee_tax = $event['value_fee_tax'];
			$sale->value_fee_org = $event['value_fee_org'];
			$sale->value_fee_org_tax = $event['value_fee_org_tax'];
			$sale->value_interest = $event['value_interest'];
			$sale->value_interest_tax = $event['value_interest_tax'];
			$sale->value_delivery = $event['value_delivery'];
			$sale->value_delivery_tax = $event['value_delivery_tax'];
			$sale->value_total = $event['value_total'];
			$sale->status = 1; // status 1 = pedido recebido
			$sale->created_at = date('Y-m-d H:i:s');

			if (!$sale->save()) {
				return array(
					"success" => false,
					"message" => $sale->getMessages()
				);
			}

			// Cria o vinculo entra a Order x Sale
			$saveOrder = $this->saveOrderSale($id_order, $sale->id, $id_event);
			if ($saveOrder['success']) {
				// Salva os Items da Sale
				$saveItems = $this->saveSalesItems($event, $sale->id, $id_event, $id_order, $id_payment_type);
				if (!$saveItems['success']) {
					return array(
						"success" => false,
						"message" => $saveItems['message']
					);
				}
			} else {
				return array(
					"success" => false,
					"message" => $saveOrder['message']
				);
			}
		}

		return array(
			"success" => true,
			"sales_id" => $sale->id
		);
	}




	/**
	 * Salva o vinculo entre Order x Sale
	 * Uma Ordem de compra pode ter vários eventos
	 * Cada evento gera uma Sale
	 */
	public function saveOrderSale($id_order, $id_sale, $id_event)
	{
		$order_sale = new OrderSale();
		$order_sale->id_order = $id_order;
		$order_sale->id_sale = $id_sale;
		$order_sale->created_at = date('Y-m-d H:i:s');
		if (!$order_sale->save()) {
			return array(
				"success" => false,
				"message" => $order_sale->getMessages()
			);
		}
		return array(
			"success" => true,
			"data" => $order_sale
		);
	}

	/**
	 * Salva os itens do pedido
	 * Para cada evento, cria uma Sale, agora salva os itens deste  evento
	 */
	public function saveSalesItems($event, $id_sale, $id_event, $id_order = null,  $id_payment_type = null)
	{
		$ticket_sequence = 0;
		foreach ($event['products'] as $id_product => $product) {

			foreach ($product as $id_type => $type) {

				$is_migration = false;
				$sql = "SELECT 1 FROM migrations m WHERE m.id_product_from = '$id_product' AND ( m.id_product_type_from = '$id_type' OR m.id_product_type_from IS NULL)";
				$result_migrations = $this->db->fetchOne($sql);
				if ($result_migrations) {
					$is_migration = true;
				}


				for ($cont = 1; $cont <= $type['qty']; $cont++) {

					if (!isset($type['fraction'])) $type['fraction'] = 1;

					$product_sequence = 0;
					for ($repeat = 1; $repeat <= $type['fraction']; $repeat++) {

						if ($repeat == 1) {
							$ticket_sequence++;
						}
						$product_sequence++;

						$sales_items = new SalesItems();
						$sales_items->ticket = $this->ticketGenerate($id_event, $id_product, $id_type, true, $is_migration);
						$sales_items->status = 3;  // Status pendente - Depois do pgto ativa o ingresso
						$sales_items->id_order = $id_order;
						$sales_items->id_sale = $id_sale;
						$sales_items->id_event = $id_event;
						$sales_items->id_product = $id_product;
						$sales_items->id_product_type = $id_type;
						$sales_items->id_payment_type = $id_payment_type;
						$sales_items->product_lot = $type['lot'];
						$sales_items->value_product = $type['price'];
						$sales_items->value_product_tax = $type['tax'];
						$sales_items->value_fee = $type['fee_value'];
						$sales_items->value_fee_tax = $type['fee_tax'];
						$sales_items->value_fee_org = $type['fee_org_value'];
						$sales_items->value_fee_org_tax = $type['fee_org_tax'];
						$sales_items->fraction = $type['fraction'];
						$sales_items->ticket_sequence = $ticket_sequence;
						$sales_items->product_sequence = $product_sequence;
						$sales_items->created_at = date('Y-m-d H:i:s');


						if (!$sales_items->save()) {
							return array(
								"success" => false,
								"message" => $sales_items->getMessages()
							);
						}
					}
				}
			}
		}

		return array(
			"success" => true
		);
	}





	/**
	 * Add produto ao carrinho
	 * Cria um indice com o código do evento, depois um array com os dados do produto
	 */
	public function addProductToCart($cart, $id_event = 0, $product = array(), $id_customer = null)
	{
		$cart['event'][$id_event]['event'] = $id_event;
		$cart['event'][$id_event]['event_name'] = $product['event_name'];
		$cart['event'][$id_event]['event_delivery'] = $product['delivery'];
		$cart['event'][$id_event]['products'][$product['id']][$product['id_type']] = $product;
		$cart = $this->persistCart($cart, $id_customer);
		return $cart;
	}

	/**
	 * Remove produto do carrinho
	 * Por hora, remove o evento todo do carrinho. Deleta todos produtos
	 */
	public function removeProductFromCart($cart, $id_event, $id_customer = null)
	{
		unset($cart['event'][$id_event]);
		$cart = $this->persistCart($cart, $id_customer);
		return $cart;
	}




	public function setDelivery($cart, $id_event, $id_delivery, $destination = null)
	{
		// Primeiro verifica se a opção escolhida para Delivery, existe disponível para o evento.
		$delivery_option = isset($cart['event'][$id_event]['event_delivery'][$id_delivery]) ? $cart['event'][$id_event]['event_delivery'][$id_delivery] : false;

		if ($destination && ($id_delivery == 6 || $id_delivery == 7)) {
			$cart['event'][$id_event]['event_delivery_set'] = $delivery_option;
			if ($id_delivery == 6) {
				$cart['send_to_email'] = $destination;
				$cart['send_to_whatsapp'] = null;
			} else if ($id_delivery == 7) {
				$cart['send_to_email'] = null;
				$cart['send_to_whatsapp'] = $destination;
			}
			return $cart;
		}

		if (!$delivery_option && $id_delivery != 5) {
			return false;
		}
		$cart['event'][$id_event]['event_delivery_set'] = $delivery_option;
		return $cart;
	}




	/**
	 * Funcao bem util
	 * Refaz toda a variável $cart, salvando todos os eventos, produtos, valores, taxa ..
	 * Isto vai ser disponível na session pra toda aplicacao
	 * Tbm persiste no banco de dados para depois analisar os carrinhos abandonados
	 */
	public function persistCart($cart, $id_customer = null)
	{
		$value_total = 0;
		$value_total_products = 0;
		$value_total_product_tax = 0;
		$value_total_fee = 0;
		$value_total_fee_tax = 0;
		$value_total_fee_org = 0;
		$value_total_fee_org_tax = 0;
		$value_total_delivery = 0;
		$value_total_delivery_price = 0;
		$value_total_delivery_tax = 0;

		if (!$id_customer) {
			$id_customer = 'NULL';
		}

		if (isset($cart['customer_session'])) {
			// Primeiro limpa os carrinhos que possam existir pra esta SESSÃO - Depois vai add cada prdouto no carrinho novamente
			//	$this->db->execute("DELETE FROM cart WHERE customer_session = '{$cart['customer_session']}' ");
		}


		if (isset($cart['event']) and is_array($cart['event']) and count($cart['event']) > 0) {

			$sql = "INSERT INTO `ticket`.`cart` (`id_customer`, `id_event`, `id_product`, `id_product_type`, `product_lot`, `qty`, `price`, `price_tax`, `fee`, `fee_tax`, `fee_org`, `fee_org_tax`, `customer_session`, `customer_ip`, `customer_agent`) VALUES  ";

			$sql_values = array();
			foreach ($cart['event'] as $id_event => $event) {  // Percorre os eventos

				$cart['event'][$id_event]['value_interest'] = 0;
				$cart['event'][$id_event]['value_interest_tax'] = 0;
				$cart['event'][$id_event]['value_product'] = 0;
				$cart['event'][$id_event]['value_product_tax'] = 0;
				$cart['event'][$id_event]['value_fee'] = 0;
				$cart['event'][$id_event]['value_fee_tax'] = 0;
				$cart['event'][$id_event]['value_fee_org'] = 0;
				$cart['event'][$id_event]['value_fee_org_tax'] = 0;

				if (isset($event['products']) and $event['products']) {
					foreach ($event['products'] as $id_product => $product) { // Percorre os produtos
						foreach ($product as $id_type => $type) { // Percorre os tipos

							$sql_values[] = "({$id_customer}, '{$id_event}', '{$id_product}', '{$id_type}', '{$type['lot']}', '{$type['qty']}', '{$type['price']}', '{$type['tax']}', '{$type['fee_value']}', '{$type['fee_tax']}', '{$type['fee_org_value']}',  '{$type['fee_org_tax']}', '{$cart['customer_session']}', '{$cart['customer_ip']}', '{$cart['customer_agent']}')";

							// Valores totais acumulados por evento
							$cart['event'][$id_event]['value_interest'] += 0;
							$cart['event'][$id_event]['value_interest_tax'] += 0;
							$cart['event'][$id_event]['value_product'] += ($type['qty'] * $type['price']);
							$cart['event'][$id_event]['value_product_tax'] += ($type['qty'] * $type['tax']);
							$cart['event'][$id_event]['value_fee'] += ($type['qty'] * $type['fee_value']);
							$cart['event'][$id_event]['value_fee_tax'] += ($type['qty'] * $type['fee_tax']);
							$cart['event'][$id_event]['value_fee_org'] += ($type['qty'] * $type['fee_org_value']);
							$cart['event'][$id_event]['value_fee_org_tax'] += ($type['qty'] * $type['fee_org_tax']);

							// Valores totais finais para saber valor do carrinho
							$value_total_products += ($type['qty'] * $type['price']);
							$value_total_product_tax += ($type['qty'] * $type['tax']);
							$value_total_fee += ($type['qty'] * $type['fee_value']);
							$value_total_fee_tax += ($type['qty'] * $type['fee_tax']);
							$value_total_fee_org += ($type['qty'] * $type['fee_org_value']);
							$value_total_fee_org_tax += ($type['qty'] * $type['fee_org_tax']);
						}
					}
				}


				$delivery_price = 0; // Este é o valor base cobrado pela entrega - Inicia zerado
				$delivery_tax = 0; // Este é o imposto cobrado sobre a entrega - Inicia zerado
				if (isset($event['event_delivery_set']['value']) and $event['event_delivery_set']['value'] > 0) // Se tiver valor, soma
					$delivery_price = $event['event_delivery_set']['value'];

				if (isset($event['event_delivery_set']['value']) and $event['event_delivery_set']['value_tax'] > 0) // Se tiver taxa, soma
					$delivery_tax = $event['event_delivery_set']['value_tax'];


				$cart['event'][$id_event]['value_delivery_price'] = $delivery_price;
				$cart['event'][$id_event]['value_delivery_tax'] = $delivery_tax;
				$cart['event'][$id_event]['value_delivery'] = $delivery_price + $delivery_tax;
				$cart['event'][$id_event]['value_total'] =  (
					$cart['event'][$id_event]['value_product'] + // Produtos
					$cart['event'][$id_event]['value_product_tax'] + // Impostos sobre o produto
					$cart['event'][$id_event]['value_fee'] + // Taxa
					$cart['event'][$id_event]['value_fee_tax'] + // Impostos sobre a taxa
					$cart['event'][$id_event]['value_fee_org'] + // Taxa do organizador
					$cart['event'][$id_event]['value_fee_org_tax'] + // Imposto sobre a taxa do organizador
					$cart['event'][$id_event]['value_interest'] + // Juros do pagamento
					$cart['event'][$id_event]['value_interest_tax'] + // Juros do pagamento
					$cart['event'][$id_event]['value_delivery'] // Custo da entrega
				);
				$value_total_delivery_price += $cart['event'][$id_event]['value_delivery_price'];
				$value_total_delivery_tax += $cart['event'][$id_event]['value_delivery_tax'];
				$value_total_delivery += $cart['event'][$id_event]['value_delivery'];
			} // foreach ( $cart['event'] AS $id_event => $event ) {

			$sql = $sql . implode(", ", $sql_values) . ';';
			//	$this->db->execute($sql);


			/**
			 * Adicionado este trecho, para gravar tbm na SESSION o total do carrinho
			 * Ajuda muito na hora de exibir o resumo do carrinho de compras
			 * Já tras os valores e ai não precisa percorrer o carrinho novamente
			 */
			$cart['value_product'] = $value_total_products;
			$cart['value_product_tax'] = $value_total_product_tax;
			$cart['value_fee'] = $value_total_fee;
			$cart['value_fee_tax'] = $value_total_fee_tax;
			$cart['value_fee_org'] = $value_total_fee_org;
			$cart['value_fee_org_tax'] = $value_total_fee_org_tax;
			$cart['value_interest'] = 0;
			$cart['value_interest_tax'] = 0; // Somar no total de value_tax tbm
			$cart['value_delivery'] = $value_total_delivery;
			$cart['value_tax'] = $value_total_product_tax + $value_total_fee_tax + $value_total_fee_org_tax;
			$cart['value_total'] = (
				$cart['value_product'] + // Produtos
				$cart['value_product_tax'] + // Impostos sobre o produto
				$cart['value_fee'] + // Taxa
				$cart['value_fee_tax'] + // Impostos sobre a taxa
				$cart['value_fee_org'] + // Taxa do organizador
				$cart['value_fee_org_tax'] + // Imposto sobre a taxa do organizador
				$cart['value_interest'] + // Juros do pagamento
				$cart['value_interest_tax'] + // Juros do pagamento
				$cart['value_delivery'] // Valor da entrega
			);

			return $cart;
		} else { // if ($cart['event'])
			return false;
		}
	}






	public function getProductsFeesByPDV($pdv, $event_obj, $id_product, $productType, $quantity)
	{
		$getProducts = new GetProducts();
		// public  function getEventPdv($pdv = false, $event = false, $id_product = false, $productType = false, $lot = false)
		$getProduct = $getProducts->getEventPdv($pdv, $event_obj->id, $id_product, $productType);

		$product_temp = false;
		if ($getProduct and isset($getProduct['name'])) {
			$product_temp = array();
			$product_temp['event'] = $event_obj->id;
			$product_temp['event_name'] = $event_obj->name;
			$product_temp['max_installment_without_interest'] = $event_obj->max_installment_without_interest;
			$product_temp['max_installment_with_interest'] = $event_obj->max_installment_with_interest;
			$product_temp['id'] = $id_product;
			$product_temp['id_type'] = $productType;
			$product_temp['qty'] = $quantity;
			$product_temp['price'] = $getProduct['price'];
			$product_temp['tax'] = $getProduct['tax'];

			$product_temp['fee'] = $getProduct['duty']; // O valor da taxa
			$product_temp['fee_type'] = $getProduct['duty_type']; // O tipo da taxa (fixa ou porcentagem)
			// calcTax($price = 0 , $duty = 0 , $duty_type = 0) // Faz o calculo pra saber o valor real da taxa
			$product_temp['fee_value'] = $getProduct['duty_value']; // $this->getProducts->calcTax($getProduct['price'], $getProduct['duty'], $getProduct['duty_type']);
			$product_temp['fee_tax'] = $getProduct['duty_tax_value']; // O valor da taxa

			$product_temp['fee_org'] = $getProduct['duty_org']; // O valor da taxa
			$product_temp['fee_type'] = $getProduct['duty_org_type']; // O tipo da taxa (fixa ou porcentagem)
			// calcTax($price = 0 , $duty = 0 , $duty_type = 0) // Faz o calculo pra saber o valor real da taxa
			$product_temp['fee_org_value'] = $getProduct['duty_org_value']; // $this->getProducts->calcTax($getProduct['price'], $getProduct['duty_org'], $getProduct['duty_org_type']);
			$product_temp['fee_org_tax'] = $getProduct['duty_org_tax_value']; // O valor da taxa

			// TODO
			// Comecei a lógica para trazer as formas de entrega por evento(que pode se extender no futuro e ser tratada por produto)
			// deliveryType($id_event = 0, $id_product = false)
			$product_temp['delivery'] = $getProducts->deliveryType($event_obj->id);

			$product_temp['lot'] = $getProduct['current_lot'];
			$product_temp['name'] = $getProduct['name'];
			$product_temp['type'] = $getProduct['type_name'];
			$product_temp['fraction'] = $getProduct['fraction'];

			// Tras a qtd disponivel para venda
			$product_temp['available'] = $getProduct['available'];
		}

		return $product_temp;
	}





	public function proccessPayment($id_order = false, $async = false)
	{
		// Se for assincrono faz uma requisição pra uma url executar esta açao e nao aguarda  resposta
		// Feito isto pq o gateway de pgto tem um delay - o cliente nao precisa aguardar isto
		if ($async and $id_order) {
			$url = $this->url->get() . 'cron/proccess_payment/' . $id_order;
			$commandExec = "wget " . $url . "  > /dev/null &";
			$exec = exec($commandExec);

			$LogOrderProccessPayment = new LogOrderProccessPayment();
			$LogOrderProccessPayment->id_order = $id_order;
			$LogOrderProccessPayment->id_orders_payment = null;
			$LogOrderProccessPayment->response = $commandExec;
			$LogOrderProccessPayment->obs = 'CartLib - Modo Async';
			$LogOrderProccessPayment->created_at = date('Y-m-d H:i:s');
			$LogOrderProccessPayment->save();

			return array(
				"success" => true,
				"message" => 'async'
			);
		}

		if ($id_order) {

			$ProccessPayment = new ProccessPayment();
			$result = $ProccessPayment->proccess($id_order);

			$LogOrderProccessPayment = new LogOrderProccessPayment();
			$LogOrderProccessPayment->id_order = $id_order;
			$LogOrderProccessPayment->id_orders_payment = null;
			$LogOrderProccessPayment->response = print_r($result, true);
			$LogOrderProccessPayment->obs = 'Via CartLib';
			$LogOrderProccessPayment->created_at = date('Y-m-d H:i:s');
			$LogOrderProccessPayment->save();

			if ($result['response_code'] == 100) {
				$sql = " UPDATE orders SET id_orders_payment_status = 3 WHERE id = $id_order ";  // Payment received
				$this->db->execute($sql);
				return array(
					"success" => true
				);
			} else {
				$sql = " UPDATE orders SET id_orders_payment_status = 7 WHERE id = $id_order ";  // Error - Erro na transação
				$this->db->execute($sql);
				return array(
					"success" => false,
					"message" => array($result['responsetext'])
				);
			}
		} else {
			return array(
				"success" => false,
				"message" => 'Order Required'
			);
		}
	}



	/**
	 * Envia a confirmação de compra pro WHATSAPP
	 * Se já tiver o objeto $order, manda o $id_order como NULL e passa o objeto $order como parametro
	 * Assim não precisa fazer outra consulta no banco para pegar os dados da $order
	 */
	public function sendWhatsappOrder($id_order = null, $order = null, $async = false)
	{
		// Se for assincrono faz uma requisição pra uma url executar esta açao e nao aguarda  resposta
		// Feito isto pq o envio do whatsapp tem um delay do servidor de email, desnecessário o cliente esperar por isto
		if ($async and $id_order) {
			$url = $this->url->get() . 'cron/send_whatsapp_order/' . $id_order;
			$commandExec = "wget " . $url . "  > /dev/null &";
			$exec = exec($commandExec);

			$LogOrderWhatsappSent = new LogOrderWhatsappSent();
			$LogOrderWhatsappSent->id_order = $id_order;
			$LogOrderWhatsappSent->whatsapp_to = $commandExec;
			$LogOrderWhatsappSent->obs = 'CartLib - Modo Async';
			$LogOrderWhatsappSent->created_at = date('Y-m-d H:i:s');
			$LogOrderWhatsappSent->save();
			return array(
				"success" => true,
				"message" => 'async'
			);
		}


		if ($id_order) {
			$order = $this->getOrder($id_order);
		}

		if ($order) {
			$customer = $order->Customers;
			$id_customer = $customer->id;
			$email = $customer->email;
			$string = $id_customer . '##' . $email;
			$t = base64_encode($this->crypt->encryptBase64($string));
			$u = base64_encode($this->crypt->encryptBase64('account/verify'));
			$token_order = base64_encode($this->crypt->encryptBase64($order->id));
			$link_view_order = $this->url->get() . 'order/' . $token_order;
			$link_view_order = 'https://tickett.com/order/' . $token_order;


			if ($order->send_to_whatsapp) {
				$whatsapp = $order->send_to_whatsapp;
				$name = $order->send_to_whatsapp;
			} else {
				$customer = $order->Customers;
				$name = $customer->name;
				$whatsapp = $customer->cell_number;
			}
			// remover os caracteres desnecessários
			$whatsapp = str_replace(array(".", "-", "_", " ", "/", "(", ")"), "", $whatsapp);

			$arrayProductName = [];
			$msg = '';
			$arrayVariables = [];
			$cont = 1;
			$idEv = 0 ;
			foreach ($order->Sales as $sale) {
				foreach ($sale->SalesItems as $si) {
					if (!in_array($si->Products->name, $arrayProductName)) {
						$idEv = $si->Events->id;
						array_push($arrayProductName, $si->Products->name);

						$productType = trim((string) $si->ProductsTypes->name);

						if ($productType === '') {
							$productType = '-';
						}

						$arrayVariables = (object) [
							(string) $cont => "Evento: " . $si->Events->name,
							(string) $cont + 1 => "Produto: " . strip_tags($si->Products->name),
							(string) $cont + 2 => "Tipo: " . $productType,
							(string) $cont + 3 => "Pedido: " . $order->id,
							(string) $cont + 4 => $link_view_order,
						];

						$msg .=
							"Evento: " . $si->Events->name .
							"\nProduto: " . strip_tags($si->Products->name) .
							"\nTipo: " . $si->ProductsTypes->name .
							"\nPedido: " . $order->id . "\n\n";
						break;
					}
				}
			}


			// No BRASIL - valida o Whatsapp, adiciona o código do pais  +55
			if (COMPANY == 'lebillet') {
				if (substr($whatsapp, 0, 3) != '+55') {
					$whatsapp = '+55' . $whatsapp;
				}
			}



			// Pega a primeira SALE , pra saber o nome do evento e manda ele mesmo
			$order_sale = $order->Sales[0];
			$event = $order_sale->Events;
			$event_name = $event->name;


			require_once(BASE_PATH . '/app/library/WhatsApp.php');
			// $sendWhatsapp = new WhatsApp('ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', '+552731800700');
			$sendWhatsapp = new WhatsApp();
			$sendWhatsapp = new WhatsApp('ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', '+19895643612');
			
			// $sendWhatsapp = $sendWhatsapp->send($whatsapp, "LeBillet | Você acabou de receber o seu ticket para *$event_name* . Basta clicar no link abaixo e apresentá-lo na entrada do evento: *$link_view_order*");


			$language = TwilioLanguages::findFirst('language="' . $order->language . '"');
			$contentSid = 'HX59268970b3723605e4c7253c651ebb87';
			if ($language) {
				$contentSid = $language->contentSid;
			}

			/*if (isset($order->ticket_bolt)) {
				$language = TwilioLanguages::findFirst('language="' . $order->language . '_bolt"');
				if ($language) {
					$contentSid = $language->contentSid;
				}
			}*/

			$isProduct = false;
			foreach ($order->Sales as $sale) {
				foreach ($sale->SalesItems as $si) {
					$product = $si->Products;
					if (isset($product)) {
						if ($product->physical == 1) {
							$isProduct = true;
						}
					}
				}
			}

			if ($isProduct) {
				$arrayProductName = [];
				$msg = '';
				$arrayVariables = [];
				$cont = 1;
				foreach ($order->Sales as $sale) {
					foreach ($sale->SalesItems as $si) {
						if (!in_array($si->Products->name, $arrayProductName)) {
							array_push($arrayProductName, $si->Products->name);
							$msg .= strip_tags($si->Products->name) . "  ";
						}
					}
				}

				$nameC = $order->Customers ? $order->Customers->name : ' ';
				$detailCustomer = $order->Customers ? $order->Customers->address_1 . "  " . $order->Customers->city . " - " . $order->Customers->region . " - " . $order->Customers->country . " - " . $order->Customers->zipcode : '-';
				$arrayVariables = (object) [
					(string) $cont => $nameC,
					//(string) $cont + 1 => $order->Customers->name,
					(string) $cont + 1 => '' . $order->id,
					(string) $cont + 2 => $msg,
					(string) $cont + 3 => $detailCustomer,
				];
			}

			$sendWhatsapp = $sendWhatsapp->send($whatsapp, '...', $arrayVariables, $contentSid);
			

			if ($sendWhatsapp) {

				$sql = ' UPDATE orders SET whatsapp_sent = 1 WHERE id = ' . $order->id; // 0 -> nao | 1 -> sim
				$this->db->execute($sql);

				$LogOrderWhatsappSent = new LogOrderWhatsappSent();
				$LogOrderWhatsappSent->id_order = $id_order;
				$LogOrderWhatsappSent->whatsapp_to = $whatsapp;
				$LogOrderWhatsappSent->message_id = $sendWhatsapp;
				$LogOrderWhatsappSent->obs = 'Via CartLib ' . $sql;
				$LogOrderWhatsappSent->created_at = date('Y-m-d H:i:s');
				//$LogOrderWhatsappSent->save();


				return array(
					"success" => true,
					"sendWhatsapp" => print_r($sendWhatsapp, true)
				);
			} else {
				return array(
					"success" => false,
					"message" => print_r($sendWhatsapp, true)
				);
			}
		} else {
			return array(
				"success" => false,
				"message" => 'Order Not Found'
			);
		}
	}

	public function sendWhatsappOrderNew($id_order = null, $order = null, $async = false)
	{
		// Se for assincrono faz uma requisição pra uma url executar esta açao e nao aguarda  resposta
		// Feito isto pq o envio do whatsapp tem um delay do servidor de email, desnecessário o cliente esperar por isto
		if ($async and $id_order) {
			$url = $this->url->get() . 'cron/send_whatsapp_order/' . $id_order;
			$commandExec = "wget " . $url . "  > /dev/null &";
			$exec = exec($commandExec);

			$LogOrderWhatsappSent = new LogOrderWhatsappSent();
			$LogOrderWhatsappSent->id_order = $id_order;
			$LogOrderWhatsappSent->whatsapp_to = $commandExec;
			$LogOrderWhatsappSent->obs = 'CartLib - Modo Async';
			$LogOrderWhatsappSent->created_at = date('Y-m-d H:i:s');
			$LogOrderWhatsappSent->save();
			return array(
				"success" => true,
				"message" => 'async'
			);
		}


		if ($id_order) {
			$order = $this->getOrder($id_order);
		}

		if ($order) {
			if ($order->send_to_whatsapp) {
				$whatsapp = $order->send_to_whatsapp;
				$name = $order->send_to_whatsapp;
			} else {
				$customer = $order->Customers;
				$name = $customer->name;
				$whatsapp = $customer->cell_number;
			}
			// remover os caracteres desnecessários
			$whatsapp = str_replace(array(".", "-", "_", " ", "/", "(", ")"), "", $whatsapp);


			// No BRASIL - valida o Whatsapp, adiciona o código do pais  +55
			if (COMPANY == 'lebillet') {
				if (substr($whatsapp, 0, 3) != '+55') {
					$whatsapp = '+55' . $whatsapp;
				}
			}



			// Pega a primeira SALE , pra saber o nome do evento e manda ele mesmo
			$order_sale = $order->Sales[0];
			$event = $order_sale->Events;
			$event_name = $event->name;


			require_once(BASE_PATH . '/app/library/WhatsApp.php');
			// $sendWhatsapp = new WhatsApp('ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', '+552731800700');
			$sendWhatsapp = new WhatsApp();
			// $sendWhatsapp = $sendWhatsapp->send($whatsapp, "LeBillet | Você acabou de receber o seu ticket para *$event_name* . Basta clicar no link abaixo e apresentá-lo na entrada do evento: *$link_view_order*");


			if ($order->id_orders_status == 10) {
				$customer = $order->Customers;
				$id_customer = $customer->id;
				$email = $customer->email;
				$string = $id_customer . '##' . $email;
				$t = base64_encode($this->crypt->encryptBase64($string));
				$u = base64_encode($this->crypt->encryptBase64('account/verify'));
				$link_view_order = $this->url->get() . "account/login/?t=$t&u=$u";

				// *********************************   MENSAGEM QDO CAI NO ANTIFRAUDE ********************************* */
				/* *********************************   MENSAGEM QDO CAI NO ANTIFRAUDE ********************************* */
				if (COMPANY == 'tiktx') {

					$message = "Realize a ativação dos seus ingressos para *$event_name*, clicando no link abaixo:

					$link_view_order

					✅ *Clique em CONTINUAR no rodapé desta conversa* ou adicione a Tiktx em seus contatos para habilitar o link de verificação.

					_Caso o processo não seja realizado, sua compra poderá ser cancelada_";
				} else {

					$message = "Realize a ativação dos seus ingressos para *$event_name*, clicando no link abaixo:

					$link_view_order

					✅ *Clique em CONTINUAR no rodapé desta conversa* ou adicione a LeBillet na sua agenda para habilitar o link de verificação.

					_Caso o processo não seja realizado, sua compra poderá ser cancelada_";
				}
			} else {


				$token_order = base64_encode($this->crypt->encryptBase64($order->id));
				$link_view_order = $this->url->get() . 'order/' . $token_order;

				/* *********************************   MENSAGEM DE SUCESSO ********************************* */
				/* *********************************   MENSAGEM DE SUCESSO ********************************* */

				if (COMPANY == 'lebillet') {

					$message = "Olá, importante mensagem da LEBILLET

				✅ *ADICIONE esse número da LeBillet em seus contatos para habilitar o link de visualização dos seus bilhetes*

				_A Equipe Lebillet lhe deseja um ótimo evento!_";
				} else if (COMPANY == 'lebillet_pt') {


					$message = "Olá, importante mensagem da LEBILLET

				✅ *ADICIONE esse número da LeBillet em seus contatos para habilitar o link de visualização dos seus bilhetes*

				_A Equipe Lebillet lhe deseja um ótimo evento!_";
				} else if (COMPANY == 'tiktx') {

					$message = "Olá, importante mensagem da LEBILLET

				✅ *ADICIONE esse número da LeBillet em seus contatos para habilitar o link de visualização dos seus bilhetes*

				_A Equipe Lebillet lhe deseja um ótimo evento!_";
				}
			} //  else  if ( $order->id_orders_status == 10 ) {




			$sendWhatsapp = $sendWhatsapp->send($whatsapp, $message);


			if ($sendWhatsapp) {

				$sql = ' UPDATE orders SET whatsapp_sent = 1 WHERE id = ' . $order->id; // 0 -> nao | 1 -> sim
				$this->db->execute($sql);

				$LogOrderWhatsappSent = new LogOrderWhatsappSent();
				$LogOrderWhatsappSent->id_order = $id_order;
				$LogOrderWhatsappSent->whatsapp_to = $whatsapp;
				$LogOrderWhatsappSent->message_id = $sendWhatsapp;
				$LogOrderWhatsappSent->obs = 'Via CartLib ' . $sql;
				$LogOrderWhatsappSent->created_at = date('Y-m-d H:i:s');
				$LogOrderWhatsappSent->save();


				return array(
					"success" => true,
					"sendWhatsapp" => print_r($sendWhatsapp, true)
				);
			} else {
				return array(
					"success" => false,
					"message" => print_r($sendWhatsapp, true)
				);
			}
		} else {
			return array(
				"success" => false,
				"message" => 'Order Not Found'
			);
		}
	}

	public function sendWhatsappMensageNew($number = null, $async = false)
	{

		// remover os caracteres desnecessários
		$whatsapp = str_replace(array(".", "-", "_", " ", "/", "(", ")"), "", $number);


		// No BRASIL - valida o Whatsapp, adiciona o código do pais  +55
		if (COMPANY == 'lebillet') {
			if (substr($whatsapp, 0, 3) != '+55') {
				$whatsapp = '+55' . $whatsapp;
			}
		}

		require_once(BASE_PATH . '/app/library/WhatsApp.php');
		// $sendWhatsapp = new WhatsApp('ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', '+552731800700');
		$sendWhatsapp = new WhatsApp();
		// $sendWhatsapp = $sendWhatsapp->send($whatsapp, "LeBillet | Você acabou de receber o seu ticket para *$event_name* . Basta clicar no link abaixo e apresentá-lo na entrada do evento: *$link_view_order*");


		$message = "COMUNICADO IMPORTANTE!! Devido a problemas logísticos e operacionais, o local do concerto da Banda Chimarruts em Lisboa foi alterado. O concerto se realizará no GARDEN MASSAMA, no endereço Rua das Indústrias 125,2745-838, Queluz - Massamá, a manter-se no dia 15/10. 
		Os clientes que preferirem podem solicitar o reembolso através do nosso site no link https://lebillet.my/helpdesk.";

		$sendWhatsapp = $sendWhatsapp->send($whatsapp, $message);

		if ($sendWhatsapp) {
			return array(
				"success" => true,
				"sendWhatsapp" => print_r($sendWhatsapp, true)
			);
		} else {
			return array(
				"success" => false,
				"message" => print_r($sendWhatsapp, true)
			);
		}
	}



	/**
	 * Envia o SMS da compra
	 * Se já tiver o objeto $order, manda o $id_order como NULL e passa o objeto $order como parametro
	 * Assim não precisa fazer outra consulta no banco para pegar os dados da $order
	 */
	public function sendSMSOrder($id_order = null, $order = null, $async = false)
	{
		// Se for assincrono faz uma requisição pra uma url executar esta açao e nao aguarda  resposta
		// Feito isto pq o envio do email tem um delay do servidor de email, desnecessário o cliente esperar por isto
		if ($async and $id_order) {
			$url = $this->url->get() . 'cron/send_sms_order/' . $id_order;
			$commandExec = "wget " . $url . "  > /dev/null &";
			$exec = exec($commandExec);


			$LogOrderSmsSent = new LogOrderSmsSent();
			$LogOrderSmsSent->id_order = $id_order;
			$LogOrderSmsSent->obs = 'CartLib - Modo Async';
			$LogOrderSmsSent->created_at = date('Y-m-d H:i:s');
			$LogOrderSmsSent->save();

			return array(
				"success" => true,
				"message" => 'async'
			);
		}


		if ($id_order) {
			$order = $this->getOrder($id_order);
		}

		if ($order) {
			if ($order->send_to_sms) {
				$cell_number = $order->send_to_sms;
			} else {
				$customer = $order->Customers;
				$name = $customer->name;
				$cell_number = $customer->cell_number;
			}
			// remover os caracteres desnecessários
			$cell_number = str_replace(array(".", "-", "_", " ", "/", "(", ")"), "", $cell_number);


			// No BRASIL - valida o Whatsapp, adiciona o código do pais  +55
			if (COMPANY == 'lebillet') {
				if (substr($cell_number, 0, 3) != '+55') {
					$cell_number = '+55' . $cell_number;
				}
			}


			require_once(BASE_PATH . '/app/library/SMS.php');
			//$sendSMS = new SMS('teste');
			$sendSMS = new SMS('producao');

			$token_order = base64_encode($this->crypt->encryptBase64($order->id));
			$link_view_order = $this->url->get() . 'order/' . $token_order;

			$message = "Le Billet
Link para acesso ao(s) bilhete(s):

$link_view_order

Obrigado.";
			$sendSMS = $sendSMS->send($cell_number, $message);


			$sql = ' UPDATE orders SET sms_sent = 1 WHERE id = ' . $order->id; // 0 -> nao | 1 -> sim
			$this->db->execute($sql);

			$LogOrderSmsSent = new LogOrderSmsSent();
			$LogOrderSmsSent->id_order = $id_order;
			$LogOrderSmsSent->sms_to = $cell_number;

			if (isset($sendSMS['curl']['transaction'])) {
				$LogOrderSmsSent->message_id = $sendSMS['curl']['transaction'];
			}

			$LogOrderSmsSent->obs = print_r($sendSMS, true);
			$LogOrderSmsSent->created_at = date('Y-m-d H:i:s');
			$LogOrderSmsSent->save();

			if (isset($sendSMS['curl']['status']) and $sendSMS['curl']['status'] == 'OK') {
				return array(
					"success" => true,
					"message" => json_encode($sendSMS['curl']),
				);
			}
		} else {
			return array(
				"success" => false,
				"message" => 'Order Not Found'
			);
		}
	}






	/**
	 * Envia o email da compra
	 * Se já tiver o objeto $order, manda o $id_order como NULL e passa o objeto $order como parametro
	 * Assim não precisa fazer outra consulta no banco para pegar os dados da $order
	 */
	public function sendEmailOrder($id_order = null, $order = null, $async = false)
	{
		// Se for assincrono faz uma requisição pra uma url executar esta açao e nao aguarda  resposta
		// Feito isto pq o envio do email tem um delay do servidor de email, desnecessário o cliente esperar por isto
		if ($async and $id_order) {
			$url = $this->url->get() . 'cron/send_email_order/' . $id_order;
			$commandExec = "wget " . $url . "  > /dev/null &";
			$exec = exec($commandExec);

			$LogOrderEmailSent = new LogOrderEmailSent();
			$LogOrderEmailSent->id_order = $id_order;
			$LogOrderEmailSent->email_to = $commandExec;
			$LogOrderEmailSent->obs = 'CartLib - Modo Async';
			$LogOrderEmailSent->created_at = date('Y-m-d H:i:s');
			$LogOrderEmailSent->save();


			return array(
				"success" => true,
				"message" => 'async'
			);
		}


		if ($id_order) {
			$order = $this->getOrder($id_order);
		}


		if ($order) {
			if ($order->send_to_email) {
				$email = $order->send_to_email;
				$name = $order->send_to_email;
			} else {
				$customer = $order->Customers;
				$name = $customer->name;
				$email = $customer->email;
			}


			if ($order->id_orders_status == 10) {
				$template = 'facial-biometrics';
				$param = array('order' => $order, 'title' => $this->config->company->msg_email_order_biometrics . '  #' . $order->id);

				//function send($to, $subject, $template, $params)
				$sendMail = $this->getDI()->getMail()->send(
					array(
						$email => $name // destinatario
					),
					$this->config->company->msg_email_order_biometrics . '  #' . $order->id, // assunto
					$template, // template
					$param // array de parametros para ser usado no template
				);
			} else {
				$token_order = base64_encode($this->crypt->encryptBase64($order->id));
				$link_view_order = $this->url->get() . 'order/' . $token_order;
				$template = 'order-confirmation-slim-lebillet-new';
				$urlFiles = $this->di->get('urlFiles');
				$param = array('link_view_order' => $link_view_order, 'order' => $order, 'urlFiles' => $urlFiles, 'title' => $this->config->company->msg_email_order_confirmation . '  #' . $order->id);

				//function send($to, $subject, $template, $params)
				$sendMail = $this->getDI()->getMail()->send(
					array(
						$email => $name // destinatario
					),
					$this->config->company->msg_email_order_confirmation . '  #' . $order->id, // assunto
					$template, // template
					$param // array de parametros para ser usado no template
				);
			}



			if ($sendMail) {

				$sql = ' UPDATE orders SET email_sent = 1 WHERE id = ' . $order->id; // 0 -> nao | 1 -> sim
				$this->db->execute($sql);

				$LogOrderEmailSent = new LogOrderEmailSent();
				$LogOrderEmailSent->id_order = $id_order;
				$LogOrderEmailSent->email_to = $email;
				$LogOrderEmailSent->obs = 'Via CartLib ' . $sql;
				$LogOrderEmailSent->created_at = date('Y-m-d H:i:s');
				$LogOrderEmailSent->save();

				return array(
					"success" => true
				);
			} else {
				return array(
					"success" => false,
					"message" => print_r($sendMail)
				);
			}
		} else {
			return array(
				"success" => false,
				"message" => 'Order Not Found'
			);
		}
	}

	/**
	 * Envia o email da compra
	 * Se já tiver o objeto $order, manda o $id_order como NULL e passa o objeto $order como parametro
	 * Assim não precisa fazer outra consulta no banco para pegar os dados da $order
	 */
	public function sendEmailOrdersVerify()
	{
		$sql = "select * from orders where 
		id_orders_status = 2 and 
		id_orders_payment_status = 3 and   
		send_to_email is not null AND
		id in (select id_order from sales where id_event IN (859)) and
		id_customer < 65000";
		$orders = $this->db->fetchAll($sql);

		foreach ($orders as $o) {
			$order = $this->getOrder($o['id']);
			if ($order->send_to_email) {
				$email = $order->send_to_email;
				$name = $order->send_to_email;
			} else {
				$customer = $order->Customers;
				$name = $customer->name;
				$email = $customer->email;
			}

			$token_order = base64_encode($this->crypt->encryptBase64($order->id));
			$link_view_order = $this->url->get() . 'order/' . $token_order;
			$template = 'order-confirmation-slim-lebillet-new';
			$urlFiles = $this->di->get('urlFiles');
			$param = array('link_view_order' => $link_view_order, 'order' => $order, 'urlFiles' => $urlFiles, 'title' => $this->config->company->msg_email_order_confirmation . '  #' . $order->id);

			//function send($to, $subject, $template, $params)
			$sendMail = $this->getDI()->getMail()->send(
				array(
					$email => $name // destinatario
				),
				$this->config->company->msg_email_order_confirmation . '  #' . $order->id, // assunto
				$template, // template
				$param // array de parametros para ser usado no template
			);


			if ($sendMail) {

				$sql = ' UPDATE orders SET email_sent = 1 WHERE id = ' . $order->id; // 0 -> nao | 1 -> sim
				$this->db->execute($sql);

				$LogOrderEmailSent = new LogOrderEmailSent();
				$LogOrderEmailSent->id_order = $order->id;
				$LogOrderEmailSent->email_to = $email;
				$LogOrderEmailSent->obs = 'Via CartLib ' . $sql;
				$LogOrderEmailSent->created_at = date('Y-m-d H:i:s');
				$LogOrderEmailSent->save();
			}
		}
	}

	public function sendEmailFatura($fatura = null, $id_sale = null)
	{
		if ($fatura && $id_sale) {

			$sale = Sales::findFirst($id_sale);
			if ($sale) {
				$customerSaft = CustomerSaft::findFirst('id_order = ' . $sale->id_order);
				if ($customerSaft) {
					if (!isset($sale->Customers) || !$sale->Customers) {
						$sale->Customers = new Customers();
					}
					$sale->Customers->name = $customerSaft->name;
					$sale->Customers->id_number = $customerSaft->nif;
					$sale->Customers->address_1 = $customerSaft->morada;
					$sale->Customers->email = $customerSaft->email;
				}

				$customer = $sale->Customers;
				$template = 'fatura-confirmation';
				$urlSup = $this->config->application->baseUriSup;
				$param = array('fatura' => $fatura, 'urlSup' => $urlSup, 'customer' => $customer);
				$file = $this->config->application->pathSupPdf . $fatura;
				//function send($to, $subject, $template, $params)
				$sendMail = $this->getDI()->getMail()->send(
					array(
						$customer->email => $customer->name // destinatario
					),
					'Fatura do pedido  #' . $sale->id_order, // assunto
					$template, // template
					$param, // array de parametros para ser usado no template
					$file
				);


				if ($sendMail) {
					return array(
						"success" => true
					);
				} else {
					return array(
						"success" => false,
						"message" => print_r($sendMail)
					);
				}
			} else {
				return array(
					"success" => false,
					"message" => 'Sale Not Found'
				);
			}
		} else {
			return array(
				"success" => false,
				"message" => 'Sale Not Found'
			);
		}
	}

	public function sendEmailFaturaOrg($fatura = null, $name, $nif, $morada, $email)
	{
		if ($fatura) {

			$customer = new Customers();
			$customer->id = time();
			$customer->name = $name;
			$customer->id_number = $nif;
			$customer->address_1 = $morada;
			$customer->email = $email;

			$template = 'fatura-confirmation';
			$urlSup = $this->config->application->baseUriSup;
			$param = array('fatura' => $fatura, 'urlSup' => $urlSup, 'customer' => $customer);
			$file = $this->config->application->pathSupPdf . $fatura;

			//function send($to, $subject, $template, $params)
			$sendMail = $this->getDI()->getMail()->send(
				array(
					$customer->email => $customer->name // destinatario
				),
				'Fatura Lebillet', // assunto
				$template, // template
				$param, // array de parametros para ser usado no template
				$file
			);



			if ($sendMail) {
				return array(
					"success" => true
				);
			} else {
				return array(
					"success" => false,
					"message" => print_r($sendMail)
				);
			}
		} else {
			return array(
				"success" => false,
				"message" => 'Sale Not Found'
			);
		}
	}

	public function sendEmailMultiBanco($id_order = null, $entity, $expireDate, $reference, $value, $async = false)
	{
		// Se for assincrono faz uma requisição pra uma url executar esta açao e nao aguarda  resposta
		// Feito isto pq o envio do email tem um delay do servidor de email, desnecessário o cliente esperar por isto
		if ($async) {
			$url = $this->url->get() . 'cron/send_multibanco_sibs/' . $id_order . '?entity=' . $entity . '&expireDate=' . $expireDate . '&reference=' . $reference . '&value=' . $value;
			$commandExec = "wget " . $url . "  > /dev/null &";
			$exec = exec($commandExec);

			$LogOrderEmailSent = new LogOrderEmailSent();
			$LogOrderEmailSent->id_order = $id_order;
			$LogOrderEmailSent->email_to = $commandExec;
			$LogOrderEmailSent->obs = 'CartLib - Modo Async';
			$LogOrderEmailSent->created_at = date('Y-m-d H:i:s');
			$LogOrderEmailSent->save();

			return array(
				"success" => true,
				"message" => 'async'
			);
		}


		if ($id_order) {
			$order = $this->getOrder($id_order);
		}


		if ($order) {
			if ($order->send_to_email) {
				$email = $order->send_to_email;
				$name = $order->send_to_email;
			} else {
				$customer = $order->Customers;
				$name = $customer->name;
				$email = $customer->email;
			}



			$template = 'multibanco-sibs';
			$param = array(
				'order' => $order,
				'entity' => $entity,
				'expireDate' => $expireDate,
				'reference' => $reference,
				'customer' => $order->Customers,
				'value' => $value,
				'title' => 'Lebillet - Multibanco ' . '  #' . $order->id
			);

			//function send($to, $subject, $template, $params)
			$sendMail = $this->getDI()->getMail()->send(
				array(
					$email => $name // destinatario
				),
				$this->config->company->msg_email_order_confirmation . '  #' . $order->id, // assunto
				$template, // template
				$param // array de parametros para ser usado no template
			);

			if ($sendMail) {
				return array(
					"success" => true
				);
			} else {
				return array(
					"success" => false,
					"message" => print_r($sendMail)
				);
			}
		} else {
			return array(
				"success" => false,
				"message" => 'Order Not Found'
			);
		}
	}

	public function sendSmsTwilio($to = null, $code = "", $async = false)
	{
		if ($async and $to) {
			$url = $this->url->get() . 'cron/send_sms_twilio?to=' . $to . '&msg=' . $code;
			$commandExec = "wget " . $url . "  > /dev/null &";
			$exec = exec($commandExec);

			$LogOrderWhatsappSent = new LogOrderWhatsappSent();
			$LogOrderWhatsappSent->id_order = $id_order;
			$LogOrderWhatsappSent->whatsapp_to = $commandExec;
			$LogOrderWhatsappSent->obs = 'CartLib - Modo Async';
			$LogOrderWhatsappSent->created_at = date('Y-m-d H:i:s');
			$LogOrderWhatsappSent->save();
			return array(
				"success" => true,
				"message" => 'async'
			);
		}

		if ($to) {

			require_once(BASE_PATH . '/app/library/SMS.php');
			$sendSMS = new SMS('producao');
			$sendSMS = $sendSMS->send($to, $code);

			if (isset($sendSMS['curl']['status']) and $sendSMS['curl']['status'] == 'OK') {
				return array(
					"success" => true,
					"message" => json_encode($sendSMS['curl']),
				);
			}

			/* require_once(BASE_PATH . '/app/library/SMSTwilio.php');
			$sendSMS = new SMSTwilio('ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', '+19452123330');
			
			$message = $code;
			$sendSMS = $sendSMS->send($to, $message);

			if (isset($sendSMS)) {
				return array(
					"success" => true,
					"sid" => json_encode($sendSMS),
				);
			}else{
				return array(
					"success" => false,
					"sid" => json_encode($sendSMS),
				);
			} */

			/* require_once(BASE_PATH . '/app/library/SMS.php');
			$sendSMS = new SMS('producao');

			$message = "Código de confirmação de cadastro Lebillet: ". $code;
			$sendSMS = $sendSMS->send($to, $message);

			if (isset($sendSMS['curl']['status']) and $sendSMS['curl']['status'] == 'OK') {
				return array(
					"success" => true,
					"message" => json_encode($sendSMS['curl']),
				);
			} */
		} else {
			return array(
				"success" => false,
				"message" => 'Number Not Found'
			);
		}
	}

	public function getTotalSalesEvent($idProduct, $idEvent)
	{
		$sql = "
			SELECT
				p.current_lot,
				p.id,
			    p.name product,
			    pl.lot_number,
			    psl.sales_limit,
				p.fraction,
			    (SELECT  COUNT(DISTINCT (si.ticket)) FROM sales_items si WHERE si.id_product = pl.id_product AND si.product_lot =  pl.lot_number AND si.status = 1) sales,
				(SELECT COUNT(id) FROM products_seats prs WHERE prs.id_product = p.id AND prs.status in (1,4)) products_seats_count
			FROM products p
			LEFT JOIN products_lots pl
			    ON p.id = pl.id_product
			LEFT JOIN products_sales_limit psl
			    ON psl.id_product = pl.id_product  AND psl.product_lot = pl.lot_number
			WHERE p.id_event = " . $idEvent . " AND p.id = " . $idProduct . " 
			GROUP BY pl.id_product, pl.lot_number
			ORDER BY p.name, pl.id_product,	pl.lot_number
   		";
		return $this->db->fetchAll($sql);
	}




	/**
	Lógica para gerar o numero do ingresso
	 */
	public function ticketGenerate($id_event = 0, $id_product = 0, $id_type = 0, $check_stock = true, $is_migrator = false)
	{
		// Verifica se tem estoque pra este produto
		if ($check_stock) {
			$filter_type = ' AND id_product_type IS NULL';
			// Para o tipo definido, ou tipo genérico (NULL)
			if ($id_type > 0) {
				$filter_type = " AND (id_product_type = $id_type OR  id_product_type IS NULL ) ORDER BY id_product_type DESC ";
			}
			$sql = " SELECT ticket FROM ticket_stock WHERE status = '0' AND id_event = $id_event AND id_product = $id_product  $filter_type LIMIT 1 ";
			$result_stock = $this->db->fetchOne($sql);
		} else {
			$result_stock = false;
		}

		if ($result_stock) {
			$ticket = $result_stock['ticket'];

			// Remove o estoque depois de utiliza-lo
			$sql = " DELETE FROM ticket_stock WHERE id_event = $id_event AND ticket = '$ticket' AND status = '0' LIMIT 1 ";
			$this->db->execute($sql);
		} else {
			// Não achou no stock, vai gerar um novo código
			// Para ingresso FISICO, vem da API, começa com 5 ou 6
			$caracteres0 = "56";
			$caracteres1 = "0123456789";

			// caso já tenha verificado se é migrador antes, muda a inicial do ticket pra nao dar conflito
			if ($is_migrator) {
				$caracteres0 = '2';
			}

			$ticket =  substr(str_shuffle($caracteres0), 0, 1) . str_shuffle(substr(str_shuffle($caracteres1), 0, 3)) . str_shuffle(substr(str_shuffle($caracteres1), 0, 3));

			/** CHECA SE O NUMERO JÁ EXISTE PARA O EVENTO */
			$sql = " SELECT COUNT(1) qty FROM sales_items WHERE id_event = $id_event AND ticket = '$ticket' LIMIT 1 ";
			$result = $this->db->fetchOne($sql);
			if ($result['qty'] > 0) {
				return ticketGenerate($id_event, $id_product, $id_type, false, $is_migrator);
			}
		}


		return $ticket;
	}
}

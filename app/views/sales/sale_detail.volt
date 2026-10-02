
<div class="modal-header ">
	<h5 class="modal-title">
		{{ t._('Order') }} #{{ order.id }}
		<small>
			&nbsp; - &nbsp;
			<?php echo formatMoney($order->value_total)  ?>
			&nbsp; - &nbsp;
			<?php echo formatDate($order->created_at)  ?>
		</small>
	</h5>
	<button type="button" class="close" data-dismiss="modal" aria-label="Close">
		<span aria-hidden="true">&times;</span>
	</button>
</div>
<div class="modal-body">











	<?php
		$mais_que_um = 0;
		foreach ( $order->OrderSale AS $sales) :
		$sale = $sales->Sales;
		$mais_que_um++;
	?>
		<div class="div-event-data">
			<h5>{{ sale.Events.name }}
				<small>
					&nbsp; &nbsp;
					<?php echo date('d, M, Y - l', strtotime($sale->Events->date_start) ) ?>
				</small>
			</h5>

			<div>
				<i class="fa fa-map-marker" aria-hidden="true"></i> &nbsp;
				{{ sale.Events.Places.name }} - {{ sale.Events.Cities.name}}/{{ sale.Events.Regions.acronym }}
			</div>
			<div>
				<small>{{ t._('Open') }}:</small> <?php echo date('H:i', strtotime($sale->Events->date_opening)) ?>
				&nbsp; &nbsp; &nbsp;
				<small>{{ t._('Start') }}:</small> <?php echo date('H:i', strtotime($sale->Events->date_start)) ?>
			</div>
		</div>


		<table class="table  table-sm mt-3">
			<thead>
				<tr>
					<th style="padding: 0; margin: 0"></th>
					<th>{{ t._('product') }}</th>
					<th>{{ t._('price') }}</th>
					<th>{{ t._('fee') }}</th>
					<th>{{ t._('tax') }}</th>
					<th>{{ t._('total') }}</th>
				</tr>
			</thead>
			<tbody>
				<?php
					$products = $sale->SalesItems;
					$value_total = $sale->value_delivery;
					$cont = 0;
					foreach ( $products AS $product ) :
					$value_product = $product->value_product;
					$value_fees = $product->value_fee + $product->value_fee_org ;
					$value_taxes = $product->value_product_tax + $product->value_fee_tax + $product->value_fee_org_tax ;
					$value_subtotal = $value_product + $value_fees + $value_taxes;
					$value_total += $value_subtotal;
				?>
					<tr>
						<td style="vertical-align: middle; padding: 0;">
							<small><?php echo ++$cont ?></small>
						</td>
						<td>
							{{ product.Products.name }}<br />
							<small>{{ product.Products.ProductsGenres.name }} - {{ product.ProductsTypes.name }}</small>
						</td>
						<td ><?php echo formatMoney($value_product) ?></td>
						<td ><?php echo formatMoney($value_fees) ?></td>
						<td ><?php echo formatMoney($value_taxes) ?></td>
						<td ><?php echo formatMoney($value_subtotal) ?></td>
					</tr>
				<?php  endforeach; ?>
				<?php if ( $sale->value_delivery > 0 ) : ?>
					<tr>
						<th colspan="5" class="text-right">{{ t._('DELIVERY') }}</th>
						<td ><?php echo formatMoney($sale->value_delivery) ?></td>
					</tr>
				<?php endif ; ?>
				<tr>
					<th colspan="5" class="text-right">{{ t._('TOTAL') }}</th>
					<td ><?php echo formatMoney($value_total) ?></td>
				</tr>
			</tbody>
		</table>



	<?php  endforeach ;  ?>


	<h5 class="text-center my-2">{{ t._('payment_information') }}</h5>

	<dl class="row">
		<dt class="col-sm-3">{{ t._('type') }}</dt>
		<dd class="col-sm-9">{{ t._(order.PaymentTypes.name) }}</dd>

		<dt class="col-sm-3">{{ t._('status') }}</dt>
		<dd class="col-sm-9">{{ t._(order.OrdersPaymentStatus.name) }}</dd>

		<?php
			if ( $order->id_orders_payment_status == 3 AND $order->id_payment_type == 2 )  :// Payment received
			$payment = $order->OrdersPayment;
			$payment = $payment[0];
		?>
			<dt class="col-sm-3">{{ t._('Card Number') }}</dt>
			<dd class="col-sm-9">{{ payment.cc_number }}</dd>

			<dt class="col-sm-3">{{ t._('Auth Code') }}</dt>
			<dd class="col-sm-9">{{ payment.cc_authcode }}</dd>

			<dt class="col-sm-3">{{ t._('Transaction Id') }}</dt>
			<dd class="col-sm-9">{{ payment.cc_transactionid }}</dd>
		<?php endif ; ?>
	</dl>












</div>


<div class="modal-footer">
	<button type="button" class="btn btn-secondary" data-dismiss="modal">{{ t._('close') }}</button>

	<div class="btn-group input-group div-send-email">
		<input type="text" class="form-control input-send-email" value="{{ order.send_to_email }}"  placeholder="{{ order.send_to_email }}" aria-label="{{ order.send_to_email }}" >
		<button class="btn btn-primary btn-send-email" onclick="sendEmail({{ order.id }});" type="button">{{ t._('send_email') }}</button>
	</div>

</div>

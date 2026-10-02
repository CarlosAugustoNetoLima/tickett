{{ content() }}
<form class=" mb-3 " method="POST">
	<div class="container-fluid">
		<h3>{{ t._('sales') }}</h3>
	<div class="row">

		<div class="col-md-5">
			<div class="form-group">
				<div class='input-group date' id='datetimepicker6' style="width: 100%">
					<input type='text' class="form-control" name="date_start" value="{{ date_start }}" />
					<span class="input-group-addon">
						<span class="fa fa-calendar"></span>
					</span>
				</div>
			</div>
		</div>

		<div class="col-md-5">
			<div class="form-group">
				<div class='input-group date' id='datetimepicker7' style="width: 100%">
					<input type='text' class="form-control" name="date_end" value="{{ date_end }}" />
					<span class="input-group-addon">
						<span class="fa fa-calendar"></span>
					</span>
				</div>
			</div>
		</div>

		<div class="col-md-2">

			<div class="btn-group" role="group" aria-label="Basic example">
				<button type="submit" class="btn btn-primary " style="    padding: 0.5rem 1.75rem;">
					<i class="fa fa-check" aria-hidden="true"></i>
				</button>
				<button type="button" class="btn btn-secondary " data-toggle="collapse" data-target="#filterAdvanced"  aria-expanded="false" aria-controls="filterAdvanced">
					<i class="fa fa-filter" aria-hidden="true"></i>
				</button>
			</div>

		</div>

	</div>

		<div class="collapse" id="filterAdvanced">

				<div class="form-row">

				    <div class="form-group col-md-4">
				      <input type="text" class="form-control" id="payment_type" name="payment_type" placeholder="{{ t._('payment_type') }}" value="<?php echo isset($payment_type) ? "[$payment_type]" : '' ?>" >
				    </div>

				    <div class="form-group col-md-4">
				      <input type="text" class="form-control" id="payment_status" name="payment_status" placeholder="{{ t._('payment_status') }}"  value="<?php echo isset($payment_status) ? "[$payment_status]" : '' ?>"  style="width: 100%">
				    </div>

				    <div class="form-group col-md-4">
				      <input type="text" class="form-control" id="order_status"  name="order_status" placeholder="{{ t._('order_status') }}"   value="<?php echo isset($order_status) ? "[$order_status]" : '' ?>" >
				    </div>

				  </div>



		</div>


	</div>
</form>




<table class="table table-striped  table-hover table-responsive">
	<thead class="thead-light">
		<tr>
			<th scope="col">{{ t._('date') }}</th>
			<th scope="col">{{ t._('total') }}</th>
			<th scope="col">{{ t._('email_address') }}</th>
			<th scope="col">{{ t._('events') }}</th>
			<th scope="col">{{ t._('payment') }}</th>
			<th scope="col">{{ t._('status') }}</th>
		</tr>
	</thead>
	<tbody>
		<?php
			$value_total = $cont =  0;
			$payment_type_total = $events_total = $status_total = $cont_email = array();
			foreach ( $orders AS $order ) :
				$cont++;
				$value_total += $order->value_total;
				$cont_email[$order->send_to_email] =  (
					isset($cont_email[$order->send_to_email])
					 ? $cont_email[$order->send_to_email] + 1
					 : 1 );

				$payment_type_total[$this->t->_($order->PaymentTypes->name)]['value'] = (
					isset($payment_type_total[$this->t->_($order->PaymentTypes->name)]['value'])
					?  $payment_type_total[$this->t->_($order->PaymentTypes->name)]['value'] + $order->value_total
					:  $order->value_total );

				$payment_type_total[$this->t->_($order->PaymentTypes->name)]['qty'] =  (
					isset($payment_type_total[$this->t->_($order->PaymentTypes->name)]['qty'])
					?  $payment_type_total[$this->t->_($order->PaymentTypes->name)]['qty'] + 1
					:  1 );

				$status_total[$this->t->_($order->OrdersStatus->name)]['qty'] = (
					isset($status_total[$this->t->_($order->OrdersStatus->name)]['qty'])
					? $status_total[$this->t->_($order->OrdersStatus->name)]['qty'] + 1
					: 1 );

				$status_total[$this->t->_($order->OrdersStatus->name)]['value'] = (
					isset($status_total[$this->t->_($order->OrdersStatus->name)]['value'])
					 ? $status_total[$this->t->_($order->OrdersStatus->name)]['value'] + $order->value_total
					 : $order->value_total );

		?>
			<tr>

				<td class="align-middle">
					<small>
						<?php echo date('d/m/y', strtotime($order->created_at)) ?>
						<br />
						<?php echo date('H:i:s', strtotime($order->created_at)) ?>
					</small>
				</td>

				<td class="align-middle">
					<?php echo formatMoney($order->value_total) ?>
				</td>

				<td class="align-middle">
					<button type="button" class="btn btn-outline-dark" data-remote="{{ urlSales }}sale_detail/{{ order.id }}" data-toggle="modal" data-target="#modal_order">
						{{ order.send_to_email }}
					</button>
				</td>

				<td class="align-middle">
					<?php
					$events_in_order = array();
					foreach ( $order->OrderSale AS $order_sale ) {
						$label_event =  $order_sale->Sales->id_event . ') ' .  $order_sale->Sales->Events->name;
						$events_in_order[] = $label_event;

						$events_total[$label_event]['value'] = ( isset($events_total[$label_event]['value']) ? $events_total[$label_event]['value'] + $order_sale->Sales->value_total : $order_sale->Sales->value_total );
						$events_total[$label_event]['qty'] = ( isset($events_total[$label_event]['qty']) ? $events_total[$label_event]['qty'] + 1 : 1 );
					}
					?>
					<?php echo implode('<br />', $events_in_order) ?>
				</td>

				<td class="align-middle">
					<small>
						{{  t._(order.OrdersPaymentStatus.name) }}
						<br>
						{{ t._(order.PaymentTypes.name) }}
					</small>
				</td>

				<td class="align-middle">
					{{ t._(order.OrdersStatus.name) }}
				</td>

			</tr>
		<?php endforeach ; ?>

		<tr class="table-info">

			<td>
				{{ t._('qty') }}: {{ cont }}
			</td>

			<td>
				<?php echo formatMoney($value_total) ?>
			</td>

			<td>
				{{ t._('different') }}: <?php echo count($cont_email) ?>
			</td>

			<td>	<!-- events -->
				<small>
					<?php foreach ($events_total as $key => $value) : ?>
						<div>
							{{ key }}: {{ value['qty'] }}
							<span class="float-right">
								<?php echo formatMoney($value['value']) ?>
							</span>
						</div>
					<?php endforeach ; ?>
				</small>
			</td>

			<td>	<!-- payment -->
				<small>
					<?php foreach ($payment_type_total as $key => $value) : ?>
						<div>
							{{ key }}: {{ value['qty'] }}
							<span class="float-right">
								<?php echo formatMoney($value['value']) ?>
							</span>
						</div>
					<?php endforeach ; ?>
				</small>
			</td>

			<td>	<!-- status -->
				<small>
					<?php foreach ($status_total as $key => $value) : ?>
						<div>
							{{ key }}: {{ value['qty'] }}
							<span class="float-right">
								<?php echo formatMoney($value['value']) ?>
							</span>
						</div>
					<?php endforeach ; ?>
				</small>

			</td>


		</tr>

	</tbody>
</table>








	<div class="modal fade" id="modal_order" tabindex="-1" role="dialog" aria-labelledby="modal_order" aria-hidden="true">
		<div class="modal-dialog  modal-lg modal-dialog-centered" role="document">
			<div class="modal-content">
			</div>
		</div>
	</div>






<script type="text/javascript">
	var payment_status_data = [ {id:1,name:"{{ t._('Pending') }}"}, {id: 3, name: "{{ t._('Payment received') }}"}, {id: 5, name: "{{ t._('Canceled') }}"}, {id: 7, name: "{{ t._('Error') }}"} ];

	var payment_type_data = [ {name: '{{ t._('Cash') }}', id: 1}, {name: '{{ t._('Credit Card') }}', id: 2} , {name: '{{ t._('Courtesy') }}', id: 7} ];

	var order_status_data = [ {id:2,name:"{{ t._('Confirmed') }}"}, {id: 3, name: "{{ t._('Canceled') }}"} ];
</script>

<?php

?>





<form class=" mb-3 " method="POST">
	<div class="container-fluid">
		<h3>{{ t._('balance') }}</h3>
		<div class="row">

			<div class="col-md-5">
				<div class="form-group">
					<div class='input-group date' id='datetimepicker6' style="width: 100%">
						<input type='text' class="form-control" name="date_start"  value="<?php echo isset($date_start) ? "[$date_start]" : '' ?>" >
						<span class="input-group-addon">
							<span class="fa fa-calendar"></span>
						</span>
					</div>
				</div>
			</div>

			<div class="col-md-5">
				<div class="form-group">
					<div class='input-group date' id='datetimepicker7' style="width: 100%">
						<input type='text' class="form-control" name="date_end"  value="<?php echo isset($date_end) ? "[$date_end]" : '' ?>" >
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
					<input type="text" class="form-control" id="event_filter" name="event_filter" placeholder="{{ t._('events') }}" value="<?php echo isset($event_filter) ? "[$event_filter]" : '' ?>" >
				</div>

			</div>



		</div>


	</div>
</form>



<div class="container-fluid">
	<div class="row">
		{{ content() }}

		<?php
		$events = $payment_types = $total_payment = array();
		$total_qty = $total_value_product = $total_value_tax  = $total_value_fee = 0;
		foreach ($balance as $value)
		{
			$payment_types[$value['id_payment_type']] = $value['name_payment_type'];

			$events[$value['id_event']][$value['id_payment_type']]['qty'] = $value['qty'];
			$events[$value['id_event']][$value['id_payment_type']]['value_product'] = $value['value_product'];
			$events[$value['id_event']][$value['id_payment_type']]['value_tax'] = $value['value_tax'];
			$events[$value['id_event']][$value['id_payment_type']]['value_fee'] = $value['value_fee'];
			$events[$value['id_event']][$value['id_payment_type']]['value_tax_fee'] = ($value['value_fee'] +  $value['value_tax']);


			$events_distincts[$value['id_event']]['name'] = $value['name_event'];
			$events_distincts[$value['id_event']]['qty'] = isset($events_distincts[$value['id_event']]['qty']) ? $events_distincts[$value['id_event']]['qty'] + $value['qty'] : $value['qty'];
			$events_distincts[$value['id_event']]['value_tax'] =  isset($events_distincts[$value['id_event']]['value_tax']) ? $events_distincts[$value['id_event']]['value_tax'] + $value['value_tax'] : $value['value_tax'] ;
			$events_distincts[$value['id_event']]['value_fee'] =  isset($events_distincts[$value['id_event']]['value_fee']) ? $events_distincts[$value['id_event']]['value_fee'] +  $value['value_fee'] :  $value['value_fee'] ;
			$events_distincts[$value['id_event']]['value_product'] = isset($events_distincts[$value['id_event']]['value_product']) ? $events_distincts[$value['id_event']]['value_product'] +  $value['value_product'] :  $value['value_product'] ;

			$events_distincts[$value['id_event']]['value_tax_fee'] = $events_distincts[$value['id_event']]['value_fee'] + $events_distincts[$value['id_event']]['value_tax'];


			$total_qty += $value['qty'];
			$total_value_product += $value['value_product'];
			$total_value_tax += $value['value_tax'];
			$total_value_fee += $value['value_fee'];
			$total_value_fee_tax = $total_value_fee + $total_value_tax;

			$payment_qty[$value['id_payment_type']] = isset($payment_qty[$value['id_payment_type']]) ? $payment_qty[$value['id_payment_type']] + $value['qty'] : $value['qty'];
			$payment_value_product[$value['id_payment_type']] = isset($payment_value_product[$value['id_payment_type']]) ? $payment_value_product[$value['id_payment_type']] + $value['value_product'] : $value['value_product'];
			$payment_value_tax[$value['id_payment_type']] = isset($payment_value_tax[$value['id_payment_type']]) ? $payment_value_tax[$value['id_payment_type']] + $value['value_tax'] : $value['value_tax'];
			$payment_value_fee[$value['id_payment_type']] = isset($payment_value_fee[$value['id_payment_type']]) ? $payment_value_fee[$value['id_payment_type']] + $value['value_fee'] : $value['value_fee'];
			$payment_value_fee_tax[$value['id_payment_type']] = $payment_value_tax[$value['id_payment_type']] + $payment_value_fee[$value['id_payment_type']];
		}
		?>

		<?php if ( isset($events_distincts) ) : ?>

			<table class="table table-striped  table-hover table-responsive" id="table-balance">
				<thead class="thead-light text-center">
					<tr>

						<th scope="col" rowspan="2" style="    width: 50%;">
							{{ t._('events') }}
							<label style=" float: right; font-size: 10px;  font-weight: normal;" >
								<input type="checkbox" id="check-show-tax-fee" onchange="showDetail('#table-balance .div-tax-fee', '#table-balance')">{{ t._('Show Tax/Fee') }}
							</label>
						</th>

						<th scope="col" colspan="2" class="text-center">
							{{ t._('products') }}
						</th>


						<th scope="col" colspan="<?php echo count($payment_types) * 2 ?>" class="text-center ">
							{{ t._('Payment Types') }}
						</th>

					</tr>

					<tr>

						<th scope="col" class=" text-center">
							<small> {{ t._('qty') }}</small>
						</th>
						<th scope="col" class=" text-center">
							<small>{{ t._('value') }}</small>
						</th>

						<?php foreach ( $payment_types AS $id_payment_type => $name_payment_type ) : ?>
							<th scope="col" colspan="2" class="text-center ">
								<small> {{ t._(name_payment_type) }}</small>
							</th>
						<?php endforeach ; ?>

					</tr>

				</thead>
				<tbody>
					<?php foreach ( $events_distincts AS $id_event => $event ) : ?>
						<tr>

							<td class="align-middle">
								{{ id_event }}) {{ event['name'] }}
							</td>

							<td class="td-divider text-center">
								{{ event['qty'] }}
							</td>
							<td>
								<?php echo formatMoney($event['value_product']) ?>
								<div class="div-tax-fee">
									<small>+{{ event['value_tax_fee'] }} = <?php echo number_format($event['value_product'] +  $event['value_tax_fee'], 2)  ?></small>
								</div>
							</td>

							<?php foreach ( $payment_types AS $id_payment_type => $name_payment_type ) : ?>
								<?php if ( isset($events[$id_event][$id_payment_type]['qty']) ) : ?>
									<td class="td-divider  text-center">
										<?php echo $events[$id_event][$id_payment_type]['qty']  ?>
									</td>
									<td class="">
										<?php echo formatMoney($events[$id_event][$id_payment_type]['value_product'])  ?>

										<div class="div-tax-fee">
											<small>
												+<?php echo $events[$id_event][$id_payment_type]['value_tax_fee'] ?> = <?php echo number_format($events[$id_event][$id_payment_type]['value_product'] +  $events[$id_event][$id_payment_type]['value_tax_fee'], 2)  ?>
											</small>
										</div>

									</td>
									<?php else : ?>
										<td class="td-divider  text-center">0</td>
										<td></td>
									<?php endif ; ?>
								<?php endforeach ; ?>
							</tr>
						<?php endforeach ; ?>

						<tr class="table-info">

							<td class="align-middle">
								Total
							</td>

							<td class="td-divider text-center">
								{{ total_qty }}
							</td>

							<td>
								<?php echo formatMoney($total_value_product)  ?>
								<div class="div-tax-fee">
									<small>
										+<?php echo $total_value_fee_tax ?> = <?php echo number_format($total_value_fee_tax + $total_value_product, 2)  ?>
									</small>
								</div>
							</td>

							<?php foreach ( $payment_types AS $id_payment_type => $name_payment_type ) : ?>
								<td class="td-divider  text-center">
									<?php echo $payment_qty[$id_payment_type] ?>
									<td>
										<?php echo formatMoney($payment_value_product[$id_payment_type])  ?>
										<div class="div-tax-fee">
											<small>
												+<?php echo $payment_value_fee_tax[$id_payment_type] ?> = <?php echo  number_format($payment_value_fee_tax[$id_payment_type] + $payment_value_product[$id_payment_type], 2)  ?>
											</small>
										</div>
									</td>
								<?php endforeach ; ?>
							</tr>

					</tbody>
			</table>


			<script type="text/javascript">
				<?php
				$events_filter_data = array();
				foreach ($events_distincts as $id_event => $event) {
					$events_filter_data[] = ' { id: ' . $id_event . ', name : "' . $id_event . ') ' . $event['name'] . '" } ';
				}
				?>
				var events_filter_data = [ <?php echo implode(',', $events_filter_data) ?> ];
			</script>

			<?php else : ?>

				<div class="col alert alert-primary" role="alert">
					<h4 class="alert-heading">Sem vendas</h4>
					<p>Não existe movimentação de vendas para serem exibidas</p>
					<hr>
					<p class="mb-0">Caso esteja utilizando algum filtro, tente modificar ou eliminar os filtros</p>
				</div>

			<?php endif ; ?>




	</div>
</div>






<?php
	foreach ( $cart['event'] AS $id_event => $event ) :
?>
	<ul class="list-group mb-3">
		 <li class="list-group-item list-group-item-info" >
			<h5 class="my-0"><?php echo $event['event_name'] ?>
				<span class="float-right">
					<form action="{{ url() }}cart" method="POST">
						<input type="hidden" name="event_remove" value="<?php echo $event['event']?>">
							<button type="submit" class="close" aria-label="X" >
								<span aria-hidden="true" data-toggle="tooltip" title="{{ t._('remove_event_from_cart') }}">&times;</span>
							</button>
					</form>
				</span>
			</h5>
		 </li>
	<?php
		foreach ( $event['products'] AS $id_product => $product ) :
			foreach ( $product AS $id_type => $type ) :
				$product_value_unit = ($type['price'] + $type['fee_value'] + $type['fee_org_value'] + $type['tax'] + $type['fee_tax'] + $type['fee_org_tax'] );
	?>
				<li class="list-group-item d-flex justify-content-between lh-condensed">
					<div>
						<h6 class="my-0">{{ type['qty'] }}x {{ type['name'] }}</h6>
						<button type="button" class="text-muted  btn-link" data-toggle="tooltip" data-html="true"
							title="
								<h6>Unitary Value</h6>
								<table class='table'>
									<thead>
										<tr>
											<th scope='col'>{{ t._('product') }}</th>
											<?php if ( $type['tax'] > 0 ) : ?>
												<th scope='col'>{{ t._('tax') }}</th>
											<?php endif ; ?>
											<?php if ( $type['fee_value'] > 0 ) : ?>
												<th scope='col'>{{ t._('fee') }}</th>
											<?php endif ; ?>
											<?php if ( $type['fee_tax'] > 0 ) : ?>
												<th scope='col'>{{ t._('fee_tax') }}</th>
											<?php endif ; ?>
											<?php if ( $type['fee_org_value'] > 0 ) : ?>
												<th scope='col'>{{ t._('fee_org') }}</th>
											<?php endif ; ?>
											<?php if ( $type['fee_org_tax'] > 0 ) : ?>
												<th scope='col'>{{ t._('fee_org_tax') }}</th>
											<?php endif ; ?>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td><?php echo formatMoney($type['price'], false) ?></td>
											<?php if ( $type['tax'] > 0 ) : ?>
												<td><?php echo formatMoney($type['tax'], false) ?></td>
											<?php endif ; ?>
											<?php if ( $type['fee_value'] > 0 ) : ?>
												<td><?php echo formatMoney($type['fee_value'], false) ?></td>
											<?php endif ; ?>
											<?php if ( $type['fee_tax'] > 0 ) : ?>
												<td><?php echo formatMoney($type['fee_tax'], false) ?></td>
											<?php endif ; ?>
											<?php if ( $type['fee_org_value'] > 0 ) : ?>
												<td><?php echo formatMoney($type['fee_org_value'], false) ?></td>
											<?php endif ; ?>
											<?php if ( $type['fee_org_tax'] > 0 ) : ?>
												<td><?php echo formatMoney($type['fee_org_tax'], false) ?></td>
											<?php endif ; ?>
										</tr>
									</tbody>
								</table>
								">
							<small class="text-muted">
								{{ type['qty'] }} x <?php echo formatMoney($product_value_unit) ?>
							</small>
						</button>
					</div>
					<span class="text-muted"><?php echo formatMoney($product_value_unit * $type['qty'])  ?></span>
				</li>
	<?php
			endforeach;
		endforeach;
	?>

		<?php if ( isset($event['event_delivery_set']) AND is_array($event['event_delivery_set']) ) : ?>
			<li class="list-group-item d-flex justify-content-between lh-condensed">
				<div>
					<h6 class="my-0">{{ t._('delivery') }}</h6>
					<button type="button" class="text-muted  btn-link" <?php if ( $event['event_delivery_set']['value'] > 0 ) : ?>
						data-toggle="tooltip" data-html="true"
							title="
								<table class='table'>
									<thead>
										<tr>
											<th scope='col'>{{ t._('delivery') }}</th>
											<?php if ( $event['event_delivery_set']['value_tax'] > 0 ) : ?>
												<th scope='col'>{{ t._('delivery_tax') }}</th>
											<?php endif ; ?>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td><?php echo formatMoney($event['event_delivery_set']['value'], false) ?></td>
											<?php if ( $event['event_delivery_set']['value_tax'] > 0 ) : ?>
												<td><?php echo formatMoney($event['event_delivery_set']['value_tax'], false) ?></td>
											<?php endif ; ?>
										</tr>
									</tbody>
								</table>
								"
							<?php endif ; // if ( $event['event_delivery_set']['value'] > 0 ) ?>
							>
							<small class="text-muted">
								<?php echo $event['event_delivery_set']['name'] ?>
							</small>
						</button>
				</div>
				<span class="text-muted"><?php echo formatMoney($event['event_delivery_set']['value'] + $event['event_delivery_set']['value_tax'])  ?></span>
			</li>
		<?php endif ; ?>
		<li class="list-group-item  list-group-item-secondary d-flex justify-content-between">
			<span>{{ t._('subtotal') }}</span>
			<strong><?php echo formatMoney($event['value_total']) ?></strong>
		</li>
	</ul>
<?php
	endforeach;
?>
<ul class="list-group mb-3">
	<li class="list-group-item d-flex justify-content-between">
		<span>{{ t._('products') }}</span>
		<strong><?php echo formatMoney($cart['value_product']) ?></strong>
	</li>

	<?php if ($cart['value_delivery'] > 0 ) : ?>
		<li class="list-group-item d-flex justify-content-between">
			<span>{{ t._('delivery') }}</span>
			<strong><?php echo formatMoney($cart['value_delivery']) ?></strong>
		</li>
	<?php endif ; ?>

	<?php if ($cart['value_fee'] > 0  OR $cart['value_fee_org'] > 0) : ?>
		<li class="list-group-item d-flex justify-content-between">
			<span>{{ t._('fee') }}</span>
			<strong><?php echo formatMoney($cart['value_fee'] + $cart['value_fee_org']) ?></strong>
		</li>
	<?php endif ; ?>

	<?php if ($cart['value_product_tax'] > 0  OR $cart['value_fee_tax'] > 0 OR $cart['value_fee_org_tax'] > 0) : ?>
		<li class="list-group-item d-flex justify-content-between">
			<span>{{ t._('tax') }}</span>
			<strong><?php echo formatMoney($cart['value_product_tax'] + $cart['value_fee_tax'] + $cart['value_fee_org_tax']) ?></strong>
		</li>
	<?php endif ; ?>

	<li class="list-group-item  list-group-item-success d-flex justify-content-between">
		<h5>{{ t._('total') }}</h5>
		<strong><?php echo formatMoney($cart['value_total']) ?></strong>
	</li>

<?php /*
	<li class="list-group-item d-flex justify-content-between bg-light">
		<div class="text-success">
			<h6 class="my-0">{{ t._('promo_code') }}</h6>
			<small>#VaiBombar-Toma10%</small>
		</div>
		<span class="text-success">-<?php $promo = ($cart['value_total'] * 0.10 );  echo formatMoney( $promo ); ?></span>
	</li>

	<li class="list-group-item d-flex justify-content-between">
		<span>{{ t._('total') }}</span>
		<strong><?php echo formatMoney($cart['value_total'] - $promo) ?></strong>
	</li>
*/ ?>

</ul>


<?php /*
<form class="card p-2">
	<div class="input-group">
		<input type="text" class="form-control" placeholder="{{ t._('promo_code') }}">
		<div class="input-group-append">
			<button type="submit" class="btn btn-secondary">{{ t._('apply') }}</button>
		</div>
	</div>
</form>
*/ ?>


<script type="text/javascript">
	if ( typeof $ !== "undefined" ) {
		$(function () {
			$('[data-toggle="tooltip"]').tooltip()
		})
	}
</script>
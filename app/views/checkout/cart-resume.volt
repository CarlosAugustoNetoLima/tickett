<div class="well">
	<?php if ( $cart AND isset($cart['event']) AND count($cart['event']) > 0 ) : ?>

		<?php foreach ( $cart['event'] AS $id_event => $event ) : ?>
			<table class='table table-cart-resume'>
				<thead>
					<tr>
						<th class="fs-subtitle">
							<b>
								<?php echo $event['event_name'] ?>
							</b>
						</th>
						<th class="text-right">
							<!--
							<i class="glyphicon glyphicon-remove"   data-placement="bottom" data-toggle="tooltip" title="{{ t._('remove_event_from_cart') }}"></i>
						-->
						</th>
					</tr>
				</thead>
				<tbody>
					<?php
					foreach ( $event['products'] AS $id_product => $product ) :
						foreach ( $product AS $id_type => $type ) :
							?>

							<tr>
								<td>{{ type['qty'] }}x {{ type['name'] }}</td>
								<td class="text-right"><?php echo formatMoney( ( $type['qty'] * $type['price'] ) ) ?></td>
							</tr>

							<?php
						endforeach;
					endforeach;
					?>
				</tbody>
			</table>
		<?php endforeach; ?>



		<table class='table table-condensed table-cart-resume'>
			<tbody>

				<?php if ($cart['value_delivery'] > 0 ) : ?>
					<tr>
						<td>{{ t._('delivery') }}</td>
						<td class="text-right"><?php echo formatMoney($cart['value_delivery']) ?></td>
					</tr>
				<?php endif ; ?>

				<?php if ($cart['value_fee'] > 0  OR $cart['value_fee_org'] > 0) : ?>
					<tr>
						<td>{{ t._('fee') }}</td>
						<td class="text-right"><?php echo formatMoney($cart['value_fee'] + $cart['value_fee_org']) ?></td>
					</tr>
				<?php endif ; ?>

				<?php if ($cart['value_product_tax'] > 0  OR $cart['value_fee_tax'] > 0 OR $cart['value_fee_org_tax'] > 0) : ?>
					<tr>
						<td>{{ t._('tax') }}</td>
						<td class="text-right"><?php echo formatMoney($cart['value_product_tax'] + $cart['value_fee_tax'] + $cart['value_fee_org_tax']) ?></td>
					</tr>
				<?php endif ; ?>

				<tr>
					<td class="fs-subtitle"><b>{{ t._('total') }}</b></td>
					<td class="text-right fs-subtitle"><b><?php echo formatMoney($cart['value_total']) ?></b></td>
				</tr>

			</tbody>
		</table>
	<?php else : // if ( $cart AND isset($cart['event']) AND $cart['value_total'] > 0 ) : ?>

		<h2 class="fs-title">{{ t._('Choose your products') }}</h2>

	<?php endif ; ?>
</div>

<?php if ( $cart['value_total'] > 0 ) : ?>
<script type="text/javascript">
	if ( typeof $ !== 'undefined' ) {
		var value_total =   <?php echo $cart['value_total'] ?>;
		$('.span-cart-resume').html( '$' + value_total.toFixed(2) + ' ' );
		$('[data-toggle="tooltip"]').tooltip();
	}
</script>
<?php endif ; ?>



<?php

// echo '<pre>';
// print_r($cart);
// echo '</pre>';
?>
<?php $show_cash = false; ?>


<?php if (  $cart['value_total'] == 0 ) : ?>
	<h2 class="fs-title">{{ t._('Payment') }}</h2>

	<button type="button" class="btn btn-success" style="margin: 5px;"   data-toggle="tooltip"  title="{{ t._('Courtesy') }}"  onclick="payment();">
		<i class="glyphicon glyphicon-gift" style="top: 2px;"></i>
		{{ t._('Courtesy') }}
	</button>

	<form id="form-payment-7"  class="form-horizontal ">
		<input type="hidden" name="paymentMethod" value="7" />
		<h3 class="fs-subtitle">{{ t._('Confirm payment with Courtesy') }}</h3>
	</form>


<?php else : ?>


	<?php if ( count($payments_type) == 0 OR empty($payments_type) OR !$payments_type ) : ?>


			<h2 class="fs-title">{{ t._('Error') }}</h2>
			<h3 class="fs-subtitle">{{ t._('Payment Method is not set for this event') }}</h3>

	<?php elseif ( count($payments_type) > 1 ) : ?>

		<div id="payment-choose">

			<h2 class="fs-title">{{ t._('Payment') }}</h2>
			<h3 class="fs-subtitle">{{ t._('Choose payment method') }}</h3>

			<?php
				foreach ($payments_type as $payment ) :
					if ( $payment->id_payment_type == 1 )  $show_cash = true;
					if ( $payment->id_payment_type == 7)  continue; // Não exibe cortesia, apenas mostra em cima, se o valor do pedido for ZERO
			?>
				<button type="button" class="btn btn-default btn-payment-type" style="margin: 5px;"  onclick="paymentChoose({{ payment.id_payment_type }});"  data-toggle="tooltip"  title="{{ t._(payment.PaymentTypes.name) }}" id="button-payment-choose-{{ payment.id_payment_type }}" >
					<?php if ( $payment->id_payment_type == 2 ) : ?>
						<i class="glyphicon glyphicon-credit-card" style="top: 2px;"></i>
					<?php else : ?>
						<i class="glyphicon glyphicon-usd" style="top: 2px;"></i>
					<?php endif ; ?>
					{{ t._(payment.PaymentTypes.name) }}
				</button>
			<?php endforeach ; ?>

		</div>

	<?php else : ?>

		<script type="text/javascript">
			<?php
				foreach ($payments_type as $payment ) :
					if ( $payment->id_payment_type == 1 )  $show_cash = true;
			?>
		 	paymentChoose({{ payment.id_payment_type }});
		 <?php endforeach ; ?>
	 	</script>
		<h2 class="fs-title">{{ t._('Payment') }}</h2>

	<?php endif ; ?>



<?php endif ; ?>



<?php if ( $show_cash ) : ?>
<form id="form-payment-1"  class="form-horizontal form-payment">
	<input type="hidden" name="paymentMethod" value="1" />

	<h2 class="fs-title">{{ t._('Cash') }}</h2>
	<h3 class="fs-subtitle">{{ t._('Confirm payment with cash') }}</h3>
		<div class="form-group">
			<label for="total_value_hidden" class="col-sm-2 control-label">{{ t._('Total') }}</label>
			<div class="col-sm-10 text-left">
				<p class="form-control-static"> &nbsp; &nbsp;<?php echo $cart['value_total'] ?></p>
				<input type="hidden" id="total_value_hidden"  value="<?php echo $cart['value_total'] ?>" >
			</div>
		</div>

		<div class="form-group">
			<label for="amount_paid" class="col-sm-2 control-label">{{ t._('Amount paid') }}</label>
			<div class="col-sm-10">
				<input type="text" class="form-control" id="amount_paid"  value="<?php echo $cart['value_total'] ?>" placeholder="<?php echo $cart['value_total'] ?>" onkeyup="calculateChange();" onclick="$(this).select();" >
			</div>
		</div>

		<div class="form-group">
			<label for="change_money" class="col-sm-2 control-label">{{ t._('Change of Money') }}</label>
			<div class="col-sm-10">
				<input type="text" class="form-control" id="change_money"  value="0.00" disabled readonly>
			</div>
		</div>
</form>
<?php endif ; ?>




<form id="form-payment-2"  class="form-payment">

	<input type="hidden" name="paymentMethod" value="2" />

	<div id="credit-card-data" >

		<h2 class="fs-title">{{ t._('Credit Card') }}</h2>
		<h3 class="fs-subtitle">{{ t._('Inform the data to make the payment by credit card') }}</h3>





		<div class="row  ">

			<div class="col-md-6 form-group">
				<label for="cc_name">{{ t._('full_name_on_card') }}</label>
				<input type="text" class="form-control" id="cc_name"  name="cc_name" value="<?php echo isset($customer) ? $customer->name : ''  ?>" placeholder="{{ t._('full_name') }}">
			</div>

			<div class="col-md-6 form-group">
				<label for="cc_number">{{ t._('credit_card_number') }} <span class="cc-brand"></span> </label>
				<div class="input-group">
					<input type="tel" class="form-control cc_number text-center" id="cc_number" name="cc_number" autocomplete="cc-number"  placeholder="•••• •••• •••• ••••" >
					<div class="input-group-addon">
						<i class="glyphicon glyphicon-lock" data-toggle="tooltip"  title="This site is SAFE"></i>
					</div>
				</div>
			</div>

		</div>


		<div class="row ">

			<div class="col-xs-4 form-group">
				<label for="cc_expiration">{{ t._('expiration') }}</label>
				<input type="tel" class="form-control cc_expiration text-center" id="cc_expiration" name="cc_expiration" autocomplete="cc-exp" placeholder="•• / ••"  >
			</div>

			<div class="col-xs-4 form-group">
				<label for="cc_cvv">{{ t._('cvv') }}</label>
				<input type="tel" class="form-control cc_cvv text-center" id="cc_cvv"  name="cc_cvv" autocomplete="off" placeholder="•••" >
			</div>

			<div class="col-xs-4 form-group">
				<label for="zipcode">{{ t._('ZIP Code') }}</label>
				<input type="text" class="form-control form-control-small" id="zipcode" name="address[zip]" placeholder="{{ t._('ZIP Code') }}">
				<span id="div-msg-address-complete" class="help-block"></span>
			</div>


			<div class="card-wrapper"></div>
		</div>

	<div  id="text-error-payment-credit-card"></div>


	</div>








	<div id="billing-address" style="display: none;">


		<h2 class="fs-title">{{ t._('Payment - Billing Address') }}</h2>
		<h3 class="fs-subtitle">{{ t._('Inform billing address for the informed credit card') }}</h3>




		<div class="form-group">
			<label for="inputname">{{ t._('Name') }}</label>
			<input type="text" class="form-control form-control-large" id="inputname" name="address[full_name]" placeholder="{{ t._('Name') }}">
		</div>

		<div class="row">
			<div class="col-xs-7">
				<div class="form-group">
					<label for="inputAddress1">{{ t._('Street address 1') }}</label>
					<input type="text" class="form-control form-control-large" id="inputAddress1" name="address[address_1]" placeholder="{{ t._('Enter address') }}">
				</div>
			</div>
			<div class="col-xs-5">
				<div class="form-group">
					<label for="inputAddress2">{{ t._('Street address 2') }}</label>
					<input type="text" class="form-control form-control-large" id="inputAddress2" name="address[address_2]" placeholder="{{ t._('Enter address') }}">
				</div>
			</div>
		</div>

		<div class="row">


			<div class="col-xs-6">
				<div class="form-group">
					<label for="zipcode">{{ t._('ZIP Code') }}</label>
					<div class="input-group">
						<input type="text" class="form-control form-control-small" id="zipcode" name="address[zipcode]" placeholder="{{ t._('ZIP') }}">
					 	<div class="input-group-addon btn btn-info" id="button-complete-address" onclick="completeAddress();" >
					 		{{ t._('Complete') }}
						 </div>
					</div>
					<span id="div-msg-address-complete" class="help-block"></span>
				</div>
			</div>

			<div class="col-xs-6">
				<div class="form-group">
					<label for="city">{{ t._('City') }}</label>
					<input type="text" class="form-control" id="city" name="address[city]" placeholder="{{ t._('City') }}">
				</div>
			</div>

		</div>

		<div class="row">

			<div class="col-xs-6">
				<div class="form-group">
					<label for="region">{{ t._('State') }}</label>
					<input type="text" class="form-control form-control-small" id="region" name="address[region]" placeholder="{{ t._('State') }}">
				</div>
			</div>

			<div class="col-xs-6">
				<div class="form-group">
					<label for="country">{{ t._('Country') }}</label>
					<input type="text" class="form-control" id="country" name="address[country]" placeholder="{{ t._('Country') }}">
				</div>
			</div>

		</div>

	<div  id="text-error-payment-billing-address"></div>

	</div>


</form>




<div  id="text-error-payment"></div>

<?php

// echo '<pre>';
// print_r($payments_type->toArray());
// echo '</pre>';



<?php

// echo 'cart[even]<pre>';
// print_r($cart['event']);
// echo '</pre>';
?>

<div class="container pt-5">
	<div class="row">
		<div class="col-12">
			{{ content() }}
		</div>

		<div class="col-md-4 order-md-2 mb-4" id="cart-resume">
			<h4 class="d-flex justify-content-between align-items-center mb-3">
				<span class="text-muted" data-toggle="tooltip" title="Disabled tooltip">{{ t._('your_cart') }}</span>
			</h4>

			<?php $this->partial("cart/cart-resume", array('cart' => $cart) ); // tras o resumo do cart de um PARTIAL, passa o $cart como parametro para o PARTIAL utilizar  ?>
		</div>



		<div class="col-md-8 order-md-1">
			<div class="stepsPage">
				<form class=""  method="POST" action="{{ url() }}cart/checkout">

					<div class="page-header">
						<h4>{{ t._('login') }}</h4>
					</div>

					<?php if ( $customer ) : ?>
						<div class="row mb-3">
							<div class="col-md-12">
								<h3>{{ customer.name }} - {{ customer.email }}</h3>
								<p><br></p>
							</div>
						</div>





						<div class="page-header pt-3">
							<h4>{{ t._('delivery') }}</h4>
						</div>
						<div class="row mb-3">
							<div class="col-md-12">
							<?php foreach ( $cart['event'] AS $id_event => $event ) : ?>

								<div class="form-group quick-drop selectOptions">
									<label for="delivery_<?php echo $event['event'] ?>"><?php echo $event['event_name'] ?></label>
									<select class="form-control  select-delivery" data-event='<?php echo $event['event'] ?>' id="delivery_<?php echo $event['event'] ?>" name="deliveryMethod[<?php echo $event['event'] ?>]"  required="required">

										<?php
											foreach ( $event['event_delivery'] AS $delivery ) :
												$delivery_value = 0;
												if ( $delivery['value'] > 0 )
													$delivery_value += $delivery['value'];
												if ( $delivery['value_tax'] > 0 )
													$delivery_value += $delivery['value_tax'];
										?>
											<option value="{{ delivery['id'] }}" <?php echo ( isset($event['event_delivery_set']['id']) AND $event['event_delivery_set']['id'] == $delivery['id'] ) ? ' selected ' : '' ?>>
												{{ delivery['name'] }}
												<?php echo ($delivery_value > 0 ? formatMoney($delivery_value) : '' )  ?> &nbsp;
												<?php if ( $delivery['resume'] )  : ?>  - &nbsp; {{ delivery['resume'] }} <?php endif ; ?>
											</option>
										<?php endforeach; ?>
									</select>
								</div>

							<?php endforeach; ?>
							</div>
						</div>




						<?php if ( isset($delivery_set) AND $delivery_set ) : ?>

							<div class="page-header pt-3">
								<h4>{{ t._('payment') }}</h4>
							</div>
							<div class="row mb-3 checkboxArea" style="    float: inherit;">
								<div class="col-12 col-lg-6 mb-4">
									<input id="payment_2" class="select-payment" name="paymentMethod" type="radio" value="2" checked="checked"  required="required">
									<label for="payment_2">
										<span></span>Cartão de Crédito
									</label>
								</div>
							</div>




							<div class="page-header">
								<h5>{{ t._('credit_card') }}</h5>
							</div>
							<div id="credit-card-div" >


								<div class="row">
									<div class="col-md-6 mb-3">
										<label for="cc_name">{{ t._('name_on_card') }}</label>
										<input type="text" class="form-control" id="cc_name"  name="cc_name" required="required">
										<small class="form-text text-muted" style="margin-top: -25px;">{{ t._('full_name_on_card') }}</small>
									</div>
									<div class="col-md-6 mb-3">
										<label for="cc_number">{{ t._('credit_card_number') }}</label>
										<input type="text" class="form-control" id="cc_number" name="cc_number"  required="required">
									</div>
								</div>
								<div class="row">
									<div class="col-md-3 mb-3">
										<label for="cc_expiration">{{ t._('expiration') }}</label>
										<input type="text" class="form-control" id="cc_expiration" name="cc_expiration"  required="required">
									</div>
									<div class="col-md-3 mb-3">
										<label for="cc_cvv">{{ t._('cvv') }}</label>
										<input type="text" class="form-control" id="cc_cvv"  name="cc_cvv"  required="required">
									</div>
									<div class="card-wrapper"></div>
								</div>
							</div>



							<div class="page-header">
								<h5>{{ t._('billing_address') }}</h5>
							</div>
							<div id=" " >
								<div class="row">
									<div class="col-md-6 mb-3">
										<label for="full_name">{{ t._('full_name') }}</label>
										<input type="text" class="form-control" id="full_name" value="{{ customer.name }}" name="address[full_name]" required="required">
										<small class="form-text text-muted" style="margin-top: -25px;">{{ t._('full_name') }}</small>
									</div>
									<div class="col-md-6 mb-6">
										<label for="phone">{{ t._('phone') }}</label>
										<input type="text" class="form-control" id="phone" value="{{ customer.cell_number }}" name="address[phone]"  required="required">
									</div>
								</div>
								<div class="row">
									<div class="col-md-6 mb-3">
										<label for="address_1">{{ t._('address_1') }}</label>
										<input type="text" class="form-control" id="address_1" value="{{ customer.address_1 }}" name="address[address_1]"  required="required">
									</div>
									<div class="col-md-6 mb-6">
										<label for="address_2">{{ t._('address_2') }}</label>
										<input type="text" class="form-control" id="address_2" value="{{ customer.address_2 }}" name="address[address_2]" >
									</div>
								</div>
								<div class="row">
									<div class="col-md-3 mb-3">
										<label for="city">{{ t._('city') }}</label>
										<input type="text" class="form-control" id="city" value="{{ customer.city }}" name="address[city]"  required="required">
									</div>
									<div class="col-md-3 mb-3">
										<label for="region">{{ t._('region') }}</label>
										<input type="text" class="form-control" id="region" value="{{ customer.region }}"  name="address[region]"  required="required">
									</div>

									<div class="col-md-3 mb-3">
										<label for="zip_code">{{ t._('zip') }}</label>
										<input type="text" class="form-control" id="zip_code" value="{{ customer.zipcode }}" name="address[zip]"  required="required">
									</div>
									<div class="col-md-3 mb-3">
										<label for="country">{{ t._('country') }}</label>
										<input type="text" class="form-control" id="country" value="{{ customer.country }}"  name="address[country]"  required="required">
									</div>
								</div>
							</div>

						<?php endif ;  /* <?php if ( $delivery_set ) : ?> */ ?>



					<?php else : /* <?php if ( $customer ) : */ ?>
						<div class="row mb-3">
							<div class="col-md-12 buttons-login">
								<a class="btn btn-primary btn-default" data-toggle="modal" href='.login-modal'>
									Log in
								</a>
							 &nbsp;  &nbsp; {{ t._('or') }} &nbsp;  &nbsp;
								<a class="btn btn-primary btn-default" data-toggle="modal" href='#signup'>
									Create an account
								</a>
							</div>
						</div>
					<?php endif; ?>







					<hr class="mb-4">
					<?php if ( $customer ) : ?>
						<button class="btn btn-info btn-lg btn-block" type="submit">{{ t._('continue_to_checkout') }}</button>
					<?php else : ?>
						<button class="btn btn-warning btn-lg btn-block" type="button">{{ t._('login_to_continue') }}</button>
					<?php endif; ?>

				</form>
			</div> <!-- <div class="stepsPage"> -->

		</div>
	</div>
</div>



<?php
	$this->assets->addCss('plugins/credit-card-mask/credit-card.css');

	$this->assets->addJs('plugins/credit-card-mask/jquery.credit-card.js');
	$this->assets->addInlineJs("
		$('#credit-card-div').card({
		container: '.card-wrapper',
		formSelectors: {
			numberInput: 'input[name=\"cc_number\"]',
			expiryInput: 'input[name=\"cc_expiration\"]',
			cvcInput: 'input[name=\"cc_cvv\"]',
			nameInput: 'input[name=\"cc_name\"]'
		},
	});
	");
?>
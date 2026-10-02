<div class="container-fluid">
	<div class="row">

		<div class="col-12">
			{{ content() }}

			<h1>
				{{ t._('checkout') }}
			</h1>



			<?php if ( isset($email) AND filter_var($email, FILTER_VALIDATE_EMAIL) ) : ?>


			<form class=""  method="POST" action="{{ di['urlSales'] }}checkout">

				<div class="page-header ">
					<h4>{{ t._('delivery') }}</h4>
				</div>
				<div class="row mb-3">
					<div class="col-md-12">


						<div class="mb-2 ">
							<label for="email">{{ t._('email') }}
							<small class=" text-muted" >&nbsp; {{ t._('send_to_email') }}</small>
							</label>
							<input type="email" class="form-control" id="email"  name="email" required="required" value="<?php echo isset($email) ? $email : '' ?>">
						</div>

						<div class="mb-2 ">
							<label for="name">{{ t._('name') }}</label>
							<input type="text" class="form-control" id="name"  name="name" required="required" value="<?php echo isset($name) ? $name : '' ?>">
						</div>

						<div class="mb-2 ">
							<label for="id">{{ t._('id') }}
							<small class=" text-muted" >&nbsp; {{ t._('identification_required_to_view_tickets') }}</small>
							</label>
							<input type="text" class="form-control" id="id"  name="id" required="required" value="<?php echo isset($id) ? $id : '' ?>">
						</div>


						<div class="  mb-3">
							<label for="zip">{{ t._('zip') }}</label>
							<input type="text" class="form-control" id="zip"  name="zip" required="required" value="<?php echo isset($zipcode) ? $zipcode : '' ?>">
						</div>

						<?php foreach ( $cart['event'] AS $id_event => $event ) : ?>
							<input type="hidden" name="deliveryMethod[<?php echo $event['event'] ?>]" value="6">
						<?php endforeach; ?>

					</div>
				</div>


				<div class="page-header pt-3">
					<h4>{{ t._('payment') }}</h4>
				</div>



				<div class="row mb-1 checkboxArea" style=" float: inherit;">
					<?php if ( $cart['value_total'] > 0 ) : ?>


					<div class="col-md-12 " id="div-payment-type">
						<div class="btn-group btn-group-toggle" data-toggle="buttons" style="width: 100%;">
							<?php foreach ($payments_type as $key => $payment) : ?>

								<label class="btn btn-light" style="width: 100%;">
									<input class="select-payment" type="radio" name="paymentMethod" id="payment_{{ payment.PaymentTypes.id }}" autocomplete="off" value="{{ payment.PaymentTypes.id }}"  required="required"> {{ t._(payment.PaymentTypes.name) }}
								</label>

							<?php /*
								<div class="col-6 col-lg-6 mb-2">
									<label for="payment_{{ payment.PaymentTypes.id }}">
										<input id="payment_{{ payment.PaymentTypes.id }}" class="select-payment" name="paymentMethod" type="radio" value="{{ payment.PaymentTypes.id }}"  required="required">
										ss{{ payment.PaymentTypes.name }}
									</label>
								</div>
							*/ ?>
							<?php endforeach ; ?>
						</div>
					</div>




						<div id="div-payment-credit-card" class=" col-md-12 mt-3" style="display: none;">


							<?php if ( isset($billing_address) AND count($billing_address) > 0 ) : ?>
								<div class="page-header mt-2">
									<h5>{{ t._('billing_addresses_in_this_email') }}</h5>
								</div>
								<div id=" " >


										 <div class="accordion" id="accordion">

										 	<div class="card">

										<?php
											$array_address = array();
											foreach ( $billing_address AS $value ) :

												$array_address[$value->id] = array(
													'name' => $value->name ,
													'address_1' => $value->address_1 ,
													'address_2' => $value->address_2 ,
													'city' => $value->city ,
													'region' => $value->region ,
													'zipcode' => $value->zipcode ,
													'country' => $value->country ,
													'phone' => $value->phone ,
													'cc_name' => $value->cc_name ,
													'cc_number' => substr(trim($value->cc_number), 0, 6) . '...' ,
													'cc_expiration' => $value->cc_expiration
												);
										 ?>



										 		<div class="card-header" id="headingOne">
										 			<h5 class="mb-0" onclick="setAddress({{ value.id }})">
										 				<button class="btn btn-link" type="button" data-toggle="collapse" data-target="#collapse_{{ value.id }}" aria-expanded="true" aria-controls="collapse_{{ value.id }}">
										 					{{ value.cc_name }} : <?php echo substr(trim($value->cc_number), 0, 6) ?>...
										 				</button>
										 			</h5>
										 		</div>

										 		<div id="collapse_{{ value.id }}" class="collapse" aria-labelledby="heading_{{ value.id }}" data-parent="#accordion">
										 			<div class="card-body">

														<input class="select-billing-address" type="radio" name="billing_address" id="radio_billing_address_{{ value.id }}" autocomplete="off" value="{{ value.id }}"  style="    position: absolute; clip: rect(0,0,0,0); pointer-events: none; " >

														<address>
															<strong>{{ value.name }}</strong><br>
															{{ value.address_1 }}
															<?php if ( $value->address_2 ) :?>
																&nbsp; {{ value.address_2 }}
															<?php endif ; ?>
															<br>
															{{ value.city }}, {{ value.region }} - {{ value.zipcode }}<br>
															<abbr title="Phone"><i class="fa fa-phone" aria-hidden="true"></i></abbr> {{ value.phone }}

															<br /><br />
															<small>{{ t._('name_on_card') }}: </small>
															{{ value.cc_name }} <br>

															<small>{{ t._('expiration') }}: </small>
															{{ value.cc_expiration }} <br>

															<label>
																<small>{{ t._('credit_card_number') }}: </small><br>
																<input type="tel" name="set_cc_number[{{ value.id }}]" class="cc_number"  placeholder="•••• •••• •••• ••••" value="<?php echo substr(trim($value->cc_number), 0, 6) ?>..."> <br>
															</label>

															<br>

															<label>
																<small>{{ t._('cvv') }}: </small>
																<input type="tel" name="set_cc_cvv[{{ value.id }}]" class="cc_cvv"  placeholder="•••"  maxlength="5" size="5">
															</label>

														</address>


										 			</div>
										 		</div>






										<?php
											endforeach ;
											echo '
											<script type="text/javascript">
												var billing_address = ' . json_encode($array_address) . ';
											</script>
											';
										?>


										 		<div class="card-header" id="headingOne">
										 			<h5 class="mb-0" onclick="newCreditCart()">
										 				<button class="btn btn-link" type="button" data-toggle="collapse" data-target="#collapse_new_credit_card" aria-expanded="true" aria-controls="collapse_new_credit_card">
										 					{{ t._('new_credit_card') }}
										 				</button>
										 			</h5>
										 		</div>

										 		<div id="collapse_new_credit_card" class="collapse" aria-labelledby="heading_new_credit_card" data-parent="#accordion">
										 			<div class="card-body">

														<div id="new-billing-address">
															<div class="page-header mt-4">
																<h5>{{ t._('credit_card') }}</h5>
															</div>
															<div id="" >

																<div class="row">
																	<div class="col-md-6 mb-3">
																		<label for="cc_name">{{ t._('name_on_card') }}</label>
																		<input type="text" class="form-control" id="cc_name"  name="cc_name" value="<?php echo isset($cc_name) ? $cc_name : '' ?>">
																		<small class="form-text text-muted" >{{ t._('full_name_on_card') }}</small>
																	</div>
																	<div class="col-md-6 mb-3">
																		<label for="cc_number">{{ t._('credit_card_number') }} <span class="cc-brand"></span> </label>
																		<input type="tel" class="form-control cc_number" id="cc_number" name="cc_number" autocomplete="cc-number"  placeholder="•••• •••• •••• ••••" value="<?php echo isset($cc_number) ? $cc_number : '' ?>">
																	</div>
																</div>
																<div class="row">
																	<div class="col-md-6 mb-3">
																		<label for="cc_expiration">{{ t._('expiration') }}</label>
																		<input type="tel" class="form-control cc_expiration" id="cc_expiration" name="cc_expiration" autocomplete="cc-exp" placeholder="•• / ••"  value="<?php echo isset($cc_expiration) ? $cc_expiration : '' ?>">
																	</div>
																	<div class="col-md-6 mb-3">
																		<label for="cc_cvv">{{ t._('cvv') }}</label>
																		<input type="tel" class="form-control cc_cvv" id="cc_cvv"  name="cc_cvv" autocomplete="off" placeholder="•••"  value="<?php echo isset($cc_cvv) ? $cc_cvv : '' ?>">
																	</div>
																	<div class="card-wrapper"></div>
																</div>
															</div>




															<div class="page-header mt-2">
																<h5>{{ t._('billing_address') }}</h5>
															</div>
															<div id=" " >
																<div class="row">
																	<div class="col-md-6 mb-3">
																		<label for="full_name">{{ t._('full_name') }}</label>
																		<input type="text" class="form-control" id="full_name"  name="address[full_name]" value="<?php echo isset($full_name) ? $full_name : '' ?>" >
																	</div>
																	<div class="col-md-6 mb-3">
																		<label for="phone">{{ t._('phone') }}</label>
																		<input type="tel" class="form-control" id="phone"  name="address[phone]"  value="<?php echo isset($phone) ? $phone : '' ?>" >
																	</div>
																</div>
																<div class="row">
																	<div class="col-md-6 mb-3">
																		<label for="address_1">{{ t._('address_1') }}</label>
																		<input type="text" class="form-control" id="address_1" name="address[address_1]"  value="<?php echo isset($address_1) ? $address_1 : '' ?>" >
																	</div>
																	<div class="col-md-6 mb-3">
																		<label for="address_2">{{ t._('address_2') }}</label>
																		<input type="text" class="form-control" id="address_2" name="address[address_2]"  value="<?php echo isset($address_2) ? $address_2 : '' ?>" >
																	</div>
																</div>
																<div class="row">
																	<div class="col-md-3 mb-3">
																		<label for="city">{{ t._('city') }}</label>
																		<input type="text" class="form-control" id="city" name="address[city]"  value="<?php echo isset($city) ? $city : '' ?>" >
																	</div>
																	<div class="col-md-3 mb-3">
																		<label for="region">{{ t._('region') }}</label>
																		<input type="text" class="form-control" id="region"  name="address[region]"  value="<?php echo isset($region) ? $region : '' ?>" >
																	</div>

																	<div class="col-md-3 mb-3">
																		<label for="zipcode">{{ t._('zip') }}</label>
																		<input type="tel" class="form-control" id="zipcode" name="address[zip]"  value="<?php echo isset($zip) ? $zip : '' ?>" >
																	</div>
																	<div class="col-md-3 mb-3">
																		<label for="country">{{ t._('country') }}</label>
																		<input type="text" class="form-control" id="country"  name="address[country]"  value="<?php echo isset($country) ? $country : '' ?>" >
																	</div>
																</div>
															</div>

														</div> <!-- <div id="new-billing-address" style="display: none;">  -->



										 			</div>
										 		</div>







										 	</div>

										 </div>
								</div>
							<?php else : ?>
								<script type="text/javascript">var show_new_billing_address = 'show';</script>
							<?php endif ; ?>



						</div> <!-- <div id="div-payment-credit-card"> -->




						<?php else : /* <?php if ( $cart['value_total'] > 0 )  */ ?>

							<div class="col-6 col-lg-6 mb-2">
								<label for="payment_7">
								<input id="payment_7" class="select-payment" name="paymentMethod" type="radio" value="7"  required="required" checked>
									<span></span>{{ t._('courtesy') }}
								</label>
							</div>

						<?php endif ; ?>

					</div>




					<hr class="mb-4">
					<button class="btn btn-primary btn-lg btn-block" type="submit">
						{{ t._('continue_to_checkout') }}
						<strong>  &nbsp;
							<i class="fa fa-shopping-cart" aria-hidden="true"></i> &nbsp;
							<?php echo formatMoney($cart['value_total']) ?>
						</strong>
					</button>


				</form>



			<?php else : /* if ( $email ) : */ ?>

				<form class=""  method="POST" action="{{ di['urlSales'] }}cart">

					<div class="form-group">
						<label for="email">{{ t._('email_address') }}</label>
						<input type="email" class="form-control" id="email" name="email" aria-describedby="email" placeholder="{{ t._('enter_email') }}">
						<small id="email" class="form-text text-muted">We'll never share your email with anyone else.</small>
					</div>

					<hr class="mb-4">
					<button class="btn btn-primary btn-lg btn-block" type="submit">
						{{ t._('continue_to_checkout') }}
						<strong>  &nbsp;
							<i class="fa fa-shopping-cart" aria-hidden="true"></i> &nbsp;
							<?php echo formatMoney($cart['value_total']) ?>
						</strong>
					</button>
				</form>

			<?php endif ; /* else -  if ( $email ) : */ ?>

			</div>
		</div>

	</div>








	<?php
		$this->assets->addJs('js/jquery.payment.js');
	?>
<section class="page-title">
	<div class="container">
		<h1 class="title">{{ t._('Order Details') }}</h1>
	</div>
</section>

<br>




<section class="page-order-details">
	<div class="container">



		<div class="page-order-details-inner internal-page">
			<div class="internal-page-title">
				<h2 class="title">{{ t._('Activate') }} #{{ order.id }}</h2>
			</div>


			<div class="page-content">


				{{ content() }}
				{{ flashSession.output() }}



				<?php
					$payment = $order->OrdersPayment;
					if ( isset( $payment[0] ) AND  $payment[0] AND $order->id_orders_status == 10  AND $order->id_payment_type == 2 )  :// Pago e em análise
						$payment = $payment[0];
				?>


				<h4 >
					<!-- {{ t._('Just to activate your purchase and receive your tickets') }} -->
					Falta pouco para ativar sua compra e receber seus ingressos
				</h4>
				<br>
				<br>

				<?php if ( $orderActive AND $orderActive->id_order == $order->id AND $orderActive->finished_in == NULL ) :  /* Isso para validar se realmente é o active dessa order */ ?>


					<div class="jumbotron">

						<p class="lead">
							Em <?php echo $this->getDI()->getFormatdates()->format($orderActive->created_at, '25/01/2000 17:00h') ?> lançamos um pequeno valor em seu cartão <?php echo maskCreditCard($payment->cc_number) ?>
						</p>


						<p class="lead">
							<b>Informe qual foi o valor:</b>
						</p>

						<form class="form-inline" method="POST"  onsubmit="$('.button-submit').attr('disabled','disabled');">
							<input type="hidden" name="post_value" value="on">
							<div class="form-group mx-sm-3 mb-2">
								<label for="value_active" class="sr-only">{{ t._('Value') }}</label>
								<input type="tel" class="form-control" style="background-color: #ffffff;" id="value_active" name="value_active" placeholder="{{ t._('Value') }}">
							</div>
							<button type="submit" class="btn btn-primary mb-2 button-submit">{{ t._('Validate') }}</button>
						</form>

					</div>

				<?php else : ?>
					<div class="jumbotron">

						<p class="lead">
							Vamos lançar um pequeno valor em seu cartão, na próxima etapa você deve informar qual valor foi esse.
						</p>


						<p class="lead">
							Informe o código de segurança do seu cartão: <?php echo maskCreditCard($payment->cc_number) ?>
						</p>

						<form class="form-inline" method="POST"  onsubmit="$('.button-submit').attr('disabled','disabled');">
							<input type="hidden" name="post_cvv" value="on">
							<div class="form-group mx-sm-3 mb-2">
								<label for="cc_cvv" class="sr-only">{{ t._('cvv') }}</label>
								<input type="tel" class="form-control" style="background-color: #ffffff;" id="cc_cvv" name="cc_cvv" placeholder="{{ t._('cvv') }}">
							</div>
							<button type="submit" class="btn btn-primary mb-2 button-submit">{{ t._('Continue') }}</button>
						</form>

					</div>
				<?php
				$show_cvv_help = true;
			endif ; ?>


				<br>
				<br>

				<p>
					Tenha em mãos o aplicativo do seu cartão para poder conferir qual o valor realizado no teste acima
				</p>

				<p>
					<i>* Após esse processo, o valor será imediatamente estornado</i>
				</p>

				<?php if ( isset($show_cvv_help) ) : ?>
					<p>
						<a class="btn btn-light  btn-sm" data-toggle="collapse" href="#collapseCvv" role="button" aria-expanded="false" aria-controls="collapseCvv">
							Onde localizar o código de segurança? (cvv)
						</a>
					</p>
					<div class="collapse" id="collapseCvv">
						<div class="card card-body">
							<img class="img-fluid" src="https://images.tcdn.com.br/static_inst/meiosdepagamento/wp-content/uploads/2018/02/onde-fica-o-cvv.png">
						</div>
					</div>
				<?php endif ; ?>





				<?php else : ?>

					<div class="alert alert-info" role="alert">
						<p>
							<b>
								{{ t._('This purchase does not need to be activated') }}
							</b>
						</p>
						<p>
							<a href="{{ url() }}account/order/{{ order.id }}">{{ t._('Click here to view the purchase') }}</a>
						</p>
					</div>

				<?php endif ; ?>

				<p><br></p>
				<hr>
				<p><br></p>


			<?php
			$now = date('Y-m-d H:i:s');
			$mais_que_um = 0;
			foreach ( $order->OrderSale AS $sales) :
				$mais_que_um++;
				$sale = $sales->Sales;
				$event = $sale->Events;


				if ( $mais_que_um > 1) : ?>
				<div class="divider divider-center divider-gradient divider-gradient-gray w50 mx-auto my-5">
					<i class="fa fa-circle divider-icon bg-white " style="font-size: 10px"></i>
				</div>
				<?php endif ; ?>

				<div class="ticket-info">
					<div class="side-type">
						<h4 class="text">{{ t._('EVENT') }}</h4>
					</div>
					<div class="side-info">
						<div class="title">{{ event.name }}</div>
						<ul class="info-list">
							<li class="info-item"><span class="info-type">{{ t._('DATE') }}:</span> <?php echo $this->getDI()->getFormatdates()->format($event->date_start, '25/Jan/2000');?></li>
							<li class="info-item"><span class="info-type">{{ t._('CITY') }}:</span> {{ event.Cities.name}}/{{ event.Regions.acronym }}</li>
							<li class="info-item"><span class="info-type">{{ t._('LOCAL') }}:</span> {{ event.Places.name }}</li>
							<li class="info-item"><span class="info-type">{{ t._('OPENS') }}:</span> <?php echo $this->getDI()->getFormatdates()->format($event->date_opening, '17:00h');?></li>
							<li class="info-item"><span class="info-type">{{ t._('START') }}:</span> <?php echo $this->getDI()->getFormatdates()->format($event->date_start, '17:00h');?></li>
						</ul>
					</div>
				</div>
				<div class="ticket-table">
					<table class="table table-event-data">
						<thead>
							<tr>
								<th scope="col">
								</th>
								<th scope="col">{{ t._('PRODUCTS') }}</th>
								<th scope="col">{{ t._('VALUE') }}</th>
								<th scope="col">{{ t._('FEE') }}</th>
								<th scope="col">{{ t._('TAXES') }}</th>
							</tr>
						</thead>
						<tbody>
							<?php
							$products = $sale->SalesItems;
							$tt_value_product = $tt_value_fees = $tt_value_taxes = $tt_value = 0;
							$all_actives = true;
							foreach ( $products AS $product ) :
								$value_product = $product->value_product;
								$value_fees = $product->value_fee + $product->value_fee_org ;
								$value_taxes = $product->value_product_tax + $product->value_fee_tax + $product->value_fee_org_tax ;
								$value_subtotal = $value_product + $value_fees + $value_taxes;

								// Considerar a fração do produto
								$value_product = $value_product / $product->fraction;
								$value_fees = $value_fees / $product->fraction;
								$value_taxes = $value_taxes / $product->fraction;
								$value_subtotal = $value_subtotal / $product->fraction;

								$tt_value += $value_subtotal;

								$tt_value_product += $value_product;
								$tt_value_fees += $value_fees;
								$tt_value_taxes += $value_taxes;

								// Se algum produto estiver cancelado, já não permite o cancelamento da compra
								if ( $product->status != 1 ) {
									$all_actives = false;
								}
								?>
								<tr>
									<?php if ( $order->id_orders_status == 2 AND $product->status == 1   ) : ?>
										<td width="50">
											<a target="_blank" href="{{ url() }}ticket/<?php echo base64_encode($sale->id_event . '#' . $product->ticket) ?>" class="ticket-icon ticket-success">
												<svg class="icon" viewBox="0 0 1792 1792" xmlns="http://www.w3.org/2000/svg">
													<path
														d="M1024 452l316 316-572 572-316-316zm-211 979l618-618q19-19 19-45t-19-45l-362-362q-18-18-45-18t-45 18l-618 618q-19 19-19 45t19 45l362 362q18 18 45 18t45-18zm889-637l-907 908q-37 37-90.5 37t-90.5-37l-126-126q56-56 56-136t-56-136-136-56-136 56l-125-126q-37-37-37-90.5t37-90.5l907-906q37-37 90.5-37t90.5 37l125 125q-56 56-56 136t56 136 136 56 136-56l126 125q37 37 37 90.5t-37 90.5z" />
												</svg>
											</a>
										</td>
									<?php else : ?>
										<td>

										</td>
									<?php endif ; ?>
									<td>
										<?php if ( $order->id_orders_status == 2 AND $product->status == 1 ) : ?>
											<a target="_blank" href="{{ url() }}ticket/<?php echo base64_encode($sale->id_event . '#' . $product->ticket) ?>">
												{{ product.Products.name }}

												<?php if ( $product->fraction > 1 ) : ?>
													({{ product.product_sequence }}/{{ product.fraction }})
												<?php endif ; ?>


												<?php if ( $product->id_product_seat > 1 ) : ?>
													({{ product.ProductsSeats.label }})
												<?php endif ; ?>

												<small>&nbsp;({{ t._('click to view') }})</small>
											</a><br />
										<?php else : ?>
											{{ product.Products.name }}
											<?php if ( $product->id_product_seat > 1 ) : ?>
												({{ product.ProductsSeats.label }})
											<?php endif ; ?>
											  <br />
										<?php endif ; ?>
										<!--<small>{{ product.Products.ProductsGenres.name }} - {{ product.ProductsTypes.name }}</small>-->
										<?php
										$ExtraData = $product->TicketExtraData;
										if ( count($ExtraData) > 0 ) :
										foreach ( $ExtraData as $temp ) : ?>
											<small class="text-muted">{{ temp.ExtraData.name }}: {{ temp.value }}</small><br>
										<?php endforeach ; endif ; ?>
									</td>
									<td><?php echo formatMoney($value_product, true, COMPANY, true) ?></td>
									<td><?php echo formatMoney($value_fees, true, COMPANY, true) ?></td>
									<td><?php echo formatMoney($value_taxes, true, COMPANY, true) ?></td>
								</tr>
							<?php  endforeach; ?>
							<tr>
								<th colspan="2" class="text-right">{{ t._('SUBTOTAL') }}</th>
								<td><?php echo formatMoney($tt_value_product, true, COMPANY, true) ?></td>
								<td><?php echo formatMoney($tt_value_fees, true, COMPANY, true) ?></td>
								<td><?php echo formatMoney($tt_value_taxes, true, COMPANY, true) ?></td>
							</tr>
							<?php if ( $sale->value_delivery > 0 ) : ?>
								<tr>
									<th colspan="4" class="text-right">{{ t._('DELIVERY') }}</th>
									<td ><?php echo formatMoney($sale->value_delivery, true, COMPANY, true) ?></td>
								</tr>
							<?php endif ; ?>
						</tbody>
					</table>
				</div>



			<?php  endforeach ;  ?>








				<div class="information-block">
					<div class="information-block-inner">
						<div class="block-title">
							<h3 class="title">{{ t._('PAYMENT INFORMATION') }}</h3>
						</div>
						<ul class="information-list">
							<li class="information-item"><span class="information-title">{{ t._('Amount') }}:</span><?php echo formatMoney($order->value_total, true, COMPANY, true)  ?></li>
							<li class="information-item"><span class="information-title">{{ t._('Date') }}:</span><?php echo $this->getDI()->getFormatdates()->format($order->created_at, '25/01/2000 17:00h') ?></li>
							<li class="information-item"><span class="information-title">{{ t._('Status') }}:</span>{{ t._(order.OrdersStatus.name) }}</li>
							<li class="information-item"><span class="information-title">{{ t._('Payment Type') }}:</span>{{ t._(order.PaymentTypes.name) }}</li>
							<li class="information-item"><span class="information-title">{{ t._('Payment Status') }}:</span>{{ t._(order.OrdersPaymentStatus.name) }}</li>
							<?php
								$payment = $order->OrdersPayment;
							if ( isset( $payment[0] ) AND  $payment[0] AND $order->id_orders_payment_status == 3  AND $order->id_payment_type == 2 )  :// Payment received
								$payment = $payment[0];
								?>
								<li class="information-item"><span class="information-title">{{ t._('Card Number') }}:</span><?php echo maskCreditCard($payment->cc_number) ?></li>
								<li class="information-item"><span class="information-title">{{ t._('Auth Code') }}:</span>{{ payment.cc_authcode }}</li>
								<li class="information-item"><span class="information-title">{{ t._('Transaction Id') }}:</span>{{ payment.cc_transactionid }}</li>
							<?php endif ; ?>
						</ul>
					</div>
				</div>


			</div>

		</div>
	</div>
</section>




<?php


	function maskCreditCard($cc) {

		$cc_length = strlen($cc);

		for ($i = 7; $i < $cc_length - 4; $i++) {
			if ($cc[$i] == '-' OR $cc[$i] == ' ') {
				continue;
			}
			$cc[$i] = '*';
		}
		return $cc;
	}


?>
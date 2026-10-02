<section class="page-title">
	<div class="container">
		<h1 class="title">{{ t._('Order Details') }}</h1>
	</div>
</section>

{{ partial('account/menu') }}



<?php
$new_order = ( $this->session->get("new_order") == $order->id ) ? true : false;
if ( $new_order ) :
	?>
	<section class=" clearfix setp5 pt-5 pb-1">
		<div class="container-fluid">
			<div class="row">
				<div class="col-md-12">
					<div class="thanksContent">
						<h2>Thank You For Your Order <small>You will receive an email of your order details</small></h2>
					</div>
				</div>
			</div>
		</div>
	</section>
<?php endif ; ?>

<section class="page-order-details">
	<div class="container">


		{{ content() }}
		{{ flashSession.output() }}


		<div class="page-order-details-inner internal-page">
			<div class="internal-page-title">
				<h2 class="title">{{ t._('Order') }} #{{ order.id }}</h2>
			</div>


			<div class="page-content">



			<?php  if ( COMPANY == 'lebillet' AND  $order->id_orders_status == 10  AND  $order->OrderSale[0]->Sales->Events->id == 64   )  : /* Pago e em análise */ ?>
					<div class="alert alert-info" role="alert">
						<p>
							<b>
								{{ t._('Purchase under review') }}
							</b>
						</p>
						<p class="lead">
							<a class="btn btn-primary" href="{{ url() }}active/order/{{ order.id }}">{{ t._('Click here to activate') }}</a>
						</p>
					</div>
			<?php endif ; ?>



			<?php
			$now = date('Y-m-d H:i:s');
			$mais_que_um = 0;
			foreach ( $order->OrderSale AS $sales) :
				$mais_que_um++;
				$sale = $sales->Sales;
				$event = $sale->Events;

				//  os dados de configuração do CANCELAMENTO
				$cancellation = json_decode($event->cancellation, true);
				$cancellation['days_after_purchase'] = isset($cancellation['days_after_purchase']) ? $cancellation['days_after_purchase']: 7 ;
				$cancellation['days_before_event'] = isset($cancellation['days_before_event']) ? $cancellation['days_before_event'] : 2 ;
				$cancellation['type'] = isset($cancellation['type']) ? $cancellation['type'] : 1 ;


				if ( $mais_que_um > 1) : ?>
				<div class="divider text-center divider-center divider-gradient divider-gradient-gray w50 mx-auto my-5">
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
								<?php  if ( $order->OrderSale[0]->Sales->Events->id == 1)  : ?>
									<th scope="col">{{ t._('#') }}</th>
								<?php endif ; ?>

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


								// Se algum ticket foi validado, não permite o cancelamento
								// Alguns evento deu merda e pode cancelar mesmo validado
								// if ( $product->validated != '0' AND !in_array( $product->id_event, array(287) ) ) {
								if ( $product->validated != '0' ) {
									$all_actives = false;
								}

								?>
								<tr>
									<?php if ( $order->id_orders_status == 2 AND $order->id_orders_payment_status == 3 AND $product->status == 1  ) : ?>
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
										<?php if ( $order->id_orders_status == 2 AND $order->id_orders_payment_status == 3 AND $product->status == 1 ) : ?>
											<a target="_blank" href="{{ url() }}ticket/<?php echo base64_encode($sale->id_event . '#' . $product->ticket) ?>">
												{{ product.Products.name }}

												<?php if ( $product->fraction > 1 ) : ?>
													({{ product.product_sequence }}/{{ product.fraction }})
												<?php endif ; ?>


												<?php if ( $product->id_product_seat > 1 ) : ?>
													({{ product.ProductsSeats.label }})
												<?php endif ; ?>

												<small>&nbsp;<b>({{ t._('click to view') }})</b></small>
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

									<?php  if ( $order->OrderSale[0]->Sales->Events->id == 1 )  : ?>
										<td>
											<a href="#" class="btn btn-sm btn-primary" data-toggle="modal" data-target="#editarTicket{{product.id}}">
												<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 14.66V20a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h5.34"></path><polygon points="18 2 22 6 12 16 8 16 8 12 18 2"></polygon></svg>
											</a>

											<!-- Modal -->
											<div class="modal fade" id="editarTicket{{product.id}}" tabindex="-1" aria-labelledby="editarTicket{{product.id}}Label" aria-hidden="true">
												<div class="modal-dialog">
												<div class="modal-content">
													<div class="modal-header">
													<h5 class="modal-title" id="editarTicket{{product.id}}Label">Editar - {{ product.Products.name }}

														<?php if ( $product->fraction > 1 ) : ?>
															({{ product.product_sequence }}/{{ product.fraction }})
														<?php endif ; ?>


														<?php if ( $product->id_product_seat > 1 ) : ?>
															({{ product.ProductsSeats.label }})
														<?php endif ; ?>
													</h5>
													<button type="button" class="close" data-dismiss="modal" aria-label="Close">
														<span aria-hidden="true">&times;</span>
													</button>
													</div>
													<div class="modal-body">
														<form action="{{url()}}/account/order/{{order.id}}" method="POST">
															<input type="hidden" name="idSalesItems" value="{{product.id}}" class="form-control">
															<div class="form-group">
															<label>Nome no ingresso</label>
															<input type="text" name="name" class="form-control" value="{{product.customer_name}}">
															</div>
															<button type="submit" class="btn btn-primary">Alterar</button>
														</form>
													</div>
												</div>
												</div>
											</div>
										</td>
									<?php endif ; ?>
								</tr>
							<?php  endforeach; ?>
							<tr>
								<th colspan="2" class="text-right">{{ t._('SUBTOTAL') }}</th>
								<td><?php echo formatMoney($tt_value_product, true, COMPANY, true) ?></td>
								<td><?php echo formatMoney($tt_value_fees, true, COMPANY, true) ?></td>
								<td><?php echo formatMoney($tt_value_taxes, true, COMPANY, true) ?></td>
								<?php  if ( $order->OrderSale[0]->Sales->Events->id == 1)  : ?>
									<td>#</td>
								<?php endif ; ?>
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




				<?php
					$existing_cancellation = false;
					if ( isset($sale->SalesCancellation) AND isset($sale->SalesCancellation[0]) ) :
						$SalesCancellation = $sale->SalesCancellation[0];
						$existing_cancellation = true;
					?>
					<?php if ( $SalesCancellation->status == 1  ) : ?>

						<div class="alert alert-info" role="alert">
							{{ t._('Cancellation in process') }}
						</div>

					<?php elseif ( $SalesCancellation->status == 2  ) : ?>

						<div class="alert alert-success" role="alert">
							{{ t._('Successfully canceled') }}
						</div>

					<?php elseif ( $SalesCancellation->status == 3  ) : ?>

						<div class="alert alert-danger" role="alert">
							{{ t._('Cancellation failure') }}
						</div>

					<?php endif ; ?>
				<?php endif ; ?>

				<?php
					if ( isset($cancellation['able']) AND $cancellation['able'] AND $all_actives AND $existing_cancellation == false  AND COMPANY == 'lebillet'  ) :

						$str = strtotime($now) - strtotime($order->created_at);
						$days_purchase = floor($str/3600/24);

						$str = strtotime($event->date_start) - strtotime($now) ;
						$days_event = floor($str/3600/24);

						$cancel_value = $sale->value_interest +  $sale->value_interest_tax ;

						// PICPAY nao faz estorno parcial - por isso muda pra INTEGRAL
						if ( $sale->id_payment_type == 20 ) {
							// Comentei pra testar, não precisa mostrar pro cliente
							// No BACKEND ja trata isso igual e cancela o valor total
							// Se tiver mais de um evento no pedido, vai dar errado saporra
							// $cancellation['type'] = 4;
						}


						// Compras com até 7 dias, cancelamento total sem reter taxa
						// Isto por causa da regra do CDC de poder cancelar com 7 dias sem custos
						if ( $days_purchase < 7 ) {
							$cancellation['type'] = 4;
						}
				?>

				<div class="ticket-info">
					<div class="side-info">
						<div class="title">{{ t._('Cancellation') }} / {{ t._('refund') }} </div>
						<ul class="info-list">

							<li class="info-item">
								O cancelamento/reembolso desta compra é permitido até {{ cancellation['days_after_purchase'] }} dia(s) após a compra, desde que esteja no prazo minimo de {{ cancellation['days_before_event'] }} dia(s) antes do evento.
							</li>

							<?php if ( $days_purchase <= $cancellation['days_after_purchase']  AND  $days_event >= $cancellation['days_before_event'] ) : ?>

								<li class="info-item">
									<span class="info-type">{{ t._('VALUE') }}: &nbsp; </span>
									<?php if ( $cancellation['type'] == '1' ) :  ?>
										<?php $cancel_value += $tt_value_product; ?>
										<i>Somente valor do(s) produto(s)</i>
									<?php elseif ( $cancellation['type'] == '2' ) : ?>
										<?php $cancel_value += $tt_value_product + $tt_value_fees + $tt_value_taxes; ?>
										<i>Somente valor do(s) produto(s) e taxas</i>
									<?php elseif ( $cancellation['type'] == '3' ) :  ?>
										<?php $cancel_value += $tt_value_product + $sale->value_delivery; ?>
										<i>Somente valor do(s) produto(s) e entrega</i>
									<?php elseif ( $cancellation['type'] == '4' ) :  ?>
										<?php $cancel_value += $tt_value_product + $tt_value_fees + $tt_value_taxes + $sale->value_delivery; ?>
										<i>Cancelamento total</i>
									<?php endif ; ?>
									&nbsp; <b><?php echo formatMoney($cancel_value, true, COMPANY, true) ?></b>
								</li>

								<li id="li_cancel_{{ sale.id }}" style="display: block;">
									<br>
									Desejar realizar o cancelamento/reembolso? <br>
									<button class="btn btn-danger" onclick="$('#li_check_{{ sale.id }}').show(); $('#li_cancel_{{ sale.id }}').hide(); ">{{ t._('CANCEL') }} <?php echo formatMoney($cancel_value, true, COMPANY, true) ?> </button>
								</li>
								<li id="li_check_{{ sale.id }}" style="display: none;">
									<br>

									<label>
										<input type="checkbox" id="check_{{ sale.id }}" style="width: 20px;height: 20px;" > Confirmo que desejo cancelar todos ingressos desse evento e estou ciente que os mesmos não poderão ser utilizados em hipótese alguma.
									Reconheço que o processo é irreversível e concordo com o valor de <?php echo formatMoney($cancel_value, true, COMPANY, true) ?>
									</label>
									<br>

									<button class="btn btn-info" onclick="cancelSale('{{ sale.id }}', this)"  >{{ t._('CANCEL') }} <?php echo formatMoney($cancel_value, true, COMPANY, true) ?> </button>
									<br>

									<form id="sale_{{ sale.id }}" method="POST">
										<input type="hidden" name="sale" value="<?php echo base64_encode($this->crypt->encryptBase64($sale->id))  ?>"  >
									</form>

								</li>

							<?php else : ?>
								Devido ao prazo acima, essa compra não pode ser cancelada.
							<?php endif ; ?>

						</ul>
					</div>
				</div>


				<?php elseif (  $all_actives AND $existing_cancellation == false AND COMPANY == 'lebillet' )  :   /* COMPANY pra funcionar isso só na lebillet  */ ?>
					<blockquote class="blockquote">
						<p class="mb-0">{{ t._('Cancellation') }}</p>
						<footer class="blockquote-footer">
							{{ t._('This order is not eligible for cancellation') }}
						</footer>
					</blockquote>
				<?php endif ; ?>


			<?php  endforeach ;  ?>



				<script type="text/javascript">
					function cancelSale(sale, btn)
					{
						check = $('#check_' + sale);
						if ( check.is(':checked') ) {
							$(btn).attr('disabled','disabled');
							$('#sale_' + sale).submit();
						} else {
							check.parent().css({'font-weight':'bold','color':'green' }).fadeOut(100).fadeIn(100).fadeOut(100).fadeIn(100);
						}
					}
				</script>









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



				<div class="information-block">
					<div class="information-block-inner">
						<div class="block-title">
							<!--h3 class="title">IMPORTANT INFORMATIONS</h3-->
						</div>
						<ul class="normal-list">
							{{ config.company.ticket_instructions }}
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
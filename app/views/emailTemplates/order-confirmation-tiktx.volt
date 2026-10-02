
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">

	<title>Digital Purchase Confirmation from tiktx.com</title>

	<style type="text/css">
</style>
</head>
<body style="margin:0; padding:0; background-color:#F2F2F2; font-family: 'Oxygen', sans-serif;">
	<center>
		<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#F2F2F2">
			<tr>
				<td align="center" valign="top">


					<table width="640" cellpadding="0" cellspacing="0" border="0"  bgcolor="#FFF">
						<tr>
							<td align="center" valign="top">









								<table width="640" cellspacing="0" cellpadding="0" border="0" align="center" style="max-width:640px; width:100%;" bgcolor="#201E1E">
									<tr>
										<td align="center" valign="top" style=" ">

											<table width="640" cellspacing="20" cellpadding="0" border="0" align="center" style="  width:100%;">
												<tr>
													<td width="50" align="center" valign="top" style=" ">
														<img src="{{ url() }}img/email/confirmation_header_tiktx_black.gif" />
													</td>
													<td width="400" align="center" valign="top" style="font-size: 25px; color: #fefefe; padding: 10px 0; border-left: 2px solid #c4c4c4; border-right: 2px solid #c4c4c4;">
														CONFIRMATION&nbsp;ORDER
														<br />
														#<?php echo str_pad($order->id, 5, "0", STR_PAD_LEFT) ?>
													</td>
													<td width="50" align="center" valign="top" style=" ">
														<img src="{{ url() }}img/email/confirmation_header_tiktx_black.gif" />
													</td>
												</tr>
											</table>


										</td>
									</tr>
								</table>


								<table width="640" cellpadding="0" cellspacing="0" border="0"  bgcolor="#FFF">

									<tr>
										<td height="10" style="font-size:10px; line-height:10px;">&nbsp;</td>
									</tr>


									<tr>
										<td align="center" valign="top">
											DATE: <?php echo date('m/d/Y h:i A', strtotime($order->created_at))  ?>

										</td>
									</tr>
								</table>


							</td>
						</tr>

						<tr>
							<td height="10" style="font-size:10px; line-height:10px;">&nbsp;</td>
						</tr>


						<tr>
							<td align="center" valign="top">

								<table width="640" cellpadding="10" cellspacing="0" border="0"  bgcolor="#FFF">
									<tr>
										<td align="left" valign="top" style="  ;">

											<p>Hello,
												<?php if ( $order->Customers ) : ?>
													{{ order.Customers.name }}
												<?php endif ; ?>
												<?php if ( $order->OrderSale[0]->Orders->send_to_email ) : ?>
													{{ order.send_to_email }}
												<?php endif ; ?>
											<p>This message is a conﬁrmation that your request #<?php echo str_pad($order->id, 5, "0", STR_PAD_LEFT) ?> was successful.</p>

										</td>
									</tr>
								</table>

							</td>
						</tr>



						<tr>
							<td height="30" style="font-size:30px; line-height:30px;">&nbsp;</td>
						</tr>

						<tr>
							<td height="10" style="font-size:10px; line-height:10px;">&nbsp;</td>
						</tr>


						<tr>
							<td align="center" valign="top">

								<table width="640" cellspacing="0" cellpadding="0" border="0" align="center" style="max-width:640px; width:100%;" bgcolor="#FFF">
									<tr>
										<td align="center" valign="top" style=" ">

											<table width="640" cellspacing="0" cellpadding="0" border="0" align="center" style="max-width:640px; width:100%;">
												<tr>
													<td width="120" align="right" valign="top" style="font-size: 30px;  color: #000;">
														<strike>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strike>
													</td>
													<td width="400" align="center" valign="top" style="font-size: 30px;  color: #000; ">
														YOUR&nbsp;PURCHASE
													</td>
													<td width="120" align="left" valign="top" style="font-size: 30px; color: #000;">
														<strike>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strike>
													</td>
												</tr>
											</table>


										</td>
									</tr>
								</table>


							</td>
						</tr>






						<?php
						$mais_que_um = 0;
						foreach ( $order->OrderSale AS $sales) :
							$sale = $sales->Sales;
							$mais_que_um++;
						?>






							<tr>
								<td height="30" style="font-size:30px; line-height:30px;">&nbsp;</td>
							</tr>




							<tr>
								<td align="center" valign="top">

									<table width="640" cellspacing="0" cellpadding="0" border="0" align="center" style="max-width:640px; width:100%;" bgcolor="#FFF">
										<tr>
											<td align="center" valign="top" style="padding:10px;">

												<table width="600" cellspacing="0" cellpadding="0" border="0" align="center" style="max-width:600px; width:100%;">
													<tr>

													<td width="10">	</td>

													<td  align="left" valign="top" style="max-width:580px; width:100%;
													padding-left: 15px;
													border-left: 5px solid #c4c4c4;
													border-top: 0px solid #c4c4c4;
													color: #000; ">

														<h3 style="margin: 5px;">{{ sale.Events.name }}</h3>
														<p style="margin: 5px;">DATE: <?php echo date('M/d/Y', strtotime($sale->Events->date_start)) ?> (<?php echo date('l', strtotime($sale->Events->date_start)) ?> )</p>
														<p style="margin: 5px;">CITY: {{ sale.Events.Cities.name}}/{{ sale.Events.Regions.acronym }} </p>
														<p style="margin: 5px;">LOCAL: {{ sale.Events.Places.name }}</p>
														<p style="margin: 5px;">OPEN: <?php echo date('h:i a', strtotime($sale->Events->date_opening)) ?></p>
														<p style="margin: 5px;">START: <?php echo date('h:i a', strtotime($sale->Events->date_start)) ?></p>

													</td>



													<td width="10"  valign="top" >
														<img   src="{{ url() }}img/shows/{{ sale.Events.logo }}" style="    max-width: 250px;">
													</td>

												</tr>
											</table>


										</td>
									</tr>
								</table>



							</td>
						</tr>





						<tr>
							<td height="30" style="font-size:30px; line-height:30px;">&nbsp;</td>
						</tr>






						<tr>
							<td align="center" valign="top">
								<table width="600" cellspacing="0" cellpadding="10" border="0" align="center" style="max-width:600px; width:100%; font-size: 12px;">
									<tr>


										<td width="350" align="left" valign="middle" style=" ">
											DESCRIPTION
										</td>

										<td width="50" align="center" valign="middle" style=" ">
											PRICE
										</td>

										<td width="50" align="center" valign="middle" style=" ">
											FEE
										</td>

										<td width="50" align="center" valign="middle" style=" ">
											TAXES
										</td>

										<td width="100" align="center" valign="middle" style=" ">
											TOTAL
										</td>

									</tr>
								</table>
							</td>
						</tr>


						<tr>
							<td align="center" valign="top">
								<table width="600" cellspacing="0" cellpadding="10" border="1" align="center" style="max-width:600px; width:100%;font-size: 14px;">

									<?php
									$products = $sale->SalesItems;
									$value_total = $sale->value_delivery;
									foreach ( $products AS $product ) :
										$value_product = $product->value_product;
										$value_fees = $product->value_fee + $product->value_fee_org ;
										$value_taxes = $product->value_product_tax + $product->value_fee_tax + $product->value_fee_org_tax ;
										$value_subtotal = $value_product + $value_fees + $value_taxes;
										//$value_total += $value_subtotal;


										// Considerar a fração do produto
										$value_product = $value_product / $product->fraction;
										$value_fees = $value_fees / $product->fraction;
										$value_taxes = $value_taxes / $product->fraction;
										$value_subtotal = $value_subtotal / $product->fraction;

										$value_total += $value_subtotal;
										?>

										<tr>


											<td width="350" align="left" valign="middle" style=" ">
												<a target="_blank" href="{{ url() }}ticket/<?php echo base64_encode($sale->id_event . '#' . $product->ticket) ?>">
													<img src="{{ url() }}img/email/icon_ticket.png">
													{{ product.Products.name }} <small>(click to view)</small>
												</a>

												<?php if ( $product->fraction > 1 ) : ?>
													<small>{{ product.product_sequence }}/{{ product.fraction }}</small>
												<?php endif ; ?>

											</td>

											<td width="50" align="center" valign="middle" style="white-space: nowrap; ">
												<?php echo formatMoney($value_product, true, 'tiktx') ?>
											</td>

											<td width="50" align="center" valign="middle" style="white-space: nowrap; ">
												<?php echo formatMoney($value_fees, true, 'tiktx') ?>
											</td>

											<td width="50" align="center" valign="middle" style="white-space: nowrap; ">
												<?php echo formatMoney($value_taxes, true, 'tiktx') ?>
											</td>

											<td width="100" align="center" valign="middle" style="white-space: nowrap; ">
												<?php echo formatMoney($value_subtotal, true, 'tiktx') ?>
											</td>

										</tr>
									<?php endforeach ; // foreach ( $products AS $product ) : ?>

								</table>
							</td>
						</tr>




						<?php if ( $sale->value_delivery > 0 ) : ?>
							<tr>
								<td align="center" valign="top">
									<table width="600" cellspacing="0" cellpadding="5" border="0" align="center" style="max-width:600px; width:100%; font-size: 14px;">
										<tr>

											<td width="350" align="center" valign="top" style=" ">
											</td>

											<td width="50" align="center" valign="top" style=" ">
											</td>

											<td width="0" align="center" valign="top" style=" ">

											</td>

											<td width="100" align="right" valign="middle" style="white-space: nowrap;  ">
												DELIVERY
											</td>

											<td width="100" align="center" valign="middle" style="white-space: nowrap; ">
												<?php echo formatMoney($sale->value_delivery, true, 'tiktx') ?>
											</td>

										</tr>
									</table>
								</td>
							</tr>
						<?php endif ; ?>


						<tr>
							<td align="center" valign="top">
								<table width="600" cellspacing="0" cellpadding="5" border="0" align="center" style="max-width:600px; width:100%; font-size: 14px;">
									<tr>

										<td width="350" align="center" valign="middle" style=" ">
										</td>

										<td width="50" align="center" valign="middle" style=" ">
										</td>

										<td width="0" align="center" valign="middle" style=" ">

										</td>

										<td width="100" align="right" valign="middle" style="white-space: nowrap; ">
											TOTAL
										</td>

										<td width="100" align="center" valign="middle" style="white-space: nowrap; ">
											<?php echo formatMoney($value_total, true, 'tiktx') ?>
										</td>

									</tr>
								</table>
							</td>
						</tr>






						<tr>
							<td height="10" style="font-size:10px; line-height:10px;">&nbsp;</td>
						</tr>





					<?php endforeach ; // foreach ( $order->OrderSale AS $sales) : ?>












					<tr >
						<td style="font-size:10px; line-height:10px; border-bottom-style: dashed;">&nbsp;</td>
					</tr>

					<tr>
						<td height="10" style="font-size:10px; line-height:10px;">&nbsp;</td>
					</tr>



					<tr>
						<td align="center" valign="top">
							PAYMENT INFORMATION

						</td>
					</tr>





					<tr>
						<td align="center" valign="top">
							<table width="600" cellspacing="0" cellpadding="10" border="0" align="center" style="max-width:600px; width:100%; font-size: 14px;">
								<tr>
									<td width="50%" align="right" valign="top" style=" ">
										Type
									</td>
									<td width="50%" align="left" valign="top" style=" ">
										{{ order.PaymentTypes.name }}
									</td>
								</tr>
								<?php
									if ( $order->id_orders_payment_status == 3 AND $order->id_payment_type == 2 )  :// Payment received e Credit Card
									$payment = $order->OrdersPayment;
									$payment = $payment[0];
								?>
									<tr>
										<td width="50%" align="right" valign="top" style=" ">
											Status
										</td>
										<td width="50%" align="left" valign="top" style=" ">
											{{ order.OrdersPaymentStatus.name }}
										</td>
									</tr>
									<tr>
										<td width="50%" align="right" valign="top" style=" ">
											Auth Code
										</td>
										<td width="50%" align="left" valign="top" style=" ">
											{{ payment.cc_authcode }}
										</td>
									</tr>
									<tr>
										<td width="50%" align="right" valign="top" style=" ">
											Transaction Id
										</td>
										<td width="50%" align="left" valign="top" style=" ">
											{{ payment.cc_transactionid }}
										</td>
									</tr>
								<?php endif ; ?>

						</table>
					</td>
				</tr>



				<tr>
					<td height="40" style="font-size:40px; line-height:40px;">&nbsp;</td>
				</tr>



				<tr  >
					<td style="font-size:10px; line-height:10px; border-bottom-style: dashed;">&nbsp;</td>
				</tr>

				<tr>
					<td height="10" style="font-size:10px; line-height:10px;">&nbsp;</td>
				</tr>



				<tr>
					<td align="center" valign="top">
						IMPORTANT INFORMATIONS


					</td>
				</tr>


				<tr>
					<td align="left" valign="top" style=" ">


						<table width="640" cellpadding="10" cellspacing="0" border="0"  bgcolor="#FFF">
							<tr>
								<td align="left" valign="top" style="  ;">

									<ul style="font-size: 14px; ">
										<li style="list-style-type: disc;">
											<p>
												All purchases, for your safety, undergo an analysis. Therefore, we may request additional information email to verify your identity.
											</p>
										</li>
										<li style="list-style-type: disc;">
											<p>
												To track your order, as well as the history of orders already placed, go to the Tiktx Co. website, log in and check the status on the "Order History" link in the top menu.
											</p>
										</li>
										<li style="list-style-type: disc;">
											<p>
												Always keep your email address updated on our website to receive the latest updates on the event, such as location changes, date and cancellations.
											</p>
										</li>
										<li style="list-style-type: disc;">
											<p>
												Always check the page of the event on our website to update any changes that may occur in the event.
											</p>
										</li>
										<li style="list-style-type: disc;">
											<p>
												We are at your disposal through the email available in the Contact Us section of our website.
											</p>
										</li>

										<li style="list-style-type: disc;">
											<p>
												Occasionally, concerts are canceled or postponed. Should this occur, we will attempt to contact you to inform you of refund or exchange procedures for that concert. For exact instructions on any canceled or postponed concert, please check the concert information online or contact us.
											</p>
										</li>

										<li style="list-style-type: disc;">
											<p>
												If the event was moved or rescheduled, the Event Provider may set refund limitations. Please contact us for more information or to request a refund IF APPLICABLE!
											</p>
										</li>

										<li style="list-style-type: disc;">
											<p>
												*** NO RETURNS FROM TICKETS AND CAN NOT BE TRANSFERRED ***
											</p>
											<p>
												** IT IS NOT NECESSARY TO PRINT YOUR TICKET. JUST SHOW THE QR CODE ON THE CELL PHONE **
											</p>
										</li>

										<li style="list-style-type: disc;">
											<p>
												* This is an automated message, please do not reply *
											</p>
										</li>

									</ul>

								</td>
							</tr>
						</table>



					</td>
				</tr>


			</table>

		</td>
	</tr>



</table>




</center>
</body>
</html>
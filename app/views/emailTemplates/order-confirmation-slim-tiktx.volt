
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">

	<title>{{ config.company.msg_email_order_confirmation }}  #{{ order.id }}</title>

	<!-- Icons -->
	<link rel="shortcut icon" href="{{ url() }}{{ config.company.logos }}favicon.ico" type="image/x-icon">
	<link rel="icon" href="{{ url() }}{{ config.company.logos }}favicon.ico" type="image/x-icon">
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="apple-mobile-web-app-status-bar-style" content="black">
	<meta name="apple-mobile-web-app-title" content="{{ config.company.name }}">
	<link rel="apple-touch-icon" href="{{ url() }}{{ config.company.logos }}apple-icon.png">
	<link rel="apple-touch-icon" sizes="57x57" href="{{ url() }}{{ config.company.logos }}apple-icon-57x57.png">
	<link rel="apple-touch-icon" sizes="60x60" href="{{ url() }}{{ config.company.logos }}apple-icon-60x60.png">
	<link rel="apple-touch-icon" sizes="72x72" href="{{ url() }}{{ config.company.logos }}apple-icon-72x72.png">
	<link rel="apple-touch-icon" sizes="76x76" href="{{ url() }}{{ config.company.logos }}apple-icon-76x76.png">
	<link rel="apple-touch-icon" sizes="114x114" href="{{ url() }}{{ config.company.logos }}apple-icon-114x114.png">
	<link rel="apple-touch-icon" sizes="120x120" href="{{ url() }}{{ config.company.logos }}apple-icon-120x120.png">
	<link rel="apple-touch-icon" sizes="144x144" href="{{ url() }}{{ config.company.logos }}apple-icon-144x144.png">
	<link rel="apple-touch-icon" sizes="152x152" href="{{ url() }}{{ config.company.logos }}apple-icon-152x152.png">
	<link rel="apple-touch-icon" sizes="180x180" href="{{ url() }}{{ config.company.logos }}apple-icon-180x180.png">
	<link rel="icon" type="image/png" sizes="192x192"  href="{{ url() }}{{ config.company.logos }}android-icon-192x192.png">
	<link rel="icon" type="image/png" sizes="32x32" href="{{ url() }}{{ config.company.logos }}favicon-32x32.png">
	<link rel="icon" type="image/png" sizes="96x96" href="{{ url() }}{{ config.company.logos }}favicon-96x96.png">
	<link rel="icon" type="image/png" sizes="16x16" href="{{ url() }}{{ config.company.logos }}favicon-16x16.png">
	<link rel="manifest" href="{{ url() }}{{ config.company.logos }}manifest.json">
	<meta name="msapplication-TileColor" content="#ffffff">
	<meta name="msapplication-TileImage" content="{{ url() }}{{ config.company.logos }}ms-icon-144x144.png">
	<meta name="theme-color" content="#00B1E3">

	<link href="{{ url() }}{{ config.company.logos }}apple_splash_2048x2732.png" sizes="2048x2732" rel="apple-touch-startup-image" />
	<link href="{{ url() }}{{ config.company.logos }}apple_splash_1668x2224.png" sizes="1668x2224" rel="apple-touch-startup-image" />
	<link href="{{ url() }}{{ config.company.logos }}apple_splash_1536x2048.png" sizes="1536x2048" rel="apple-touch-startup-image" />
	<link href="{{ url() }}{{ config.company.logos }}apple_splash_1125x2436.png" sizes="1125x2436" rel="apple-touch-startup-image" />
	<link href="{{ url() }}{{ config.company.logos }}apple_splash_1242x2208.png" sizes="1242x2208" rel="apple-touch-startup-image" />
	<link href="{{ url() }}{{ config.company.logos }}apple_splash_750x1334.png" sizes="750x1334" rel="apple-touch-startup-image" />
	<link href="{{ url() }}{{ config.company.logos }}apple_splash_640x1136.png" sizes="640x1136" rel="apple-touch-startup-image" />

</head>
<body style="margin:0; padding:0; background-color:#545454; font-family: 'Oxygen', sans-serif;">
	<center>
		<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#545454">
			<tr>
				<td align="center" valign="top">

					<table width="100%" cellpadding="0" cellspacing="0" border="0"  bgcolor="#FFF"  style="max-width:640px; width:100%;">
						<tr>
							<td align="center" valign="top">


								<!-- tabela do header -->
								<table   cellspacing="0" cellpadding="0" border="0" align="center" style="max-width:640px; width:100%;" bgcolor="#F2F2F2">
									<tr>
										<td align="center" valign="top" style=" ">

											<table   cellspacing="20" cellpadding="0" border="0" align="center" style="  width:100%;">
												<tr>
													<td width="100%" align="center" valign="top" style=" ">
														<img src="{{ url() }}{{ config.company.logos }}logo.png" />
													</td>
												</tr>
											</table>


										</td>
									</tr>
								</table>




								<!-- tabela apresentação  -->
								<table width="100%" cellpadding="0" cellspacing="0" border="0"  >

									<tr>
										<td height="10" style="font-size:10px; line-height:10px;">&nbsp;</td>
									</tr>

									<tr>
										<td align="center" valign="top">
											<h2>Olá,
												<?php if ( $order->Customers ) : ?>
													{{ order.Customers.name }}
												<?php elseif ( $order->OrderSale[0]->Orders->send_to_email ) : ?>
													{{ order.send_to_email }}
												<?php endif ; ?>
											</h2>

											<p style="color: #989ca0;">
												Este email é a confirmação do seu pedido #{{ order.id }}
											</p>


										</td>
									</tr>

								</table>




									<?php
										foreach ( $order->OrderSale AS $sales) :
										$sale = $sales->Sales;
										$event = $sale->Events;
									?>
									<!-- tabela do evento -->
									<table width="100%" cellpadding="0" cellspacing="0" border="0">
										<tr>
											<td align="center" valign="top" style=" ">

												<p>
													<a href="{{ url() }}event/{{ event.id }}/{{ event.slug }}" style="color: #17a2b8; text-decoration: none;">
														<b>{{ sale.Events.name }}</b>
													</a>
												</p>

												<?php if ( isset($event->EventsImages[0]) ) : ?>
													<img alt="{{ event.name }}" src="{{ url() }}img/shows/{{ event.EventsImages[0].name }}" style="max-width: 350px;" />
												<?php endif ; ?>


												<p style="color: #989ca0; line-height: 25px;">
													<?php echo $this->getDI()->getFormatdates()->format($event->date_opening, '01_de_Jan_-_Domingo_12:00h') ?>
													<br />
													{{ sale.Events.Places.location }}, {{ sale.Events.Cities.name}}, {{ sale.Events.Regions.acronym }}
													<br />
													{{ sale.Events.Places.name }}
												</p>

											</td>
										</tr>


										<tr>
											<td height="15" style="font-size:15px; line-height:15px;" >&nbsp;</td>
										</tr>
										<tr>
											<td height="15" style="font-size:15px; line-height:15px;"  bgcolor="#F2F2F2">&nbsp;</td>
										</tr>


										<tr>
											<td align="center" valign="top" style=" ">
												<?php
													$products = $sale->SalesItems;
													$qty_tickets = count($products);
												?>

												<h2>
													<?php if ( $qty_tickets > 1 ) : ?>
														Seus {{ qty_tickets }} Ingressos
													<?php else : ?>
														Seu Ingresso
													<?php endif ; ?>
												</h2>


												<?php
													$cont = 0;
													foreach ( $products AS $product ) :
													$value_product = $product->value_product;
													$cont++;
												?>
													<br>
													<p>
														<a target="_blank" href="{{ url() }}ticket/<?php echo base64_encode($product->id_event . '#' . $product->ticket) ?><?php echo ( isset($a4) AND $a4 ) ? '?a4=on' : '' ?>" style="color: #17a2b8; text-decoration: none;" >
															Bilhete {{ cont }} de {{ qty_tickets }} - <b>{{ product.ticket }}</b> &nbsp; <img src="{{ url() }}img/email/save_share.png">
														</a>
													</p>
													<img src="{{ url() }}ticket/<?php echo base64_encode($product->id_event . '#' . $product->ticket) ?><?php echo ( isset($a4) AND $a4 ) ? '?a4=on' : '' ?>" alt="Bilhete {{ cont }} de {{ qty_tickets }} - {{ product.ticket }}" />

													<p><br /></p>

												<?php endforeach ; ?>




											</td>
										</tr>







										<tr>
											<td height="15" style="font-size:15px; line-height:15px;" >&nbsp;</td>
										</tr>
										<tr>
											<td height="15" style="font-size:15px; line-height:15px;"  bgcolor="#F2F2F2">&nbsp;</td>
										</tr>


										<tr>
											<td align="center" valign="top" style=" ">
												<h2>
													Clique no mapa para saber como chegar ao evento
												</h2>

												<a target="_blank" href="{{ url() }}event/{{ event.id }}/{{ event.slug }}#show-location" style="text-decoration: none;">
													<img src="{{ url() }}img/email/maps.png" style="width: 80%;" alt="Mapa de como chegar ao local" />
												</a>
											</td>
										</tr>











										<tr>
											<td height="15" style="font-size:15px; line-height:15px;" >&nbsp;</td>
										</tr>
										<tr>
											<td height="15" style="font-size:15px; line-height:15px;"  bgcolor="#F2F2F2">&nbsp;</td>
										</tr>








										<tr>
											<td height="30" style="font-size:30px; line-height:30px;" >&nbsp;</td>
										</tr>









									</table> <!-- /tabela do evento -->

								<?php endforeach ; ?>


							</td>
						</tr>

						<tr>
							<td align="left" valign="top" style=" font-size: 12px; padding: 10px; ">
								{{ config.company.ticket_instructions }}
							</td>
						</tr>


						<tr>
							<td align="center" valign="top" >

									<p>
										<small style="color: red;">** Não responda este email **</small>
									</p>

							</td>
						</tr>






					</table>

				</td>
			</tr>

		</table>


	</center>
</body>
</html>
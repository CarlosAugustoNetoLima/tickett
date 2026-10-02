
<!doctype html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<!--<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">-->
	<meta name="viewport" content="initial-scale=1">
	<title>{{ config.company.title }} | Ticket</title>
	<link href="{{ url() }}plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet">



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

<style type="text/css">
@font-face {
	font-family: 'Mister Giacco';
	src: url('{{ url() }}font/Mister Giacco Bold.ttf');
}
body {
	font-family: "Mister Giacco", serif;
	width: 210mm;
	height: 297mm;
	margin: 0 auto;
    padding: 0px;
	display: block;
	background: white;
}
.header {
	border: 2px solid #368faf;
	-webkit-border-radius: 5px;
	-moz-border-radius: 5px;
	border-radius: 20px;
	margin-top: 15px;
	position: relative;
}

.title {
	margin-top: -14px;
	width: 250px;
}
.title b, .bottom b{
	background-color: #fff;
}
.title b b, .bottom b b{
	margin: 0 5px;
}
.title b span, .bottom b span{
	color: #368faf
}


.bottom {
	position: absolute;
	margin-top: -12px;
	width: 100%;
}

.url-tickets {
	margin-top: -35px;
	margin-right: 15px;
}

.table-header {
	width: 100%;
	margin: 15px 0;
}
.table-footer {
	width: 100%;
}
.img-logo {
	margin-bottom: 10px;
	max-height: 90px;
}
.img-qrcode {

}

.header-middle {
	border-color: #ccc3c3;
	border-style:  dashed ;
	border-width: 0 2px;
}

.header-left img {
	max-width: 80%;
}
h2, h5, h4, h6, h3 {
	text-transform: uppercase;
	/*white-space: nowrap;*/
}
h3 {
	font-size: 26px;
}
h3 p{
	font-size: 12px;
	margin-bottom: 2px;
}
h6 {
	font-size: 11px;
	margin: 0;
}
h4 {
	font-size: 21px;
	margin-bottom: 8px;
}
h2 {
	font-size: 28px;
}


hr {
	margin: 25px 10px;
	border: 0;
	border-bottom: 2px dashed #ccc;
}

.instructions {
	margin-bottom: 0;
}
.instructions li  {
    margin: 5px 0;
    font-size: 14px;
}
.ticket-cut {
	padding-top: 15px;
	margin-bottom: -28px;
	font-size: 11px;
}
.div-footer-event {
	position: absolute;
	text-align: center;
	margin-left: 176px;
	margin-top: 115px;
	-webkit-transform: rotate(-90deg);
	-moz-transform: rotate(-90deg);
	-ms-transform: rotate(-90deg);
	-o-transform: rotate(-90deg);
	filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=3);

}
</style>
<body>
	{{ content() }}

	<div class="container d-table">
		<div class="row">
			<div class="col-12">



				<div class="clearfix">
					<img src="{{ url() }}{{ config.company.logos }}logo.png" class="float-left" style="max-height: 50px;"  />
				</div>


				<div class="  header">
					<div class="text-center mx-auto title">
						<b class="position-absolute"><span>[</span> <b>{{ t._('THIS IS YOUR TICKET') }}</b> <span>]</span></b>
					</div>




					<span class="float-right position-absolute url-tickets">{{ config.company.full_name }}</span>




					<table class="table-header">
						<tbody>
							<tr>



								<td  align="center" valign="center" width="30%">

									<div class="header-left  text-center" style="width: 228px;">


										<?php if ( $ticket->Events->logo ) : ?>
											<img  class="mx-auto img-logo"  style="max-height: 90px;"  src="{{ url() }}img/shows/<?php echo $ticket->Events->logo ?>">
										<?php endif ; ?>

										<?php if ( $ticket->Sales->Customers ) : ?>
											<h6>{{ t._('NAME') }}</h6>
										<?php endif ; ?>
										<h5 style="white-space: unset;           ">
											<small>
												<?php if ( $ticket->Sales->Customers ) : ?>
												<?php if ( isset($ticket->customer_name) ) { ?>
													{{ ticket.customer_name }}
												<?php } else { ?>
													{{ ticket.Sales.Customers.name }}
												<?php } ?>

											<?php elseif( isset($ticket->customer_name) ) : ?>
												{{ ticket.customer_name }}
											<?php endif ; ?>
												<?php if ( $ticket->Sales->OrderSale[0]->Orders->send_to_email ) : ?>
													<small>
														<br>{{ ticket.Sales.OrderSale[0].Orders.send_to_email }}
													</small>
												<?php endif ; ?>
											</small>
										</h5>

										<?php if ( ($ticket->Sales->Customers AND $ticket->Sales->Customers->id_number) OR $ticket->Sales->OrderSale[0]->Orders->customer_id ) : ?>
										<h6>ID</h6>
										<?php endif ; ?>


										<h5 style="white-space: unset;         ">
											<small>
												<?php if ( $ticket->Sales->Customers AND $ticket->Sales->Customers->id_number ) : ?>
													{{ ticket.Sales.Customers.id_number }}
												<?php else : ?>
													<?php if ( $ticket->Sales->OrderSale[0]->Orders->customer_id ) : ?>
														{{ ticket.Sales.OrderSale[0].Orders.customer_id }}
													<?php endif ; ?>
												<?php endif ; ?>
											</small>
										</h5>

										<h6><small>{{ t._('ORGANIZED BY') }}</small></h6>
										<h5>
											<small>{{ ticket.Events.Organizers.name }}</small>
										</h5>

										<?php if ( $ticket->Events->parental_rating AND strlen($ticket->Events->parental_rating) > 0 ) : ?>
	                                        <p><b>{{ t._('parental_rating') }}: {{ ticket.Events.parental_rating }}</b></p>
	                                    <?php endif ; ?>

									</div>

								</td>



								<td  align="center" valign="center" width="40%">
									<div class="header-middle text-center">

										<h6>{{ t._('EVENT') }}</h6>
										<h2>{{ ticket.Events.name }}</h2>
										<?php if ( $ticket->Events->ticket_sub_name ) : ?>
											<h4>{{ ticket.Events.ticket_sub_name }}</h4>
										<?php endif ; ?>


										<h6>{{ t._('DATE') }}</h6>
										<h4><?php echo $this->getDI()->getFormatdates()->format($ticket->Events->date_start, '25/Jan/2000') ?></h4>

										<h6>{{ t._('PLACE') }}</h6>
										<h4>
											{{ ticket.Events.Places.name }}
											<br>
											<small>{{ ticket.Events.Places.location }}</small>
										</h4>


										<h6>{{ t._('CITY') }}</h6>
										<h4>{{ ticket.Events.Cities.name}}/{{ ticket.Events.Regions.acronym }}</h4>

										<h6>{{ t._('OPENS') }}</h6>
										<h4><?php echo $this->getDI()->getFormatdates()->format($ticket->Events->date_opening, '17:00h') ?></h4>


									</div>
								</td>




								<td  align="center" valign="center" width="30%">
									<div class="header-right  text-center">

										<!-- <h6>PRODUCT</h6> -->
										<h3 style="margin-bottom: 0;">
											{{ ticket.Products.name }}
										</h3>
										<?php if ( $ticket->id_product_seat > 1 ) : ?>
											({{ ticket.ProductsSeats.label }})&nbsp;
										<?php endif ; ?>

										<!--
											<small>{{ ticket.Products.ProductsGenres.name }}</small><br>
										-->
											<small>{{ ticket.Products.ProductsGenres.name }} - {{ ticket.ProductsTypes.name }}</small>
											<br>

										<img class="mx-auto img-qrcode" src="https://zxing.org/w/chart?cht=qr&chs=150x150&chld=L&choe=UTF-8&chl={{ ticket.ticket }}">
										<!--
										<h6>
											PRICE
											<?php if ( $ticket->fraction > 1 ) : ?>
												[{{ ticket.product_sequence }}/{{ ticket.fraction }}]
											<?php endif ; ?>
										</h6>
										-->
										<h4>
											<?php if ( $ticket->value_product > 0 ) : ?>
												<?php echo formatMoney(($ticket->value_product / $ticket->fraction), true, COMPANY, true) ?>
											<?php endif ; ?>
										</h4>

									</div>
								</td>




							</tr>
						</tbody>
					</table>



					<div class="text-center mx-auto bottom">
						<b class="position-absolute"><span>&#x25CF;</span> <b>{{ t._('print and present at the event entrance') }}</b> <span>&#x25CF;</span></b>
					</div>


				</div> <!-- <div class="  header"> -->


					<br>

					{{ config.company.ticket_instructions }}

					<div class="ticket-cut text-center">{{ t._('THIS TICKET MAY BE CUT AT THE EVENT') }}</div>
					<hr />









					<table class="table-footer">
						<tbody>
							<tr>



								<td  align="left" valign="top" width="35%">

									<?php if ( $ticket->Sales->Customers ) : ?>
										<h6>{{ t._('NAME') }}</h6>
									<?php endif ; ?>
									<h4 style="white-space: unset;         ">
										<small>
											<?php if ( $ticket->Sales->Customers ) : ?>
													<?php if ( isset($ticket->customer_name) ) { ?>
														{{ ticket.customer_name }}
													<?php } else { ?>
														{{ ticket.Sales.Customers.name }}
													<?php } ?>

												<?php elseif( isset($ticket->customer_name) ) : ?>
													{{ ticket.customer_name }}
												<?php endif ; ?>
											<?php if ( $ticket->Sales->OrderSale[0]->Orders->send_to_email ) : ?>
												<small>
													<br>{{ ticket.Sales.OrderSale[0].Orders.send_to_email }}
												</small>
											<?php endif ; ?>
										</small>
									</h4>

										<?php if ( ($ticket->Sales->Customers AND $ticket->Sales->Customers->id_number) OR $ticket->Sales->OrderSale[0]->Orders->customer_id ) : ?>
										<h6>ID</h6>
										<?php endif ; ?>
									<h4 style="white-space: unset;       ">
										<small>
											<?php if ( $ticket->Sales->Customers AND $ticket->Sales->Customers->id_number ) : ?>
												{{ ticket.Sales.Customers.id_number }}
											<?php else : ?>
												<?php if ( $ticket->Sales->OrderSale[0]->Orders->customer_id ) : ?>
													{{ ticket.Sales.OrderSale[0].Orders.customer_id }}
												<?php endif ; ?>
											<?php endif ; ?>
										</small>
									</h4>


									<h6>{{ t._('EVENT DATE') }}</h6>
									<h4><?php echo $this->getDI()->getFormatdates()->format($ticket->Events->date_start, '25/Jan/2000') ?></h4>

									<h6>{{ t._('PLACE') }}</h6>
									<h4>{{ ticket.Events.Places.name }}</h4>

									<h6>{{ t._('CITY') }}</h6>
									<h4>{{ ticket.Events.Cities.name}}/{{ ticket.Events.Regions.acronym }}</h4>


								</td>
								<td  align="center" valign="top" width="35%" style="    border-color: #ccc3c3;
								border-style: dashed;
								border-width: 0 2px;">


								<!---<h6>PRODUCT</h6>-->
								<h3 style="margin-bottom: 0;">
									{{ ticket.Products.name }}
									<?php if ( $ticket->id_product_seat > 1 ) : ?>
										&nbsp;({{ ticket.ProductsSeats.label }})
									<?php endif ; ?>
								</h3>


								<?php if ($ticket->Products->description) : ?>
									<h6>
										{{ ticket.Products.description }}
									</h6>
								<?php endif ; ?>

								<img class="mx-auto" src="https://zxing.org/w/chart?cht=qr&chs=150x150&chld=L&choe=UTF-8&chl={{ ticket.ticket }}">
								<h4>{{  ticket.ticket }}</h4>
								<!---
								<h6>
									PRICE
									<?php if ( $ticket->fraction > 1 ) : ?>
										[{{ ticket.product_sequence }}/{{ ticket.fraction }}]
									<?php endif ; ?>
								</h6>
								-->
								<h4>
									<?php if ( $ticket->value_product > 0 ) : ?>
										<?php echo formatMoney(($ticket->value_product / $ticket->fraction), true, COMPANY, true) ?>
									<?php endif ; ?>
								</h4>

							</td>




							<td  align="center" valign="top" width="30%">
								<div class="header-right  text-center">


									<h6>{{ t._('EVENT') }}</h6>
									<h3>{{ ticket.Events.name }}</h3>

									<h6>{{ t._('EAN') }}</h6>
									<?php if(isset($barCode)){ ?>
										<p class="text-center" style="margin-left: 5px;">{{ barCode  }}</p>
									<?php } ?>
									<h4>{{  ticket.code_ean }}</h4>
									
									

									<small>
										<b>{{ ticket.Products.name }}</b>
										<?php if ( $ticket->id_product_seat > 1 ) : ?>
											- ({{ ticket.ProductsSeats.label }})
										<?php endif ; ?>
										 - {{ ticket.Products.ProductsGenres.name }}
										 - {{ ticket.ProductsTypes.name }}
									</small>
									<br>

									<h6>
										{{ t._('Order') }}: {{ ticket.Sales.OrderSale[0].Orders.id }}
											&nbsp;
										{{ t._('Sale') }}: {{ ticket.Sales.id }}
											&nbsp;
										Evt: {{ ticket.Events.id }}
									</h6>
									<h6>{{ t._('Date') }}: <?php echo $ticket->Sales->created_at  ?></h6>
									<h6>PDV:  <?php echo $ticket->Sales->SalesPoints->name  ?></h6>
									<h6>{{ t._('Terminal') }}:  <?php echo $ticket->Sales->SalesTerminal->name  ?></h6>


									<?php if ( $ticket->fraction > 1 ) : ?>
										<h6>{{ t._('Ticket') }}: {{ ticket.product_sequence }}/{{ ticket.fraction }}</h6>
									<?php endif ; ?>

									<h6>{{ t._('Print') }}: <?php echo date("Y-m-d H:i:s") ?></h6>

								</div>
							</td>




						</tr>
					</tbody>
				</table>








			</div>
		</div>
	</div>

	<script>
		window.onload = function() {
			window.print();
		};
	</script>

</body>
</html>

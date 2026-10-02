<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">

	<title>{{ config.company.msg_email_order_confirmation }} #{{ order.id }}</title>

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
	<link rel="icon" type="image/png" sizes="192x192"
		href="{{ url() }}{{ config.company.logos }}android-icon-192x192.png">
	<link rel="icon" type="image/png" sizes="32x32" href="{{ url() }}{{ config.company.logos }}favicon-32x32.png">
	<link rel="icon" type="image/png" sizes="96x96" href="{{ url() }}{{ config.company.logos }}favicon-96x96.png">
	<link rel="icon" type="image/png" sizes="16x16" href="{{ url() }}{{ config.company.logos }}favicon-16x16.png">
	<link rel="manifest" href="{{ url() }}{{ config.company.logos }}manifest.json">
	<meta name="msapplication-TileColor" content="#ffffff">
	<meta name="msapplication-TileImage" content="{{ url() }}{{ config.company.logos }}ms-icon-144x144.png">
	<meta name="theme-color" content="#00B1E3">

	<link href="{{ url() }}{{ config.company.logos }}apple_splash_2048x2732.png" sizes="2048x2732"
		rel="apple-touch-startup-image" />
	<link href="{{ url() }}{{ config.company.logos }}apple_splash_1668x2224.png" sizes="1668x2224"
		rel="apple-touch-startup-image" />
	<link href="{{ url() }}{{ config.company.logos }}apple_splash_1536x2048.png" sizes="1536x2048"
		rel="apple-touch-startup-image" />
	<link href="{{ url() }}{{ config.company.logos }}apple_splash_1125x2436.png" sizes="1125x2436"
		rel="apple-touch-startup-image" />
	<link href="{{ url() }}{{ config.company.logos }}apple_splash_1242x2208.png" sizes="1242x2208"
		rel="apple-touch-startup-image" />
	<link href="{{ url() }}{{ config.company.logos }}apple_splash_750x1334.png" sizes="750x1334"
		rel="apple-touch-startup-image" />
	<link href="{{ url() }}{{ config.company.logos }}apple_splash_640x1136.png" sizes="640x1136"
		rel="apple-touch-startup-image" />

</head>

<body style="margin:0; padding:0; background-color:#545454; font-family: 'Oxygen', sans-serif;">
	<center>
		<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#545454">
			<tr>
				<td align="center" valign="top">

					<!-- tabela do header -->
					<table width="600px" cellpadding="0" cellspacing="0" border="0" align="center" style="width:600px;"
						bgcolor="#F2F2F2">
						<tr>
							<td align="center" valign="top" style=" ">

								<table cellspacing="0" cellpadding="0" border="0" align="center" style="  width:100%;">
									<tr>
										<td width="100%" align="center" valign="top" style=" ">
											<div style="
												justify-content: space-between;
												align-items: center;
												background-image: url('https://lebillet.eu/logos/lebillet_pt/header_clean.png'); 
												background-size: cover; 
												background-position: center; 
												height: auto;
												display: flex;
												padding: 20px;
												">

												<table width="100%" border="0" cellspacing="0" cellpadding="0"
													style="height: 100%;">
													<tr>
														<td valign="middle" align="left">
															<img src="https://www.tickett.com/brand/logo.png"
																class="logo-esquerda" alt="Logo"
																style="display: block; height: auto; width: 50%;">
														</td>
														<td valign="middle" align="right" style="color: #ffffff;">
															<p style="font-size: 18px;">Confirmação de
																Reserva <br>
																#{{order.id}}
															</p>
														</td>
													</tr>
												</table>
											</div>
										</td>
									</tr>
								</table>


							</td>
						</tr>
					</table>


					<table width="600px" cellpadding="0" cellspacing="0" border="0" bgcolor="#FFF"
						style="max-width:600px; width:600px;">
						<tr>
							<td align="center" valign="top">
								<!-- tabela apresentação  -->
								<table width="100%" cellpadding="0" cellspacing="0" border="0">

									<tr>
										<td height="10" style="font-size:10px; line-height:10px;">&nbsp;</td>
									</tr>

									<tr cellspacing="0" cellpadding="0" border="0" bgcolor="#FFF"
										style=" background-color:#FFF;">
										<td align="start" valign="top" cellspacing="0" cellpadding="0" border="0"
											style="color: #000000; padding: 20px; background-color:#FFF">
											<p style="font-size: 24px; color: #096f94; font-weight: bold;">Olá
												<?php if ( $order->Customers ) : ?>
												{{ order.Customers.name }}
												<?php elseif ( $order->OrderSale[0]->Orders->send_to_email ) : ?>
												{{ order.send_to_email }}
												<?php endif ; ?>
											</p>
											<br>
											Este email é a confirmação do teu pedido #{{ order.id }}
											<br><br>
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
										<td align="start" valign="top" style="color: #000000; padding-left: 20px; padding-right: 20px; background-color:#FFF">

											<!-- <p>
												<a href="{{ url() }}event/{{ event.id }}/{{ event.slug }}"
													style="color: #17a2b8; text-decoration: none;">
													<b>{{ sale.Events.name }}</b>
												</a>
											</p> -->

											<?php if ( isset($event->EventsImages[0]) ) : ?>
											<!--<img alt="{{ event.name }}"
												src="{{ url() }}img/shows/{{ event.EventsImages[0].name }}"
												style="max-width: 350px; border-radius: 10px;" />-->
											
											<img alt="{{ event.name }}"
												src="https://lebillet.eu/img/shows/{{ event.EventsImages[0].name }}"
												style="max-width: 350px; border-radius: 10px;" />
											<?php endif ; ?>


											<p style="color: #989ca0; line-height: 25px;">
												<?php echo $this->getDI()->getFormatdates()->format($event->date_opening, '01_de_Jan_-_Domingo_12:00h') ?>
												<br />
												{{ sale.Events.Places.location }}, {{ sale.Events.Cities.name}}, {{
												sale.Events.Regions.acronym }}
												<br />
												{{ sale.Events.Places.name }}
											</p>
										
											<?php if ($event->id == 1) : ?>
											<p>Olá!<br>
												Se aproxima a hora do nosso encontro em Lisboa - Portugal.<br>
												Estamos felizes com a oportunidade desse encontro!<br>
												Seguem algumas informações importantes:<br><br>

												Dia 04/04/26 - Sábado - Hotel Roma - Lisboa<br><br>

												O acesso dos bilhetes VIP será às 13:30h pela porta principal do Hotel Roma - Av. Roma, nº 33.<br><br>

												O acesso dos bilhetes Plateia será às 14:00h pela porta lateral do Hotel Roma - Av. Infante Dom Pedro, nº 06<br><br>

												No hall de entrada da Sala Veneza, haverá exposição e venda de produtos das marcas brasileiras: <br>
												•  ⁠Turini Vedere (óculos solares e armações)<br>
												•  ⁠Akinna (camisetas, sandálias, bonés, bolsas)<br>
												* Venda apenas em dinheiro<br><br>

												A venda de bilhetes para as palestras no local do evento será apenas em dinheiro.<br><br>

												Programação:<br><br>

												14:30h - Abertura das portas - Sala Veneza / Hotel Roma<br>
												15:00h - Palestra Ana Barragão<br>
												  - “Relacionamentos e Saúde Mental - Crises e Vinculação Saudável” <br>
												15:30h - Palestra Ana Fernandes<br>
												  - “Fazer a Paz com o Passado - Não é Esquecer, Justificar ou Reviver a Dor”<br>
												16:00h - Palestra Dra Andréa Vermont<br>
												  - “A Mente que Adoece em Silêncio – A Epidemia Invisível do Século”<br>
												17:30h - Encerramento<br><br>

												Bilhetes:<br>
												www.lebillet.eu<br><br>


												Produção: <br>
												@evorainstituto<br>
												@revistamulherafricana <br><br>

												Apoio:<br>
												@maniqueisabel <br>
												@elizzandra_santoos <br>
												@anasofiafernandes__ <br> 
												@ana_barragao_mind_soul_bod<br>
											
											</p>
											<?php endif ; ?>

										</td>
									</tr>

									<tr>
										<td align="start" valign="top" style="color: #000000; padding-left: 20px; padding-right: 20px; background-color:#FFF">
											<?php
													$products = $sale->SalesItems;
													$qty_tickets = count($products);
												?>

											<h2>
												<?php if ( $qty_tickets > 1 ) : ?>
												Seus {{ qty_tickets }} Bilhetes
												<?php else : ?>
												Seu Bilhete
												<?php endif ; ?>
											</h2>


											<p>
												<?php if ( $qty_tickets > 1 ) : ?>
												Estão disponíveis no link abaixo.<br>
												<a href="{{link_view_order}}" target="_blank">Clique aqui para aceder
													aos seus bilhetes.</a>
												<?php else : ?>
												Está disponivel no link abaixo.<br>
												<a href="{{link_view_order}}" target="_blank">Clique aqui para aceder ao
													seu bilhete.</a>
												<?php endif ; ?>
											</p>




										</td>
									</tr>


									<tr>
										<td align="start" valign="top" style="color: #000000; padding-left: 20px; padding-right: 20px; background-color:#FFF">
											<h2>
												Clique no mapa para saber como chegar ao evento
											</h2>

											<a target="_blank"
												href="{{ url() }}event/{{ event.id }}/{{ event.slug }}#show-location"
												style="text-decoration: none;">
												<img src="{{ url() }}img/email/maps.png" style="width: 100%;"
													alt="Mapa de como chegar ao local" />
											</a>
										</td>
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
							<td align="center" valign="top"
								style="color: #000000; padding: 20px; ">
								<a target="_blank" href="{{ urlSite }}">
									<img src="https://www.tickett.com/brand/logo.png" style="width: 40%;padding: 10px;
									border-radius: 10px;
									background: #151518e6;"/>
								</a>

								<p>
									<b>{{ config.company.name }}</b>: Inovação, Segurança e Tecnologia de ponta!
								</p>

								<p>
									<small>
										Este é um e-mail automático, <b>favor não responder.</b>
									</small>
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
<?php

$ticket = $product;


?>


<!doctype html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<!--<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">-->
	<meta name="viewport" content="initial-scale=1">

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
	html {
		width:350px;
		margin: 0 auto;
	    padding: 0px;
		background: #FFF;
	}
	body {
	font-family: "Mister Giacco", serif;
	margin: 0 auto;
    padding: 0;
	display: block;
	background: #FFF;
	width:350px;
}
</style>
<body>

<!-- tabela do header -->
<table cellspacing="0" cellpadding="0" border="0" align="center" style="width:350px;" bgcolor="#FFF">
	<tr>
		<td align="center" valign="top" style=" ">

			<table   cellspacing="0" cellpadding="10" align="center" style="  max-width:350px; border: 3px solid #066a8e; border-top: 0; color: #066a8e; font: normal bold 15px  Arial, Helvetica, sans-serif; ">
				<tr>
					<td width="45%" align="center" valign="middle" style="border-top: 3px solid #066a8e; text-align: center;">
						<img src="{{ url() }}{{ config.company.logos }}logo.png" style="width: 100px" />
					</td>
					<td width="10%" align="center" valign="top" style="padding: 0; margin: 0;" >
						<div style=" border: 3px solid #066a8e; border-radius: 0 0 90px 90px; border-top: 0; width: 50px; height: 30px;">
							&nbsp;
						</div>
					</td>
					<td width="45%" align="center" valign="middle" style="font-size: 18px; border-top: 3px solid #066a8e; text-align: center;">
						<?php if (isset($ticket->Products->label_date) AND strlen($ticket->Products->label_date) > 2) : ?>
							{{ ticket.Products.label_date }}
						<?php elseif ( isset($ticket->Events->label_date) AND strlen($ticket->Events->label_date) > 2  ) : ?>
							{{ ticket.Events.label_date }}
						<?php else : ?>
							<?php echo $this->getDI()->getFormatdates()->format($ticket->Events->date_start, '25/Jan/2000') ?>
							<br>
							<?php echo $this->getDI()->getFormatdates()->format($ticket->Events->date_start, '17:00h') ?>
						<?php endif ; ?>
					</td>
				</tr>

				<tr>
					<td colspan="3" align="center" valign="middle" style=" ">

						<?php if ( $ticket->Events->logo ) : ?>
							<img  class=" "  style="max-width: 150px; max-height: 100px;"  src="{{ url() }}img/shows/<?php echo $ticket->Events->logo ?>">
						<?php endif ; ?>

					</td>
				</tr>

				<tr>
					<td colspan="3" align="left" valign="middle" style="font-size: 18px; ">
						{{ ticket.Events.name }}
					</td>
				</tr>

				<tr>
					<td colspan="2" width="100%" align="left" valign="top" style=" ">
						{{ ticket.Events.Places.name }}
						<br>
						{{ ticket.Events.Cities.name}} - {{ ticket.Events.Regions.acronym }}


						<br>
						<br>
						<small>{{ t._('Responsible') }}:</small>
						<br>
						{{ ticket.Events.Organizers.name }}
						<br>
						<small>{{ ticket.Events.Organizers.doc }}</small>

					</td>
					<td width=" " align="right" valign="top" >
						<?php if ( $ticket->value_product > 0 ) : ?>
							<small>{{ t._(ticket.Sales.PaymentTypes.name) }}</small>
							<br>
							<?php echo formatMoney(($ticket->value_product / $ticket->fraction), false, COMPANY, false) ?>

							<?php if ( COMPANY == 'lebillet_pt' ) : ?>
								<br>
								<small>IVA incluído</small>
							<?php endif ; ?>

						<?php endif ; ?>
					</td>
				</tr>

				<tr>
					<td colspan="3" align="center" valign="top" style=" ">
						<?php if ( $ticket->Sales->Orders->Customers && $ticket->Events->id == 1 ) : ?>
							<?php if ( isset($ticket->customer_name) ) { ?>
								{{ ticket.customer_name }}
							<?php } else { ?>
								{{ ticket.Sales.Orders.Customers.name }}
							<?php } ?>
							
						<?php elseif (isset($ticket->customer_name) && $ticket->Events->id == 1) : ?>
							{{ ticket.customer_name }}	
						<?php endif ; ?>
					</td>
				</tr>
				<tr style="color: #333;">

					<td colspan="3" align="center" valign="top" style=" ">

						<h3 style="margin: 10px;">
							{{ ticket.Products.name }}
							<?php if ( $ticket->id_product_seat > 1 ) : ?>
								&nbsp;({{ ticket.ProductsSeats.label }})
							<?php endif ; ?>
							<br>

							<?php
								$label = '<small>';
								if ( $ticket->Products->id_genre > 1 ) {
									$label .= $ticket->Products->ProductsGenres->name;
								}
								if ( $ticket->id_product_type > 1 ) {
									if ( $ticket->Products->id_genre > 1 ) {
										$label .= ' - ';
									}
									$label .= $ticket->ProductsTypes->name;
								}
								$label .= '</small>';
							?>
							{{ label }}


						</h3>

						<?php

							$ticket_number = $ticket->ticket;


							// Em outro processo assincrono, tenta gerar os QRCODES antecipadamente
							// Isto para agilizar este processo e nao travar o servidor na geração da imagem deste ticket
							//$url_qr_code = 'https://chart.googleapis.com/chart?chs=200x200&cht=qr&chl=' . $ticket_number . '&choe=UTF-8&chld=L|0';
							//$url_qr_code = 'http://api.qrserver.com/v1/create-qr-code/?data=' . $ticket_number . '&size=200x200';



							$path_tickets = $this->di->get('pathSite') . 'public/tickets/';
							$qr_code__name = 'qr_code_' . $ticket->id_event . '_' . $ticket->ticket . '.png';
							$url_qr_code = $this->url->get() . 'tickets/' . $qr_code__name;


							// Se não existe o qrcode já no servidor, ai vai criar um novo
							if ( !file_exists($path_tickets . $qr_code__name) ) {

								//$qr_code = file_get_contents($url_qr_code);
								//$file_put_contents = file_put_contents($path_tickets . $qr_code__name, $qr_code );

								// Primeiro tenta criar usando uma biblioteca PHP
								include($this->di->get('pathSite') . 'vendor/phpqrcode/qrlib.php');
								QRcode::png($ticket_number, $path_tickets . $qr_code__name, QR_ECLEVEL_L, 9, 0 );


									// Se não existe, deu erro na criação, então usa um padrão do google mesmo
									if ( !file_exists($path_tickets . $qr_code__name) ) {
										$url_qr_code = 'https://chart.googleapis.com/chart?chs=200x200&cht=qr&chl=' . $ticket_number . '&choe=UTF-8&chld=L|0';
										//$url_qr_code = 'http://api.qrserver.com/v1/create-qr-code/?data=' . $ticket_number . '&size=200x200';
									}

							}


						?>
						<img class="mx-auto img-qrcode" src="{{ url_qr_code }}" />

						<p style="letter-spacing: 2px; margin-bottom: 0;">
							{{ ticket.ticket }}


							<?php if ( $ticket->fraction > 1 ) : ?>
								<small>({{ ticket.product_sequence }}/{{ ticket.fraction }})</small>
							<?php endif ; ?>


						</p>

						<p style="letter-spacing: 2px; margin-bottom: 0; font-size: 12px;">
							EAN
						</p>
						<?php if(isset($barCode)){ ?>
							<p class="text-center" style="margin-left: 5px;">{{ barCode  }}</p>
						<?php } ?>
						<p style="letter-spacing: 2px; margin-bottom: 0; font-size: 12px;">
							{{ ticket.code_ean }}
						</p>

						<?php if ($ticket->Products->description) : ?>
							<p style="margin-bottom: 0; font-weight: normal;">
								<small>{{ ticket.Products.description }}</small>
							</p>
						<?php endif ; ?>

					</td>
				</tr>



			</table>


		</td>
	</tr>

</table>



</body>
</html>

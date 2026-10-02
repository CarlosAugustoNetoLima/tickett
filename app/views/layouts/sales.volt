<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>{{ config.company.title }}</title>

	<!-- Bootstrap CSS CDN -->
	<link href="{{ url() }}plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<link href="{{ url() }}plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet">


	<link href="{{ url() }}css/bootstrap-datetimepicker.min.css" rel="stylesheet">
	<link href="{{ url() }}css/magicsuggest.css" rel="stylesheet" type="text/css">

	<!-- Our Custom CSS -->
	<link rel="stylesheet" href="{{ url() }}css/sales.css">


	<!-- Icons -->
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="apple-mobile-web-app-status-bar-style" content="black">
	<meta name="apple-mobile-web-app-title" content="{{ config.company.title }}">
	<link rel="apple-touch-icon" sizes="57x57" href="{{ url() }}favicon-sales/apple-icon-57x57.png">
	<link rel="apple-touch-icon" sizes="60x60" href="{{ url() }}favicon-sales/apple-icon-60x60.png">
	<link rel="apple-touch-icon" sizes="72x72" href="{{ url() }}favicon-sales/apple-icon-72x72.png">
	<link rel="apple-touch-icon" sizes="76x76" href="{{ url() }}favicon-sales/apple-icon-76x76.png">
	<link rel="apple-touch-icon" sizes="114x114" href="{{ url() }}favicon-sales/apple-icon-114x114.png">
	<link rel="apple-touch-icon" sizes="120x120" href="{{ url() }}favicon-sales/apple-icon-120x120.png">
	<link rel="apple-touch-icon" sizes="144x144" href="{{ url() }}favicon-sales/apple-icon-144x144.png">
	<link rel="apple-touch-icon" sizes="152x152" href="{{ url() }}favicon-sales/apple-icon-152x152.png">
	<link rel="apple-touch-icon" sizes="180x180" href="{{ url() }}favicon-sales/apple-icon-180x180.png">
	<link rel="icon" type="image/png" sizes="192x192"  href="{{ url() }}favicon-sales/android-icon-192x192.png">
	<link rel="icon" type="image/png" sizes="32x32" href="{{ url() }}favicon-sales/favicon-32x32.png">
	<link rel="icon" type="image/png" sizes="96x96" href="{{ url() }}favicon-sales/favicon-96x96.png">
	<link rel="icon" type="image/png" sizes="16x16" href="{{ url() }}favicon-sales/favicon-16x16.png">
	<link rel="manifest" href="{{ url() }}favicon-sales/manifest.json">
	<meta name="msapplication-TileColor" content="#ffffff">
	<meta name="msapplication-TileImage" content="{{ url() }}favicon-sales/ms-icon-144x144.png">
	<meta name="theme-color" content="#005D8A">

	<link href="{{ url() }}apple_splash_2048x2732.png" sizes="2048x2732" rel="apple-touch-startup-image" />
	<link href="{{ url() }}apple_splash_1668x2224.png" sizes="1668x2224" rel="apple-touch-startup-image" />
	<link href="{{ url() }}apple_splash_1536x2048.png" sizes="1536x2048" rel="apple-touch-startup-image" />
	<link href="{{ url() }}apple_splash_1125x2436.png" sizes="1125x2436" rel="apple-touch-startup-image" />
	<link href="{{ url() }}apple_splash_1242x2208.png" sizes="1242x2208" rel="apple-touch-startup-image" />
	<link href="{{ url() }}apple_splash_750x1334.png" sizes="750x1334" rel="apple-touch-startup-image" />
	<link href="{{ url() }}apple_splash_640x1136.png" sizes="640x1136" rel="apple-touch-startup-image" />

</head>
<script type="text/javascript">
	var BASE_URL = "{{ di['urlSales'] }}";
	var Translate = {
		button_loading: '{{ t._('button_checkout_loading') }}',
		email_sent: '{{ t._('Email sent') }}',
	};
</script>

<body>



	<div class="wrapper">


		<!-- Sidebar Holder -->
		{{ partial("sales/sales-sidebar") }}



		<!-- Page Content Holder -->
		<div id="content"  class="container-fluid">

			<nav class="navbar navbar-default">
				<div class="navbar-header">
					<button type="button" id="sidebarCollapse" class="btn btn-primary navbar-btn">
						<i class="fa fa-align-left" aria-hidden="true"></i>
						<span>&nbsp;Menu</span>
					</button>
				</div>





				<div class="btn-group">
					<button type="button" class="btn btn-primary">
						<?php if  ( isset( $cart['event']) AND count($cart['event']) > 0 ) : ?>
							<a href="#detail-cart"  data-toggle="modal" data-target="#detail-cart">
								<strong>
									<i class="fa fa-shopping-cart" aria-hidden="true"></i> &nbsp;
									<?php echo  formatMoney($cart['value_total']) ?>
								</strong>
							</a>
						<?php else : ?>
							<strong>
								<i class="fa fa-shopping-cart" aria-hidden="true"></i> &nbsp;
								<?php echo formatMoney(0) ?>
							</strong>
						<?php endif ; ?>
					</button>

				<?php if  ( isset( $cart['event']) AND count($cart['event']) > 0 ) : ?>
					<button type="button" class="btn btn-primary dropdown-toggle dropdown-toggle-split" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
						<span class="sr-only">{{ t._('show') }}</span>
					</button>
					<div class="dropdown-menu dropdown-menu-right" style="    left: unset;    right: 0 !important;">
						<ul class="list-group">
						<?php
						foreach ( $cart['event'] AS $id_event => $event ) :
							?>
							<li class="dropdown-item justify-content-between align-items-center">
								<a  href="{{ di['urlSales'] }}event/{{ id_event }}" class="">
									<?php echo $event['event_name'] ?>
									<strong><?php echo formatMoney($event['value_total']) ?></strong>
								</a>
							</li>
						<?php endforeach ; ?>

						<div class="dropdown-divider"></div>
						<a class="dropdown-item" href="{{ di['urlSales'] }}clearCart">{{ t._('clear_cart') }}</a>
						<a class="dropdown-item" href="#detail-cart"  data-toggle="modal" data-target="#detail-cart">{{ t._('detail_cart') }}</a>
						</ul>
					</div>
				<?php endif ; ?>

				</div>


			</nav>

			{{ content() }}

		</div> <!-- <div id="content"> -->

		</div> <!-- <div class="wrapper"> -- >




			<?php if  ( isset( $cart['event']) AND count($cart['event']) > 0 ) : ?>

				<!-- Modal -->
				<div class="modal fade" id="detail-cart" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
					<div class="modal-dialog" role="document">
						<div class="modal-content">
							<div class="modal-header">
								<h5 class="modal-title" id="exampleModalLabel">{{ t._('cart') }}</h5>
								<button type="button" class="close" data-dismiss="modal" aria-label="Close">
									<span aria-hidden="true">&times;</span>
								</button>
							</div>
							<div class="modal-body">
								<?php $this->partial("cart/cart-resume", array('cart' => $cart) ); ?>
							</div>
							<div class="modal-footer">
								<!--<a href="{{ di['urlSales'] }}cart" class="btn btn-primary" >{{ t._('checkout') }}</a>-->
								<button type="button" class="btn btn-secondary" data-dismiss="modal">{{ t._('close') }}</button>
							</div>
						</div>
					</div>
				</div>

			<?php endif ; ?>







			<!-- jQuery CDN-->
			<script src="{{ url() }}plugins/jquery/jquery.min.js"></script>

			<!-- Bootstrap Js CDN -->
			<script src="{{ url() }}plugins/bootstrap/js/popper.min.js"></script>
			<script src="{{ url() }}plugins/bootstrap/js/bootstrap.min.js"></script>
			<script src="{{ url() }}js/moment.min.js"></script>
			<script src="{{ url() }}js/bootstrap-datetimepicker.min.js"></script>
			<script src="{{ url() }}js/magicsuggest.js"></script>
			<?php $this->assets->outputJs() ?>
			<script src="{{ url() }}js/sales.js"></script>
			{{ assets.outputInlineJs() }}





		</body>
		</html>

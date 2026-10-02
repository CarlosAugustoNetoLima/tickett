<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>{{ config.company.title }}</title>
	<link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="{{ url() }}plugins/touchspin/jquery.bootstrap-touchspin.css">
	<link rel="stylesheet" type="text/css" href="{{ url() }}css/checkout.css?v=2">
	<script type="text/javascript">
		var BASE_URL = '{{ urlCheckout }}';
		var ID_EVENT = '<?php echo isset($event) ? $event->id : '0' ?>';
		var Translate = {
			button_loading: '{{ t._('button_checkout_loading') }}',
			email_sent: '{{ t._('Email sent') }}',
		};
	</script>

	<!-- Icons -->
	<link rel="apple-touch-icon" sizes="57x57" href="{{ url() }}apple-icon-57x57.png">
	<link rel="apple-touch-icon" sizes="60x60" href="{{ url() }}apple-icon-60x60.png">
	<link rel="apple-touch-icon" sizes="72x72" href="{{ url() }}apple-icon-72x72.png">
	<link rel="apple-touch-icon" sizes="76x76" href="{{ url() }}apple-icon-76x76.png">
	<link rel="apple-touch-icon" sizes="114x114" href="{{ url() }}apple-icon-114x114.png">
	<link rel="apple-touch-icon" sizes="120x120" href="{{ url() }}apple-icon-120x120.png">
	<link rel="apple-touch-icon" sizes="144x144" href="{{ url() }}apple-icon-144x144.png">
	<link rel="apple-touch-icon" sizes="152x152" href="{{ url() }}apple-icon-152x152.png">
	<link rel="apple-touch-icon" sizes="180x180" href="{{ url() }}apple-icon-180x180.png">
	<link rel="icon" type="image/png" sizes="192x192"  href="{{ url() }}android-icon-192x192.png">
	<link rel="icon" type="image/png" sizes="32x32" href="{{ url() }}favicon-32x32.png">
	<link rel="icon" type="image/png" sizes="96x96" href="{{ url() }}favicon-96x96.png">
	<link rel="icon" type="image/png" sizes="16x16" href="{{ url() }}favicon-16x16.png">
	<link rel="manifest" href="{{ url() }}manifest.json">
	<meta name="msapplication-TileColor" content="#ffffff">
	<meta name="msapplication-TileImage" content="{{ url() }}ms-icon-144x144.png">
	<meta name="theme-color" content="#005D8A">

</head>
<body>



	<?php if ( isset($event) AND isset($event->id) AND $event->id > 0 ) : ?>

	<?php
	if ( $id_sale_point == 1 )
	{

		if ( in_array($event->id, array(22) )  )
		{
			$event->date_sales_end = '2019-06-01 23:00:00';
		}

	}

/*
	echo date("Y-m-d H:i:s");
	echo '<br>';
	echo $event->date_sales_end;
*/
	?>


	<?php

		$hoje = new DateTime();
		if ( isset($_REQUEST['preview']) ) {
			$event->date_sales_start = date('Y-m-d H:i:s', (time() - 3600) );
			$event->date_sales_end = date('Y-m-d H:i:s', (time() + 3600) );
		}

		$label_sales_start = date('d/m/Y H:i', strtotime($event->date_sales_start));
/*
		if ( in_array($event->id, array(28)) ) { // Mano Walter
			$label_sales_start = 'Julho de 2019';
		} else if ( in_array($event->id, array(27)) ) {  // Ludmilla
			$label_sales_start = 'Julho de 2019';
		} else if ( in_array($event->id, array(29, 30, 31)) ) {  // É o Tchan
			$label_sales_start = 'Junho de 2019';
		}
*/

	?>

	<?php if ( $hoje < new DateTime($event->date_sales_start) )  : ?>


		<div class="container-fluid">
			<div class="row">
				<div class="col-12">
					<div class="alert alert-info text-center" role="alert">
						<p><span title="Atualmente: <?php echo date('d/m/Y H:i') ?>">As</span> vendas iniciam em {{ label_sales_start }}</p>
					</div>
				</div>
			</div>
		</div>


	<?php elseif ( $hoje > new DateTime($event->date_sales_end)  ) : ?>


		<div class="container-fluid">
			<div class="row">
				<div class="col-12">
					<div class="alert alert-info text-center" role="alert">
						<p>As vendas encerraram em <?php echo date('d/m/Y H:i', strtotime($event->date_sales_end)) ?></p>
					</div>
				</div>
			</div>
		</div>


	<?php else : ?>




		<div id="msform">

			<!--{{ event.name }}-->


			<!-- progressbar -->
			<ul id="progressbar">
				<li class="active">{{ t._('products') }}</li>
				<li>{{ t._('customer') }}</li>
				<li>{{ t._('delivery') }}</li>
				<li>{{ t._('payment') }}</li>
			</ul>




			<!-- fieldsets -->
			<fieldset >
				<div id="field-div-products" class="field-div">
					{{ partial("checkout/products") }}
				</div>



				<div  class="cart-resume">
					<div class="collapse cart-resume-in">
					 	{{ partial("checkout/cart-resume") }}
					</div>
					<span  class="span-cart-resume text-muted "  data-toggle="collapse" data-target=".cart-resume-in" aria-expanded="false" aria-controls="collapseExample">
						$<?php echo number_format($cart['value_total'], 2) ?>
					</span>
				</div>



				<button type="button" id="button-products"  class="btn action-button btn  disabled"    data-toggle="tooltip"  title="{{ t._('Next') }}" >
					<i class="glyphicon glyphicon-menu-right"></i>
				</button>
				<br>
				<i class="next" id="products-next"></i>
			</fieldset>



			<fieldset>
				<?php if ( $seller ) : ?>

					<div  id="field-div-login" class="field-div">
						{{ partial("checkout/login-seller") }}
					</div>




					<div  class="cart-resume">
						<div class="collapse cart-resume-in">
						 	{{ partial("checkout/cart-resume") }}
						</div>
						<span  class="span-cart-resume text-muted "  data-toggle="collapse" data-target=".cart-resume-in" aria-expanded="false" aria-controls="collapseExample">
							$<?php echo number_format($cart['value_total'], 2) ?>
						</span>
					</div>




					<button type="button" name="previous" class="previous action-button-previous"  data-toggle="tooltip"  title="{{ t._('Previous') }}">
						<i class="glyphicon glyphicon-menu-left"></i>
					</button>
					<button type="button" id="button-login-seller-email"  class="action-button" onclick="loginSeller(5);" style="display: none;"   data-toggle="tooltip"  title="{{ t._('email') }}" >
						<i class="glyphicon glyphicon-envelope"></i>
					</button>
					<button type="button" id="button-login-seller"  class="btn action-button"  onclick="loginSeller();"  data-toggle="tooltip"  title="{{ t._('Next') }}" >
						<i class="glyphicon glyphicon-menu-right"></i>
					</button>
					<i class="next" id="login-next"></i>

				<?php else : ?>

					<div  id="field-div-login" class="field-div">
						{{ partial("checkout/login") }}
					</div>




					<div  class="cart-resume">
						<div class="collapse cart-resume-in">
						 	{{ partial("checkout/cart-resume") }}
						</div>
						<span  class="span-cart-resume text-muted "  data-toggle="collapse" data-target=".cart-resume-in" aria-expanded="false" aria-controls="collapseExample">
							$<?php echo number_format($cart['value_total'], 2) ?>
						</span>
					</div>


					<button type="button" name="previous" class="previous action-button-previous"  data-toggle="tooltip"  title="{{ t._('Previous') }}">
						<i class="glyphicon glyphicon-menu-left"></i>
					</button>
					<button type="button" id="button-login"  class="btn action-button"  onclick="login();"  data-toggle="tooltip"  title="{{ t._('Next') }}" >
						<i class="glyphicon glyphicon-menu-right"></i>
					</button>
					<i class="next" id="login-next"></i>

				<?php endif ; ?>
			</fieldset>



			<fieldset >
				<div id="field-div-delivery" class="field-div">
					<?php /* {{ partial("checkout/delivery") }} */ ?>
				</div>


				<div  class="cart-resume">
					<div class="collapse cart-resume-in">
					 	{{ partial("checkout/cart-resume") }}
					</div>
					<span  class="span-cart-resume text-muted "  data-toggle="collapse" data-target=".cart-resume-in" aria-expanded="false" aria-controls="collapseExample">
						$<?php echo number_format($cart['value_total'], 2) ?>
					</span>
				</div>



				<button type="button" name="previous" class="previous action-button-previous"   data-toggle="tooltip"  title="{{ t._('Previous') }}">
					<i class="glyphicon glyphicon-menu-left"></i>
				</button>
				<button type="button" id="button-delivery"  class="btn action-button"  onclick="delivery();"   data-toggle="tooltip"  title="{{ t._('Next') }}" >
					<i class="glyphicon glyphicon-menu-right"></i>
				</button>
				<i class="next" id="delivery-next"></i>
			</fieldset>



			<fieldset >
				<div id="field-div-payment" class="field-div">
					<?php /* {{ partial("checkout/payment") }} */ ?>
				</div>


				<div  class="cart-resume">
					<div class="collapse cart-resume-in">
					 	{{ partial("checkout/cart-resume") }}
					</div>
					<span  class="span-cart-resume text-muted "  data-toggle="collapse" data-target=".cart-resume-in" aria-expanded="false" aria-controls="collapseExample">
						$<?php echo number_format($cart['value_total'], 2) ?>
					</span>
				</div>


				<button type="button" name="previous" class="previous action-button-previous"   data-toggle="tooltip"  title="{{ t._('Previous') }}">
					<i class="glyphicon glyphicon-menu-left"></i>
				</button>
				<?php /*
				<button type="button" id="button-payment-credit-card"  class="action-button" onclick="payment(5);" style="display: none;"   data-toggle="tooltip"  title="{{ t._('Credit Card') }}" >
					<i class="glyphicon glyphicon-credit-card"></i>
				</button>
				*/ ?>
				<button type="button" id="button-payment"  class="btn action-button" onclick="payment();"   data-toggle="tooltip"  title="{{ t._('payment') }}" >
					<i class="glyphicon glyphicon-menu-right"></i>
				</button>
				<i class="next" id="payment-next"></i>
			</fieldset>



		</div>



	<?php endif ; ?>



<?php endif ; ?>



<div id="console-log"></div>


<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-easing/1.3/jquery.easing.min.js"></script>
<script src="{{ url() }}plugins/touchspin/jquery.bootstrap-touchspin.js"></script>
<script src="{{ url() }}js/jquery.payment.js"></script>


<script type="text/javascript" src="{{ url() }}plugins/mailtip/jquery.mailtip.js"></script>
<script type="text/javascript">
$(document).on('click', '.email', function() {
    $(this).mailtip({
		mails: ['@gmail.com', '@hotmail.com', '@icloud.com', '@yahoo.com',  '@outlook.com', '@live.com', '@msn.com', '@aol.com'],
		width: 'auto',
		offsetTop: 0,
		offsetleft: 0,
		zindex: 1000
	});
});
</script>



<script src="{{ url() }}js/checkout.js"></script>

<script type="text/javascript">
	function resizeIframe(){
		h=document.body.scrollHeight;
		/*console.log('altura do body: ' + h);*/
		window.parent.postMessage(h, "*");
	}
	$('body').bind("keypress keydown click mouseup", function(){
		resizeIframe();
		setTimeout(function() {
			resizeIframe();
		}, 50);
	});
/*

	$(document).bind("DOMSubtreeModified",function(){
		resizeIframe();
	});
*/
	resizeIframe();

	setTimeout(function() {
		resizeIframe();
	}, 50);

</script>




</body>
</html>
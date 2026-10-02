
<!DOCTYPE html>
<html lang="en">
<head>

	<!-- head -->
	<meta charset="utf-8">
	<meta name="msapplication-tap-highlight" content="no" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">

	{% if metaTitle is defined %}
	<title>{{ metaTitle }} | tiktx.com</title>
	{% else %}
	<title>tiktx.com | Events</title>
	{% endif %}

	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" crossorigin="anonymous">

	<link rel="stylesheet" href="https://owlcarousel2.github.io/OwlCarousel2/assets/owlcarousel/assets/owl.carousel.min.css">
	<link rel="stylesheet" href="https://owlcarousel2.github.io/OwlCarousel2/assets/owlcarousel/assets/owl.theme.default.min.css">

	<script src="https://owlcarousel2.github.io/OwlCarousel2/assets/vendors/jquery.min.js"></script>
	<script src="https://owlcarousel2.github.io/OwlCarousel2/assets/owlcarousel/owl.carousel.js"></script>


	<style type="text/css">
		body {
			background-color: #5d018a;
			overflow: hidden;
		}
		.zoom {
			overflow: hidden;
		}

		.zoom img {
			max-width: 100%;
			-moz-transition: all 0.8s;
			-webkit-transition: all 0.8s;
			transition: transform .8s ease;
		}

		.zoom:hover img {
			-moz-transform: scale(1.1);
			-webkit-transform: scale(1.1);
			transform: scale(1.1);
			filter: brightness(80%);
			transition: transform 1s, filter 1.2s ease-in-out;
		}
		.card-deck {
			margin: 10px;
		}
		.card {
			background-color: #f6f6f6;
			min-height: 380px;
			box-shadow: 0px -2px 20px 0px rgba(0,0,0,0.26);
		}
		.card-title {
			color: #9c02cc;
			margin: 10px 0 5px 0;
		}
		.card-body {
			padding: 0 10px;
		}
		.card p {
			margin: 0;
		}
		.desc {
			font-size: 12px;
		}
		.buy {
			text-align: center;
			margin: 20px 0;
		}

		/* Use a media query to add a breakpoint at 800px: */
		@media screen and (max-width: 800px) {
			.card {
				min-height: 370px;
			}
		}
	</style>

</head>
<body>



	<!-- Set up your HTML -->
	<div class="owl-carousel owl-theme card-deck">

		<?php foreach ($events as $event) : ?>
			<div class="item card zoom">

				<a href="#"  onclick="ticketsCheckout({{ event.id }}); return;"  title="{{ event.name }}" >
					<img class="card-img-top img-hover-zoom" alt="{{ event.name }}" src="https://tiktx.com/img/shows/{{ event.EventsImages[0].name }}" />
				</a>
				<div class="card-body">
					<h5 class="card-title">{{ event.name }}</h5>
					<div class="card-text">
						<p class="desc"><b><?php echo date('M, d', strtotime($event->date_opening)) ?></b>  -  <?php echo date('gA', strtotime($event->date_opening)) ?></p>
						<p class="desc">{{ event.Places.name }}</p>
						<p class="desc">{{ event.Cities.name }}, {{ event.Regions.acronym }}</p>

						<div class="desc buy">
							<button  onclick="ticketsCheckout({{ event.id }}); return;" type="button" class="btn btn-primary">
								Comprar
							</button>
						</div>
					</div>
				</div>

			</div>
		<?php endforeach ; ?>


	</div>

	<script type="text/javascript">
		$(document).ready(function(){
			var owl = $('.owl-carousel');
			owl.owlCarousel({
				loop:true,
				nav:true,
				autoHeight:true,
				autoplay:true,
				autoplayTimeout:4000,
				autoplayHoverPause:true,
				responsiveClass:true,
				margin:5,
				responsive:{
					0:{
						items:2
					},
					600:{
						items:3
					},
					900:{
						items:4
					}
				}
			});
			owl.on('mousewheel', '.owl-stage', function (e) {
				if (e.deltaY>0) {
					owl.trigger('next.owl');
				} else {
					owl.trigger('prev.owl');
				}
				e.preventDefault();
			});

		});
	</script>

	<script src="https://checkout.tiktx.com/js/embedded.js"></script>
	<script type="text/javascript">function ticketsCheckout(id_event) { window.Tickets.checkoutEmbedded({ eventId: id_event, domain: 'https://checkout.tiktx.com/', language: 'pt_br', ref: 'RadioFlorida'}); }</script>


</body>
</html>




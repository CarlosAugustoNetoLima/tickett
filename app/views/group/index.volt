<?php
	$ref = isset($_REQUEST['ref']) ? '?ref=' . $_REQUEST['ref'] : null;
?>
<main>
	<article class="banner-session">
		<section class="box-session">
			<div class="container containerAll" style="background-color: #FFFFFF;">
				<div class="">
					<?php
								if ( isset($group->bannerPrincipal) ) : ?>
					<img class="image-session card-img-top" src="{{ url() }}img/shows/{{ group.bannerPrincipal }}">
					<?php
								endif ;
							?>
					<div style="padding-left: 15px; padding-right: 15px;">
						<h2 class="section-title" style="font-size: large; color: #096f94; padding-top: 20px;">{{
							group.name }}</h2>
						<div class="card-columns">

							<?php foreach ( $events AS $event ) : ?>
							<div class="card card-events">
								<a href="{{ url() }}event/{{ event.id }}/{{ event.slug }}{{ ref }}" class="card-link">
									<img class="card-img-top" alt="{{ event.name }} {{ event.ticket_sub_name }}"
										src="{{ url() }}img/shows/{{ event.EventsImages[0].name }}">
									<div class="card-body">
										<h3 class="title"
											style="font-size: medium; white-space: nowrap;  overflow: hidden;  text-overflow: ellipsis;">
											{{ event.name }}</h3>
										<p class="card-text">
											<?php if ( (isset($event->label_date) AND strlen($event->label_date) > 2) OR (isset($event->date_opening) AND strlen($event->date_opening) > 2) ) : ?>
										<p class="text-left" style="font-size: small;">
											<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
												viewBox="0 0 24 24" fill="none" stroke="#096f94" stroke-width="2"
												stroke-linecap="round" stroke-linejoin="round">
												<rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
												<line x1="16" y1="2" x2="16" y2="6"></line>
												<line x1="8" y1="2" x2="8" y2="6"></line>
												<line x1="3" y1="10" x2="21" y2="10"></line>
											</svg>
											<?php if ( isset($event->label_date) AND strlen($event->label_date) > 2 ) : ?>
											{{ event.label_date }}
											<?php else : ?>
											<?php echo $this->getDI()->getFormatdates()->format($event->date_opening, 'Dom_01_de_Janeiro_de_2000');?>
											<?php endif ; ?>

											*
											<?php echo $this->getDI()->getFormatdates()->format($event->date_opening, '17:00h');?>

											<?php if ( isset($event->Cities->name) AND strlen($event->Cities->name) > 2 ) : ?>
										<p style="font-size: small; color: rgb(98, 105, 115); margin-top: -10px;">
											<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
												viewBox="0 0 24 24" fill="none" stroke="#626973" stroke-width="2"
												stroke-linecap="round" stroke-linejoin="round">
												<path
													d="M12 22s-8-4.5-8-11.8A8 8 0 0 1 12 2a8 8 0 0 1 8 8.2c0 7.3-8 11.8-8 11.8z" />
												<circle cx="12" cy="10" r="3" />
											</svg>
											{{ event.Places.name }} - {{ event.Cities.name }}, {{ event.Regions.acronym
											}}
										</p>
										<?php endif ; ?>
										</p>
										<?php endif ; ?>
										</p>
									</div>
									<div class="card-footer text-center" style="background: #096f94; color: #FFFFFF;">
										COMPRAR
									</div>
								</a>
							</div>

							<?php endforeach ; ?>

						</div>
					</div>
				</div>
			</div>
		</section>
	</article>
</main>








<?php if ( COMPANY == 'lebillet' AND $group->id == 4 ) : ?>
<!-- Facebook Pixel Code -->
<script>
	!function (f, b, e, v, n, t, s) {
		if (f.fbq) return; n = f.fbq = function () {
			n.callMethod ?
				n.callMethod.apply(n, arguments) : n.queue.push(arguments)
		};
		if (!f._fbq) f._fbq = n; n.push = n; n.loaded = !0; n.version = '2.0';
		n.queue = []; t = b.createElement(e); t.async = !0;
		t.src = v; s = b.getElementsByTagName(e)[0];
		s.parentNode.insertBefore(t, s)
	}(window, document, 'script',
		'https://connect.facebook.net/en_US/fbevents.js');
	fbq('init', '443564397195282');
	fbq('track', 'PageView');
</script>
<noscript><img height="1" width="1" style="display:none"
		src="https://www.facebook.com/tr?id=443564397195282&ev=PageView&noscript=1" /></noscript>
<!-- End Facebook Pixel Code -->
<?php endif ; ?>

<!-- Demo styles -->
<style>
	.banner-session {
		background-image: url("{{ url() }}img/shows/<?php echo isset($group->bannerPrincipal) ? $group->bannerPrincipal : ''; ?> ");
		background-position: center;
		background-repeat: no-repeat;
		background-size: cover;
		width: 100%;
		height: 100%;
	}

	.box-session {
		background-color: rgba(0, 0, 0, 0.237);
		backdrop-filter: blur(5px);
	}

	.containerAll {
		padding-right: 0px !important;
		padding-left: 0px !important;
	}

	.image-session {
		display: block;
		width: 100%;
	}

	.text-hors {
		text-align: right;
	}

	.card-events:hover {
		transform: scale(1.05);
	}

	@media only screen and (max-width: 600px) {

		.carousel-shows {
			margin-bottom: 0px;
			margin-top: 0%;
		}

		.swiper {
			width: 100%;
			height: 100%;
			margin-top: 20px;
		}

		.swiper-slide img {
			display: block;
			width: 100%;
			height: 100%;
			object-fit: cover;
		}

		.text-details {
			margin-left: 1%;
		}

		.btn-details {
			width: 100%;
		}

		.text-hors {
			text-align: left;
		}
	}

	@media (min-width: 992px) {
		.swiper {
			width: 90%;
			height: 100%;
		}

		.carousel-shows {
			height: 30rem;
		}
	}

	/* target the active bullet */
	span.swiper-pagination-bullet.swiper-pagination-bullet-active {
		background-color: #096f94;
		opacity: 1;
	}

	.swiper-button-prev {
		color: #096f94;
	}

	.swiper-button-next {
		color: #096f94;
	}
</style>
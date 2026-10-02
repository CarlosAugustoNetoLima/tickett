<main>
	
	<?php
									$imagename = '';
									$index = 0;
									foreach ( $event->EventsImages AS $image ) :
										if ( $image->name ) : 
										$imagename = $image->name;
										else :
											$imagename = $image->base64;
										endif ;
										break;
										$index++;
									endforeach;
									?>
		<article class="banner-session">
			<div class="box-session">

				<div class="container containerAll">
					<div class="card cardNew">
						<?php
								if ( isset($event->bannerPrincipal) ) : ?>
									<img class="image-session card-img-top" src="{{ url() }}img/shows/{{ event.bannerPrincipal }}">
								<?php else : ?>
									<img class="image-session card-img-top" src="{{ image.base64 }}">
								<?php
								endif ;
							?>
						<div class="card-body">

							<div class="row">
									<div class="col-sm-7">
										<h2 class="card-title">
											{{ event.name }}
										</h2>
										<?php if ( $event->ticket_sub_name ) : ?>
										<h5>{{ event.ticket_sub_name }}</h5>
											<?php endif ; ?>
										<p class="card-text" >
											<div class="row">
												<div class="col-sm-8">
													<div class="data-group data-date" style="color: #096f94;">
														<p class="data-text datetime">
															<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#096f94" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
															<?php if ( isset($event->label_date) AND strlen($event->label_date) > 2 ) : ?>
																{{ event.label_date }}
															<?php else : ?>
																<?php echo $this->getDI()->getFormatdates()->format($event->date_opening, '01_de_Jan_-_Domingo_12:00h') ?>
															<?php endif ; ?>
														</p>
													</div>
													<div class="data-group data-location" style="color: #096f94;">
														<p class="data-text location">
															<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#096f94" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s-8-4.5-8-11.8A8 8 0 0 1 12 2a8 8 0 0 1 8 8.2c0 7.3-8 11.8-8 11.8z"/><circle cx="12" cy="10" r="3"/></svg>
															{{ event.Places.name }} - {{ event.Places.Cities.name }}, {{ event.Places.Regions.acronym }}
														</p>
													</div>
												</div>
											</div>
										</p>
										
										<p class="card-text">
											<div class="row">
												<div class="col-sm-12 btnBuy">
													<div class="fixed-tickets-button">
														<a href="#" data-toggle="modal" data-target="#exampleModalLong" class="btn btn-primary">
															<?php if ( isset($event->label_purchase) AND strlen($event->label_purchase) > 2 ) : ?>
																{{ t._(event.label_purchase) }}
															<?php else : ?>
																{{ t._('Buy Tickets') }}
															<?php endif ; ?>
														</a>
													</div>
												</div>
											</div>
										</p>
									</div>
								<?php if(isset($event->video) && $event->video != ''){ ?>
									<div class="col-sm-5 rounded">
										<div style="width: 100%;">
											<iframe width="100%" height="250" src="https://www.youtube.com/embed/{{event.video}}" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
										</div>
									</div>
									<br><br>
									<?php } ?>
							</div>
						<hr>
						<p class="card-text">
							<div class="content-text">
								<div class="text-group">
									<p class="text">
										<?php if ( $event->parental_rating AND strlen($event->parental_rating) > 0 ) : ?>
											<p><b>{{ t._('parental_rating') }}: {{ event.parental_rating }}</b></p>
										<?php endif ; ?>
										{{ event.description }}
									</p>
								</div>
							</div>
						</p>

						<p><strong>Produção e realização - {{ event.Organizers.name }}</strong></p>
						<hr>

						<p class="card-text">
							<h3 class="title">{{ t._('Directions') }}</h3>
							<div class="location-widget">
								<div class="location-widget-inner">
									<div class="location-text">
										<div class="side-text">
											<h5 class="title">{{ event.Places.name }}</h5>
											<p class="text">{{ event.Places.location }} - {{ event.Places.Cities.name }}, {{ event.Places.Regions.acronym }}</p>
										</div>
										<div class="side-button">
											<a href="#" class="btn btn-outline-primary btn-sm" data-toggle="modal" data-target="#mapa">Como chegar</a>
										</div>
									</div>
								</div>
							</div>
						</p>

						<hr>

						<?php if ( $event->map AND strlen($event->map) > 5 ) : ?>
							<p class="card-text">
								<h3 class="title">{{ t._('Event map') }}</h3>
								<div class="content-text">
									<div class="text-group">
										<p class="text">
											<a href="{{ url() }}img/shows/{{ event.map }}" target="_blank" style="cursor: zoom-in;">
												<img class="img-fluid"  src="{{ url() }}img/shows/{{ event.map }}">
											</a>
										</p>
									</div>
								</div>
							</p>

							<hr>
						<?php endif ; ?>

						<?php if ( $event->instructions AND strlen($event->instructions) > 5 ) : ?>
							<p class="card-text">
								<h3 class="title">{{ t._('Information') }}</h3>
								<div class="content-text">
									<div class="text-group">
									<?php if ( isset($event->banner)) : ?>
										<img src="{{ url() }}img/shows/{{ event.banner }}">
										<hr>
										<br>
										<br>
									<?php endif ; ?>
										<p class="text">{{ event.instructions }}</p>
											<br>
											<br>
										<hr>
											<br>
											<br>
										<p class="text">
											{{ t._('Agree to terms and conditions') }}
											<br>
											<a target="_blank" href="{{ url() }}company/terms">{{ t._('Terms and Conditions') }}</a>
										</p>
									</div>
								</div>
							</p>
							<hr>
						<?php endif ; ?>

						<p class="card-text">
							{{ t._('Agree to terms and conditions') }}
							<br>
							<a target="_blank" href="{{ url() }}company/terms">{{ t._('Terms and Conditions') }}</a>
						</p>
					</div>
					</div>
				</div>
				
			</div>
		</article>

		<!-- Modal checkout -->
		<div class="modal fade" id="exampleModalLong" tabindex="-1" role="dialog" aria-labelledby="exampleModalLongTitle" aria-hidden="true">
			<div class="modal-dialog modal-lg" role="document" style="height: 100%;">
			<div class="modal-content" style="height: 100%;">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					  <span aria-hidden="true">&times;</span>
					</button>
				  </div>
				  <div class="modal-body" style="padding: 0%;">
					<?php 

					$la = '';
					if(isset($_GET['l'])){
						$la = '?l=' . $_GET['l'];
					} else if(isset($language)){
						$la = '?l=' . $language;
					}

					?>
					<iframe src="<?php echo  $this->di->get('urlFastCheckout') ?>{{ event.id }}{{la}}" class="tickets-iframe" id="Tickets_Embedded_Checkout_Site" height="100%" width="100%" style="border-width: 0px;"> </iframe>
				  </div>
			</div>
			</div>
		</div>


			<!-- MAPA MODAL -->
			<div class="modal fade" id="mapa" tabindex="-1" role="dialog">
				<div class="modal-dialog modal-lg">
					<div class="modal-content">
						<div class="modal-header justify-content-center">
							<h3 class="modal-title">{{ t._('Como chegar') }}</h3>
							<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
						</div>
						<div class="modal-body">
							<div class="location-map">
								{{ event.Places.description }}
							</div>
						</div>
					</div>
				</div>
			</div>
		<style>
			.banner-session {
				background-image: url("{{ url() }}img/shows/<?php echo isset($event->bannerPrincipal) ? $event->bannerPrincipal : $imagename; ?> ");
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

			.image-session {
				display: block;
				width: 100%;
			}

			.show-header{
				width: 70%;
				margin: auto;
				display: block;
			}

			.cardNew{
				width: 100%;
				height: 100%;
				margin: auto;
				display: block;
			}

			.show-page .show-page-inner .show-header .show-header-nav .nav-tabs .nav-item.active {
				opacity: 1;
				border-bottom: 3px solid #096f94;
			}

			.show-page .show-page-inner .show-header .show-header-nav .nav-tabs .nav-item {
				padding-bottom: 1.4rem;
				font-size: .87rem;
				color: #096f94;
				opacity: .7;
				font-weight: 700;
				border: none;
			}

			.containerNew {
				max-width: 100%;
			}

			.card {
				border: 0px solid transparent;
			}

			@media only screen and (max-width: 600px) {
				.containerAll{
					padding-right: 0px;
					padding-left: 0px;
				}
				.modal-dialog {
					max-width: 100% !important;
					margin: 1.75rem auto;
				}
			}

			
			.modal-lg, .modal-xl {
				max-width: 80%;
			}

			@media (min-width: 992px) {
				.modal-lg, .modal-xl {
					max-width: 80%;
				}
			}


		</style>
</main>


<?php
	$language = $this->session->get("language") ?: 'pt_br';
	$sid = session_id();
	$ref = isset($_REQUEST['ref']) ? $_REQUEST['ref'] : null;
?>

<script src="<?php echo  $this->di->get('urlFastCheckout') ?>js/embedded.js?v=1"></script>
<script type="text/javascript">function ticketsCheckout(id_event) { window.Tickets.checkoutEmbedded({ eventId: id_event, domain: '<?php echo  $this->di->get('urlFastCheckout') ?>', language: '{{ language }}', sid: '{{ sid }}', ref: '{{ ref }}' }); }</script>


<script type="application/ld+json">
{
  "@context": "http://schema.org",
  "@type": "Event",
  "name": "{{ event.name }}",
  "startDate": "{{ event.date_start }}",
  <?php if ( isset( $event->Places) AND isset( $event->Places->Cities->name) AND isset( $event->Places->Countries->name) ) : ?>
	  "location": {
		"@type": "Place",
		"name": "{{ event.Places.name }}",
		"address": {
		  "@type": "PostalAddress",
		  "streetAddress": "{{ event.Places.location }}",
		  "addressLocality": "{{ event.Places.Cities.name }}",
		  "addressRegion": "{{ event.Places.Regions.acronym }}",
		  "addressCountry": "{{ event.Places.Countries.name }}"
		}
	  },
	<?php endif ; ?>
  "image": [
	<?php
		$qtd = count($event->EventsImages);
		$contador = 1;
		foreach ( $event->EventsImages AS $image ) :
	?>
		"{{ url() }}img/shows/{{ image.name }}" <?php echo $contador < $qtd ? ',' : ''  ?>
	<?php
		$contador++;
		endforeach ;
	?>
   ],
<?php
$qtd = count($event->EventsPerformes);
if ( $qtd > 0 ) :
?>
  "performer": [
	<?php
		$contador = 1;
		foreach ( $event->EventsPerformes AS $performer ) :
	?>
		{
		"@type": "{{ performer.Performers.type }}",
		"name": "<?php echo str_replace('"', "'", $performer->Performers->name) ?>"
	  } <?php echo $contador < $qtd ? ',' : ''  ?>
	<?php
		$contador++;
		endforeach ;
	?>
   ],
<?php endif ; /* if ( $qtd > 0 ) */ ?>
  "description": "<?php echo str_replace('"', "'", $event->description) ?>",
  "endDate": "{{ event.date_sales_end}}",
  "offers": {
	"@type": "Offer",
	"url": "{{ url() }}event/{{ event.id }}/{{ event.slug }}",
	"price": "30",
	"priceCurrency": "USD",
	"availability": "http://schema.org/InStock",
	"validFrom": "{{ event.date_sales_start }}"
  }
}
</script>




<?php  if ( $event->tag_metapixel AND strlen($event->tag_metapixel) > 5 ) : ?>
<!-- Meta Pixel Code -->
<script>

var eventiTitleh1 = document.querySelector('h1');
var eventiTitle = eventiTitleh1.textContent;
var userId = '<?php echo md5($_SERVER['REMOTE_ADDR'].$_SERVER['HTTP_USER_AGENT'])?>';

!function(f,b,e,v,n,t,s)
{if(f.fbq)return;n=f.fbq=function(){n.callMethod?
n.callMethod.apply(n,arguments):n.queue.push(arguments)};
if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
n.queue=[];t=b.createElement(e);t.async=!0;
t.src=v;s=b.getElementsByTagName(e)[0];
s.parentNode.insertBefore(t,s)}(window, document,'script',
'https://connect.facebook.net/en_US/fbevents.js');
fbq('init', '{{ event.tag_metapixel }}', {
        cookie: true,
        cookieDomain: '.lebillet.eu'
});
fbq('track', 'PageView', {
    external_id: userId
});
fbq('track', 'ViewContent', { external_id: userId, content_name: eventiTitle });
</script>
<noscript><img height="1" width="1" style="display:none"
src="https://www.facebook.com/tr?id={{ event.tag_metapixel }}&ev=PageView&noscript=1"
/></noscript>
<!-- End Meta Pixel Code -->
<?php endif ; ?>




<?php if ( $event->tag_googletag AND strlen($event->tag_googletag) > 5 ) : ?>
<!-- Google Tag Manager -->
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','{{ event.tag_googletag }}');</script>
<!-- End Google Tag Manager -->
<!-- Google Tag Manager (noscript) -->
<noscript><iframe src="https://www.googletagmanager.com/ns.html?id={{ event.tag_googletag }}"
height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<!-- End Google Tag Manager (noscript) -->
<?php endif ; ?>

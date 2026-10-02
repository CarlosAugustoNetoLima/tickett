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

			<div class="container containerAll" style="max-width: 100%; padding: 0px;">
				<div class="card cardNew">
					<div class="card-body">

						<div class="row">
							<div class="col-sm-5 card-img-event">
								<div class="image-container">
									<img class="image-session card-img-top"
										src="{{ url() }}img/shows/{{ event.EventsImages[0].name }}">
									<div class="dropdown-new">
										<button class="overlay-button" type="button" data-toggle="dropdown"
											aria-expanded="false">
											<svg xmlns="http://www.w3.org/2000/svg" class="button-link" width="25"
												height="25" viewBox="0 0 24 24" fill="none" stroke="#FFFFFF"
												stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
												<path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71">
												</path>
												<path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71">
												</path>
											</svg>
										</button>
										<div class="dropdown-menu dropdown-menu-new">
											<a class="dropdown-item-new" href="#"
												onclick="copiarHref('{{url()}}event/{{event.id}}')">
												<svg xmlns="http://www.w3.org/2000/svg" class="button-link" width="23"
													height="23" viewBox="0 0 24 24" fill="none" stroke="#FFFFFF"
													stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
													<g fill="none" fill-rule="evenodd">
														<path
															d="M18 14v5a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8c0-1.1.9-2 2-2h5M15 3h6v6M10 14L20.2 3.8" />
													</g>
												</svg>
												&nbsp;Copiar
											</a>
											<a class="dropdown-item-new"
												href="mailto:?subject=Lebillet EU Evento - {{event.name}}&body=Link para o evento: {{url()}}event/{{event.id}}">
												<svg xmlns="http://www.w3.org/2000/svg" class="button-link" width="23"
													height="23" viewBox="0 0 24 24" fill="none" stroke="#FFFFFF"
													stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
													<circle cx="12" cy="12" r="4"></circle>
													<path d="M16 8v5a3 3 0 0 0 6 0v-1a10 10 0 1 0-3.92 7.94"></path>
												</svg>
												&nbsp;Email
											</a>
											<a class="dropdown-item-new" href="#"
												onclick="shareFacebook('{{url()}}event/{{event.id}}')">
												<svg xmlns="http://www.w3.org/2000/svg" class="button-link" width="23"
													height="23" viewBox="0 0 24 24" fill="none" stroke="#FFFFFF"
													stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
													<path
														d="M18 2h-3a5 5 0 0 0-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 0 1 1-1h3z">
													</path>
												</svg>
												&nbsp;Facebook
											</a>
											<a class="dropdown-item-new"
												href="https://twitter.com/intent/tweet?text=Lebillet evento - {{event.name}}&url={{url()}}event/{{event.id}}"
												target="_blank">
												<svg xmlns="http://www.w3.org/2000/svg" class="button-link" width="23"
													height="23" viewBox="0 0 448 512" stroke="#FFFFFF">
													<path fill="#FFFFFF"
														d="M357.2 48L427.8 48 273.6 224.2 455 464 313 464 201.7 318.6 74.5 464 3.8 464 168.7 275.5-5.2 48 140.4 48 240.9 180.9 357.2 48zM332.4 421.8l39.1 0-252.4-333.8-42 0 255.3 333.8z" />
												</svg>
												&nbsp;Twitter
											</a>
										</div>
									</div>

								</div>

							</div>
							<div class="col-sm-4" style="font-weight: bold;">
								<h2 class="card-title">
									<div class="row" style="margin-left: 0px; font-weight: bold;">
										<div class="col-sm-8"
											style="text-transform: uppercase; padding-left: 0px; font-weight: bold;">
											<h1 style="font-size: 26px; font-weight: bold;">{{ event.name }}</h1>
											<h5 style="font-size: 14px; margin-top: 5px;">{{ event.ticket_sub_name }}
											</h5>
										</div>
										<div class="col-sm-4 btn-buy">
											<!-- <a href="#" data-toggle="modal" data-target="#exampleModalLong"
												class="btn btn-primary">
												<?php if ( isset($event->label_purchase) AND strlen($event->label_purchase) > 2 ) : ?>
												{{ t._(event.label_purchase) }}
												<?php else : ?>
												{{ t._('Buy Tickets') }}
												<?php endif ; ?>
											</a> -->
										</div>
									</div>
								</h2>
								<?php if ( $event->ticket_sub_name ) : ?>

								<?php endif ; ?>
								<p class="card-text">
								<div class="row" style="margin-left: 0px; font-weight: bold;">
									<div class="col-sm-8" style="padding-left: 0px; font-weight: bold;">
										<div class="data-group data-date" style="color: #FFFFFF;">
											<p class="data-text datetime" style="margin-bottom: 5px;">
												<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
													viewBox="0 0 24 24" fill="none" stroke="#FFFFFF" stroke-width="2"
													stroke-linecap="round" stroke-linejoin="round">
													<rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
													<line x1="16" y1="2" x2="16" y2="6"></line>
													<line x1="8" y1="2" x2="8" y2="6"></line>
													<line x1="3" y1="10" x2="21" y2="10"></line>
												</svg>&nbsp;&nbsp;
												<?php if ( isset($event->label_date) AND strlen($event->label_date) > 2 ) : ?>
												{{ event.label_date }}
												<?php else : ?>
												<?php echo $this->getDI()->getFormatdates()->format($event->date_opening, '01_de_Jan_-_Domingo_12:00h') ?>
												<?php endif ; ?>
											</p>
										</div>
										<div class="data-group data-location" style="color: #FFFFFF;">
											<p class="data-text location">
												<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
													viewBox="0 0 24 24" fill="none" stroke="#FFFFFF" stroke-width="2"
													stroke-linecap="round" stroke-linejoin="round">
													<path
														d="M12 22s-8-4.5-8-11.8A8 8 0 0 1 12 2a8 8 0 0 1 8 8.2c0 7.3-8 11.8-8 11.8z" />
													<circle cx="12" cy="10" r="3" />
												</svg>&nbsp;&nbsp;
												{{ event.Places.name }} - {{ event.Places.Cities.name }}, {{
												event.Places.Regions.acronym }}
											</p>
										</div>
									</div>
								</div>
								</p>

								<p class="card-text">
								<div class="content-text div-leia"
									style="height: 180px; overflow: hidden; text-overflow: ellipsis;">
									<div class="text-group">
										<p class="text">
											{{ event.description }}
											<?php if ( $event->parental_rating AND strlen($event->parental_rating) > 0 ) : ?>
										<p><b>{{ t._('parental_rating') }}: {{ event.parental_rating }}</b></p>
										<?php endif ; ?>
										</p>
									</div>
								</div>
								</p>

								<p class="card-text">
								<div class="row" style="margin-left: 0px;">
									<div class="col-sm-12 btnBuy text-center" style="padding-left: 0px;">
										<div class="fixed-tickets-button">
											<div class="col-sm-12 btn-buy">
												<a class="btn btn-primary-leia" onclick="expandirLeia()"
													style="font-size: small;">

												</a>
											</div>
										</div>
									</div>
								</div>
								</p>
							</div>
							<div class="col-sm-12 col-md-3 col-xl-3 btn-buy-new"
								style="display: flex; justify-content: center; align-items: center;">
								<a href="#" data-toggle="modal" data-target="#exampleModalLong"
									class="btn btn-primary btn-buy-style"
									style="height: auto; font-family: Oswald; font-weight: bold; border: 3px solid #FFFFFF !important; font-size: xx-large;">
									<?php if ( isset($event->label_purchase) AND strlen($event->label_purchase) > 2 ) : ?>
									{{ t._(event.label_purchase) }}
									<?php else : ?>
									{{ t._('Buy Tickets') }}
									<?php endif ; ?>
								</a>
							</div>
							<?php if(isset($event->video) && $event->video != ''){ ?>
							<div class="col-sm-12 rounded text-center mt-5">
								<div style="width: 100%;">
									<iframe width="50%" height="450" style="border: 2px solid #FFFFFF;"
										src="https://www.youtube.com/embed/{{event.video}}" title="YouTube video player"
										frameborder="0"
										allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
										allowfullscreen></iframe>
								</div>
							</div>
							<br><br>
							<?php } ?>

							<div class="col-md-8">
								<div class="row text-direction" style="margin-left: 0px; font-weight: bold;">
									<div class="col-md-12">
										<p class="card-text">
										<h3 class="title">{{ t._('Directions') }}</h3>
										<div class="location-widget">
											<div class="location-widget-inner">
												<div class="location-text">
													<div class="side-text">
														<h5 class="title">{{ event.Places.name }}</h5>
														<p class="text">{{ event.Places.location }} - {{
															event.Places.Cities.name }}, {{
															event.Places.Regions.acronym }}</p>
													</div>
													<div class="side-button">
														<a href="#" class="btn btn-outline-primary btn-sm"
															data-toggle="modal" data-target="#mapa"
															style="color: #FFFFFF; border: 1px solid #FFFFFF;">{{
															t._('How to get there') }}</a>
													</div>
												</div>
											</div>
										</div>
										</p>
									</div>

									<?php if ( $event->map AND strlen($event->map) > 5 ) : ?>
									<div class="col-md-12">
										<p class="card-text">
										<h3 class="title">{{ t._('Event map') }}</h3>
										<div class="content-text">
											<div class="text-group">
												<p class="text">
													<a href="{{ url() }}img/shows/{{ event.map }}" target="_blank"
														style="cursor: zoom-in;">
														<img class="img-fluid"
															src="{{ url() }}img/shows/{{ event.map }}">
													</a>
												</p>
											</div>
										</div>
										</p>
									</div>

									<hr>
									<?php endif ; ?>

									<?php if ( $event->instructions AND strlen($event->instructions) > 5 ) : ?>
									<div class="col-md-12">
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
											</div>
										</div>
										</p>
									</div>
									<hr>
									<?php endif ; ?>

									<div class="col-md-12">
										<?php if(isset($event->producer_description)){ ?>
										<p><strong>
												<?php echo isset($event->producer_description) ? $event->producer_description : "" ; ?>
											</strong>
										</p>
										<?php } else { ?>
										<p><strong>{{ t._('production_realization') }} -
												<?php echo isset($event->Organizers->fantasy_name) ? $event->Organizers->fantasy_name : $event->Organizers->name ; ?>
											</strong>
										</p>
										<?php } ?>
										<?php if(isset($event->Organizers->logotipo)){ ?>
										<p>
											<img src="<?php echo $this->di->get('urlAdmin'); ?>documents/{{event.Organizers.logotipo}}"
												style="width: 40%;">
										</p>
										<?php } ?>

										<p class="card-text">
											{{ t._('Agree to terms and conditions') }}
											<br>
											<a target="_blank" href="{{ url() }}company/terms"
												style="color: #9bbaff;">{{
												t._('Terms and Conditions') }}</a>
										</p>
									</div>
								</div>
							</div>

							<div class="col-md-4">

							</div>
						</div>
					</div>
				</div>
			</div>

		</div>
	</article>

	<!-- Modal checkout -->
<div class="modal fade" id="exampleModalLong" tabindex="-1" role="dialog" aria-labelledby="exampleModalLongTitle"
		aria-hidden="true" style="background: #000000bd; backdrop-filter: blur(3px); -webkit-backdrop-filter: blur(3px);">
		<div class="modal-dialog modal-dialog-centered modal-lg modal-prevenda" role="document" style="height: 70% !important;">
			<div class="modal-content modal-prevenda-content" style="border-radius: 1em; padding: 0px !important;">
				<?php 
				if(!isset($_GET['banda'])){ ?>
				<div class="modal-header"
					style="background: #092653; border-radius: 10px 10px 0px 0px; text-transform: uppercase; font-weight: bold; font-family: Oswald;">
					<h5 class="modal-title w-100" style="color: #FFFFFF; opacity: 1; font-family: sans-serif; font-weight: bold;">{{event.name}}</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close"
						style="color: #FFFFFF; opacity: .8;">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<?php } ?>
				<div class="modal-body" style="padding: 0%;">
					<?php 

					$la = '';
					if(isset($_GET['l'])){
						$la = '?l=' . $_GET['l'];
					} else if(isset($language)){
						$la = '?l=' . $language;
					}

					$ref = '';
					if(isset($_GET['ref'])){
						if($la != ''){
							$ref = '&ref=' . $_GET['ref'];
						}else{
							$ref = '?ref=' . $_GET['ref'];
						}
					}

					$banda = '';
					if(isset($_GET['banda']) && $_GET['banda'] == 'calema'){
						if($la != '' || $ref != ''){
							$banda = "&banda=calema";
						}else{
							$banda = "banda=calema";
						}
					}

					?>
					<iframe src="<?php echo  $this->di->get('urlFastCheckout') ?>{{ event.id }}{{la}}{{ref}}{{banda}}"
						class="tickets-iframe iframe-new" id="Tickets_Embedded_Checkout_Site" height="100%" width="100%"
						style="border-width: 0px; border-radius: 0px 0px 20px 20px !important;"> </iframe>
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
		.dropdown-menu-new {
			position: absolute;
			will-change: transform;
			top: 79% !important;
			left: 85% !important;
			/* right: 45px; */
			margin-right: 15px;
			transform: translate3d(0px, 10px, 0px) !important;
			background-color: #212529f7;
			border-radius: 0px 50px 50px 50px;
		}

		.modal-content {
			flex-direction: column;
			width: 100%;
			pointer-events: auto;
			background-color: #ffffff00;
			background-clip: padding-box;
			border: 1px solid rgba(0, 0, 0, .0);
			border-radius: 20px;
			outline: 0;
			border-radius: 16px;
			background: #04153b;
			box-shadow: 0 0 40px rgba(0, 0, 0, 0.5);
		}

		.dropdown-new {
			position: static;
		}

		.image-container {
			position: relative;
			/* Permite posicionar elementos absolutos dentro dele */
			display: inline-block;
			/* Garante que o contêiner se ajuste ao tamanho da imagem */
		}

		.image-container img {
			display: block;
			/* Remove o espaço extra abaixo da imagem */
			max-width: 100%;
			/* Garante que a imagem se ajuste ao contêiner */
			height: auto;
		}

		.overlay-button {
			position: absolute;
			/* Posiciona o botão sobre a imagem */
			top: 80%;
			/* Move o botão para o meio da altura */
			left: 90%;
			/* Move o botão para o meio da largura */
			transform: translate(-50%, -90%);
			/*Centraliza o botão com precisão */
			background-color: #212529d6;
			/* Cor de fundo do botão (exemplo) */
			color: white;
			/* Cor do texto do botão (exemplo) */
			padding: 10px 20px;
			/* Espaçamento interno do botão */
			border: none;
			/* Remove a borda padrão */
			cursor: pointer;
			/* Indica que é um elemento clicável */
			z-index: 1;
			/* Garante que o botão fique acima da imagem */
			border-radius: 50px;
		}

		.dropdown-item-new {
			display: block;
			width: 100%;
			padding: .40rem 1.5rem;
			clear: both;
			font-weight: 400;
			color: #FFFFFF;
			text-align: inherit;
			white-space: nowrap;
			background-color: transparent;
			border: 0;
		}

		.dropdown-item-new:hover {
			color: #f6f6f6;
			text-decoration: none;
		}

		.overlay-button:focus {
			outline: 0px auto -webkit-focus-ring-color;
		}

		.fa-instagram-new {
			font-size: 23px;
		}

		.modal-dialog {
			width: 1200%;
			height: 70%;
		}

		.modal-content {
			height: 100%;
		}

		.modal-open .modal {
			overflow-x: initial;
			overflow-y: initial;
		}

		.modal {
			position: fixed;
			top: 0;
			/* left: 0; */
			/* right: 50px; */
			z-index: 1050;
			/* display: flex; */
			/* justify-content: flex-end; */
			width: 100%;
			height: 100%;
			/* overflow: hidden; */
			/* outline: 0; */
		}

		.modal-backdrop {
			position: fixed;
			top: 0;
			left: 0;
			z-index: 1040;
			width: 100vw;
			height: 100vh;
			background-color: #00000046;
		}

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
			box-shadow: 0 18px 14px -4px rgba(255, 255, 255, 0.3);
		}

		.show-header {
			width: 70%;
			margin: auto;
			display: block;
		}

		.cardNew {
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

		.card {
			color: #FFFFFF !important;
			background-image: url('{{ url() }}img/background.png') !important;
			background-position: top !important;
			background-repeat: no-repeat !important;
			background-size: cover !important;
		}

		.btn-buy {
			padding-left: 0px;
			text-align: left;
		}

		.btn-primary {
			color: #fff;
			padding: 20px;
			padding-left: 40px;
			padding-right: 40px;
			border-radius: 50px;
			font-weight: bold;
			text-transform: uppercase;
			background-color: transparent;
			border-color: #FFFFFF;
		}

		.btn-primary-leia {
			width: 100%;
			cursor: pointer;
			color: #fff;
			padding-top: 10px;
			padding-bottom: 10px;
			padding-left: 40px;
			padding-right: 40px;
			border-radius: 40px;
			font-weight: bold;
			text-transform: uppercase;
			background-color: transparent;
			border-color: #FFFFFF;
		}

		.card-img-event {
			display: flex;
			justify-content: right;
		}

		.card-img-top {
			border-radius: 50px;
			width: 550px;
			height: 370px;
		}

		.row {
			margin-right: 0px;
			margin-left: 10px;
		}

		iframe {
			border-radius: 20px 20px 20px 20px !important;
		}

		@media only screen and (max-width: 1366px) {
			.card-img-top {
				width: 100%;
				height: 380px;
			}

			iframe {
				width: 100% !important;
			}

			.btn-buy {
				text-align: left;
			}

			.btn-primary-leia {
				width: 100%;
				padding-left: 0px;
				padding-right: 0px;
			}

			.card-img-event {
				display: flex;
				justify-content: left;
			}

		}

		@media only screen and (max-width: 600px) {

			.button-link,
			.fa-instagram-new {
				width: 20px;
			}

			.fa-instagram-new {
				font-size: 20px;
			}

			.overlay-button {
				top: 93%;
				left: 90%;
				transform: translate(-50%, -90%);
				padding: 10px 20px;
			}

			.dropdown-menu-new {
				top: 90% !important;
				left: 55% !important;
				border-radius: 50px 0px 50px 50px !important;
			}

			iframe {
				width: 100% !important;
				height: auto !important;
			}

			.iframe-new {
				width: 100% !important;
				height: 100% !important;
			}

			.card-img-event {
				display: flex;
				justify-content: left;
			}

			.card-img-top {
				width: 100%;
				height: auto;
			}

			.btn-buy {
				text-align: left;
			}

			.modal-content {
				height: 100%;
			}

			.containerAll {
				padding-right: 0px;
				padding-left: 0px;
			}

			.modal-dialog {
				max-width: 100% !important;
				margin: 1.75rem auto;
			}

			.modal-dialog {
				width: 100%;
				height: 100%;
			}

			.modal-open .modal {
				overflow-x: initial;
				overflow-y: initial;
			}

			.modal {
				height: 100%;
			}

			h1 {
				margin-top: 30px;
			}

			.col-sm-4 {
				text-align: center;
			}

			.data-text {
				font-size: 16px !important;
			}

			.btn-buy-style {
				height: auto;
				font-family: Oswald;
				font-weight: bold;
				border: 3px solid #FFFFFF !important;
				font-size: large !important;
			}

			.btnBuy {
				padding-right: 0px !important;
			}

			.btn-buy {
				padding-right: 0px !important;
			}

			.text-direction {
				text-align: center !important;
			}

			p {
				font-size: 16px !important;
			}

			.div-leia {
				text-align: justify !important;
			}

			.title {
				font-size: larger !important;
				font-weight: bold;
			}
		}

		@media only screen and (max-width: 932px) {
			.modal-dialog {
				max-width: 100% !important;
				margin: 1.75rem auto;
			}

			.modal-dialog {
				width: 100%;
				height: 100%;
			}

			.modal-open .modal {
				overflow-x: initial;
				overflow-y: initial;
			}

			.modal {
				height: 100%;
			}
		}


		.modal-lg,
		.modal-xl {
			max-width: 80%;
		}

		@media (min-width: 992px) {

			.modal-lg,
			.modal-xl {
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
<script
	type="text/javascript">function ticketsCheckout(id_event) { window.Tickets.checkoutEmbedded({ eventId: id_event, domain: '<?php echo  $this->di->get('urlFastCheckout') ?>', language: '{{ language }}', sid: '{{ sid }}', ref: '{{ ref }}' }); }</script>


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
		src="https://www.facebook.com/tr?id={{ event.tag_metapixel }}&ev=PageView&noscript=1" /></noscript>
<!-- End Meta Pixel Code -->
<?php endif ; ?>




<?php if ( $event->tag_googletag AND strlen($event->tag_googletag) > 5 ) : ?>
<!-- Google Tag Manager -->
<script>(function (w, d, s, l, i) {
		w[l] = w[l] || []; w[l].push({
			'gtm.start':
				new Date().getTime(), event: 'gtm.js'
		}); var f = d.getElementsByTagName(s)[0],
			j = d.createElement(s), dl = l != 'dataLayer' ? '&l=' + l : ''; j.async = true; j.src =
				'https://www.googletagmanager.com/gtm.js?id=' + i + dl; f.parentNode.insertBefore(j, f);
	})(window, document, 'script', 'dataLayer', '{{ event.tag_googletag }}');</script>
<!-- End Google Tag Manager -->
<!-- Google Tag Manager (noscript) -->
<noscript><iframe src="https://www.googletagmanager.com/ns.html?id={{ event.tag_googletag }}" height="0" width="0"
		style="display:none;visibility:hidden"></iframe></noscript>
<!-- End Google Tag Manager (noscript) -->
<?php endif ; ?>

<script>

	window.onload = function (e) {
		$('.btn-primary-leia').html('{{ t._("Leia Mais") }} <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M6 9l6 6 6-6"/></svg>');
	}
</script>

<script>
	function expandirLeia() {
		if ($(".div-leia").height() == 180) {
			$(".div-leia").css("height", "auto");
			var h = $(".div-leia").height();
			$(".div-leia").css("height", "180px");
			$(".div-leia").animate({ height: h }, 1000, function () {
			});

			$('.btn-primary-leia').html('{{ t._("Leia Mais") }} <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 15l-6-6-6 6"/></svg>');
		} else {
			$(".div-leia").css("height", "auto");
			var h = $(".div-leia").height();
			$(".div-leia").animate({ height: '180px' }, 1000, function () {
			});

			$('.btn-primary-leia').html('{{ t._("Leia Mais") }} <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M6 9l6 6 6-6"/></svg>');
		}

	}



	function twitterShare(text, url) {
		const twitterUrl = `https://twitter.com/intent/tweet?text=${text}&url=${url}`;

		// Open a new window for the tweet intent
		window.open(twitterUrl, '_blank', 'width=500,height=300');
	}
</script>

<script>
	const shareButton = document.getElementById('shareButton');

	if (navigator.share) {
		shareButton.addEventListener('click', async () => {
			try {
				await navigator.share({
					title: document.title,
					text: 'Check out this awesome page!',
					url: window.location.href
				});
			} catch (error) {
				console.error('Error sharing:', error);
			}
		});
	} else {
		shareButton.style.display = 'none'; // Hide button if API is not supported
		shareResult.textContent = 'Web Share API not supported in this browser.';
	}

</script>

<script>
	function copiarHref(link) {

		navigator.clipboard.writeText(window.location.href).then(() => {
			alert('URL copiado para a área de transferência!');
		}).catch(err => {
			console.error('Erro ao copiar: ', err);
			alert('Falha ao copiar URL.');
		});
	}

	function shareFacebook(url) {

		var w = 630;
		var h = 360;

		var left = screen.width / 2 - 630 / 2;
		var top = screen.height / 2 - 360 / 2;

		window.open('http://www.facebook.com/sharer.php?u=' + url);
	}
</script>

<?php 
	if(isset($_GET['banda']) && $_GET['banda'] == 'calema'){ ?>

<style>
	html body main {
		background-color: #000000 !important;
		padding: 0px !important;
	}

	.banner-session {
		background-color: #000000 !important;
	}

	.card {
		background-color: #000000 !important;
		background-image: none !important;
	}

	.footer {
		display: none !important;
	}

	html {
		background-color: #000000 !important;
	}

	.map-container {
		background-color: #000000;
	}
</style>
<?php } ?>
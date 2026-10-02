<?php
	$ref = isset($_REQUEST['ref']) ? '?ref=' . $_REQUEST['ref'] : null;
?>

<?php
$number_a = (int)rand(1, 5);
$number_b = (int)rand(1, 5);
$total = ($number_a + $number_b);
$crypt = base64_encode($this->crypt->encryptBase64((string)$total));
?>

<main>
	{{ content() }}

	<?php if ( isset($events_featured_premium) AND count($events_featured_premium) > 0 ) : ?>
	{{ partial('newLayout/carousel_shows') }}
	<?php endif; ?>

	<?php if ( isset($events_featured) AND count($events_featured) > 0 ) : ?>
	{{ partial('newLayout/featured_events') }}
	<?php endif; ?>

	{{ partial('newLayout/benefits') }}

	{{ partial('newLayout/next_shows_country') }}

	{{ partial('newLayout/next_shows') }}

	<?php if ( isset($primaries) AND count($primaries) > 0 ) : ?>
	{{ partial('newLayout/categories') }}
	<?php endif; ?>

	{# partial('newLayout/download_app') #}

	<?php if ( COMPANY == 'lebillet_pt' ) : ?>

	<?php endif ; ?>

	<?php
			/*  LISTA DE DDI - PAISES */
			/* https://pt.wikipedia.org/wiki/Compara%C3%A7%C3%A3o_entre_c%C3%B3digos_de_pa%C3%ADses_COI,_FIFA,_e_ISO_3166 */
			$array_countries = array(
				'tiktx' => [
					'USA' => '+1',
					'CAN' => '+1',
					'BRA' => '+55',
				],
				'lebillet' => [
					'BRA' => '+55',
					'ARG' => '+54',
					'PAR' => '+595',
					'URU' => '+598',
					'EUA' => '+1',
				],
				'lebillet_pt' => [
					'POR' => '+351',
					'BRA' => '+55',
					'ITA' => '+39',
					'ESP' => '+34',
					'SUI' => '+41',
					'FRA' => '+33',
					'IRL' => '+353',
					'GBR' => '+44',
					'BEL' => '+32',
					'GER' => '+49',
					'NED' => '+31',
					'ANG' => '+244',
					'POL' => '+48',
					'USA' => '+1',
					'LUX' => '+352',
					'ROM' => '+40',
					'AND' => '+376',
					'SUE' => '+46',
					'NOR' => '+47',
					'DIN' => '+45',
					'FIN' => '+358',
					'ISL' => '+354',
					'EST' => '+372',

				]
			);
			?>


	<!-- Demo styles -->
	<style>
		html body {
			font-family: Arial, Helvetica, sans-serif;
			;
		}

		.swiper {
			width: 100%;
			height: 100%;
		}

		.swiper-slide {
			text-align: center;
			/*display: flex;*/
			justify-content: center;
			align-items: top;
			background: #f6f6f6;
		}

		.carousel-shows {
			margin-bottom: 0px;
			height: 100%;
		}

		.text-hors {
			text-align: right;
		}

		.swiper-slide img {
			display: block;
			width: 100%;
			height: 100%;
			object-fit: cover;
		}

		.card-events {
			margin: 1%;
		}

		.textSearch {
			text-align: center;
		}

		.div-events-flag {
			width: 100%;
			display: flex;
			justify-content: left;
			margin-left: 50px;
		}

		@media only screen and (max-width: 600px) {

			.div-events-flag {
				width: 100%;
				display: flex;
				justify-content: left;
				margin-left: 0px;
			}

			.carousel-shows {
				margin-bottom: 0px;
				height: 100%;
			}

			.menu-language {
				width: 100% !important;
			}

			.swiper-banner {}

			.swiper {
				width: 100%;
				height: 100%;
				margin-top: 20px;
			}

			.swiper-slide img {
				display: block;
				width: 100%;
				height: 70%;
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

			.textSearch {
				text-align: left;
			}

			.logo{
				height: 50px !important;
				max-height: 50px !important;
				width: 180% !important;
			}
		}

		@media (min-width: 992px) {
			.swiper {
				width: 95%;
				height: 100%;
			}

			.carousel-shows {
				margin-bottom: 0px;
				height: 100%;
				margin-top: -1rem;
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

		.swiper-slide img {
			display: inline;
			width: 100%;
			height: 100%;
			object-fit: cover;
		}

		.swiper-slide {
			background-color: transparent !important;
		}

		.swiper-button-next,
		.swiper-button-prev {
			background: #FFF;
			padding: 30px;
			border-radius: 50px;
			color: #000000 !important;
		}
	</style>

	<script src="https://www.google.com/recaptcha/api.js?hl=en"></script>
	<div class="modal fade" id="vendaIngressoModal" tabindex="-1" aria-labelledby="exampleModalLabel"
		aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-body text-center" style="padding: 0px;">
					<img src="{{ url() }}{{ config.company.logos }}logo_new_f.gif" width="100%"
						style="background-color: #06445a;">
					<h2 style="color: #07142d;">Venda seu evento!</h2>
					<p style="color: #6f7287;">Utilize o formulário abaixo para enviar um e-mail</p>
					<div class="alert alert-danger alert-dismissible collapse text-left alertDanger" role="alert"></div>
					<div class="alert alert-success alert-dismissible collapse text-left alertSuccess" role="alert">
					</div>
					<form method="POST" id="form_event">
						<div class="form-row" style="padding: 1rem;">
							<div class="form-group col-md-6">
								<input type="text" class="form-control" name="name" id="name_event" required="required"
									placeholder="Nome"
									style="height: 100%; display: flex; border-radius: 8px; margin-top: 10px;  box-shadow: 3px 3px 5px rgba(0, 0, 0, 0.2);">
							</div>
							<div class="form-group col-md-6">
								<input type="text" class="form-control" name="email" id="email_event"
									required="required" placeholder="Email"
									style="height: 100%; display: flex; border-radius: 8px; margin-top: 10px; box-shadow: 3px 3px 5px rgba(0, 0, 0, 0.2);">
							</div>
							<div class="form-group col-md-12">
								<input type="text" class="form-control" name="subject" id="subject_event"
									required="required" placeholder="Assunto"
									style="height: 100%; display: flex; border-radius: 8px; margin-top: 10px; box-shadow: 3px 3px 5px rgba(0, 0, 0, 0.2);">
							</div>
							<div class="form-group col-md-12">
								<input type="text" class="form-control" name="phone" id="phone_event"
									required="required" placeholder="Telefone"
									style="height: 100%; display: flex; border-radius: 8px; margin-top: 10px; box-shadow: 3px 3px 5px rgba(0, 0, 0, 0.2);">
							</div>
							<div class="form-group col-md-12">
								<textarea placeholder="Mensagem" name="message" id="message_event" required="required"
									class="form-control" rows="5"
									style="height: 100%; display: flex; border-radius: 8px; margin-top: 10px; box-shadow: 3px 3px 5px rgba(0, 0, 0, 0.2);"></textarea>
							</div>
							<div class="form-group col-md-12" style="display: flex;justify-content: center;">
								<div class="g-recaptcha" data-sitekey="<?php echo $recaptcha; ?>"></div>
							</div>
						</div>
						<button type="button" class="btn btn-primary btn-block btnEnviar" style="background-color: #06445a; border-color: #06445a;"
								onclick="sendEventRegister()">{{ t._('ENVIAR MENSAGEM') }}</button>
					</form>
				</div>
			</div>
		</div>
	</div>


	<script>
		const validateEmail = (email) => {
			return email.match(
				/^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
			);
		};

		function onSubmit(token) {
			sendEventRegister();
		}

		function sendEventRegister() {
			$('.btnEnviar').prop("disabled", true);
			$('.btnEnviar').html(
				`<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Enviando...`
			);

			$('.alert').hide();
			var name = $('#name_event').val();
			var email = $('#email_event').val();
			var subject = $('#subject_event').val();
			var message = $('#message_event').val();
			var phone = $('#phone_event').val();
			if (!validateEmail(email)) {
				$('.alertDanger').text('Favor preencher o email corretamente');
				$('.alertDanger').show();
				$('.btnEnviar').prop("disabled", false);
				$('.btnEnviar').text('ENVIAR MENSAGEM');
				return;
			}

			if (name == '' || email == '' || subject == '' || message == '' || phone == '') {
				$('.alertDanger').text('Favor preencher todos os campos');
				$('.alertDanger').show();
				$('.btnEnviar').prop("disabled", false);
				$('.btnEnviar').text('ENVIAR MENSAGEM');
				return;
			}

			$.post("{{url()}}index/sendMailEvent", $('#form_event').serialize())
				.done(function (data) {
					data = JSON.parse(data);
					if (data.success) {
						$('#name_event').val('');
						$('#email_event').val('');
						$('#subject_event').val('');
						$('#message_event').val('');
						$('#phone_event').val('');
						$('.alertSuccess').text(data.msg);
						$('.alertSuccess').show();
					} else {
						$('.alertDanger').text(data.msg);
						$('.alertDanger').show();
					}

					$('.btnEnviar').prop("disabled", false);
					$('.btnEnviar').text('ENVIAR MENSAGEM');
				});
		}
	</script>

	<div class="modal fade" id="cadastrarModal" tabindex="-1" aria-labelledby="cadastrarLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-body text-center">
					<h2 style="color: #096f94;" class="text-center">Faça seu cadastro</h2>
					<form method="POST" action="{{url()}}account/register">
						<input type="hidden" name="crypt" value="{{ crypt }}">
						<div class="form-group">
							<input type="text" class="form-control" id="name-create"
								placeholder="{{ t._('Full Name') }}" name="name"
								style="height: 100%; display: flex; border-radius: 8px; margin-top: 10px;  box-shadow: 3px 3px 5px rgba(0, 0, 0, 0.2);">
						</div>


						<?php if ( null !== COMPANY AND COMPANY == 'lebillet'  ) : // CPF obrigatório no LeBillet //  ?>
						<div class="form-group">
							<input type="text" class="form-control" id="cpf-create" name="cpf"
								placeholder="{{ t._('CPF') }}"
								style="height: 100%; display: flex; border-radius: 8px; margin-top: 10px;  box-shadow: 3px 3px 5px rgba(0, 0, 0, 0.2);">
						</div>
						<?php endif ; ?>

						<div class="form-group row ">

							<div class="col-sm-3 ">
								<select class="form-control custom-select" aria-placeholder="{{ t._('Code') }}"
									onchange="selectCountryMobile(this);" id="selectMobileNumber"
									style="height: 80%; display: flex; border-radius: 8px; margin-top: 10px; box-shadow: 3px 3px 5px rgba(0, 0, 0, 0.2); background-color: #f0f0f0;">
									<option value=" ">{{ t._('Code') }}</option>
									<?php foreach ( $array_countries[COMPANY]  AS $country => $ddi ) : ?>
									<option value="{{ ddi }}">{{ country }} {{ ddi }}</option>
									<?php endforeach ; ?>
								</select>
							</div>

							<div class="col-sm-9 mt-3 mt-sm-0">
								<div class="input-group flex-nowrap">
									<div class="input-group-prepend">
										<span class="input-group-text span-ddi-mobile"
											style="height: 81%; display: flex; border-radius: 8px 0px 0px 8px; margin-top: 10px; box-shadow: 3px 3px 5px rgba(0, 0, 0, 0.2); border: 0px solid #ced4da;">
											&nbsp; &nbsp; </span>
										<input type="hidden" class="input-ddi-mobile" readonly name="mobile_country"
											style="height: 100%; display: flex; border-radius: 8px; margin-top: 10px;  box-shadow: 3px 3px 5px rgba(0, 0, 0, 0.2);"></input>
									</div>

									<input type="tel" class="form-control whatsapp_number_BR" id="register_cell_number"
										name="cell_number" placeholder="{{ t._('Mobile Number') }}"
										style="height: 100%; display: flex; border-radius: 0px 8px 8px 0px; margin-top: 10px;  box-shadow: 3px 3px 5px rgba(0, 0, 0, 0.2);">

								</div>
							</div>
						</div>


						<div class="form-group">
							<input type="email" class="form-control" id="email-create"
								placeholder="{{ t._('enter_email') }}" name="email"
								style="height: 100%; display: flex; border-radius: 8px; margin-top: 10px;  box-shadow: 3px 3px 5px rgba(0, 0, 0, 0.2);">
						</div>
						<div class="form-group">
							<input type="password" class="form-control" id="password-create"
								placeholder="{{ t._('password') }}" name="password"
								style="height: 100%; display: flex; border-radius: 8px; margin-top: 10px;  box-shadow: 3px 3px 5px rgba(0, 0, 0, 0.2);">
						</div>
						{# <div class="form-group">
							<label for="captcha_sign">{{ t._('Answer') }}: {{ number_a }} + {{ number_b}} = </label>
							<input type="text" class="form-control" id="captcha_sign" name="captcha"
								style="height: 100%; display: flex; border-radius: 8px; margin-top: 10px;  box-shadow: 3px 3px 5px rgba(0, 0, 0, 0.2);">
						</div> #}
						<button type="submit" class="btn btn-primary btn-sm"
							style=" box-shadow: 3px 3px 5px rgba(0, 0, 0, 0.2); border-radius: 8px;">{{ t._('sign_up')
							}}</button>
					</form>
				</div>
			</div>
		</div>
	</div>

</main>
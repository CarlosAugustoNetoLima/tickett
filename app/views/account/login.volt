
<?php
$number_a = (int)rand(1, 5);
$number_b = (int)rand(1, 5);
$total = ($number_a + $number_b);
$crypt = base64_encode($this->crypt->encryptBase64((string)$total));
?>

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
					'AND' => '+376',
					'ANG' => '+244',
					'ARG' => '+54',
					'AUS' => '+43',
					'BEL' => '+32',
					'CHI' => '+56',
					'COL' => '+57',
					'DIN' => '+45',
					'ENG' => '+44',
					'EQU' => '+593',
					'ESP' => '+34',
					'EST' => '+372',
					'FIN' => '+358',
					'FRA' => '+33',					
					'GER' => '+49',
					'IRL' => '+353',
					'ISL' => '+354',
					'ITA' => '+39',
					'LUX' => '+352',
					'NED' => '+31',
					'NOR' => '+47',
					'PAR' => '+595',
					'PER' => '+51',
					'POL' => '+48',
					'ROM' => '+40',
					'SUE' => '+46',					
					'SUI' => '+41',
					'URU' => '+598',
					'USA' => '+1',
					'RTC' => '+420'
				]
			);
			?>



<main>

		<div class="container mt-3">

			<div class="content-text  mt-3">
				<div class="text-group">



					<!-- MAIN CONTENT SECTION -->
					<section class="mainContent clearfix genricContent  mt-3">
						<div class="container">

						<br>
						<br>

							{{ content() }}
							{{ flashSession.output() }}

							<div class="row  mt-3">


								<div class="col-md-6 col-sm-12">


									<h3 class="modal-title">{{ t._('log_in') }}</h3>


									<form action="{{ url() }}account/login" method="POST" role="form">
										<div class="form-group">
											<label for="email_login">{{ t._('enter_email') }}</label>
											<input type="email" class="form-control" id="email_login" name="email">
										</div>
										<div class="form-group">
											<label for="password_login">{{ t._('password') }}</label>
											<input type="password" class="form-control" id="password_login" name="password">
										</div>
										<button type="submit" class="btn btn-primary btn-block">{{ t._('log_in') }}</button>
										<a data-toggle="modal" href='#forgot-password'>
											<button type="button" class="btn btn-link btn-block" data-dismiss="modal">{{ t._('forgot_password') }}</button>
										</a>
									</form>

									<br>
									<br>
								</div>




								<div class="col-md-6 col-sm-12">

									<h3 class="modal-title">{{ t._('create_an_account') }}</h3>

								{# 	<p>
										<br>
										{{ t._('Your account will be created at the time of purchase') }}
									</p> #}

									<form action="{{ url() }}account/register" method="POST" role="form">
										<input type="hidden" name="crypt" value="{{ crypt }}">
										<div class="form-group">
											<label for="name-create">{{ t._('Full Name') }}</label>
											<input type="text" class="form-control" id="name-create" name="name">
										</div>


										<?php if ( null !== COMPANY AND COMPANY == 'lebillet'  ) : // CPF obrigatório no LeBillet //  ?>
											<div class="form-group">
												<label for="cpf-create">{{ t._('CPF') }}</label>
												<input type="text" class="form-control" id="cpf-create" name="cpf">
											</div>
										<?php endif ; ?>

										<div class="form-group row ">

											<div class="col-sm-3 ">
												<label for="selectMobileNumber">{{ t._('Code') }}</label>
												<select class="form-control custom-select" onchange="selectCountryMobile(this);" id="selectMobileNumber" style="
																													height: auto;
																													border-radius: 0;
																													font-size: 14px;
																													padding: 13px 20px;
																													line-height: 24px;
																													border: 1px solid #f0f0f0;
																													background-color: #f0f0f0;
																													font-weight: 300;
																												">
													<option value=" ">{{ t._('Code') }}</option>
													<?php foreach ( $array_countries[COMPANY]  AS $country => $ddi ) : ?>
														<option value="{{ ddi }}">{{ country }} {{ ddi }}</option>
													<?php endforeach ; ?>
												</select>
											</div>

											<div class="col-sm-9 mt-3 mt-sm-0">
												<label for="register_cell_number">{{ t._('Mobile Number') }}</label>
												<div class="input-group flex-nowrap">
													<div class="input-group-prepend">
														<span class="input-group-text span-ddi-mobile" > &nbsp; &nbsp; </span>
														<input type="hidden" class="input-ddi-mobile" readonly name="mobile_country"></input>
													</div>

													<input type="tel" class="form-control whatsapp_number_BR" id="register_cell_number" name="cell_number" placeholder="{{ t._('Mobile Number') }}">

												</div>
											</div>
										</div>


										<div class="form-group">
											<label for="email-create">{{ t._('enter_email') }}</label>
											<input type="email" class="form-control" id="email-create" name="email">
										</div>
										<div class="form-group">
											<label for="password-create">{{ t._('password') }}</label>
											<input type="password" class="form-control" id="password-create" name="password">
										</div>
										{# <div class="form-group">
											<label for="captcha_sign">{{ t._('Answer') }}: {{ number_a }} + {{ number_b}} = </label>
											<input type="text" class="form-control" id="captcha_sign" name="captcha">
										</div> #}
										<button type="submit" class="btn btn-primary btn-block">{{ t._('sign_up') }}</button>


									</form>

								</div>



								<!-- PASSWORD MODAL -->
								<div class="modal fade" id="forgot-password" tabindex="-1" role="dialog">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-header justify-content-center">
												<h3 class="modal-title">{{ t._('remember_password') }}</h3>
												<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
											</div>
											<div class="modal-body">
												<form action="{{ url() }}account/remember_password" method="POST" role="form">
													<input type="hidden" name="crypt" value="{{ crypt }}">
													<div class="form-group">
														<label for="email-remember-password">{{ t._('enter_email') }}</label>
														<input type="email" class="form-control" id="email-remember-password" name="email">
													</div>
													<div class="form-group">
														<label for="captcha_password">{{ t._('Answer') }}: {{ number_a }} + {{ number_b}} = </label>
														<input type="text" class="form-control" id="captcha_password" name="captcha">
													</div>
													<button type="submit" class="btn btn-primary btn-block">{{ t._('remember') }}</button>
												</form>
											</div>
										</div>
									</div>
								</div>


							</div>
						</div>

					</section>

					<br>
					<br>
					<br>
					<br>
					<br>


			</div>
		</div>

	</div>

</main>
<section class="page-title">
    <div class="container">
        <h1 class="title">{{ t._('profile') }}</h1>
    </div>
</section>

{{ partial('account/menu') }}

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
				],
				'lebillet_pt' => [
					'POR' => '351',
					'BRA' => '55',
					'ITA' => '39',
					'ESP' => '34',
					'SUI' => '41',
					'FRA' => '33',
					'IRL' => '353',
					'GBR' => '44',
					'BEL' => '32',
					'GER' => '49',
					'NED' => '31',
					'ANG' => '244',
					'POL' => '48',
					'USA' => '1',
					'LUX' => '352',
					'ROM' => '40',
					'AND' => '376',
					'SUE' => '46',
					'NOR' => '47',
					'DIN' => '45',
					'FIN' => '358',
					'ISL' => '354',
					'EST' => '372',

				]
			);
			?>




<section class="page-profile">
    <div class="container">


                        {{ content() }}
                        {{ flashSession.output() }}

        <div class="page-profile-inner internal-page">
            <div class="internal-page-title">
                <h2 class="title">{{ t._('profile') }}</h2>
            </div>
            <div class="profile-update-area">
                <div class="profile-update-form">
                    <form class="form form-profile-update" method="POST" action="{{ url() }}account/profile">
                        <input type="hidden" name="save_profile" value="on">
                        <div class="form-group">
                            <label for="name">{{ t._('Full Name') }}</label>
                            <input type="text" name="name" class="form-control" id="name" placeholder="{{ t._('Full Name') }}" value="{{ customer.name }}">
                        </div>
                        <div class="form-group">
                            <label for="email">{{ t._('enter_email') }}</label>
                            <input type="email" name="email" class="form-control" id="email" placeholder="{{ t._('enter_email') }}" value="{{ customer.email }}">
                        </div>
                        <div class="form-group row ">
							<div class="col-sm-2 ">
								<label for="selectMobileNumber">{{ t._('Code') }}</label>
								<select class="form-control  custom-select" onchange="selectCountryMobile(this);" id="selectMobileNumber">
									<option value=" ">{{ t._('Code') }}</option>
									<?php foreach ( $array_countries[COMPANY]  AS $country => $ddi ) : ?>
									<option value="{{ ddi }}"<?php if(isset($customer->mobile_country)&&$customer->mobile_country == $ddi){ echo 'selected'; } ?>>{{ country }}
										{{ ddi }}</option>
									<?php endforeach ; ?>
								</select>


							</div>


							<div class="col-sm-10 mt-3 mt-sm-0">
								<label for="mobileNumber">{{ t._('Mobile Number') }}</label>
								<div class="input-group-prepend">
									<span class="input-group-text span-ddi-mobile">
										<?php if(isset($customer->mobile_country)){ echo $customer->mobile_country; } ?>
									</span>
                                    <input type="hidden" class="input-ddi-mobile" readonly name="mobile_country" value="<?php if(isset($customer->mobile_country)){ echo $customer->mobile_country; } ?>"></input>
									<input type="tel" name="cell_number" class="form-control whatsapp_number_BR" id="cell_number" placeholder="{{ t._('Mobile Number') }}" value="{{ customer.cell_number }}" maxlength="15" style="height: 38px">
								</div>
							</div>
						</div>
                        <div class="form-group">
                            <label for="id">{{ t._('id') }}</label>
                            <input type="text" name="id_number" class="form-control" id="id_number" placeholder="{{ t._('id') }}" value="{{ customer.id_number }}">
                            <small id="id" class="form-text text-muted">{{ t._('identification_required_to_view_tickets') }}</small>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-12 col-md-12">
                                <label for="zipCode">{{ t._('zip') }}</label>
                                <input type="text" name="zipcode" class="form-control" id="zipcode" placeholder="{{ t._('zip') }}" value="{{ customer.zipcode }}">
                            </div>
                            <!--
                                <div class="form-group col-4 col-md-2">
                                    <button type="button" class="btn btn-secondary btn-block" id="button-complete-address" onclick="completeAddress();">{{ t._('Complete') }}</button>
                                </div>
                            -->
                        </div>
                        <div class="form-group row">
							<div class="col-md-12 " id="div-msg-address-complete"></div>
						</div>
                        <div class="form-group">
                            <label for="city">{{ t._('city') }}</label>
                            <input type="text" name="city" class="form-control" id="city" placeholder="{{ t._('city') }}" value="{{ customer.city }}">
                        </div>
                        <div class="form-group">
                            <label for="state">{{ t._('region') }}</label>
                            <input type="text" name="region" class="form-control" id="region" placeholder="{{ t._('region') }}" value="{{ customer.region }}">
                        </div>
                        <div class="form-group">
                            <label for="country">{{ t._('country') }}</label>
                            <input type="text" name="country" class="form-control" id="country" placeholder="{{ t._('country') }}" value="{{ customer.country }}">
                        </div>
                        <button type="submit" class="btn btn-primary">{{ t._('save_info') }}</button>
                    </form>
                    <?php /*
                    <form class="form form-new-password pt-5" method="POST" action="{{ url() }}account/profile">
                    */ ?>
                        <input type="hidden" name="save_password" value="on">
                        <div class="form-group">
                            <label for="password">{{ t._('password') }}</label>
                            <input type="password" name="password"  class="form-control" id="password" placeholder="{{ t._('password') }}">
                        </div>
                        <div class="form-group">
                            <label for="newPassword">{{ t._('new_password') }}</label>
                            <input type="password" name="newPassowrd" class="form-control" id="newPassowrd" placeholder="{{ t._('new_password') }}">
                        </div>
                        <?php /*
                        <button type="submit" name="save_password" value="true" class="btn btn-primary">{{ t._('save_info') }}</button>
                    </form>
                    */ ?>
                </div>
            </div>
        </div>
    </div>
</section>

<script type="text/javascript">
	function selectCountryMobile(select) {
        var ddi = $(select).val();
        $('.input-ddi-mobile').val(ddi);
        $('.span-ddi-mobile').html(ddi);
    }
</script>
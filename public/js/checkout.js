


var current_fs, next_fs, previous_fs; /* fieldsets */
var left, opacity, scale; /* fieldset properties which we will animate */
var animating; /* flag to prevent quick multi-click glitches */

$(".next").on('click', function () {
	if(animating) return false;
	animating = true;

	current_fs = $(this).parent();
	next_fs = $(this).parent().next();

	/* activate next step on progressbar using the index of next_fs */
	$("#progressbar li").eq($("fieldset").index(next_fs)).addClass("active");

	/* show the next fieldset */
	next_fs.show();
	/* hide the current fieldset with style */
	current_fs.animate({opacity: 0}, {
		step: function(now, mx) {
			/* as the opacity of current_fs reduces to 0 - stored in "now" */
			/* 1. scale current_fs down to 80% */
			scale = 1 - (1 - now) * 0.2;
			/* 2. bring next_fs from the right(50%) */
			left = (now * 50)+"%";
			/* 3. increase opacity of next_fs to 1 as it moves in */
			opacity = 1 - now;
			current_fs.css({
				'transform': 'scale('+scale+')',
				'position': 'absolute'
			});
			next_fs.css({'left': left, 'opacity': opacity});
		},
		duration: 600,
		complete: function(){
			current_fs.hide();
			animating = false;
			resizeIframe();
		},
		/* this comes from the custom easing plugin */
		easing: 'easeInOutBack'
	});

	  resizeIframe();
});

$(".previous").on('click', function () {
	if(animating) return false;
	animating = true;

	current_fs = $(this).parent();
	previous_fs = $(this).parent().prev();

	/* de-activate current step on progressbar */
	$("#progressbar li").eq($("fieldset").index(current_fs)).removeClass("active");

	/* show the previous fieldset */
	previous_fs.show();
	/* hide the current fieldset with style */
	current_fs.animate({opacity: 0}, {
		step: function(now, mx) {
			/* as the opacity of current_fs reduces to 0 - stored in "now" */
			/* 1. scale previous_fs from 80% to 100% */
			scale = 0.8 + (1 - now) * 0.2;
			/* 2. take current_fs to the right(50%) - from 0% */
			left = ((1-now) * 50)+"%";
			/* 3. increase opacity of previous_fs to 1 as it moves in */
			opacity = 1 - now;
			current_fs.css({'left': left});
			previous_fs.css({'transform': 'scale('+scale+')', 'opacity': opacity});
		},
		duration: 600,
		complete: function(){
			current_fs.hide();
			animating = false;
			resizeIframe();
		},
		/* this comes from the custom easing plugin */
		easing: 'easeInOutBack'
	});
	  resizeIframe();
});





/* faz os tooltip funcionarem */
$('[data-toggle="tooltip"]').tooltip();



$("input.input_qty").TouchSpin({
	min: 0,
	max: 6,
	buttondown_class: "btn btn-info",
	buttonup_class: "btn btn-info"
});



function sumTotal() {
	var total_value = 0;
	var total_qty = 0;
	$('input.input_qty').each(function(){
		price = $(this).data('price');
		qty = $(this).val();
		total_qty += qty;
		total_value += (qty * price);
	})
	return_values =  {value: total_value, qty: total_qty };
	return return_values;
}

$('input.input_qty').change(function(){
	var available =  $(this).data('available');
	/* Se o valor selecionado for maior que o disponivel no input, nao deixa passar */
	if ( $(this).val() > available ) {
		$(this).val(available);
	} else {

		total = sumTotal();
		$('.span-cart-resume').html( '$' + total.value.toFixed(2) + ' ' );
		if (  total.qty > 0 ) {
			$('#button-products').removeClass('disabled');
			$('.span-cart-resume').fadeIn(200).fadeOut(100).fadeIn(200);
		} else {
			$('#button-products').addClass('disabled');
		}
		var product = $(this).attr('name');
		var qty = $(this).val();
		$.post( BASE_URL + "productAdd", "" + product + "=" + qty + "&event=" + ID_EVENT )
			.done(function( data ) {
				$('.cart-resume-in').html(data);
		});
	}
});
//$('input.input_qty').change();




$('#button-products').on('click', function () {
	total = sumTotal();
	if ( total.qty > 0 ) {
		var button = $('#button-products');
		var button_text = buttonWait(button);

		var products = $('#form-products').serialize();
		$('#products-next').click();
		$.post( BASE_URL + "productAdd", products)
		.done(function( data ) {
			buttonWait(button, button_text);
			showLog(data);
		});
	} else {
		$('.span-cart-resume').fadeIn(100).fadeOut(100).fadeIn(100).fadeOut(100).fadeIn(100);
		$('input.input_qty').fadeIn(100).fadeOut(100).fadeIn(100).fadeOut(100).fadeIn(100);
	}
	  resizeIframe();

});



function login(){

	/* Se tiver na tela de RECUPERAR SENHA nao envia o formulário  e volta o FOCUS */
	if ( $('#remember').is(":visible")  )
	{
		$('#tab-login ul li a:first').tab('show');
	} else
	{

		var button = $('#button-login');
		var button_text = buttonWait(button);

		var login = $('#form-login').serialize();
		$.post( BASE_URL + "login", login)
		.done(function( data ) {
			if ( data.success ) {
				if ( data.html_delivery ) {
					$('#field-div-delivery').html(data.html_delivery);
				}
				if ( data.html_payment ) {
					$('#field-div-payment').html(data.html_payment);

					/* Como carrega o html novamente, precisa chamar a função da máscara de novo */
					setPaymentMask();
					/* faz os tooltip funcionarem */
					$('[data-toggle="tooltip"]').tooltip();

				}
				$('#field-div-login').html(data.html_login);
				$('#login-next').click();
				$('#text-error-login').html('');
				$('#text-error-register').html('');
			} else {

				if ( data.msg_login ) {
					$('#text-error-login').fadeIn(100).fadeOut(100).fadeIn(100).fadeOut(100).fadeIn(100).html('<div class="alert alert-danger" role="alert">' + data.msg_login + '</div>');
				}
				if ( data.msg_register ) {
					$('#text-error-register').fadeIn(100).fadeOut(100).fadeIn(100).fadeOut(100).fadeIn(100).html('<div class="alert alert-danger" role="alert">' + data.msg_register + '</div>');
				}
			}

			buttonWait(button, button_text);
		});
	}
	  resizeIframe();
}


function loginRemember() {
	var button = $('#button-login-remember');
	var button_text = buttonWait(button);

	var email = $('#remember_email').val();
	$.post( BASE_URL + "loginRemember", {email: email})
	.done(function( data ) {
		if ( data.success ) {
			$('#text-error-remember').fadeIn(100).fadeOut(100).fadeIn(100).fadeOut(100).fadeIn(100).html('<div class="alert alert-success" role="alert">' + data.msg + '</div>');
			button.html(Translate.email_sent);
		} else {
			$('#text-error-remember').fadeIn(100).fadeOut(100).fadeIn(100).fadeOut(100).fadeIn(100).html('<div class="alert alert-danger" role="alert">' + data.msg + '</div>');
			buttonWait(button, button_text);
		}
	});

	  resizeIframe();
}


function logout(){
	var button = $('#button-logout');
	var button_text = buttonWait(button);

	$.post( BASE_URL + "logout")
	.done(function( data ) {
		$('#field-div-login').html(data);
		buttonWait(button, button_text);
	});

	  resizeIframe();
}




function loginSeller(step = null) {

	$('#text-error-login-seller-email').hide().html('');
	$('#text-error-login-seller-data').hide().html('');

	if ( step == 5 ){/* 5 => volta pra tela anteior - que identifica o usuario pelo email*/

		$('#login-seller-data').slideUp(500, function() {
			    resizeIframe();
			  });
		$('#button-login-seller-email').hide(100, function() {
			    resizeIframe();
			  });
		$('#login-seller-email').slideDown(500, function() {
			    resizeIframe();
			  });
		resizeIframe();

	} else {

		var step = 0;
		if ( $('#login-seller-email').is(":visible")  ){
			step = 1;
		}
		if ( $('#login-seller-data').is(":visible")  ){
			step = 2;
		}


		var button = $('#button-login-seller');
		var button_text = buttonWait(button);


		var login_seller = $('#form-login-seller').serialize();
		if ( step == 1 ){
			$.post( BASE_URL + "loginSeller", login_seller + "&step=" + step )
			.done(function( data ) {
				if ( data.success ) {

					$('#login-seller-email_data').val(data.email);
					if ( data.customer ) {
						$('#login-seller-email_data').html(data.customer.email).prop('readonly', true);
						if (data.customer.name) $('#login-seller-name').val(data.customer.name).prop('readonly', true);
						if (data.customer.cell_number) $('#login-seller-cell').val(data.customer.cell_number).prop('readonly', true);
					} else {
						$('#login-seller-name').val('').prop('readonly', false);
						$('#login-seller-cell').val('').prop('readonly', false);
					}

					$('#login-seller-email').slideUp(500);
					$('#login-seller-data').slideDown(500);
					$('#button-login-seller-email').show(500, function() {
					    resizeIframe();
					  });
					resizeIframe();
				} else {
					$('#text-error-login-seller-email').fadeIn(100).fadeOut(100).fadeIn(100).fadeOut(100).fadeIn(100).html('<div class="alert alert-danger" role="alert"> ' + data.msg + ' </div>');
				}
				buttonWait(button, button_text);
			});

		}

		if ( step == 2 ) {
			$.post( BASE_URL + "loginSeller", login_seller + "&step=" + step )
			.done(function( data ) {
				if ( data.success ) {
					if ( data.html_delivery ) {
						$('#field-div-delivery').html(data.html_delivery);
					}
					if ( data.html_payment ) {
						$('#field-div-payment').html(data.html_payment);

						/* Como carrega o html novamente, precisa chamar a função da máscara de novo */
						setPaymentMask();
						/* faz os tooltip funcionarem */
						$('[data-toggle="tooltip"]').tooltip();
					}
					$('#login-next').click();
				} else {
					$('#text-error-login-seller-data').fadeIn(100).fadeOut(100).fadeIn(100).fadeOut(100).fadeIn(100).html('<div class="alert alert-danger" role="alert"> ' + data.msg + ' </div>');
				}
				buttonWait(button, button_text);
			});
		}



	}

	resizeIframe();
}


function delivery(){
	var button = $('#button-delivery');
	var button_text = buttonWait(button);

	var delivery = $('#form-delivery').serialize();
	$.post( BASE_URL + "delivery", delivery + "&event=" + ID_EVENT)
	.done(function( data ) {
		if ( data.success ) {
			$('#delivery-next').click();
			$('#text-error-delivery').html('');
		} else {
			$('#text-error-delivery').fadeIn(100).fadeOut(100).fadeIn(100).fadeOut(100).fadeIn(100).html('<div class="alert alert-danger" role="alert"> ' + data.msg + ' </div>');
		}
		buttonWait(button, button_text);
	});

	  resizeIframe();
}







function paymentChoose(payment_id) {
	$('.form-payment').hide();
	$('#form-payment-' + payment_id).slideDown(500, function() {
			    resizeIframe();
			  });

	$('.btn-payment-type').removeClass('btn-success');
	$('.btn-payment-type').addClass('btn-default');
	$('#button-payment-choose-' + payment_id ).addClass('btn-success');
}



function calculateChange() {
	var total = $('#total_value_hidden').val();
	var value = $('#amount_paid').val();
	var diff = (total - value).toFixed(2);
	$('#change_money').val( (diff * -1 ) );
	/*console.log(total + ' - ' + value + ' = ' + diff);*/
}







function payment(step = null) {

	$('#text-error-payment').hide().html('');
	$('#text-error-payment-credit-card').hide().html('');
	$('#text-error-payment-billing-address').hide().html('');

	if ( step == 5 ){/* 5 => volta pra tela do cartao */

		$('#billing-address').slideUp(500);
		$('#button-payment-credit-card').hide(100);
		$('#credit-card-data').slideDown(500, function() {
			    resizeIframe();
			  });
		resizeIframe();

	} else {


		var step = 0;
		if ( $('#credit-card-data').is(":visible")  ){
			step = 1; /* Pgto em cartao - mostra os dados do cartao */

			// Nao pede os dados do BILLING ADDRESS - pula direto para transacao financeira
			step = 2;
		}
		if ( $('#billing-address').is(":visible")  ){
			step = 2; /* Pgto em cartao - tela de preencher o billind address */
		}
		if ( $('#form-payment-1').is(":visible")  ){
			step = 3; /* Pgto em dinheiro */
		}
		if ( $('#form-payment-7').is(":visible")  ){
			step = 4; /* Pgto com cortesia */
		}




		if ( step == 1 )
		{
			$('#credit-card-data').slideUp(500, function() {
			    resizeIframe();
			  });
			$('#billing-address').slideDown(500, function() {
			    resizeIframe();
			  });
			$('#button-payment-credit-card').show(500, function() {
			    resizeIframe();
			  });
			resizeIframe();

		} else if ( step == 2 )
		{
			var button = $('#button-payment');
			var button_text = buttonWait(button);

			var payment_data = $('#form-payment-2').serialize();
			$.post( BASE_URL + "checkout", payment_data )
			.done(function( data ) {
				buttonWait(button, button_text);
				if ( data.success ) {
					$('#msform').html(data.html);
				} else {
					if ( data.msg ) {
						$('#text-error-payment').fadeIn(100).fadeOut(100).fadeIn(100).fadeOut(100).fadeIn(100).html('<div class="alert alert-danger" role="alert"> ' + data.msg + ' </div>');
						resizeIframe();
					}
					if ( data.msg_credit_card ) {
						// payment(5);
						// $('#text-error-payment-credit-card').fadeIn(100).fadeOut(100).fadeIn(100).fadeOut(100).fadeIn(100).html('<div class="alert alert-danger" role="alert"> ' + data.msg_credit_card + ' </div>');
						$('#text-error-payment').fadeIn(100).fadeOut(100).fadeIn(100).fadeOut(100).fadeIn(100).html('<div class="alert alert-danger" role="alert"> ' + data.msg_credit_card + ' </div>');
						resizeIframe();
					}
					if ( data.msg_billing_address ) {
						//$('#text-error-payment-billing-address').fadeIn(100).fadeOut(100).fadeIn(100).fadeOut(100).fadeIn(100).html('<div class="alert alert-danger" role="alert"> ' + data.msg_billing_address + ' </div>');
						$('#text-error-payment').fadeIn(100).fadeOut(100).fadeIn(100).fadeOut(100).fadeIn(100).html('<div class="alert alert-danger" role="alert"> ' + data.msg_billing_address + ' </div>');
						resizeIframe();
					}
				}
			});
		} else if ( step == 3 )
		{
			var button = $('#button-payment');
			var button_text = buttonWait(button);

			var payment_data = $('#form-payment-1').serialize();
			$.post( BASE_URL + "checkout", payment_data )
			.done(function( data ) {
				buttonWait(button, button_text);
				if ( data.success ) {
					$('#msform').html(data.html);
					resizeIframe();
				} else {
					if ( data.msg ) {
						$('#text-error-payment').fadeIn(100).fadeOut(100).fadeIn(100).fadeOut(100).fadeIn(100).html('<div class="alert alert-danger" role="alert"> ' + data.msg + ' </div>');
						resizeIframe();
					}
				}
			});
		} else if ( step == 4 )
		{
			var button = $('#button-payment');
			var button_text = buttonWait(button);

			var payment_data = $('#form-payment-7').serialize();
			$.post( BASE_URL + "checkout", payment_data )
			.done(function( data ) {
				buttonWait(button, button_text);
				if ( data.success ) {
					$('#msform').html(data.html);
				} else {
					if ( data.msg ) {
						$('#text-error-payment').fadeIn(100).fadeOut(100).fadeIn(100).fadeOut(100).fadeIn(100).html('<div class="alert alert-danger" role="alert"> ' + data.msg + ' </div>');
						resizeIframe();
					}
				}
			});
		}
	}

  resizeIframe();

}




function buttonWait(button, original_text = false)
{
	if (original_text )
	{
		button.html(original_text).removeClass('disabled').prop('disabled', false);
	} else {
		var original_text = button.html();
		var loadingText = '<i class="glyphicon glyphicon-refresh glyphicon-spin"></i> ';
		button.html(loadingText).addClass('disabled').prop('disabled', true);
		return  original_text;
	}

	  resizeIframe();
}





function setPaymentMask() {

	$('.cc_expiration').payment('formatCardExpiry');
	$('.cc_cvv').payment('formatCardCVC');
	$('.cc_number').payment('formatCardNumber');

	$.fn.toggleInputError = function(erred) {
		this.parent('.form-group').toggleClass('has-error', erred);
		return this;
	};
	$('#cc_number').focusout(function() {
		var cardType = $.payment.cardType($('#cc_number').val());
		if ( typeof cardType === 'string' && cardType.trim() ) {
			$('.cc-brand').html('<small style="text-transform: capitalize;"> &nbsp; [' + cardType + '] </small>');
		}
	});
}
setPaymentMask();






function completeAddress(sector)
{
	$('#button-complete-address').removeClass('btn-secondary').addClass('btn-info');
	$('#div-msg-address-complete').html('');
	if ( sector == 'register' ) {
		var city = $('#register_city');
		var region = $('#register_region');
		var country = $('#register_country');
		var zip = $('#register_zipcode').val();
	} else {
		var city = $('#city');
		var region = $('#region');
		var country = $('#country');
		var zip = $('#zipcode').val();
	}
	city.val('');
	region.val('');
	country.val('');
	$.post( BASE_URL + "getAddress", { zip: zip })
		.done(function( data ) {
			if ( data.status == 'success' )
			{
				//console.log(data);
				city.val(data.result.city_name);
				region.val(data.result.region_name);
				country.val(data.result.country_name);
				$('#button-complete-address').removeClass('btn-info').addClass('btn-secondary');
			} else if ( data.status == 'not_found' )
			{
				$('#div-msg-address-complete').html("<div class='alert alert-primary'  style='margin-bottom: 20px;'>" + data.msg + "</div>");
			} else {
				$('#div-msg-address-complete').html("<div class='alert alert-primary'  style='margin-bottom: 20px;'>" + data.msg + "</div>");
			}
	});
}




function showLog(log) {
	return false;
	/*$('#console-log').html(log);*/
}
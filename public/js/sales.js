$(document).ready(function () {


	/* abre o modal pra detalhar o pedido na listagem de vendas */
	$('#modal_order').on('show.bs.modal', function (e) {
		$(this).find('.modal-content').html('<div class="modal-order-loader"></div>');
		var button = $(e.relatedTarget);
		$(this).find('.modal-content').load(button.data('remote'));
	});



	/* faz os tooltip funcionarem */
	$('[data-toggle="tooltip"]').tooltip();



	/*  oculta a barra lateral */
	$('#sidebarCollapse').on('click', function () {
		$('#sidebar').toggleClass('active');
	});


});


function submitWithdrawal()
{
	$('#form-withdrawal').submit();
}



function showDetail(elemnent_show, table_responsible = false)
{
	console.log(elemnent_show);

	$(elemnent_show).toggle();
	if ( table_responsible ) {
		$(table_responsible).toggleClass(' table-sm ');
	}
}







function sendEmail(id_order)
{
	var button = $('.btn-send-email');
	button.data('original-text', button.html());

	var loadingText = '<i class="fa fa-spinner fa-spin"></i> ' + Translate.button_loading;
	button.html(loadingText).addClass('disabled').prop('disabled', true);


	var email = $('.input-send-email').val();
	$.post( BASE_URL + "send_email", { id_order: id_order, email: email })
		.done(function( data ) {
			//console.log(data);
			if ( data.status == 'success' )
			{
				$('.div-send-email').html('<div class="btn  btn-success text-center" style="width: 100%">' + data.msg + '</div>');
			} else {
				alert(data.msg);
				button.html(button.data('original-text')).removeClass('disabled').prop('disabled', false);
			}

	});
}



$(function () {
	$('#datetimepicker6, #datetimepicker7').datetimepicker({
			//useCurrent: false, //Important! See issue #1075
			showTodayButton: true,
			focusOnShow: true,
			allowInputToggle: true,
			format: "DD/MM/YYYY HH:mm:ss",
		});
	$("#datetimepicker6").on("dp.change", function (e) {
		$('#datetimepicker7').data("DateTimePicker").minDate(e.date);
	});
	$("#datetimepicker7").on("dp.change", function (e) {
		$('#datetimepicker6').data("DateTimePicker").maxDate(e.date);
	});

	$('#datetimepicker6').on("dp.hide",function (e) {
		$('#datetimepicker7').data('DateTimePicker').show();
	});
});



$(function() {
	if ( typeof payment_status_data != "undefined" ) {
		var payment_status = $('#payment_status').magicSuggest({
			data: payment_status_data,
			toggleOnClick: true,
			typeDelay: 50,
		});
	}

	if ( typeof payment_type_data != "undefined" ) {
		var payment_type = $('#payment_type').magicSuggest({
			data: payment_type_data,
			toggleOnClick: true,
			typeDelay: 50,
		});
	}

	if ( typeof order_status_data != "undefined" ) {
		var order_status = $('#order_status').magicSuggest({
			data: order_status_data,
			toggleOnClick: true,
			typeDelay: 50,
		});
	}

	if ( typeof events_filter_data != "undefined" ) {
		var event_filter = $('#event_filter').magicSuggest({
			data: events_filter_data,
			toggleOnClick: true,
			typeDelay: 50,
		});
	}

});
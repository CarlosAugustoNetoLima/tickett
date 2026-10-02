
<div class="page-header">
	<h4>{{ t._('credit_card') }}</h4>
</div>
<div id="credit-card-div">


	<div class="row">
		<div class="col-md-6 mb-3">
			<label for="cc_name">{{ t._('name_on_card') }}</label>
			<input type="text" class="form-control" id="cc_name"  name="cc_name" >
			<small class="form-text text-muted" style="margin-top: -25px;">{{ t._('full_name_on_card') }}</small>
		</div>
		<div class="col-md-6 mb-3">
			<label for="cc_number">{{ t._('credit_card_number') }}</label>
			<input type="text" class="form-control" id="cc_number" name="cc_number" >
		</div>
	</div>
	<div class="row">
		<div class="col-md-3 mb-3">
			<label for="cc_expiration">{{ t._('expiration') }}</label>
			<input type="text" class="form-control" id="cc_expiration" name="cc_expiration" >
		</div>
		<div class="col-md-3 mb-3">
			<label for="cc_cvv">{{ t._('cvv') }}</label>
			<input type="text" class="form-control" id="cc_cvv"  name="cc_cvv" >
		</div>
		<div class="card-wrapper"></div>
	</div>
</div>




    <script>


	$('#credit-card-div').card({
		container: '.card-wrapper',
		formSelectors: {
			numberInput: 'input[name="cc_number"]',
			expiryInput: 'input[name="cc_expiration"]',
			cvcInput: 'input[name="cc_cvv"]',
			nameInput: 'input[name="cc_name"]'
		},
	});
    </script>
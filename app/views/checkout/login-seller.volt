<h2 class="fs-title">{{ t._('Customer') }}</h2>


<form id="form-login-seller" class="text-left ">




	<div id="login-seller-email" >

		<div class="form-group">
			<label for="login-seller-email">{{ t._('email_address') }}</label>
			<input type="email" class="form-control email" id="login-seller-email" name="loginSeller[email]" placeholder="{{ t._('email') }}" >
		</div>

		<div class="form-group">
			<div   id="text-error-login-seller-email"></div>
		</div>


	</div>





	<div id="login-seller-data" style="display: none;">

		<div class="form-group">
			<label for="login-seller-email_data">{{ t._('email_address') }}</label>
			<input type="email" class="form-control email" id="login-seller-email_data" name="loginSeller[email_data]" placeholder="{{ t._('email') }}" value="<?php echo isset($customer) ? $customer->email : ''  ?>" >
		</div>

		<div class="form-group">
			<label for="login-seller-name">{{ t._('name') }}</label>
			<input type="text" class="form-control" id="login-seller-name" name="loginSeller[name]" placeholder="{{ t._('name') }}">
		</div>
		<div class="form-group">
			<label for="login-seller-cell">{{ t._('Mobile Number') }}</label>
			<input type="text" class="form-control" id="login-seller-cell" name="loginSeller[cell_number]" placeholder="{{ t._('Mobile Number') }}">
		</div>

		<div class="form-group">
			<div   id="text-error-login-seller-data"></div>
		</div>


	</div>







</form>


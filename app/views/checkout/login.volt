<h2 class="fs-title">{{ t._('Customer') }}</h2>


<?php if ( isset($customer) AND $customer->id > 0 ) : ?>

	<div class="row">
		<div class="col-md-8">
			<h3>{{ customer.name }}</h3>
			<h4>{{ customer.email }}</h4>
		</div>
		<div class="col-md-4 text-center" style="    line-height: 85px;">
			<button type="button" class="btn btn-warning btn-logout" id="button-logout" onclick="logout();">{{ t._('Logout') }}</button>
		</div>
	</div>
<?php else : ?>

	<form id="form-login" class="text-left">
		<div id="tab-login">

			<!-- Nav tabs -->
			<ul class="nav nav-tabs " role="tablist">
				<li role="presentation" class="active">
					<a href="#register" aria-controls="register" role="tab" data-toggle="tab" onclick="$('#login input').val('');">
						{{ t._('new_user') }}
					</a>
				</li>
				<li role="presentation" class="">
					<a href="#login" aria-controls="login" role="tab" data-toggle="tab" onclick="$('#register input').val('');">
						{{ t._('login') }}
					</a>
				</li>
					<li role="presentation">
						<a href="#remember" aria-controls="register" role="tab" data-toggle="tab" onclick="$('#register input').val('');$('#login input').val('');">
						{{ t._('remember') }}
					</a>
				</li>
			</ul>
			<br />

			<!-- Tab panes -->
			<div class="tab-content">
				<div role="tabpanel" class="tab-pane active" id="register">


					<div class="form-group">
						<label for="register_name">{{ t._('name') }}</label>
						<input type="text" class="form-control" id="register_name" name="register[name]" placeholder="{{ t._('name') }}">
					</div>
					<div class="form-group">
						<label for="register_email">{{ t._('email_address') }}</label>
						<input type="email" class="form-control email" id="register_email" name="register[email]" placeholder="{{ t._('email') }}">
					</div>
					<div class="form-group">
						<label for="register_password">{{ t._('password') }}</label>
						<input type="password" class="form-control" id="register_password" name="register[password]" placeholder="{{ t._('password') }}">
					</div>
					<div class="form-group">
						<label for="register_cell_number">{{ t._('Mobile Number') }}</label>
						<input type="text" class="form-control" id="register_cell_number" name="register[cell_number]" placeholder="{{ t._('Mobile Number') }}">
					</div>
					<div class="form-group">
						<div   id="text-error-register"></div>
					</div>


				</div>
				<div role="tabpanel" class="tab-pane " id="login">


					<div class="form-group">
						<label for="login_email">{{ t._('email_address') }}</label>
						<input type="email" class="form-control email" id="login_email" name="login[email]" placeholder="{{ t._('email') }}">
					</div>
					<div class="form-group">
						<label for="login_password">{{ t._('password') }}</label>
						<input type="password" class="form-control" id="login_password" name="login[password]" placeholder="{{ t._('password') }}">
					</div>
					<div class="form-group">
						<div   id="text-error-login"></div>
					</div>


				</div>
				<div role="tabpanel" class="tab-pane" id="remember">


					<div class="form-group">
						<label for="remember_email">{{ t._('email_address') }}</label>
						<input type="email" class="form-control email" id="remember_email" name="remember[email]" placeholder="{{ t._('email') }}">
					</div>

					<button type="button" class="btn btn-info" id="button-login-remember" onclick="loginRemember();">{{ t._('remember_password') }}</button>

					<div class="form-group">
						<div   id="text-error-remember"></div>
					</div>


				</div>
			</div>

		</div>
	</form>

<?php endif ; ?>



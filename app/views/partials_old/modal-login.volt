


<?php
$number_a = (int)rand(1, 5);
$number_b = (int)rand(1, 5);
$total = ($number_a + $number_b);
$crypt = base64_encode($this->crypt->encryptBase64((string)$total));
?>



<!-- LOGIN MODAL -->
<div class="modal fade login-modal" id="login" tabindex="-1" role="dialog">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header justify-content-center">
				<h3 class="modal-title">{{ t._('log_in') }}</h3>
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
			</div>
			<div class="modal-body">
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
					<a data-toggle="modal" href='#signup'>
						<button type="button" class="btn btn-link btn-block" data-dismiss="modal">{{ t._('new_user') }}</button>
					</a>
				</form>
			</div>
		</div>
	</div>
</div>


<!-- SIGN UP MODAL -->
<div class="modal fade " id="signup" tabindex="-1" role="dialog">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header justify-content-center">
				<h3 class="modal-title">{{ t._('create_an_account') }}</h3>
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
			</div>
			<div class="modal-body">
				<form action="{{ url() }}account/register" method="POST" role="form">
					<input type="hidden" name="crypt" value="{{ crypt }}">
					<div class="form-group">
						<label for="name-create">{{ t._('Full Name') }}</label>
						<input type="text" class="form-control" id="name-create" name="name">
					</div>


					<?php if ( null !== COMPANY AND COMPANY == 'lebillet'  ) : /* CPF obrigatório no LeBillet */  ?>
						<div class="form-group">
							<label for="cpf-create">{{ t._('CPF') }}</label>
							<input type="text" class="form-control" id="cpf-create" name="cpf">
						</div>
					<?php endif ; ?>


					<div class="form-group">
						<label for="email-create">{{ t._('enter_email') }}</label>
						<input type="email" class="form-control" id="email-create" name="email">
					</div>
					<div class="form-group">
						<label for="password-create">{{ t._('password') }}</label>
						<input type="password" class="form-control" id="password-create" name="password">
					</div>
					<div class="form-group">
						<label for="captcha_sign">{{ t._('Answer') }}: {{ number_a }} + {{ number_b}} = </label>
						<input type="text" class="form-control" id="captcha_sign" name="captcha">
					</div>
					<button type="submit" class="btn btn-primary btn-block">{{ t._('sign_up') }}</button>
					<a data-toggle="modal" href='#login'>
						<button type="button" class="btn btn-link btn-block" data-dismiss="modal">{{ t._('have_a_account') }}</button>
					</a>
					<a data-toggle="modal" href='#forgot-password'>
						<button type="button" class="btn btn-link btn-block" data-dismiss="modal">{{ t._('forgot_password') }}</button>
					</a>
				</form>
			</div>
		</div>
	</div>
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



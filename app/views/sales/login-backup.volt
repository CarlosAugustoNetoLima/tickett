

<form action="{{ urlSales }}login" method="POST" role="form" class="form-signin">
	<img class="mb-4" src="{{ urlSales }}tiktx_logo.png"" alt="TiktX" >
	<h1 class="h3 mb-3 font-weight-normal">Please sign in</h1>

	{{ content() }}


	<label for="email_login" class="sr-only">{{ t._('enter_email') }}</label>
	<input type="email" name="id" id="email_login" class="form-control" placeholder="{{ t._('enter_email') }}" required autofocus>

	<label for="password_login" class="sr-only">{{ t._('password') }}</label>
	<input type="password" name="password" id="password_login" class="form-control" placeholder="{{ t._('password') }}" required>


	<button class="btn btn-lg btn-primary btn-block" type="submit">{{ t._('log_in') }}</button>

	<p class="mt-5 mb-3 text-muted">&copy; <?php echo date('Y') ?> - tiktx | Tickets</p>
</form>

<style type="text/css">

html,
body {
	height: 100%;
}

body {
	display: -ms-flexbox;
	display: -webkit-box;
	display: flex;
	-ms-flex-align: center;
	-ms-flex-pack: center;
	-webkit-box-align: center;
	align-items: center;
	-webkit-box-pack: center;
	justify-content: center;
	padding-top: 40px;
	padding-bottom: 40px;
	background-color: #f5f5f5;
}

.form-signin {
	width: 100%;
	max-width: 330px;
	padding: 15px;
	margin: 0 auto;
}
.form-signin .checkbox {
	font-weight: 400;
}
.form-signin .form-control {
	position: relative;
	box-sizing: border-box;
	height: auto;
	padding: 10px;
	font-size: 16px;
}
.form-signin .form-control:focus {
	z-index: 2;
}
.form-signin input[type="email"] {
	margin-bottom: -1px;
	border-bottom-right-radius: 0;
	border-bottom-left-radius: 0;
}
.form-signin input[type="password"] {
	margin-bottom: 10px;
	border-top-left-radius: 0;
	border-top-right-radius: 0;
}

</style>
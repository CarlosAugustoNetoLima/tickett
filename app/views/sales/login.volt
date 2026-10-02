
	<div class= " logo ">
		<div class= "  flash">
			<?php echo $this->getContent(); ?>
		</div>
	</div>

	<!-- Login Box -->
	<div class="box">
		<div class="content">
			<!-- Login Formular -->
			<form action="{{ urlSales }}login" method="POST" role="form" class="form-signin">

				<!-- Title -->
				<h3 class="form-title">{{ t._('Sign In to your Account') }}</h3>

				<!-- Error Message -->
				<div class="alert fade in alert-danger" style="display: none;">
					<i class="icon-remove close" data-dismiss="alert"></i>
					{{ t._('Enter any username and password') }}.
				</div>

				<!-- Input Fields -->
				<div class="form-group">
					<!--<label for="username">Username:</label>-->
					<div class="input-icon">

						<input type="text" name="id" class="form-control" placeholder="{{ t._('Email') }}" autofocus="autofocus" data-rule-required="true" data-msg-required="{{ t._('Please enter your email') }}." />
					</div>
				</div>
				<div class="form-group">
					<!--<label for="password">Password:</label>-->
					<div class="input-icon">

						<input type="password" name="password" class="form-control" placeholder="{{ t._('Password') }}" data-rule-required="true" data-msg-required="{{ t._('Please enter your password') }}." />
					</div>
				</div>
				<!-- /Input Fields -->

				<!-- Form Actions -->
				<div class="form-actions">
					<button type="submit" class="submit btn btn-info float-right" style="background-color: #00719a !important;">
						{{ t._('Sign In') }}   &raquo;
					</button>
				</div>
			</form>
			<!-- /Login Formular -->




		</div>
		<!-- /<div class="content"> -->





		<!-- Forgot Password Form -->
		<div class="inner-box">
			<div class="content">
				<!-- Link as Toggle Button -->
				<a onclick="document.getElementById('form-password').style.display = 'block';" href="#" class="forgot-password-link">Forgot Password?</a>

				<!-- Forgot Password Formular -->
				<form action="{{ urlSales }}login" id="form-password" class="form-vertical" method="post"  style="<?php echo $reset_password ? '' : 'display: none;' ?>">
					<input type="hidden" name="reset_password" value="true">

					<!-- Input Fields -->
					<div class="form-group">
						<!--<label for="email">Email:</label>-->
						<div class="input-icon">
							<input type="text" name="email_reset_password" class="form-control" placeholder="{{ t._('Please enter your email') }}" />
						</div>
					</div>
					<!-- /Input Fields -->

					<button type="submit" class="submit btn btn-default btn-block">
						{{ t._('Reset your Password') }}
					</button>
				</form>
				<!-- /Forgot Password Formular -->

			</div> <!-- /.content -->
		</div>
		<!-- /Forgot Password Form -->





	</div>
	<!-- /Login Box -->

<div class="header clearfix">

<?php
 // echo '<pre>';
 // print_r($cart);
 // echo '</pre>';
?>
	<!-- TOPBAR -->
	<div class="topBar">
		<div class="container">
			<div class="row">
				<div class="col-md-6 d-none d-md-block">


					<div class="dropdown">
						<button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="background-color: #7a7878;border: 0; color: #c2c1c1; text-transform: none; font-size: 12px; height: 36px;">
							<?php
							$language = $this->session->get("language") ;

							$language_text = 'English' ;
							if ( $language == 'pt_br' ) {
								$language_text = 'Português';
							} else if ( $language == 'es_do' ) {
								$language_text = 'Spanish';
							} else if ( $language == 'pt_pt' ) {
								$language_text = 'Português';
							}
							echo $language_text ;
							?>
						</button>
						<div class="dropdown-menu" aria-labelledby="dropdownMenuButton" style="font-size: 12px;">
							<a class="dropdown-item" href="{{ url() }}<?php echo strip_tags($this->router->getRewriteUri()) ?>?l=en_us"><img src="{{ url() }}img/home/usa-top.png" width="22px" height="16px">&nbsp; English</a>
							<a class="dropdown-item" href="{{ url() }}<?php echo strip_tags($this->router->getRewriteUri()) ?>?l=pt_br"><img src="{{ url() }}img/home/brazil-top.png" width="22px" height="16px">&nbsp; Português</a>
							<a class="dropdown-item" href="{{ url() }}<?php echo strip_tags($this->router->getRewriteUri()) ?>?l=pt_pt"><img src="{{ url() }}img/home/portugal-top.png" width="22px" height="16px">&nbsp; Português</a>
							<a class="dropdown-item" href="{{ url() }}<?php echo strip_tags($this->router->getRewriteUri()) ?>?l=es_do"><img src="{{ url() }}img/home/spain-top.png" width="22px" height="16px">&nbsp; Spanish</a>
						</div>
					</div>



				</div>
				<div class="col-md-6 col-12">
					<ul class="list-inline float-right top-right">
						<li class="account-login">
							<?php if ( $customer ) : ?>
								<span>
									<a>
										{{ t._('hi') }}, {{ customer.name }}
									</a>
									-
									<a href="{{ url() }}account/logout">
										{{ t._('logout') }}
									</a>
								</span>
							<?php else : ?>
								<span>
									<a data-toggle="modal" href='.login-modal'>
										{{ t._('log_in') }}
									</a>
									<small>
										{{ t._('or') }}
									</small>
									<a data-toggle="modal" href='#signup'>
										{{ t._('create_an_account') }}
									</a>
								</span>
							<?php endif; ?>
						</li>

					</ul>
				</div>
			</div>
		</div>
	</div>


</div>
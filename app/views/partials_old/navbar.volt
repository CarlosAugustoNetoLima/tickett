<!-- NAVBAR -->
<nav class="navbar navbar-main navbar-default navbar-expand-md" role="navigation">
	<div class="container">
		<!-- Brand and toggle get grouped for better mobile display -->

		<a class="navbar-brand" href="{{ url() }}">
			<img src="{{ url() }}{{ config.company.logos }}logo.png" />
		</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse" data-target=".navbar-ex1-collapse" aria-controls="navbar-ex1-collapse" aria-expanded="false" aria-label="Toggle navigation">
			<span class="fa fa-bars"></span>
		</button>


		<!-- Collect the nav links, forms, and other content for toggling -->
		<div class="collapse navbar-collapse navbar-ex1-collapse">
			<ul class="nav navbar-nav ml-auto">

				<li class="nav-item active ">
					<a href="{{ url('helpdesk') }}" class=" nav-link active"  role="button">{{ t._('contact') }}</a>
				</li>

				<li class="nav-item dropdown ">
					<a href="{{ url() }}account" class="dropdown-toggle nav-link" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">{{ t._('account') }}</a>
					<ul class="dropdown-menu dropdown-menu-right">
						<li class=""><a href="{{ url() }}account">{{ t._('dashboard_account') }}</a></li>
						<li class=""><a href="{{ url() }}account/profile">{{ t._('edit_profile') }}</a></li>
						<li class=""><a href="{{ url() }}account/orders">{{ t._('order_history') }}</a></li>
						<li class=""><a href="{{ url() }}account/wishlist">{{ t._('wish_list') }}</a></li>
						<li class=""><a href="{{ url() }}account/support">{{ t._('support') }}</a></li>
						<li class=""><a href="{{ url() }}account/logout">{{ t._('logout') }}</a></li>
					</ul>
				</li>


				<li class="nav-item dropdown megaDropMenu ">
					<a href="javascript:void(0)" class="dropdown-toggle nav-link" data-toggle="dropdown" data-hover="dropdown" data-delay="300" data-close-others="true" aria-expanded="false">{{ config.company.name }}</b></a>
					<ul class="dropdown-menu row">
						<li class="col-md-6 col-12">
							<ul class="list-unstyled">
								<li>{{ t._('the_company') }}</li>
								<li><a href="{{ url() }}company">{{ t._('about') }}</a></li>
								<li><a href="{{ url() }}company/policies_procedures">{{ t._('policies_procedures') }}</a></li>
								<li><a href="{{ url() }}company/privacy">{{ t._('privacy') }}</a></li>
							</ul>
						</li>
						<li class="col-md-6 col-12">
							<ul class="list-unstyled">
								<li>{{ t._('help') }}</li>
								<!--<li><a href="{{ url('company/faq') }}">{{ t._('faq') }}</a></li>-->
								<li><a href="{{ url('helpdesk') }}">{{ t._('contact') }}</a></li>
								<li><a href="{{ url('helpdesk') }}">{{ t._('helpdesk') }}</a></li>
								<?php if ( COMPANY == 'lebillet' ) : ?>
								<li><a href="{{ url('company/meia_entrada') }}">{{ t._('Meia Entrada') }}</a></li>
		                        <?php endif ; ?>

								<li><a href="{{ url('company/sell') }}">{{ t._('sell_your_event') }}</a></li>
							</ul>
						</li>
					</ul>
				</li>

			</ul>
		</div><!-- /.navbar-collapse -->



	</div>
</nav>
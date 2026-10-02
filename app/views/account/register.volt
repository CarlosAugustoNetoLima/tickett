

<main>
	<article class="internal-content">
		<div class="container">
			<div class="internal-content-inner">
				<div class="content-text">
					<div class="text-group">

						<!-- LIGHT SECTION -->
						<section class="lightSection clearfix pageHeader">
							<div class="container">
								<div class="row">
									<div class="col">
										<div class="page-title">
											<h2>{{ t._('register') }}</h2>
										</div>
									</div>
								</div>
							</div>
						</section>

						{{ content() }}
						{{ flashSession.output() }}

						<!-- MAIN CONTENT SECTION -->
						<section class="mainContent clearfix genricContent">
							<div class="container">
								<div class="row">
									<div class="col-md-12 buttons-login">
										<a class="btn btn-primary btn-default" data-toggle="modal" href='.login-modal'>
											{{ t._('log_in') }}
										</a>
										&nbsp;  &nbsp; {{ t._('or') }} &nbsp;  &nbsp;
										<a class="btn btn-primary btn-default" data-toggle="modal" href='#signup'>
											{{ t._('create_an_account') }}
										</a>
									</div>
								</div>
							</div>
						</section>
						<br/>

					</div>
				</div>
			</div>
		</div>
	</div>
</main>


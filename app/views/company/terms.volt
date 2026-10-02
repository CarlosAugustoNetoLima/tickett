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
											<h2>{{ t._('Terms and Conditions') }}</h2>
										</div>
									</div>
								</div>
							</div>
						</section>

						<!-- MAIN CONTENT SECTION -->
						<section class="mainContent clearfix genricContent">
							<div class="container">
								<div class="row">
									<div class="col-md-12">
										{{ config.company.ticket_instructions }}
									</div>
								</div>
							</div>
						</section>

						<?php if ( COMPANY == 'tiktx' ) : ?>
							<section class="mainContent clearfix genricContent">
								<div class="container">
									<div class="row">
										<div class="col-md-12">
											<h4 class="text-center" style="text-align: center;">{{ t._('policies_procedures') }}</h4>
											{{ config.company.policies }}
										</div>
									</div>
								</div>
							</section>
						<?php endif ; ?>

					</div>
				</div>
			</div>
		</div>
	</div>
</main>
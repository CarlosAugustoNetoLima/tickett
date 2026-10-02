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
											<h2>{{ t._('sell_your_event') }}</h2>
										</div>
									</div>
								</div>
							</div>
						</section>

						<div class="container pt-5">
							{{ content() }}
							<div class="row">

								<script language="javascript" type="text/javascript">
									var pre = "{{ config.company.email_pre }}";
									var domain = "{{ config.company.email_domain }}";
								</script>

								<div class="col">
									<div class="page-header">
										<h4>{{ t._('Contact us or send us an email') }} <script type="text/javascript">document.write("<a target='_blank'  style='color: #47bac1; text-transform: lowercase;''  href='mailto:" + pre + "@" + domain + "'>" + pre
														+ "@" + domain + "</a>");</script> </h4>
									</div>
									<form class="" method="POST" action="{{ url() }}helpdesk/new">
										<input type="hidden" name="action" value="new">
										<div class="row">
											<div class="form-group col-md-6">
												<label for="new_request_name">{{ t._('name') }}</label>
												<input type="text" class="form-control" id="new_request_name" name="name" placeholder="{{ t._('name') }}">
											</div>
											<div class="form-group col-md-6">
												<label for="new_request_email">{{ t._('email') }}</label>
												<input type="email" class="form-control" id="new_request_email" name="email" placeholder="{{ t._('email') }}">
											</div>
											<div class="form-group col-md-12">
												<label for="new_request_subject">{{ t._('subject') }}</label>
												<input type="text" class="form-control" id="new_request_subject" name="subject" placeholder="{{ t._('subject') }}">
											</div>
											<div class="form-group col-md-12">
												<label for="new_request_message">{{ t._('message') }}</label>
												<textarea class="form-control" id="new_request_message" name="message" rows="5" placeholder="{{ t._('message') }}"></textarea>
											</div>
										</div>
										<button type="submit" class="btn btn-default btn-primary">{{ t._('send_message') }}</button>
									</form>
								</div>

							</div>
						</div>

					</div>
				</div>
			</div>
		</div>
	</article>
</main>
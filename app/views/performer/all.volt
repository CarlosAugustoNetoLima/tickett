
<!-- LIGHT SECTION -->
<section class="lightSection clearfix pageHeader">
	<div class="container">
		<div class="row">
			<div class="col-md-12">
				<div class="page-title">
					<h2>{{ t._('Performers') }}</h2>
				</div>
			</div>

		</div>
	</div>
</section>

<section class=" clearfix blogPage">
	<div class="container">

		<div class="row">
			<div class="col-md-12">







				<div class="card-deck">

					<?php foreach ($performers as $performer)  : ?>
						<div class="card">
							<div class="card_img">
								<a href="{{ url() }}performer/{{ performer.slug }}">
									<?php if ( isset($performer->logo) ) : ?>
										<img class="img-fluid" src="{{ url() }}img/shows/{{ performer.logo }}" alt="{{ performer.name }}" >
									<?php endif ; ?>
								</a>
							</div>
							<div class="card-block">
								<a href="{{ url() }}performer/{{ performer.slug }}">
									<h3 class="card-title">
										{{ performer.name }}
									</h3>
								</a>
								<!--
									<a href="{{ url() }}performer/{{ performer.slug }}" class="btn btn-primary">
										{{ t._('Read more') }}
									</a>
								-->
							</div>
						</div>
					<?php endforeach ; ?>

				</div>



			</div>
		</div>

	</div>
</section>

<style type="text/css">
	.card-deck {
		margin: 30px 0;
	}
	.card {
		min-width: 200px;
		margin-bottom: 50px;
	}
</style>
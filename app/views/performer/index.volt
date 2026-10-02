
<!-- LIGHT SECTION -->
<section class="lightSection clearfix pageHeader">
	<div class="container">
		<div class="row">
			<div class="col-md-12">
				<div class="page-title">
					<h2>{{ performer.name }}</h2>
				</div>
			</div>

		</div>
	</div>
</section>

<section class=" clearfix blogPage">
	<div class="container">

		<div class="row">
			<div class="col-md-12">


				<p>{{ performer.description }}</p>

			</div>
		</div>

	</div>
</section>



<style type="text/css">
	.col-xs-12{
		width: 100%;
	}
	.btn-default {
	    color: #333;
	    background-color: #fff;
	    border-color: #ccc;
	}
</style>

<section class="mainContent clearfix blogPage">
	<div class="container">

		<div class="row">
		<div class="col-md-12">
			<h3>{{ t._('Shows com') }} {{ performer.name }}</h3>
			<br>
			{{ partial("events/slug", ['events': events, 'partial' : true]) }}
		</div>
		</div>
	</div>
</section>




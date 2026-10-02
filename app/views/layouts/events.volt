<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="msapplication-TileColor" content="#ffffff">
	<meta name="msapplication-TileImage" content="{{ url() }}ms-icon-144x144.png">
	<meta name="theme-color" content="#005D8A">

	{% if metaTitle is defined %}
		<title>{{ metaTitle }}</title>
	{% else %}
		<title>{{ config.company.title }}</title>
	{% endif %}

	<!-- Bootstrap CSS CDN -->
	<link href="//netdna.bootstrapcdn.com/bootstrap/3.1.0/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">


</head>
<script type="text/javascript">
	var BASE_URL = "{{ url() }}";
	var Translate = {
		button_loading: '{{ t._('button_checkout_loading') }}',
		email_sent: '{{ t._('Email sent') }}',
	};
</script>

<body>




	{{ content() }}



	<div class="container foot">
		<div class="row">
			<div class="col-xs-12 col-sm-offset-2 col-sm-8">
				<p>
					<a href="{{ url() }}">
						&copy; {{ config.company.name }}
					</a>
					&nbsp;
					<a href="?l=pt_br">
						<img src="{{ url() }}img/home/brazil-top.png" width="22px" height="16px" />
					</a>
					&nbsp;
					<a href="?l=en_us">
						<img src="{{ url() }}img/home/usa-top.png" width="22px" height="16px" />
					</a>
					&nbsp;
					<a href="?l=es_do">
						<img src="{{ url() }}img/home/spain-top.png" width="22px" height="16px" />
					</a>
				</p>
			</div>
		</div>
	</div>

	<style type="text/css">
		.foot a {
			text-decoration: none;
			color: #333;
		}
	</style>

</body>
</html>

<!doctype html>
<html lang="en">
<head>
	<!-- Required meta tags -->
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

	<!-- Bootstrap CSS -->
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css" integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4" crossorigin="anonymous">

	<title>tiktx | Extra Data</title>

	<!-- Icons -->
	<link rel="apple-touch-icon" sizes="57x57" href="{{ url() }}{{ config.company.logos }}apple-icon-57x57.png">
	<link rel="apple-touch-icon" sizes="60x60" href="{{ url() }}{{ config.company.logos }}apple-icon-60x60.png">
	<link rel="apple-touch-icon" sizes="72x72" href="{{ url() }}{{ config.company.logos }}apple-icon-72x72.png">
	<link rel="apple-touch-icon" sizes="76x76" href="{{ url() }}{{ config.company.logos }}apple-icon-76x76.png">
	<link rel="apple-touch-icon" sizes="114x114" href="{{ url() }}{{ config.company.logos }}apple-icon-114x114.png">
	<link rel="apple-touch-icon" sizes="120x120" href="{{ url() }}{{ config.company.logos }}apple-icon-120x120.png">
	<link rel="apple-touch-icon" sizes="144x144" href="{{ url() }}{{ config.company.logos }}apple-icon-144x144.png">
	<link rel="apple-touch-icon" sizes="152x152" href="{{ url() }}{{ config.company.logos }}apple-icon-152x152.png">
	<link rel="apple-touch-icon" sizes="180x180" href="{{ url() }}{{ config.company.logos }}apple-icon-180x180.png">
	<link rel="icon" type="image/png" sizes="192x192"  href="{{ url() }}{{ config.company.logos }}android-icon-192x192.png">
	<link rel="icon" type="image/png" sizes="32x32" href="{{ url() }}{{ config.company.logos }}favicon-32x32.png">
	<link rel="icon" type="image/png" sizes="96x96" href="{{ url() }}{{ config.company.logos }}favicon-96x96.png">
	<link rel="icon" type="image/png" sizes="16x16" href="{{ url() }}{{ config.company.logos }}favicon-16x16.png">
	<link rel="manifest" href="{{ url() }}{{ config.company.logos }}manifest.json">
	<meta name="msapplication-TileColor" content="#ffffff">
	<meta name="msapplication-TileImage" content="{{ url() }}{{ config.company.logos }}ms-icon-144x144.png">
	<meta name="theme-color" content="#4285f4">

</head>
<body>


	<div class="container">
		<div class="row">
			{{ content() }}


			<div class="col-sm-6">




				<div class="card">

					<img class="card-img-top" src="{{ url() }}img/shows/{{ ticket.Events.EventsImages[0].name }}" alt="Card image cap">
					<h5 class="card-header">
						{{ ticket.Events.name }}
						<small class="text-muted">
							&nbsp; <?php echo $this->getDI()->getFormatdates()->format($ticket->Events->date_start, '25/Jan/2000') ?>
						</small>
					</h5>

					<div class="card-body">
						{{ t._('product') }}:
						<h5 class="card-title">
							{{ ticket.Products.name }}
							<small>&nbsp; {{ ticket.Products.ProductsGenres.name }} - {{ ticket.ProductsTypes.name }}</small>
						</h5>
						<div class="card-text">



						</div>
					</div>

				</div>


			</div>
			<div class="col-sm-6">

				<h5 class="mb-4">{{ t._('Enter the required data') }}</h5>

				<form class="needs-validation" method="POST">


					<?php
						/* Percorre todos os dados extras já salvos no ticket para completar os que já estão preenchidos */
						$ticket_extra_data = $ticket->TicketExtraData;
						$array_extras_data = array();
						foreach ($ticket_extra_data as $key => $value)
						{
							$array_extras_data[$value->id_extra_data] = $value->value;
						}
					?>


					<?php
						/* Percorre todos dados extras vinculados ao evento/produto/tipo */
						foreach ($EventsExtraData as $key => $EventExtraData)  :

							/* Verificar se já tem algum valor salvo para este dado extra */
							$input_value = '';
							if ( isset($array_extras_data[$EventExtraData->id_extra_data]) )
							{
								$input_value = $array_extras_data[$EventExtraData->id_extra_data];
							}

					?>


						<?php
							/* Verifica se o dado extra esta preenchido e se é um dado que permite a edição */
							/* 0 -> NAO PODE EDITAR |  1 -> PODE EDITAR */
							/* Entao, se esta preenchido e nao permite edição, nao mostra o input  */
							if ( $EventExtraData->editable == 0 AND strlen($input_value) > 1 ) :
						?>

							<div class="form-group  ">
								<label for="extra_data_{{ key }}">{{ EventExtraData.ExtraData.name }}</label>
								<span  class="form-control text-info" >{{ input_value }}</span>
								<small  class="form-text text-muted">{{ EventExtraData.description }}</small>
							</div>

						<?php else : ?>

							<div class="form-group ">
								<label for="extra_data_{{ key }}">{{ EventExtraData.ExtraData.name }}</label>
								<input type="text" class="form-control" id="extra_data_{{ key }}"  placeholder="{{ EventExtraData.ExtraData.name }}" value="{{ input_value }}" name="extra_data[{{ EventExtraData.id_extra_data }}]" required>
								<div class="invalid-tooltip">
									{{ t._('required') }}
								</div>
								<small  class="form-text text-muted">{{ EventExtraData.description }}</small>
							</div>

						<?php endif ; ?>



					<?php endforeach ; ?>





					<button type="submit" class="btn btn-primary">{{ t._('Save') }}</button>
				</form>




			</div>
		</div>
	</div>



	<!-- Optional JavaScript -->
	<!-- jQuery first, then Popper.js, then Bootstrap JS -->
	<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js" integrity="sha384-cs/chFZiN24E4KMATLdqdvsezGxaGsi4hLGOzlXwp5UZB1LY//20VyM2taTB4QvJ" crossorigin="anonymous"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js" integrity="sha384-uefMccjFJAIv6A+rW+L4AHf99KvxDjWSu1z9VI8SKNVmz4sk7buKt/6v9KI65qnm" crossorigin="anonymous"></script>
</body>
</html>
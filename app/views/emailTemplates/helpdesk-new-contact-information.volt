<!doctype html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Helpdesk</title>
	<style type="text/css">
	table td { border: 0;}
	p { margin: 20px 30px; letter-spacing: 1px; }
	@media only screen and (max-width: 600px) {
		.wrapper{width:95% !important;}
	}
</style>
</head>
<body style="margin:0; padding:0; background-color:#FFFFFF">
	<center>
		<table border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="#FFFFFF" class="wrapper">



			<tbody style="width: 100%">
				<tr style="width: 100%">
					<td style="padding:10px;">


						<h4>Olá administrador </h4>
						<small><i>Recebemos um novo contato em nosso site</i></small>
						<br><br>
						<hr>

						<table border="1" cellpadding="0" cellspacing="0" width="100%" style="width: 100%">
							<thead>
								<tr>
									<th scope="col">{{ t._('date') }}</th>
									<th scope="col">{{ t._('author') }}</th>
									<th scope="col">{{ t._('message') }}</th>
								</tr>
							</thead>
							<tbody>
								<?php foreach ( $helpdesk->HelpdeskAnswers AS $answers ) : ?>
									<tr style="border: 1px solid #333" >
										<td scope="row">
											<?php echo date('d/m/Y H:i', strtotime($answers->created_at)) ?>
										</td>
										<td>{{ answers.author }}</td>
										<td>{{ answers.message|nl2br }}</td>
									</tr>
								<?php endforeach ; ?>
							</tbody>
						</table>

						<hr>
						<a href="https://sup.lebillet.com.br/helpdesk/show/{{ helpdesk.id }}">
							<b>Clique aqui para responder</b>
						</a>
						<hr>
						<small><i>Enviado em : <?php echo date('Y/m/d  -  H:i:s') ?></i></small>
						<br>
					</td>
				</tr>
			</tbody>


		</table>

	</center>

</body>

</html>
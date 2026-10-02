
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">

	<title>{{ config.company.full_name }}</title>
	<style type="text/css">a {color:#00405a; }</style>

</head>
<body style="margin:0; padding:0; background-color:#545454; font-family: Roboto, sans-serif; letter-spacing: 0,8pt;">
	<center>
		<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#545454">
			<tr>
				<td align="center" valign="top">


					<table width="600px" cellpadding="0" cellspacing="0" border="0"  bgcolor="#FFF"  style="width:600px;">


						<tr>
							<td  valign="top" >
								<table  width="600px" height="260px;"  cellspacing="0" cellpadding="0" border="0"   background="https://lebillet.com.br/img/email/template_header.png?v=5" bgcolor="#013753"valign="top" style="  width:600px; color: #FFF; font-size: 300%; background-image:url('https://lebillet.com.br/img/email/template_header.png?v=5'); background-repeat:no-repeat;background-size: 600px 265px;background-position:top center;">

									<tr>

										<td width="500px" align="right" valign="middle" style=" ">

											Transferência
											<br>
											concluída!
										</td>

										<td width="100px" align="center" valign="middle" style=" ">
											<img src="https://lebillet.com.br/img/email/template_check.png" />
										</td>

									</tr>


									<tr>
										<td colspan="2" >

										</td>
									</tr>
								</table>
							</td>
						</tr>




						<tr  cellspacing="0" cellpadding="0" border="0"  bgcolor="#FFF" style=" background-color:#FFF;"  >
							<td align="center" valign="top" cellspacing="0" cellpadding="0" border="0"  style="color:#00405a; padding: 20px; background-color:#FFF" >





								<p>
									A solicitação de transferência do evento <b>{{ transfer.Events.name }}</b> foi realizada com sucesso.
								</p>



								<table  cellspacing="10" cellpadding="10" >

									<tr>
										<td align="right" valign="top">
											<b>Favorecido<b>
										</td>

										<td align="left" valign="middle">
											<?php echo nl2br($transfer->recipient) ?>
										</td>
									</tr>

									<tr>
										<td align="right" valign="top">
											<b>Conta<b>
										</td>

										<td align="left" valign="middle">
											<?php echo nl2br($transfer->account) ?>
										</td>
									</tr>

									<tr>
										<td align="right" valign="top">
											<b>Valor<b>
										</td>

										<td align="left" valign="middle">
											<?php echo number_format($transfer->total_value, 2) ?>
										</td>
									</tr>

									<?php if ( $transfer->file )  : ?>
									<tr>
										<td align="right" valign="top">
											<b>Comprovante<b>
										</td>

										<td align="left" valign="middle">
											<a class="badge badge-pill badge-success" target="_blank" href="{{ url() }}transfers/{{ transfer.file }}">
												Visualizar
											</a>
										</td>
									</tr>
									<?php endif ; ?>


								</table>


								<p>
									Para mais informações, acompanhe o
									 <a target="_blank" href="{{ url() }}{{ transfer.id_event }}/balance">
									 	<b>Balanço Financeiro</b>
									 </a>
									de seu evento
								</p>




							</td>
						</tr>





						<tr>
							<td align="center" valign="top"  cellspacing="0" cellpadding="0" border="0"   background="https://lebillet.com.br/img/email/template_footer.png" bgcolor="#FFF" height="16px;"  style="  width:100%; color: #fff; font-size: 50px; background-image:url('https://lebillet.com.br/img/email/template_footer.png'); background-repeat:no-repeat;" >

							</td>
						</tr>


						<tr>
							<td align="center" valign="top" style="background-color: #e3eef2; color: #00405a; padding: 20px; ">




								<p>
									<b>{{ config.company.name }}</b>: <small>Inovação, Segurança e Tecnologia de ponta!</small>
								</p>

								<p><br></p>

								<a target="_blank" href="https://lebillet.com.br/">
									<img src="https://lebillet.com.br/{{ config.company.logos }}logo.png" />
								</a>

								<p><br></p>

							</td>
						</tr>

						<tr >
							<td align="center" valign="top" style="background-color: #fff; padding: 1px; ">

							</td>
						</tr>

						<tr >
							<td align="center" valign="top" style="background-color: #e3eef2; color: #00405a; padding: 5px; font-size: 80%; ">

								<p>
									Este é um e-mail automático, <b style="text-decoration: underline; text-decoration-color: red;">favor não responder.</b>
								</p>

							</td>
						</tr>


					</table>

				</td>
			</tr>

		</table>
	</center>
</body>
</html>
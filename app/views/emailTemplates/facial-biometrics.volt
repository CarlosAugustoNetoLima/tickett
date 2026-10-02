
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">

	<title>{{ config.company.full_name }}</title>

	<style type="text/css">a {color:#006e91; }</style>

</head>
<body style="margin:0; padding:0; background-color:#545454; font-family: Roboto, sans-serif; letter-spacing: 0,8pt;">
	<center>
		<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#545454">
			<tr>
				<td align="center" valign="top">


					<table width="600px" cellpadding="0" cellspacing="0" border="0"  bgcolor="#FFF"  style="width:600px;">


						<tr>
							<td  valign="top" >
								<img src="{{ url() }}img/email/biometrics_Header.png?v=1">
							</td>
						</tr>



						<tr  cellspacing="0" cellpadding="0" border="0"  bgcolor="#FFF" style=" background-color:#FFF;"  >
							<td align="center" valign="top" cellspacing="0" cellpadding="0" border="0"  style="color:#006e91; padding: 20px; background-color:#FFF" >




							<p style="font-size: 150%;">
								<b>
									<span style="font-size: 250%;">Olá,</span>
									<br>
									{{ order.Customers.name }}
								</b>
							</p>

							<br>

							<p>
								Sua segurança está em primeiro lugar, <br>
								por isso precisamos confirmar seus dados  <br>
								antes de concluirmos sua compra
							</p>


							<br>

							<p>
								Para isso você deve concluir sua identificação. <br>
								Não vai demorar 2 minutos!
							</p>

							<br>

							<p>
								Este processo deve ser realizado em até 24 horas após a compra<br>
								Caso não seja realizado, sua compra poderá ser cancelada.
							</p>


							<br>

							<?php
								$customer = $order->Customers;
								$id_customer = $customer->id;
								$email = $customer->email;
								$string = $id_customer . '##' . $email;
								$t = base64_encode($this->crypt->encryptBase64($string));
								$u = base64_encode($this->crypt->encryptBase64('account/verify'));
							?>
							<a href="{{ url() }}account/login/?t={{ t }}&u={{ u }}">
							<img src="{{ url() }}img/email/biometrics_CliqueAqui.png" />
							</a>




							</td>
						</tr>





						<tr>
							<td align="center" valign="top"  cellspacing="0" cellpadding="0" border="0"   background="{{ url() }}img/email/template_footer.png" bgcolor="#FFF" height="16px;"  style="  width:100%; color: #fff; font-size: 50px; background-image:url('{{ url() }}img/email/template_footer.png'); background-repeat:no-repeat;" >

							</td>
						</tr>


						<tr>
							<td align="center" valign="top" style="background-color: #e3eef2; color: #006e91; padding: 20px; ">


								<?php if ( COMPANY == 'lebillet' ) : ?>
									<p>
										Ah... Todos os seus dados serão guardados <br>
										conforme a Lei Geral de Proteção de Dados.
									</p>
								<?php endif ; ?>


								<p><br></p>

								<a target="_blank" href="{{ url() }}"><img src="{{ url() }}{{ config.company.logos }}logo.png" /></a>

								&nbsp; &nbsp; &nbsp;

								<a target="_blank" href="{{ url() }}"><img src="{{ url() }}img/email/biometrics_Slogan.png" /></a>

								<p><br></p>

							</td>
						</tr>

						<tr >
							<td align="center" valign="top" style="background-color: #fff; padding: 1px; ">

							</td>
						</tr>

						<tr >
							<td align="center" valign="top" style="background-color: #e3eef2; color: #006e91; padding: 5px; font-size: 80%; ">

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

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
								<table  width="600px" height="260px;"  cellspacing="0" cellpadding="0" border="0"   background="{{ url() }}img/email/template_header.png?v=5" bgcolor="#013753"valign="top" style="  width:600px; color: #FFF; font-size: 300%; background-image:url('{{ url() }}img/email/template_header.png?v=5'); background-repeat:no-repeat;background-size: 600px 265px;background-position:top center;">

									<tr>

										<td width="500px" align="right" valign="middle" style=" ">
											Confirmação
											<br>
											 de reserva
											<br>
											<br>
										</td>

										<td width="100px" align="center" valign="middle" style=" ">
											<img src="{{ url() }}img/email/template_check.png" />
											<br>
											<br>
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
							<td  valign="top" cellspacing="0" cellpadding="0" border="0"  style="color:#00405a; padding: 20px; background-color:#FFF" >






							<p style="font-size: 200%;">
								Olá <?php echo  $customer ? $customer->name : '' ?>
							</p>

							<br>

							<p>
								Obrigado por ter escolhido a LeBillet.
								<br>
								<br>
								Junto enviamos os dados necessários para efetuar o pagamento da sua reserva na rede Multibanco.
							</p>


							<br>


										<table width="100%"  cellpadding="5" cellspacing="0" border="0">
											<tbody>

												<tr>
													<td align="center" rowspan="5" class="no-border">
														<img src="{{ url() }}img/payments/multibanco.png" >
													</td>
												</tr>

												<tr>
													<td align="right" class="no-border">
														Entidade:
													</td>
													<td class="no-border">
														<b>{{ entity }}</b>
													</td>
												</tr>

												<tr>
													<td align="right">
														Referência:
													</td>
													<td>
														<b>{{ reference }}</b>
													</td>
												</tr>

												<tr>
													<td align="right">
														Valor:
													</td>
													<td>
														<b>€&nbsp;{{ value }}</b>
													</td>
												</tr>

												<tr>
													<td align="right">
														<br>
														<small>
															Validade:
														</small>
													</td>
													<td>
														<br>
														<small>
															{{ expireDate }}
														</small>
													</td>
												</tr>

											</tbody>
										</table>






							<br>

							<p>
								Reserva temporária: {{ order.id }}
								<br>
								<br>



								Depois de efetuado o pagamento, receberá, um email de confirmação com seus bilhetes
								<br>
								<br>

								Tanto este documento como o talão de multibanco não poderão ser utilizados como título de entrada.
								<br>
								<br>

								Para qualquer esclarecimento, <a href="{{ url() }}helpdesk"  style="text-decoration: underline;">contacte-nos</a>

							</p>



							</td>
						</tr>





						<tr>
							<td align="center" valign="top"  cellspacing="0" cellpadding="0" border="0"   background="{{ url() }}img/email/template_footer.png" bgcolor="#FFF" height="16px;"  style="  width:100%; color: #fff; font-size: 50px; background-image:url('{{ url() }}img/email/template_footer.png'); background-repeat:no-repeat;" >

							</td>
						</tr>


						<tr>
							<td align="center" valign="top" style="background-color: #e3eef2; color: #00405a; padding: 20px; ">




								<p>
									<b>LeBillet.pt</b>: <small>Inovação, Segurança e Tecnologia de ponta!</small>
								</p>

								<p><br></p>

								<a target="_blank" href="{{ url() }}">
									<img src="https://tickett.com/brand/logo_dark.png" alt="Tickett" style="width: 200px; height: auto;" />
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
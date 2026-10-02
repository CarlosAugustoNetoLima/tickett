
<!doctype html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<!--<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">-->
	<meta name="viewport" content="initial-scale=1">


</head>
<style type="text/css">
	html {
		width:350px;
		margin: 0 auto;
	    padding: 0px;
		background: #FFF;
	}
	body {
	font-family: "Mister Giacco", serif;
	margin: 0 auto;
    padding: 0;
	display: block;
	background: #FFF;
	width:350px;
}
</style>
<body>

<!-- tabela do header -->
<table cellspacing="0" cellpadding="0" border="0" align="center" style="width:350px;" bgcolor="#FFF">
	<tr>
		<td align="center" valign="top" style=" ">

			<table   cellspacing="0" cellpadding="10" align="center" style="  max-width:350px; border: 3px solid #066a8e; border-top: 0; color: #066a8e; font: normal bold 15px  Arial, Helvetica, sans-serif; ">
				<tr>
					<td width="45%" align="center" valign="middle" style="border-top: 3px solid #066a8e; text-align: center;">
						logo.png
					</td>
					<td width="10%" align="center" valign="top" style="padding: 0; margin: 0;" >
						<div style=" border: 3px solid #066a8e; border-radius: 0 0 90px 90px; border-top: 0; width: 50px; height: 30px;">
							&nbsp;
						</div>
					</td>
					<td width="45%" align="center" valign="middle" style="font-size: 18px; border-top: 3px solid #066a8e; text-align: center;">
						25/Jan/2000
						<br>
						17:00h
					</td>
				</tr>

				<tr>
					<td colspan="3" align="center" valign="middle" style=" ">
						Events->logo

					</td>
				</tr>

				<tr>
					<td colspan="3" align="left" valign="middle" style="font-size: 18px; ">
						 ticket.Events.name
					</td>
				</tr>

				<tr>
					<td colspan="2" width="100%" align="left" valign="top" style=" ">
						{{ ticket.Events.Places.name }}
						<br>
						{{ ticket.Events.Cities.name}} - {{ ticket.Events.Regions.acronym }}


						<br>
						<br>
						<small>{{ t._('Responsible') }}:</small>
						<br>
						{{ ticket.Events.Organizers.name }}
						<br>
						<small>{{ ticket.Events.Organizers.doc }}</small>

					</td>
					<td width=" " align="right" valign="top" >
							<small>{{ t._(ticket.Sales.PaymentTypes.name) }}</small>
							<br>
							6,66

					</td>
				</tr>

				<tr>
					<td colspan="3" align="center" valign="top" style=" ">
							{{ ticket.Sales.Orders.Customers.name }}
					</td>
				</tr>
				<tr style="color: #333;">

					<td colspan="3" align="center" valign="top" style=" ">

						<h3 style="margin: 10px;">
							{{ ticket.Products.name }}
								&nbsp;({{ ticket.ProductsSeats.label }})
							<br>

							{{ label }}


						</h3>

						<img class="mx-auto img-qrcode" src="<?php echo base64_decode($_REQUEST['qrcode']) ?>" />

						<p style="letter-spacing: 2px; margin-bottom: 0;">
							{{ ticket.ticket }}


								<small>({{ ticket.product_sequence }}/{{ ticket.fraction }})</small>


						</p>


							<p style="margin-bottom: 0; font-weight: normal;">
								<small>{{ ticket.Products.description }}</small>
							</p>

					</td>
				</tr>



			</table>


		</td>
	</tr>

</table>



</body>
</html>
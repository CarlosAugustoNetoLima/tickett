
<main class="section payment_msg" >
	<div class="container">

		<div class="row">
			<div class="col-md-12 col-sm-12 text-center">
				<p><br></p>
				<p><br>

					<img src="{{ url() }}img/payments/payment_pending.png" />

					<h1>{{ t._('Pending payment') }}</h1>
				</p>
				<p><br></p>

				<p >
					Sua compra esta pendente. Iremos te encaminhar a confirmação
					<br>
					logo que recebermos o aviso de pagamento.
				</p>

				<p><br></p>

				<p>
					Caso seja preciso, <a href="{{ url() }}helpdesk"><b>entre em contato</b></a> conosco
				</p>
			</div>
		</div>

	</div>
</main>



<link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Montserrat&display=swap" rel="stylesheet">
<style type="text/css">
	.payment_msg {
		font-family: 'Montserrat', sans-serif;
		color: #096F94;
	}
	.payment_msg h1 {
		font-weight: 800;
	}

</style>
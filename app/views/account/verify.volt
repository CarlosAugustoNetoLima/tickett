<section class="page-title">
	<div class="container">
		<h1 class="title">Biometria Facial</h1>
	</div>
</section>

{{ partial('account/menu') }}

<section class="internal-menu">
	<div class="container">
		{{ content() }}
		{{ flashSession.output() }}
	</div>
</section>

<?php if ( in_array( $customer->verify, array(0,1) )  ) :   /*  NOVO ou JÁ CAIU NO ANTIFRAUDE  */ ?>



<script src="{{ url() }}plugins/jquery/jquery.min.js"></script>
<script src="{{ url() }}plugins/jquery/jquery-migrate-3.0.0.min.js"></script>



<section class="page-profile verify">
	<form class="form" method="POST" action="{{ url() }}account/verify" enctype="multipart/form-data" id="form_active" onsubmit="$('.infoTamanhoBtn button').attr('disabled','disabled');">
		<div class="container">
			<div class="row">

				<div class="col-md-4">
					<div class="row">
						<div class="col col-sm-12 col-md-11 card">
							<div class="img">
								<label for="documento_frente">
									<img src="{{ url() }}/img/bf/identidade-01.png" style="max-width: 100%;  height: 200px;" id="documento_frente_img"  />
								</label>
							</div>
							<div class="title">
								Envie a frente do documento e do cartão utilizado na compra
							</div>
							<div class="text01 mb16">
								Insira a imagem do cartão com os numeros do mesmo (pode ocultar a validade e o código de segurança)
							</div>
							<div class="upload">
								<label for="documento_frente" class="upload-photo">
									<div>Capturar a imagem</div>
									<img src="{{ url() }}/img/bf/biometria-botao-inserir-imagem.png" height="30px;"/>
								</label>
								<div style="text-align: center;  color: #C0C0C0; font-size: 12px;">Você pode utilizar a câmera de seu celular</div>
								<input type="file" accept="image/*"  capture="camera"  name="files[]" id="documento_frente" />
							</div>
							<div class="d-md-none ">
								<div class="upload">
									<label for="documento_frente_anexo" class="upload-photo">
										<div>Anexar uma imagem</div>
										<img src="{{ url() }}/img/bf/biometria-botao-inserir-imagem-anexo.png" height="30px;"/>
									</label>
									<div style="text-align: center;    color: #C0C0C0; font-size: 12px;">Ou selecione um arquivo para anexar</div>
									<input type="file" accept="image/*" name="files[]" id="documento_frente_anexo" />
								</div>
							</div>
							<div class="text02">
								Posicione o cartão e o documento juntos e caputre uma imagem nítida dos mesmos
							</div>


						</div>
						<div class="d-sm-none d-md-block col-md-1"></div>
					</div>
				</div>

				<div class="col col-sm-12 d-md-none d-sm-block">&nbsp;</div>

				<div class="col-md-4">
					<div class="row">
						<div class="col col-sm-12 col-md-11 card">
							<div class="img">
								 <label for="documento_verso"  >
									<img src="{{ url() }}/img/bf/identidade-02.png" style="max-width: 100%; height: 200px;"   id="documento_verso_img" />
								</label>
							</div>
							<div class="title">
								Envie a verso do documento
							</div>
							<div class="text01 mb16">
								Insira abaixo a imagem da verso do documento.
							</div>
							<div class="upload">
								<label for="documento_verso" class="upload-photo">
									<div>Capturar a imagem</div>
									<img src="{{ url() }}/img/bf/biometria-botao-inserir-imagem.png" height="30px;" />
								</label>
								<div style="text-align: center;    color: #C0C0C0; font-size: 12px;">Você pode utilizar a câmera de seu celular</div>
								<input type="file" accept="image/*"  capture="camera"  name="files[]" id="documento_verso" />
							</div>
							<div class="d-md-none ">
								<div class="upload">
									<label for="documento_verso_anexo" class="upload-photo">
										<div>Anexar uma imagem</div>
										<img src="{{ url() }}/img/bf/biometria-botao-inserir-imagem-anexo.png" height="30px;"/>
									</label>
									<div style="text-align: center;    color: #C0C0C0; font-size: 12px;">Ou selecione um arquivo para anexar</div>
									<input type="file" accept="image/*" name="files[]" id="documento_verso_anexo" />
								</div>
							</div>
							<div class="text02">
								O comprovante precisa estar legivel para os dados serem conferidos.
							</div>
						</div>
						<div class="d-sm-none d-md-block col-md-1"></div>
					</div>
				</div>

				<div class="col col-sm-12 d-md-none d-sm-block">&nbsp;</div>

				<div class="col-md-4">
					<div class="row">
						<div class="col col-sm-12 col-md-11 card">
							<div class="img">
								<label for="documento_selfie" >
									<img src="{{ url() }}/img/bf/identidade-03.png"  style="max-width: 100%;  height: 200px;"   id="documento_selfie_img" />
								</label>
							</div>
							<div class="title">
								Selfie com o documento
							</div>
							<div class="text01">
								Insira abaixo a imagem sua (selfie) segurando o mesmo documento de identificação.
							</div>
							<div class="upload">
								<label for="documento_selfie" class="upload-photo">
									<div>Insira a imagem aqui</div>
									<img src="{{ url() }}/img/bf/biometria-botao-inserir-imagem.png" height="30px;"/>
								</label>
								<div style="text-align: center;    color: #C0C0C0; font-size: 12px;">Você pode utilizar a câmera de seu celular</div>
								<input type="file" accept="image/*"  capture="camera"  name="files[]" id="documento_selfie" required="required" />
							</div>
							<div class="text02">
								Na foto devem aparecer seu rosto e a Identidade utilizada. Faça igual ao modelo acima
							</div>
						</div>
					</div>
				</div>

				<div class="col col-sm-12">&nbsp;</div>
			</div>

			<div class="row">
				<div class="col-12">
					<div class="row flex">
						<div class="col d-none d-md-block col-md-6 infoTamanho">
							<div class="row">
								<div class="col-md-1" style="padding-left:50px;padding-right:0px;">
									<img src="{{ url() }}/img/bf/alert-icon.png" height="30"/>
								</div>
								<div class="col-md-11" style="padding-left:0px;">
									Arquivos png, jpg, jpeg e etc.<br>
									O Tamanho máximo permitido para qualquer imagem é de 4MB.
								</div>
							</div>
						</div>
						<div class="col d-none col-md-2 d-sm-none d-md-block infoTamanhoBtn">
							<button>FINALIZAR</button>
						</div>
					</div>
				</div>
			</div>

			<div class="row">
				<div class="col col-12 d-block d-sm-none d-md-none infoTamanho pdt30 pdb30">
					<img src="{{ url() }}/img/bf/alert-icon.png" height="30"/><br>
					Arquivos png, jpg, jpeg e etc.<br>
					O Tamanho máximo permitido para qualquer imagem é de 4MB.
				</div>
				<div class="col-12 d-block d-sm-none d-md-none infoTamanhoBtn">
					<button>FINALIZAR</button>
				</div>
			</div>

		</div>
	</form>
</section>
<script>
$("input[type='file']" ).change(function(e) {
	var id = $(this).attr('id');
	var file = e.target.files[0];
	$('#' + id + '_img').attr('src', URL.createObjectURL(file));
	$(this).parent().children("label").children("div").html($(this).val().split("\\")[2]);
});
</script>


<?php elseif( $customer->verify == 2 ) :   /*  ENVIOU OS DADOS - Falta analisar  */  ?>




<section class="page-last-orders">
	<div class="container">
		<div class="page-last-orders-inner internal-page">
			<div class="internal-page-title">
				<h2 class="title">{{ t._('Hello') }} <span class="title-featured">{{ customer.name }}</span></h2>
			</div>

			<p>
				Recebemos seus dados e estamos efetuando as verificações necessárias
			</p>

			<p>
				Por favor aguarde este processo.
			</p>


		</div>
	</div>
</section>


<?php elseif( $customer->verify == 3 ) :   /*  APROVADO */  ?>

<section class="page-last-orders">
	<div class="container">
		<div class="page-last-orders-inner internal-page">
			<div class="internal-page-title">
				<h2 class="title">{{ t._('Hello') }} <span class="title-featured">{{ customer.name }}</span></h2>
			</div>

			<p>
				Já validamos seu cadastro. Esta tudo correto
			</p>


		</div>
	</div>
</section>

<?php elseif( $customer->verify == 4 ) :   /*  Reprovado */  ?>

	<section class="page-last-orders">
	<div class="container">
		<div class="page-last-orders-inner internal-page">
			<div class="internal-page-title">
				<h2 class="title">{{ t._('Hello') }} <span class="title-featured">{{ customer.name }}</span></h2>
			</div>

			<p>
				Não conseguimos aprovar seu cadastro com base nos dados enviados.
			</p>


		</div>
	</div>
</section>

<?php else : ?>
	<section class="page-last-orders">
	<div class="container">
		<div class="page-last-orders-inner internal-page">
			<div class="internal-page-title">
				<h2 class="title">{{ t._('Hello') }} <span class="title-featured">{{ customer.name }}</span></h2>
			</div>

			<p>
				Caso tenha problemas com seu cadastro, por favor <a href="{{ url() }}helpdesk">fale conosco</a>
			</p>


		</div>
	</div>
</section>
<?php endif ; ?>


<style type="text/css">
	.verify .card #documento_frente_anexo {
	    opacity: 0;
	    position: absolute;
	    z-index: -1;
	}
</style>
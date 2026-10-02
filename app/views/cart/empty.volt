
<!-- LIGHT SECTION -->
<section class="lightSection clearfix pageHeader">
	<div class="container">
		<div class="row">
			<div class="col">
				<div class="page-title">
					<h2>{{ t._('cart') }}</h2>
				</div>
			</div>
		</div>
	</div>
</section>

<div class="container">
	<div class="row">
		{{ content() }}
		<div class="alert alert-danger" role="alert">
			<h1>Você ainda não adicionou produtos no carrinho de compras</h1>
		</div>
	</div>
</div>
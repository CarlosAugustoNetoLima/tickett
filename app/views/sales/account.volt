
<style type="text/css">
	.card form label {
		text-align: right;
	}
</style>

<div class="container">
	<div class="row">
		<div class="col-12">


			{{ content() }}


			<div class="card">
				<h5 class="card-header">{{ t._('My account') }}</h5>
				<div class="card-body">



					<form method="post">

						<div class="form-group row">
							<label for="name" class="col-sm-2 col-form-label">{{ t._('Point of Sale') }}:</label>
							<div class="col-sm-10">
								<span  class="form-control-plaintext" >
								{{ seller.SalesPoints.name }}
								</span>
							</div>
						</div>

						<div class="form-group row">
							<label for="name" class="col-sm-2 col-form-label">{{ t._('Terminal') }}:</label>
							<div class="col-sm-10">
								<span  class="form-control-plaintext" >
								{{ seller.name }}
								</span>
							</div>
						</div>

						<div class="form-group row">
							<label for="email" class="col-sm-2 col-form-label">{{ t._('Email') }}:</label>
							<div class="col-sm-10">
								<span  class="form-control-plaintext" >
								{{ seller.email }}
								</span>
							</div>
						</div>

						<div class="form-group row">
							<label for="password" class="col-sm-2 col-form-label">{{ t._('Password') }}:</label>
							<div class="col-sm-10">
								<input type="password" name="password" class="form-control" id="password" placeholder="Password">
							</div>
						</div>

						<div class="form-group row">
							<label   class="col-sm-2 col-form-label"></label>
							<div class="col-sm-10">
								<button type="submit" class="btn btn-primary">{{ t._('Change Password') }}</button>
							</div>
						</div>

					</form>



				</div>
			</div>





		</div>
	</div>
</div>


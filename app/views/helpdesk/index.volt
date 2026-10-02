<style type="text/css">


</style>


<main>
	<article class="internal-content">
		<div class="container">

				<div class="content-text">
					<div class="text-group">

						<section class="lightSection clearfix pageHeader">
							<div class="container">
								<div class="row">
									<div class="col">
										<div class="page-title">
											<h2>{{ t._('helpdesk') }}</h2>
										</div>
									</div>
								</div>
							</div>
						</section>

						<div class="container pt-5">
							{{ content() }}
							<div class="row">


								<!--
								<div class="col">
									<div class="page-header">
										<h4>{{ t._('already_helpdesk') }}</h4>
									</div>

									<p class=" pt-5"></p>
								</div>
							-->



								<div class="col">

									<div class="page-header">
										<h4>{{ t._('How can we help you?') }}</h4>
									</div>
									<?php if($customer == NULL){ ?>
										<div>
											<div class="row" id="btnlogin">
												<div class="form-group col-md-12">
													<br>Se ainda não for nosso cliente, favor utilizar o chat no canto inferior da página. <br><br>
	
													Caso já tenha uma conta, faça o login no botão abaixo:
												</div>
												
												<div class="form-group col-md-12">
													<a class="btn btn-default btn-primary" href="{{ url() }}account/login?helpdesk=1">Fazer login</a>
												</div>
											</div>
											
										</div>
										<?php } else{?>





									<div class="accordion" id="accordionHelpdesk">

									<div class="card-body" id="formsHelpdesk">

														<form class="" method="POST" action="{{ url() }}helpdesk/new"  onsubmit="$('.button-submit').attr('disabled','disabled');">
															<input type="hidden" name="action" value="new">
															<div class="row">

																<div class="form-group col-md-6">
																	<label for="new_request_name">{{ t._('name') }}</label>
																	<input type="text" class="form-control" id="new_request_name" name="name" placeholder="{{ t._('name') }}">
																</div>

																<div class="form-group col-md-6">
																	<label for="new_request_email">{{ t._('email') }}</label>
																	<input type="email" class="form-control" id="new_request_email" name="email" placeholder="{{ t._('email') }}">
																</div>

																<div class="form-group col-md-12">
																	<label for="new_request_event">{{ t._('Event') }}</label>
																	<select  class="form-control" id="new_request_event" name="event" placeholder="{{ t._('event') }}">
																		<option></option>
																		<?php foreach ( $events AS $event ) : ?>
																			<option value="{{ event.id }}" >
																				<?php echo $this->getDI()->getFormatdates()->format($event->date_start, '25/Jan/2000');?>
																				&nbsp; - &nbsp;
																				{{ event.name }}
																			</option>
																		<?php endforeach ; ?>
																	</select>
																</div>

																<div class="form-group col-md-12">
																<label for="new_request_subject">{{ t._('subject') }}</label>
																<select  class="form-control" id="new_request_subject" name="subject" placeholder="{{ t._('subject') }}" requerid="requerid">
																		<option></option>
																		<!-- <option value="DÚVIDAS SOBRE BIOMETRIA" >DÚVIDAS SOBRE BIOMETRIA</option> -->
																		<option value="INGRESSO CANCELADO / CANCELAMENTO DE INGRESSO" >INGRESSO CANCELADO / CANCELAMENTO DE INGRESSO</option>
																		<option value="TROCA DE INGRESSOS" >TROCA DE INGRESSOS</option>
																		<option value="EVENTO CANCELADO" >EVENTO CANCELADO</option>
																		<option value="REENVIO DE INGRESSOS / NÃO RECEBI MEU INGRESSO" >REENVIO DE INGRESSOS / NÃO RECEBI MEU INGRESSO</option>
																		<option value="NOME NO INGRESSO" >NOME NO INGRESSO</option>
																		<option value="DÚVIDAS SOBRE MEIA ENTRADA" >DÚVIDAS SOBRE MEIA ENTRADA</option>
																		<option value="ERRO/FALHA NO PAGAMENTO" >ERRO/FALHA NO PAGAMENTO</option>
																		<option value="INFORMAÇÕES GERAIS / DÚVIDAS SOBRE O EVENTO" >INFORMAÇÕES GERAIS / DÚVIDAS SOBRE O EVENTO</option>
																	</select>
																</div>

																<?php if($customer != NULL){ ?>
																	<div class="form-group col-md-12">
																		<label for="new_request_subject">{{ t._('Order') }}</label>
																		<select  class="form-control" id="new_request_order" name="order" placeholder="{{ t._('Order') }}" requerid="requerid">
																			<option></option>
																			<?php foreach($orders as $o): ?>
																			<option value="<?php echo $o->id; ?>"><?php echo $o->id. ' - ' .$o->Sales[0]->Events->name; ?></option>
																			<?php endforeach; ?>
																		</select>
																	</div>
																	<?php } ?>
																	
																<div class="form-group col-md-12">
																	<label for="new_request_message">{{ t._('message') }}</label>
																	<textarea class="form-control" id="new_request_message" name="message" rows="5" placeholder="{{ t._('message') }}"></textarea>

																	<?php if ( COMPANY == 'lebillet' ) : ?>
																		<p>
																			Para contato sobre cancelamento, <b>acesse sua compra e realize o processo: &nbsp; <a href="{{ url() }}account/orders">{{ url() }}account/orders</a> </b>
																		</p>
																	<?php endif ; ?>

																</div>

																<div class="form-group col-md-12">
																	 <div class="g-recaptcha" data-sitekey="<?php echo $recaptcha; ?>"></div>
																</div>

															</div>
															<button type="submit" class="btn btn-default btn-primary  button-submit">{{ t._('send_message') }}</button>
														</form>
												</div>

										<?php if ( COMPANY == 'lebillet' ) : ?>
											<!-- <div class="card">
												<div class="card-header" id="heading2">
													<h2 class="mb-0">
														<button class="btn btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#collapse2" aria-expanded="false" aria-controls="collapse2">
															<b>{{ t._('I want to cancel my purchase') }}</b>
														</button>
													</h2>
												</div>
												<div id="collapse2" class="collapse" aria-labelledby="heading2" data-parent="#accordionHelpdesk">
													<div class="card-body">

														<p>
															O cancelamento deve ser realizado pelo cliente diretamente em nosso site, atendendo as regras e políticas do site:
															https://lebillet.com.br/company/policies_procedures
														</p>


														<b>
															<p>Acesse suas compras e realize o processo: &nbsp; <a href="{{ url() }}account/orders">{{ url() }}account/orders</a>  </p>
														</b>
													</div>
												</div>
											</div> -->
										<?php endif ; ?>

										<!--

										<div class="card">
											<div class="card-header" id="heading1">
												<h2 class="mb-0">
													<button class="btn btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#collapse1" aria-expanded="true" aria-controls="collapse1">
														{{ t._("I didn't receive my tickets") }}
													</button>
												</h2>
											</div>

											<div id="collapse1" class="collapse " aria-labelledby="heading1" data-parent="#accordionHelpdesk">
												<div class="card-body">

													<p>Suas compras estão disponíveis em sua conta</p>

													<p>Acessar a conta: <a href="{{ url() }}account/orders">{{ url() }}account/orders</a>  </p>
												</div>
											</div>
										</div>


										<div class="card">
											<div class="card-header" id="heading3">
												<h2 class="mb-0">
													<button class="btn btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#collapse3" aria-expanded="false" aria-controls="collapse3">
														{{ t._('I need help with another matter') }}
													</button>
												</h2>
											</div>
											<div id="collapse3" class="collapse" aria-labelledby="heading3" data-parent="#accordionHelpdesk">
												
											</div>
										</div>




										<div class="card">
											<div class="card-header" id="heading4">
												<h2 class="mb-0">
													<button class="btn btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#collapse4" aria-expanded="false" aria-controls="collapse4">
														{{ t._('I want to view an existing service') }}
													</button>
												</h2>
											</div>
											<div id="collapse4" class="collapse" aria-labelledby="heading4" data-parent="#accordionHelpdesk">
												<div class="card-body">
													<form class="" method="POST" action="{{ url() }}helpdesk"  onsubmit="$('.button-submit').attr('disabled','disabled');">
														<input type="hidden" name="action" value="view">
														<div class="row">
															<div class="form-group col-md-12">
																<label for="alread_email">{{ t._('email') }}</label>
																<input type="email" class="form-control" id="alread_email"  name="email" placeholder="{{ t._('email') }}">
															</div>
															<div class="form-group col-md-12">
																<label for="alread_number">{{ t._('number_helpdesk') }}</label>
																<input type="number" class="form-control" id="alread_number" name="number"  placeholder="{{ t._('number_helpdesk') }}">
															</div>
														</div>
														<button type="submit" class="btn btn-default btn-primary  button-submit">{{ t._('ok') }}</button>
													</form>
												</div>
											</div>
										</div>

										-->



									</div>






								</div>

								<?php } ?>
							</div>
						</div>

					</div>
				</div>

		</div>
	</div>
</main>
<article class="internal-content">
	<div class="container">
		<div class="internal-content-inner">
			<div class="content-text">
				<div class="text-group">

					<section class="lightSection clearfix pageHeader">
						<div class="container">
							<div class="row">
								<div class="col">
									<div class="page-title">
										<h2>Help Desk  #<?php echo str_pad($helpdesk->id, 4, "0", STR_PAD_LEFT);  ?></h2>
									</div>
								</div>
							</div>
						</div>
					</section>


					<style type="text/css">
						dl dt.col-sm-3 {
							text-align: right;
						}
					</style>

					<div class="container pt-5">
						{{ content() }}

							<dl class="row">
								<dt class="col-sm-3">{{ t._('number_helpdesk') }}:</dt>
								<dd class="col-sm-9">#<?php echo str_pad($helpdesk->id, 4, "0", STR_PAD_LEFT);  ?></dd>

								<dt class="col-sm-3">{{ t._('name') }}:</dt>
								<dd class="col-sm-9">{{ helpdesk.name }}</dd>

								<dt class="col-sm-3">{{ t._('email') }}:</dt>
								<dd class="col-sm-9">{{ helpdesk.email }}</dd>

								<?php if ( $helpdesk->id_event ) : ?>
									<dt class="col-sm-3">{{ t._('Event') }}:</dt>
									<dd class="col-sm-9"><?php echo $this->getDI()->getFormatdates()->format($helpdesk->Events->date_start, '25/Jan/2000');?> {{ helpdesk.Events.name }}</dd>
								<?php endif ; ?>

								<dt class="col-sm-3">{{ t._('subject') }}:</dt>
								<dd class="col-sm-9">{{ helpdesk.subject }}</dd>

								<dt class="col-sm-3">{{ t._('created_at') }}:</dt>
								<dd class="col-sm-9"><?php echo date('d, M, Y  H:i', strtotime($helpdesk->created_at)) ?></dd>
							</dl>
						<div class="row">


							<div class="page-header pt-5">
								<h4>{{ t._('interactions') }}</h4>
							</div>

							<table class="table table-striped">
								<thead>
									<tr>
										<th scope="col">{{ t._('date') }}</th>
										<th scope="col">{{ t._('author') }}</th>
										<th scope="col">{{ t._('message') }}</th>
									</tr>
								</thead>
								<tbody>
									<?php foreach ( $helpdesk->HelpdeskAnswers AS $answers ) : ?>
										<tr >
											<td scope="row">
												<?php echo date('d/m/Y H:i', strtotime($answers->created_at)) ?>
											</td>
											<td>
												<?php if ( $answers->admin > 0 ) : ?>
													{{ config.company.name }}
												<?php else : ?>
													{{ answers.author }}
												<?php endif ; ?>
											</td>
											<td style="word-break: break-all;">{{ answers.message|nl2br }}</td>
										</tr>
									<?php endforeach ; ?>

									<tr class="table-light pt-5">
										<td colspan="2" class="table-light text-right align-middle">
											{{ t._('label_for_new_message_in_helpdesk') }}
											<a name="last"></a>
										</td>
										<td class="table-light">
											<form class="" method="POST" action="{{ url() }}helpdesk/view/{{ helpdesk.id }}/#last">
												<textarea class="form-control" name="message" rows="3" placeholder="{{ t._('new_message') }}"    autofocus></textarea>
												<button type="submit" class="btn btn-primary  btn-sm">{{ t._('send_new_message') }}</button>
											</form>
										</td>
									</tr>

								</tbody>
							</table>

						</div>
					</div>

				</div>
			</div>
		</div>
	</div>
</div>
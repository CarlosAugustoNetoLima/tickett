<section class="section" style="background: #d8d8d8;">
	<div class="container" style="max-width: 100%;">
		<div class="">
        	<!-- <h2 class="section-title" style="font-size: large;"><a href="#"  data-toggle="modal" data-target="#filtroModal"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#096f94" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="3" y1="12" x2="21" y2="12"></line><line x1="3" y1="6" x2="21" y2="6"></line><line x1="3" y1="18" x2="21" y2="18"></line></svg></a>&nbsp; &nbsp;{{ t._('Filter') }} </h2>
			 Modal -->
			 <h2 class="section-title textSearch" style="font-size: large;width: 100%;">{{ t._('Pesquisar') }}</h2>
			 <form action="{{ url() }}search" class="search-form">
				<div class="input-group searchBtn">
					<input name="term" type="text" placeholder="{{ t._('Nome do Evento, País, Cidade, Local') }}" class="form-control"  style="display: flex; border: 2px solid #096f94; border-radius: 8px 0 0 8px;">
					<div class="input-group-prepend">
						<button class="btn btn-outline-secondary" type="submit"  style="display: flex; border: 2px solid #096f94; border-radius: 0 8px 8px 0; background: #096f94;">
							<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
						</button>
					  </div>
				</div>
			</form>
			<br>

			<!-- <form action="{{ url() }}search" class="search-form">
				<div class="form-row">
					<div class="form-group col-md-3">
                        <label>{{ t._('Event') }}</label>
						<input type="text" class="form-control" placeholder="{{ t._('Event') }}" name="event" style="display: flex; border: 2px solid #096f94; border-radius: 8px; background: #f6f6f6;">
					</div>
					<div class="form-group col-md-3">
                        <label for="date_of">{{ t._('City') }}</label>
						<select class="custom-select" placeholder="{{ t._('City') }}" name="city" style="height: 100%; display: flex; border: 2px solid #096f94; border-radius: 8px; padding: 13px 20px; background: #f6f6f6;">
                            <option value="0">{{ t._('Select') }}</option>
                            <?php foreach ( $cities AS $city ) : ?>
                                <option value="{{ city['id'] }}">{{ city['name'] }}</option>
                            <?php endforeach ; ?>
                        </select>
					</div>
					<div class="form-group col-md-2">
						<label for="date_of">{{ t._('Date of') }}</label>
						<input type="date" class="form-control" placeholder="Data de" name="dateOf" style="height: 100%; display: flex; border: 2px solid #096f94; border-radius: 8px;">
					</div>
                    <div class="form-group col-md-2">
						<label for="date_until">{{ t._('Date until') }}</label>
						<input type="date" class="form-control" placeholder="Data até" name="dateUntil" style="height: 100%; display: flex; border: 2px solid #096f94; border-radius: 8px;">
					</div>
                    <div class="form-group col-md-2">
						<button type="submit" class="btn btn-primary btn-block">{{ t._('Search') }}</button>
					</div>
				</div>
				
			</form> -->

			<h2 class="section-title" style="font-size: large;">{{ t._('Featured Events') }}</h2>
			<div class="row">

				<?php foreach ( $events_featured AS $event ) : ?>
					<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3" style="margin-bottom: 30px;">
						<div class="card card-events" style="box-shadow: 2px 2px 8px #888888;">
						<?php if ( $event['type'] == 'event' ) : ?>
							<a href="{{ url() }}event/{{ event['id'] }}/{{ event['slug'] }}{{ ref }}" class="card-link">
						<?php else : ?>
							<a href="{{ url() }}group/{{ event['slug'] }}" class="card-link">
								<?php endif ; ?>
								<img class="card-img-top" alt="{{ event['name'] }} {{ event['ticket_sub_name'] }}" src="{{ url() }}img/shows/{{ event['image'] }}">
								<div class="card-body">
									<h3 class="title" style="font-size: medium; white-space: nowrap;  overflow: hidden;  text-overflow: ellipsis;">{{ event['name'] }}</h3>
									<p class="card-text">
										<?php if ( (isset($event['label_date']) AND strlen($event['label_date']) > 2) OR (isset($event['date_opening']) AND strlen($event['date_opening']) > 2) ) : ?>
											<p class="text-left" style="font-size: small;">
												<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#096f94" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
												<?php if ( isset($event['label_date']) AND strlen($event['label_date']) > 2 ) : ?>
												{{ event['label_date'] }}
												<?php else : ?>
													<?php echo $this->getDI()->getFormatdates()->format($event['date_opening'], 'Dom_01_de_Janeiro_de_2000');?>
												<?php endif ; ?>

												<?php if ( $event['type'] == 'event' ) : ?>

												<?php if ( isset($event['label_date']) AND strlen($event['label_date']) > 2 ) : ?>
							
												<?php else : ?>
													* <?php echo $this->getDI()->getFormatdates()->format($event['date_opening'], '17:00h');?>
												<?php endif ; ?>

												<?php endif ; ?>

												<?php if ( isset($event['city_name']) AND strlen($event['city_name']) > 2 ) : ?>
													<p style="font-size: small; color: rgb(98, 105, 115); margin-top: -10px; white-space: nowrap;  overflow: hidden;  text-overflow: ellipsis;">
														<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#626973" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s-8-4.5-8-11.8A8 8 0 0 1 12 2a8 8 0 0 1 8 8.2c0 7.3-8 11.8-8 11.8z"/><circle cx="12" cy="10" r="3"/></svg>
														{{ event['place_name'] }} - {{ event['city_name'] }}, {{ event['region_acronym'] }}
													</p>
												<?php endif ; ?>
											</p>
										<?php endif ; ?>
									</p>
								  </div>
								  <div class="card-footer text-center" style="background: #096f94; color: #FFFFFF;">
									COMPRAR
								  </div>
							</a>
						</div>
					</div>
					<?php endforeach ; ?>

				</div>
			</div>
		</div>
	</section>

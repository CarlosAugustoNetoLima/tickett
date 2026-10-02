<section class="section featured-shows">
	<div class="container">
		<div class="featured-shows-inner">
        <h2 class="section-title">{{ t._('Filter') }}</h2>
			<form action="{{ url() }}search" class="search-form">
				<div class="form-row">
					<div class="form-group col-md-3">
                        <label for="date_of">{{ t._('City') }}</label>
						<select class="custom-select" placeholder="{{ t._('City') }}" name="city" style="height: 100%; display: flex; border: 2px solid #096f94; border-radius: 8px; padding: 13px 20px; background: #f6f6f6;">
                            <option value="0">{{ t._('Select') }}</option>
                            <?php foreach ( $cities AS $city ) : ?>
                                <option value="{{ city['id'] }}">{{ city['name'] }}</option>
                            <?php endforeach ; ?>
                        </select>
					</div>
					<div class="form-group col-md-3">
						<label for="date_of">{{ t._('Date of') }}</label>
						<input type="date" class="form-control" placeholder="Data de" name="dateOf" style="height: 100%; display: flex; border: 2px solid #096f94; border-radius: 8px;">
					</div>
                    <div class="form-group col-md-3">
						<label for="date_until">{{ t._('Date until') }}</label>
						<input type="date" class="form-control" placeholder="Data até" name="dateUntil" style="height: 100%; display: flex; border: 2px solid #096f94; border-radius: 8px;">
					</div>
                    <div class="form-group col-md-3">
						<button type="submit" class="btn btn-primary btn-block">{{ t._('Search') }}</button>
					</div>
				</div>
				
			</form>
			<h2 class="section-title">{{ t._('Featured Events') }}</h2>
			<div class="featured-shows-items">

				<?php foreach ( $events_featured AS $event ) : ?>
				<div class="show-card big ">


					<?php if ( $event['type'] == 'event' ) : ?>
					<a href="{{ url() }}event/{{ event['id'] }}/{{ event['slug'] }}{{ ref }}" class="card-link">
					<?php else : ?>
						<a href="{{ url() }}group/{{ event['slug'] }}" class="card-link">
							<?php endif ; ?>


							<div class="show-card-inner">
								<div class="card-cover">
									<img alt="{{ event['name'] }} {{ event['ticket_sub_name'] }}" src="{{ url() }}img/shows/{{ event['image'] }}" class="image"/>
								</div>
								<div class="card-data">
									<div class="card-data-inner">
										<div class="data-group data-title">
											<h3 class="title">{{ event['name'] }}</h3>
										</div>


										<?php if ( (isset($event['label_date']) AND strlen($event['label_date']) > 2) OR (isset($event['date_opening']) AND strlen($event['date_opening']) > 2) ) : ?>
										<div class="data-group data-date">
											<svg class="data-icon" version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="488.152px" height="488.152px" viewbox="0 0 488.152 488.152" style="enable-background:new 0 0 488.152 488.152;" xml:space="preserve">
												<path d="M177.854,269.311c0-6.115-4.96-11.069-11.08-11.069h-38.665c-6.113,0-11.074,4.954-11.074,11.069v38.66 c0,6.123,4.961,11.079,11.074,11.079h38.665c6.12,0,11.08-4.956,11.08-11.079V269.311L177.854,269.311z"/>
												<path d="M274.483,269.311c0-6.115-4.961-11.069-11.069-11.069h-38.67c-6.113,0-11.074,4.954-11.074,11.069v38.66 c0,6.123,4.961,11.079,11.074,11.079h38.67c6.108,0,11.069-4.956,11.069-11.079V269.311z"/>
												<path d="M371.117,269.311c0-6.115-4.961-11.069-11.074-11.069h-38.665c-6.12,0-11.08,4.954-11.08,11.069v38.66 c0,6.123,4.96,11.079,11.08,11.079h38.665c6.113,0,11.074-4.956,11.074-11.079V269.311z"/>
												<path d="M177.854,365.95c0-6.125-4.96-11.075-11.08-11.075h-38.665c-6.113,0-11.074,4.95-11.074,11.075v38.653 c0,6.119,4.961,11.074,11.074,11.074h38.665c6.12,0,11.08-4.956,11.08-11.074V365.95L177.854,365.95z"/>
												<path d="M274.483,365.95c0-6.125-4.961-11.075-11.069-11.075h-38.67c-6.113,0-11.074,4.95-11.074,11.075v38.653 c0,6.119,4.961,11.074,11.074,11.074h38.67c6.108,0,11.069-4.956,11.069-11.074V365.95z"/>
												<path d="M371.117,365.95c0-6.125-4.961-11.075-11.069-11.075h-38.67c-6.12,0-11.08,4.95-11.08,11.075v38.653 c0,6.119,4.96,11.074,11.08,11.074h38.67c6.108,0,11.069-4.956,11.069-11.074V365.95L371.117,365.95z"/>
												<path d="M440.254,54.354v59.05c0,26.69-21.652,48.198-48.338,48.198h-30.493c-26.688,0-48.627-21.508-48.627-48.198V54.142 h-137.44v59.262c0,26.69-21.938,48.198-48.622,48.198H96.235c-26.685,0-48.336-21.508-48.336-48.198v-59.05 C24.576,55.057,5.411,74.356,5.411,98.077v346.061c0,24.167,19.588,44.015,43.755,44.015h389.82 c24.131,0,43.755-19.889,43.755-44.015V98.077C482.741,74.356,463.577,55.057,440.254,54.354z M426.091,422.588 c0,10.444-8.468,18.917-18.916,18.917H80.144c-10.448,0-18.916-8.473-18.916-18.917V243.835c0-10.448,8.467-18.921,18.916-18.921 h327.03c10.448,0,18.916,8.473,18.916,18.921L426.091,422.588L426.091,422.588z"/>
												<path d="M96.128,129.945h30.162c9.155,0,16.578-7.412,16.578-16.567V16.573C142.868,7.417,135.445,0,126.29,0H96.128 C86.972,0,79.55,7.417,79.55,16.573v96.805C79.55,122.533,86.972,129.945,96.128,129.945z"/>
												<path d="M361.035,129.945h30.162c9.149,0,16.572-7.412,16.572-16.567V16.573C407.77,7.417,400.347,0,391.197,0h-30.162 c-9.154,0-16.577,7.417-16.577,16.573v96.805C344.458,122.533,351.881,129.945,361.035,129.945z"/>
											</svg>
											<p class="data-text datetime">
												<?php if ( isset($event['label_date']) AND strlen($event['label_date']) > 2 ) : ?>
												{{ event['label_date'] }}
											<?php else : ?>
												<?php echo $this->getDI()->getFormatdates()->format($event['date_opening'], 'Dom_01_de_Janeiro_de_2000');?>
												<?php endif ; ?>
											</p>
										</div>
										<?php endif ; ?>


										<?php if ( $event['type'] == 'event' ) : ?>

										<?php if ( isset($event['label_date']) AND strlen($event['label_date']) > 2 ) : ?>

									<?php else : ?>
										<div class="data-group data-date">
											<svg class="data-icon" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewbox="0 0 477.867 477.867" style="enable-background:new 0 0 477.867 477.867;" xml:space="preserve">
												<g>
													<path d="M238.933,0C106.974,0,0,106.974,0,238.933s106.974,238.933,238.933,238.933s238.933-106.974,238.933-238.933
																										                                                            C477.726,107.033,370.834,0.141,238.933,0z M238.933,443.733c-113.108,0-204.8-91.692-204.8-204.8s91.692-204.8,204.8-204.8
																										                                                            s204.8,91.692,204.8,204.8C443.611,351.991,351.991,443.611,238.933,443.733z"/>
												</g>
												<g>
													<path d="M238.933,85.333c-9.426,0-17.067,7.641-17.067,17.067v119.467H102.4c-9.426,0-17.067,7.641-17.067,17.067
																										                                                                S92.974,256,102.4,256h136.533c9.426,0,17.067-7.641,17.067-17.067V102.4C256,92.974,248.359,85.333,238.933,85.333z"/>
												</g>
											</svg>
											<p class="data-text datetime">
												<?php echo $this->getDI()->getFormatdates()->format($event['date_opening'], '17:00h');?>
											</p>
										</div>
										<?php endif ; ?>


										<?php endif ; ?>


										<?php if ( isset($event['city_name']) AND strlen($event['city_name']) > 2 ) : ?>
										<div class="data-group data-location">
											<svg class="data-icon" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewbox="0 0 512 512" style="enable-background:new 0 0 512 512;" xml:space="preserve">
												<path d="M256,0C153.755,0,70.573,83.182,70.573,185.426c0,126.888,165.939,313.167,173.004,321.035 c6.636,7.391,18.222,7.378,24.846,0c7.065-7.868,173.004-194.147,173.004-321.035C441.425,83.182,358.244,0,256,0z M256,278.719 c-51.442,0-93.292-41.851-93.292-93.293S204.559,92.134,256,92.134s93.291,41.851,93.291,93.293S307.441,278.719,256,278.719z"/>
											</svg>
											<p class="data-text location">{{ event['city_name'] }},
												{{ event['region_acronym'] }}</p>
										</div>
										<?php endif ; ?>


									</div>
								</div>
							</div>
						</a>
					</div>
					<?php endforeach ; ?>

				</div>
			</div>
		</div>
	</section>

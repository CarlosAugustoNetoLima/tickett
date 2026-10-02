<section class="tkt-scope tkt-section">
	<div class="tkt-container">

		<div class="tkt-section__head">
			<div>
				<span class="tkt-section__eyebrow">TOP 10</span>
				<h2 class="tkt-section__title">{{ t._('Featured Events') }}</h2>
			</div>
			<div class="tkt-section__nav" data-swiper-nav-for="tkt-featured-swiper">
				<button type="button" class="tkt-swiper-prev" aria-label="Anterior">
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"></polyline></svg>
				</button>
				<button type="button" class="tkt-swiper-next" aria-label="Seguinte">
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"></polyline></svg>
				</button>
			</div>
		</div>

		<div class="swiper mySwiper_1 tkt-cards-swiper" id="tkt-featured-swiper">
			<div class="swiper-wrapper">
				<?php foreach ( $events_featured AS $event ) : ?>
				<div class="swiper-slide" style="width: 300px;">
					<?php if ( $event['type'] == 'event' ) : ?>
					<a href="{{ url() }}event/{{ event['id'] }}/{{ event['slug'] }}{{ ref }}" class="tkt-card-destaque">
						<?php else : ?>
						<a href="{{ url() }}group/{{ event['slug'] }}" class="tkt-card-destaque">
							<?php endif ; ?>
							<div class="tkt-card-destaque__media">
								<img alt="{{ event['name'] }} {{ event['ticket_sub_name'] }}" src="{{ url() }}img/shows/{{ event['image'] }}">
							</div>
							<div class="tkt-card-destaque__body">
								<div>
									<p class="tkt-card-destaque__title">{{ event['name'] }}</p>
									<?php if ( isset($event['place_name']) AND strlen($event['place_name']) > 2 ) : ?>
									<p class="tkt-card-destaque__subtitle">{{ event['place_name'] }}<?php if ( isset($event['city_name']) AND strlen($event['city_name']) > 2 ) : ?> - {{ event['city_name'] }}<?php endif ; ?></p>
									<?php endif ; ?>
								</div>
								<?php if ( (isset($event['label_date']) AND strlen($event['label_date']) > 2) OR (isset($event['date_opening']) AND strlen($event['date_opening']) > 2) ) : ?>
								<div class="tkt-card-destaque__pr">
									<span class="tkt-card-destaque__date">
										<?php if ( isset($event['label_date']) AND strlen($event['label_date']) > 2 ) : ?>
										{{ event['label_date'] }}
										<?php else : ?>
										<?php echo date("d M", strtotime($event['date_opening'])); ?>
										<?php endif ; ?>
									</span>
								</div>
								<?php endif ; ?>
							</div>
						</a>
				</div>
				<?php endforeach ; ?>
			</div>
		</div>

	</div>
</section>

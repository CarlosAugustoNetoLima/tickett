<section class="tkt-scope tkt-hero">
	<div class="swiper mySwiper">
		<div class="swiper-wrapper">
			<?php foreach ( $events_featured_premium AS $event ) : ?>
			<div class="swiper-slide">
				<?php if ( $event['type'] == 'event' ) : ?>
				<a href="{{ url() }}event/{{ event['id'] }}/{{ event['slug'] }}{{ ref }}">
					<?php else : ?>
					<a href="{{ url() }}group/{{ event['slug'] }}{{ ref }}">
						<?php endif ; ?>
						<img class="tkt-hero__image" alt="{{ event['name'] }} {{ event['ticket_sub_name'] }}"
							src="{{ url() }}img/shows/{{ event['bannerPrincipal'] }}">
					</a>

					<div class="tkt-hero__bar">
						<div class="tkt-hero__left">
							<?php if ( $event['type'] == 'event' ) : ?>
							<a href="{{ url() }}event/{{ event['id'] }}/{{ event['slug'] }}{{ ref }}" class="tkt-btn tkt-btn--primary" style="width: 210px;">{{ t._('Comprar bilhetes') }}</a>
							<?php else : ?>
							<a href="{{ url() }}group/{{ event['slug'] }}{{ ref }}" class="tkt-btn tkt-btn--primary" style="width: 210px;">{{ t._('Comprar bilhetes') }}</a>
							<?php endif ; ?>
						</div>

						<div class="tkt-hero__meta">
							<?php if ( (isset($event['label_date']) AND strlen($event['label_date']) > 2) OR (isset($event['date_opening']) AND strlen($event['date_opening']) > 2) ) : ?>
							<div class="tkt-hero__meta-item">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
								<span>
									<?php if ( isset($event['label_date']) AND strlen($event['label_date']) > 2 ) : ?>
									{{ event['label_date'] }}
									<?php else : ?>
									<?php echo date("d M Y", strtotime($event['date_opening'])); ?>
									<?php if ( $event['type'] == 'event' ) : ?>
									&middot; <?php echo $this->getDI()->getFormatdates()->format($event['date_opening'], '17:00h'); ?>
									<?php endif ; ?>
									<?php endif ; ?>
								</span>
							</div>
							<?php endif ; ?>
							<?php if ( isset($event['city_name']) AND strlen($event['city_name']) > 2 ) : ?>
							<span class="tkt-hero__meta-sep">&middot;</span>
							<div class="tkt-hero__meta-item">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s-8-4.5-8-11.8A8 8 0 0 1 12 2a8 8 0 0 1 8 8.2c0 7.3-8 11.8-8 11.8z"></path><circle cx="12" cy="10" r="3"></circle></svg>
								<span>{{ event['place_name'] }} - {{ event['city_name'] }}</span>
							</div>
							<?php endif ; ?>
						</div>

						<div class="tkt-hero__nav">
							<button type="button" class="swiper-button-prev" aria-label="Anterior">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"></polyline></svg>
							</button>
							<button type="button" class="swiper-button-next" aria-label="Seguinte">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"></polyline></svg>
							</button>
						</div>
					</div>
			</div>
			<?php endforeach ; ?>
		</div>
	</div>
</section>

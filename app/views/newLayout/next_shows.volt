<section class="tkt-scope tkt-section" style="padding-top: 0;">
	<div class="tkt-container">

		<div class="tkt-section__head">
			<h2 class="tkt-section__title">{{ t._('Next Events') }}</h2>
		</div>

		<div class="swiper mySwiper_2">
			<div class="swiper-wrapper">
				<?php foreach ( $events AS $event ) : ?>
				<div class="swiper-slide" style="width: 410.667px;">
					<?php if ( $event['type'] == 'event' ) : ?>
					<a href="{{ url() }}event/{{ event['id'] }}/{{ event['slug'] }}{{ ref }}" class="tkt-card-min">
						<?php else : ?>
						<a href="{{ url() }}group/{{ event['slug'] }}" class="tkt-card-min">
							<?php endif ; ?>
							<div class="tkt-card-min__media">
								<img alt="{{ event['name'] }} {{ event['ticket_sub_name'] }}" src="{{ url() }}img/shows/{{ event['image'] }}">
							</div>
							<div class="tkt-card-min__body">
								<p class="tkt-card-min__title">{{ event['name'] }}</p>
								<?php if ( (isset($event['label_date']) AND strlen($event['label_date']) > 2) OR (isset($event['date_opening']) AND strlen($event['date_opening']) > 2) ) : ?>
								<p class="tkt-card-min__meta">
									<?php if ( isset($event['label_date']) AND strlen($event['label_date']) > 2 ) : ?>
									{{ event['label_date'] }}
									<?php else : ?>
									<?php echo date("d M", strtotime($event['date_opening']));?>
									<?php if ( $event['type'] == 'event' ) : ?>
									- <?php echo $this->getDI()->getFormatdates()->format($event['date_opening'], '17:00h');?>
									<?php endif ; ?>
									<?php endif ; ?>
									<?php if ( isset($event['city_name']) AND strlen($event['city_name']) > 2 ) : ?>
									&middot; {{ event['place_name'] }}
									<?php endif ; ?>
								</p>
								<?php endif ; ?>
							</div>
						</a>
				</div>
				<?php endforeach ; ?>
			</div>
		</div>

	</div>
</section>

<section class="tkt-scope tkt-section" style="padding-top: 0;">
	<div class="tkt-container">

		<div class="tkt-section__head">
			<h2 class="tkt-section__title dropdown tkt-country-dropdown" style="display: flex; align-items: center; gap: 8px; cursor: pointer;">
				{{ t._('EVENTOS EM') }}
				<?php
					$flag = $this->session->get("flag") ;

					$flag_text = '<img src="'.$this->url->get().'assets/images/flag/flag-pt_pt.png" width="20" height="20" style="border-radius:50%;" alt="Português" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">';
					if ( $flag == 'ESP' ) {
						$flag_text = '<img src="'.$this->url->get().'assets/images/flag/flag-es.png" width="20" height="20" style="border-radius:50%;" alt="Spanish" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">';
					}
					else if ( $flag == 'HOL' ) {
						$flag_text = '<img src="'.$this->url->get().'assets/images/flag/flag-hl.avif" width="20" height="20" style="border-radius:50%;" alt="Netherlands" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">';
					}
					else if ( $flag == 'FRA' ) {
						$flag_text = '<img src="'.$this->url->get().'assets/images/flag/flag_fr.png" width="20" height="20" style="border-radius:50%;" alt="France" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">';
					}
					else if ( $flag == 'CHE' ) {
						$flag_text = '<img src="'.$this->url->get().'assets/images/flag/flag-su.png" width="20" height="20" style="border-radius:50%;" alt="Suice" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">';
					}
					else if ( $flag == 'BEL' ) {
						$flag_text = '<img src="'.$this->url->get().'assets/images/flag/flag-bl.png" width="20" height="20" style="border-radius:50%;" alt="Belgium" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">';
					}

					echo $flag_text ;
				?>
				<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><path d="M6 9l6 6 6-6" /></svg>

				<div class="dropdown-menu" aria-labelledby="language-select">
					<?php if(in_array("POR", $arrayflags)) { ?>
					<a class="dropdown-item" href="{{ url() }}<?php echo strip_tags($this->router->getRewriteUri()) ?>?flag=POR"><span class="language-flag"><img src="{{ url() }}assets/images/flag/flag-pt_pt.png" width="20px" alt="Português"></span>&nbsp;Portugal</a>
					<?php } ?>
					<?php if(in_array("ESP", $arrayflags)) { ?>
					<a class="dropdown-item" href="{{ url() }}<?php echo strip_tags($this->router->getRewriteUri()) ?>?flag=ESP"><span class="language-flag"><img src="{{ url() }}assets/images/flag/flag-es.png" width="20px" alt="Spanish"></span>&nbsp;Espanha</a>
					<?php } ?>
					<?php if(in_array("HOL", $arrayflags)) { ?>
					<a class="dropdown-item" href="{{ url() }}<?php echo strip_tags($this->router->getRewriteUri()) ?>?flag=HOL"><span class="language-flag"><img src="{{ url() }}assets/images/flag/flag-hl.avif" width="20px" alt="Netherlands"></span>&nbsp;Holanda</a>
					<?php } ?>
					<?php if(in_array("FRA", $arrayflags)) { ?>
					<a class="dropdown-item" href="{{ url() }}<?php echo strip_tags($this->router->getRewriteUri()) ?>?flag=FRA"><span class="language-flag"><img src="{{ url() }}assets/images/flag/flag_fr.png" width="20px" alt="France"></span>&nbsp;França</a>
					<?php } ?>
					<?php if(in_array("CHE", $arrayflags)) { ?>
					<a class="dropdown-item" href="{{ url() }}<?php echo strip_tags($this->router->getRewriteUri()) ?>?flag=CHE"><span class="language-flag"><img src="{{ url() }}assets/images/flag/flag-su.png" width="20px" alt="Suice"></span>&nbsp;Suíça</a>
					<?php } ?>
					<?php if(in_array("BEL", $arrayflags)) { ?>
					<a class="dropdown-item" href="{{ url() }}<?php echo strip_tags($this->router->getRewriteUri()) ?>?flag=BEL"><span class="language-flag"><img src="{{ url() }}assets/images/flag/flag-bl.png" width="20px" alt="Belgium"></span>&nbsp;Bélgica</a>
					<?php } ?>
				</div>
			</h2>
		</div>

		<div class="swiper mySwiper_2">
			<div class="swiper-wrapper">
				<?php foreach ( $eventsCountry AS $event ) : ?>
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

<section class="carousel-shows" style="background: #f6f6f6;">
    <!-- Swiper -->
  <div class="swiper mySwiper">
    <div class="swiper-wrapper">
        <?php foreach ( $events_featured_premium AS $event ) : ?>
        <div class="swiper-slide ">
          <?php if ( $event['type'] == 'event' ) : ?>
          <a href="{{ url() }}event/{{ event['id'] }}/{{ event['slug'] }}{{ ref }}" class="card-link">
          <?php else : ?>
          <a href="{{ url() }}group/{{ event['slug'] }}{{ ref }}" class="card-link">
          <?php endif ; ?>
            <img alt="{{ event['name'] }} {{ event['ticket_sub_name'] }}" src="{{ url() }}img/shows/{{ event['bannerPrincipal'] }}" alt="Card image cap" >
          </a>
        </div>
    <?php endforeach ; ?>
    </div>
    <div class="swiper-button-next"></div>
    <div class="swiper-button-prev"></div>
    <div class="swiper-pagination"></div>
  </div>
</section>
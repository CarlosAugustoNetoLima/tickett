

<div class="card-deck">
<?php
	$hoje = new DateTime();
	foreach ( $events AS $event ) :
		/* Ocultar eventos passados */
		if ( $hoje > new DateTime($event->date_sales_end)  ) continue;

?>

	<div class="card" style="    max-width: 400px; ">
		<a href="#" onclick="tiktxCheckout({{ event.id }}); return;" >
			<?php if ( count($event->EventsImages) > 0 ) : ?>
				<img class="card-img-top" src="{{ url() }}img/shows/{{ event.EventsImages[0].name }}" alt="{{ event.name }}">
			<?php endif ; ?>
			<div class="card-body">
				<h5 class="card-title">{{ event.name }}</h5>
				<h6 class="card-text">{{ event.Cities.name }}, {{ event.Regions.acronym }}</h6>
				<p class="card-text"><small class="text-muted"><?php echo formatDate($event->date_start, null, null, true) ?></small></p>
			</div>
		</a>
	</div>

<?php endforeach ; ?>
</div>

<div class="container-fluid">
	<div class="row">

		{{ content() }}


			<h3>
				{{ event.name }} - <?php echo formatDate($event->date_start, null, null, true) ?> - {{ event.Cities.name }}, {{ event.Regions.acronym }}
			</h3>


		<?php
		$language = $this->session->get("language") ?: 'en_us';
		$sid = session_id();
		?>
		<div id="div-tiktx-checkout-embedded" style="width: 100%"></div>
		<script src="{{ url() }}js/embedded.js"></script>
		<script type="text/javascript">
			window.TiktX.checkoutEmbedded({
				eventId: '{{ event.id }}',
				embeddedId: '{{ seller.token_embedded }}',
				containerId: 'div-tiktx-checkout-embedded',
				language: '{{ language }}',
				sid: '{{ sid }}'
			});
		</script>


</div>
</div>
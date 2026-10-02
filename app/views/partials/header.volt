<header class="tkt-navbar tkt-scope">
	<div class="tkt-navbar__inner">
		<a class="tkt-navbar__logo" href="{{ url() }}">
			<img src="{{ url() }}logos/tickett/logo_white.png" alt="{{ config.company.name }}">
		</a>

		<form action="{{ url() }}search" class="tkt-navbar__search" role="search">
			<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
			<input name="term" type="text" placeholder="{{ t._('Pesquisar eventos, artistas...') }}" value="<?php echo isset($term) ? $term : '' ; ?>">
		</form>

		<button type="button" class="tkt-navbar__burger" id="tktNavToggle" aria-label="Menu" aria-expanded="false" aria-controls="tktNavLinks">
			<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="3" y1="12" x2="21" y2="12"></line><line x1="3" y1="6" x2="21" y2="6"></line><line x1="3" y1="18" x2="21" y2="18"></line></svg>
		</button>

		{{ partial('partials/nav-bar') }}
	</div>
</header>

<script>
(function () {
	var toggle = document.getElementById('tktNavToggle');
	var links = document.getElementById('tktNavLinks');
	if (!toggle || !links) return;
	toggle.addEventListener('click', function () {
		var open = links.classList.toggle('is-open');
		toggle.setAttribute('aria-expanded', open ? 'true' : 'false');
	});
})();
</script>

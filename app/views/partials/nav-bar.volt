<ul class="tkt-navbar__links" id="tktNavLinks">

	<li>
		<a href="{{ url() }}search">{{ t._('Eventos') }}</a>
	</li>

	<li>
		<button type="button" data-toggle="modal" data-target="#vendaIngressoModal">{{ t._('Venda seu evento') }}</button>
	</li>

	<li>
		<button type="button" data-toggle="modal" data-target="#resendModal">Reenviar Bilhete</button>
	</li>

	<li class="dropdown">
		<button class="tkt-navbar__lang dropdown-toggle" type="button" id="language-select" data-toggle="dropdown"
			aria-haspopup="true" aria-expanded="false">
			<?php
				$language = $this->session->get("language");
				$lang_flag = 'flag-en_us.png';
				$lang_code = 'EN';
				if ( $language == 'pt_pt' ) {
					$lang_flag = 'flag-pt_pt.png';
					$lang_code = 'PT';
				} else if ( $language == 'es_do' ) {
					$lang_flag = 'flag-es.png';
					$lang_code = 'ES';
				} else if ( $language == 'fr_fr' ) {
					$lang_flag = 'flag-fr.png';
					$lang_code = 'FR';
				}
			?>
			<img src="{{ url() }}assets/images/flag/<?php echo $lang_flag ?>" width="16" height="16" alt="<?php echo $lang_code ?>">
			<span><?php echo $lang_code ?></span>
		</button>
		<div class="dropdown-menu" aria-labelledby="language-select">
			<a class="dropdown-item"
				href="{{ url() }}<?php echo strip_tags($this->router->getRewriteUri()) ?>?l=en_us"><span
					class="language-flag"><img src="{{ url() }}assets/images/flag/flag-en_us.png" width="20px"
						alt="English"></span>&nbsp;English</a>
			<a class="dropdown-item"
				href="{{ url() }}<?php echo strip_tags($this->router->getRewriteUri()) ?>?l=pt_pt"><span
					class="language-flag"><img src="{{ url() }}assets/images/flag/flag-pt_pt.png" width="20px"
						alt="Português"></span>&nbsp;Português</a>
			<a class="dropdown-item"
				href="{{ url() }}<?php echo strip_tags($this->router->getRewriteUri()) ?>?l=es_do"><span
					class="language-flag"><img src="{{ url() }}assets/images/flag/flag-es.png" width="20px"
						alt="Spanish"></span>&nbsp;Spanish</a>
			<a class="dropdown-item"
				href="{{ url() }}<?php echo strip_tags($this->router->getRewriteUri()) ?>?l=fr_fr"><span
					class="language-flag"><img src="{{ url() }}assets/images/flag/flag-fr.png" width="20px"
						alt="French"></span>&nbsp;French</a>
		</div>
	</li>

</ul>

<style>
	#tktNavLinks .dropdown-menu {
		position: absolute;
		top: 100%;
		right: 0;
		left: auto;
		margin-top: 8px;
		background: var(--tkt-bg-elevated);
		border: 1px solid var(--tkt-border-default);
		border-radius: var(--tkt-radius-sm);
		min-width: 180px;
		padding: 6px;
	}

	#tktNavLinks .dropdown-item {
		display: flex;
		align-items: center;
		gap: 8px;
		padding: 8px 10px;
		border-radius: 6px;
		color: var(--tkt-text-secondary);
		font-size: 13px;
	}

	#tktNavLinks .dropdown-item:hover {
		background: var(--tkt-bg-lighter);
		color: var(--tkt-text-primary);
	}

	@media (max-width: 900px) {
		#tktNavLinks.is-open {
			display: flex;
			position: absolute;
			top: 100%;
			left: 0;
			right: 0;
			flex-direction: column;
			align-items: flex-start;
			gap: 0;
			background: var(--tkt-bg-elevated);
			border-bottom: 1px solid var(--tkt-border-subtle);
			padding: 8px 20px 16px;
		}

		#tktNavLinks.is-open li {
			width: 100%;
			padding: 10px 0;
			border-bottom: 1px solid var(--tkt-border-subtle);
		}
	}
</style>

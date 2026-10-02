<footer class="tkt-footer tkt-scope">
	<div class="tkt-container">

		<div class="tkt-footer__top">

			<div class="tkt-footer__brand">
				<img src="{{ url() }}logos/tickett/logo_white.png" alt="{{ config.company.name }}">
				<p>{{ t._('Rápido, Seguro e Fácil') }} — {{ config.company.name }}</p>
			</div>

			<div class="tkt-footer__cols">

				<div class="tkt-footer__col">
					<p class="tkt-footer__col-title">Tickett.com</p>
					<a href="{{ url() }}company">{{ t._('about') }}</a>
					<a href="{{ url() }}company/policies_procedures">{{ t._('policies_procedures') }}</a>
					<a href="{{ url() }}company/privacy">{{ t._('privacy') }}</a>
					<a href="{{ url() }}company/politicadeCookies">{{ t._('politicade_cookies') }}</a>
				</div>

				<div class="tkt-footer__col">
					<p class="tkt-footer__col-title">{{ t._('help') }}</p>
					<a href="https://wa.me/351913666847" target="_blank">{{ t._('contact') }}</a>
					<?php if ( COMPANY == 'lebillet' ) : ?>
					<a href="{{ url('company/meia_entrada') }}">{{ t._('Meia Entrada') }}</a>
					<?php elseif ( COMPANY == 'lebillet_pt' ) : ?>
					<a target="_blank" href="https://consumer-redress.ec.europa.eu/index_en">{{ t._('Resolução de litígios em linha') }}</a>
					<a target="_blank" href="https://www.livroreclamacoes.pt/">{{ t._('Livro de reclamações online') }}</a>
					<?php endif ; ?>
					<a href="#" data-toggle="modal" data-target="#vendaIngressoModal">{{ t._('sell_your_event') }}</a>
				</div>

				<div class="tkt-footer__col">
					<p class="tkt-footer__col-title">{{ t._('Social') }}</p>
					<?php if ( isset($this->config->company->social->twitter) ) : ?>
					<a target="_blank" href="{{ config.company.social.twitter }}"><i class="fab fa-twitter-square"></i> Twitter</a>
					<?php endif ; ?>
					<?php if ( isset($this->config->company->social->instagram) ) : ?>
					<a target="_blank" href="{{ config.company.social.instagram }}"><i class="fab fa-instagram"></i> Instagram</a>
					<?php endif ; ?>
					<?php if ( isset($this->config->company->email) ) : ?>
					<span id="tkt-footer-email"></span>
					<script type="text/javascript">
						(function () {
							var pre = "{{ config.company.email }}";
							var el = document.getElementById('tkt-footer-email');
							if (el) {
								el.innerHTML = "<a target='_blank' href='mailto:" + pre + "'>" + pre + "</a>";
							}
						})();
					</script>
					<?php endif ; ?>
					<?php if ( isset($this->config->company->phone) ) : ?>
					<span>{{ config.company.phone }}</span>
					<?php endif ; ?>
				</div>

				<div class="tkt-footer__col">
					<p class="tkt-footer__col-title">{{ t._('newsletter') }}</p>
					<span>{{ t._('Subscreva as novidades') }}</span>
					<form id="form-newsletter" class="tkt-footer__newsletter">
						<input type="text" name="email" placeholder="{{ t._('your_email_address') }}">
						<button type="button" id="basic-addon2" onclick="submitNews(); return false;">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor"><path d="m8.75 17.612v4.638c0 .324.208.611.516.713.077.025.156.037.234.037.234 0 .46-.11.604-.306l2.713-3.692z"/><path d="m23.685.139c-.23-.163-.532-.185-.782-.054l-22.5 11.75c-.266.139-.423.423-.401.722.023.3.222.556.505.653l6.255 2.138 13.321-11.39-10.308 12.419 10.483 3.583c.078.026.16.04.242.04.136 0 .271-.037.39-.109.19-.116.319-.311.352-.53l2.75-18.5c.041-.28-.077-.558-.307-.722z"/></svg>
						</button>
					</form>
					<p id="news-responde" style="font-size: 12px; color: var(--tkt-text-secondary); margin: 4px 0 0;"></p>
				</div>

			</div>
		</div>

		<div class="tkt-footer__bottom">
			<p>Copyright &copy;<?php echo date('Y') ?> {{ config.company.name }}. {{ t._('All Rights Reserved') }}.</p>
			<?php if ( COMPANY == 'tiktx' ) : ?>
			<p>The Tiktx Company, 3801 NE 207 TH ST, Miami FL 33180</p>
			<p><img src="{{ url() }}img/payments/cards.png" style="max-height: 24px;"></p>
			<?php endif ; ?>
		</div>

	</div>
</footer>

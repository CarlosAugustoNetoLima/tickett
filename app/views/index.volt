<!DOCTYPE html>
<html lang="en">

<head>
	<?php
			/*  LISTA DE DDI - PAISES */
			/* https://pt.wikipedia.org/wiki/Compara%C3%A7%C3%A3o_entre_c%C3%B3digos_de_pa%C3%ADses_COI,_FIFA,_e_ISO_3166 */
			$array_countries = array(
				'tiktx' => [
				'POR' => '+351',
				'BRA' => '+55',
				'ITA' => '+39',
				'ESP' => '+34',
				'SUI' => '+41',
				'FRA' => '+33',
				'IRL' => '+353',
				'GBR' => '+44',
				'BEL' => '+32',
				'GER' => '+49',
				'NED' => '+31',
				'ANG' => '+244',
				'USA' => '+1',
				'LUX' => '+352',
				'ROM' => '+40',
				'AND' => '+376',
				'SUE' => '+46',
				'NOR' => '+47',
				'DIN' => '+45',
				'FIN' => '+358',
				'ISL' => '+354',
				'EST' => '+372',
				],
				'lebillet' => [
					'BRA' => '+55',
					'ARG' => '+54',
					'PAR' => '+595',
					'URU' => '+598',
				],
				'lebillet_pt' => [
					'POR' => '+351',
					'BRA' => '+55',
					'ITA' => '+39',
					'ESP' => '+34',
					'SUI' => '+41',
					'FRA' => '+33',
					'IRL' => '+353',
					'GBR' => '+44',
					'BEL' => '+32',
					'GER' => '+49',
					'NED' => '+31',
					'ANG' => '+244',
					'POL' => '+48',
					'USA' => '+1',
					'LUX' => '+352',
					'ROM' => '+40',
					'AND' => '+376',
					'SUE' => '+46',
					'NOR' => '+47',
					'DIN' => '+45',
					'FIN' => '+358',
					'ISL' => '+354',
					'EST' => '+372',

				]
			);
			?>

	<?php if ( isset($this->config->company->analytics) ) : ?>
	<!-- Global site tag (gtag.js) - Google Analytics -->
	<script async src="https://www.googletagmanager.com/gtag/js?id={{ config.company.analytics }}"></script>
	<script>
		window.dataLayer = window.dataLayer || [];
		function gtag() { dataLayer.push(arguments); }
		gtag('js', new Date());

		gtag('config', '{{ config.company.analytics }}');
	</script>
	<?php endif ; ?>

	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="facebook-domain-verification" content="iwgis9fb5m3shv38c1fc0vorx3agcs" />

	{% if metaTitle is defined %}
	<title>{{ metaTitle }}</title>
	{% else %}
	<title>{{ config.company.title }}</title>
	{% endif %}

	{% if metaNoindex is defined %}
	<meta name="robots" content="noindex">
	{% else %}
	<meta name="robots" content="index, follow" />
	{% endif %}

	{% if metaDescription is defined %}
	<meta name="description" content="{{ metaDescription|e }}" />
	{% else %}
	<meta name="description" content="{{ config.company.description }}" />
	{% endif %}

	{% if metaKeywords is defined %}
	<meta name="keywords" content="{{ metaKeywords }}" />
	{% else %}
	<meta name="keywords" content="{{ config.company.keywords }}" />
	{% endif %}

	<meta property="og:site_name" content="{{ config.company.name }}">
	{% if og_title is defined %}
	<meta property="og:title" content="{{ og_title }}" />{% endif %}
	{% if og_type is defined %}
	<meta property="og:type" content="{{ og_type }}" />{% endif %}
	{% if og_url is defined %}
	<meta property="og:url" content="{{ url() }}{{ og_url }}" />{% endif %}
	{% if og_img is defined %}
	<meta property="og:image" content="{{ url() }}img/shows/{{ og_img }}" />{% endif %}
	{% if og_description is defined %}
	<meta property="og:description" content="{{ og_description }}" />{% endif %}
	{% if canonical is defined %}
	<link rel="canonical" href="{{ url() }}{{ canonical }}" />{% endif %}

	<!-- PLUGINS CSS STYLE -->
	<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/css/all.min.css" rel="stylesheet"
		type='text/css'> <!-- https://fontawesome.com/icons -->

	<!-- CUSTOM CSS -->
	<link rel="stylesheet" href="{{ url() }}assets/build/css/main.css?v=4.5">
	<?php $this->assets->outputCss(); ?>

	<!-- TICKETT.COM REDESIGN (depois do CSS legado de propósito, para vencer
	     empates de especificidade contra as regras antigas) -->
	<link rel="stylesheet" href="{{ url() }}assets/build/css/redesign/tokens.css?v=2">
	<link rel="stylesheet" href="{{ url() }}assets/build/css/redesign/components.css?v=2">

	<!-- Icons -->
	<link rel="shortcut icon" href="{{ url() }}{{ config.company.logos }}favicon.ico" type="image/x-icon">
	<link rel="icon" href="{{ url() }}{{ config.company.logos }}favicon.ico" type="image/x-icon">
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="apple-mobile-web-app-status-bar-style" content="black">
	<meta name="apple-mobile-web-app-title" content="{{ config.company.name }}">
	<link rel="apple-touch-icon" href="{{ url() }}{{ config.company.logos }}apple-icon.png">
	<link rel="apple-touch-icon" sizes="57x57" href="{{ url() }}{{ config.company.logos }}apple-icon-57x57.png">
	<link rel="apple-touch-icon" sizes="60x60" href="{{ url() }}{{ config.company.logos }}apple-icon-60x60.png">
	<link rel="apple-touch-icon" sizes="72x72" href="{{ url() }}{{ config.company.logos }}apple-icon-72x72.png">
	<link rel="apple-touch-icon" sizes="76x76" href="{{ url() }}{{ config.company.logos }}apple-icon-76x76.png">
	<link rel="apple-touch-icon" sizes="114x114" href="{{ url() }}{{ config.company.logos }}apple-icon-114x114.png">
	<link rel="apple-touch-icon" sizes="120x120" href="{{ url() }}{{ config.company.logos }}apple-icon-120x120.png">
	<link rel="apple-touch-icon" sizes="144x144" href="{{ url() }}{{ config.company.logos }}apple-icon-144x144.png">
	<link rel="apple-touch-icon" sizes="152x152" href="{{ url() }}{{ config.company.logos }}apple-icon-152x152.png">
	<link rel="apple-touch-icon" sizes="180x180" href="{{ url() }}{{ config.company.logos }}apple-icon-180x180.png">
	<link rel="icon" type="image/png" sizes="192x192"
		href="{{ url() }}{{ config.company.logos }}android-icon-192x192.png">
	<link rel="icon" type="image/png" sizes="32x32" href="{{ url() }}{{ config.company.logos }}favicon-32x32.png">
	<link rel="icon" type="image/png" sizes="96x96" href="{{ url() }}{{ config.company.logos }}favicon-96x96.png">
	<link rel="icon" type="image/png" sizes="16x16" href="{{ url() }}{{ config.company.logos }}favicon-16x16.png">
	<link rel="manifest" href="{{ url() }}{{ config.company.logos }}manifest.json">
	<meta name="msapplication-TileColor" content="#ffffff">
	<meta name="msapplication-TileImage" content="{{ url() }}{{ config.company.logos }}ms-icon-144x144.png">
	<meta name="theme-color" content="#00B1E3">
	<?php /*
	<link href="{{ url() }}{{ config.company.logos }}apple_splash_2048x2732.png" sizes="2048x2732" rel="apple-touch-startup-image" />
	<link href="{{ url() }}{{ config.company.logos }}apple_splash_1668x2224.png" sizes="1668x2224" rel="apple-touch-startup-image" />
	<link href="{{ url() }}{{ config.company.logos }}apple_splash_1536x2048.png" sizes="1536x2048" rel="apple-touch-startup-image" />
	<link href="{{ url() }}{{ config.company.logos }}apple_splash_1125x2436.png" sizes="1125x2436" rel="apple-touch-startup-image" />
	<link href="{{ url() }}{{ config.company.logos }}apple_splash_1242x2208.png" sizes="1242x2208" rel="apple-touch-startup-image" />
	<link href="{{ url() }}{{ config.company.logos }}apple_splash_750x1334.png" sizes="750x1334" rel="apple-touch-startup-image" />
	<link href="{{ url() }}{{ config.company.logos }}apple_splash_640x1136.png" sizes="640x1136" rel="apple-touch-startup-image" />
*/ ?>
	<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
	<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
	<!--[if lt IE 9]>
	<script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
	<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
	<script type="text/javascript">
		var BASE_URL = "{{ url() }}";


		let visitorId = localStorage.getItem('visitorId');

		if (!visitorId) {
			visitorId = '<?php echo md5($_SERVER['REMOTE_ADDR'].$_SERVER['HTTP_USER_AGENT'])?>';
			localStorage.setItem('visitorId', visitorId);
		}

	</script>

	<link rel="stylesheet" href="{{ url() }}css/swiper-bundle.min.css" />

	<script src='https://cdn.jsdelivr.net/npm/fullcalendar/index.global.min.js'></script>
	<link href='https://fonts.googleapis.com/css?family=Quicksand' rel='stylesheet'>

	<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Oswald|Noto+Sans">
	<style>
		body {
			--font-fallback: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji" !important;
			-webkit-text-size-adjust: 100%;
			-webkit-font-smoothing: antialiased;
			-moz-osx-font-smoothing: grayscale;
			-moz-tab-size: 4;
			-o-tab-size: 4;
			tab-size: 4;
			-webkit-tap-highlight-color: transparent;
			line-height: 1.5;
			font-family: var(--global-font-body, var(--font-fallback)) !important;
		}

		html body main {
			background-image: url('{{ url() }}img/background.png') !important;
			background-attachment: fixed !important;
			background-position: center !important;
			background-repeat: no-repeat !important;
			background-size: cover !important;
		}

		.header,
		html body {
			background-image: url('{{ url() }}img/background.png') !important;
			background-position: top !important;
			background-repeat: no-repeat !important;
			background-size: cover !important;
		}

		.menu-link {
			font-size: 12px;
			background-color: #096f9466;
			padding-left: 15px;
			padding-right: 15px;
			padding-top: 10px;
			padding-bottom: 10px;
			border-radius: 20px;
		}

		.dropdown-toggle:after {
			display: none;
			margin-left: .255em;
			vertical-align: .255em;
			content: "";
			border-top: .3em solid;
			border-right: .3em solid transparent;
			border-bottom: 0;
			border-left: .3em solid transparent;
		}

		.carousel-shows {
			background: transparent !important;
		}

		.card-events {
			border: 1px solid #FFF;
			border-radius: 1rem;
			background-color: transparent;
			height: 97%;
			top: 5px;
		}

		.btn-new {
			background: #096f94;
			color: #FFFFFF;
			cursor: pointer;
			padding-left: 30px;
			padding-right: 30px;
			border-radius: 15px;
			border: 1px solid #FFFFFF;
			font-family: Oswald;
			font-size: x-large !important;
		}

		.swiper-slide img {
			width: 100%;
			height: 80% !important;
			border-radius: 0.9rem 0.9rem 0rem 0rem;
		}

		.swiper-slide-banner img {
			width: 100%;
			height: 100% !important;
		}

		.card-events:hover {
			transform: scale(1.02);
		}

		.card-body{
			padding-top: 1.0rem;
			padding-left: 1.25rem;
			padding-right: 1.25rem;
			padding-bottom: 1.25rem;
		}

		.img-ca {
			border-radius: 1rem !important;
		}

		.show-card {
			max-width: 30% !important;
		}

		.next-shows .next-shows-inner .next-shows-items {
			display: flex;
			justify-content: center;
		}

		.text-search::placeholder {
			font-size: 12px;
			white-space: nowrap;
			overflow: hidden;
			text-overflow: ellipsis;
			color: #ffffff6f;
		}

		.btn-buy-new{
				height: 370px;
			}

		.search-index{
			display: none;
		}

		.title{
				font-size: large !important;
			}

		p {
				font-size: 14px !important;
			}

		.header .header-inner {
			padding: 0 0 !important;
		}

			.section .section-title{
			font-family: Oswald !important;
			font-weight: bolder !important;
			font-size: xx-large !important;
		}

		.header .header-inner .action-side{
			flex-direction: row-reverse;
		}

		.text-date{
			margin-top: 20px;
		}

		.dropdown-evento-em .dropdown-menu{
				top: 20% !important;
    			left: 18% !important;
			}

	
		.col-12, .col-auto, .col-lg, .col-lg-12, .col-lg-auto, .col-md-12, .col-sm-12, .col-sm-auto, .col-xl-12, .col-xl-auto{
			padding-left: 0px !important;
			padding-right: 0px !important;
		}

		.carousel-shows {
			padding-left: 7px !important;
			padding-right: 7px !important;
		}

		.header .header-inner .action-side {
			padding-right: 30px;
		}

		.header .header-inner .logo-side .logo-link .logo {
			padding-right: 20px;
		}

		.div-events-flag {
			margin-left: 40px !important;
		}

		@media only screen and (max-width: 600px) {
			.div-events-flag {
				margin-left: 3px !important;
			}

			.col-12, .col-auto, .col-lg, .col-lg-12, .col-lg-auto, .col-md-12, .col-sm-12, .col-sm-auto, .col-xl-12, .col-xl-auto{
				padding-left: 7px !important;
				padding-right: 7px !important;
			}

			.header .header-inner .action-side {
				padding-right: 0px;
			}

			.header .header-inner {
				padding: 0.5rem 0 !important;
			}

			    .header .header-inner .logo-side {
				padding-right: 7rem !important;
			}

			.header .header-inner .menu-mobile {
				margin-top: -5px;
			}

			.menu-item {
				margin-top: 10px;
			}

			.btn-buy-new{
				height: auto;
			}

			.header .header-inner {
				padding: 1rem 0;
				position: relative;
				display: flex;
				align-items: start;
				flex-direction: column;
			}

			.dropdown-evento-em .dropdown-menu{
				left: 50% !important;
			}

		.header .header-inner .logo-side {
				padding-right: 5rem;
			}

			.search-index{
				display:block;
			}


			.btn-new {
				background: #096f94;
				color: #FFFFFF;
				cursor: pointer;
				padding-left: 10px;
				padding-right: 10px;
				border-radius: 15px;
				border: 1px solid #FFFFFF;
				font-family: Oswald;
				font-size: x-small !important;
			}

			.mySwiper .swiper-slide {
				height: 120px;
			}

			.title{
				font-size: 17px !important;
				white-space:initial;
			}

			p {
				font-size: 14px !important;
			}

			.section .section-title{
				font-size: medium !important;
			}

			svg {
				width: 12px;
			}

			.svg-whats{
				width: 35px !important;
			}

			.menu-action-svg{
				width: 30px !important;
			}

			.card-body {
				padding-left: 0.5em;
				padding-right: 0.5em;
				padding-bottom: 0em;
			}

			.swiper-button-next:after, .swiper-button-prev:after {
				font-size: 12px !important;
			}

			.swiper-button-next, .swiper-button-prev {
				padding: 10px !important;
				display: none !important;
			}

			.section .next-shows{
				margin-top: 20px;
			}

			.mySwiper_1 {
				margin-top: 0px !important;
			}

			.mySwiper_2 {
				margin-top: 0px !important;
			}

			.mySwiper{
				margin-top: 20px !important;
			}

			.swiper-slide img {
				object-fit: fill !important;
				height: auto !important;
			}

			.swiper-slide-banner img {
				width: 100%;
				height: 100% !important;
			}

			.card-events {
				 height: auto;
			}

			.section {
				padding: 0rem 0 1rem !important;
			}
		}

		body {
			font-family: 'Quicksand' !important;
		}
	</style>
</head>

<body class="tkt-page tkt-scope">
	<!-- HEADER -->
	{{ partial('partials/header') }}

	<!-- MAIN CONTENT -->
	{{ content() }}

	<!-- FOOTER -->
	{{ partial('partials/footer') }}

	<!-- Modal LOGIN e SIGNUP -->
	{{ partial("partials/modal-login") }}

	<script src="https://www.google.com/recaptcha/api.js?hl=pt"></script>
	<!-- ===== Modal: Venda seu Evento (novo layout multi-step) ===== -->
	<style>
	/* lebillet — Formulário de Submissão de Eventos (multi-step)
	   Escopo: prefixo lb- para não conflituar com Bootstrap */
	#vendaIngressoModal .modal-content {
		background: transparent;
		border: none;
	}
	#vendaIngressoModal .modal-dialog {
		max-width: 820px;
	}
	:root {
		--lb-primary: #096f94;
		--lb-primary-hover: #0a85b2;
		--lb-primary-light: #2780a0;
		--lb-bg-panel: #15171c;
		--lb-white: #ffffff;
		--lb-text: rgba(255,255,255,.92);
		--lb-muted: rgba(255,255,255,.6);
		--lb-card-border: rgba(255,255,255,.85);
		--lb-line: rgba(255,255,255,.18);
		--lb-input-bg: rgba(255,255,255,.07);
		--lb-input-border: rgba(255,255,255,.35);
		--lb-danger: #ff6b7a;
		--lb-success: #28a745;
		--lb-radius-card: 1rem;
		--lb-radius-btn: 15px;
		--lb-radius-input: 10px;
		--lb-font: 'Ubuntu',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Arial,sans-serif;
		--lb-font-display: 'Oswald','Ubuntu',sans-serif;
	}
	.lb-form-wrapper {
		display: flex;
		flex-direction: column;
		max-width: 820px;
		height: 85vh;
		max-height: 85vh;
		margin: 0 auto;
		background: radial-gradient(120% 90% at 50% 0%,rgba(9,111,148,.28) 0%,rgba(9,111,148,0) 55%),var(--lb-bg-panel);
		border: 1px solid var(--lb-line);
		border-radius: var(--lb-radius-card);
		box-shadow: 0 1rem 3rem rgba(0,0,0,.55);
		font-family: var(--lb-font);
		color: var(--lb-text);
		color-scheme: dark;
	}
	.lb-header,.lb-steps { flex-shrink: 0; }
	#lb-event-form { display:flex;flex-direction:column;flex:1;min-height:0; }
	.lb-header { text-align:center;padding:2.25rem 1.5rem 0; }
	.lb-logo { height:38px;width:auto;margin-bottom:1.1rem; }
	.lb-logo-text { display:block;color:var(--lb-white);font-size:1.6rem;font-weight:700;letter-spacing:.5px;margin-bottom:1.1rem; }
	.lb-title { margin:0 0 .4rem;font-family:var(--lb-font-display);font-size:1.9rem;font-weight:500;text-transform:uppercase;letter-spacing:1.5px;color:var(--lb-white); }
	.lb-subtitle { margin:0 auto;max-width:480px;color:var(--lb-muted);font-size:.95rem;font-weight:300; }
	.lb-steps { position:relative;display:flex;padding:1.75rem 2rem 1rem;gap:.25rem; }
	.lb-steps-track { position:absolute;top:calc(1.75rem + 17px);left:14%;right:14%;height:2px;background:var(--lb-line);border-radius:2px; }
	.lb-steps-fill { height:100%;width:0;background:var(--lb-primary-hover);border-radius:2px;transition:width .35s ease; }
	.lb-step { position:relative;z-index:1;flex:1;display:flex;flex-direction:column;align-items:center;gap:.45rem;padding:0;background:none;border:none;font-family:var(--lb-font-display);font-size:.8rem;font-weight:400;text-transform:uppercase;letter-spacing:1px;color:var(--lb-muted);cursor:pointer;transition:color .2s; }
	.lb-step-num { display:inline-flex;align-items:center;justify-content:center;width:34px;height:34px;border-radius:50%;background:var(--lb-bg-panel);border:1px solid var(--lb-input-border);color:var(--lb-muted);font-size:.9rem;transition:background .2s,border-color .2s,color .2s,transform .2s,box-shadow .2s; }
	.lb-step:hover .lb-step-num { border-color:var(--lb-white);color:var(--lb-white); }
	.lb-step.is-active { color:var(--lb-white); }
	.lb-step.is-active .lb-step-num { background:var(--lb-primary);border-color:var(--lb-white);color:var(--lb-white);transform:scale(1.12);box-shadow:0 0 0 .25rem rgba(9,111,148,.35); }
	.lb-step.is-done { color:var(--lb-primary-hover); }
	.lb-step.is-done .lb-step-num { background:var(--lb-primary);border-color:var(--lb-primary);color:transparent;position:relative; }
	.lb-step.is-done .lb-step-num::before { content:'✓';position:absolute;inset:0;display:flex;align-items:center;justify-content:center;color:var(--lb-white); }
	.lb-panel { display:none;padding:.75rem 2rem 1.5rem; }
	.lb-panel.is-active { display:block;flex:1;min-height:0;overflow-y:auto;animation:lb-panel-in .3s ease; }
	@keyframes lb-panel-in { from{opacity:0;transform:translateX(14px)} to{opacity:1;transform:translateX(0)} }
	.lb-panel-title { margin:0 0 1.25rem;font-family:var(--lb-font-display);font-size:1.05rem;font-weight:500;text-transform:uppercase;letter-spacing:1.2px;color:var(--lb-white);display:flex;align-items:center;gap:.6rem; }
	.lb-panel-title::before { content:'';width:4px;height:1.15em;background:var(--lb-primary-hover);border-radius:2px; }
	.lb-grid { display:grid;grid-template-columns:repeat(12,1fr);gap:1.1rem 1.25rem; }
	.lb-col-3 { grid-column:span 3; }
	.lb-col-4 { grid-column:span 4; }
	.lb-col-6 { grid-column:span 6; }
	.lb-col-8 { grid-column:span 8; }
	.lb-col-12 { grid-column:span 12; }
	@media(max-width:640px){
		.lb-col-3,.lb-col-4,.lb-col-6,.lb-col-8{grid-column:span 12;}
		.lb-step-label{display:none;}
		.lb-panel{padding:.5rem 1.25rem 1.25rem;}
		.lb-steps{padding:1.5rem 1.25rem .75rem;}
		.lb-title{font-size:1.5rem;}
	}
	.lb-field label { display:block;font-size:.82rem;font-weight:500;letter-spacing:.3px;margin-bottom:.45rem;color:var(--lb-text); }
	.req { color:var(--lb-primary-hover); }
	.lb-phone { display:flex;gap:.6rem; }
	.lb-field .lb-phone select.lb-phone-code { width:140px;flex-shrink:0;text-overflow:ellipsis; }
	.lb-field .lb-phone input { width:auto;flex:1;min-width:0; }
	@media(max-width:640px){ .lb-field .lb-phone select.lb-phone-code{width:120px;} }
	.lb-alert { padding:.8rem 1rem;border:1px solid var(--lb-danger);border-radius:var(--lb-radius-input);background:rgba(220,53,69,.15);color:var(--lb-danger);font-size:.88rem; }
	.lb-alert[hidden] { display:none; }
	.lb-optional { color:var(--lb-muted);font-weight:300;font-size:.75rem; }
	.lb-field input,.lb-field select,.lb-field textarea { width:100%;padding:.6rem .85rem;font-family:inherit;font-size:.95rem;font-weight:300;color:var(--lb-white);border:1px solid var(--lb-input-border);border-radius:var(--lb-radius-input);background:var(--lb-input-bg);transition:border-color .15s ease-in-out,box-shadow .15s ease-in-out,background .15s; }
	.lb-field input::placeholder,.lb-field textarea::placeholder { color:rgba(255,255,255,.35);font-weight:300; }
	.lb-field select { appearance:auto; }
	.lb-field select option { background:var(--lb-bg-panel);color:var(--lb-white); }
	.lb-field input:focus,.lb-field select:focus,.lb-field textarea:focus { outline:none;background:rgba(255,255,255,.1);border-color:var(--lb-primary-hover);box-shadow:0 0 0 .2rem rgba(9,111,148,.4); }
	.lb-field.is-invalid input,.lb-field.is-invalid select,.lb-field.is-invalid textarea { border-color:var(--lb-danger);box-shadow:0 0 0 .2rem rgba(220,53,69,.25); }
	.lb-error { display:none;color:var(--lb-danger);font-size:.78rem;margin-top:.3rem; }
	.lb-field.is-invalid .lb-error { display:block; }
	.lb-hint { display:block;color:var(--lb-muted);font-size:.78rem;font-weight:300;margin-top:.3rem; }
	.lb-ticket { padding:1.1rem;margin-bottom:.9rem;background:transparent;border:1px solid var(--lb-card-border);border-radius:var(--lb-radius-card); }
	.lb-ticket label { font-size:.76rem; }
	.lb-ticket-head { display:grid;grid-template-columns:1fr 38px;gap:.75rem .85rem;align-items:end;margin-bottom:.85rem; }
	.t-lote-row { display:grid;grid-template-columns:1fr 115px 100px 38px;gap:.75rem .85rem;align-items:end;padding:.65rem .75rem;margin-bottom:.6rem;border:1px dashed var(--lb-input-border);border-radius:var(--lb-radius-input); }
	@media(max-width:640px){ .t-lote-row{grid-template-columns:1fr 1fr 38px;} .t-lote-row .lb-field:first-child{grid-column:span 3;} }
	.lb-ticket-remove { height:40px;border:none;background:none;color:var(--lb-muted);font-size:1.3rem;cursor:pointer;border-radius:50%;transition:color .15s,background .15s; }
	.lb-ticket-remove:hover { color:#fff;background:rgba(220,53,69,.35); }
	.lb-tickets-bar { display:flex;align-items:center;justify-content:space-between;gap:1rem;flex-wrap:wrap; }
	.lb-total { font-size:.9rem;font-weight:300;color:var(--lb-muted);padding:.5rem 1.1rem;border:1px solid var(--lb-input-border);border-radius:var(--lb-radius-btn);background:var(--lb-input-bg); }
	.lb-total strong { color:var(--lb-white);font-family:var(--lb-font-display);font-weight:500;font-size:1rem; }
	.lb-desconto { display:grid;grid-template-columns:1fr 140px 38px;gap:.75rem .85rem;align-items:end;padding:.85rem;margin-bottom:.75rem;border:1px solid var(--lb-input-border);border-radius:var(--lb-radius-input); }
	@media(max-width:640px){ .lb-desconto{grid-template-columns:1fr 1fr 38px;} }
	.lb-desconto label { font-size:.76rem; }
	.lb-btn-sm { font-size:.8rem;padding:.4rem 1.2rem; }
	.lb-conditional[hidden] { display:none; }
	.lb-files { display:flex;flex-wrap:wrap;gap:.5rem;margin-top:.6rem; }
	.lb-files:empty { display:none; }
	.lb-file-chip { display:inline-flex;align-items:center;gap:.45rem;max-width:100%;padding:.3rem .45rem .3rem .85rem;font-size:.8rem;font-weight:300;color:var(--lb-text);border:1px solid var(--lb-input-border);border-radius:var(--lb-radius-btn);background:var(--lb-input-bg); }
	.lb-file-name { max-width:220px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap; }
	.lb-file-chip button { display:inline-flex;align-items:center;justify-content:center;width:20px;height:20px;border:none;border-radius:50%;background:none;color:var(--lb-muted);font-size:1rem;line-height:1;cursor:pointer;transition:color .15s,background .15s; }
	.lb-file-chip button:hover { color:#fff;background:rgba(220,53,69,.45); }
	.lb-summary { background:transparent;border:1px solid var(--lb-card-border);border-radius:var(--lb-radius-card);padding:1.2rem 1.4rem;margin-bottom:1.25rem;font-size:.9rem; }
	.lb-summary h3 { margin:1rem 0 .45rem;font-family:var(--lb-font-display);font-size:.8rem;font-weight:500;text-transform:uppercase;letter-spacing:1.2px;color:var(--lb-primary-hover); }
	.lb-summary h3:first-child { margin-top:0; }
	.lb-summary dl { margin:0;display:grid;grid-template-columns:170px 1fr;row-gap:.3rem; }
	@media(max-width:640px){ .lb-summary dl{grid-template-columns:1fr;} .lb-summary dt{margin-top:.4rem;} }
	.lb-summary dt { color:var(--lb-muted);font-weight:300; }
	.lb-summary dd { margin:0;color:var(--lb-white); }
	.lb-check { display:flex;gap:.65rem;align-items:flex-start;font-size:.9rem;font-weight:300;cursor:pointer;color:var(--lb-text); }
	.lb-check input { margin-top:.2rem;width:1.05rem;height:1.05rem;accent-color:var(--lb-primary);flex-shrink:0; }
	.lb-check a { color:var(--lb-primary-hover); }
	.lb-checks { display:flex;flex-wrap:wrap;gap:.6rem; }
	.lb-check-pill { align-items:center;gap:.5rem;padding:.45rem .9rem;border:1px solid var(--lb-input-border);border-radius:var(--lb-radius-btn);background:var(--lb-input-bg);font-size:.85rem;transition:border-color .15s,background .15s; }
	.lb-check-pill:hover { border-color:var(--lb-white); }
	.lb-check-pill:has(input:checked) { border-color:var(--lb-primary-hover);background:rgba(9,111,148,.3); }
	.lb-check-pill input { margin-top:0; }
	.lb-field input[type="file"] { padding:.45rem .55rem;cursor:pointer; }
	.lb-field input[type="file"]::file-selector-button { font-family:var(--lb-font-display);font-size:.8rem;text-transform:uppercase;letter-spacing:.8px;color:var(--lb-white);background:var(--lb-primary);border:1px solid var(--lb-white);border-radius:var(--lb-radius-btn);padding:.35rem 1rem;margin-right:.85rem;cursor:pointer;transition:background .15s; }
	.lb-field input[type="file"]::file-selector-button:hover { background:var(--lb-primary-hover); }
	#lb-termos-error { display:none; }
	#lb-termos-error.is-visible { display:block; }
	.lb-btn { font-family:var(--lb-font-display);font-size:.95rem;font-weight:500;text-transform:uppercase;letter-spacing:1px;padding:.55rem 1.9rem;border-radius:var(--lb-radius-btn);border:1px solid transparent;cursor:pointer;transition:background .15s,color .15s,border-color .15s,box-shadow .15s,transform .15s; }
	.lb-btn-primary { background:var(--lb-primary);border-color:var(--lb-white);color:var(--lb-white); }
	.lb-btn-primary:hover { background:var(--lb-primary-hover);transform:translateY(-1px);box-shadow:0 .35rem 1rem rgba(9,111,148,.45); }
	.lb-btn-primary:focus { box-shadow:0 0 0 .2rem rgba(9,111,148,.5); }
	.lb-btn-primary:disabled { opacity:.6;cursor:not-allowed;transform:none;box-shadow:none; }
	.lb-btn-submit { flex:1; }
	.lb-btn-outline { background:transparent;border-color:var(--lb-white);color:var(--lb-white); }
	.lb-btn-outline:hover { background:var(--lb-primary); }
	.lb-btn-ghost { background:none;border-color:transparent;color:var(--lb-muted); }
	.lb-btn-ghost:hover { color:var(--lb-white); }
	.lb-nav { flex-shrink:0;display:flex;align-items:center;gap:1rem;padding:1rem 2rem 1.25rem;background:var(--lb-bg-panel);border-top:1px solid var(--lb-line);border-radius:0 0 var(--lb-radius-card) var(--lb-radius-card); }
	.lb-nav-spacer { flex:1; }
	.lb-nav.is-hidden { display:none; }
	.lb-nav:has(.lb-btn-submit:not([hidden])) .lb-nav-spacer { display:none; }
	.lb-success { text-align:center;padding:2.5rem 1.5rem; }
	.lb-success-icon { width:76px;height:76px;margin:0 auto 1.4rem;border-radius:50%;background:var(--lb-primary);border:1px solid var(--lb-white);color:var(--lb-white);font-size:2.3rem;line-height:76px;animation:lb-pop .35s ease; }
	@keyframes lb-pop { 0%{transform:scale(.4);opacity:0} 70%{transform:scale(1.1)} 100%{transform:scale(1);opacity:1} }
	.lb-success h2 { margin:0 0 .5rem;font-family:var(--lb-font-display);font-weight:500;text-transform:uppercase;letter-spacing:1.5px;color:var(--lb-white); }
	.lb-success p { color:var(--lb-muted);max-width:440px;margin:0 auto 1.75rem;font-weight:300; }
	</style>

	<div class="modal fade" id="vendaIngressoModal" tabindex="-1" aria-labelledby="vendaIngressoLabel" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered" style="max-width:820px;">
			<div class="modal-content">
				<div class="modal-body" style="padding:0;">

					<div class="lb-form-wrapper">

						<header class="lb-header">
							<img src="{{ url() }}{{ config.company.logos }}white_new.png" alt="lebillet" class="lb-logo"
								onerror="this.outerHTML='<span class=&quot;lb-logo-text&quot;>lebillet</span>'">
							<h1 class="lb-title">Venda o seu Evento</h1>
							<p class="lb-subtitle">Preencha os dados do seu evento — a nossa equipa entra em contacto consigo.</p>
						</header>

						<nav class="lb-steps" aria-label="Progresso">
							<div class="lb-steps-track"><div class="lb-steps-fill" id="lb-progress-fill"></div></div>
							<button type="button" class="lb-step is-active" data-goto="1"><span class="lb-step-num">1</span><span class="lb-step-label">Promotor</span></button>
							<button type="button" class="lb-step" data-goto="2"><span class="lb-step-num">2</span><span class="lb-step-label">Evento</span></button>
							<button type="button" class="lb-step" data-goto="3"><span class="lb-step-num">3</span><span class="lb-step-label">Bilhetes</span></button>
							<button type="button" class="lb-step" data-goto="4"><span class="lb-step-num">4</span><span class="lb-step-label">Revisão</span></button>
						</nav>

						<form id="lb-event-form" novalidate>

							<!-- PASSO 1 · Promotor -->
							<section class="lb-panel is-active" data-step="1">
								<h2 class="lb-panel-title">Dados do Promotor</h2>
								<div class="lb-grid">
									<div class="lb-field lb-col-6">
										<label for="promotorNome">Nome do responsável <span class="req">*</span></label>
										<input type="text" id="promotorNome" name="name" required autocomplete="name" placeholder="ex.: Maria Silva">
										<small class="lb-error">Indique o nome do responsável.</small>
									</div>
									<div class="lb-field lb-col-6">
										<label for="promotorEntidade">Entidade / Empresa</label>
										<input type="text" id="promotorEntidade" name="subject" autocomplete="organization" placeholder="ex.: Eventos &amp; Companhia, Lda">
									</div>
									<div class="lb-field lb-col-6">
										<label for="promotorNif">NIF <span class="req">*</span></label>
										<input type="text" id="promotorNif" name="promotorNif" required maxlength="20" placeholder="ex.: 123456789">
										<small class="lb-error">Indique o NIF.</small>
									</div>
									<div class="lb-field lb-col-6">
										<label for="promotorEmail">Email <span class="req">*</span></label>
										<input type="email" id="promotorEmail" name="email" required autocomplete="email" placeholder="nome@exemplo.pt">
										<small class="lb-error">Indique um email válido.</small>
									</div>
									<div class="lb-field lb-col-6">
										<label for="promotorTelefone">Telefone <span class="req">*</span></label>
										<div class="lb-phone">
											<select id="promotorIndicativo" name="promotorIndicativo" class="lb-phone-code" aria-label="Indicativo do país"></select>
											<input type="tel" id="promotorTelefone" name="phone" required autocomplete="tel-national" placeholder="912 345 678">
										</div>
										<small class="lb-error">Indique um contacto telefónico.</small>
									</div>
									<div class="lb-field lb-col-6">
										<label for="promotorWebsite">Website ou rede social</label>
										<input type="text" id="promotorWebsite" name="promotorWebsite" placeholder="www.exemplo.pt ou @instagram">
									</div>
								</div>
							</section>

							<!-- PASSO 2 · Evento -->
							<section class="lb-panel" data-step="2">
								<h2 class="lb-panel-title">Dados do Evento</h2>
								<div class="lb-grid">
									<div class="lb-field lb-col-8">
										<label for="eventoNome">Nome do evento <span class="req">*</span></label>
										<input type="text" id="eventoNome" name="eventoNome" required placeholder="ex.: Festival de Verão 2026">
										<small class="lb-error">Indique o nome do evento.</small>
									</div>
									<div class="lb-field lb-col-4">
										<label for="eventoCategoria">Categoria <span class="req">*</span></label>
										<select id="eventoCategoria" name="eventoCategoria" required>
											<option value="">— Selecionar —</option>
											<option>Concerto</option>
											<option>Festival</option>
											<option>Teatro</option>
											<option>Stand-up Comedy</option>
											<option>Conferência</option>
											<option>Desporto</option>
											<option>Família</option>
											<option>Outro</option>
										</select>
										<small class="lb-error">Selecione uma categoria.</small>
									</div>
									<div class="lb-field lb-col-12">
										<label for="eventoDescricao">Descrição <span class="req">*</span></label>
										<textarea id="eventoDescricao" name="message" rows="4" required
											placeholder="Descreva o evento tal como deverá aparecer na página de venda."></textarea>
										<small class="lb-error">Escreva uma breve descrição.</small>
									</div>
									<div class="lb-field lb-col-4">
										<label for="eventoDataInicio">Data do evento <span class="req">*</span></label>
										<input type="date" id="eventoDataInicio" name="eventoDataInicio" required>
										<small class="lb-error">Indique a data.</small>
									</div>
									<div class="lb-field lb-col-4">
										<label for="eventoAberturaPortas">Abertura de portas</label>
										<select id="eventoAberturaPortas" name="eventoAberturaPortas" data-time-slots>
											<option value="">— Selecionar —</option>
										</select>
									</div>
									<div class="lb-field lb-col-4">
										<label for="eventoHoraInicio">Hora de início <span class="req">*</span></label>
										<select id="eventoHoraInicio" name="eventoHoraInicio" required data-time-slots>
											<option value="">— Selecionar —</option>
										</select>
										<small class="lb-error">Indique a hora.</small>
									</div>
									<div class="lb-field lb-col-6">
										<label for="vendasFim">Fim das vendas — data</label>
										<input type="date" id="vendasFim" name="vendasFim">
									</div>
									<div class="lb-field lb-col-6">
										<label for="vendasFimHora">Fim das vendas — hora</label>
										<select id="vendasFimHora" name="vendasFimHora" data-time-slots>
											<option value="">— Selecionar —</option>
										</select>
									</div>
									<div class="lb-field lb-col-12 lb-alert" id="vendasAlert" hidden>
										⚠ O fim das vendas tem <strong>mais de 12 horas de diferença</strong> da abertura de portas. É mesmo assim?
									</div>
									<div class="lb-field lb-col-6">
										<label for="eventoLocal">Recinto / Local <span class="req">*</span></label>
										<input type="text" id="eventoLocal" name="eventoLocal" required placeholder="ex.: Coliseu do Porto">
										<small class="lb-error">Indique o local do evento.</small>
									</div>
									<div class="lb-field lb-col-6">
										<label for="eventoMorada">Morada <span class="lb-optional">(opcional)</span></label>
										<input type="text" id="eventoMorada" name="eventoMorada" autocomplete="street-address" placeholder="Rua, número, código postal">
									</div>
									<div class="lb-field lb-col-6">
										<label for="eventoCidade">Cidade <span class="req">*</span></label>
										<input type="text" id="eventoCidade" name="eventoCidade" required placeholder="ex.: Porto">
										<small class="lb-error">Indique a cidade.</small>
									</div>
									<div class="lb-field lb-col-6">
										<label for="eventoPais">País <span class="req">*</span></label>
										<select id="eventoPais" name="eventoPais" required>
											<option value="">— Selecionar —</option>
										</select>
										<small class="lb-error">Selecione o país.</small>
									</div>
									<div class="lb-field lb-col-6">
										<label for="imgPrincipal">Imagem principal — 1438×959 <span class="req">*</span></label>
										<input type="file" id="imgPrincipal" name="imgPrincipal" required accept="image/png,image/jpeg,image/webp" data-dims="1438x959">
										<small class="lb-hint">JPG, PNG ou WebP com 1438×959 px.</small>
										<small class="lb-error">Anexe uma imagem com 1438×959 px.</small>
									</div>
									<div class="lb-field lb-col-6">
										<label for="imgBanner">Banner — 1440×340 <span class="req">*</span></label>
										<input type="file" id="imgBanner" name="imgBanner" required accept="image/png,image/jpeg,image/webp" data-dims="1440x340">
										<small class="lb-hint">JPG, PNG ou WebP com 1440×340 px.</small>
										<small class="lb-error">Anexe uma imagem com 1440×340 px.</small>
									</div>
									<div class="lb-field lb-col-12">
										<label for="mediaSocial">Imagens / vídeos para redes sociais <span class="lb-optional">(opcional)</span></label>
										<input type="file" id="mediaSocial" name="mediaSocial" multiple accept="image/*,video/*">
										<small class="lb-hint">Pode anexar várias imagens ou vídeos.</small>
										<div class="lb-files" id="mediaSocialList"></div>
									</div>
								</div>
							</section>

							<!-- PASSO 3 · Bilhetes -->
							<section class="lb-panel" data-step="3">
								<h2 class="lb-panel-title">Bilhética</h2>
								<div id="lb-tickets"></div>
								<div class="lb-tickets-bar">
									<button type="button" class="lb-btn lb-btn-outline" id="lb-add-ticket">+ Adicionar tipo de bilhete</button>
									<div class="lb-total" id="lb-lotacao-total" aria-live="polite">Lotação total: <strong>0</strong> bilhetes</div>
								</div>
								<div class="lb-grid" style="margin-top:1.25rem">
									<div class="lb-field lb-col-6">
										<label for="idadeRestricao">Restrição de idade <span class="req">*</span></label>
										<select id="idadeRestricao" name="idadeRestricao" required>
											<option value="">— Selecionar —</option>
											<option value="Sem restrição">Sem restrição</option>
										</select>
										<small class="lb-error">Indique a restrição de idade.</small>
									</div>
									<div class="lb-field lb-col-12">
										<label>Características do evento <span class="lb-optional">(selecione as que se aplicam)</span></label>
										<div class="lb-checks">
											<label class="lb-check lb-check-pill"><input type="checkbox" name="obsOpcoes" value="Lugares marcados" data-toggles="fld-mapa"><span>Lugares marcados</span></label>
											<label class="lb-check lb-check-pill"><input type="checkbox" name="obsOpcoes" value="Acessos especiais / mobilidade reduzida" data-toggles="fld-mobilidade"><span>Acessos especiais / mobilidade reduzida</span></label>
											<label class="lb-check lb-check-pill"><input type="checkbox" name="obsOpcoes" value="Descontos / promoções" data-toggles="fld-descontos"><span>Descontos / promoções</span></label>
										</div>
									</div>
									<div class="lb-field lb-col-12 lb-conditional" id="fld-mapa" hidden>
										<label for="mapaSala">Mapa da sala <span class="lb-optional">(opcional)</span></label>
										<input type="file" id="mapaSala" name="mapaSala" accept="image/*,application/pdf">
										<small class="lb-hint">Anexe o mapa de lugares (imagem ou PDF).</small>
									</div>
									<div class="lb-field lb-col-6 lb-conditional" id="fld-mobilidade" hidden>
										<label for="mobilidadeLotacao">Lotação para mobilidade reduzida <span class="req">*</span></label>
										<input type="number" id="mobilidadeLotacao" name="mobilidadeLotacao" min="1" placeholder="ex.: 10">
										<small class="lb-error">Indique a lotação para este tipo de bilhete.</small>
									</div>
									<div class="lb-field lb-col-12 lb-conditional" id="fld-descontos" hidden>
										<label>Descontos</label>
										<div id="lb-descontos"></div>
										<button type="button" class="lb-btn lb-btn-outline lb-btn-sm" id="lb-add-desconto">+ Adicionar desconto</button>
									</div>
									<div class="lb-field lb-col-12">
										<label for="observacoes">Outras observações <span class="lb-optional">(opcional)</span></label>
										<textarea id="observacoes" name="observacoes" rows="3"
											placeholder="Detalhes adicionais que devamos saber"></textarea>
									</div>
								</div>
							</section>

							<!-- PASSO 4 · Revisão -->
							<section class="lb-panel" data-step="4">
								<h2 class="lb-panel-title">Revisão e Submissão</h2>
								<div id="lb-summary" class="lb-summary"></div>
								<label class="lb-check">
									<input type="checkbox" id="aceitaTermos" name="aceitaTermos" required>
									<span>Declaro que os dados são verdadeiros e aceito os <a href="{{ url() }}info/termos-condicoes" target="_blank" rel="noopener">Termos e Condições</a> da lebillet. <span class="req">*</span></span>
								</label>
								<small class="lb-error" id="lb-termos-error">Tem de aceitar os termos para submeter.</small>
								<div style="margin-top:1.25rem;display:flex;justify-content:center;">
									<div class="g-recaptcha" id="lb-recaptcha" data-sitekey="<?php echo $recaptcha; ?>" data-theme="dark"></div>
								</div>
								<small class="lb-error" id="lb-recaptcha-error" style="display:none;text-align:center;margin-top:.4rem;">Por favor, confirme que não é um robô.</small>
							</section>

							<!-- Ecrã de sucesso -->
							<section class="lb-panel" data-step="success">
								<div class="lb-success">
									<div class="lb-success-icon">✓</div>
									<h2>Evento submetido!</h2>
									<p>Obrigado. Vai receber uma cópia da submissão no email indicado e a nossa equipa entrará em contacto consigo brevemente.</p>
									<button type="button" class="lb-btn lb-btn-primary" id="lb-close" data-dismiss="modal">FECHAR</button>
								</div>
							</section>

							<!-- Navegação -->
							<footer class="lb-nav">
								<button type="button" class="lb-btn lb-btn-ghost" id="lb-prev" hidden>← ANTERIOR</button>
								<span class="lb-nav-spacer"></span>
								<button type="button" class="lb-btn lb-btn-primary" id="lb-next">SEGUINTE →</button>
								<button type="submit" class="lb-btn lb-btn-primary lb-btn-submit" id="lb-submit" hidden>SUBMETER EVENTO</button>
							</footer>
						</form>

					</div><!-- /.lb-form-wrapper -->

				</div><!-- /.modal-body -->
			</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div><!-- /#vendaIngressoModal -->

	<script>
	const SUBMIT_CONFIG = {
		mode: 'email',
		emailEndpoint: '{{ url() }}index/sendMailEvent',
		googleFormUrl: '',
		fieldMap: {},
		apiUrl: '/api/eventos/submeter'
	};

	const LB_PAISES_PRINCIPAIS = ['PT','ES','FR','NL','IT'];
	const LB_PAISES = ['AF','ZA','AL','DE','AD','AO','AG','SA','DZ','AR','AM','AU','AT','AZ','BS','BH','BD','BB','BE','BZ','BJ','BY','BO','BA','BW','BR','BN','BG','BF','BI','BT','CV','CM','KH','CA','QA','KZ','TD','CL','CN','CY','CO','KM','CG','CD','KP','KR','CI','CR','HR','CU','DK','DM','EG','SV','AE','EC','ER','SK','SI','US','EE','SZ','ET','FJ','PH','FI','GA','GM','GH','GE','GD','GR','GT','GY','GN','GW','GQ','HT','HN','HU','YE','MH','SB','IN','ID','IR','IQ','IE','IS','IL','JM','JP','DJ','JO','KI','XK','KW','LA','LS','LV','LB','LR','LY','LI','LT','LU','MK','MG','MY','MW','MV','ML','MT','MA','MU','MR','MX','MM','FM','MZ','MD','MC','MN','ME','NA','NR','NP','NI','NE','NG','NO','NZ','OM','PW','PS','PA','PG','PK','PY','PE','PL','KE','KG','GB','CF','CZ','DO','RO','RW','RU','WS','SM','LC','KN','ST','VC','SC','SN','SL','RS','SG','SY','SO','LK','SD','SS','SE','CH','SR','TH','TW','TJ','TZ','TL','TG','TO','TT','TN','TM','TR','TV','UA','UG','UY','UZ','VU','VA','VE','VN','ZM','ZW'];
	const LB_INDICATIVOS_PRINCIPAIS = [['PT','+351'],['ES','+34'],['FR','+33'],['NL','+31'],['IT','+39']];
	const LB_INDICATIVOS = [['AF','+93'],['ZA','+27'],['AL','+355'],['DE','+49'],['AD','+376'],['AO','+244'],['AG','+1268'],['SA','+966'],['DZ','+213'],['AR','+54'],['AM','+374'],['AU','+61'],['AT','+43'],['AZ','+994'],['BS','+1242'],['BH','+973'],['BD','+880'],['BB','+1246'],['BE','+32'],['BZ','+501'],['BJ','+229'],['BY','+375'],['BO','+591'],['BA','+387'],['BW','+267'],['BR','+55'],['BN','+673'],['BG','+359'],['BF','+226'],['BI','+257'],['BT','+975'],['CV','+238'],['CM','+237'],['KH','+855'],['CA','+1'],['QA','+974'],['KZ','+7'],['TD','+235'],['CL','+56'],['CN','+86'],['CY','+357'],['CO','+57'],['KM','+269'],['CG','+242'],['CD','+243'],['KP','+850'],['KR','+82'],['CI','+225'],['CR','+506'],['HR','+385'],['CU','+53'],['DK','+45'],['DM','+1767'],['EG','+20'],['SV','+503'],['AE','+971'],['EC','+593'],['ER','+291'],['SK','+421'],['SI','+386'],['US','+1'],['EE','+372'],['SZ','+268'],['ET','+251'],['FJ','+679'],['PH','+63'],['FI','+358'],['GA','+241'],['GM','+220'],['GH','+233'],['GE','+995'],['GD','+1473'],['GR','+30'],['GT','+502'],['GY','+592'],['GN','+224'],['GW','+245'],['GQ','+240'],['HT','+509'],['HN','+504'],['HU','+36'],['YE','+967'],['MH','+692'],['SB','+677'],['IN','+91'],['ID','+62'],['IR','+98'],['IQ','+964'],['IE','+353'],['IS','+354'],['IL','+972'],['JM','+1876'],['JP','+81'],['DJ','+253'],['JO','+962'],['KI','+686'],['XK','+383'],['KW','+965'],['LA','+856'],['LS','+266'],['LV','+371'],['LB','+961'],['LR','+231'],['LY','+218'],['LI','+423'],['LT','+370'],['LU','+352'],['MK','+389'],['MG','+261'],['MY','+60'],['MW','+265'],['MV','+960'],['ML','+223'],['MT','+356'],['MA','+212'],['MU','+230'],['MR','+222'],['MX','+52'],['MM','+95'],['FM','+691'],['MZ','+258'],['MD','+373'],['MC','+377'],['MN','+976'],['ME','+382'],['NA','+264'],['NR','+674'],['NP','+977'],['NI','+505'],['NE','+227'],['NG','+234'],['NO','+47'],['NZ','+64'],['OM','+968'],['PW','+680'],['PS','+970'],['PA','+507'],['PG','+675'],['PK','+92'],['PY','+595'],['PE','+51'],['PL','+48'],['KE','+254'],['KG','+996'],['GB','+44'],['CF','+236'],['CZ','+420'],['DO','+1809'],['RO','+40'],['RW','+250'],['RU','+7'],['WS','+685'],['SM','+378'],['LC','+1758'],['KN','+1869'],['ST','+239'],['VC','+1784'],['SC','+248'],['SN','+221'],['SL','+232'],['RS','+381'],['SG','+65'],['SY','+963'],['SO','+252'],['LK','+94'],['SD','+249'],['SS','+211'],['SE','+46'],['CH','+41'],['SR','+597'],['TH','+66'],['TW','+886'],['TJ','+992'],['TZ','+255'],['TL','+670'],['TG','+228'],['TO','+676'],['TT','+1868'],['TN','+216'],['TM','+993'],['TR','+90'],['TV','+688'],['UA','+380'],['UG','+256'],['UY','+598'],['UZ','+998'],['VU','+678'],['VA','+379'],['VE','+58'],['VN','+84'],['ZM','+260'],['ZW','+263']];

	(function () {
		'use strict';

		var form       = document.getElementById('lb-event-form');
		var panels     = Array.from(form.querySelectorAll('.lb-panel[data-step]'));
		var steps      = Array.from(document.querySelectorAll('.lb-step'));
		var btnPrev    = document.getElementById('lb-prev');
		var btnNext    = document.getElementById('lb-next');
		var btnSubmit  = document.getElementById('lb-submit');
		var nav        = document.querySelector('.lb-nav');
		var ticketsBox = document.getElementById('lb-tickets');
		var descontosBox = document.getElementById('lb-descontos');

		var TOTAL_STEPS = 4;
		var current = 1;

		
		document.querySelectorAll('select[data-time-slots]').forEach(function(sel) {
			for (var h = 0; h < 24; h++) {
				for (var m = 0; m < 60; m += 15) {
					var val = String(h).padStart(2,'0') + ':' + String(m).padStart(2,'0');
					var opt = document.createElement('option');
					opt.value = val; opt.textContent = val;
					sel.appendChild(opt);
				}
			}
		});

		
		(function() {
			var sel = document.getElementById('idadeRestricao');
			for (var idade = 3; idade <= 18; idade++) {
				var opt = document.createElement('option');
				opt.value = 'M/' + idade;
				opt.textContent = 'Maiores de ' + idade + ' anos';
				sel.appendChild(opt);
			}
		})();

		
		function fillGroupedSelect(sel, principais, todos, toOption) {
			var grpP = document.createElement('optgroup'); grpP.label = 'Principais';
			principais.forEach(function(item){ grpP.appendChild(toOption(item)); });
			var grpT = document.createElement('optgroup'); grpT.label = 'Todos os países';
			todos.forEach(function(item){ grpT.appendChild(toOption(item)); });
			sel.appendChild(grpP); sel.appendChild(grpT);
		}
		fillGroupedSelect(
			document.getElementById('eventoPais'),
			LB_PAISES_PRINCIPAIS,
			LB_PAISES.filter(function(p){ return !LB_PAISES_PRINCIPAIS.includes(p); }),
			function(p){ var o=document.createElement('option'); o.value=p; o.textContent=p; return o; }
		);
		var principaisNomes = LB_INDICATIVOS_PRINCIPAIS.map(function(x){ return x[0]; });
		fillGroupedSelect(
			document.getElementById('promotorIndicativo'),
			LB_INDICATIVOS_PRINCIPAIS,
			LB_INDICATIVOS.filter(function(x){ return !principaisNomes.includes(x[0]); }),
			function(x){ var o=document.createElement('option'); o.value=x[1]; o.textContent=x[1]+' '+x[0]; return o; }
		);
		document.getElementById('promotorIndicativo').value = '+351';

		
		var DIMS_TOLERANCIA = 0.05;
		document.querySelectorAll('input[type="file"][data-dims]').forEach(function(input) {
			var parts = input.dataset.dims.split('x');
			var w = Number(parts[0]), h = Number(parts[1]);
			input.addEventListener('change', function() {
				input.setCustomValidity('');
				var file = input.files[0];
				if (!file) { validateField(input); return; }
				var img = new Image();
				var url = URL.createObjectURL(file);
				img.onload = function() {
					URL.revokeObjectURL(url);
					var okW = Math.abs(img.naturalWidth - w) <= w * DIMS_TOLERANCIA;
					var okH = Math.abs(img.naturalHeight - h) <= h * DIMS_TOLERANCIA;
					if (!okW || !okH) input.setCustomValidity('A imagem tem ' + img.naturalWidth + '×' + img.naturalHeight + ' px; é necessário ' + w + '×' + h + ' px.');
					validateField(input);
				};
				img.onerror = function() { URL.revokeObjectURL(url); input.setCustomValidity('Ficheiro de imagem inválido.'); validateField(input); };
				img.src = url;
			});
		});

		
		var dataEvento     = document.getElementById('eventoDataInicio');
		var portasSel      = document.getElementById('eventoAberturaPortas');
		var vendasFimData  = document.getElementById('vendasFim');
		var vendasFimHora  = document.getElementById('vendasFimHora');
		var vendasAlert    = document.getElementById('vendasAlert');
		var vendasFimEditado = false;

		vendasFimData.addEventListener('input', function(){ vendasFimEditado=true; checkVendasAlert(); });
		vendasFimHora.addEventListener('input', function(){ vendasFimEditado=true; checkVendasAlert(); });

		function autoFillVendasFim() {
			if (vendasFimEditado || !dataEvento.value || !portasSel.value) return;
			var dt = new Date(dataEvento.value + 'T' + portasSel.value);
			if (isNaN(dt)) return;
			dt.setHours(dt.getHours() + 6);
			vendasFimData.value = dt.getFullYear() + '-' + String(dt.getMonth()+1).padStart(2,'0') + '-' + String(dt.getDate()).padStart(2,'0');
			vendasFimHora.value = String(dt.getHours()).padStart(2,'0') + ':' + String(dt.getMinutes()).padStart(2,'0');
			checkVendasAlert();
		}
		function checkVendasAlert() {
			var mostrar = false;
			if (dataEvento.value && portasSel.value && vendasFimData.value && vendasFimHora.value) {
				var portas = new Date(dataEvento.value + 'T' + portasSel.value);
				var fim = new Date(vendasFimData.value + 'T' + vendasFimHora.value);
				if (!isNaN(portas) && !isNaN(fim)) mostrar = Math.abs(fim - portas) > 12*60*60*1000;
			}
			vendasAlert.hidden = !mostrar;
		}
		portasSel.addEventListener('change', function(){ autoFillVendasFim(); checkVendasAlert(); });
		dataEvento.addEventListener('change', function(){ autoFillVendasFim(); checkVendasAlert(); });

		
		var horaInicioSel  = document.getElementById('eventoHoraInicio');
		var horaInicioErro = horaInicioSel.closest('.lb-field').querySelector('.lb-error');
		function checkHoraInicio() {
			if (portasSel.value && horaInicioSel.value && horaInicioSel.value < portasSel.value) {
				horaInicioSel.setCustomValidity('A hora de início não pode ser antes da abertura de portas.');
				horaInicioErro.textContent = 'A hora de início não pode ser antes da abertura de portas (' + portasSel.value + ').';
			} else {
				horaInicioSel.setCustomValidity('');
				horaInicioErro.textContent = 'Indique a hora.';
			}
			validateField(horaInicioSel);
		}
		horaInicioSel.addEventListener('change', checkHoraInicio);
		portasSel.addEventListener('change', checkHoraInicio);

		
		var socialInput = document.getElementById('mediaSocial');
		var socialList  = document.getElementById('mediaSocialList');
		var socialStore = new DataTransfer();
		function renderSocialList() {
			socialList.innerHTML = '';
			Array.from(socialStore.files).forEach(function(f, i) {
				var chip   = document.createElement('span'); chip.className = 'lb-file-chip';
				var name   = document.createElement('span'); name.className  = 'lb-file-name'; name.textContent = f.name;
				var remove = document.createElement('button'); remove.type = 'button';
				remove.setAttribute('aria-label','Remover ' + f.name); remove.textContent = '×';
				remove.addEventListener('click', function(){ socialStore.items.remove(i); socialInput.files = socialStore.files; renderSocialList(); });
				chip.appendChild(name); chip.appendChild(remove); socialList.appendChild(chip);
			});
		}
		socialInput.addEventListener('change', function() {
			Array.from(socialInput.files).forEach(function(f) {
				var dup = Array.from(socialStore.files).some(function(x){ return x.name===f.name && x.size===f.size; });
				if (!dup) socialStore.items.add(f);
			});
			socialInput.files = socialStore.files;
			renderSocialList();
		});

		
		document.querySelectorAll('input[data-toggles]').forEach(function(chk) {
			var target = document.getElementById(chk.dataset.toggles);
			chk.addEventListener('change', function() {
				target.hidden = !chk.checked;
				var mob = document.getElementById('mobilidadeLotacao');
				if (chk.dataset.toggles === 'fld-mobilidade') {
					mob.required = chk.checked;
					if (!chk.checked) { mob.value = ''; mob.closest('.lb-field').classList.remove('is-invalid'); }
				}
				if (chk.dataset.toggles === 'fld-descontos' && chk.checked && !descontosBox.children.length) addDescontoRow();
			});
		});

		
		function addLoteRow(lotesBox, data) {
			var row = document.createElement('div'); row.className = 't-lote-row';
			row.innerHTML = '<div class="lb-field"><label>Lote</label><input type="text" class="t-lote" placeholder="ex.: 1º Lote"></div>' +
				'<div class="lb-field"><label>Preço (€) <span class="req">*</span></label><input type="number" class="t-preco" min="0" step="0.01" placeholder="0.00" required><small class="lb-error">Obrigatório.</small></div>' +
				'<div class="lb-field"><label>Quantidade <span class="req">*</span></label><input type="number" class="t-qtd" min="1" placeholder="ex.: 200" required><small class="lb-error">Obrigatório.</small></div>' +
				'<button type="button" class="lb-ticket-remove t-remove-lote" title="Remover lote" aria-label="Remover lote">×</button>';
			row.querySelector('.t-remove-lote').addEventListener('click', function() {
				if (lotesBox.children.length > 1) { row.remove(); updateLotacaoTotal(); }
			});
			if (data) { row.querySelector('.t-lote').value=data.lote||''; row.querySelector('.t-preco').value=data.preco||''; row.querySelector('.t-qtd').value=data.qtd||''; }
			lotesBox.appendChild(row);
		}
		function addTicketRow(data) {
			var card = document.createElement('div'); card.className = 'lb-ticket';
			card.innerHTML = '<div class="lb-ticket-head"><div class="lb-field"><label>Nome do bilhete <span class="req">*</span></label><input type="text" class="t-nome" placeholder="ex.: Geral, VIP, Plateia A" required><small class="lb-error">Obrigatório.</small></div>' +
				'<button type="button" class="lb-ticket-remove t-remove-ticket" title="Remover bilhete" aria-label="Remover bilhete">×</button></div>' +
				'<div class="t-lotes"></div><button type="button" class="lb-btn lb-btn-outline lb-btn-sm t-add-lote">+ Adicionar lote</button>';
			var lotesBox = card.querySelector('.t-lotes');
			card.querySelector('.t-remove-ticket').addEventListener('click', function() {
				if (ticketsBox.children.length > 1) { card.remove(); updateLotacaoTotal(); }
			});
			card.querySelector('.t-add-lote').addEventListener('click', function(){ addLoteRow(lotesBox); });
			if (data) { card.querySelector('.t-nome').value=data.nome||''; (data.lotes&&data.lotes.length?data.lotes:[null]).forEach(function(l){ addLoteRow(lotesBox,l); }); }
			else addLoteRow(lotesBox);
			ticketsBox.appendChild(card);
		}
		document.getElementById('lb-add-ticket').addEventListener('click', function(){ addTicketRow(); });
		addTicketRow();

		function getTickets() {
			return Array.from(ticketsBox.querySelectorAll('.lb-ticket')).map(function(card) {
				return { nome: card.querySelector('.t-nome').value.trim(), lotes: Array.from(card.querySelectorAll('.t-lote-row')).map(function(row) {
					return { lote: row.querySelector('.t-lote').value.trim(), preco: row.querySelector('.t-preco').value, qtd: row.querySelector('.t-qtd').value };
				})};
			});
		}
		function getLotacaoTotal() {
			return getTickets().reduce(function(sum,t){ return sum + t.lotes.reduce(function(s,l){ return s+(parseInt(l.qtd,10)||0); },0); },0);
		}
		function updateLotacaoTotal() {
			document.querySelector('#lb-lotacao-total strong').textContent = getLotacaoTotal().toLocaleString('pt-PT');
		}
		ticketsBox.addEventListener('input', function(e){ if (e.target.classList.contains('t-qtd')) updateLotacaoTotal(); });

		
		function addDescontoRow() {
			var row = document.createElement('div'); row.className = 'lb-desconto';
			row.innerHTML = '<div class="lb-field"><label>Código de Desconto</label><input type="text" class="d-codigo" placeholder="ex.: PROMO10"></div>' +
				'<div class="lb-field"><label>% de desconto</label><input type="number" class="d-perc" min="1" max="100" placeholder="ex.: 10"></div>' +
				'<button type="button" class="lb-ticket-remove" title="Remover" aria-label="Remover desconto">×</button>';
			row.querySelector('.lb-ticket-remove').addEventListener('click', function(){ if (descontosBox.children.length > 1) row.remove(); });
			descontosBox.appendChild(row);
		}
		document.getElementById('lb-add-desconto').addEventListener('click', addDescontoRow);
		function getDescontos() {
			return Array.from(descontosBox.querySelectorAll('.lb-desconto'))
				.map(function(row){ return { codigo: row.querySelector('.d-codigo').value.trim(), percentagem: row.querySelector('.d-perc').value }; })
				.filter(function(d){ return d.codigo||d.percentagem; });
		}

		
		function validateField(input) {
			var field = input.closest('.lb-field');
			var ok = input.checkValidity();
			if (field) field.classList.toggle('is-invalid', !ok);
			return ok;
		}
		form.addEventListener('input', function(e) {
			var field = e.target.closest('.lb-field');
			if (field && field.classList.contains('is-invalid')) validateField(e.target);
		});
		function validateStep(n) {
			var panel = panels.find(function(p){ return p.dataset.step === String(n); });
			var ok = true;
			panel.querySelectorAll('input,select,textarea').forEach(function(input) {
				if (input.closest('.lb-conditional[hidden]')) return;
				if (!validateField(input)) ok = false;
			});
			if (!ok) {
				var first = panel.querySelector('.lb-field.is-invalid input,.lb-field.is-invalid select,.lb-field.is-invalid textarea');
				if (first) first.focus();
			}
			return ok;
		}

		
		function showStep(n) {
			current = n;
			panels.forEach(function(p){ p.classList.toggle('is-active', p.dataset.step === String(n)); });
			steps.forEach(function(s, i){ s.classList.toggle('is-active', i+1===n); s.classList.toggle('is-done', i+1<n); });
			var fill = document.getElementById('lb-progress-fill');
			if (fill) fill.style.width = ((n-1)/(TOTAL_STEPS-1)*100) + '%';
			btnPrev.hidden   = n === 1;
			btnNext.hidden   = n === TOTAL_STEPS;
			btnSubmit.hidden = n !== TOTAL_STEPS;
			if (n === TOTAL_STEPS) buildSummary();
			var active = panels.find(function(p){ return p.classList.contains('is-active'); });
			if (active) active.scrollTop = 0;
		}
		btnNext.addEventListener('click', function(){ if (validateStep(current)) showStep(current+1); });
		btnPrev.addEventListener('click', function(){ showStep(current-1); });
		steps.forEach(function(s, i) {
			s.addEventListener('click', function() {
				var target = i + 1;
				if (target <= current) { showStep(target); return; }
				for (var n = current; n < target; n++) { if (!validateStep(n)) { showStep(n); return; } }
				showStep(target);
			});
		});

		
		function getObsOpcoes() { return Array.from(form.querySelectorAll('input[name="obsOpcoes"]:checked')).map(function(c){ return c.value; }); }
		function getFile(id) { return document.getElementById(id).files[0] || null; }
		function getFiles(id) { return Array.from(document.getElementById(id).files); }
		function telefoneCompleto() {
			var ind = document.getElementById('promotorIndicativo').value;
			var num = document.getElementById('promotorTelefone').value.trim();
			return num ? ind + ' ' + num : '';
		}
		function collectData() {
			var data = {};
			new FormData(form).forEach(function(val, key) { if (!(val instanceof File)) data[key] = val; });
			delete data.obsOpcoes; delete data.aceitaTermos;
			data.promotorTelefone = telefoneCompleto();
			data.bilhetes      = getTickets();
			data.lotacaoTotal  = getLotacaoTotal();
			data.caracteristicas = getObsOpcoes();
			data.descontos     = getDescontos();
			data.ficheiros     = {
				imgPrincipal: getFile('imgPrincipal') ? getFile('imgPrincipal').name : '',
				imgBanner:    getFile('imgBanner')    ? getFile('imgBanner').name    : '',
				mediaSocial:  getFiles('mediaSocial').map(function(f){ return f.name; }),
				mapaSala:     getFile('mapaSala')     ? getFile('mapaSala').name     : ''
			};
			if (data.promotorWebsite && !/^https?:\/\//i.test(data.promotorWebsite) && !data.promotorWebsite.startsWith('@')) {
				data.promotorWebsite = 'https://' + data.promotorWebsite;
			}
			return data;
		}

		
		var esc = function(s){ return String(s).replace(/[&<>"']/g, function(c){ return({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]); }); };
		function ticketsTexto() {
			return getTickets().filter(function(t){ return t.nome; }).map(function(t) {
				return t.nome + ': ' + t.lotes.filter(function(l){ return l.preco||l.qtd; }).map(function(l){ return (l.lote?l.lote+' — ':'')+l.preco+' € × '+l.qtd; }).join('; ');
			});
		}
		function summaryPairs() {
			function v(id){ return document.getElementById(id).value.trim(); }
			function dt(d,h){ return [v(d),v(h)].filter(Boolean).join(' às ') || ''; }
			var descontos = getDescontos().map(function(d){ return (d.codigo||'—')+': '+(d.percentagem||'—')+'%'; });
			return {
				'Promotor': [['Responsável',v('promotorNome')],['Entidade',v('promotorEntidade')],['NIF',v('promotorNif')],['Email',v('promotorEmail')],['Telefone',telefoneCompleto()],['Website',v('promotorWebsite')]],
				'Evento':   [['Nome',v('eventoNome')],['Categoria',v('eventoCategoria')],['Descrição',v('eventoDescricao')],['Data',v('eventoDataInicio')],['Abertura de portas',v('eventoAberturaPortas')],['Hora de início',v('eventoHoraInicio')],['Fim das vendas',dt('vendasFim','vendasFimHora')],['Local',v('eventoLocal')],['Morada',v('eventoMorada')],['Cidade / País',[v('eventoCidade'),v('eventoPais')].filter(Boolean).join(', ')]],
				'Bilhética':[['Bilhetes',ticketsTexto().join('\n')],['Lotação total',getLotacaoTotal()?getLotacaoTotal().toLocaleString('pt-PT')+' bilhetes':''],['Restrição de idade',v('idadeRestricao')],['Características',getObsOpcoes().join(', ')],['Lotação mobilidade reduzida',document.getElementById('fld-mobilidade').hidden?'':v('mobilidadeLotacao')],['Descontos',document.getElementById('fld-descontos').hidden?'':descontos.join('\n')],['Outras observações',v('observacoes')]],
				'Anexos':   [['Imagem principal (1438×959)',getFile('imgPrincipal')?getFile('imgPrincipal').name:''],['Banner (1440×340)',getFile('imgBanner')?getFile('imgBanner').name:''],['Redes sociais',getFiles('mediaSocial').map(function(f){return f.name;}).join('\n')],['Mapa da sala',getFile('mapaSala')?getFile('mapaSala').name:'']]
			};
		}
		function buildSummary() {
			document.getElementById('lb-summary').innerHTML = Object.entries(summaryPairs()).map(function(entry) {
				return '<h3>'+esc(entry[0])+'</h3><dl>'+entry[1].filter(function(p){return p[1];}).map(function(p){ return '<dt>'+esc(p[0])+'</dt><dd>'+esc(p[1]).replace(/\n/g,'<br>')+'</dd>'; }).join('')+'</dl>';
			}).join('');
		}

		
		function buildEmailText() {
			return Object.entries(summaryPairs()).map(function(entry) {
				return '--- ' + entry[0].toUpperCase() + ' ---\n' +
					entry[1].filter(function(p){return p[1];}).map(function(p){ return p[0]+': '+p[1]; }).join('\n');
			}).join('\n\n');
		}
		async function submitEmail(data) {
			
			var fd = new FormData();

			
			fd.append('name',            document.getElementById('promotorNome').value.trim());
			fd.append('email',           document.getElementById('promotorEmail').value.trim());
			fd.append('phone',           telefoneCompleto());
			fd.append('subject',         document.getElementById('promotorEntidade').value.trim());
			fd.append('promotorNif',     document.getElementById('promotorNif').value.trim());
			fd.append('promotorWebsite', document.getElementById('promotorWebsite').value.trim());

			
			fd.append('eventoNome',           document.getElementById('eventoNome').value.trim());
			fd.append('eventoCategoria',      document.getElementById('eventoCategoria').value);
			fd.append('message',              document.getElementById('eventoDescricao').value.trim());
			fd.append('eventoDataInicio',     document.getElementById('eventoDataInicio').value);
			fd.append('eventoAberturaPortas', document.getElementById('eventoAberturaPortas').value);
			fd.append('eventoHoraInicio',     document.getElementById('eventoHoraInicio').value);
			fd.append('vendasFim',            document.getElementById('vendasFim').value);
			fd.append('vendasFimHora',        document.getElementById('vendasFimHora').value);
			fd.append('eventoLocal',          document.getElementById('eventoLocal').value.trim());
			fd.append('eventoMorada',         document.getElementById('eventoMorada').value.trim());
			fd.append('eventoCidade',         document.getElementById('eventoCidade').value.trim());
			fd.append('eventoPais',           document.getElementById('eventoPais').value);

			
			fd.append('bilhetes',          ticketsTexto().join(' | '));
			fd.append('lotacaoTotal',      String(getLotacaoTotal()));
			fd.append('idadeRestricao',    document.getElementById('idadeRestricao').value);
			fd.append('caracteristicas',   getObsOpcoes().join(', '));
			fd.append('mobilidadeLotacao', document.getElementById('fld-mobilidade').hidden ? '' : document.getElementById('mobilidadeLotacao').value.trim());
			fd.append('descontos',         getDescontos().map(function(d){ return (d.codigo||'—')+': '+(d.percentagem||'—')+'%'; }).join(', '));
			fd.append('observacoes',       document.getElementById('observacoes').value.trim());

			
			var imgP = document.getElementById('imgPrincipal').files[0];
			if (imgP) fd.append('imgPrincipal', imgP, imgP.name);

			var imgB = document.getElementById('imgBanner').files[0];
			if (imgB) fd.append('imgBanner', imgB, imgB.name);

			Array.from(document.getElementById('mediaSocial').files).forEach(function(f) {
				fd.append('mediaSocial[]', f, f.name);
			});

			var mapa = document.getElementById('mapaSala').files[0];
			if (mapa) fd.append('mapaSala', mapa, mapa.name);

			
			fd.append('g-recaptcha-response', typeof grecaptcha !== 'undefined' ? grecaptcha.getResponse() : '');

			
			var res = await fetch(SUBMIT_CONFIG.emailEndpoint, {
				method: 'POST',
				body: fd
			});
			var json = JSON.parse(await res.text());
			if (!json.success) throw new Error(json.msg || 'Falha no envio do email');
		}

		form.addEventListener('submit', async function(e) {
			e.preventDefault();
			var termos = document.getElementById('aceitaTermos');
			var termosError = document.getElementById('lb-termos-error');
			if (!termos.checked) { termosError.classList.add('is-visible'); termos.focus(); return; }
			termosError.classList.remove('is-visible');
			var recaptchaError = document.getElementById('lb-recaptcha-error');
			var recaptchaResp = (typeof grecaptcha !== 'undefined') ? grecaptcha.getResponse() : '';
			if (!recaptchaResp) {
				recaptchaError.style.display = 'block';
				document.getElementById('lb-recaptcha').scrollIntoView({behavior:'smooth',block:'center'});
				return;
			}
			recaptchaError.style.display = 'none';
			btnSubmit.disabled = true;
			btnSubmit.textContent = 'A SUBMETER…';
			try {
				var data = collectData();
				await submitEmail(data);
				panels.forEach(function(p){ p.classList.remove('is-active'); });
				form.querySelector('[data-step="success"]').classList.add('is-active');
				steps.forEach(function(s){ s.classList.add('is-done'); s.classList.remove('is-active'); });
				var fill = document.getElementById('lb-progress-fill');
				if (fill) fill.style.width = '100%';
				nav.classList.add('is-hidden');
			} catch(err) {
				alert('Ocorreu um erro ao submeter. Por favor tente novamente.\n(' + err.message + ')');
				btnSubmit.disabled = false;
				btnSubmit.textContent = 'SUBMETER EVENTO';
			}
		});

		
		document.getElementById('lb-close').addEventListener('click', function() {
			$('#vendaIngressoModal').modal('hide');
		});

	})();

	
	$('#vendaIngressoModal').on('hidden.bs.modal', function() {
		var f = document.getElementById('lb-event-form');
		if (!f) return;
		f.reset();
		
		f.querySelectorAll('.lb-panel').forEach(function(p){ p.classList.remove('is-active'); });
		var first = f.querySelector('.lb-panel[data-step="1"]');
		if (first) first.classList.add('is-active');
		document.querySelectorAll('.lb-step').forEach(function(s,i){ s.classList.toggle('is-active',i===0); s.classList.remove('is-done'); });
		var fill = document.getElementById('lb-progress-fill');
		if (fill) fill.style.width = '0%';
		var nav = document.querySelector('.lb-nav');
		if (nav) nav.classList.remove('is-hidden');
		var btnPrev   = document.getElementById('lb-prev');
		var btnNext   = document.getElementById('lb-next');
		var btnSubmit = document.getElementById('lb-submit');
		if (btnPrev)   btnPrev.hidden   = true;
		if (btnNext)   btnNext.hidden   = false;
		if (btnSubmit) btnSubmit.hidden = true;
		if (btnSubmit) { btnSubmit.disabled = false; btnSubmit.textContent = 'SUBMETER EVENTO'; }
		
		var ticketsBox = document.getElementById('lb-tickets');
		if (ticketsBox) ticketsBox.innerHTML = '';
		
		var descontosBox = document.getElementById('lb-descontos');
		if (descontosBox) descontosBox.innerHTML = '';
		
		['fld-mapa','fld-mobilidade','fld-descontos'].forEach(function(id){
			var el = document.getElementById(id); if (el) el.hidden = true;
		});
		
		var te = document.getElementById('lb-termos-error');
		if (te) te.classList.remove('is-visible');
		var re = document.getElementById('lb-recaptcha-error');
		if (re) re.style.display = 'none';
		if (typeof grecaptcha !== 'undefined') grecaptcha.reset();
		
		(function addTicketReset() {
			var card = document.createElement('div'); card.className = 'lb-ticket';
			card.innerHTML = '<div class="lb-ticket-head"><div class="lb-field"><label>Nome do bilhete <span class="req">*</span></label><input type="text" class="t-nome" placeholder="ex.: Geral, VIP, Plateia A" required><small class="lb-error">Obrigatório.</small></div>' +
				'<button type="button" class="lb-ticket-remove t-remove-ticket" title="Remover bilhete" aria-label="Remover bilhete">×</button></div>' +
				'<div class="t-lotes"></div><button type="button" class="lb-btn lb-btn-outline lb-btn-sm t-add-lote">+ Adicionar lote</button>';
			var loteRow = document.createElement('div'); loteRow.className = 't-lote-row';
			loteRow.innerHTML = '<div class="lb-field"><label>Lote</label><input type="text" class="t-lote" placeholder="ex.: 1º Lote"></div>' +
				'<div class="lb-field"><label>Preço (€) <span class="req">*</span></label><input type="number" class="t-preco" min="0" step="0.01" placeholder="0.00" required><small class="lb-error">Obrigatório.</small></div>' +
				'<div class="lb-field"><label>Quantidade <span class="req">*</span></label><input type="number" class="t-qtd" min="1" placeholder="ex.: 200" required><small class="lb-error">Obrigatório.</small></div>' +
				'<button type="button" class="lb-ticket-remove t-remove-lote" title="Remover lote" aria-label="Remover lote">×</button>';
			card.querySelector('.t-lotes').appendChild(loteRow);
			ticketsBox.appendChild(card);
			document.querySelector('#lb-lotacao-total strong').textContent = '0';
		})();
	});
	</script>

	<div class="modal fade" id="loginModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-body text-center">
					<h2 style="color: #096f94;">Login</h2>
					<div class="alert alert-danger alert-dismissible collapse text-left alertDanger" role="alert"></div>
					<div class="alert alert-success alert-dismissible collapse text-left alertSuccess" role="alert">
					</div>
					<form method="POST" action="{{ url() }}account/login">
						<div class="form-row">
							<div class="form-group col-md-12">
								<input type="text" class="form-control" name="email" id="email_login"
									required="required" placeholder="{{ t._('enter_email') }}"
									style="height: 100%; display: flex; border-radius: 8px; margin-top: 10px;  box-shadow: 3px 3px 5px rgba(0, 0, 0, 0.2);">
							</div>
							<div class="form-group col-md-12">
								<input type="password" class="form-control" name="password" id="password"
									required="required" placeholder="{{ t._('password') }}"
									style="height: 100%; display: flex; border-radius: 8px; margin-top: 10px; box-shadow: 3px 3px 5px rgba(0, 0, 0, 0.2);">
							</div>
							<div class="form-group col-md-12">
								<button type="submit" class="btn btn-primary btn-sm btn-block"
									style=" box-shadow: 3px 3px 5px rgba(0, 0, 0, 0.2); border-radius: 8px;">{{
									t._('log_in') }}</button>
							</div>
							<div class="form-group col-md-12">
								<a data-toggle="modal" data-target="#forgot-password-new">
									<button type="button" class="btn btn-link btn-block" data-dismiss="modal">{{
										t._('forgot_password') }}</button>
								</a>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>

	<!-- PASSWORD MODAL -->
	<div class="modal fade" id="forgot-password-new" tabindex="-1" role="dialog">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-body text-center">
					<h2 style="color: #096f94;">{{ t._('remember_password') }}</h2>
					<form action="{{ url() }}account/remember_password" method="POST" role="form">
						<input type="hidden" name="crypt" value="{{ crypt }}">
						<div class="form-group">
							<input type="email" class="form-control" id="email-remember-password"
								placeholder="{{ t._('enter_email') }}" name="email"
								style="height: 100%; display: flex; border-radius: 8px; margin-top: 10px;  box-shadow: 3px 3px 5px rgba(0, 0, 0, 0.2);">
						</div>
						<div class="form-group">
							<label for="captcha_password"></label>
							<input type="text" class="form-control" id="captcha_password"
								placeholder="{{ t._('Answer') }}: {{ number_a }} + {{ number_b}} = " name="captcha"
								style="height: 100%; display: flex; border-radius: 8px; margin-top: 10px;  box-shadow: 3px 3px 5px rgba(0, 0, 0, 0.2);">
						</div>
						<button type="submit" class="btn btn-primary btn-block">{{ t._('remember') }}</button>
					</form>
				</div>
			</div>
		</div>
	</div>

	<div class="modal fade" id="resendModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-body text-center">
					<h2 style="color: #07142d;">{{ t._('resend_ticket') }}</h2>
					<div class="alert alert-danger alert-dismissible collapse text-left alertDangerResend" role="alert">
					</div>
					<div class="alert alert-success alert-dismissible collapse text-left alertSuccessResend"
						role="alert">
					</div>
					<form method="POST" id="form_resend_ticket">
						<div class="form-row">
							<div class="form-group col-md-12">
								<input type="text" class="form-control" name="email" id="email_resend"
									required="required" placeholder="{{ t._('enter_email') }}"
									style="height: calc(1.5em + .75rem + 5px); display: flex; border-radius: 8px; margin-top: 10px;  box-shadow: 3px 3px 5px rgba(0, 0, 0, 0.2);">
							</div>
							<div class="form-group col-md-12">
								<div class="input-group flex-nowrap">
									<div class="input-group-prepend">
										<select class="form-control  custom-select form-control-sm" required="required"
											style="display: flex; border-radius: 8px 0px 0px 8px; margin-top: 10px; box-shadow: 3px 3px 5px rgba(0, 0, 0, 0.2); background-color: #f0f0f0; border: 0px solid #ced4da;"
											onchange="selectCountryMobile(this);" id="selectMobileNumber">
											<?php foreach ( $array_countries[COMPANY]  AS $country => $ddi ) : ?>
											<option value="{{ ddi }}">{{ country }} {{ ddi }}</option>
											<?php endforeach ; ?>
										</select>
										<span class="input-group-text span-ddi-mobile form-control-sm d-none"> &nbsp;
											&nbsp; </span>
										<input type="hidden" class="input-ddi-mobile form-control-sm" readonly
											name="mobile_country"
											value="<?php echo $array_countries[COMPANY]['POR']; ?>"></input>
									</div>

									<input type="tel" class="form-control form-control-sm whatsapp_number_BR"
										id="register_cell_number" name="cell_number"
										placeholder="{{ t._('Mobile Number') }}"
										style="height: calc(1.5em + .75rem + 5px); display: flex; border-radius: 0px 8px 8px 0px; margin-top: 10px; box-shadow: 3px 3px 5px rgba(0, 0, 0, 0.2); background-color: #f0f0f0;">

								</div>
							</div>
							<div class="form-group col-md-12">
								<select class="form-control" name="event" id="event_resend" required="required"
									style="height: calc(1.5em + .75rem + 5px); display: flex; border-radius: 8px; margin-top: 10px; box-shadow: 3px 3px 5px rgba(0, 0, 0, 0.2); background-color: #f0f0f0;">
									<?php foreach($eventList as $event){ ?>
									<!-- <option value="{{event['id']}}">{{event['name']}}</option> -->
									<?php } ?>
								</select>
							</div>
							<div class="form-group col-md-12" style="display: flex; justify-content: center;">
								<div class="g-recaptcha" data-sitekey="<?php echo $recaptcha; ?>"></div>
							</div>
							<div class="form-group col-md-12">
								<button type="button" class="btn btn-primary btn-sm btn-block btnEnviarResend"
									onclick="resendTicket()"
									style=" box-shadow: 3px 3px 5px rgba(0, 0, 0, 0.2); border-radius: 8px;">{{
									t._('resend') }}</button>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>

	<script src="{{ url() }}plugins/jquery/jquery.min.js"></script>
	<script src="{{ url() }}plugins/jquery/jquery-migrate-3.0.0.min.js"></script>
	<script src="{{ url() }}js/custom.js?v=1"></script>
	<?php $this->assets->outputJs() ?>
	{{ assets.outputInlineJs() }}

	<script src="{{ url() }}assets/build/js/main.js?v=3"></script>
	<script>
		$('.location-map iframe').addClass('map');
	</script>



	<?php if (  COMPANY == 'lebillet_pt' ) : ?>
	<!-- Facebook Pixel Code -->
	<script>
		!function (f, b, e, v, n, t, s) {
			if (f.fbq) return; n = f.fbq = function () {
				n.callMethod ?
					n.callMethod.apply(n, arguments) : n.queue.push(arguments)
			};
			if (!f._fbq) f._fbq = n; n.push = n; n.loaded = !0; n.version = '2.0';
			n.queue = []; t = b.createElement(e); t.async = !0;
			t.src = v; s = b.getElementsByTagName(e)[0];
			s.parentNode.insertBefore(t, s)
		}(window, document, 'script',
			'https://connect.facebook.net/en_US/fbevents.js');
		fbq('init', '541848486879756');
		fbq('track', 'PageView');
	</script>
	<noscript>
		<img height="1" width="1" src="https://www.facebook.com/tr?id=541848486879756&ev=PageView&noscript=1" />
	</noscript>
	<!-- End Facebook Pixel Code -->
	<?php endif ; ?>



	<?php /*
	***** COMUNICADO INSERIDO NA LEBILLET
	Sobre a LGPD
	*/
	 if ( COMPANY == 'lebillet' ) :
	 ?>


	<style type="text/css">
		@media only screen and (min-width: 900px) {
			#modalLGPD {
				min-width: 925px !important;
			}
		}

		@media only screen and (max-width: 900px) {
			#modalLGPD {
				width: 100% !important;
				bottom: 0 !important;
				padding-left: 5px !important;
				padding-right: 5px !important;
			}
		}

		@media screen and (max-width: 899px) and (min-width: 501px) {
			#modalLGPD {
				padding-top: 10px !important;
			}
		}
	</style>

	<div id="modalLGPD"
		style=" z-index: 2147483648; height: auto; background: #ffffff 0% 0% no-repeat padding-box; box-shadow: 0px 3px 25px #00000069; border-radius: 5px; display: flex; flex-direction: row; justify-items: center; align-items: center; padding: 0 20px; position: fixed; bottom: 10px; left: 50%; transform: translate(-50%, 0);       ">
		<span style="margin-right: 18px" id="iconLgpd">
			<svg xmlns="http://www.w3.org/2000/svg" width="20.85" height="20.85" viewBox="0 0 20.85 20.85">
				<defs>
					<style>
						.a {
							fill: #096f94;
						}
					</style>
				</defs>
				<path class="a"
					d="M11.693,8.118a.98.98,0,0,1,.977-.977h.652a.98.98,0,0,1,.977.977v.652a.98.98,0,0,1-.977.977H12.67a.98.98,0,0,1-.977-.977ZM15.6,17.566H10.389v-1.3h1.3V12.353h-1.3v-1.3H14.3v5.213h1.3ZM13,1.928A10.425,10.425,0,1,0,23.421,12.353,10.425,10.425,0,0,0,13,1.928Zm0,18.9a8.47,8.47,0,1,1,8.47-8.47A8.47,8.47,0,0,1,13,20.823Z"
					transform="translate(-2.571 -1.928)"></path>
			</svg>
		</span>
		<p
			style=" text-align: left; font-size: 12px; letter-spacing: 0px; margin-right: 30px; margin-top: 14px; color: #5b5c65; ">
			Usamos os cookies e dados de navegação visando proporcionar uma melhor experiência durante o uso do site. Ao
			continuar, você concorda com nossa
			<a href="{{ url() }}company/privacy"> Política de Privacidade</a>.
		</p>
		<div id="divButtonsLgpd" style="display: flex;flex-direction: row;       ">
			<button id="acceptCookie"
				style=" width: 99px; height: 35px; background: #096f94; border: 2px solid #096f94; border-radius: 4px; color: #fff; font: normal normal bold 13px/18px Unimed Sans;">Aceitar
			</button>
		</div>
	</div>
	<script type="text/javascript">
		(function () {
			var cookieName = '@lebillet.com.br:lgpdCookie';

			function checkCookie() {
				if (getCookie(cookieName)) {
					removeModal();
				} else {
					document.getElementById('acceptCookie').addEventListener('click', function () {
						document.cookie = '@lebillet.com.br:lgpdCookie=true';
						removeModal();
					});
				}
			}

			function getCookie(cname) {
				var name = cname + '=';
				var decodedCookie = decodeURIComponent(document.cookie);
				var ca = decodedCookie.split(';');
				for (var i = 0; i < ca.length; i++) {
					var c = ca[i];
					while (c.charAt(0) == ' ') {
						c = c.substring(1);
					}
					if (c.indexOf(name) == 0) {
						return c.substring(name.length, c.length);
					}
				}
				return '';
			}

			function removeModal() {
				document.getElementById('modalLGPD').remove();
			}
			checkCookie();
		})();
	</script>

	<?php endif ;  ?>

	<style>
		.modal-prevenda{
			
			height: auto !important;
			border-radius: 10px !important;
			padding: 7px;
			background-color: #ffffff1d;
		}

		.modal-prevenda-content{
			background-image: url("{{ url() }}img/background.png") !important;
			background-size: cover;
			background-position: center;
			background-repeat: no-repeat;
			background-color: transparent;
			border-radius: 10px !important;
			padding: 8px;
		}

		.new-input{
			display: flex !important; 
			border-radius: 5px !important; 
			margin-top: 5px !important; 
			border: 0px solid #ffffff00 !important; 
			box-shadow: 3px 3px 5px rgba(0, 0, 0, 0.2) !important; 
			height: calc(1.5em + .75rem + 5px) !important; 
			background-color: #79797911 !important;
		}

		.new-input-textarea{
			display: flex !important; 
			border-radius: 5px !important; 
			margin-top: 5px !important; 
			border: 0px solid #ffffff00 !important; 
			box-shadow: 3px 3px 5px rgba(0, 0, 0, 0.2) !important; 
			height: 100% !important; 
			background-color: #79797911 !important;
		}

		.new-input-select{
			display: flex !important; 
			border-radius: 5px 0px 0px 8px !important; 
			margin-top: 5px !important; 
			border: 0px solid #ffffff00 !important; 
			box-shadow: 0px 3px 5px rgba(0, 0, 0, 0.2) !important; 
			background-color: #79797911 !important;
		}

		.modal-header {
			border-bottom: 1px solid #dee2e61a;
		}
	</style>

	<!--Inicio mySuite Chat Script HTTPS-->
	<!-- <script type="text/javascript">
		window.$mysuite || function (t, e) { var c = $mysuite = function (t) { c._.push(t) }, s = c.s = t.createElement(e), a = t.getElementsByTagName(e)[0]; c.set = function (t) { c.set._.push(t) }, c._ = [], c.set._ = [], s.async = !0, s.setAttribute("charset", "utf-8"), s.src = "https://servidorseguro.mysuite1.com.br/client/cf/?h=946dc8df67d88416f1969600b1a82c0e&sl=lbl", c.t = +new Date, s.type = "text/javascript", a.parentNode.insertBefore(s, a) }(document, "script");
	</script> -->
	<!--Fim mySuite Chat Script HTTPS-->

	<!-- <script type="text/javascript">window.$crisp=[];window.CRISP_WEBSITE_ID="c31f6b30-7c5e-404a-97d3-a87c25ec4d58";(function(){d=document;s=d.createElement("script");s.src="https://client.crisp.chat/l.js";s.async=1;d.getElementsByTagName("head")[0].appendChild(s);})();</script>
	-->
	
	

	<script type="text/javascript">
		function selectCountryMobile(select) {

			var ddi = $(select).val();
			$('.input-ddi-mobile').val(ddi);
			$('.span-ddi-mobile').html(ddi);
		}
	</script>

	<script src="{{url()}}js/swiper-bundle.min.js"></script>
	<!-- Initialize Swiper -->
	<script>
		var swiper = new Swiper(".mySwiper", {
			spaceBetween: 30,
			centeredSlides: true,
			loop: true,
			autoplay: {
				delay: 5000,
				disableOnInteraction: false,
			},
			pagination: {
				el: ".swiper-pagination",
				clickable: true,
			},
			navigation: {
				nextEl: ".swiper-button-next",
				prevEl: ".swiper-button-prev",
			},
		});

		var swiper = new Swiper(".mySwiper_1", {
			slidesPerView: 'auto',
			spaceBetween: 24,
			loop: false,
			watchOverflow: true,
		});

		document.querySelectorAll('.mySwiper_2').forEach(function (el) {
			new Swiper(el, {
				slidesPerView: 'auto',
				spaceBetween: 24,
				loop: false,
				watchOverflow: true,
			});
		});

		document.querySelectorAll('[data-swiper-nav-for]').forEach(function (nav) {
			var target = document.getElementById(nav.getAttribute('data-swiper-nav-for'));
			if (!target || !target.swiper) return;
			var instance = target.swiper;
			var prev = nav.querySelector('.tkt-swiper-prev');
			var next = nav.querySelector('.tkt-swiper-next');
			if (prev) prev.addEventListener('click', function () { instance.slidePrev(); });
			if (next) next.addEventListener('click', function () { instance.slideNext(); });
		});

		function sendEventRegister() {
			$('.btnEnviar').prop("disabled", true);
			$('.btnEnviar').html(
				`<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Enviando...`
			);

			$('.alert').hide();
			var name = $('#name_event').val();
			var email = $('#email_event').val();
			var subject = $('#subject_event').val();
			var message = $('#message_event').val();
			var phone = $('#phone_event').val();
			if (!validateEmail(email)) {
				$('.alertDanger').text('Favor preencher o email corretamente');
				$('.alertDanger').show();
				$('.btnEnviar').prop("disabled", false);
				$('.btnEnviar').text('ENVIAR MENSAGEM');
				return;
			}

			if (name == '' || email == '' || subject == '' || message == '' || phone == '') {
				$('.alertDanger').text('Favor preencher todos os campos');
				$('.alertDanger').show();
				$('.btnEnviar').prop("disabled", false);
				$('.btnEnviar').text('ENVIAR MENSAGEM');
				return;
			}

			$.post("{{url()}}index/sendMailEvent", $('#form_event').serialize())
				.done(function (data) {
					data = JSON.parse(data);
					if (data.success) {
						$('#name_event').val('');
						$('#email_event').val('');
						$('#subject_event').val('');
						$('#message_event').val('');
						$('#phone_event').val('');
						$('.alertSuccess').text(data.msg);
						$('.alertSuccess').show();
					} else {
						$('.alertDanger').text(data.msg);
						$('.alertDanger').show();
					}

					$('.btnEnviar').prop("disabled", false);
					$('.btnEnviar').text('ENVIAR MENSAGEM');
				});
		}
	</script>

	<script>
		function resendTicket() {
			$('.btnEnviarResend').prop("disabled", true);
			$('.btnEnviarResend').html(
				`<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Enviando...`
			);

			$('.alert').hide();
			var event = $('#event_resend').find(":selected").val();
			var email = $('#email_resend').val();
			if (!validateEmail(email)) {
				$('.alertDangerResend').text('Favor preencher o email corretamente');
				$('.alertDangerResend').show();
				$('.btnEnviarResend').prop("disabled", false);
				$('.btnEnviarResend').text('ENVIAR MENSAGEM');
				return;
			}

			if (event == undefined || email == '') {
				$('.alertDangerResend').text('Favor preencher todos os campos');
				$('.alertDangerResend').show();
				$('.btnEnviarResend').prop("disabled", false);
				$('.btnEnviarResend').text('ENVIAR MENSAGEM');
				return;
			}
			$.post("{{url()}}index/resendEmail", $('#form_resend_ticket').serialize())
				.done(function (data) {
					data = JSON.parse(data);
					if (data.success) {
						$('#email_resend').val('');
						$('.alertSuccessResend').text(data.msg);
						$('.alertSuccessResend').show();
					} else {
						$('.alertDangerResend').text(data.msg);
						$('.alertDangerResend').show();
					}

					$('.btnEnviarResend').prop("disabled", false);
					$('.btnEnviarResend').text('ENVIAR MENSAGEM');
				});
		}
	</script>

	<script>
		function selectCountryMobile(select) {
			var ddi = $(select).val();
			$('.input-ddi-mobile').val(ddi);
		}

		$(document).on('keyup', '#email_resend', function (e) {
			if (validateEmail($("#email_resend").val())) {
				var email = $("#email_resend").val();
				$.post("{{url()}}index/getEventsResend/" + email)
					.done(function (data) {
						$('#event_resend').empty();
						data = JSON.parse(data);
						if (data.success) {
							$.each(data.msg, function (i, item) {
								$('#event_resend').append($('<option>', {
									value: item.id,
									text: item.name
								}));
							});
						}
					});
			}
		});
	</script>

	<a href="https://wa.me/351913666847" style="position:fixed;width:60px;height:60px;bottom:40px;right:40px;background-color:#25d366;color:#FFF;border-radius:50px;text-align:center;font-size:30px;box-shadow: 1px 1px 2px #888;
	z-index:1000;" target="_blank">
	<svg class="svg-whats" style="margin-top: 9px;" xmlns="http://www.w3.org/2000/svg" x="0px" y="0px" width="35" height="35" viewBox="0,0,256,256">
		<g fill="#ffffff" fill-rule="nonzero" stroke="none" stroke-width="1" stroke-linecap="butt" stroke-linejoin="miter" stroke-miterlimit="10" stroke-dasharray="" stroke-dashoffset="0" font-family="none" font-weight="none" font-size="none" text-anchor="none" style="mix-blend-mode: normal"><g transform="scale(5.12,5.12)"><path d="M25,2c-12.69047,0 -23,10.30953 -23,23c0,4.0791 1.11869,7.88588 2.98438,11.20898l-2.94727,10.52148c-0.09582,0.34262 -0.00241,0.71035 0.24531,0.96571c0.24772,0.25536 0.61244,0.35989 0.95781,0.27452l10.9707,-2.71875c3.22369,1.72098 6.88165,2.74805 10.78906,2.74805c12.69047,0 23,-10.30953 23,-23c0,-12.69047 -10.30953,-23 -23,-23zM25,4c11.60953,0 21,9.39047 21,21c0,11.60953 -9.39047,21 -21,21c-3.72198,0 -7.20788,-0.97037 -10.23828,-2.66602c-0.22164,-0.12385 -0.48208,-0.15876 -0.72852,-0.09766l-9.60742,2.38086l2.57617,-9.19141c0.07449,-0.26248 0.03851,-0.54399 -0.09961,-0.7793c-1.84166,-3.12289 -2.90234,-6.75638 -2.90234,-10.64648c0,-11.60953 9.39047,-21 21,-21zM16.64258,13c-0.64104,0 -1.55653,0.23849 -2.30859,1.04883c-0.45172,0.48672 -2.33398,2.32068 -2.33398,5.54492c0,3.36152 2.33139,6.2621 2.61328,6.63477h0.00195v0.00195c-0.02674,-0.03514 0.3578,0.52172 0.87109,1.18945c0.5133,0.66773 1.23108,1.54472 2.13281,2.49414c1.80347,1.89885 4.33914,4.09336 7.48633,5.43555c1.44932,0.61717 2.59271,0.98981 3.45898,1.26172c1.60539,0.5041 3.06762,0.42747 4.16602,0.26563c0.82216,-0.12108 1.72641,-0.51584 2.62109,-1.08203c0.89469,-0.56619 1.77153,-1.2702 2.1582,-2.33984c0.27701,-0.76683 0.41783,-1.47548 0.46875,-2.05859c0.02546,-0.29156 0.02869,-0.54888 0.00977,-0.78711c-0.01897,-0.23823 0.0013,-0.42071 -0.2207,-0.78516c-0.46557,-0.76441 -0.99283,-0.78437 -1.54297,-1.05664c-0.30567,-0.15128 -1.17595,-0.57625 -2.04883,-0.99219c-0.8719,-0.41547 -1.62686,-0.78344 -2.0918,-0.94922c-0.29375,-0.10568 -0.65243,-0.25782 -1.16992,-0.19922c-0.51749,0.0586 -1.0286,0.43198 -1.32617,0.87305c-0.28205,0.41807 -1.4175,1.75835 -1.76367,2.15234c-0.0046,-0.0028 0.02544,0.01104 -0.11133,-0.05664c-0.42813,-0.21189 -0.95173,-0.39205 -1.72656,-0.80078c-0.77483,-0.40873 -1.74407,-1.01229 -2.80469,-1.94727v-0.00195c-1.57861,-1.38975 -2.68437,-3.1346 -3.0332,-3.7207c0.0235,-0.02796 -0.00279,0.0059 0.04687,-0.04297l0.00195,-0.00195c0.35652,-0.35115 0.67247,-0.77056 0.93945,-1.07812c0.37854,-0.43609 0.54559,-0.82052 0.72656,-1.17969c0.36067,-0.71583 0.15985,-1.50352 -0.04883,-1.91797v-0.00195c0.01441,0.02867 -0.11288,-0.25219 -0.25,-0.57617c-0.13751,-0.32491 -0.31279,-0.74613 -0.5,-1.19531c-0.37442,-0.89836 -0.79243,-1.90595 -1.04102,-2.49609v-0.00195c-0.29285,-0.69513 -0.68904,-1.1959 -1.20703,-1.4375c-0.51799,-0.2416 -0.97563,-0.17291 -0.99414,-0.17383h-0.00195c-0.36964,-0.01705 -0.77527,-0.02148 -1.17773,-0.02148zM16.64258,15c0.38554,0 0.76564,0.0047 1.08398,0.01953c0.32749,0.01632 0.30712,0.01766 0.24414,-0.01172c-0.06399,-0.02984 0.02283,-0.03953 0.20898,0.40234c0.24341,0.57785 0.66348,1.58909 1.03906,2.49023c0.18779,0.45057 0.36354,0.87343 0.50391,1.20508c0.14036,0.33165 0.21642,0.51683 0.30469,0.69336v0.00195l0.00195,0.00195c0.08654,0.17075 0.07889,0.06143 0.04883,0.12109c-0.21103,0.41883 -0.23966,0.52166 -0.45312,0.76758c-0.32502,0.37443 -0.65655,0.792 -0.83203,0.96484c-0.15353,0.15082 -0.43055,0.38578 -0.60352,0.8457c-0.17323,0.46063 -0.09238,1.09262 0.18555,1.56445c0.37003,0.62819 1.58941,2.6129 3.48438,4.28125c1.19338,1.05202 2.30519,1.74828 3.19336,2.2168c0.88817,0.46852 1.61157,0.74215 1.77344,0.82227c0.38438,0.19023 0.80448,0.33795 1.29297,0.2793c0.48849,-0.05865 0.90964,-0.35504 1.17773,-0.6582l0.00195,-0.00195c0.3568,-0.40451 1.41702,-1.61513 1.92578,-2.36133c0.02156,0.0076 0.0145,0.0017 0.18359,0.0625v0.00195h0.00195c0.0772,0.02749 1.04413,0.46028 1.90625,0.87109c0.86212,0.41081 1.73716,0.8378 2.02148,0.97852c0.41033,0.20308 0.60422,0.33529 0.6543,0.33594c0.00338,0.08798 0.0068,0.18333 -0.00586,0.32813c-0.03507,0.40164 -0.14243,0.95757 -0.35742,1.55273c-0.10532,0.29136 -0.65389,0.89227 -1.3457,1.33008c-0.69181,0.43781 -1.53386,0.74705 -1.8457,0.79297c-0.9376,0.13815 -2.05083,0.18859 -3.27344,-0.19531c-0.84773,-0.26609 -1.90476,-0.61053 -3.27344,-1.19336c-2.77581,-1.18381 -5.13503,-3.19825 -6.82031,-4.97266c-0.84264,-0.8872 -1.51775,-1.71309 -1.99805,-2.33789c-0.4794,-0.62364 -0.68874,-0.94816 -0.86328,-1.17773l-0.00195,-0.00195c-0.30983,-0.40973 -2.20703,-3.04868 -2.20703,-5.42578c0,-2.51576 1.1685,-3.50231 1.80078,-4.18359c0.33194,-0.35766 0.69484,-0.41016 0.8418,-0.41016z"></path></g></g>
	</svg>
	</a>
</body>

</html>

<?php $action = $this->dispatcher->getActionName(); ?>
		<!-- Sidebar Holder -->
		<nav id="sidebar">
			<div class="sidebar-header">
				<a href="{{ di['urlSales'] }}">
					<h3 class="text-center"><img src="{{ url() }}tiktx_logo.png"></h3>
					<strong><img src="{{ url() }}android-icon-48x48.png"></strong>
				</a>

			</div>

			<ul class="list-unstyled components">



				<li class=" ">
					<a href="#homeSubmenu" data-toggle="collapse" aria-expanded="false">
						<i class="fa fa-list-ul" aria-hidden="true"></i>
						{{ t._('events') }}
					</a>
					<ul class="collapse list-unstyled " id="homeSubmenu">
						<?php $hoje = new DateTime(); ?>
						<?php foreach ( $events as $event ) : ?>
							<?php if ( $hoje > new DateTime($event->date_sales_end)  ) continue; ?>
							<li>
								<a href="#" onclick="tiktxCheckout({{ event.id }}); return;" >
									{{ event.name }}, <?php echo formatDate($event->date_start, null, null, true) ?>
								</a>
							</li>
						<?php endforeach ; ?>
					</ul>
				</li>


				<li class=" <?php echo ( $action == 'withdrawal' ) ? 'active' : '' ?>">
					<a href="#financesSubmenu" data-toggle="collapse" aria-expanded="<?php echo ( $action == 'withdrawal' ) ? 'true' : 'false' ?>">
						<i class="fa fa-money" aria-hidden="true"></i>
						{{ t._('finances') }}
					</a>
					<ul class="collapse list-unstyled <?php echo ( $action == 'withdrawal' ) ? 'show' : '' ?>" id="financesSubmenu">
						<li><a href="{{ di['urlSales'] }}withdrawal">{{ t._('withdrawal') }}</a></li>
					</ul>
				</li>


				<li class=" <?php echo ( $action == 'sales' OR $action == 'balance' ) ? 'active' : '' ?> ">
					<a href="#salesSubmenu"  data-toggle="collapse" aria-expanded="<?php echo ( $action == 'sales' OR $action == 'balance' ) ? 'true' : 'false' ?>">
						<i class="fa fa-ticket" aria-hidden="true"></i>
						{{ t._('sales') }}
					</a>
					<ul class="collapse list-unstyled <?php echo ( $action == 'balance' OR $action == 'sales' ) ? 'show' : '' ?>" id="salesSubmenu">
						<li><a href="{{ di['urlSales'] }}balance">{{ t._('balance') }}</a></li>
						<li><a href="{{ di['urlSales'] }}sales">{{ t._('Detailed') }}</a></li>
					</ul>
				</li>




				<li>
					<a href="#languageSubmenu" data-toggle="collapse" aria-expanded="false">
						<i class="fa fa-language" aria-hidden="true"></i>
						{{ t._('language') }}
					</a>
					<ul class="collapse list-unstyled" id="languageSubmenu">
						<li><a href="?l=en_us">English</a></li>
						<li><a href="?l=pt_br">Português</a></li>
						<li><a href="?l=es_do">Spanish</a></li>
					</ul>
				</li>




				<li class=" <?php echo ( $action == 'account' OR $action == 'logout' ) ? 'active' : '' ?> ">
					<a href="#user_terminal" data-toggle="collapse" aria-expanded="false">
						<i class="fa fa-user" aria-hidden="true"></i>
						{{ seller.name }}
					</a>
					<ul class="collapse list-unstyled <?php echo ( $action == 'account' OR $action == 'logout' ) ? 'show' : '' ?>" id="user_terminal">
						<li>
							<a href="{{ di['urlSales'] }}logout">
								{{ t._('logout') }}
							</a>
						</li>
						<li>
							<a href="{{ di['urlSales'] }}account">
								{{ t._('My account') }}
							</a>
						</li>
					</ul>
				</li>


			</ul>



<!--
			<div class="text-center">

				<div>
					<small>
						{{ seller.SalesPoints.name }}
						<small class="hidden-xs hidden-sm">
							[{{ seller.SalesPoints.id }}]
						</small>
					</small>
				</div>

				<div>
					<small><small>Terminal: {{ seller.id }}</small></small>
				</div>


			</div>
-->

		</nav> <!-- <nav id="sidebar"> -->





		<?php
		$language = $this->session->get("language") ?: 'pt_br';
		$sid = session_id();
		?>

		<script src="{{ urlFastCheckout }}js/embedded.js?time=<?php echo time() ?>"></script>
		<script type="text/javascript">
			function tiktxCheckout(id_event)
			{
				window.TiktX.checkoutEmbedded({
					eventId: id_event,
					language: '{{ language }}',
					sid: '{{ sid }}'
				});
			}
		</script>
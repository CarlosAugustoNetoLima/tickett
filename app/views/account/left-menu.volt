<div class="panel panel-default">
	<div class="panel-heading">{{ t._('account') }}</div>
	<div class="panel-body">
		<ul class="list-unstyle sidebar-list">
			<li class="active">
				<a href="{{ url() }}account">
					<i class="fa fa-caret-right" aria-hidden="true"></i>
					{{ t._('home') }}
				</a>
			</li>
			<li class="active">
				<a href="{{ url() }}account/orders">
					<i class="fa fa-caret-right" aria-hidden="true"></i>
					{{ t._('order_history') }}
				</a>
			</li>
			<li class="active">
				<a href="{{ url() }}account/support">
					<i class="fa fa-caret-right" aria-hidden="true"></i>
					{{ t._('support') }}
				</a>
			</li>
			<li class="active">
				<a href="{{ url() }}account/profile">
					<i class="fa fa-caret-right" aria-hidden="true"></i>
					{{ t._('edit_profile') }}
				</a>
			</li>
			<li class="active">
				<a href="{{ url() }}account/wishlist">
					<i class="fa fa-caret-right" aria-hidden="true"></i>
					{{ t._('wish_list') }}
				</a>
			</li>
			<li class="active">
				<a href="{{ url() }}account/logout">
					<i class="fa fa-caret-right" aria-hidden="true"></i>
					{{ t._('logout') }}
				</a>
			</li>
		</ul>
	</div>
</div>
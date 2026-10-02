<section class="page-title">
    <div class="container">
        <h1 class="title">{{ t._('wish_list') }}</h1>
    </div>
</section>

{{ partial('account/menu') }}




<section class="page-profile">
    <div class="container">

                        {{ content() }}
                        {{ flashSession.output() }}


        <div class="page-profile-inner internal-page">
            <div class="internal-page-title">
                <h2 class="title">{{ t._('wish_list') }}</h2>
            </div>
            <div class="profile-update-area">
                <div class="profile-update-form">
					{{ t._('Em breve você poderá marcar seus artistas favoritos e será avisado quando houver show deles') }}
				</div>
			</div>
		</div>
	</div>
</section>
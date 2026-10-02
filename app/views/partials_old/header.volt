<header class="header" style="z-index:112; background: #096f94;" >
    <div class="container" style="max-width: 100%;">
        <div class="header-inner">
            <div class="logo-side">
                <a class="logo-link" href="{{ url() }}">
                    <!-- Para nao ficar aparecndo pros curiosos -->
                    <?php if (FALSE AND $_SERVER['HTTP_HOST'] == 'localhost' ) : ?>
                        <img src="https://cdn.iconscout.com/public/images/icon/free/png-128/google-brand-logo-3c2adca9187edc96-128x128.png" class="logo" />
                    <?php else : ?>
                        <img src="{{ url() }}{{ config.company.logos }}white_new.png" class="logo"/>
                    <?php endif; ?>
                </a>
            </div>
            <div class="action-side">

                {{ partial('partials/search-bar') }}

                {{ partial('partials/nav-bar') }}

            </div>
            <div class="menu-mobile">
                <button class="menu-action">
                    <svg class="menu-action-svg" xmlns="http://www.w3.org/2000/svg" width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="3" y1="12" x2="21" y2="12"></line><line x1="3" y1="6" x2="21" y2="6"></line><line x1="3" y1="18" x2="21" y2="18"></line></svg>
                </button>
            </div>
        </div>
    </div>
</header>
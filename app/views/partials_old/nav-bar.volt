<ul class="menu">

    <!-- <li class="menu-item">
        <a href="{{ url('helpdesk') }}" class="menu-link" style="color: #FFFFFF;">{{ t._('contact') }}</a>
    </li> -->

    <li class="menu-item">
        <a href="#" class="menu-link" style="color: #FFFFFF; font-weight: bold;" data-toggle="modal" data-target="#vendaIngressoModal">{{ t._('Venda seu evento') }}</a>
    </li>

    <?php if ( !isset($customer) ) : ?>
    <!-- <li class="menu-item">
        <a href="#" style="color: #FFFFFF; font-weight: bold;" class="menu-link" data-toggle="modal" data-target="#loginModal">{{ t._('log_in') }}</a>
    </li>
    <li class="menu-item">
        <a href="#" style="color: #FFFFFF; font-weight: bold;" class="menu-link" data-toggle="modal" data-target="#cadastrarModal">{{ t._('Cadastre-se') }}</a>
    </li> -->
    <?php endif; ?>

    <li class="menu-item">
        <a href="#" style="color: #FFFFFF; font-weight: bold;" class="menu-link" data-toggle="modal" data-target="#resendModal">{{ t._('resend_ticket') }}</a>
    </li>

    <?php if ( isset($customer) AND $customer ) : ?>
    <!-- <li class="menu-item">
        <div class="menu-language dropdown">
            <button class="language-btn dropdown-toggle" type="button" id="language-select" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="background: transparent; color: #FFFFFF;">
                {{ t._('account') }}
            </button>
            <div class="dropdown-menu" aria-labelledby="language-select">
                <a class="dropdown-item" href="{{ url() }}account">{{ t._('dashboard_account') }}</a>
                <a class="dropdown-item" href="{{ url() }}account/profile">{{ t._('edit_profile') }}</a>
                <a class="dropdown-item" href="{{ url() }}account/orders">{{ t._('order_history') }}</a>
                <a class="dropdown-item" href="{{ url() }}account/wishlist">{{ t._('wish_list') }}</a>
                <a class="dropdown-item" href="{{ url() }}account/support">{{ t._('support') }}</a>
                <a class="dropdown-item" href="{{ url() }}account/logout">{{ t._('logout') }}</a>
            </div>
        </div>
    </li> -->

            <script>
                /*window.onload = function() {
                    var customerID = "{{ customer.id }}";
                    var interval = setInterval(
                        function foo() {
                            (function() {     
                                var period = 300;     
                                var limit = 20 * 1e3;     
                                var nTry = 0;     
                                var intervalID = setInterval(function() {    
                                    var clear = limit/period <= ++nTry;         
                                    if ((typeof(Konduto) !== "undefined") &&
                                        (typeof(Konduto.setCustomerID) !== "undefined")) {            
                                    window.Konduto.setCustomerID(customerID);        
                                    clear = true;         
                                }         
                                if (clear) {
                            clearInterval(intervalID); 
                            }     
                            }, period);
                            })(customerID);

                            clearInterval(interval);
                        },
                        4000
                    );
                }*/
			</script>
    <?php endif; ?>

    <!-- <li class="menu-item">
        <div class="menu-language dropdown">
            <button class="language-btn dropdown-toggle" type="button" id="language-select" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="background: transparent; color: #FFFFFF;">
               {{ config.company.name }}
            </button>
            <div class="dropdown-menu" aria-labelledby="language-select">
                <b style="padding-left:10px;">{{ t._('the_company') }}</b>
                <a class="dropdown-item" href="{{ url() }}company">{{ t._('about') }}</a>
                <a class="dropdown-item" href="{{ url() }}company/policies_procedures">{{ t._('policies_procedures') }}</a>
                <a class="dropdown-item" href="{{ url() }}company/privacy">{{ t._('privacy') }}</a>
                <b style="padding-left:10px;">{{ t._('help') }}</b>
                <a class="dropdown-item" href="{{ url('helpdesk') }}">{{ t._('contact') }}</a>
                <a class="dropdown-item" href="{{ url('helpdesk') }}">{{ t._('helpdesk') }}</a>
                <?php if ( COMPANY == 'lebillet' ) : ?>
                <a class="dropdown-item" href="{{ url('company/meia_entrada') }}">{{ t._('Meia Entrada') }}</a>
                <?php endif ; ?>

                <a class="dropdown-item" href="{{ url('company/sell') }}">{{ t._('sell_your_event') }}</a>
            </div>
        </div>
    </li> -->

    <li class="menu-item">
        <div class="menu-language dropdown">
            <button class="language-btn dropdown-toggle" type="button" id="language-select" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="background: transparent; color: #FFFFFF;">
                <?php
                $language = $this->session->get("language") ;

                $language_text = '<img src="'.$this->url->get().'assets/images/flag/flag-en_us.png" width="30px" alt="English">';
                if ( $language == 'pt_pt' ) {
                    $language_text = '<img src="'.$this->url->get().'assets/images/flag/flag-pt_pt.png" width="30px" alt="Português">';
                } else if ( $language == 'es_do' ) {
                    $language_text = '<img src="'.$this->url->get().'assets/images/flag/flag-es.png" width="30px" alt="Spanish">';
                }
                echo $language_text ;
                ?>
            </button>
            <div class="dropdown-menu" aria-labelledby="language-select">
                <a class="dropdown-item" href="{{ url() }}<?php echo strip_tags($this->router->getRewriteUri()) ?>?l=en_us"><span class="language-flag"><img src="{{ url() }}assets/images/flag/flag-en_us.png" width="30px" alt="English"></span>English</a>
                <a class="dropdown-item" href="{{ url() }}<?php echo strip_tags($this->router->getRewriteUri()) ?>?l=pt_pt"><span class="language-flag"><img src="{{ url() }}assets/images/flag/flag-pt_pt.png" width="30px" alt="Português"></span>Português</a>
                <a class="dropdown-item" href="{{ url() }}<?php echo strip_tags($this->router->getRewriteUri()) ?>?l=es_do"><span class="language-flag"><img src="{{ url() }}assets/images/flag/flag-es.png" width="30px" alt="Spanish"></span>Spanish</a>
            </div>
        </div>
    </li>

</ul>
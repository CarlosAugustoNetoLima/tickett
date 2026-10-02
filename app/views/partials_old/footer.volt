<footer class="footer" style="background-color: transparent;">
    <div class="container">
        <div class="footer-inner">
            <div class="columns-group">
                <div class="column logo-column">
                    <img src="{{ url() }}{{ config.company.logos }}white.png" class="logo"/>
                </div>
                <div class="column">
                    <h4 class="column-title">{{ config.company.name }}</h4>
                    <ul class="links-group">
                        <li class="link-item"><a class="link-content" href="{{ url() }}company">{{ t._('about') }}</a></li>
                        <li class="link-item"><a class="link-content" href="{{ url() }}company/policies_procedures">{{ t._('policies_procedures') }}</a></li>
                        <li class="link-item"><a class="link-content" href="{{ url() }}company/privacy">{{ t._('privacy') }}</a></li>
                        <li class="link-item"><a class="link-content" href="{{ url() }}account">{{ t._('account') }}</a></li>
                        <li class="link-item"><a class="link-content" href="{{ url() }}past-events">{{ t._('Last Shows') }}</a></li>
                    </ul>
                </div>
                <div class="column">
                    <h4 class="column-title">{{ t._('help') }}</h4>
                    <ul class="links-group">
                        <!--<li class="link-item"><a class="link-content" href="{{ url('company/faq') }}">{{ t._('faq') }}</a></li>-->
                        <li class="link-item"><a class="link-content" href="{{ url('helpdesk') }}">{{ t._('contact') }}</a></li>
                        <?php if ( COMPANY == 'lebillet' ) : ?>
                        <li class="link-item"><a class="link-content" href="{{ url('company/meia_entrada') }}">{{ t._('Meia Entrada') }}</a></li>
                        <?php elseif ( COMPANY == 'lebillet_pt' ) : ?>
                        <li class="link-item"><a class="link-content" target="_blank" href="https://ec.europa.eu/consumers/odr/main/index.cfm?event=main.home2.show&lng=PT">{{ t._('Resolução de litígios em linha') }}</a></li>
                        <li class="link-item"><a class="link-content" target="_blank" href="https://www.livroreclamacoes.pt/">{{ t._('Livro de reclamações online') }}</a></li>
                        <?php endif ; ?>
                        <li class="link-item"><a class="link-content" href="{{ url('company/sell') }}">{{ t._('sell_your_event') }}</a></li>
                    </ul>
                </div>
                <div class="column">
                    <h4 class="column-title">{{ t._('Social') }}</h4>
                    <ul class="links-group">
                        <?php if ( isset($this->config->company->social->twitter) ) : ?>
                            <li class="link-item"><a class="link-content" target="_blank" href="{{ config.company.social.twitter }}"><i class="fab fa-twitter-square"></i> Twitter</a></li>
                        <?php endif ; ?>

                        <?php if ( isset($this->config->company->social->instagram) ) : ?>
                            <li class="link-item"><a class="link-content" target="_blank" href="{{ config.company.social.instagram }}"><i class="fab fa-instagram"></i> Instagram</a></li>
                        <?php endif ; ?>

                        <?php if ( isset($this->config->company->email) ) : ?>
                            <li class="link-item">
                                <script language="javascript" type="text/javascript">
                                var pre = "{{ config.company.email }}";
                                document.write("<a target='_blank' class='link-content' href='mailto:" + pre + "'>" + pre + "</a>");
                                </script>
                                <noscript>Enable javascript to see our email!</noscript>
                            </li>
                        <?php endif ; ?>

                        <?php if ( isset($this->config->company->phone) ) : ?>
                            <li class="link-content">
                                {{ config.company.phone }}
                            </li>
                        <?php endif ; ?>
                    </ul>
                </div>
                <div class="column" style="min-width:267px;">
                    <h4 class="column-title">{{ t._('newsletter') }}</h4>
                    <form id="form-newsletter" class="newsletter-form">
                        <div class="newsletter-input-group">
                            <input type="text" name="email" placeholder="{{ t._('your_email_address') }}" class="newsletter-input">
                            <button type="button" class="newsletter-button" id="basic-addon2" onclick="submitNews(); return false;">
                                <svg class="icon" enable-background="new 0 0 24 24" height="512" viewBox="0 0 24 24" width="512" xmlns="http://www.w3.org/2000/svg"><path d="m8.75 17.612v4.638c0 .324.208.611.516.713.077.025.156.037.234.037.234 0 .46-.11.604-.306l2.713-3.692z"/><path d="m23.685.139c-.23-.163-.532-.185-.782-.054l-22.5 11.75c-.266.139-.423.423-.401.722.023.3.222.556.505.653l6.255 2.138 13.321-11.39-10.308 12.419 10.483 3.583c.078.026.16.04.242.04.136 0 .271-.037.39-.109.19-.116.319-.311.352-.53l2.75-18.5c.041-.28-.077-.558-.307-.722z"/></svg>
                            </button>
                        </div>
                    </form>
                    <p id="news-responde" style="color:#FFF;"></p>
                </div>

            </div>
            <div class="copyright">
                <p class="copyright-text">Copyright &copy;<?php echo date('Y') ?> {{ config.company.name }}. {{ t._('All Rights Reserved') }}.</p>

                <?php if ( COMPANY == 'tiktx' ) : ?>
                    <p class="copyright-text">The Tiktx Company, 3801 NE 207 TH ST, Miami FL 33180</p>
                    <p class="copyright-text"><img src="{{ url() }}img/payments/cards.png"></p>
                <?php endif ; ?>

            </div>
        </div>
    </div>
</footer>
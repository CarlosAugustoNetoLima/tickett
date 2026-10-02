<?php
    $ref = isset($_REQUEST['ref']) ? '?ref=' . $_REQUEST['ref'] : null;
?>
<main>
    <section class="section next-shows">
        <div class="container">
            <?php if(sizeof($events) > 0){ ?>
                <div class="next-shows-inner">
                    <?php if($term != ""){ ?>
                        <h2 class="section-title">{{ t._('Results for') }}: {{ term }}</h2>
                    <?php }else { ?>
                        <h2 class="section-title">{{ t._('Result') }}</h2>
                    <?php } ?>
                    <div class="next-shows-items">

                        {{ content() }}

                        <?php
                            foreach ( $events AS $event ) :
                                if ( strtotime($event->date_sales_end) < time() ) continue;
                        ?>
                            <div class="show-card small ">
                                <a href="{{ url() }}event/{{ event.id }}/{{ event.slug }}{{ ref }}" class="card-link">
                                    <div class="show-card-inner">
                                        <div class="card-cover">
                                            <?php if ( isset($event->EventsImages[0]->name) ) : ?>
                                                <img alt="{{ event.name }} {{ event.ticket_sub_name }}" src="{{ url() }}img/shows/{{ event.EventsImages[0].name }}" class="image" style="border-radius: 2rem;" />
                                            <?php endif ; ?>
                                        </div>
                                        <div class="card-data">
                                            <div class="card-data-inner">
                                                <div class="data-group data-title">
                                                    <h3 class="title">{{ event.name }}</h3>
                                                </div>
                                                <div class="data-group data-date">
                                                    <svg class="data-icon" version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="488.152px" height="488.152px" viewBox="0 0 488.152 488.152" style="enable-background:new 0 0 488.152 488.152;"
                                                        xml:space="preserve">
                                                        <path
                                                        d="M177.854,269.311c0-6.115-4.96-11.069-11.08-11.069h-38.665c-6.113,0-11.074,4.954-11.074,11.069v38.66 c0,6.123,4.961,11.079,11.074,11.079h38.665c6.12,0,11.08-4.956,11.08-11.079V269.311L177.854,269.311z" />
                                                        <path
                                                        d="M274.483,269.311c0-6.115-4.961-11.069-11.069-11.069h-38.67c-6.113,0-11.074,4.954-11.074,11.069v38.66 c0,6.123,4.961,11.079,11.074,11.079h38.67c6.108,0,11.069-4.956,11.069-11.079V269.311z" />
                                                        <path
                                                        d="M371.117,269.311c0-6.115-4.961-11.069-11.074-11.069h-38.665c-6.12,0-11.08,4.954-11.08,11.069v38.66 c0,6.123,4.96,11.079,11.08,11.079h38.665c6.113,0,11.074-4.956,11.074-11.079V269.311z" />
                                                        <path
                                                        d="M177.854,365.95c0-6.125-4.96-11.075-11.08-11.075h-38.665c-6.113,0-11.074,4.95-11.074,11.075v38.653 c0,6.119,4.961,11.074,11.074,11.074h38.665c6.12,0,11.08-4.956,11.08-11.074V365.95L177.854,365.95z" />
                                                        <path
                                                        d="M274.483,365.95c0-6.125-4.961-11.075-11.069-11.075h-38.67c-6.113,0-11.074,4.95-11.074,11.075v38.653 c0,6.119,4.961,11.074,11.074,11.074h38.67c6.108,0,11.069-4.956,11.069-11.074V365.95z" />
                                                        <path
                                                        d="M371.117,365.95c0-6.125-4.961-11.075-11.069-11.075h-38.67c-6.12,0-11.08,4.95-11.08,11.075v38.653 c0,6.119,4.96,11.074,11.08,11.074h38.67c6.108,0,11.069-4.956,11.069-11.074V365.95L371.117,365.95z" />
                                                        <path
                                                        d="M440.254,54.354v59.05c0,26.69-21.652,48.198-48.338,48.198h-30.493c-26.688,0-48.627-21.508-48.627-48.198V54.142 h-137.44v59.262c0,26.69-21.938,48.198-48.622,48.198H96.235c-26.685,0-48.336-21.508-48.336-48.198v-59.05 C24.576,55.057,5.411,74.356,5.411,98.077v346.061c0,24.167,19.588,44.015,43.755,44.015h389.82 c24.131,0,43.755-19.889,43.755-44.015V98.077C482.741,74.356,463.577,55.057,440.254,54.354z M426.091,422.588 c0,10.444-8.468,18.917-18.916,18.917H80.144c-10.448,0-18.916-8.473-18.916-18.917V243.835c0-10.448,8.467-18.921,18.916-18.921 h327.03c10.448,0,18.916,8.473,18.916,18.921L426.091,422.588L426.091,422.588z" />
                                                        <path
                                                        d="M96.128,129.945h30.162c9.155,0,16.578-7.412,16.578-16.567V16.573C142.868,7.417,135.445,0,126.29,0H96.128 C86.972,0,79.55,7.417,79.55,16.573v96.805C79.55,122.533,86.972,129.945,96.128,129.945z" />
                                                        <path
                                                        d="M361.035,129.945h30.162c9.149,0,16.572-7.412,16.572-16.567V16.573C407.77,7.417,400.347,0,391.197,0h-30.162 c-9.154,0-16.577,7.417-16.577,16.573v96.805C344.458,122.533,351.881,129.945,361.035,129.945z" />
                                                    </svg>
                                                    <p class="data-text datetime">
                                                        <?php if ( isset($event->label_date) AND strlen($event->label_date) > 2 ) : ?>
                                                            {{ event.label_date }}
                                                        <?php else : ?>
                                                            <?php echo $this->getDI()->getFormatdates()->format($event->date_opening, 'Dom_01_de_Janeiro_de_2000');?>
                                                        <?php endif ; ?>
                                                    </p>
                                                </div>


                                                <?php if ( isset($event->Cities) AND strlen($event->Cities->name) > 2 ) : ?>
                                                    <div class="data-group data-location">
                                                        <svg class="data-icon" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 512 512" style="enable-background:new 0 0 512 512;" xml:space="preserve">
                                                            <path
                                                            d="M256,0C153.755,0,70.573,83.182,70.573,185.426c0,126.888,165.939,313.167,173.004,321.035 c6.636,7.391,18.222,7.378,24.846,0c7.065-7.868,173.004-194.147,173.004-321.035C441.425,83.182,358.244,0,256,0z M256,278.719 c-51.442,0-93.292-41.851-93.292-93.293S204.559,92.134,256,92.134s93.291,41.851,93.291,93.293S307.441,278.719,256,278.719z" />
                                                        </svg>
                                                        <p class="data-text location">{{ event.Cities.name }}, {{ event.Regions.acronym }}</p>
                                                    </div>
                                                <?php endif ; ?>


                                            </div>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        <?php endforeach ; ?>

                    </div>
                </div>


                <?php if ( !isset($_REQUEST['past']) ) : ?>


                <div class="next-shows-inner mt-5">
                    <h2 class="section-title mt-5">{{ t._('Past shows') }}</h2>

                    <div class="row">
                        <?php
                        foreach ( $events AS $event ) :
                            if ( strtotime($event->date_sales_end) > time() ) continue;
                        ?>
                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                <div class="card card-events">
                                    <?php if ( $event['type'] == 'event' ) : ?>
                                    <a href="{{ url() }}event/{{ event['id'] }}/{{ event['slug'] }}{{ ref }}"
                                        class="card-link">
                                        <?php else : ?>
                                        <a href="{{ url() }}group/{{ event['slug'] }}" class="card-link">
                                            <?php endif ; ?>
                                            <?php if ( isset($event->EventsImages[0]->name) ) : ?>
                                                <img alt="{{ event.name }} {{ event.ticket_sub_name }}" src="{{ url() }}img/shows/{{ event.EventsImages[0].name }}" class="image" style="border-radius: 2rem;" />
                                            <?php endif ; ?>
                                            <div class="card-body text-center" style="color: #FFFFFF;">
                                                <h2 class="title"
                                                    style="font-size: 26px; white-space: nowrap;  overflow: hidden;  text-overflow: ellipsis; font-weight: bold;">
                                                    {{ event['name'] }}</h2>
                                                <p class="card-text text-center">
                                                    <?php if ( (isset($event['label_date']) AND strlen($event['label_date']) > 2) OR (isset($event['date_opening']) AND strlen($event['date_opening']) > 2) ) : ?>
                                                <p class="text-center text-date" style="font-size: small;">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                                                        viewBox="0 0 24 24" fill="none" stroke="#FFFFFF"
                                                        stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                                        <line x1="3" y1="10" x2="21" y2="10"></line>
                                                    </svg>
                                                    <?php if ( isset($event['label_date']) AND strlen($event['label_date']) > 2 ) : ?>
                                                    {{ event['label_date'] }}
                                                    <?php else : ?>
                                                    <?php echo $this->getDI()->getFormatdates()->format($event['date_opening'], 'Dom_01_de_Janeiro_de_2000');?>
                                                    <?php endif ; ?>

                                                    <?php if ( $event['type'] == 'event' ) : ?>

                                                    <?php if ( isset($event['label_date']) AND strlen($event['label_date']) > 2 ) : ?>

                                                    <?php else : ?>
                                                    *
                                                    <?php echo $this->getDI()->getFormatdates()->format($event['date_opening'], '17:00h');?>
                                                    <?php endif ; ?>

                                                    <?php endif ; ?>

                                                    <?php if ( isset($event['city_name']) AND strlen($event['city_name']) > 2 ) : ?>
                                                <p
                                                    style="font-size: small; margin-top: -15px; white-space: nowrap;  overflow: hidden;  text-overflow: ellipsis;">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                                                        viewBox="0 0 24 24" fill="none" stroke="#FFFFFF"
                                                        stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                        <path
                                                            d="M12 22s-8-4.5-8-11.8A8 8 0 0 1 12 2a8 8 0 0 1 8 8.2c0 7.3-8 11.8-8 11.8z" />
                                                        <circle cx="12" cy="10" r="3" />
                                                    </svg>
                                                    {{ event['place_name'] }} - {{ event['city_name'] }}, {{
                                                    event['region_acronym'] }}
                                                </p>
                                                <?php endif ; ?>
                                                </p>
                                                <?php endif ; ?>
                                                </p>
                                                <div class="btn btn-new">
                                                    COMPRAR
                                                </div>
                                            </div>
                                        </a>
                                </div>
                            </div>
                        <?php endforeach ; ?>
                    </div>


                    <div class="next-shows-items">

                        {{ content() }}

                        <?php
                            foreach ( $events AS $event ) :
                                if ( strtotime($event->date_sales_end) > time() ) continue;
                        ?>
                            <div class="show-card small ">
                                <a href="{{ url() }}event/{{ event.id }}/{{ event.slug }}{{ ref }}" class="card-link">
                                    <div class="show-card-inner">
                                        <div class="card-cover">
                                            <?php if ( isset($event->EventsImages[0]->name) ) : ?>
                                                <img alt="{{ event.name }} {{ event.ticket_sub_name }}" src="{{ url() }}img/shows/{{ event.EventsImages[0].name }}" class="image" />
                                            <?php endif ; ?>
                                        </div>
                                        <div class="card-data">
                                            <div class="card-data-inner">
                                                <div class="data-group data-title">
                                                    <h3 class="title">{{ event.name }}</h3>
                                                </div>
                                                <div class="data-group data-date">
                                                    <svg class="data-icon" version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="488.152px" height="488.152px" viewBox="0 0 488.152 488.152" style="enable-background:new 0 0 488.152 488.152;"
                                                        xml:space="preserve">
                                                        <path
                                                        d="M177.854,269.311c0-6.115-4.96-11.069-11.08-11.069h-38.665c-6.113,0-11.074,4.954-11.074,11.069v38.66 c0,6.123,4.961,11.079,11.074,11.079h38.665c6.12,0,11.08-4.956,11.08-11.079V269.311L177.854,269.311z" />
                                                        <path
                                                        d="M274.483,269.311c0-6.115-4.961-11.069-11.069-11.069h-38.67c-6.113,0-11.074,4.954-11.074,11.069v38.66 c0,6.123,4.961,11.079,11.074,11.079h38.67c6.108,0,11.069-4.956,11.069-11.079V269.311z" />
                                                        <path
                                                        d="M371.117,269.311c0-6.115-4.961-11.069-11.074-11.069h-38.665c-6.12,0-11.08,4.954-11.08,11.069v38.66 c0,6.123,4.96,11.079,11.08,11.079h38.665c6.113,0,11.074-4.956,11.074-11.079V269.311z" />
                                                        <path
                                                        d="M177.854,365.95c0-6.125-4.96-11.075-11.08-11.075h-38.665c-6.113,0-11.074,4.95-11.074,11.075v38.653 c0,6.119,4.961,11.074,11.074,11.074h38.665c6.12,0,11.08-4.956,11.08-11.074V365.95L177.854,365.95z" />
                                                        <path
                                                        d="M274.483,365.95c0-6.125-4.961-11.075-11.069-11.075h-38.67c-6.113,0-11.074,4.95-11.074,11.075v38.653 c0,6.119,4.961,11.074,11.074,11.074h38.67c6.108,0,11.069-4.956,11.069-11.074V365.95z" />
                                                        <path
                                                        d="M371.117,365.95c0-6.125-4.961-11.075-11.069-11.075h-38.67c-6.12,0-11.08,4.95-11.08,11.075v38.653 c0,6.119,4.96,11.074,11.08,11.074h38.67c6.108,0,11.069-4.956,11.069-11.074V365.95L371.117,365.95z" />
                                                        <path
                                                        d="M440.254,54.354v59.05c0,26.69-21.652,48.198-48.338,48.198h-30.493c-26.688,0-48.627-21.508-48.627-48.198V54.142 h-137.44v59.262c0,26.69-21.938,48.198-48.622,48.198H96.235c-26.685,0-48.336-21.508-48.336-48.198v-59.05 C24.576,55.057,5.411,74.356,5.411,98.077v346.061c0,24.167,19.588,44.015,43.755,44.015h389.82 c24.131,0,43.755-19.889,43.755-44.015V98.077C482.741,74.356,463.577,55.057,440.254,54.354z M426.091,422.588 c0,10.444-8.468,18.917-18.916,18.917H80.144c-10.448,0-18.916-8.473-18.916-18.917V243.835c0-10.448,8.467-18.921,18.916-18.921 h327.03c10.448,0,18.916,8.473,18.916,18.921L426.091,422.588L426.091,422.588z" />
                                                        <path
                                                        d="M96.128,129.945h30.162c9.155,0,16.578-7.412,16.578-16.567V16.573C142.868,7.417,135.445,0,126.29,0H96.128 C86.972,0,79.55,7.417,79.55,16.573v96.805C79.55,122.533,86.972,129.945,96.128,129.945z" />
                                                        <path
                                                        d="M361.035,129.945h30.162c9.149,0,16.572-7.412,16.572-16.567V16.573C407.77,7.417,400.347,0,391.197,0h-30.162 c-9.154,0-16.577,7.417-16.577,16.573v96.805C344.458,122.533,351.881,129.945,361.035,129.945z" />
                                                    </svg>
                                                    <p class="data-text datetime">
                                                        <?php if ( isset($event->label_date) AND strlen($event->label_date) > 2 ) : ?>
                                                            {{ event.label_date }}
                                                        <?php else : ?>
                                                            <?php echo $this->getDI()->getFormatdates()->format($event->date_opening, 'Dom_01_de_Janeiro_de_2000');?>
                                                        <?php endif ; ?>
                                                    </p>
                                                </div>


                                                <?php if ( isset($event->Cities) AND strlen($event->Cities->name) > 2 ) : ?>
                                                    <div class="data-group data-location">
                                                        <svg class="data-icon" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 512 512" style="enable-background:new 0 0 512 512;" xml:space="preserve">
                                                            <path
                                                            d="M256,0C153.755,0,70.573,83.182,70.573,185.426c0,126.888,165.939,313.167,173.004,321.035 c6.636,7.391,18.222,7.378,24.846,0c7.065-7.868,173.004-194.147,173.004-321.035C441.425,83.182,358.244,0,256,0z M256,278.719 c-51.442,0-93.292-41.851-93.292-93.293S204.559,92.134,256,92.134s93.291,41.851,93.291,93.293S307.441,278.719,256,278.719z" />
                                                        </svg>
                                                        <p class="data-text location">{{ event.Cities.name }}, {{ event.Regions.acronym }}</p>
                                                    </div>
                                                <?php endif ; ?>


                                            </div>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        <?php endforeach ; ?>

                    </div>
                </div>

                <?php endif ; ?>

            <?php } else { ?>
                <br><h2 class="section-title">{{ t._('Não foi encontrado nenhum evento') }}</h2>
                <a href="{{ url() }}" class="btn btn-primary">Voltar</a>
            <?php } ?>

        </div>
    </section>
</main>
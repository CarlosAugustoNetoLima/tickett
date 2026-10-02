<?php
    $ref = isset($_REQUEST['ref']) ? '?ref=' . $_REQUEST['ref'] : null;
?>
<main>
    <section class="section next-shows">
        <div class="container">
            <?php if(sizeof($events) > 0){ ?>
                <div class="next-shows-inner">
                    <?php if($term != ""){ ?>
                        <h2 class="section-title" style="color: #FFFFFF;">{{ t._('Results for') }}: {{ term }}</h2>
                    <?php }else { ?>
                        <h2 class="section-title" style="color: #FFFFFF;">{{ t._('Result') }}</h2>
                    <?php } ?>

                    <div class="row">
                        <?php
                        foreach ( $events AS $event ) :
                            if ( strtotime($event->date_sales_end) < time() ) continue;
                        ?>
                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 mt-5">
                                <div class="card card-events">
                                    <a href="{{ url() }}event/{{ event.id }}/{{ event.slug }}{{ ref }}"
                                        class="card-link">
                                            <img class="card-img-top"
                                                alt="{{ event.name }} {{ event.ticket_sub_name }}"
                                                src="{{ url() }}img/shows/{{ event.EventsImages[0].name }}" style="border-radius: 1rem 1rem 0rem 0rem;">
                                            <div class="card-body text-center" style="color: #FFFFFF;">
                                                <h2 class="title"
                                                    style="font-size: 26px; white-space: nowrap;  overflow: hidden;  text-overflow: ellipsis; font-weight: bold;">
                                                    {{ event.name }}</h2>
                                                <p class="card-text text-center">
                                                    <?php if ( (isset($event->label_date) AND strlen($event->label_date) > 2) OR (isset($event->date_opening) AND strlen($event->date_opening) > 2) ) : ?>
                                                    <p class="text-center" style="font-size: small;">
                                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                                                            viewBox="0 0 24 24" fill="none" stroke="#FFFFFF"
                                                            stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                                            <line x1="16" y1="2" x2="16" y2="6"></line>
                                                            <line x1="8" y1="2" x2="8" y2="6"></line>
                                                            <line x1="3" y1="10" x2="21" y2="10"></line>
                                                        </svg>
                                                    <?php if ( isset($event->label_date) AND strlen($event->label_date) > 2 ) : ?>
                                                    {{ event.label_date }}
                                                    <?php else : ?>
                                                    <?php echo $this->getDI()->getFormatdates()->format($event->date_opening, 'Dom_01_de_Janeiro_de_2000');?>
                                                    <?php endif ; ?>

                                                    <?php echo $this->getDI()->getFormatdates()->format($event->date_opening, '17:00h');?>

                                                    <?php if ( isset($event->city_name) AND strlen($event->city_name) > 2 ) : ?>
                                                        <p
                                                        style="font-size: small; margin-top: -10px; white-space: nowrap;  overflow: hidden;  text-overflow: ellipsis;">
                                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                                                            viewBox="0 0 24 24" fill="none" stroke="#FFFFFF"
                                                            stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                            <path
                                                                d="M12 22s-8-4.5-8-11.8A8 8 0 0 1 12 2a8 8 0 0 1 8 8.2c0 7.3-8 11.8-8 11.8z" />
                                                            <circle cx="12" cy="10" r="3" />
                                                        </svg>
                                                        {{ event.place_name }} - {{ event.city_name }}, {{ event.region_acronym }}
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
                </div>


                <?php if ( !isset($_REQUEST['past']) ) : ?>


                <div class="next-shows-inner mt-5">
                    <h2 class="section-title mt-5" style="color: #FFFFFF;">{{ t._('Past shows') }}</h2>

                    <div class="row">
                        <?php
                        foreach ( $events AS $event ) :
                            if ( strtotime($event->date_sales_end) > time() ) continue;
                        ?>
                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 mt-5">
                                <div class="card card-events">
                                    <a href="{{ url() }}event/{{ event.id }}/{{ event.slug }}{{ ref }}"
                                        class="card-link">
                                            <img class="card-img-top"
                                                alt="{{ event.name }} {{ event.ticket_sub_name }}"
                                                src="{{ url() }}img/shows/{{ event.EventsImages[0].name }}" style="border-radius: 1rem 1rem 0rem 0rem;">
                                            <div class="card-body text-center" style="color: #FFFFFF;">
                                                <h2 class="title"
                                                    style="font-size: 26px; white-space: nowrap;  overflow: hidden;  text-overflow: ellipsis; font-weight: bold;">
                                                    {{ event.name }}</h2>
                                                <p class="card-text text-center">
                                                    <?php if ( (isset($event->label_date) AND strlen($event->label_date) > 2) OR (isset($event->date_opening) AND strlen($event->date_opening) > 2) ) : ?>
                                                    <p class="text-center" style="font-size: small;">
                                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                                                            viewBox="0 0 24 24" fill="none" stroke="#FFFFFF"
                                                            stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                                            <line x1="16" y1="2" x2="16" y2="6"></line>
                                                            <line x1="8" y1="2" x2="8" y2="6"></line>
                                                            <line x1="3" y1="10" x2="21" y2="10"></line>
                                                        </svg>
                                                    <?php if ( isset($event->label_date) AND strlen($event->label_date) > 2 ) : ?>
                                                    {{ event.label_date }}
                                                    <?php else : ?>
                                                    <?php echo $this->getDI()->getFormatdates()->format($event->date_opening, 'Dom_01_de_Janeiro_de_2000');?>
                                                    <?php endif ; ?>

                                                    <?php echo $this->getDI()->getFormatdates()->format($event->date_opening, '17:00h');?>

                                                    <?php if ( isset($event->city_name) AND strlen($event->city_name) > 2 ) : ?>
                                                        <p
                                                        style="font-size: small; margin-top: -10px; white-space: nowrap;  overflow: hidden;  text-overflow: ellipsis;">
                                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                                                            viewBox="0 0 24 24" fill="none" stroke="#FFFFFF"
                                                            stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                            <path
                                                                d="M12 22s-8-4.5-8-11.8A8 8 0 0 1 12 2a8 8 0 0 1 8 8.2c0 7.3-8 11.8-8 11.8z" />
                                                            <circle cx="12" cy="10" r="3" />
                                                        </svg>
                                                        {{ event.place_name }} - {{ event.city_name }}, {{ event.region_acronym }}
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
                </div>

                <?php endif ; ?>

            <?php } else { ?>
                <br><h2 class="section-title">{{ t._('Não foi encontrado nenhum evento') }}</h2>
                <a href="{{ url() }}" class="btn btn-primary">Voltar</a>
            <?php } ?>

        </div>
    </section>
</main>
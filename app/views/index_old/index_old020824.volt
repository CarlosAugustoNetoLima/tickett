<?php
	$ref = isset($_REQUEST['ref']) ? '?ref=' . $_REQUEST['ref'] : null;
?>
<main>
	{{ content() }}


	<?php if ( isset($events_featured_premium) AND count($events_featured_premium) > 0 ) : ?>
	    {{ partial('index/carousel_shows') }}
	<?php endif; ?>


	<?php if ( isset($events_featured) AND count($events_featured) > 0 ) : ?>
	    {{ partial('index/featured_events') }}
	<?php endif; ?>


    {{ partial('index/next_shows') }}

    {# partial('index/download_app') #}

    <?php if ( COMPANY == 'lebillet_pt' ) : ?>
	    {{ partial('index/links_external') }}
	<?php endif ; ?>

</main>



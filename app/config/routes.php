<?php

	$router = new \Phalcon\Mvc\Router();

	$router->removeExtraSlashes(true);

	$router->setDefaultAction("index");
	$router->setDefaultController("index");

	//Set 404 paths
	$router->notFound(array(
		"controller" => "index",
		"action" => "route404"
	));





		$router->add('/', array(
			'controller' => 'index',
			'action' => 'index'
		));


		$router->add('/:params', array(
			'controller' => 'index',
			'action' => 'index',
			'params' => 1
		));
		$router->add('/:controller/:params', array(
			'controller' => 1,
			'action' => 'index',
			'params' => 2
		));
		$router->add('/:controller/:action/:params', array(
			'controller' => 1,
			'action' => 2,
			'params' => 3
		));


		$router->add('/contato', array(
			'controller' => 'helpdesk',
			'action' => 'index'
		));
		$router->add('/contacto', array(
			'controller' => 'helpdesk',
			'action' => 'index'
		));
		$router->add('/contact', array(
			'controller' => 'helpdesk',
			'action' => 'index'
		));

		/**
		* Rota para a página do evento
		* www.site.com/event/1/bla-bla
		*/
		$router->add('/event/{id:[0-9]+}/{name}', array(
			'controller' => 'event',
			'action' => 'index'
		));
		$router->add('/event/{id:[0-9]+}', array(
			'controller' => 'event',
			'action' => 'index'
		));


		$router->add('/qrcode/:params', array(
			'controller' => 'qrcode',
			'action' => 'index',
			'params' => 1
		));





		$router->add('/checkout/t{token:[a-zA-Z0-9_-]+}', array(
			'controller' => 'checkout',
			'token' => 1
		));







	$router->add('/performers', array(
		'controller' => 'performer',
		'action' => 'index'
	));
	$router->add('/performer/:params', array(
		'controller' => 'performer',
		'action' => 'index',
		'params' => 1
	));
	$router->add('/performer', array(
		'controller' => 'performer',
		'action' => 'index'
	));





	$router->add('/ticket/:params', array(
		'controller' => 'ticket',
		'action' => 'index',
		'params' => 1
	));

	$router->add('/ticket/show/:params', array(
		'controller' => 'ticket',
		'action' => 'show',
		'params' => 1
	));
	$router->add('/ticket/slim/:params', array(
		'controller' => 'ticket',
		'action' => 'slim',
		'params' => 1
	));

	$router->add('/ticket/extra_data/:params', array(
		'controller' => 'ticket',
		'action' => 'extra_data',
		'params' => 1
	));



	$router->add('/past-events', array(
		'controller' => 'index',
		'action' => 'pastevents'
	));



	$router->add('/search/:params', array(
		'controller' => 'index',
		'action' => 'search',
		'params' => 1
	));

	$router->add('/busca/:params', array(
		'controller' => 'index',
		'action' => 'search',
		'params' => 1
	));




	$router->add('/group/:params', array(
		'controller' => 'group',
		'action' => 'index',
		'params' => 1
	));

	$router->add('/grupo/:params', array(
		'controller' => 'group',
		'action' => 'index',
		'params' => 1
	));



	// Isto pra forçar a URL pra ORDER
	// Pq o Whatsapp no Android quebra o link e não pega os ultimos caracteres na URL
	// https://lebillet.com.br/order/SU9rd09qQmYzTTUzMWZnUkdNSXRyNzR6dENTdg==
	// https://lebillet.com.br/order/SU9rd09qQmYzTTUzMWZnUkdNSXRyNzR6dENTdg   <= fica assim
	$router->add('/order/:params', array(
		'controller' => 'order',
		'action' => 'index',
		'params' => 1
	));



		$router->add('/events', array(
			'controller' => 'events',
			'action' => 'index'
		));


		$router->add('/events/{slug:[a-zA-Z0-9_-]+}', array(
			'controller' => 'events',
			'action' => 'slug',
			'slug' => 1
		));
		$router->add('/events/{slug:[a-zA-Z0-9_-]+}/{event:[a-zA-Z0-9_-]+}', array(
			'controller' => 'events',
			'action' => 'event',
			'slug' => 1,
			'event' => 2
		));

		$router->add('/events/radio-florida', array(
			'controller' => 'events',
			'action' => 'radioflorida'
		));



	if ( in_array( $_SERVER['HTTP_HOST'], array('events.tiktx.com', 'eventos.lebillet.com.br', 'eventos.lebillet.my') ) )
    {
		$router->add('/', array(
			'controller' => 'events',
			'action' => 'index'
		));

		$router->add('/{slug:[a-zA-Z0-9_-]+}', array(
			'controller' => 'events',
			'action' => 'slug',
			'slug' => 1
		));

		$router->add('/{slug:[a-zA-Z0-9_-]+}/{event:[a-zA-Z0-9_-]+}', array(
			'controller' => 'events',
			'action' => 'event',
			'slug' => 1,
			'event' => 2
		));

		$router->add('/radio-florida', array(
			'controller' => 'events',
			'action' => 'radioflorida'
		));

    }




	// print_r( $router->getRoutes() );

	return $router;

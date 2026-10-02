<?php

use Phalcon\Mvc\View;
use Phalcon\Mvc\Url as UrlResolver;
use Phalcon\Mvc\View\Engine\Volt as VoltEngine;
use Phalcon\Mvc\Model\Metadata\Memory as MetaDataAdapter;
use Phalcon\Session\Adapter\Files as SessionAdapter;


$di = new Phalcon\DI\FactoryDefault();

/**
 * Shared configuration service
 */
$di->setShared('config', function () {
	return include APP_PATH . "/config/config_global.php";
});


/**
 * Registering a router
 */
$di->setShared('router', function() {
	//require '/../app/config/routes.php';
	//return require __DIR__ . '/../../app/config/routes.php';
	return include APP_PATH . "/config/routes.php";
	//return $router;
});



/**
 * The URL component is used to generate all kind of urls in the application
 */
$di->setShared('url', function () {
	$config = $this->getConfig();

	$url = new UrlResolver();
	$url->setBaseUri($config->application->baseUri);
	//$url->setStaticBaseUri($config->application->baseUriSales);

	return $url;
});

/**
 * A URL para o SUP.tktx.com
 */
$di->set('urlSup', function () {
    $config = $this->getConfig();
    return $config->application->baseUriSup;
});

/**
 * A URL para o site.tktx.com
 */
$di->set('completeUrl', function () {
    $config = $this->getConfig();
    return $config->application->completeUrl;
});
/**
 * A URL para o FILES.tktx.com
 */
$di->set('urlFiles', function () {
    $config = $this->getConfig();
    return $config->application->baseUriFiles;
});


/**
 * A URL para o SALES.tktx.com
 */
$di->set('urlSales', function () {
	$config = $this->getConfig();
	return $config->application->baseUriSales;
});


/**
 * A URL para o CHECKOUT.tktx.com
 */
$di->set('urlCheckout', function () {
	$config = $this->getConfig();
	return $config->application->baseUriCheckout;
});

/**
 * A URL para o FAST-CHECKOUT.tktx.com
 */
$di->set('urlFastCheckout', function () {
	$config = $this->getConfig();
	return $config->application->baseUriFastCheckout;
});

/**
 * O caminho absoluto para o Site.com
 */
$di->set('pathSite', function () {
    $config = $this->getConfig();
    return $config->application->pathSite;
});


/**
 * Setting up the view component
 */
$di->setShared('view', function () {
	$config = $this->getConfig();

	$view = new View();
	$view->setDI($this);
	$view->setViewsDir($config->application->viewsDir);

	$view->registerEngines([
		'.volt' => function ($view) {
			$config = $this->getConfig();

			$volt = new VoltEngine($view, $this);

			$volt->setOptions([
				'compiledPath' => $config->application->cacheViews,
				'compiledSeparator' => '_'
			]);

			return $volt;
		}
	]);

	return $view;
});






/**
 * Start the sendmail
 */
$di->set('mail', function() {
	$config = $this->getConfig();
	return new Mail($config);
});







$di->set(
    'crypt',
    function () {
        $crypt = new Phalcon\Crypt();
        // Set a global encryption key
        $crypt->setKey('Tk2017-2019#Tiktx-USA*BRA');
        return $crypt;
    },
    true
);









/**
 * Database connection is created based in the parameters defined in the configuration file
 */
$di->setShared('db', function () {
	$config = $this->getConfig();

	$class = 'Phalcon\Db\Adapter\Pdo\\' . $config->database->adapter;
	$params = [
		'host'     => $config->database->host,
		'username' => $config->database->username,
		'password' => $config->database->password,
		'dbname'   => $config->database->dbname,
		'charset'  => $config->database->charset
	];

	$connection = new $class($params);

	return $connection;
});


//Set the models cache service
$di->set('cache', function(){
	$config = $this->getConfig();
	//Cache data for one day by default
	$frontCache = new \Phalcon\Cache\Frontend\Data(array(
		"lifetime" => 2592000
	));
	/*
	 // Memcached connection settings
	$cache = new \Phalcon\Cache\Backend\Memcache(
		$frontCache,
		[
			"host" => "localhost",
			"port" => "11211",
		]
	);
	*/
	$cache = new \Phalcon\Cache\Backend\File($frontCache, array(
		 "cacheDir" => $config->application->cacheDB
	));

	return $cache;
});




/**
 * If the configuration specify the use of metadata adapter use it or use memory otherwise
 */
$di->setShared('modelsMetadata', function () {
	return new MetaDataAdapter();
});



/**
 * Start the session the first time some component request the session service
 */
$di->setShared('session', function () {
    $session = new SessionAdapter();
    if ( isset($_REQUEST['sid']) AND $_REQUEST['sid'] AND strlen($_REQUEST['sid']) > 1 ) {
    	session_id($_REQUEST['sid']);
    	// $session->setId($_REQUEST['sid']);
    }
    $session->start();
    return $session;
});



/*
Função que traduz o site
no /public/index.php seta qual o idioma sera usado
Esta funcao "t" busca o arquivo de tradução que corresponde ao idioma selecionado lá na index.php
*/
$di->setShared('t', function(){

	$session = $this->get("session");
	if ( $session->get("language") ) {
		$language = $session->get("language");
	} else {
		$config = $this->getConfig();
		$language = $config->application->default_language;
		$session->set("language", $language);
	}

	if ( isset($_REQUEST['l'])  ) {
		$language = $_REQUEST['l'];
		$session->set("language", $language);
	}

    $translationFile = APP_PATH . "/languages/" . $language . ".php";

    // Check if we have a translation file for that lang
    if (file_exists($translationFile)) {
        require $translationFile;
    } else {
        // Fallback to some default
		require APP_PATH . "/languages/geral.php";
    }

    // Return a translation object
    return new Phalcon\Translate\Adapter\NativeArray(
        [
            "content" => $messages,
        ]
    );
});


/**
 * Para formatar as datas conforme o idioma selecionado
 */
$di->set('formatdates', function() {
    $t = $this->getT();
    return new Formatdates($t, $this->get("session")->get("language"));
});




/**
 * Register the session flash service with the Twitter Bootstrap classes
 */
$di->set('flash', function(){
	$flash = new \Phalcon\Flash\Direct(array(
		'error' => 'alert alert-danger',
		'success' => 'alert alert-success',
		'notice' => 'alert alert-info',
		'warning' => 'alert alert-warning'
	));
	$flash->setAutoescape(false);
	return $flash;
});

$di->set('flashSession', function(){
	$flash = new FlashEscaper(array(
		'error'   => 'alert alert-danger',
		'success' => 'alert alert-success',
		'notice'  => 'alert alert-info',
		'warning' => 'alert alert-warning'
	));
	$flash->setAutoescape(false); // Here's how to change autoescape
	return $flash;
});




class FlashEscaper extends \Phalcon\Flash\Session
{
    public function message($type, $message)
    {
        $message = '<i class="icon-remove close" data-dismiss="alert"></i>' . $message;
        return parent::message($type, $message);
    }
}

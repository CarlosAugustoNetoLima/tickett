<?php




$config_global = [

	'application' => [
		'appDir'         => APP_PATH . '/',
		'controllersDir' => APP_PATH . '/controllers/',
		'modelsDir'      => APP_PATH . '/models/',
		'migrationsDir'  => APP_PATH . '/migrations/',
		'viewsDir'       => APP_PATH . '/views/',
		'pluginsDir'     => APP_PATH . '/plugins/',
		'libraryDir'     => APP_PATH . '/library/',
		'cacheAcl'		=> BASE_PATH . '/cacheAcl/',
		'cacheViews'	=> BASE_PATH . '/cacheViews/',
		'cacheDB'       => BASE_PATH . '/cacheDB/',
	],



];







$config_company = APP_PATH . '/config/config_company/' . COMPANY . '.php';
require $config_company;


$config_company_db = BASE_PATH . '/../config_company/' . COMPANY . '.php';
require $config_company_db;


$config_global = array_merge_recursive($config_global, $config2, $config_db);


// echo 'config_global<pre>';
// print_r($config_global);
// echo '</pre>';

$config = new Phalcon\Config( $config_global );



return $config;
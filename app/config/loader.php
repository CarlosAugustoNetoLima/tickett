<?php

$loader = new \Phalcon\Loader();

/**
* Para incluir os arquivos com funções específicas,
* Tipo formatação do Money
*/
$loader->registerFiles(
    [
        APP_PATH . '/functions/formats.php',
        BASE_PATH . '/vendor/autoload.php',
    ]
);

/**
 * We're a registering a set of directories taken from the configuration file
 */
$loader->registerDirs(
    [
        $config->application->controllersDir,
        $config->application->modelsDir,
		$config->application->libraryDir,
    ]
);


$loader->register();


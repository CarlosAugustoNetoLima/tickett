<?php
	$dev = (strpos($_SERVER['HTTP_HOST'], 'localhost') === 0) ? true : false;
	if ( isset($_REQUEST['forca_dev']) ) {
		echo "<h2>Forçando DEV</h2>";
		$dev = true;
	}

	if ( $dev )
	{
		error_reporting(E_ALL);
		ini_set('display_errors', 'on');
		$time = microtime();
		$time = explode(' ', $time);
		$time = $time[1] + $time[0];
		$start = $time;
	}
	ini_set('memory_limit','512M');
error_reporting(0);
                ini_set('display_errors', 'off');

	define('BASE_PATH', dirname(__DIR__));
	define('APP_PATH', BASE_PATH . '/app');

	$default_company = false;
	if ( $_SERVER['HTTP_HOST'] == 'tiktx.com' OR $_SERVER['HTTP_HOST'] == 'www.tiktx.com' )
	{
		$default_company = 'tiktx';
	} else if ( $_SERVER['HTTP_HOST'] == 'lebillet.com.br' OR $_SERVER['HTTP_HOST'] == 'www.lebillet.com.br' )
	{
		$default_company = 'lebillet';
	} else if ( $_SERVER['HTTP_HOST'] == 'tickett.com' OR $_SERVER['HTTP_HOST'] == 'www.tickett.com' OR  $_SERVER['HTTP_HOST'] == 'tickett.com' OR $_SERVER['HTTP_HOST'] == 'www.tickett.com' )
	{
		$default_company = 'lebillet_pt';
	}

	$company = isset($_REQUEST['company']) ? $_REQUEST['company'] : $default_company;


	if ( !$company ) $company = 'lebillet';

	define('COMPANY', $company);




	$config_company = APP_PATH . '/config/config_company/' . COMPANY . '.php';
	if (file_exists($config_company))
	{
		require_once $config_company;

		if ( isset($config2['application']['date_default_timezone_set']) )
		{
			date_default_timezone_set($config2['application']['date_default_timezone_set']);

		} else {
			date_default_timezone_set('UTC');
		}

	} else {
		date_default_timezone_set('UTC');
	}







		try {

			$application = new Phalcon\Mvc\Application();


			/**
			 * Include services
			 */
			require __DIR__ . "/../app/config/services.php";


			/**
			 * Get config service for use in inline setup below
			 */
			$config = $di->getConfig();// O $di foi instaciado no  require __DIR__ . "/../app/config/services.php";

			/**
			 * Include Autoloader
			 */
			include APP_PATH . '/config/loader.php';


			$application->setDi($di); // O $di foi instaciado no  require __DIR__ . "/../app/config/services.php";



			/**
			* Compacta a resposta html pro servidor
			*/

			function sanitize_output($content) {
					$search = array(
					'/\>[^\S ]+/s', //strip whitespaces after tags, except space
					'/[^\S ]+\</s', //strip whitespaces before tags, except space
					'/(\s)+/s',  // shorten multiple whitespace sequences
					'/>(\s)+</',
					'/\n/',
					'/\r/',
					'/\t/',
					"/ +/",
				);
				$replace = array(
					'>',
					'<',
					'\\1',
					'><',
					' ',
					' ',
					' ',
					' ',
				);

				$content = preg_replace($search, $replace, $content);
				// Remove any empty attributes, except:
				// action, alt, content, src
				$content = preg_replace('/(\s+)(\w++(?<!\baction|\balt|\bcontent|\bsrc)="")/', '$1', $content);
				// Remove any HTML comments, except MSIE conditional comments
				$content = preg_replace('/<!--(?!\s*(?:\[if [^\]]+]|<!|>))(?:(?!-->).)*-->/s', '', $content);

				// Remove any space before the end of self-closing XHTML tags
				// JavaScript excluded
				$content = str_replace(' />', '/>', $content);
				$content = str_replace(' "', '"', $content);
				$content = str_replace('" ', '"', $content);
				return trim($content);
			}

			$html_content = $application->handle()->getContent();


			/**
			* Em "localhost" não compacta o html, pra facilitar a visualização do código fonte
			*/
			if ( $dev) {
				echo $html_content;
			}else {
				echo sanitize_output($html_content);
			}




		} catch ( Exception $e ) {

			$html_error =  '<pre>';
			$html_error .= "URL: " . $url = $_SERVER['SERVER_NAME'] . $_SERVER['REQUEST_URI'] . "\n";
			$html_error .= get_class($e) . ": " . $e->getMessage() . "\n";
			$html_error .= " File=" . $e->getFile() . "\n";
			$html_error .= " Line=" . $e->getLine() . "\n";
			$html_error .= $e->getTraceAsString();
			$html_error .= '</pre>';


			$config_company = BASE_PATH . '/../config_company/' . COMPANY . '.php';
			include $config_company;
			if ( isset($config_db['database']['host']) )
			{

				$servername = $config_db['database']['host'];
				$username = $config_db['database']['username'];
				$password = $config_db['database']['password'];
				$dbname = $config_db['database']['dbname'];
				// Create connection
				$conn = new mysqli($servername, $username, $password, $dbname);
				$html_insert = $conn->real_escape_string($html_error);
				$sql = "INSERT INTO _log_error ('text') VALUES ('$html_insert')";
				$conn->query($sql);
				$conn->close();
			}



			$errorMessage = '<h1>Opsss</h1><h3>An error has occurred. We apologize and we are already checking the reason</h3>';

			if(isset($_SERVER['HTTP_API'])) {
				header('Content-Type: application/json');
				$errorMessage  = json_encode([
					"success" => false,
					"message" => sanitize_output($html_error)
				]);
			}


			$errorMessage = $html_error;
			 if ( $dev OR isset($_REQUEST['debugTicket']) ) {
				$errorMessage = $html_error;
			}


			echo $errorMessage;
		}






	//if ( $dev )
	if ( $dev AND false )
	{
		echo '<pre>';
		print_r($_REQUEST);
		print_r(get_included_files());
		echo '</pre>';

		$time = microtime();
		$time = explode(' ', $time);
		$time = $time[1] + $time[0];
		$finish = $time;
		$total_time = round(($finish - $start), 4);
		echo '<p>t: '.$total_time.' s.</p>';
		echo '<p>Memoria: ' . number_format((memory_get_usage(true))) . ' bytes</p>';
	}

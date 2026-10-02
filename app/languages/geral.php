<?php

	$config_company = BASE_PATH . '/../config_company/' . COMPANY . '.php';
	if (file_exists($config_company))
	{
		require $config_company;
	}


	if ( isset($config_db['database']['host']) )
	{

		$servername = $config_db['database']['host'];
		$username = $config_db['database']['username'];
		$password = $config_db['database']['password'];
		$dbname = $config_db['database']['dbname'];

		//$country = 'pe'; // Country  -  é o pais, tem um banco para cada pais, com o mesmo nome
		$mysqli = new mysqli("$servername" , "$username" , "$password" , "$dbname");
		$mysqli->set_charset("utf8");



		//$language = COUNTRY;
		if ( $language == 'pt_br' ) {
			$var_language = 'pt_br';
		} elseif ( $language == 'pt_pt' ) {
			$var_language = 'pt_pt';
		} elseif ( $language == 'es_do' ) {
			$var_language = 'es_do';
		} elseif ( $language == 'fr_fr' ) {
			$var_language = 'fr_fr';
		} else {
			$var_language = 'en_us';	
		}

		$sql = " SELECT string, $var_language FROM languages WHERE $var_language IS NOT NULL";
		$messages = array();
		if ($result = $mysqli->query($sql))
		{
	        while($obj = $result->fetch_object())
	        {
	        	$messages[$obj->string] = $obj->$var_language;
			}
		}

	}


/*
	Se chegou até aqui, é pq nao tem o arquivo de tradução, então consultou no banco de dados e gerou os arquivos pra tradução.
	Mas como a consulta no banco demora mais, então melhor criar o arquivo de tradução para ser utilizado na proxima requisição.
*/

/*

$fp = fopen('../app/languages/' . $language . '.php', 'a');
$txt = '<?php
$messages = [
	';
foreach ($messages as $key => $value) {
	$txt .= "'$key' => '$value',
	";
}
$txt.= '];';
fwrite($fp, $txt);
fclose($fp);

*/
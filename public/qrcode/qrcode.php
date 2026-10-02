<?php
$time_start = microtime(true);

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);



// Primeiro tenta criar usando uma biblioteca PHP
include('../../vendor/phpqrcode/qrlib.php');


for ($i=0; $i < 20; $i++) {

	$ticket_number = $i . '_666666666';

    $url = 'http://localhost/tickets/site/qrcode/';
    $path_tickets = 'C:/wamp/www/tickets/site/public/qrcode/';
	$qr_code__name = 'qr_code_6666_' . $ticket_number . '.png';
	$img_gerada = '6666_' . $ticket_number . '.png';
	$wkhtmltoimage = '"C:\Program Files\wkhtmltopdf\bin\wkhtmltoimage.exe"';

    $url = 'https://lebillet.com.br/qrcode/';
    $path_tickets = '/www/site/public/qrcode/';
	$qr_code__name = 'qr_code_6666_' . $ticket_number . '.png';
	$img_gerada = '6666_' . $ticket_number . '.png';
	$wkhtmltoimage = 'xvfb-run wkhtmltoimage';


/*

*/


	$path_qr_code = $path_tickets . $qr_code__name;
	$url_qrcode = $url . $qr_code__name;

	$url_gera = $url . 'gera.php?qrcode=' . base64_encode( $qr_code__name );
	$path_gerado = $path_tickets . $img_gerada;


	QRcode::png($ticket_number, $path_qr_code, QR_ECLEVEL_L, 9, 0 );


	//echo "<hr><br> $url_qrcode ";
	//echo "<img   src='{$url_qrcode}' />";

	$command_exec =   $wkhtmltoimage . ' --width 350 --quality 50 ' . $url_gera . ' "' . $path_gerado . '" ';
	$return = exec($command_exec, $output, $return_var);


	echo "<hr><br><img   src='" . $url . $img_gerada . "' /><hr>";

	$time_end = microtime(true);
	//dividing with 60 will give the execution time in minutes otherwise seconds
	$execution_time = ($time_end - $time_start)/60;

	echo '<b>Total Execution Time:</b> '.$execution_time.' Mins';
}

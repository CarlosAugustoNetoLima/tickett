<?php
//use Phalcon\Mvc\Controller;

class VivawalletController extends ControllerBase //Controller
{

	public function onConstruct()
	{
		// Remove a construção do layout - deixando somente o conteúdo carregado neste Controller
		//$this->view->disable();

	}



	public function successAction()
	{
		$OrderCode = $_REQUEST['t'];


		echo 'success<pre>';
		print_r($_REQUEST);
		echo '</pre>';

		return $this->view->pick('vivawallet/index');
	}

	public function errorAction()
	{
		echo 'error<pre>';
		print_r($_REQUEST);
		echo '</pre>';

		return $this->view->pick('vivawallet/index');
	}



}
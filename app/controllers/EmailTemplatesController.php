<?php
class EmailTemplatesController extends ControllerBase
{


	public function templateAction($id = null)
	{
		$this->view->setRenderLevel(
			Phalcon\Mvc\View::LEVEL_ACTION_VIEW
		);


		$customer = Customers::findFirstByEmail('juscelino.iene@gmail.com');
		$this->view->customer = $customer;


		$this->view->pick('emailTemplates/template');
	}


	public function templateEnviarAction($id = null)
	{

		$this->view->disable();
		$param = array();
	   	$sendMail = $this->getDI()->getMail()->send(
				array(
					'juscelino.iene@gmail.com' => 'Juscelino' // destinatario
				),
				$this->config->company->name . ' Email de teste', // assunto
				'template', // template
				$param // array de parametros para ser usado no template
			);

	   	echo 'sendMail<pre>';
	   	print_r($sendMail);
	   	echo '</pre>';
	}














	public function teste_emailAction($id_order = null)
	{
		$this->view->setRenderLevel(
			Phalcon\Mvc\View::LEVEL_ACTION_VIEW
		);
		$this->view->pick('emailTemplates/order-canceled');

		$order = Orders::findFirst($id_order);

	   	$this->view->order = $order;
	}





	public function envia_emailAction($id = null)
	{

		$this->view->disable();

	   	$order = Orders::findFirst($id);

		$param = array('order' => $order, 'title' => $this->config->company->msg_email_order_confirmation . '  #' . $order->id);

	   	$sendMail = $this->getDI()->getMail()->send(
				array(
					'juscelino.iene@gmail.com' => 'Juscelino' // destinatario
				),
				$this->config->company->msg_email_order_confirmation . '  #' . $order->id, // assunto
				'teste_email', // template
				$param // array de parametros para ser usado no template
			);

	   	echo 'sendMail<pre>';
	   	print_r($sendMail);
	   	echo '</pre>';
	}

}
<?php
use Phalcon\Mvc\Controller;

class ViewController extends Controller
{

	public function onConstruct()
	{
		// Remove a construção do layout - deixando somente o conteúdo carregado neste Controller
		//$this->view->disable();
	}



	public function indexAction($id_order = null)
	{

		$decrypt = $this->crypt->decryptBase64(base64_decode($id_order));


		$order = Orders::findFirst("id = '$decrypt'");

		if ( $order AND $order->id = $decrypt )
		{
			$this->view->order = $order;

			$this->view->enable();
			if ( $order->id_orders_status == 10 )
			{
				$this->view->pick("emailTemplates/facial-biometrics");

			} else
			{
				$this->view->pick("emailTemplates/" . $this->config->company->template_email_order_confirmation);
			}
			$this->view->setRenderLevel(
				Phalcon\Mvc\View::LEVEL_ACTION_VIEW
			);

		} else
		{
			// SE NÃO BATER O ID , já abre na página de contato
			$this->flash->error($this->t->_('Order not found'));
			return $this->dispatcher->forward(array(
				'controller' => 'helpdesk',
				'action' => 'index'
			));
		}

	}




	public function smsreleansAction()
	{
			$this->view->setRenderLevel(
				Phalcon\Mvc\View::LEVEL_ACTION_VIEW
			);

			require_once(BASE_PATH . '/app/library/SMSReleans.php');
			//$sendSMS = new SMS('teste');
			$sendSMS = new SMSReleans('producao');


			$cell_number = '+5548999883566';
			$message = 'Testando a API do Releans';
			$sendSMS = $sendSMS->send($cell_number, $message);

			echo '<pre>';
			print_r($sendSMS);
			echo '</pre>';
	}

}
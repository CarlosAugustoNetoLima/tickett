<?php
use Phalcon\Mvc\Controller;

class TwillioController extends Controller
{


	public function indexAction()
	{
		$url = $_SERVER['SERVER_NAME'] . $_SERVER['REQUEST_URI']; //$this->request->getHTTPReferer(); // $this->router->getRewriteUri();
		$ip = $this->request->getClientAddress();
		$session = session_id();
		$agent = $this->request->getUserAgent();
		$request = json_encode($_REQUEST);
		$sql = "
				INSERT INTO _log_site_pages_views
				(
					url,
					ip,
					session,
					agent,
					request
				)
				VALUES
					(
						?,
						?,
						?,
						?,
						?
					)
				";
		$this->db->execute($sql, array($url, $ip, $session, $agent, $request) );
/*
{"_url":"\/twillio","SmsMessageSid":"SM52664f83b6a06d9c388f168f07f0ef34","NumMedia":"0","SmsSid":"SM52664f83b6a06d9c388f168f07f0ef34","SmsStatus":"received","Body":"Testando o twillio","To":"whatsapp:+552731800700","NumSegments":"1","MessageSid":"SM52664f83b6a06d9c388f168f07f0ef34","AccountSid":"ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX","From":"whatsapp:+554899883566","ApiVersion":"2010-04-01"}
*/

		$msg = isset($_REQUEST['Body'])  ? $_REQUEST['Body'] : false;
		$num = isset($_REQUEST['From'])  ? $_REQUEST['From'] : false;

		if ( $msg ) {
			require_once(BASE_PATH . '/app/library/WhatsApp.php');
			//$sendWhatsapp = new WhatsApp('ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', '+552731800700');
			$sendWhatsapp = new WhatsApp();
			$whatsapp = str_replace('whatsapp:', '', $num);
			$message = 'Olá, bem vindo à ' . $this->config->company->name . '!

Estamos pronto para te ajudar através de nossa central de atendimento.

Utilize o link abaixo e seremos o mais breve possível para solucionar seu caso:

' . $this->url->get() . 'helpdesk
';
			$sendWhatsapp = $sendWhatsapp->send($whatsapp, $message);

		}

		$this->view->disable();
		echo '<pre>';
		print_r($_REQUEST);
		echo '</pre>';
	}

}


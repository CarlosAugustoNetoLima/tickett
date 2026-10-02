<?php
use Phalcon\Mvc\User\Component,
	Phalcon\Mvc\View;

require_once __DIR__ . '/../../vendor/Swift/swift_required.php';
/**
 *
 * Sends e-mails based on pre-defined templates
 */
class Mail extends Component
{

	protected $_transport;
	protected $config;


	public function __construct($config)
	{
    	$this->config = $config;
	}


	/**
	 * Applies a template to be used in the e-mail
	 *
	 * @param string $name
	 * @param array $params
	 */
	public function getTemplate($name, $params)
	{

		$parameters = array_merge(array(
			'url' => $this->config->application->baseUri,
		), $params);

		return $this->view->getRender('emailTemplates', $name, $parameters, function($view){
			$view->setRenderLevel(View::LEVEL_LAYOUT);
		});

		return $view->getContent();
	}

	/**
	 * Sends e-mails via gmail based on predefined templates
	 *
	 * @param array $to
	 * @param string $subject
	 * @param string $name
	 * @param array $params
	 */


	public function send($to, $subject, $template, $params, $file = null, $fileExcel = null, $attachments = [])
	{

		//Settings
		$mailSettings = $this->config->mail;
		$from_email = $mailSettings->fromEmail;
		$from_name = $mailSettings->fromName;


		$template = $this->getTemplate($template, $params);

		// Create the message
		$message = Swift_Message::newInstance()
  			->setSubject($subject)
  			->setTo($to)
  			->setFrom(array(
  				$from_email => $from_name
  			))
  			->setBody($template, 'text/html');
  			if (!$this->_transport) {

				$this->_transport = Swift_SmtpTransport::newInstance(
					$mailSettings->smtp->server,
					$mailSettings->smtp->port,
					$mailSettings->smtp->security
				)
		  			->setUsername($mailSettings->smtp->username)
		  			->setPassword($mailSettings->smtp->password);
		  	}

			if($file != null){
				$attachment = Swift_Attachment::fromPath($file.'.pdf');
				$attachment->setFilename('Fatura/Recibo.pdf');
				$message->attach($attachment);
			}

			if($fileExcel != null){
				$attachment = Swift_Attachment::fromPath($fileExcel);
				$attachment->setFilename('Relatório.xlsx');
				$message->attach($attachment);
			}

			// Múltiplos anexos (imagens do formulário de evento, etc.)
			foreach ($attachments as $attachInfo) {
				if (!empty($attachInfo['path']) && file_exists($attachInfo['path'])) {
					$att = Swift_Attachment::fromPath($attachInfo['path']);
					$att->setFilename($attachInfo['name']);
					$message->attach($att);
				}
			}

		  	// Create the Mailer using your created Transport
			$mailer = Swift_Mailer::newInstance($this->_transport);

			return $mailer->send($message);
	}

}

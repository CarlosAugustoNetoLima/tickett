<?php
/**
 * Biblioteca para Twilio
 * envio de mensagens via WhatsApp API
 *
 * Documentação:
 * https://www.twilio.com/console/
 * https://www.twilio.com/pt-br/docs/sms/quickstart/php
 *
 * @author  Édson Kuzniewski <contato@edsonk.com.br>
 * @version 1.0
 * @since   2020-07-07
 */

//namespace Twilio\SDK;


require_once __DIR__ . '/../../vendor/Twilio/autoload.php';

use Phalcon\Mvc\User\Component;
use Twilio\Rest\Client;

/**
 * WhatsApp
 */
class SMSTwilio extends Component {

	private $sid = "";
	private $token = "";
	private $from = "";

	/**
	 * __construct
	 *
	 * @param  string $_sid
	 * @param  string $_token
	 * @return object
	 */
	public function __construct($_sid=null, $_token=null, $_from=null)
	{
		if($_sid && $_token) {
			$this->setSid($_sid);
			$this->setToken($_token);
		} else {
			if($this->config->twilio->sid) {
				$this->setSid($this->config->twilio->sid);
			}
			if($this->config->twilio->token) {
				$this->setToken($this->config->twilio->token);
			}
		}
		if($_from) {
			$this->from = $_from;
		} else if($this->config->twilio->from){
			$this->from = $this->config->twilio->from;
		}
	}

	/**
	 * setSid
	 *
	 * @param  string $_sid
	 * @return string
	 */
	public function setSid($_sid)
	{
		$this->sid = $_sid;
	}

	/**
	 * getSid
	 *
	 * @return string
	 */
	private function getSid()
	{
		return $this->sid;
	}

	/**
	 * setToken
	 *
	 * @param  string $_token
	 * @return string
	 */
	public function setToken($_token)
	{
		$this->token = $_token;
	}

	/**
	 * getToken
	 *
	 * @return string
	 */
	private function getToken()
	{
		return $this->token;
	}

	/**
	 * setFrom
	 *
	 * @param  string $_from
	 * @return string
	 */
	public function setFrom($_from)
	{
		$this->from = $_from;
	}

	/**
	 * getFrom
	 *
	 * @return string
	 */
	private function getFrom()
	{
		return $this->from;
	}

	/**
	 * send
	 *
	 * @param  string $to
	 * @param  string $msg
	 * @return string
	 */
	public function send($to=null, $msg=null)
	{
		// Find your Account Sid and Auth Token at twilio.com/console
		// DANGER! This is insecure. See http://twil.io/secure
		$twilio = new Client($this->sid, $this->token);
		
		
		$_error = array();
		if($to == "" || $to === null) {
			$_error[] = "ERRO: o campo  PARA não pode ser em branco!";
		}
		if($msg == "" || $msg === null) {
			$_error[] = "ERRO: o campo  MENSAGEM não pode ser em branco!";
		}
		
		if(sizeof($_error) == 0) {
			$message = $twilio->messages
							->create(
								$to,
								array(
									'from' => $this->from,
									'body' => $msg
								));
								
			return $message->sid;
		} else {
			throw new \Exception(explode("#E#", implode("#E#", $_error)));
		}
	}

}
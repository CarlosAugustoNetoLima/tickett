<?php
use Phalcon\Mvc\Controller;

class ApiControllerBase extends Controller
{
	protected $requestBody = null;
	private $customer = null;
	private $seller = null;
	private $cart = null;
	private $checkout = null;
	private $session_id = null;



	public function onConstruct()
	{
		$session_id = $this->session->getId();
		$this->session_id = $session_id;
		$this->view->session_id = $session_id;



       	$request = print_r( $this->request->getRawBody() , true) ;
        $ip = $this->request->getClientAddress();
		$session = $session_id;
        $agent = $this->request->getUserAgent();
        $url = "ApiControllerBase - onConstruct ";
        $sql = "
                INSERT INTO _log_api (url,ip,session,agent,request)
                VALUES (?, ?, ?, ?, ?)
                ";
        $this->db->execute($sql, array($url, $ip, $session, $agent, $request) );




		// Verificar se já tem um usuário logado
		// Para add o ID dele no CART
		$customer = $this->session->get('customer');
		if ( $customer )
		{
			$this->customer = $customer;
		}

		$seller = $this->session->get('seller');
		if ( $seller )
		{
			$this->seller = $seller;
		}

		$cart = $this->session->get('cart');
		if ( $cart )
		{
			$this->cart = $cart;
		}


		$this->view->disable();
		$this->response->setContentType('application/json', 'UTF-8');
		$this->requestBody = $this->request->getJsonRawBody();

		if(!isset($_SERVER['HTTP_API'])) {
			return $this->response->redirect('');

		} else if (isset($_SERVER['HTTP_API']) && !$this->request->isPost()) {
			$this->response->setStatusCode(404, "Not Found");

			// Set the content of the response
			$this->response->setContent(json_encode("Sorry, the page doesn't exist"));

			// Send response to the client
			$this->response->send();
			exit;
		}

        $url = "ApiControllerBase - _SERVER ";
        $request =  print_r($_SERVER, true);
        $sql = "
                INSERT INTO _log_api (url,ip,session,agent,request)
                VALUES (?, ?, ?, ?, ?)
                ";
        $this->db->execute($sql, array($url, $ip, $session, $agent, $request) );






		// Grava o log das páginas visitadas por todos usuarios
		 $this->log();
	}




	// Para ser usado em auditoria, casos de investigação, identificar coincidencias de fraude, suspeitos, ataques...
	private function log()
	{
		$url = $_SERVER['SERVER_NAME'] . $_SERVER['REQUEST_URI']; //$this->request->getHTTPReferer(); // $this->router->getRewriteUri();
		$ip = $this->request->getClientAddress();
		$session = $this->session_id;
		$agent = $this->request->getUserAgent();

		// $request = json_encode($_REQUEST);
		$request = print_r( $this->request->getRawBody() , true) ;

		$sql = "
				INSERT INTO _log_api
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
	}




}

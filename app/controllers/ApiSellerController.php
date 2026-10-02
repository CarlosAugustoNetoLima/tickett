<?php

use Phalcon\Http\Response;

class ApiSellerController extends ApiControllerBase
{
    private $session_id = null;
    private $seller = null;

    public function initialize() {
        $session_id = $this->session->getId();
        $this->session_id = $session_id;
        $this->view->session_id = $session_id;

		$seller = $this->session->get('seller');
		if ( !$seller )
		{
			if ($this->dispatcher->getActionName() != 'login' && $this->dispatcher->getActionName() != 'logout')
			{
                $this->response->setStatusCode(404, "Not Found");
                $this->response->setContent(json_encode(array(
                    "success" => false,
                    "message" => "Login ou senha incorretos"
                )));
                $this->response->send();
                exit;
			}
		}
        $this->seller = $seller;
    }

    public function loginAction()
	{
        $session_id = $this->session->getId();
        $this->session_id = $session_id;
        $this->view->session_id = $session_id;

        $seller = $this->session->get('seller');

        // pra nao ficar fazendo novo login toda hora (alguma coisa errado na POS que toda hora faz novamente essa request)
        // Evitar trocar a SESSION pra nao dar erro na venda e no localizador
        if ( $seller ) {
            $seller = $this->seller;

            $request = print_r( $this->request->getRawBody() , true) ;
            $ip = $this->request->getClientAddress();
            $session = $session_id;
            $agent = $this->request->getUserAgent();
            $url = "ApiSellerController - loginAction  1 ";
            $sql = "
                    INSERT INTO _log_api (url,ip,session,agent,request)
                    VALUES (?, ?, ?, ?, ?)
                    ";
            $this->db->execute($sql, array($url, $ip, $session, $agent, $request) );

            $request = "seller->id $seller->id " ;
            $ip = $this->request->getClientAddress();
            $session = $session_id;
            $agent = $this->request->getUserAgent();
            $url = "ApiSellerController - loginAction 2";
            $sql = "
                    INSERT INTO _log_api (url,ip,session,agent,request)
                    VALUES (?, ?, ?, ?, ?)
                    ";
            $this->db->execute($sql, array($url, $ip, $session, $agent, $request) );



            $this->response->setContent(json_encode(array(
                "success" => true,
                "session" => $this->session_id,
                "pos" =>  $seller->id,
                "pdv" =>  $seller->id_sales_points,
                "terminal_name" =>  $seller->name,
                "message" => "login efetuado com sucesso"
            )));
            $this->response->send();
             return;
        }



        $email = isset($this->requestBody->email) ? $this->requestBody->email : '';
        $password = isset($this->requestBody->password) ? $this->requestBody->password : '';
        $serial = isset($this->requestBody->serial) ? $this->requestBody->serial : '';

        if(empty($email) || empty($password)) {
            $this->response->setContent(json_encode(array(
                "success" => false,
                "message" => "São necessários os parâmetros 'email' e 'password'"
            )));
            $this->response->send();
            return;
        }

        $sellerLib = new SellerLib();
        $seller = $sellerLib->login($email, $password);

        if(!$seller) {
            $this->response->setContent(json_encode(array(
                "success" => false,
                "message" => "Login ou senha incorretos"
            )));
            $this->response->send();
            return;
        } else if ($serial && $seller->serial != $serial) {
            $this->response->setContent(json_encode(array(
                "success" => false,
                "message" => "Terminal não autorizado"
            )));
            $this->response->send();
            return;
        }

        $this->session->set("seller", $seller);

        $this->response->setContent(json_encode(array(
            "success" => true,
            "session" => $this->session_id,
            "pos" => $this->session->get('seller')->id,
            "pdv" => $this->session->get('seller')->id_sales_points,
            "terminal_name" => $this->session->get('seller')->name,
            "message" => "login efetuado com sucesso"
        )));
        $this->response->send();


        $request = json_encode(array(
            "success" => true,
            "session" => $this->session_id,
            "pos" => $this->session->get('seller')->id,
            "pdv" => $this->session->get('seller')->id_sales_points,
            "terminal_name" => $this->session->get('seller')->name,
            "message" => "login efetuado com sucesso"
        )) ;
        $ip = $this->request->getClientAddress();
        $session = $session_id;
        $agent = $this->request->getUserAgent();
        $url = "ApiSellerController - loginAction 3";
        $sql = "
                INSERT INTO _log_api (url,ip,session,agent,request)
                VALUES (?, ?, ?, ?, ?)
                ";
        $this->db->execute($sql, array($url, $ip, $session, $agent, $request) );




	}

	public function logoutAction()
	{
        $this->session->destroy();
        $this->response->setContent(json_encode(array(
            "success" => true,
            "message" => "logout efetuado com sucesso"
        )));
        $this->response->send();
	}
}

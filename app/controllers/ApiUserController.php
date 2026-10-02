<?php

use Phalcon\Http\Response;

class ApiuserController extends ApiControllerBase
{
    public function loginAction()
    {
        $email = isset($this->requestBody->email) ? $this->requestBody->email : '';
        $password = isset($this->requestBody->password) ? $this->requestBody->password : '';

        if(empty($email) || empty($password)) {
            $this->response->setStatusCode(404, "Not Found");
            $this->response->setContent(json_encode("Missing parameters"));
            $this->response->send();
            return;
        }
        //TODO chamar lib passando os parâmetros

        $this->response->setContent(json_encode(array(
            'email' => $email,
            'password' => $password
        )));
        $this->response->send();
    }

    public function logoutAction()
    {

    }

    public function registerAction()
    {

    }
}
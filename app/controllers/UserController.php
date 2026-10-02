<?php

class UserController extends ControllerBase
{

	private $user = null;

	public function initialize()
	{
		$user = $this->session->get('user');
		if ( $user )
		{
			$this->session->set("user", $user);
			$this->user = $user;
		}
		$this->view->user = $user;
	}



	public function indexAction()
	{

		$user = $this->session->get('user');
		if ( !$user )
		{
			// ISTO AQUI AQUI FAZ UM REDIRECT PELO BROWSER, muda a URL e tal.
			// return $this->response->redirect('user/login');

			// Este outro aqui é mágico, direciona a ação interna, mantendo a mesma URL sem precisar carregar novamente o site, simplesmente executa a ação de outro controller/action
			return $this->dispatcher->forward(array(
                   "controller" => "user",
                   "action" => "login"
               ));
		}
	}

	public function logoutAction()
	{
		// Remove a session variable
		$this->session->remove("user");

		// Destroy the whole session
		//$this->session->destroy();  // Isto aqui tbm limpa o carrinho que ta na seção

		$this->flash->success("Deslogado");

		return $this->response->redirect('');
	}




	public function registerAction()
	{

		if ($this->request->isPost())
		{
			$nome    = $this->request->getPost("name");
			$email    = $this->request->getPost("email");
			$password = $this->request->getPost("password");

			if ( $nome AND $email AND $password )
			{
				$user = Users::findFirstByEmail($email);
				if ( $user )
				{
					$this->flash->error("O email <b>$email</b> já esta sendo utilizado");
				} else
				{
					$user = new Users();
					$user->name = $nome;
					$user->email = $email;
					$user->password = $password;
					$user->save();


					if ( !$user->save() )
					{
						foreach ($user->getMessages() as $message) {
							$this->flash->error($message);
						}

					}else
					{
						$this->flash->success("Cadastro efetuado com sucesso. Bem vindo ao tiktx");
						$this->session->set("user", $user);
						return $this->response->redirect('user');
					}

				} // if ( $user ) ELSE
			} // if ( $nome AND $email AND $password )
			else
			{
				$this->flash->error("Nome, email e senha são necessários para o cadastro");
			}

		}

	}





	public function loginAction()
	{


		if ($this->request->isPost())
		{
			$email    = $this->request->getPost("email");
			$password = $this->request->getPost("password");

			$user = Users::findFirstByEmail($email);

			if ($user) {
				//if ($this->security->checkHash($password, $user->password))
				if ($user->password == $password )
				{
					$this->session->set("user", $user);

					// Verificar se tem um CART pra esta SESSION - Isto pra setar o ID do USER no carrinho
					$cart = $cart = $this->session->get('cart');
					if ( $cart )
					{
						//$sql = "UPDATE cart SET id_user = '" . $user->id . "' WHERE user_session = '" . session_id() . "' AND id_user = '0' ";
						//  Mudei a regra, pq vai que o cara loga com outro usuario para terminar a compra? TODOOOOOO
						$sql = "UPDATE cart SET id_user = '" . $user->id . "' WHERE user_session = '" . session_id() . "'  ";
						$this->db->execute($sql);
					}

					// Se fizer login pelo CHECKOUT, direciona pra lá novamente
					if ( $this->request->getPost("checkout") )
					{
						return $this->response->redirect('cart');
					}

					//return $this->response->redirect('/');
					return $this->response->redirect('user');

				} else {
					$this->flash->error("Senha incorreta");
				}
			} else {
				$this->flash->error("Login incorreto");
			}


			// Se fizer login pelo CHECKOUT, direciona pra lá novamente
			if ( $this->request->getPost("checkout") )
			{
				return $this->response->redirect('cart');
			}
		}
	}

}
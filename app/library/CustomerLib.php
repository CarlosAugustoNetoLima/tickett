<?php
use Phalcon\Mvc\User\Component;


class CustomerLib extends Component
{



	public function login($email, $password)
	{
		$customer = Customers::findFirstByEmail($email);
		if ($customer) {
			//if ($this->security->checkHash($password, $customer->password))
			if ($customer->password == $password )
			{
				return $customer;
			}
		}

		return false;
	}





	public function remember($email)
	{
		$msg['success'] = false;
		$customer = Customers::findFirstByEmail($email);
		if ($customer)
		{
			$param = '<br><br> <b>Email:</b><br> ' . $customer->email;
			$param .= '<br><br> <b>Senha:</b><br> ' . $customer->password;
			$param = array('dados' => $param );
			//$param = array('customer' => $customer); // Melhorar esta vergonha
			//function send($to, $subject, $template, $params)
			$sendMail = $this->getDI()->getMail()->send(
															array(
																$customer->email => $customer->name // destinatario
															),
															'Remember Password from TiktX',// assunto
															'password-recovery', // template
															$param // array de parametros para ser usado no template
														);

			if ( $sendMail )
			{
				$msg['success'] = true;
			} else {
				$msg['msg'] = $this->t->_('Email not sent') . ' : ' . print_r($sendMail, true);
			}
		} else {  // if ($customer)
			$msg['msg'] = $this->t->_('Email not found');
		}
		return $msg;
	}






	public function register($name, $email, $password = null, $id_number = null, $zip = null, $cell_number = null, $city = null, $region = null, $country = null)
	{
		$msg['success'] = false;

		if ( !$password ) {
			$caracteres = "123456789abcdefghijkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ_-";
			$password = str_shuffle( substr(str_shuffle($caracteres),0,3) . substr(str_shuffle($caracteres),0,3) );
		}
		if ( strlen(trim($name)) > 2 AND filter_var($email, FILTER_VALIDATE_EMAIL) AND strlen(trim($password)) > 2 )
		{
			$customer = Customers::findFirstByEmail($email);
			if ( $customer )
			{
				$msg['msg'] = $this->t->_('Email already in use');
			} else
			{
				$customer = new Customers();
				$customer->name = $name;
				$customer->email = $email;
				$customer->password = $password;

				if ( $id_number )
					$customer->id_number = $id_number;

				if ( $zip )
					$customer->zipcode = $zip;

				if ( $cell_number )
					$customer->cell_number = $cell_number;

				if ( $city )
					$customer->city = $city;

				if ( $region )
					$customer->region = $region;

				if ( $country )
					$customer->country = $country;

				$customer->created_at = date('Y-m-d H:i:s');
				$customer->save();

				if ( !$customer->save() )
				{
					foreach ($customer->getMessages() as $message) {
						$msg['msg'] = $message;
					}

				}else
				{
					$msg['success'] = true;
					$msg['customer'] = $customer;
					$this->session->set("customer", $customer);
				}

			} // if ( $customer ) ELSE
		} // if ( $nome AND $email AND $password )
		else
		{
			$msg['msg'] = $this->t->_('Name, Email and Password is required');
		}

		return $msg;

	}





}
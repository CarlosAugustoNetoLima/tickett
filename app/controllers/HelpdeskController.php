<?php
class HelpdeskController extends ControllerBase
{

	public function initialize()
	{
		$this->view->metaTitle = $this->config->company->name . ' | ' . $this->t->_('helpdesk');
		$this->view->metaDescription = $this->config->company->name . ' | ' . $this->t->_('helpdesk');
	}


	public function indexAction()
	{

		$customer = $this->session->get('customer');
		$this->view->customer = $customer;

		if ($customer != NULL) {
			$orders = Orders::find("id_customer =  $customer->id");
			$this->view->orders = $orders;
		}

		$email = $this->request->get('email', 'string');
		$email = trim(strip_tags($email));
		$number = $this->request->get('number', 'int');
		$number = trim(strip_tags($number));
		$action = $this->request->get('action', 'string');
		$action = trim(strip_tags($action));

		$now = date('Y-m-d H:i:s', strtotime("-60 days"));  // Eventos até 30 passados
		$events = Events::find(array(' display_in_cover = "1" AND date_start >= "' . $now . '" ', 'order' => 'date_start ASC'));
		$this->view->events = $events;

		if ($action == 'view') {
			if ($email and $number) {
				$helpdesk = HelpdeskOpening::findFirst(
					[
						"id = :number: AND email = :email: ",
						"bind" => [
							"number" => $number,
							"email" => $email
						]
					]
				);
				if ($helpdesk) {
					$this->session->set('helpdesk', $helpdesk);
					return $this->response->redirect('helpdesk/view/' . $helpdesk->id . '/#last')->send();
				} else {
					$this->flash->error($this->t->_('helpdesk_not_found'));
				}
			} else {
				$this->flash->error($this->t->_('email_and_number_required'));
			}
		}
	}

	public function viewAction($id = null)
	{
		$this->view->metaNoindex = true;
		$helpdesk = $this->session->get('helpdesk');


		if ($this->request->isPost()) {
			$message = $this->request->getPost('message', 'string');
			$message = trim(strip_tags($message));
			if ($message and  $helpdesk and $helpdesk->id == $id) {
				$helpdesk = HelpdeskOpening::findFirst("id = $id");

				$helpdeskAnswers = new HelpdeskAnswers();
				$helpdeskAnswers->id_helpdesk = $helpdesk->id;
				$helpdeskAnswers->author = $helpdesk->name;
				$helpdeskAnswers->message = $message;
				$helpdeskAnswers->ip = $this->request->getClientAddress();
				$helpdeskAnswers->session = session_id();
				$helpdeskAnswers->agent = $this->request->getUserAgent();
				$helpdeskAnswers->created_at = date('Y-m-d H:i:s');
				if (!$helpdeskAnswers->save()) {
					foreach ($helpdeskAnswers->getMessages() as $message) {
						$this->flash->error($message);
					}
				} else {
					$helpdesk->status = 0; // 0 Novo | 1 Lido | 2 Respondido | 3 Finalizado
					$helpdesk->save();


					// Envia uma requisição para a rota a seguir
					// Lá vai validar qual ADMIN  quer receber uma notificação da atendimento
					$url = $this->di->get('urlSup') . 'pushnotifications/helpdesk/' . $helpdesk->id;
					$commandExec = "wget " . $url . "  > /dev/null &";
					$exec = exec($commandExec);
				}
			}
		}



		// Confere se o HELPDESK na session é o mesmo ID da URL, ai continua
		if ($helpdesk and $helpdesk->id == $id) {
			$this->view->helpdesk = $helpdesk;
		} else {
			$this->flash->error($this->t->_('helpdesk_not_found'));
			return $this->dispatcher->forward(array(
				'controller' => 'helpdesk',
				'action' => 'index'
			));
		}
	}

	public function newAction()
	{
		$name = $this->request->getPost('name');
		$name = trim(strip_tags($name));
		$email = $this->request->getPost('email');
		$email = trim(strip_tags($email));
		$event = $this->request->getPost('event');
		$event = trim(strip_tags($event));
		$subject = $this->request->getPost('subject');
		$subject = trim(strip_tags($subject));
		$message = $this->request->getPost('message');
		$message = trim(strip_tags($message));
		$order = $this->request->getPost('order');
		$order = trim(strip_tags($order));

		if ($event or $event == '0') {
			// Postou o evento
		} else {
			$this->flash->error($this->t->_('Select the event you want to talk about'));
			return $this->dispatcher->forward(array(
				'controller' => 'helpdesk',
				'action' => 'index'
			));
		}

		if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
			$this->flash->error($this->t->_('Enter a valid email'));
			return $this->dispatcher->forward(array(
				'controller' => 'helpdesk',
				'action' => 'index'
			));
		}

		if($subject == ""){
			$this->flash->error($this->t->_('Favor selecionar um assunto'));
			return $this->dispatcher->forward(array(
				'controller' => 'helpdesk',
				'action' => 'index'
			));
		}


		if ($name and $email and $message) {
			$helpdesk = new HelpdeskOpening();
			$helpdesk->name = $name;
			$helpdesk->email = $email;
			if ($event and $event > 0) {
				$helpdesk->id_event = $event;
			}
			$helpdesk->subject = $subject;
			$helpdesk->status = 0; // 0 Novo | 1 Lido | 2 Respondido | 3 Finalizado
			$helpdesk->created_at = date('Y-m-d H:i:s');
			if(!empty($order)){
				$helpdesk->id_order = $order;
			}

			if (!$helpdesk->save()) {
				foreach ($helpdesk->getMessages() as $message) {
					$this->flash->error($message);
				}

				return $this->dispatcher->forward(array(
					'controller' => 'helpdesk',
					'action'	=> 'index',
				));
			} else {
				$helpdeskAnswers = new HelpdeskAnswers();
				$helpdeskAnswers->id_helpdesk = $helpdesk->id;
				$helpdeskAnswers->author = $helpdesk->name;
				$helpdeskAnswers->message = $message;
				$helpdeskAnswers->ip = $this->request->getClientAddress();
				$helpdeskAnswers->session = session_id();
				$helpdeskAnswers->agent = $this->request->getUserAgent();
				$helpdeskAnswers->created_at = date('Y-m-d H:i:s');
				if (!$helpdeskAnswers->save()) {
					foreach ($helpdeskAnswers->getMessages() as $message) {
						$this->flash->error($message);
					}
					return $this->dispatcher->forward(array(
						'controller' => 'helpdesk',
						'action'	=> 'index',
					));
				} else {



					// Envia uma requisição para a rota a seguir
					// Lá vai validar qual ADMIN  quer receber uma notificação da atendimento
					$url = $this->di->get('urlSup') . 'pushnotifications/helpdesk/' . $helpdesk->id;
					$commandExec = "wget " . $url . "  > /dev/null &";
					$exec = exec($commandExec);



					// Envia email notificando sobre a nova mensagem
					// Não envia mais - OLHA NO SUP que ta tudo lá
					/*
					$param = array('helpdesk' => $helpdesk);
					$sendMail = $this->getDI()->getMail()->send(
						array(
							'juscelino.iene@gmail.com' => 'Juscelino'
						),
						$this->config->company->full_name . ' - Novo Helpdesk: ' . $subject, // assunto
						'helpdesk-new-contact-information', // template
						$param // array de parametros para ser usado no template
					);
*/
				}

				$this->session->set('helpdesk', $helpdesk);
				return $this->response->redirect('helpdesk/view/' . $helpdesk->id . '/#last')->send();
			}
		} else // if ( $name AND $email AND $message )
		{
			$this->flash->error($this->t->_('name_email_message_required'));
			return $this->dispatcher->forward(array(
				'controller' => 'helpdesk',
				'action' => 'index'
			));
		}
	}
}

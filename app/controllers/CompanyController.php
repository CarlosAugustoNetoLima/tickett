<?php
class CompanyController extends ControllerBase
{
	// About Company Tiktx
	public function indexAction()
	{
		$title = $this->config->company->name . ' | ' . $this->t->_('about');
		$this->view->metaTitle = $title;
		$this->view->metaDescription = $title;
	}

	public function policies_proceduresAction()
	{
		$title = $this->config->company->name . ' | ' . $this->t->_('policies_procedures');
		$this->view->metaTitle = $title;
		$this->view->metaDescription = $title;
	}


	public function privacyAction()
	{
		$title = $this->config->company->name . ' | ' . $this->t->_('privacy');
		$this->view->metaTitle = $title;
		$this->view->metaDescription = $title;
	}



	public function termsAction()
	{
		$title = $this->config->company->name . ' | ' . $this->t->_('Terms and Conditions');
		$this->view->metaTitle = $title;
		$this->view->metaDescription = $title;
	}


	public function securityAction()
	{
		$title = $this->config->company->name . ' | ' . $this->t->_('security');
		$this->view->metaTitle = $title;
		$this->view->metaDescription = $title;
	}


	public function faqAction()
	{
		$title = $this->config->company->name . ' | ' . $this->t->_('faq');
		$this->view->metaTitle = $title;
		$this->view->metaDescription = $title;
	}


	public function sellAction()
	{
		$title = $this->config->company->name . ' | ' . $this->t->_('sell_your_event');
		$this->view->metaTitle = $title;
		$this->view->metaDescription = $title;
	}





	public function meia_entradaAction()
	{
		$title = $this->config->company->name . ' | ' . $this->t->_('Meia Entrada');
		$this->view->metaTitle = $title;
		$this->view->metaDescription = $title;
	}





	public function newsletterAction()
	{
		$this->view->disable();
		$this->response->setContentType('application/json', 'UTF-8'); // Isto faz retornar um JSON

		$email = $this->request->getPost('email');
		if ( $email AND filter_var($email, FILTER_VALIDATE_EMAIL) )
		{
			$news = new Newsletter();
			$news->email = $email;
			$news->session = session_id();
			$news->created_at = date('Y-m-d H:i:s');

			$msg = array();
			$msg['email'] = $email;
			if ( !$news->save() )
			{
				$msg['status'] = 'error';
				foreach ($news->getMessages() as $message) {
					$msg['msg'] = $message->getMessage();
				}
			} else
			{
				$msg['status'] = 'success';
				$msg['msg'] =  $this->t->_('email_save_success');
			}
		} else {
			$msg['status'] = 'error';
			$msg['msg'] =  $this->t->_('invalid_email');
		}
		return json_encode($msg);
	}


}
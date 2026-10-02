<?php
class EventController extends ControllerBase
{
	/**
	 * Index action
	 */
	public function indexAction($id, $name = false)
	{

		/* Pra carregar o IFRAME do Embedded - Pega a url do checkout que ta no config */
		$this->view->urlCheckout  = $this->di->get('urlCheckout');

		$event = Events::findFirst($id);
		if ( $event == false ) {
			$this->flash->error('O evento buscado não foi encontrado');
			return $this->dispatcher->forward(array(
				'controller' => 'index',
				'action' => 'index'
			));
		}

		/* Conta a visita ao evento */
		$event->visit = $event->visit + 1;
		$event->save();

		$event_name = $event->name;
		if ( $event->ticket_sub_name ) {
			$event_name = $event->name . ' | ' . $event->ticket_sub_name;
		}


		$title =  $event_name . ' - ' . $event->Places->Cities->name . ', '  . $event->Places->Regions->name . ' - ' . date('d', strtotime( $event->date_start )) . ', ' . $this->t->_(date('F', strtotime( $event->date_start ))) . ', ' . date('Y', strtotime( $event->date_start )) . ' | ' . $this->config->company->name;



		$this->view->metaTitle = $title;

		if ( $event->tags ) {
			$this->view->metaDescription = $title . ' | ' . $event->tags;
		} else {
			$this->view->metaDescription = $title ;
		}


		$this->view->event = $event;

		// Pega o carrinho da SESSION, só pra preencher novamente as quantidades dos produtos já selecionados antes
		$this->view->cart = $this->session->get('cart');


		if ( isset($event->EventsImages) AND isset($event->EventsImages[0]) )
			$this->view->og_img = $event->EventsImages[0]->name;

		$this->view->og_title = $title;

		if ( $event->tags ) {
			$this->view->og_description = $title. ' | ' . $event->tags;
		} else {
			$this->view->og_description = $title ;
		}
		$this->view->og_url = "event/$event->id/$event->slug";
		/*
		og:type,
		fb:app_id
		*/


	}




}

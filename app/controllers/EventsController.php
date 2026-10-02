<?php

class EventsController extends ControllerBase
{



	public function indexAction()
	{
		return $this->dispatcher->forward(array(
			'controller' => 'events',
			'action' => 'slug',
			'slug'	=> 'tiktx'
		));
	}



	public function slugAction($slug = false)
	{
		$this->view->setRenderLevel(
			Phalcon\Mvc\View::LEVEL_LAYOUT
		);
		$this->view->pick("events/index");

		$this->view->org = false;
		$this->view->events = false;

		$embedded = false;
		if ( $slug ) {
			$embedded = EventsEmbedded::findFirst(
				[
					"slug = :slug: ",
					"bind" => [
						"slug" => $slug
					]
				]
			);
		}

		$where = '';
		if ( $embedded )
		{
			if (  strlen($embedded->title) > 0 ) {
				$this->view->metaTitle = $embedded->title;
			}

			if (  strlen($embedded->event) > 0 ) {
				$where .= ' AND e.id IN ( ' . $embedded->event . ' )  ';
			}
			if (  strlen($embedded->organizer) > 0 ) {
				$where .= ' AND e.id_organizer IN ( ' . $embedded->organizer . ' )  ';
			}
			if (  strlen($embedded->place) > 0 ) {
				$where .= ' AND e.id_place IN ( ' . $embedded->place . ' )  ';
			}
			if (  strlen($embedded->city) > 0 ) {
				$where .= ' AND e.id_city IN ( ' . $embedded->city . ' )  ';
			}
			if (  strlen($embedded->region) > 0 ) {
				$where .= ' AND e.id_region IN ( ' . $embedded->region . ' )  ';
			}
		}


		$limit = 20;
		if ( isset($_REQUEST['last']) ) {
			$where .= ' AND date_start < NOW() ';
		} else {
			$where .= ' AND date_start > NOW() ';
		}

		$sql = "
			SELECT
			    *
			FROM
			    events e
			WHERE display_in_cover = '1'
			$where
			ORDER BY date_start
			LIMIT $limit
		";
		$events_model = new Events();
		$events = new Phalcon\Mvc\Model\Resultset\Simple(null, $events_model, $events_model->getReadConnection()->query($sql));
		$this->view->events = $events;

	}

	public function eventAction($id = false)
	{
		print_r($_REQUEST);

	}




	public function radiofloridaAction()
	{
		$this->view->setRenderLevel(
			Phalcon\Mvc\View::LEVEL_ACTION_VIEW
		);

		$embedded = EventsEmbedded::findFirst(10);
		$this->view->metaTitle = $embedded->title;

		$limit = 20;

		$sql = "
			SELECT
			    *
			FROM
			    events e
			WHERE date_start > NOW()
		 	display_in_cover = '1'
			ORDER BY date_start
		";
		$events_model = new Events();
		$events = new Phalcon\Mvc\Model\Resultset\Simple(null, $events_model, $events_model->getReadConnection()->query($sql));
		$this->view->events = $events;


	}

}

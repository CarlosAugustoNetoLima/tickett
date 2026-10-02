<?php

class PerformerController extends ControllerBase
{


	public function indexAction($slug = null)
	{

		$performer = false;
		if ( $slug ) {
			$performer = Performers::findFirst(
					[
						"slug = :slug: ",
						"bind" => [
							"slug" => $slug
						]
					]
				);
		}

		if ( $performer ) {
			$sql = "
				SELECT
				    *
				FROM
				    events e
				WHERE e.id > 12
				AND display_in_cover = '1'
				    AND e.id IN
				    (SELECT
				        id_event
				    FROM
				        events_performes
				    WHERE id_performer = $performer->id )
				ORDER BY date_start
				LIMIT 10
			";
			$events_model = new Events();
			$events = new Phalcon\Mvc\Model\Resultset\Simple(null, $events_model, $events_model->getReadConnection()->query($sql));

			$this->view->events = $events;
			$this->view->performer = $performer;


			$this->view->metaTitle = $this->config->company->name . ' | ' . $performer->name;
			$this->view->metaDescription = $this->config->company->name . ' | ' . $performer->name;


		} else {
			$this->view->performers = Performers::find(array('order' => 'name ASC'));
			$this->view->pick('performer/all');
		}



	}


}
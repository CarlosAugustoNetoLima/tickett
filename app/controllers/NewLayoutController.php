<?php
class NewlayoutController extends ControllerBase
{
	public function indexAction()
	{

		$now = date('Y-m-d H:i:s');  // 2018-09-01 21:00:00


		// Neste, ignora os eventos em destaques, pois já aparecem em cima
		// $events = Events::find(array(' display_in_cover = "1" AND featured_premium = 0 AND featured = 0  AND date_start > NOW() ', 'order' => 'date_start ASC'));
		//     $events = Events::find(array(' display_in_cover = "1"  AND date_start > "' . $now . '" ', 'order' => 'date_start ASC'));
		//    $this->view->events = $events;

		$sql = "
			(
			SELECT
				t.id,
				t.name,
				t.slug,
				t.ticket_sub_name,
				t.label_date,
				t.date_start,
				t.date_opening,
				c.name city_name,
				r.name region_name,
				r.acronym region_acronym,
				p.name as place_name,
				(SELECT
					ei.name
				FROM
					events_images ei
				WHERE ei.id_event = t.id
				LIMIT 1) image,
				'event' AS 'type'
			FROM
				ticket.events t
				LEFT JOIN cities c
					ON c.id = t.id_city
				LEFT JOIN regions r
					ON r.id = t.id_region
				LEFT JOIN places p
					ON t.id_place = p.id
			WHERE t.date_sales_end > '" . $now . "'
				AND t.display_in_cover = '1'
				AND t.id NOT IN (SELECT id_event FROM events_groups )
			)

			UNION

			(
			SELECT
				t.id,
				t.name,
				t.slug,
				t.ticket_sub_name,
				t.label_date,
				t.date_start,
				t.date_opening,
				c.name city_name,
				r.name region_name,
				r.acronym region_acronym,
				t.image,
				'group' AS 'type',
				'1' AS place_name
			FROM
				ticket.groups t
				INNER JOIN events_groups  eg
					ON eg.id_group = t.id
				INNER JOIN events e
					ON e.id = eg.id_event
				LEFT JOIN cities c
					ON c.id = t.id_city
				LEFT JOIN regions r
					ON r.id = t.id_region
			WHERE t.date_start > '" . $now . "'
				AND t.display_in_cover = '1'
				AND e.date_sales_end > '" . $now . "'
			GROUP BY t.id
			)

			ORDER BY date_start ASC
		";
		$events = $this->db->fetchAll($sql);
		$this->view->events = $events;



		$sql = "
			(
			SELECT
				t.id,
				t.name,
				t.slug,
				t.ticket_sub_name,
				t.label_date,
				t.date_start,
				t.date_opening,
				t.bannerPrincipal,
				t.featured_premium,
				c.name city_name,
				r.name region_name,
				r.acronym region_acronym,
				'event' AS 'type',
				p.name as place_name
			FROM
				ticket.events t
				LEFT JOIN cities c
					ON c.id = t.id_city
				LEFT JOIN regions r
					ON r.id = t.id_region
				LEFT JOIN places p
					ON t.id_place = p.id
			WHERE t.date_sales_end > '" . $now . "'
				AND t.display_in_cover = '1'
				AND t.featured_premium > 0
				AND t.id NOT IN (SELECT id_event FROM events_groups )
			)

			UNION

			(
			SELECT
				t.id,
				t.name,
				t.slug,
				t.ticket_sub_name,
				t.label_date,
				t.date_start,
				t.date_opening,
				t.featured_premium,
				c.name city_name,
				r.name region_name,
				r.acronym region_acronym,
				t.bannerPrincipal,
				'group' AS 'type',
				'1' AS place_name
			FROM
				ticket.groups t
				INNER JOIN events_groups  eg
					ON eg.id_group = t.id
				INNER JOIN events e
					ON e.id = eg.id_event
				LEFT JOIN cities c
					ON c.id = t.id_city
				LEFT JOIN regions r
					ON r.id = t.id_region
			WHERE t.date_start <= '" . $now . "'
				AND t.display_in_cover = '1'
				AND t.featured_premium > 0
				AND e.date_sales_end >= '" . $now . "'
			GROUP BY t.id
			)

			ORDER BY featured_premium DESC, date_start ASC
		";
		$events_featured_premium = $this->db->fetchAll($sql);
		//$events_featured_premium = Events::find(array(' display_in_cover = "1" AND featured_premium > 0 AND date_start > "' . $now . '" ', 'order' => 'featured_premium DESC, date_start ASC'));
		$this->view->events_featured_premium = $events_featured_premium;








		$sql = "
			(
			SELECT
				t.id,
				t.name,
				t.slug,
				t.ticket_sub_name,
				t.label_date,
				t.date_start,
				t.date_opening,
				t.featured,
				c.name city_name,
				r.name region_name,
				r.acronym region_acronym,
				p.name as place_name,
				(SELECT
					ei.name
				FROM
					events_images ei
				WHERE ei.id_event = t.id
				LIMIT 1) image,
				'event' AS 'type'
			FROM
				ticket.events t
				LEFT JOIN cities c
					ON c.id = t.id_city
				LEFT JOIN regions r
					ON r.id = t.id_region
				LEFT JOIN places p
					ON t.id_place = p.id
			WHERE t.date_sales_end > '" . $now . "'
				AND t.display_in_cover = '1'
				AND t.featured > 0
				AND t.id NOT IN (SELECT id_event FROM events_groups )
			)

			UNION

			(
			SELECT
				t.id,
				t.name,
				t.slug,
				t.ticket_sub_name,
				t.label_date,
				t.date_start,
				t.date_opening,
				t.featured,
				c.name city_name,
				r.name region_name,
				r.acronym region_acronym,
				t.image,
				'group' AS 'type',
				'1' AS place_name
			FROM
				ticket.groups t
				INNER JOIN events_groups  eg
					ON eg.id_group = t.id
				INNER JOIN events e
					ON e.id = eg.id_event
				LEFT JOIN cities c
					ON c.id = t.id_city
				LEFT JOIN regions r
					ON r.id = t.id_region
			WHERE t.date_start > '" . $now . "'
				AND t.display_in_cover = '1'
				AND t.featured > 0
				AND e.date_sales_end > '" . $now . "'
			GROUP BY t.id
			)

			ORDER BY featured DESC, date_start ASC
		";
		$events_featured = $this->db->fetchAll($sql);

		$sql = "SELECT * FROM cities ORDER BY name";
		$cities = $this->db->fetchAll($sql);

		// $events_featured = Events::find(array(' display_in_cover = "1" AND featured > 0 AND date_start > "' . $now . '" ', 'order' => 'featured DESC, date_start ASC'));
		$this->view->events_featured = $events_featured;
		$this->view->cities = $cities;
	}


	public function pasteventsAction()
	{
		$now = date('Y-m-d H:i:s');  // 2018-09-01 21:00:00

		$events = Events::find(array(' display_in_cover = "1"  AND date_sales_end < NOW() ', 'order' => 'date_start DESC'));
		$this->view->events = $events;
	}





	public function searchAction($term = null)
	{
		$now = date('Y-m-d H:i:s');  // 2018-09-01 21:00:00

		if (isset($_REQUEST['term'])) {
			$term = $_REQUEST['term'];
		}
		$term = trim(strip_tags($term));

		$this->view->term = $term;

		if ($term and strlen($term)) {
			$title = $this->config->company->name . ' | ' . $term;
			$this->view->metaTitle = $title;
			$this->view->metaDescription = $title;

			$events = Events::find(array(' display_in_cover = "1" AND (name LIKE "%' . $term . '%" OR resume LIKE "%' . $term . '%" OR tags LIKE "%' . $term . '%" OR description LIKE "%' . $term . '%" )  ', 'order' => 'date_start DESC'));
		} else {
			$events = array();

			$params = "";
			if (isset($_REQUEST['city']) && $_REQUEST['city'] != "0") {
				$params .= "id_city = " . $_REQUEST['city'];
			}

			if (isset($_REQUEST['dateOf']) && !empty($_REQUEST['dateOf'])) {
				if ($params == "") {
					$params .= "date_opening >= '" . $_REQUEST['dateOf'] . "'";
				} else {
					$params .= " AND date_opening >= '" . $_REQUEST['dateOf'] . "'";
				}
			}

			if (isset($_REQUEST['dateUntil']) && !empty($_REQUEST['dateUntil'])) {
				if ($params == "") {
					$params .= "date_opening <= '" . $_REQUEST['dateUntil'] . "'";
				} else {
					$params .= " AND date_opening <= '" . $_REQUEST['dateUntil'] . "'";
				}
			}

			$events = Events::find(array($params, 'order' => 'date_start DESC'));

			if ($params == "") {
				$events = array();
			}
		}
		$this->view->events = $events;
	}



	public function profileAction() {}

	function sendMailEventAction()
	{

		$name    = $this->request->getPost('name');
		$email = $this->request->getPost('email');
		$subject = $this->request->getPost('subject');
		$message = $this->request->getPost('message');
		$phone = $this->request->getPost('phone');

		$param = array('name' => $name, 'message' => $message, 'subject' => $subject, 'email' => $email, 'phone' => $phone);
		
		//function send($to, $subject, $template, $params)
		$sendMail = $this->getDI()->getMail()->send(
			array(
				'atendimento@lebillet.my' => 'atendimento@lebillet.my',
				//$email => $email
			),
			$this->config->company->full_name . ' | ' . $subject, // assunto
			'event-create', // template
			$param
		);

		if ($sendMail) {
			$sendMail = $this->getDI()->getMail()->send(
				array(
					$email => $email
				),
				$this->config->company->full_name . ' | ' . $subject, // assunto
				'event-create-send', // template
				$param
			);
			$this->response->setContent(json_encode(array('msg' => 'Mensagem encaminhada com sucesso', 'success' => true)));
			return $this->response->send();
		} else {
			$this->response->setContent(json_encode(array('msg' => 'Erro: ' . print_r($sendMail), 'success' => false)));
			return $this->response->send();
		}
	}
}

<?php
class IndexController extends ControllerBase
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
				-- AND t.id NOT IN (SELECT id_event FROM events_groups )
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
				p.name as place_name,
				t.image,
				'group' AS 'type'
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
				LEFT JOIN places p
					ON t.id_place = p.id
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
				(SELECT
					ei.name
				FROM
					events_images ei
				WHERE ei.id_event = t.id
				LIMIT 1) image,
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
				t.bannerPrincipal,
				t.featured_premium,
				c.name city_name,
				r.name region_name,
				r.acronym region_acronym,
				t.image,
				'group' AS 'type',
				p.name as place_name
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
				LEFT JOIN places p
					ON t.id_place = p.id
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
				p.name as place_name,
				t.image,
				'group' AS 'type'
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
				LEFT JOIN places p
					ON t.id_place = p.id
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
		



		$flag = $this->session->get("flag") != NULL ? $this->session->get("flag") : 'POR';

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
				INNER JOIN countries co
					ON co.id = r.id_country
				LEFT JOIN places p
					ON t.id_place = p.id
			WHERE t.date_sales_end > '" . $now . "'
				AND co.iso = '" . $flag . "'
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
				'1' AS place_name,
				t.image,
				'group' AS 'type'
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
				INNER JOIN countries co
					ON co.id = r.id_country
				LEFT JOIN places p
					ON t.id_place = p.id
			WHERE t.date_start > '" . $now . "'
				AND t.display_in_cover = '1'
				AND e.date_sales_end > '" . $now . "'
				AND co.iso = '" . $flag . "'
			GROUP BY t.id
			)

			ORDER BY date_start ASC
		";
		
		$eventsCountry = $this->db->fetchAll($sql);
		$this->view->eventsCountry = $eventsCountry;

		
		$sql = "
			select distinct co.iso, count(*) as qty
			from countries as co 
			inner join regions as r on co.id = r.id_country
			inner join events as e on r.id = e.id_region
			where e.date_sales_end > '" . $now . "' and e.display_in_cover = '1' and e.id not in (select id_event from events_groups )
			group by co.iso
		";
		
		$eventsCountryQty = $this->db->fetchAll($sql);
		$arrayflags = ['POR', 'ESP', 'HOL', 'FRA', 'CHE', 'BEL'];
		$newFlags = [];
		foreach($eventsCountryQty as $c){
			if($c['qty'] > 0){
				foreach($arrayflags as $f){
					if($c['iso'] == $f){
						array_push($newFlags, $c['iso']);
					}
				}
			}
		}
		$this->view->arrayflags = $newFlags;
		
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
		$category = null;
		$termSearch = '';
		$categorySearch = '';
		if (isset($_REQUEST['term']) && strlen($_REQUEST['term']) > 0) {
			$term = $_REQUEST['term'];
			$termSearch = 'AND (name LIKE "%' . $term . '%" OR resume LIKE "%' . $term . '%" OR tags LIKE "%' . $term . '%" OR description LIKE "%' . $term . '%" )';
		}

		if (isset($_REQUEST['category']) && strlen($_REQUEST['category']) > 0) {
			$category = $_REQUEST['category'];
			$categorySearch = 'AND categories LIKE "%' . $category . '_%"';
		}

		$term = trim(strip_tags($term));
		$category = trim(strip_tags($category));

		$this->view->term = $term;
		$this->view->category = $category;

		if ($term and strlen($term)) {
			$title = $this->config->company->name . ' | ' . $term;
			$this->view->metaTitle = $title;
			$this->view->metaDescription = $title;

			$events = Events::find(array(' display_in_cover = "1" ' . $termSearch . ' ' . $categorySearch, 'order' => 'date_start DESC'));
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
			
			if (isset($_REQUEST['category']) && strlen($_REQUEST['category']) > 0) {
				if ($params == "") {
					$params .= 'categories LIKE "%' . $category . '_%"';
				} else {
					$params .= ' AND categories LIKE "%' . $category . '_%"';
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
		/*$gRecaptchaResponse = $this->request->getPost('g-recaptcha-response');
		if ($gRecaptchaResponse == "") {
			$this->response->setContent(json_encode(array('msg' => 'Confirme que você não é um robô clicando no reCaptcha', 'success' => false)));
			return $this->response->send();
		}*/
 
		// Dados do Promotor
		$name             = $this->request->getPost('name');
		$email            = $this->request->getPost('email');
		$phone            = $this->request->getPost('phone');
		$promotorEntidade = $this->request->getPost('subject');
		$promotorNif      = $this->request->getPost('promotorNif');
		$promotorWebsite  = $this->request->getPost('promotorWebsite');
 
		// Dados do Evento
		$eventoNome           = $this->request->getPost('eventoNome');
		$eventoCategoria      = $this->request->getPost('eventoCategoria');
		$eventoDescricao      = $this->request->getPost('message');
		$eventoDataInicio     = $this->request->getPost('eventoDataInicio');
		$eventoAberturaPortas = $this->request->getPost('eventoAberturaPortas');
		$eventoHoraInicio     = $this->request->getPost('eventoHoraInicio');
		$vendasFim            = $this->request->getPost('vendasFim');
		$vendasFimHora        = $this->request->getPost('vendasFimHora');
		$eventoLocal          = $this->request->getPost('eventoLocal');
		$eventoMorada         = $this->request->getPost('eventoMorada');
		$eventoCidade         = $this->request->getPost('eventoCidade');
		$eventoPais           = $this->request->getPost('eventoPais');
 
		// Bilhética
		$bilhetes          = $this->request->getPost('bilhetes');
		$lotacaoTotal      = $this->request->getPost('lotacaoTotal');
		$idadeRestricao    = $this->request->getPost('idadeRestricao');
		$caracteristicas   = $this->request->getPost('caracteristicas');
		$mobilidadeLotacao = $this->request->getPost('mobilidadeLotacao');
		$descontos         = $this->request->getPost('descontos');
		$observacoes       = $this->request->getPost('observacoes');
 
		$subject = 'Nova submissão de evento: ' . $eventoNome;
 
		$param = array(
			// Promotor
			'name'                => $name,
			'email'               => $email,
			'phone'               => $phone,
			'promotorEntidade'    => $promotorEntidade,
			'promotorNif'         => $promotorNif,
			'promotorWebsite'     => $promotorWebsite,
			// Evento
			'eventoNome'          => $eventoNome,
			'eventoCategoria'     => $eventoCategoria,
			'message'             => $eventoDescricao,
			'eventoDataInicio'    => $eventoDataInicio,
			'eventoAberturaPortas'=> $eventoAberturaPortas,
			'eventoHoraInicio'    => $eventoHoraInicio,
			'vendasFim'           => $vendasFim,
			'vendasFimHora'       => $vendasFimHora,
			'eventoLocal'         => $eventoLocal,
			'eventoMorada'        => $eventoMorada,
			'eventoCidade'        => $eventoCidade,
			'eventoPais'          => $eventoPais,
			// Bilhética
			'bilhetes'            => $bilhetes,
			'lotacaoTotal'        => $lotacaoTotal,
			'idadeRestricao'      => $idadeRestricao,
			'caracteristicas'     => $caracteristicas,
			'mobilidadeLotacao'   => $mobilidadeLotacao,
			'descontos'           => $descontos,
			'observacoes'         => $observacoes,
			// Compat
			'subject'             => $subject,
		);
 
		// ---- Upload de imagens: salva em temp e prepara anexos ----
		$pathSite   = $this->di->get('pathSite');
		$tempDir    = $pathSite . 'public/tmp_events/';
		if (!is_dir($tempDir)) {
			mkdir($tempDir, 0755, true);
		}
 
		$attachments  = [];
		$tempFiles    = []; // para limpeza posterior
		$uploadedFiles = $this->request->getUploadedFiles();
 
		foreach ($uploadedFiles as $file) {
			if ($file->getError() !== UPLOAD_ERR_OK) continue;
			$key       = $file->getKey();
			$origName  = preg_replace('/[^a-zA-Z0-9._-]/', '_', $file->getName());
			$tmpName   = uniqid($key . '_') . '_' . $origName;
			$destPath  = $tempDir . $tmpName;
			if ($file->moveTo($destPath)) {
				$attachments[] = ['path' => $destPath, 'name' => $origName];
				$tempFiles[]   = $destPath;
			}
		}
 
		// ---------------------------------------------------------------
		// Destinatários do envio de submissão de eventos.
		// Para alterar quem recebe, altere apenas esta lista.
		//
		// ATENÇÃO: lista temporária de TESTE em produção — recebe apenas
		// o Carlos. Depois de validarmos o fluxo, repor a lista final:
		//   'nuno.barradas@lebillet.eu'  => 'Nuno Barradas',
		//   'yasmin.azevedo@lebillet.eu' => 'Yasmin Azevedo',
		//   'diogo.silva@lebillet.eu'    => 'Diogo Silva',
		//   'junior@idera.com.br'        => 'Junior',
		// ---------------------------------------------------------------
		$eventSubmissionEmails = array(
			'carlosnetolima@gmail.com' => 'Carlos Lima',
		);

		// Email para a equipa (com anexos)
		$sendMail = $this->getDI()->getMail()->send(
			$eventSubmissionEmails,
			$this->config->company->full_name . ' | ' . $subject,
			'event-create',
			$param,
			null,
			null,
			$attachments
		);
 
		if ($sendMail) {
			// Confirmação para o promotor (sem anexos)
			$this->getDI()->getMail()->send(
				array($email => $email),
				$this->config->company->full_name . ' | Recebemos a sua submissão',
				'event-create-send',
				$param
			);
			// Remove ficheiros temporários
			foreach ($tempFiles as $tmp) {
				if (file_exists($tmp)) @unlink($tmp);
			}
			$this->response->setContent(json_encode(array('msg' => 'Mensagem encaminhada com sucesso', 'success' => true)));
			return $this->response->send();
		} else {
			foreach ($tempFiles as $tmp) {
				if (file_exists($tmp)) @unlink($tmp);
			}
			$this->response->setContent(json_encode(array('msg' => 'Erro: ' . print_r($sendMail), 'success' => false)));
			return $this->response->send();
		}
	}
	
	function resendEmailAction()
	{

		$gRecaptchaResponse = $this->request->getPost('g-recaptcha-response');
		if ($gRecaptchaResponse == "") {
			$this->response->setContent(json_encode(array('msg' => 'Confirme que você não é um robô clicando no reCaptcha', 'success' => false)));
			return $this->response->send();
		}

		$event    = $this->request->getPost('event');
		$email = $this->request->getPost('email');
		$mobile_country = $this->request->getPost('mobile_country');
		$cell_number = $this->request->getPost('cell_number');
		$cell_number = $mobile_country . ' ' . $cell_number; 

		$param = array('event' => $event, 'email' => $email);

		$customer = Customers::findFirst('email="' . $email . '" AND cell_number = "'. $cell_number .'"');
		if ($customer) {
			$sale = Sales::findFirst(['id_event=' . $event . ' AND id_customer=' . $customer->id . ' AND status = 4', 'order' => 'id DESC']);
			if ($sale) {
				$order = $sale->Orders;
				if ($order->id_orders_status == 2 && $order->id_orders_payment_status == 3) {
					$url = $this->di->get('completeUrl') . 'cron/send_order/' . $order->id;
					$curl = curl_init();

					curl_setopt_array($curl, array(
						CURLOPT_URL => $url,
						CURLOPT_RETURNTRANSFER => true,
						CURLOPT_ENCODING => '',
						CURLOPT_MAXREDIRS => 10,
						CURLOPT_TIMEOUT => 0,
						CURLOPT_FOLLOWLOCATION => true,
						CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
						CURLOPT_CUSTOMREQUEST => 'GET'
					));

					$return = json_decode(curl_exec($curl), true, 512, JSON_BIGINT_AS_STRING);
					curl_close($curl);

					if ($return['success']) {
						$this->response->setContent(json_encode(array('msg' => 'Bilhete encaminhado com sucesso', 'success' => true)));
						return $this->response->send();
					} else {
						$this->response->setContent(json_encode(array('msg' => 'Ocorreu um problema ao enviar o bilhete, favor tentar novamente', 'success' => false)));
						return $this->response->send();
					}
				} else {
					$this->response->setContent(json_encode(array('msg' => 'Você não possui compra para este evento', 'success' => false)));
					return $this->response->send();
				}
			} else {
				$this->response->setContent(json_encode(array('msg' => 'Você não possui compra para este evento', 'success' => false)));
				return $this->response->send();
			}
		} else {
			$this->response->setContent(json_encode(array('msg' => 'Email ou telefone não encontrado em nosso sistema', 'success' => false)));
			return $this->response->send();
		}
	}

	function getEventsResendAction($email)
	{
		if (isset($email)) {
			$customer = Customers::findFirst('email like"%' . $email . '%"');
			if ($customer) {
				$now = date('Y-m-d H:i:s');  // 2018-09-01 21:00:00


				// Neste, ignora os eventos em destaques, pois já aparecem em cima
				// $events = Events::find(array(' display_in_cover = "1" AND featured_premium = 0 AND featured = 0  AND date_start > NOW() ', 'order' => 'date_start ASC'));
				//     $events = Events::find(array(' display_in_cover = "1"  AND date_start > "' . $now . '" ', 'order' => 'date_start ASC'));
				//    $this->view->events = $events;

				$sql = "
				SELECT DISTINCT
					t.id,
					t.name
				FROM
					events t
					INNER JOIN sales_items AS si ON t.id = si.id_event
					INNER JOIN orders AS o ON si.id_order = o.id
				WHERE ( t.date_sales_end > '" . $now . "'
					AND t.display_in_cover = '1'
					OR t.id = 1 ) 
					AND o.id_customer = '" . $customer->id . "'
					AND o.id_orders_status = '2'
					AND o.id_orders_payment_status = '3'
				ORDER BY name ASC";
				$events = $this->db->fetchAll($sql);

				$this->response->setContent(json_encode(array('msg' => $events, 'success' => true)));
				return $this->response->send();
			} else {
				$this->response->setContent(json_encode(array('msg' => 'Email não localizado', 'success' => false)));
				return $this->response->send();
			}
		} else {
			$this->response->setContent(json_encode(array('msg' => 'Email não informado', 'success' => false)));
			return $this->response->send();
		}
	}
}

<?php

use Phalcon\Mvc\Controller;

class ControllerBase extends Controller
{
	private $customer = null;
	private $cart = null;
	public $IS_API = false;
	public $language;
	public $flag;

	public function onConstruct()
	{



		// Maldito robozinho
		if ($this->request->getUserAgent() == "python-requests/2.18.4") {
			$this->log();
			exit;
			die();
		}


		$language = $this->session->get("language");
		$this->language = $language;
		$this->view->language = $language;
		$this->view->recaptcha = "6LdaXS8hAAAAAGBeS8IKALufNPJdfilxDgs1t_m2";
		
		if(isset($_GET['flag'])){
			$this->session->set("flag", $_GET['flag']);
		}
	
		$flag = $this->session->get("flag") != NULL ? $this->session->get("flag") : 'POR';
		$this->flag = $flag;
		$this->view->flag = $flag;


		// Verificar se já tem um usuário logado
		// Para add o ID dele no CART
		$customer = $this->session->get('customer');
		if ($customer) {
			$this->customer = $customer;
		}
		$this->view->customer = $this->customer;

		$cart = $this->session->get('cart');
		if ($cart) {
			$this->cart = $cart;
		}
		$this->view->cart = $this->cart;



                // Rastreamento de anuncios: guarda fbclid/gclid em cookie de .lebillet.eu
                // para o dado sobreviver ate a pagina do evento e ate o checkout.
                // So grava cookie - nao faz consulta no banco.
                // O class_exists evita erro fatal caso a lib ainda nao esteja no servidor                                                                                                            
                if ( class_exists('AdsTrackingLib') ) {
                        $ads = new AdsTrackingLib();
                        $ads->captureFromUrl();
                }



		// Se passar o parametro REF veio de uma indicação
		// Salva na sessao pra depois add ao carrinho de compras
		if (isset($_REQUEST['ref']) and strlen($_REQUEST['ref']) > 0) {
			$this->session->set('ref', $_REQUEST['ref']);
		}


                if ($this->session->get('ref')) {
		    $url = $_SERVER['SERVER_NAME'] . $_SERVER['REQUEST_URI']; 
		    $urlref = $this->request->getHTTPReferer(); 
		    $ip = $this->request->getClientAddress();
		    $ref = $this->session->get('ref');
		    
		    // Verifica se já existe registro com essa combinação
		    $sql_check = "SELECT id FROM rp_register 
		                  WHERE ip = '" . $ip . "' 
		                  AND ref = '" . $ref . "' 
		                  AND url_destino = '" . $url . "'
				  AND tipo = 'REF'";
		    $existe = $this->db->fetchOne($sql_check);
		    
		    // Se não existir, faz o insert
		    if (!$existe) {
		        $sql_insert = "INSERT INTO rp_register (data, ref, ip, url_refer, url_destino, tipo)
		                       VALUES (NOW(), '" . $ref . "', '" . $ip . "', '" . $urlref . "', '" . $url . "','REF')";
		        $this->db->execute($sql_insert);
		    }
		}





                // Se passar o parametro MKT veio de uma campanha
                if (isset($_REQUEST['mkt']) and strlen($_REQUEST['mkt']) > 0) {
                        $this->session->set('mkt', $_REQUEST['mkt']);
                }


                if ($this->session->get('mkt')) {
                    $url = $_SERVER['SERVER_NAME'] . $_SERVER['REQUEST_URI'];
                    $urlref = $this->request->getHTTPReferer();
                    $ip = $this->request->getClientAddress();
                    $mkt = $this->session->get('mkt');

                    // Verifica se já existe registro com essa combinação
                    $sql_check = "SELECT id FROM rp_register
                                  WHERE ip = '" . $ip . "'
                                  AND ref = '" . $mkt . "'
                                  AND url_destino = '" . $url . "'
				  AND tipo = 'MKT'";
                    $existe = $this->db->fetchOne($sql_check);

                    // Se não existir, faz o insert
                    if (!$existe) {
                        $sql_insert = "INSERT INTO rp_register (data, ref, ip, url_refer, url_destino, tipo)
                                       VALUES (NOW(), '" . $mkt . "', '" . $ip . "', '" . $urlref . "', '" . $url . "', 'MKT')";
                        $this->db->execute($sql_insert);
                    }
                }









		if (isset($_SERVER['HTTP_API'])) {
			$this->IS_API = true;
			$this->view->disable();
			$this->response->setContentType('application/json', 'UTF-8');
		}



		// Grava o log das páginas visitadas por todos usuarios
		$this->log();


		$now = date('Y-m-d H:i:s');  // 2018-09-01 21:00:00


		// Neste, ignora os eventos em destaques, pois já aparecem em cima
		// $events = Events::find(array(' display_in_cover = "1" AND featured_premium = 0 AND featured = 0  AND date_start > NOW() ', 'order' => 'date_start ASC'));
		//     $events = Events::find(array(' display_in_cover = "1"  AND date_start > "' . $now . '" ', 'order' => 'date_start ASC'));
		//    $this->view->events = $events;

		$sql = "
			
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
				OR t.id = 1
			ORDER BY name ASC
		";
		$events = $this->db->fetchAll($sql);
		$this->view->eventList = $events;

		$primaries = CategoryPrimary::find(['disabled=1', 'order' => 'sequence ASC']);
		$newPrimaries = [];
		foreach ($primaries as $p) {
			$p->sub = [];
			$sql = "
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
				AND t.categories LIKE '%" . $p->id . "%'
			ORDER BY date_start ASC
		";

			$events = $this->db->fetchAll($sql);
			$p->sub = $events;
			array_push($newPrimaries, $p);
		}

		$this->view->primaries = $newPrimaries;
	}



	// Para ser usado em auditoria, casos de investigação, identificar coincidencias de fraude, suspeitos, ataques...
	private function log()
	{
		$url = $_SERVER['SERVER_NAME'] . $_SERVER['REQUEST_URI']; //$this->request->getHTTPReferer(); // $this->router->getRewriteUri();
		$ip = $this->request->getClientAddress();
		$session = session_id();
		$agent = $this->request->getUserAgent();
		$request = json_encode($_REQUEST);




		$sql = "
				INSERT INTO _log_site_pages_views
				(
					url,
					ip,
					session,
					agent,
					request
				)
				VALUES
					(
						?,
						?,
						?,
						?,
						?
					)
				";
		$this->db->execute($sql, array($url, $ip, $session, $agent, $request));
	}
}

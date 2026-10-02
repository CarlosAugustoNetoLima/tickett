<?php

use Phalcon\Mvc\Controller;

/**
 * Visitas do site novo (Next.js), que não passa pelo ControllerBase. Faz o mesmo que ele:
 *  - grava em _log_site_pages_views (ControllerBase::log());
 *  - grava em rp_register o ref/mkt ativo (tipo REF / MKT), sem repetir ip + código + url.
 *
 * Chamado pelo servidor Next em POST https://www.tickett.com/visit/log.
 *
 * Não estende o ControllerBase: senão a própria chamada do servidor Next também era gravada
 * como visita (e com o ref no request).
 */
class VisitController extends Controller
{

	public function logAction()
	{
		$this->view->disable();

		if ( !$this->request->isPost() ) {
			$this->response->setStatusCode(405, 'Method Not Allowed');
			return $this->response;
		}

		$url     = (string) $this->request->getPost('url');
		$ip      = (string) $this->request->getPost('ip');
		$session = (string) $this->request->getPost('session');
		$agent   = (string) $this->request->getPost('agent');
		$request = (string) $this->request->getPost('request');
		$urlref  = (string) $this->request->getPost('url_refer');
		$ref     = trim((string) $this->request->getPost('ref'));
		$mkt     = trim((string) $this->request->getPost('mkt'));

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

		$codigos = array('REF' => $ref, 'MKT' => $mkt);
		foreach ($codigos as $tipo => $codigo) {
			if ($codigo !== '') {
				$this->registrarCodigo($tipo, $codigo, $ip, $urlref, $url);
			}
		}

		$this->response->setStatusCode(204, 'No Content');
		return $this->response;
	}


	// Mesma regra do ControllerBase: só insere se ainda não existe ip + código + url + tipo.
	// O código é gravado exatamente como veio no link (sem mudar maiúsculas/minúsculas).
	private function registrarCodigo($tipo, $codigo, $ip, $urlref, $url)
	{
		// Páginas de evento do site novo: /pt-PT/event/2062/slug -> id_event = 2062.
		// Fora da página de evento fica 0, como já ficava.
		$idEvent = 0;
		if ( preg_match('#/event/(\d+)#i', $url, $m) ) {
			$idEvent = (int) $m[1];
		}

		$check = $this->db->query(
			"SELECT id FROM rp_register
			 WHERE ip = ?
			   AND ref = ?
			   AND url_destino = ?
			   AND tipo = ?
			 LIMIT 1",
			array($ip, $codigo, $url, $tipo)
		);
		if ($check && $check->fetch()) {
			return;
		}

		$this->db->execute(
			"INSERT INTO rp_register (data, ref, ip, url_refer, url_destino, tipo, id_event)
			 VALUES (NOW(), ?, ?, ?, ?, ?, ?)",
			array($codigo, $ip, $urlref, $url, $tipo, $idEvent)
		);
	}

}

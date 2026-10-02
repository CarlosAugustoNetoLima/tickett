<?php

use Phalcon\Mvc\User\Component;


class ZipCodeClass extends Component
{




	/**
	* Tras os dados do endereço com base no CEP/ZIP
	*/
	public function getAddress($zip)
	{
		$sql = "
			SELECT
			    z.city city_name,
			    z.region region_acronym,
			    r.name region_name,
			    r.id region_id,
			    z.country country_acronym,
			    c.name country_name,
			    c.id country_id
			FROM
			    zipcode z
			    LEFT JOIN regions r
			        ON r.id = z.id_region
			    LEFT JOIN countries c
			        ON c.id = r.id_country
			WHERE z.zip = '{$zip}'
		";
		$address = $this->db->fetchAll($sql);
		return $address;
	}




}
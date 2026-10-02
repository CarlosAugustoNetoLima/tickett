<?php

use Phalcon\Mvc\User\Component;


class Formatdates extends Component
{
	protected $t;
	protected $language;


	public function __construct($t, $language)
	{
    	$this->t = $t;
    	$this->language = $language;
	}

	public function format($date = '2018-01-01 00:00:00', $format = '01/01/2000')
	{
		$strtotime = strtotime($date);
		list($d, $D, $l, $F, $m, $M, $Y, $y, $A, $h, $H, $i, $s) = explode(' ', date('d D l F m M Y y A h H i s', $strtotime));

		$language = $this->language;

		$return = $date;



		if ( $format == '25/01/2000' )
		{
			if ( $language == 'pt_br' OR $language == 'pt_pt' ) {
				$return = "$d/$m/$Y";
			} else {
				$return = "$m/$d/$Y";
			}



		} elseif ( $format == '01_de_Jan_-_Domingo_12h') // 05 de Out - Sábado 21h
		{
			if ( $language == 'pt_br' OR $language == 'pt_pt' ) {
				$return = "$d de " . $this->t->_($F) . " - " . $this->t->_($l) . " $H" . "h";
			} else {
				$return = $this->t->_($F) . ", $d - " . $this->t->_($l) . " $h" . "$A";
			}



		} elseif ( $format == '01_de_Jan_-_Domingo_12:00h') // 05 de Out - Sábado 21:00h
		{
			if ( $language == 'pt_br' OR $language == 'pt_pt' ) {
				$return = "$d de " . $this->t->_($F) . " - " . $this->t->_($l) . " $H:$i" . "h";
			} else {
				$return = $this->t->_($F) . ", $d - " . $this->t->_($l) . " $h:$i" . "$A";
			}



		} elseif ( $format == '25/Jan/2000') // 25/Dez/2019
		{
			if ( $language == 'pt_br' OR $language == 'pt_pt' ) {
				$return = "$d/" . $this->t->_($M) . "/$Y";
			} else {
				$return = $this->t->_($M) . ", $d, $Y";
			}



		} elseif ( $format == '17:00h') //  05:00 PM
		{
			if ( $language == 'pt_br' OR $language == 'pt_pt' ) {
				$return = "$H:$i" . 'h';
			} else {
				$return = "$h:$i $A";
			}



		} elseif ( $format == '25/01/2000 17:00h') // 09/18/2019 9:44:20 PM
		{
			if ( $language == 'pt_br' OR $language == 'pt_pt' ) {
				$return = "$d/$m/$Y $H:$i" . 'h';
			} else {
				$return = "$m/$d/$Y $h:$i $A";
			}


		} elseif ( $format == 'Dom_01_de_Janeiro_de_2000') // Dom, 05 de Outubro de 2000
		{
			if ( $language == 'pt_br' OR $language == 'pt_pt' ) {
				if(preg_match('/bado/i', $this->t->_($l))) { $tm = 4; }else{ $tm = 3;}
				$return = substr($this->t->_($l), 0, $tm) . ", $d de " . $this->t->_($F) . " de " . $Y;
			} else {
				if(preg_match('/bado/i', $this->t->_($l))) { $tm = 4; }else{ $tm = 3;}
				$return = substr($this->t->_($l), 0, $tm) . ", $d " . $this->t->_($F) . " $Y";
			}
		}




		//	$return =  $this->t->_(date('M', $strtotime));

		return $return;

	}




}
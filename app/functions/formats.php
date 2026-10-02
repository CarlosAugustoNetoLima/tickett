<?php


	/**
	Só pra exibir bonitinho
	*/
	function formatTicket($ticket)
	{
		if ( strlen($ticket) == 10 )
			$ticket = preg_filter('/^(\d{2})(\d{3})(\d{2})(\d{3})$/', '$1.$2 $3-$4', $ticket);  // 72.098 17-453

		return $ticket;
	}








	/*
	*valor, simbolo, COMPANY, espaço
	*/
	function formatMoney($value = 99999.99, $symbol = true, $company = 'lebillet', $space = false)
	{
		if ( $company == 'lebillet' )
		{
			$value = number_format($value, 2, ',', '.');
			$current_money = 'BRA'; // depois pode se pensar em cotação de moedas
			$symbol_money = 'R$';
		} else if ($company == 'lebillet_pt'){
			$value = number_format($value, 2, '.', ',');
			$current_money = 'EUR';
			$symbol_money = '€';
		} else {
			$value = number_format($value, 2, '.', ',');
			$current_money = 'USD';
			$symbol_money = '$';
		}

		if ( $space ) {
			$space = ' ';
		}

		if ( $symbol )
			return $symbol_money . $space . $value; // $ 3,784.16
		else
			return $value;
	}








	function returnMonth($month = null, $format = 'us')
	{
		$formated = '';
		if ( $month) {
			if ( $format == 'br' ) {
				switch ($month) {
					case '01':
						$formated = 'Jan';
						break;
					case '02':
						$formated = 'Fev';
						break;
					case '03':
						$formated = 'Mar';
						break;
					case '04':
						$formated = 'Abr';
						break;
					case '05':
						$formated = 'Mai';
						break;
					case '06':
						$formated = 'Jun';
						break;
					case '07':
						$formated = 'Jul';
						break;
					case '08':
						$formated = 'Ago';
						break;
					case '09':
						$formated = 'Set';
						break;
					case '10':
						$formated = 'Out';
						break;
					case '11':
						$formated = 'Nov';
						break;
					case '12':
						$formated = 'Dez';
						break;
				}
			} else {
				switch ($month) {
					case '01':
						$formated = 'Jan';
						break;
					case '02':
						$formated = 'Fev';
						break;
					case '03':
						$formated = 'Mar';
						break;
					case '04':
						$formated = 'Apr';
						break;
					case '05':
						$formated = 'May';
						break;
					case '06':
						$formated = 'Jun';
						break;
					case '07':
						$formated = 'Jul';
						break;
					case '08':
						$formated = 'Aug';
						break;
					case '09':
						$formated = 'Sep';
						break;
					case '10':
						$formated = 'Oct';
						break;
					case '11':
						$formated = 'Nov';
						break;
					case '12':
						$formated = 'Dec';
						break;
				}
			}
		}
		return $formated;

	}

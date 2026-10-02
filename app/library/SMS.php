<?php
/**
* Biblioteca do budgetsms
* https://www.budgetsms.net/sms-http-api/send-sms/
* Gateway de SMS
*/
/*


*/

class SMS {


	private $url;
	private $username;
	private $userid;
	private $handle;



    public function __construct($ambiente = 'producao')
    {


    	if ( $ambiente == 'producao' )
    	{
	        $this->url = 'https://api.budgetsms.net/sendsms/';
	        $this->username = 'Lebillet';
	        $this->userid = '21776';
	        $this->handle = 'bbe3bf979262de1e1d40c72879bd3dd6';

    	} else {
	        $this->url = 'https://api.budgetsms.net/testsms/';
	        $this->username = 'Lebillet';
	        $this->userid = '21776';
	        $this->handle = 'bbe3bf979262de1e1d40c72879bd3dd6';
    	}
    }




	public function send( $to = null, $message = null )
	{

        $curl = curl_init();

        $params = array(
        	'username' => $this->username,
        	'userid' => $this->userid,
        	'handle' => $this->handle,
        	'msg' => $message,
        	'to' => $to,
        	'from' => 'LeBillet',
        	'price' => '1',
        	'mccmnc' => '1',
        	'credit' => '1',
        );

    	curl_setopt($curl, CURLOPT_URL, $this->url . '?' . http_build_query($params) );
		curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "GET");
		curl_setopt($curl, CURLOPT_HTTPGET, true);

		curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($curl, CURLOPT_MAXREDIRS, 10);
		curl_setopt($curl, CURLOPT_TIMEOUT, 30);
		curl_setopt($curl, CURLOPT_FOLLOWLOCATION, true);
		curl_setopt($curl, CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_1_1);

        //for debug only!
        curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, false);
        curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);


		curl_setopt($curl, CURLINFO_HEADER_OUT, true);




		$return_cur = curl_exec($curl);
		$explode_return = explode(' ', $return_cur);
		$return['status'] = isset($explode_return[0]) ? $explode_return[0] : null;
		$return['transaction'] = isset($explode_return[1]) ? $explode_return[1] : null;
		$return['price'] = isset($explode_return[2]) ? $explode_return[2] : null;
		$return['time'] = isset($explode_return[3]) ? $explode_return[3] : null;
		$return['mccmnc'] = isset($explode_return[4]) ? $explode_return[4] : null;
		$return['credit'] = isset($explode_return[5]) ? $explode_return[5] : null;
		$response['curl'] = $return;


		// Verifica se houve erros e exibe a mensagem de erro
		if($errno = curl_errno($curl)) {
			$error_message = curl_strerror($errno);
			$info['curl_errno'] =  "cURL error ({$errno}):\n {$error_message}";
		}


		$info['curl_error'] =  curl_error($curl);
		$info['info'] =  curl_getinfo($curl);
		//$info['header'] = curl_getinfo($curl, CURLINFO_HEADER_OUT);
		//$info['url'] = $url;
		$response['info'] = $info;


		curl_close($curl);

		return $response;


	}
}

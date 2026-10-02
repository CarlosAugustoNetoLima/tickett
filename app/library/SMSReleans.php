<?php
/**
* Biblioteca do releans SMS
* https://docs.releans.com/sms-api#single-message
* https://docs.releans.com/#send-sms-in-php
* API KEY 261e2389643d6f55048611ad458b0e5c
*/
/*


*/

class SMSReleans {


	private $url;
	private $from;
	private $api_key;



    public function __construct($ambiente = 'producao')
    {


    	if ( $ambiente == 'producao' )
    	{
	        $this->url = 'https://api.releans.com/v2/message';
	        $this->from = 'LeBillet';
	        $this->api_key = '261e2389643d6f55048611ad458b0e5c';

    	} else {
	        $this->url = 'https://api.releans.com/v2/message';
	        $this->from = 'LeBillet';
	        $this->api_key = '261e2389643d6f55048611ad458b0e5c';
    	}
    }




	public function send( $to = null, $message = null )
	{

        $curl = curl_init();

        $params = array(
        	'sender' => $this->from,
        	'mobile' => $to ,
        	'content' => $message ,
        );

        $params = http_build_query($params);


		$headers = array();
		$headers[] = 'Authorization: Bearer ' . $this->api_key;


    	curl_setopt($curl, CURLOPT_URL, $this->url);
		curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "POST");

		curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($curl, CURLOPT_MAXREDIRS, 10);
		curl_setopt($curl, CURLOPT_TIMEOUT, 30);
		curl_setopt($curl, CURLOPT_FOLLOWLOCATION, true);
		curl_setopt($curl, CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_1_1);

        //for debug only!
        curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, false);
        curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);


		curl_setopt($curl, CURLINFO_HEADER_OUT, true);


		curl_setopt($curl, CURLOPT_HTTPHEADER, $headers);
		curl_setopt($curl, CURLOPT_POSTFIELDS, $params);
		curl_setopt($curl, CURLOPT_POST, true);


		$return_cur = curl_exec($curl);
		$response['response'] = $return_cur;


		// Verifica se houve erros e exibe a mensagem de erro
		if($errno = curl_errno($curl)) {
			$error_message = curl_strerror($errno);
			$info['curl_errno'] =  "cURL error ({$errno}):\n {$error_message}";
		}


		$info['curl_error'] =  curl_error($curl);
		$info['info'] =  curl_getinfo($curl);
		//$info['header'] = curl_getinfo($curl, CURLINFO_HEADER_OUT);
		//$info['url'] = $url;
		$info['post'] = $params;
		$response['info'] = $info;


		curl_close($curl);

		return $response;


	}
}

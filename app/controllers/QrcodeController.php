<?php
class QrcodeController extends ControllerBase
{


// http://phpqrcode.sourceforge.net/index.php#demo
// http://phpqrcode.sourceforge.net/examples/index.php

	public function indexAction($value = null, $size = 6)
	{
	   	$this->view->disable();
	    	if ( $value ) {
	    		return file_get_contents("//chart.googleapis.com/chart?chs=150x150&cht=qr&chl=Hello%20world&choe=UTF-8");
	    	} else {
	    		return false;
	    	}
	}

}
<?php

$_SERVER['HTTP_HOST'] = isset($_SERVER['HTTP_HOST']) ? $_SERVER['HTTP_HOST'] : null;
$dev = (strpos($_SERVER['HTTP_HOST'], 'localhost') === 0) ? true : false;
$sales = ($_SERVER['HTTP_HOST'] == 'sales.tiktx.com' ) ? true : false;
$events = ($_SERVER['HTTP_HOST'] == 'events.tiktx.com' ) ? true : false;
if ( $dev )
{
	$baseUri = '/';
	$baseUriFiles = '//localhost/tickets/files/';
	$baseUriSup = '//localhost/tickets/sup/';
	$baseUriSales = '//localhost/tickets/site/sales/';
	$baseUriEvents = '//localhost/tickets/site/events/';
	$baseUriCheckout = '//localhost/tickets/checkout/';
	$baseUriFastCheckout = '//localhost/tickets/checkout/';
	$completeUrl = 'http://localhost/tickets/site/';
	$wkhtmltopdf = '"C:\Program Files\wkhtmltopdf\bin\wkhtmltopdf.exe"';
	$wkhtmltoimage = '"C:\Program Files\wkhtmltopdf\bin\wkhtmltoimage.exe"';
	$pathSite = 'C:/wamp/www/tickets/site/';
}else
{
	$baseUri = 'https://tiktx.com/';
    $baseUriFiles = 'https://files.tiktx.com/';
	$baseUriSup = 'https://sup.tiktx.com/';
	$baseUriSales = 'https://sales.tiktx.com/';
	$baseUriEvents = 'https://events.tiktx.com/';
	$baseUriCheckout = 'https://checkout.tiktx.com/';
	$baseUriFastCheckout = 'https://checkout.tiktx.com/';
	$completeUrl = $baseUri;
	$wkhtmltopdf = 'wkhtmltopdf';
	$wkhtmltoimage = 'wkhtmltoimage';
	$pathSite = '/www/site/';
}
if ( $sales )
{
	$baseUri = $baseUriSales;
} elseif ( $events )
{
	//$baseUri = $baseUriEvents;
}

$config2 = array(

	'application' => [

		// This allows the baseUri to be understand project paths that are not in the root directory
		// of the webpspace.  This will break if the public/index.php entry point is moved or
		// possibly if the web server rewrite rules are changed. This can also be set to a static path.
		'baseUri'            => $baseUri,
		'baseUriFiles'            => $baseUriFiles,
		'baseUriSup'         => $baseUriSup,
		'baseUriSales'       => $baseUriSales,
		'baseUriCheckout'    => $baseUriCheckout,
		'baseUriFastCheckout'=> $baseUriFastCheckout,
		'completeUrl'        => $completeUrl,
		'pathSite' 	 	 	=> $pathSite,
		'wkhtmltopdf'        => $wkhtmltopdf,
		'wkhtmltoimage'        => $wkhtmltoimage,
		'default_language'   => 'en_us',
		'date_default_timezone_set' => 'America/New_York',
	],


	'date_formats' => [
		'mdga' => '%b, %d - %I%p ',  /*  Dec, 25 - 05PM  */
		'MdY' => '%b, %d, %Y ',  /*  DEC, 25, 2019  */
		'hia' => '%I:%M%p ',  /*  05:00PM  */
	],




	'company' => [
		'name' => 'Tiktx',
		'full_name' => 'tiktx.com',
		'logos' => 'logos/tiktx/',
		'email' => 'contact@tiktx.com',
		'email_pre' => 'contact',
		'email_domain' => 'tiktx.com',
		'phone' => null,
		'title' => 'tiktx.com | Buy your ticket',
		'description' => 'Event tickets on sale now! Safe, Secure and Easy Ordering',
		'keywords' => 'events, tickets, shows, sales, new york, boston, orlando, Pompano Beach, brazil, brasil, brasileiro, pagode, international',

		'analytics' => 'G-737KZZSE4N',

		'msg_email_order_confirmation' => 'tiktx.com | Purchase confirmation',
		'msg_email_order_biometrics' => 'tiktx.com | It remains to activate your purchase',
		// 'template_email_order_confirmation' => 'order-confirmation-tiktx',
		'template_email_order_confirmation' => 'order-confirmation-slim-tiktx',

		'social' => [
			'facebook' => "https://www.facebook.com/tiktx",
			'twitter' => "https://twitter.com/TiktxCompany",
			'instagram' => "https://www.instagram.com/TiktX",
		],




		'about_title' => "The Tiktx Company",
		'about' => "
				<p>
					Tiktx is a tickets sales management company. Accumulating experiences in the sales of tickets business since 2010 in Brazil, we came to the US to provide maximum comfort and quality for event promoters and customers, as we are creating and developing every day new ways to exceed all expectations.
				</p>
				<p>
					In addition to our 100% online integrated event management system, ticket sales are carried out through our website and through POS machines which, in addition to ticketing, are suitable for debit and credit card transactions.
				</p>
				<p>
					With a qualified team, we are delivering a different experience to the US territories, and more than an excellent delivery, the TiktX Co. team is pleased to be part and your very own production company.
				</p>
				<p>
					The Tiktx Company <br>
					3801 NE 207 TH ST <br>
					Miami FL 33180
				</p>
				<p>
					Best regards from Tiktx Co.
				</p>
			",



		'policies' => '
			<ul class="styled_list">
				<li>
					<p>
						The ticket is valid only for the event, date, time, place and seat to which it was issued. Please check the data carefully at the time of purchase. You must reach the event at least 30 minutes in advance.
					</p>
				</li>
				<li>
					<p>
						Keep your ticket in a safe place, away from the heat, avoiding folds and contact with other materials that could damage it.
					</p>
				</li>
				<li>
					<p>
						By determination of the organization of the event, the doors should be closed at the time informed on the ticket. There will be no refund for ticket holders arriving after doors are closed.
					</p>
				</li>
				<li>
					<p>
						There will be no ticket exchange, no refund of money in case of delay or purchase on the eve of the show.
					</p>
				</li>
				<li>
					<p>
						In case of regret, we inform you that it is not possible to request cancellation or exchange of tickets.
					</p>
				</li>
				<li>
					<p>
						If there is any exception, any change in the event date or any other event outside the normality in which it is necessary to make a refund, it may take up to 45 days to be processed.
					</p>
				</li>
				<li>
					<p>
						There will be no ticket exchange, no refund of money in case of delay or purchase on the eve of the show.
					</p>
				</li>
				<li>
					<p>
						It is not possible to request cancellation and refund after the date of the event.
					</p>
				</li>
				<li>
					<p>
						Tiktx is not responsible for tickets purchased outside our points of sale.
					</p>
				</li>
				<li>
					<p>
						Always check the page of the event on our website to update any changes that may occur in the event, and always keep your email address updated on our website to receive the latest updates on the event, such as location changes, date and cancellations. Tiktx is exempt from any responsibility in case the customer`s message box is full or refusing to receive new e-mails, being this one of personal or professional use.
					</p>
				</li>
				<li>
					<p>
						The ticket has security items and will be subjected to verification at the event`s concierge. The bar code/QR code contained in the ticket is unique and does not repeat, guaranteeing only one-time access to the event.
					</p>
				</li>
				<li>
					<p>
						The production of the event reserves the right to ask the public for an official photo identification to access the event.
					</p>
				</li>
				<li>
					<p>
						This event can be recorded, filmed or photographed. By participating in the event, the holder of this ticket agrees and authorizes the free use of his image for an indeterminate period.
					</p>
				</li>
				<li>
					<p>
						Tiktx has nothing to do with the organization of the event. Issues such as values, promotions, changes of date, restitution of values in cases provided by law and any other demand related to the event are the sole responsibility of its producers and organizers.
					</p>
				</li>
			</ul>
		',



		'ticket_instructions' => '
				<h4 class="text-center" style="text-align: center;">INSTRUCTIONS FOR THE USE THE DIGITAL ENTRY</h4>

				<ul class="instructions">
					<li>
						The digital ticket security system generates a unique code for only one access, copies are prohibited. Once validated it can not be reused. Tiktx.com and the organization of the event are not responsible for tickets purchased outside the authorized network.
						** IT IS NOT NECESSARY TO PRINT YOUR TICKET. JUST SHOW THE QR CODE ON THE CELL PHONE *
						*** NO RETURNS FROM TICKETS AND CAN NOT BE TRANSFERRED ***
					</li>
					<li>
						Resale of this digital ticket is prohibited, tickets purchased from third parties may be fraudulent. Tiktx.com reserves the right to request the photocopy and credit card of the holder used in the purchase by the site to access the event.
					</li>
					<li>
						If an event is canceled, and you purchased your ticket through Tiktx.com, we will automatically issue you a refund to the credit card, debit card that you used to purchase that ticket. If a ticket was purchased through a Tiktx.com retail location, please contact us for a refund.
						If the event was moved or rescheduled, the Event Provider may set refund limitations. Please contact us for more information or to request a refund IF APPLICABLE!
					</li>
				</ul>
			',


			'privacy' => '

				<h3>PRIVACY POLICY</h3>

				<p>
					When registering in our website or purchasing tickets for events available in Tiktx sales channels, users’ personal data will be stored on our servers.
					Information we collect: name, surname, e-mail, address, telephone numbers, date of birth.
				</p>
				<p>
					Other data can be necessary to ensure veracity of the transactions.
					Payment and fulfillment data required for transaction processing, such as credit card number, are not stored on our servers.
					In additional to the users’ data, we also store the receipt of information when the user contacts us or responds any survey. This information will be included in each user`s registration.
				</p>
				<p>
					All information collected is stored on servers, which observe strict security, inviolability and reliability standards, in order to guarantee the users privacy, privacy, honor and image.
				</p>
				<p>
					Personal data will be made available only to authorized employees who undertake to comply with this privacy policy and are not publicly shared or used for purposes other than those originally proposed.
				</p>
				<p>
					Except for the express, free and informed consent of the user, Tiktx will not provide to third parties personal information, registration of connection and access to internet applications.
				</p>
				<p>
					Users assume responsibility for the information they are providing to Tiktx as well as the consequences of their decisions.
				</p>
				<p>
					The user will receive an email sent by Tiktx to confirm the registration and activate the account.
				</p>
				<p>
					By registering and confirming by e-mail, the user expressly consents to the collect, use, storage and processing of personal data by Tiktx.
				</p>
				<p>
					When you buy at the Tiktx website for the first time, the purchase can be submitted to our information security department, which can contact the user and request details of the information.
				</p>
				<p>
					After the purchase, the user will receive an email at the address indicated, thus, it is very important to keep the user data up to date on our system.
				</p>
				<p>
					Upon user request, Tiktx will proceed to the definitive exclusion of personal data.
				</p>


				<h3>COOKIES</h3>


				<p>
					Cookies are small files that a site or its service provider transfers to your computers hard drive through your Web browser. (if you have allowed it via your settings. This enables the sites or service providers systems to recognize your browser and capture and remember certain information)
				</p>
				<p>
					We use cookies to help us remember and process the items in your shopping cart, understand and save your preferences for future visits and compile aggregate data about site traffic and site interaction so that we can offer better site experiences and tools for you in the future. We may contract with third-party service providers to assist us in better understanding our site visitors. These service providers are not permitted to use the information collected on our behalf except to help us directly conduct and improve our business.
				</p>
				<p>
					If you prefer, you can choose to have your computer warn you each time a cookie is being sent, or you can choose to turn off all cookies via your browser settings. Like most websites, if you turn your cookies off, some of our services may not function properly.
				</p>


				<h3>ANTI-SPAM</h3>


				<p>
					All e-mails sent by Tiktx counts on the consent of the costumer, since he himself chooses to receive through an enrollment or implicitly when a contact between the parties is established, without using intrusive means.
				</p>
				<p>
					Every e-mail sent by Tiktx has the link option to unsubscribe from the e-mail to receive future messages, thereby fully respecting the privacy and freedom of those who receive the message.
				</p>



				<h3>CHANGES IN PRIVACY POLICY</h3>

				<p>
					If we decide to change our privacy policy, we will post those changes on this page, and/or update the Privacy Policy modification date below.
				</p>
				<p>
					Your continued use of the website and applications after any changes to this Privacy Policy indicates your agreement to the revised terms.
				</p>


				<h3>ACCORDING</h3>

				<p>
					By using our site, you consent to our online privacy policy.
				</p>
			',

	]


);
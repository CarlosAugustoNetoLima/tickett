<?php

$_SERVER['HTTP_HOST'] = isset($_SERVER['HTTP_HOST']) ? $_SERVER['HTTP_HOST'] : null;
$dev = (strpos($_SERVER['HTTP_HOST'], 'localhost') === 0) ? true : false;
$sales = ($_SERVER['HTTP_HOST'] == 'sales.lebillet.com.br' ) ? true : false;
$events = ($_SERVER['HTTP_HOST'] == 'eventos.lebillet.com.br' ) ? true : false;
if ( $dev )
{
	$baseUri = '/';
	$baseUriFiles = '//localhost/tickets/files/';
	$baseUriSup = '//localhost/tickets/sup/';
	$baseUriSales = '//localhost/tickets/sales/';
	$baseUriEvents = '//localhost/tickets/site/events/';
	$baseUriCheckout = '//localhost/tickets/checkout/';
	$baseUriFastCheckout = '//localhost/tickets/checkout/';
	$completeUrl = 'http://localhost/tickets/site/';
	$wkhtmltopdf = '"C:\Program Files\wkhtmltopdf\bin\wkhtmltopdf.exe"';
	$wkhtmltoimage = '"C:\Program Files\wkhtmltopdf\bin\wkhtmltoimage.exe"';
	$pathSite = 'C:/wamp/www/tickets/site/';
}else
{
	$baseUri = 'https://lebillet.com.br/';
    $baseUriFiles = 'https://files.lebillet.com.br/';
    $baseUriSup = 'https://sup.lebillet.com.br/';
	$baseUriSales = 'https://sales.lebillet.com.br/';
	$baseUriEvents = 'https://eventos.lebillet.com.br/';
	$baseUriCheckout = 'https://checkout.lebillet.com.br/';
	$baseUriFastCheckout = 'https://checkout.lebillet.com.br/';
	$completeUrl = $baseUri;
	$wkhtmltopdf = 'xvfb-run wkhtmltopdf';
	$wkhtmltoimage = 'xvfb-run wkhtmltoimage';
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
		'baseUriSup'            => $baseUriSup,
		'baseUriSales'       => $baseUriSales,
		'baseUriCheckout'    => $baseUriCheckout,
		'baseUriFastCheckout'=> $baseUriFastCheckout,
		'pathSite' 	 	 	=> $pathSite,
		'completeUrl'        => $completeUrl,
		'wkhtmltopdf'        => $wkhtmltopdf,
		'wkhtmltoimage'        => $wkhtmltoimage,
		'default_language'   => 'pt_br',
		'date_default_timezone_set' => 'America/Sao_Paulo',
'debug' => false
	],






	'company' => [
		'name' => 'LeBillet',
		'full_name' => 'lebillet.com.br',
		'logos' => 'logos/lebillet/',
		// Logo usado nos e-mails transacionais (URL absoluto).
		'email_logo' => 'https://lebillet.com.br/logos/lebillet/logo.png',
		'email' => 'atendimento@lebillet.com.br',
		'email_pre' => 'atendimento',
		'email_domain' => 'lebillet.com.br',
		'phone' => null,
		'title' => 'lebillet.com.br | Compre seu ingresso',
		'description' => 'Ingressos a venda! Rápido, Seguro e Fácil. Faça sua compra',
		'keywords' => 'eventos, ingressos, shows, brasil, apresentações, musicais, rock, sertanejo, samba, artistas, pagode',

		'analytics' => 'G-CS2RML31RQ',

		'msg_email_order_confirmation' => 'LeBillet.com.br | Confirmação de compra',
		'msg_email_order_biometrics' => 'LeBillet.com.br | Falta ativar sua compra',
		// 'template_email_order_confirmation' => 'order-confirmation-lebillet',
		'template_email_order_confirmation' => 'order-confirmation-slim-lebillet',

		'social' => [
			'facebook' => "https://www.facebook.com/lebilletbr",
			'twitter' => "https://twitter.com/lebilletbr",
			'instagram' => "https://www.instagram.com/lebilletbr",
		],




		'about_title' => "A LeBillet",
		'about' => "
			<p>
				A LeBillet é uma empresa de gerenciamento de vendas de ingressos. Acumulando experiências no negócio de vendas de ingressos desde 2010 no Brasil, presente nos EUA desde 2018, estamos no mercado para oferecer o máximo de conforto e qualidade aos promotores e clientes de eventos, pois estamos criando e desenvolvendo diariamente novas maneiras de superar todas as expectativas.
			</p>
			<p>
				Além do nosso sistema integrado de gerenciamento de eventos 100% on-line, a venda de ingressos é realizada por meio de nosso site e de PDV´s que, além de emissão de bilhetes, são adequadas para transações com cartão de crédito e débito.
			</p>
			<p>
				Com uma equipe qualificada, estamos entregando uma experiência diferente aos territórios do Brasil e dos EUA e, mais do que uma entrega excelente, a equipe da LeBillet tem o prazer de ser parceira de sua organização.
			</p>

			<p>
				LeBillet é nome fantasia da LEBILLET TECNOLOGIA E INGRESSOS LTDA, empresa sob CNPJ: 22.771.853/0001-60 <br>
				Com sede na Avenida Champagnat, 304, Sala 201 - Edifício Aprígio Freire - Vila Velha, ES - Brasil, CEP: 29.101-410 <br>
				Para entrar em contato conosco, <a href='https://lebillet.com.br/helpdesk'>clique aqui</a>.


			</p>

			<p>
				Com os melhores cumprimentos da LeBillet.
			</p>
			",


		'policies' => '
			<ul class="styled_list">
				<li>
					<p>

						O ingresso é válido apenas para o evento, data, hora, local e assento para o qual foi emitido. Por favor, verifique os dados cuidadosamente no momento da compra. Você deve chegar ao evento com pelo menos 30 minutos de antecedência.
					</p>
				</li>

				<li>
					<p>

						Mantenha seu ingresso em um local seguro, longe do calor, evitando dobras e contato com outros materiais que possam danificá-lo.
					</p>
				</li>

				<li>
					<p>

						Por determinação da organização do evento, as portas devem ser fechadas no horário informado no ingresso. Não haverá reembolso para os portadores de bilhetes que chegarem após o fechamento das portas.
					</p>
				</li>

				<li>
					<p>

						Após o início do evento, não haverá garantias sobre a disponibilidade de assentos marcados nos ingressos.
					</p>
				</li>

				<li>
					<p>
						Não haverá troca de ingressos, nenhum reembolso de dinheiro em caso de atraso ou compra na véspera do show.
					</p>
				</li>

				<li>
					<p>
						Em caso de arrependimento, o consumidor tem o direito de solicitar o cancelamento de seu pedido até 7 dias após a compra desde que esteja no prazo minimo de 48 horas antes da data do evento.
					</p>
				</li>

				<li>
					<p>

						O reembolso do valor da compra será feito, excluindo as taxas de serviço (conveniência) e entrega (se houver).
					</p>
				</li>

				<li>
					<p>

						A solicitação de reembolso de bilhetes adquiridos nos pontos de venda deve ser feita pessoalmente, no mesmo local e só pode ser feita após a devolução do bilhete.
					</p>
				</li>


				<li>
					<p>

						Não é possível solicitar cancelamento e reembolso após a data do evento.
					</p>
				</li>

				<li>
					<p>

						A LeBillet não se responsabiliza por ingressos comprados fora de nossos pontos de venda.
					</p>
				</li>

				<li>
					<p>

						Compras realizadas com cartão de crédito de terceiros podem ser submetidas para análise e canceladas caso não estejam de acordo com critérios internos de segurança.
					</p>
				</li>

				<li>
					<p>

						Sempre verifique a página do evento em nosso site para atualizar quaisquer alterações que possam ocorrer no evento e mantenha sempre seu endereço de e-mail atualizado em nosso site para receber as atualizações mais recentes sobre o evento, como alterações de local, data e cancelamentos. A LeBillet está isenta de qualquer responsabilidade caso a caixa de mensagens do cliente esteja cheia ou se recuse a receber novos e-mails, sendo de uso pessoal ou profissional.
					</p>
				</li>

				<li>
					<p>

						O ingresso possui itens de segurança e será sujeito a verificação no concierge do evento. O código de barras/código QR contido no ingresso é exclusivo e não se repete, garantindo apenas o acesso único ao evento.
					</p>
				</li>

				<li>
					<p>

						A produção do evento se reserva o direito de solicitar ao público uma identificação com foto oficial para acessar o evento.
					</p>
				</li>

				<li>
					<p>

						O evento pode ser gravado, filmado ou fotografado. Ao participar do evento, o titular deste bilhete concorda e autoriza o uso gratuito de sua imagem por um período indeterminado.
					</p>
				</li>

				<li>
					<p>

						A LeBillet não é responsável pela organização do evento. Questões como valores, promoções, alterações de data, restituição de valores nos casos previstos em lei e qualquer outra demanda relacionada ao evento são de responsabilidade exclusiva de seus produtores e organizadores.
					</p>
				</li>
				<li>
					<p>
					A LeBillet se reserva o direito de solicitar aos clientes informações e documentos adicionais para a efetivação do pedido, caso não estejam de acordo com as análises internas de segurança a compra poderá ser cancelada.
					<br>
					A solicitação será enviada pela LeBillet através de mensagem própria e o cliente terá o prazo de 24 horas de sua compra ou 48 horas antes do início do evento, qual ocorrer antes, para o envio dos dados solicitados.
					<br>
					Caso não ocorra o envio ou os dados sejam divergentes a LeBillet se reserva o direito de cancelar o pedido.
					</p>
				</li>
			</ul>

			<br>
			<hr>
			<br>

			<h3>Contatos do Procon</h3>

			<b>Procon Vitória</b><br>
			Localizado em: Casa do Cidadão de Vitória <br>
			Endereço: Av. Maruípe, 2544 - bloco a - Itararé, Vitória - ES, 29047-495 <br>
			Telefone: (27) 3382-5537

			<br><br>
			<b>Procon Estadual do Estado do Espírito Santo</b> <br>
			Endereço: Edifício Março - Av. Princesa Isabel, 599 - Centro, Vitória - ES, 29010-361 <br>
			Telefone: (27) 3381-6248
			',




		'ticket_instructions' => '
			<h4 class="text-center" style="text-align: center;">INFORMAÇÕES IMPORTANTES</h4>

			<ul class="instructions">
				<li>
					Todas as compras, para sua segurança, passam por uma análise. Portanto, podemos solicitar informações adicionais para verificar sua identidade.
				</li>
				<li>
					Sempre mantenha seu endereço de e-mail atualizado em nosso site para receber as atualizações mais recentes sobre o evento, como alterações de local, data e cancelamentos. Sempre verifique a página do evento em nosso site para atualizar as alterações que possam ocorrer no evento.
				</li>
				<li>
					Ocasionalmente, os shows são cancelados ou adiados. Caso isso ocorra, tentaremos entrar em contato com você para informá-lo sobre os procedimentos de reembolso ou troca deste evento. Para instruções exatas sobre qualquer evento cancelado ou adiado, verifique as informações do evento on-line ou entre em contato conosco.
				</li>
				<li>
					Se o evento foi cancelado ou reagendado, o Organizador do Evento pode definir limitações de reembolso. Entre em contato conosco para obter mais informações ou solicitar um reembolso, SE APLICÁVEL!
				</li>
				<li>
					O reembolso do valor da compra será feito, excluindo as taxas de serviço (conveniência) e entrega (se houver), sempre que atendidos as regras de prazos, sendo permitido até 7 dias após a compra desde que esteja no prazo minimo de 48 horas antes da data do evento
				</li>
				<li>
					** NÃO É NECESSÁRIO IMPRIMIR SEU BILHETE. APENAS APRESENTE  NO TELEFONE CELULAR **
				</li>
			</ul>
		',


		'privacy' => '
			<h3>POLÍTICA DE PRIVACIDADE</h3>

			<p>
				Ao se registrar em nosso site ou comprar ingressos para eventos disponíveis nos canais de vendas da LeBillet, os dados pessoais dos usuários serão armazenados em nossos servidores. Informações que coletamos: nome, sobrenome, e-mail, endereço, números de telefone, data de nascimento.
			</p>
			<p>
				Outros dados podem ser necessários para garantir a veracidade das transações. Os dados de pagamento e preenchimento necessários para o processamento da transação, como número do cartão de crédito, não são armazenados em nossos servidores. Além dos dados dos usuários, também armazenamos o recebimento de informações quando o usuário entra em contato conosco ou responde a qualquer pesquisa. Esta informação será incluída no registro de cada usuário.
			</p>
			<p>
				Todas as informações coletadas são armazenadas em servidores, que seguem rígidos padrões de segurança, inviolabilidade e confiabilidade, a fim de garantir aos usuários privacidade, privacidade, honra e imagem.
			</p>
			<p>
				Os dados pessoais serão disponibilizados apenas para funcionários autorizados que se comprometam a cumprir esta política de privacidade e não são compartilhados publicamente ou usados para outros fins que não os originalmente propostos.
			</p>
			<p>
				Exceto pelo consentimento expresso, livre e informado do usuário, a LeBillet não fornecerá a terceiros informações pessoais, registro de conexão e acesso a aplicativos da Internet.
			</p>
			<p>
				Os usuários assumem a responsabilidade pelas informações que estão fornecendo à LeBillet, bem como pelas consequências de suas decisões.
			</p>
			<p>
				O usuário receberá um email enviado pela LeBillet para confirmar o registro e ativar a conta.
			</p>
			<p>
				Ao registrar e confirmar por e-mail, o usuário consente expressamente na coleta, uso, armazenamento e processamento de dados pessoais pela LeBillet.
			</p>
			<p>
				Quando você compra no site da LeBillet pela primeira vez, a compra pode ser enviada ao nosso departamento de segurança da informação, que pode entrar em contato com o usuário e solicitar detalhes da informação.
			</p>
			<p>
				Após a compra, o usuário receberá um e-mail no endereço indicado, portanto, é muito importante manter os dados do usuário atualizados em nosso sistema.
			</p>
			<p>
				Mediante solicitação do usuário, a LeBillet continuará com a exclusão definitiva de dados pessoais.
			</p>


			<h3>COOKIES</h3>
			<p>
				Cookies são pequenos arquivos que um site ou seu provedor de serviços transfere para o disco rígido do seu computador através do navegador da Web. (se você tiver permitido isso através de suas configurações. Isso permite que os sites ou sistemas de provedores de serviços reconheçam seu navegador e capturem e lembrem de certas informações)
			</p>
			<p>
				Utilizamos cookies para nos ajudar a lembrar e processar os itens em seu carrinho de compras, entender e salvar suas preferências para futuras visitas e compilar dados agregados sobre o tráfego e a interação do site, para que possamos oferecer melhores experiências e ferramentas para você no futuro. Podemos contratar fornecedores de serviços terceirizados para nos ajudar a entender melhor os visitantes do site. Esses prestadores de serviços não têm permissão para usar as informações coletadas em nosso nome, exceto para nos ajudar a conduzir e melhorar diretamente nossos negócios.
			</p>
			<p>
				Se preferir, você pode optar por avisar o computador sempre que um cookie for enviado ou optar por desativar todos os cookies nas configurações do navegador. Como a maioria dos sites, se você desativar os cookies, alguns de nossos serviços podem não funcionar corretamente.
			<p>

			<h3>ANTI-SPAM</h3>
			<p>
				Todos os e-mails enviados pela LeBillet contam com o consentimento do cliente, uma vez que ele próprio escolhe receber por meio de uma inscrição ou implicitamente quando um contato entre as partes é estabelecido, sem o uso de meios intrusivos.
			</p>
			<p>
				Todo e-mail enviado pela LeBillet tem a opção de link para cancelar a inscrição no e-mail para receber futuras mensagens, respeitando assim totalmente a privacidade e a liberdade daqueles que recebem a mensagem.
			</p>

			<h3>ALTERAÇÕES NA POLÍTICA DE PRIVACIDADE</h3>
			<p>
				Se decidirmos mudar nossa política de privacidade, publicaremos essas alterações nesta página e / ou atualizaremos a data de modificação da Política de Privacidade abaixo.
			</p>
			<p>
				Seu uso continuado do site e dos aplicativos após quaisquer alterações nesta Política de Privacidade indica que você concorda com os termos revisados.
			<p>

			<h3>DE ACORDO</h3>
			<p>
				Ao usar nosso site, você concorda com nossa política de privacidade online.
			</p>
		',

	]







);

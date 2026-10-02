<?php

$_SERVER['HTTP_HOST'] = isset($_SERVER['HTTP_HOST']) ? $_SERVER['HTTP_HOST'] : null;
$dev = ($_SERVER['HTTP_HOST'] == 'localhost' ) ? true : false;
$sales = ($_SERVER['HTTP_HOST'] == 'sales.lebillet.my' ) ? true : false;
$events = ($_SERVER['HTTP_HOST'] == 'eventos.lebillet.my' ) ? true : false;
if ( $dev )
{
	$baseUri = preg_replace('/public([\/\\\\])index.php$/', '', $_SERVER["PHP_SELF"]);
	$baseUriFiles = '//localhost/br/br_files/';
	$baseUriSup = '//localhost/br/br_sup/';
	$baseUriSales = '//localhost/br/br_sales/';
	$baseUriEvents = '//localhost/br/br_site/events/';
	$baseUriCheckout = '//localhost/br/br_checkout/';
	$baseUriFastCheckout = '//localhost/br/br_checkout/';
	$completeUrl = 'http://localhost/br/br_site/';
	$wkhtmltopdf = '"C:\Program Files\wkhtmltopdf\bin\wkhtmltopdf.exe"';
	$wkhtmltoimage = '"C:\Program Files\wkhtmltopdf\bin\wkhtmltoimage.exe"';
	$pathSite = 'C:/wamp/www/tickets/site/';
}else
{
	$baseUri = 'https://lebillet.my/';
    $baseUriFiles = 'https://files.lebillet.my/';
    $baseUriSup = 'https://sup.lebillet.my/';
	$baseUriSales = 'https://sales.lebillet.my/';
	$baseUriEvents = 'https://eventos.lebillet.my/';
	$baseUriCheckout = 'https://checkout.lebillet.my/';
	$baseUriFastCheckout = 'https://checkout.lebillet.my/';
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
		'default_language'   => 'pt_pt',
		'date_default_timezone_set' => 'Europe/Lisbon',
	],






	'company' => [
		'name' => 'LeBillet',
		'full_name' => 'lebillet.my',
		'logos' => 'logos/lebillet_pt/',
		'email' => 'contacto@lebillet.my',
		'email_pre' => 'contacto',
		'email_domain' => 'lebillet.my',
		'phone' => null,
		'title' => 'lebillet.my | Venda de bilhetes',
		'description' => 'SUPER BILHETICA TECNOLOGIA LDA. Bilhetes a venda! Rápido, Seguro e Fácil. Faça sua compra',
		'keywords' => 'SUPER BILHETICA TECNOLOGIA LDA, eventos, bilhetes, shows, portugal, europa, apresentações, musicais, rock, sertanejo, samba, artistas, pagode',

		'analytics' => 'G-WD88QZZHN6',

		'msg_email_order_confirmation' => 'LeBillet.eu | Confirmação de reserva',
		'msg_email_order_biometrics' => 'LeBillet.eu | Falta ativar sua compra',
		// 'template_email_order_confirmation' => 'order-confirmation-lebillet',
		'template_email_order_confirmation' => 'order-confirmation-slim-lebillet_pt',

		'social' => [
			'facebook' => 'https://www.facebook.com/LeBilletPT',
			'twitter' => null,
			'instagram' => 'https://www.instagram.com/lebilleteu',
		],




		'about_title' => "SUPER BILHETICA TECNOLOGIA LDA - A LeBillet",
		'about' => "

			<p>
			A LeBillet é uma empresa de gerenciamento de vendas de bilhetes. Atua no ramo de vendas de bilhetes desde 2010 no Brasil e nos EUA, desde 2018. Estamos no mercado para oferecer o máximo de conforto e qualidade aos promotores e clientes de eventos, pois estamos diariamente a criar e a desenvolver novas maneiras de superar todas as expectativas.
			</p>



			<p>
			Além do nosso sistema integrado de gerenciamento de eventos 100% on-line, a venda de bilhetes é realizada através de nosso site e de pontos de vendas físicos que, além da possibilidade de emissão de bilhetes impressos também conta com a funcionalidade de envio por WhatsApp e e-mail, com opção de diferentes formas de pagamento.
			</p>


			<p>
			A Lebillet garante a instalação de todo o equipamento necessário à operacionalização das suas soluções de bilhética bem como a assistência técnica necessária ao bom funcionamento da plataforma tecnológica que comercializa, com apoio remoto e presencial aos seus parceiros, 24 horas por dias e 7 dias por semana.
			</p>

			<p>
			O nosso sistema de controlo de acesso em eventos é totalmente integrado ao sistema de vendas e permite a gestão em tempo real das portas de entrada, diferenciação dos tipos de bilhetes e controla possíveis situações de extravio e fraude.
			</p>

			<p>
			Com uma equipa qualificada, estamos a entregar uma experiência diferente aos territórios onde atuamos e, mais do que uma excelente comercialização, a equipe da LeBillet tem o prazer de trabalhar com sentido de parceira no seu projeto.
			</p>

			<p>
				<b>LeBillet é: SUPER BILHETICA TECNOLOGIA LDA</b>, empresa com número de pessoa coletiva 516085115 <br>
				Com sede na Rua de Vila Meã, 128, 4815-029 Conde <br>
				Para entrar em contato conosco, <a href='https://lebillet.my/helpdesk'>clique aqui</a>.
			</p>

			<p>
			Com os melhores cumprimentos da LeBillet.
			</p>
			",


		'policies' => '
			<ul class="styled_list">
				<li>
					<p>

						A SUPER BILHETICA TECNOLOGIA LDA – “LEBILLET INGRESSOS”, pessoa coletiva número 516085115, com sede no Rua Vila do Meã, 128, 4815-029, Conde e Gandela, é a entidade responsável pelo site lebillet.my (o “site”), e pela venda de bilhetes e serviços conexos prestados através do mesmo.
					</p>
				</li>


				<li>
					<p>

						As presentes Condições Gerais de Venda (“CGV”) contêm os termos da compra e venda de bilhetes através do site e de quaisquer serviços prestados através deste, devendo ser lidas atentamente antes da conclusão da ordem de compra por parte do comprador.
					</p>
				</li>


				<li>
					<p>

						O bilhete é válido apenas para o evento, data, hora, local e lugar para o qual foi emitido. Por favor, verifique os dados cuidadosamente no momento da compra. Você deve chegar ao evento com pelo menos 30 minutos de antecedência. Mantenha seu bilhete em um local seguro, longe do calor, evitando dobras e contato com outros materiais que possam danificá-lo.
					</p>
				</li>

				<li>
					<p>

						O bilhete possui itens de segurança e será sujeito a verificação no local do evento. O código de barras/código QR contido no ingresso é exclusivo e não se repete, garantindo apenas o acesso único ao evento.
					</p>
				</li>

				<li>
					<p>

						A produção do evento reserva-se no direito de solicitar ao público uma identificação com foto oficial para acessar ao evento.
					</p>
				</li>

				<li>
					<p>

						O evento pode ser gravado, filmado ou fotografado pela organização. Ao participar no evento, o titular deste bilhete concorda e autoriza o uso gratuito de sua imagem por um período indeterminado.
					</p>
				</li>

				<li>
					<p>

						A LeBillet não é responsável pela organização do evento. Questões como valores, promoções, alterações de data, restituição de valores nos casos previstos em lei e qualquer outra demanda relacionada ao evento são de responsabilidade exclusiva de seus produtores e organizadores.
					</p>
				</li>

				<li>
					<p>

						As CGV, a par das Condições Particulares informações veiculadas aquando da compra, contêm a totalidade dos termos acordados entre a lebillet e o comprador
					</p>
				</li>

				<li>
					<p>

						Quaisquer referências a consumidor devem ser lidas nos termos da Lei n.º 24/96, de 31 de julho, e subsequentes alterações. 1.2. Comunicações, apoio ao Cliente e reclamações 1.2.1. Todas as comunicações a dirigir à lebillet, incluindo reclamações, devem ser dirigidas para os seguintes endereços: — Correio eletrónico: contacto@lebillet.my; (disponível 24h), com respostas no máximo em 12 horas.
					</p>
				</li>

				<li>
					<p>

						<b>Resolução de litígios</b>
					</p>
				</li>

				<li>
					<p>

						Os conflitos de consumo de reduzido valor económico estão sujeitos a arbitragem necessária ou mediação quando, por opção expressa dos consumidores, sejam submetidos à apreciação de tribunal arbitral adstrito aos centros de arbitragem de conflitos de consumo legalmente autorizados.
					</p>
				</li>

				<li>
					<p>

						Para os fins do número anterior, consideram-se conflitos de consumo de reduzido valor económico aqueles cujo valor não exceda a alçada dos tribunais de 1.ª instância (5.000€).
					</p>
				</li>

				<li>
					<p>

						Tendo em vista facilitar a resolução de extrajudicial de litígios de consumo em linha, poderá utilizar a plataforma de Resolução de Litígios em Linha disponibilizada pela Comissão Europeia para o efeito.
					</p>
				</li>

				<li>
					<p>

						Sem prejuízo dos meios de resolução alternativa disponibilizados, os compradores podem, em qualquer caso, recorrer ao sistema judicial, caso em que as partes determinam que serão competentes os tribunais da Comarca de Guimarães, com expressa renúncia a quaisquer outros.
					</p>
				</li>

				<li>
					<p>

						As presentes CGV, bem como, as condições particulares, regem-se pela lei portuguesa.
					</p>
				</li>

				<li>
					<p>

						<b>Compra e venda de bilhetes </b>
					</p>
				</li>

				<li>
					<p>

						Através da plataforma de comércio eletrónico “eTicketing” detida pela LEBILLET podem ser feitas compras online de bilhetes para eventos, que são disponibilizados nos mesmos termos que os demais pontos de venda da rede LEBILLET, incluindo, as bilheteiras das salas de espetáculos e outros locais fisicos.
					</p>
				</li>
				<li>
					<p>
					Ao preço dos bilhetes, podem acrescer, dependendo da modalidade de entrega escolhida, despesas de envio, acrescendo igualmente a comissão de bilheteira da Lebillet.
					</p>
				</li>


				<li>
					<p>
					Em caso de erro por duplicação de transação é garantida a anulação e devolução integral da compra após solicitação do cliente. Para realização de pedidos de anulação, nestas situações, contate por favor contacto@lebillet.my.
					</p>
				</li>


				<li>
					<p>
					<b>PREÇO E MODO DE PAGAMENTO </b>
					</p>
				</li>


				<li>
					<p>
					O preço dos bilhetes é identificado no site, junto com a informação sobre cada evento, bem como, no momento da confirmação da conclusão da ordem de compra (“check-out”). O preço identificado é sempre o preço do bilhete juntamente com o IVA à taxa legal aplicável.
					</p>
				</li>


				<li>
					<p>
					Ao preço acresce uma comissão de bilheteira da LeBillet. Em média esta comissão corresponde a 7% do valor do bilhete, todavia, esta informação deve ser confirmada (i) no carrinho de compras e (ii) no momento da conclusão da ordem de compra.
					</p>
				</li>


				<li>
					<p>
					Ao preço podem acrescer despesas postais ou de entrega, associadas ao envio, consoante as modalidades disponíveis e escolhidas.
					</p>
				</li>


				<li>
					<p>
					<b>Modos de pagamento</b>
					</p>
				</li>


				<li>
					<p>
					O pagamento pode ser feito através dos seguintes sistemas: — Cartões de Crédito (VISA, MASTERCARD); — MBWay; — MBnet; — PayPal; — Paysafe Cash; — Rede MULTIBANCO (pagamento através de referência em ATM´s ou no Home banking do seu banco). A validação destas transações é assegurada pela UNICRE/SIBS.
					</p>
				</li>


				<li>
					<p>
					<b>Falha no pagamento</b>
					</p>
				</li>


				<li>
					<p>
					Em caso de utilização fraudulenta de cartões, a Lebillet cancela as transações associadas a esse meio de pagamento.
					</p>
				</li>



				<li>
					<p>
					Caso o meio de pagamento não seja aceite no prazo de 48h ou as referências MULTIBANCO não sejam pagas atempadamente, a venda não é finalizada, devendo o comprador repetir a sua ordem de compra, ficando os bilhetes novamente disponíveis para venda.
					</p>
				</li>



				<li>
					<p>
					<b>ENTREGA DOS BILHETES</b>
					</p>
				</li>



				<li>
					<p>
					Os modos de entrega disponíveis variam de acordo com evento. Estão disponíveis, no ato da compra, os modos de entrega aplicáveis, identificados para cada evento. Esta informação deve ser confirmada (i) no carrinho de compras e (ii) na conclusão da ordem de compra.
					</p>
				</li>



				<li>
					<p>
					Dependendo dos eventos e da data da compra o cliente poderá optar, entre outros, por receber os bilhetes, através de uma das seguintes modalidades: — Bilhete impresso: (i) a levantar na bilheteira da sala onde terá lugar o evento (ii) Bilhete eletrónico: disponibilizado através de mensagem de correio eletrónico, através do SMARTPHONE ou TABLET imediatamente após a confirmação de pagamento. O bilhete eletrónico permite o acesso direto e imediato ao mesmo. A sua utilização implica a apresentação da impressão do bilhete ficheiro em formato em anexo à mensagem de correio eletrónico, ou a sua apresentação através do SMARTPHONE ou TABLET, e apresentação para validação na porta de acesso (à semelhança da modalidade de bilhete impresso referida acima) (iii) – Recebimento por Whatsapp, onde o cliente fornece seu número de telefono móvel e recebe o bilhete imediatamente após a confirmação da compra.
					</p>
				</li>



				<li>
					<p>
					A Lebillet não se obriga a disponibilizar todos os meios de compra referidos em 3.1.2., podendo selecionar, para cada evento, os meios mais adequados, que devem ser sempre verificados pelo comprador antes da compra.
					</p>
				</li>



				<li>
					<p>
					O bilhete enviado pela Lebillet é sempre personalizado, mas pode ser utilizado por outra pessoa, valendo somente 1 check-in.
					</p>
				</li>



				<li>
					<p>
					<b>Conclusão da ordem de compra (“check-out”) </b>
					</p>
				</li>



				<li>
					<p>
					Antes da conclusão da compra, a Lebillet dá ao comprador, de forma clara, algumas informações que resumem o pedido, dando-lhe a possibilidade de confirmar os elementos essenciais da transação, para que possa, posteriormente, concluir a operação.
					</p>
				</li>



				<li>
					<p>
					<b>Confirmação da receção da ordem de compra </b>
					</p>
				</li>



				<li>
					<p>
					Após a conclusão da transação através do site (conclusão da ordem de compra), o comprador recebe uma mensagem de correio eletrónico com a confirmação de que a transação foi concluída com sucesso, ficando a sua finalização dependente da validação dos meios de pagamento selecionados.
					</p>
				</li>



				<li>
					<p>
					Se houver algum erro ou indisponibilidade que impeça a Lebillet de aceitar a ordem de compra, o comprador será informado em prazo razoável, sendo reembolsadas quaisquer quantias já despendidas.
					</p>
				</li>



				<li>
					<p>
					A mensagem de confirmação da receção da ordem de compra terá uma hiperligação (link) para uma área reservada no site que mostra os detalhes do bilhete e da compra.
					</p>
				</li>



				<li>
					<p>
					Após a ordem de compra e a respetiva confirmação da receção, o comprador recebe uma mensagem de correio eletrónico com informação acerca dos detalhes necessários à receção ou levantamento dos bilhetes de acordo com a opção escolhida.
					</p>
				</li>



				<li>
					<p>
					A compra fica concluída quando o meio de pagamento é aceite. Caso haja algum erro, a lebillet irá informar o comprador de que deve repetir a Ordem de Compra.
					</p>
				</li>



				<li>
					<p>
					As informações relativas às suas compras ficam guardadas e registadas na sua área pessoal.
					</p>
				</li>



				<li>
					<p>
					<b>Cancelamento da compra</b>
					</p>
				</li>



				<li>
					<p>
					A Lebillet pode cancelar a transação e invalidar o bilhete, procedendo à restituição do valor pago se: — O montante pago estiver incorreto, quer se deva a um erro no preço publicado neste site ou a qualquer informação que lhe tenha sido comunicada de outra forma; — O comprador tiver conseguido, por erro, adquirir um bilhete antes da sua data de venda ou bilhete que não haja sido colocado à venda;
					</p>
				</li>




				<li>
					<p>
					O cancelamento será aplicável quer o erro se deva a uma falha humana ou a uma falha técnica no site ou em qualquer outro sistema operativo da Lebillet.
					</p>
				</li>




				<li>
					<p>
					DEVOLUÇÕES, CANCELAMENTO E ADIAMENTO DE EVENTOS ATENÇÃO – MEDIDAS EXCEPCIONAIS COVID-19: NOVAS REGRAS DE DEVOLUÇÃO DO VALOR DOS BILHETES  <a href="https://www.culturacovid19.gov.pt/eu-tenho-uma-estrutura/" target="_blank">https://www.culturacovid19.gov.pt/eu-tenho-uma-estrutura/</a>
					</p>
				</li>




				<li>
					<p>
					<b>Alteração de datas </b>
					</p>
				</li>




				<li>
					<p>
					Os bilhetes adquiridos para um evento já agendado somente poderão ser alterados com a concordância expressa da Lebillet.
					</p>
				</li>




				<li>
					<p>
					<b>Resolução </b>
					</p>
				</li>




				<li>
					<p>
					Todas as vendas são finais, não sendo aceites trocas ou devoluções. No caso da aquisição de bilhetes com data prevista ou período de execução específico não há lugar a direito de livre resolução.
					</p>
				</li>




				<li>
					<p>
					<b>Cancelamento de eventos</b>
					</p>
				</li>



				<li>
					<p>
					Em caso de cancelamento do evento, a lebillet obriga-se à devolução do valor pago pelos bilhetes, com exceção dos custos de envio e comissão de bilheteira.
					</p>
				</li>




				<li>
					<p>
					O processo de devolução será realizado para o meio de pagamento utilizado no ato da compra. Quando necessário, a Lebillet solicitará o NIB/IBAN para finalização da devolução.
					</p>
				</li>



				<li>
					<p>
					Em caso de adiamento do espetáculo os bilhetes são válidos para a nova data.
					</p>
				</li>




				<li>
					<p>
					Caso o comprador não tenha interesse nos bilhetes para a nova data, solicitando a devolução do montante dos bilhetes, esta será efetuada nos termos do ponto 5.3.2. e até 30 dias após a data prevista para a realização do evento.
					</p>
				</li>



				<li>
					<p>
					<b>DISPOSIÇÕES FINAIS </b>
					</p>
				</li>




				<li>
					<p>
					A Lebillet pode, em qualquer momento e sem aviso prévio, proceder a alterações no conteúdo do site, nomeadamente, quanto a serviços, condições comerciais, modos de entrega, pagamento, entre outros.
					</p>
				</li>



				<li>
					<p>
					Os utilizadores do site não deverão efetuar encomendas fraudulentas.
					</p>
				</li>




				<li>
					<p>
					É vedada a cópia total ou parcial do site, incluindo qualquer conteúdo ou formato digital, sem a prévia autorização escrita da Lebillet.
					</p>
				</li>





				<li>
					<p>
					Em situações de utilização indevida do site, pode a Lebillet cancelar o registo de utilizador, cancelar encomendas, bem como, qualquer outro tipo de conteúdo do utilizador.
					</p>
				</li>





				<li>
					<p>
					São utilizadas as melhores práticas conhecidas, como certificações Verisign e Hacker Safe, com vista a assegurar os mais elevados padrões de segurança, porém, a Lebillet não pode assegurar que o funcionamento do site seja totalmente desprovido de erros ou sem períodos de indisponibilidade. O site não pode garantir que o download de ficheiros seja totalmente livre de erros ou de riscos associados, nomeadamente, de vírus informáticos. A Lebillet não será responsável por quaisquer danos, independente da sua natureza, em equipamentos informáticos, que decorram da utilização deste site.
					</p>
				</li>





				<li>
					<p>
					Os dados relativos a cartões de crédito para proceder a compras através do site da Lebillet são inseridos num Servidor Seguro (SSL) que codifica, ou seja, transforma em código todos os dados confidenciais relativos a dados pessoais e de pagamentos. O SSL é suportado por todas as versões dos browsers Google Chrome, Firefox, Opera e Microsoft Internet Explorer.
					</p>
				</li>





				<li>
					<p>
					Existem elementos que indicam que o utilizador se encontra num site seguro: por exemplo um cadeado (no Microsoft Internet Explorer) deve aparecer no seu browser, como indicador de segurança da página. Poderá ainda constatar que, ao entrar numa zona segura do site, o respetivo endereço URL começará com https:// (S=Seguro).
					</p>
				</li>






			</ul>


			',




		'ticket_instructions' => '
			<h4 class="text-center" style="text-align: center;">INFORMAÇÕES IMPORTANTES</h4>


				1. A Página de Confirmação / Bilhete Electrónico é pessoal e intransmissível, pelo que qualquer uso indevido do mesmo é da total responsabilidade do cliente. A duplicação ou revenda da(o) Página de Confirmação / Bilhete Electrónico impedem o livre acesso ao recinto, facto que a LE BILLET é alheia e isenta de qualquer responsabilidade. É da responsabilidade do cliente confirmar sempre os dados constantes na(o) Página de Confirmação / Bilhete Electrónico e manter o bilhete.
			<br>


				2. O bilhete electrónico é válido mediante a apresentação do documento de identificação, caso seja solicitado pelos assistentes de sala.
			<br>


				3. Sobre o valor total da transacção acresce 6% mais IVA à taxa legal em vigor. Estes custos de operação aplicam-se a todas as compras efectuadas em www.LEBILLET.pt.
			<br>


				4. Não se efectuam trocas e/ou devoluções de compras feitas online, excepto no caso de o evento sofrer alguma alteração ao previsto ou ser cancelado. A resolução ao disposto é da responsabilidade do promotor. A empresa emissora do bilhete não assume, em qualquer caso, as obrigações e responsabilidades do promotor.
			<br>


				5. O cancelamento e/ou alteração de um evento que se realize ao ar livre ou que esteja dependente das condições climatéricas, não obriga o promotor a devolver o valor do bilhete.
			<br>


				6. No caso de o evento ser cancelado, adiado, ou seja, solicitada a devolução do valor da compra efectuada por motivos de força maior, a Le Billet não procede ao reembolso dos custos de operação e dos custos de envio da compra.
			<br>

				7. É obrigatória a apresentação do documento comprovativo de desconto na entrada do recinto.
			<br>

				8. Salvo indicação em contrário, não é permitido entrar no recinto enquanto o evento está a decorrer; não é permitido fumar no recinto; não é permitida a entrada de animais, máquinas fotográficas e/ou de vídeo e de gravadores de áudio, bem como de objectos perigosos.
			<br>


				9. Ao adquirir este bilhete estará a aceitar todas as condições acima descritas.
			<br>


				10. Sempre mantenha o seu endereço de e-mail atualizado em nosso site para receber as atualizações mais recentes sobre o evento, como alterações de local, data e cancelamentos.
			<br>


				11. NÃO É NECESSÁRIO IMPRIMIR SEU BILHETE. APENAS APRESENTE NO TELEMÓVEL

		',



		'privacy' => '
			<h3>POLÍTICA DE PRIVACIDADE</h3>

			<p>
				Ao registrar-se no nosso site ou comprar bilhetes para eventos disponíveis nos canais de vendas da LeBillet, os dados pessoais dos usuários serão armazenados em nossos servidores. Informações que coletamos: nome, sobrenome, e-mail, endereço, números de telefone e data de nascimento.
			</p>

			<p>
				Outros dados podem ser necessários para garantir a veracidade das transações. Os dados de pagamento e preenchimento necessários para o processamento da transação, como número do cartão de crédito, não são armazenados em nossos servidores. Além dos dados dos usuários, também armazenamos o recebimento de informações quando o usuário entra em contato conosco ou responde a qualquer pesquisa. Esta informação será incluída no registo de cada usuário.
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
				O usuário receberá um e-mail enviado pela LeBillet para confirmar o registro e ativar a conta.
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

			<p>
				No que respeita ao tratamento dos seus dados pessoais, goza o titular dos dados dos seguintes direitos, nos termos dos artigos 15.º a 22.º do Regulamento Geral sobre a Proteção de Dados, conforme se descreve infra
			</p>

			<p>
				Nos termos do Regulamento Geral sobre a Proteção de Dados, será tratamento de dados pessoais, uma operação ou um conjunto de operações efetuadas sobre dados pessoais ou sobre conjuntos de dados pessoais, por meios automatizados ou não automatizados, tais como a recolha, o registo, a organização, a estruturação, a conservação, a adaptação ou alteração, a recuperação, a consulta, a utilização, a divulgação por transmissão, difusão ou qualquer outra forma de disponibilização, a comparação ou interconexão, a limitação, o apagamento ou a destruição. 3 - 14 O tratamento de dados pessoais para uma determinada finalidade, deve reunir um dos fundamentos jurídicos taxativamente previstos no RGPD. A LeBillet poderá proceder ao tratamento dos seus dados pessoais com os seguintes fundamentos: a) Consentimento para o tratamento dos seus dados pessoais para uma ou mais finalidades específicas (artigo 6.º, n.º 1, alínea a)); b) Se o tratamento for necessário para a execução de um contrato no qual o titular dos dados é parte, ou para diligências pré-contratuais a pedido do titular dos dados (artigo 6.º, n.º 1, alínea b)); c) Se o tratamento for necessário para o cumprimento de uma obrigação jurídica a que a LeBillet esteja sujeita (artigo 6.º, n.º 1, alínea c)); d) O tratamento for necessário para efeito dos interesses legítimos prosseguidos pela LeBillet ou por terceiros, exceto se prevalecerem os interesses ou direitos e liberdades fundamentais do titular que exijam a proteção dos dados pessoais, em especial se o titular for uma criança (artigo 6.º, n.º 1, alínea f)).
			</p>

			<p>
				Nos termos legais, tem o direito de solicitar o apagamento dos seus dados pessoais quando se verifique uma das seguintes situações: — os dados pessoais deixem de ser necessários para a finalidade que motivou a sua recolha ou tratamento; — apresente oposição ao tratamento dos dados e não existam interesses legítimos prevalecentes que justifiquem o tratamento ou os dados forem tratados para efeitos de marketing direto (envio de comunicações não solicitadas); — os dados pessoais forem tratados ilicitamente; — os dados pessoais tenham que ser apagados ao abrigo de uma obrigação jurídica a que esteja sujeita a LeBillet; ou — os dados pessoais tenham sido recolhidos no contexto da oferta de serviços da sociedade de informação. 11 - 14 O direito ao apagamento não se aplica quando o tratamento seja necessário para os seguintes efeitos: — exercício de liberdade de expressão e de informação; — cumprimento de obrigação legal que exija o tratamento e que se aplique à LeBillet; — motivos de interesse público no domínio da saúde pública; — fins de arquivo de interesse público, fins de investigação científica ou histórica ou fins estatísticos, na medida em que o exercício do direito ao apagamento prejudique gravemente a obtenção dos objetivos desse tratamento; ou — declaração, exercício ou defesa de um direito num processo judicial. Embora possa exercer, a todo o tempo, o seu direito ao apagamento, o exercício deste direito, no que respeita à finalidade de definição de perfis para fins de envio de ofertas e promoções personalizadas (marketing direto) fica comprometido.
			</p>



			<h3>COOKIES</h3>

			<p>
			Cookies são pequenos arquivos que um site ou seu provedor de serviços transfere para o disco rígido do seu computador através do navegador da Web (se você tiver permitido isso através de suas configurações). Isso permite que os sites ou sistemas de provedores de serviços reconheçam seu navegador e capturem e lembrem de certas informações.
			</p>

			<p>
			Utilizamos cookies para nos ajudar a lembrar e processar os itens do seu carrinho de compras, entender e salvar as suas preferências para futuras visitas e compilar os dados agregados sobre o tráfego e a interação do site, para que possamos oferecer melhores experiências e ferramentas para si no futuro. Podemos contratar fornecedores de serviços terceirizados para nos ajudar a entender melhor os visitantes do site. Esses prestadores de serviços não têm permissão para usar as informações coletadas em nosso nome, exceto para nos ajudar a conduzir e a melhorar diretamente nossos negócios.
			</p>

			<p>
			Se preferir, você pode optar por avisar o computador sempre que um cookie for enviado ou optar por desativar todos os cookies nas configurações do navegador. Como a maioria dos sites, se você desativar os cookies, alguns de nossos serviços podem não funcionar corretamente.
			</p>




			<h3>ANTI-SPAM</h3>
			<p>
			Todos os e-mails enviados pela LeBillet contam com o consentimento do cliente, uma vez que ele próprio escolhe receber por meio de uma inscrição ou implicitamente quando um contacto entre as partes é estabelecido, sem o uso de meios intrusivos.
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
			</p>


			<h3>DE ACORDO</h3>
			<p>
				Ao usar nosso site, você concorda com a nossa política de privacidade online.
			</p>
		',

	]







);
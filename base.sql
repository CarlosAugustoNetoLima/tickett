/*
SQLyog Ultimate v12.09 (64 bit)
MySQL - 5.7.28-0ubuntu0.18.04.4 : Database - ticket
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`ticket` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `ticket`;

/*Table structure for table `_log` */

DROP TABLE IF EXISTS `_log`;

CREATE TABLE `_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `_log_error` */

DROP TABLE IF EXISTS `_log_error`;

CREATE TABLE `_log_error` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `text` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6168 DEFAULT CHARSET=utf8;

/*Table structure for table `_log_order_email_sent` */

DROP TABLE IF EXISTS `_log_order_email_sent`;

CREATE TABLE `_log_order_email_sent` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_order` int(10) unsigned DEFAULT NULL,
  `email_to` varchar(150) DEFAULT NULL,
  `obs` varchar(200) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `id` (`id`),
  KEY `id_order` (`id_order`),
  CONSTRAINT `_log_order_email_sent_ibfk_1` FOREIGN KEY (`id_order`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17347 DEFAULT CHARSET=utf8;

/*Table structure for table `_log_order_proccess_payment` */

DROP TABLE IF EXISTS `_log_order_proccess_payment`;

CREATE TABLE `_log_order_proccess_payment` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_order` int(10) unsigned DEFAULT NULL,
  `id_orders_payment` int(10) unsigned DEFAULT NULL,
  `response` mediumtext,
  `obs` varchar(200) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `id` (`id`),
  KEY `id_order` (`id_order`),
  KEY `id_orders_payment` (`id_orders_payment`),
  CONSTRAINT `_log_order_proccess_payment_ibfk_1` FOREIGN KEY (`id_order`) REFERENCES `orders` (`id`),
  CONSTRAINT `_log_order_proccess_payment_ibfk_2` FOREIGN KEY (`id_orders_payment`) REFERENCES `orders_payment` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14863 DEFAULT CHARSET=utf8;

/*Table structure for table `_log_site_pages_views` */

DROP TABLE IF EXISTS `_log_site_pages_views`;

CREATE TABLE `_log_site_pages_views` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `url` varchar(255) DEFAULT NULL COMMENT 'Página visitada',
  `ip` varchar(100) DEFAULT NULL COMMENT 'IP do visitante',
  `session` varchar(100) DEFAULT NULL COMMENT 'Sessao do browser',
  `agent` text COMMENT 'Browser utilizado',
  `request` text COMMENT 'O que foi postado POST e GET',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=370698 DEFAULT CHARSET=utf8;

/*Table structure for table `admins` */

DROP TABLE IF EXISTS `admins`;

CREATE TABLE `admins` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(250) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

/*Table structure for table `cart` */

DROP TABLE IF EXISTS `cart`;

CREATE TABLE `cart` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_customer` int(11) DEFAULT '0' COMMENT 'Se tiver, é o codigo do usuario logado',
  `id_event` int(11) DEFAULT '0' COMMENT 'Evento',
  `id_product` int(11) DEFAULT '0' COMMENT 'Codigo do produto',
  `id_product_type` int(11) DEFAULT '0' COMMENT 'Tipo do produto',
  `id_delivery_type` int(11) DEFAULT NULL,
  `id_payment_type` int(11) DEFAULT NULL,
  `product_lot` int(11) DEFAULT '0' COMMENT 'Lote do produto',
  `qty` int(11) DEFAULT '0' COMMENT 'Qtd de produtos',
  `price` decimal(10,2) DEFAULT '0.00' COMMENT 'Preço unitário',
  `price_tax` decimal(10,2) DEFAULT NULL COMMENT 'Imposto sobre o valor do produto - unitário',
  `fee` decimal(10,2) DEFAULT '0.00' COMMENT 'Taxa',
  `fee_tax` decimal(10,2) DEFAULT NULL COMMENT 'Imposto sobre a taxa',
  `fee_org` decimal(10,2) DEFAULT '0.00' COMMENT 'Taxa do organizador',
  `fee_org_tax` decimal(10,2) DEFAULT NULL COMMENT 'Imposto sobre a taxa do organizador',
  `customer_session` varchar(500) DEFAULT NULL COMMENT 'A SESSION do usuário',
  `customer_ip` varchar(200) DEFAULT NULL COMMENT 'IP do usuário',
  `customer_agent` text COMMENT 'O browser do usuário',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `id` (`id`),
  KEY `session` (`customer_session`),
  KEY `created` (`created_at`),
  KEY `product` (`id_product`),
  KEY `type` (`id_product_type`),
  KEY `event` (`id_event`),
  KEY `user` (`id_customer`)
) ENGINE=InnoDB AUTO_INCREMENT=64684 DEFAULT CHARSET=utf8;

/*Table structure for table `cc_temp` */

DROP TABLE IF EXISTS `cc_temp`;

CREATE TABLE `cc_temp` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID do cartao',
  `cc_name` varchar(150) DEFAULT NULL COMMENT 'Nome',
  `cc_number` varchar(50) DEFAULT NULL COMMENT 'Numero',
  `cc_expiration` varchar(10) DEFAULT NULL COMMENT 'Data Validade',
  `cc_cvv` varchar(5) DEFAULT NULL COMMENT 'CV',
  `flag` varchar(100) DEFAULT NULL COMMENT 'Bandeira',
  `status` tinyint(2) DEFAULT '1' COMMENT '1 - Aguardando ser processado | 2 - Foi processado',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `checkout_embedded` */

DROP TABLE IF EXISTS `checkout_embedded`;

CREATE TABLE `checkout_embedded` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `token` varchar(200) DEFAULT NULL,
  `id_sale_point` int(10) unsigned DEFAULT NULL,
  `id_sale_terminal` int(10) unsigned DEFAULT NULL,
  `config` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `id_sale_point` (`id_sale_point`),
  KEY `id_sale_terminal` (`id_sale_terminal`),
  CONSTRAINT `checkout_embedded_ibfk_1` FOREIGN KEY (`id_sale_point`) REFERENCES `sales_points` (`id`),
  CONSTRAINT `checkout_embedded_ibfk_2` FOREIGN KEY (`id_sale_terminal`) REFERENCES `sales_terminal` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=118 DEFAULT CHARSET=utf8;

/*Table structure for table `cities` */

DROP TABLE IF EXISTS `cities`;

CREATE TABLE `cities` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `id_region` int(10) unsigned DEFAULT NULL,
  `id_country` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `region_idx` (`id_region`),
  KEY `country_idx` (`id_country`),
  CONSTRAINT `country-cities` FOREIGN KEY (`id_country`) REFERENCES `countries` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `region-cities` FOREIGN KEY (`id_region`) REFERENCES `regions` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;

/*Table structure for table `countries` */

DROP TABLE IF EXISTS `countries`;

CREATE TABLE `countries` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `acronym` varchar(10) DEFAULT NULL,
  `iso` char(3) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Table structure for table `coupons` */

DROP TABLE IF EXISTS `coupons`;

CREATE TABLE `coupons` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL COMMENT 'Nome da Regra',
  `description` text COMMENT 'Descrição - opcional, não é visível pro usuário',
  `usage_limit` int(10) unsigned DEFAULT '0',
  `start_at` timestamp NULL DEFAULT NULL COMMENT 'Válido de tal data',
  `end_at` timestamp NULL DEFAULT NULL COMMENT 'Válido até tal data',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `value_type` tinyint(1) DEFAULT NULL COMMENT '1->Porcentagem 2->Fixo',
  `value` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Table structure for table `coupons_codes` */

DROP TABLE IF EXISTS `coupons_codes`;

CREATE TABLE `coupons_codes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_coupon` int(10) unsigned DEFAULT NULL COMMENT 'A qual cupom corresponde',
  `code` varchar(255) DEFAULT NULL COMMENT 'CODIGO para ativar o cupom',
  `usage_limit` int(10) unsigned DEFAULT '0' COMMENT 'Limite de utilizaçoes',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id_coupon` (`id_coupon`),
  CONSTRAINT `coupons_codes_ibfk_1` FOREIGN KEY (`id_coupon`) REFERENCES `coupons` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=92 DEFAULT CHARSET=utf8;

/*Table structure for table `customer_billing_address` */

DROP TABLE IF EXISTS `customer_billing_address`;

CREATE TABLE `customer_billing_address` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_customer` int(10) unsigned DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  `phone` varchar(100) DEFAULT NULL,
  `address_1` varchar(250) DEFAULT NULL,
  `address_2` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `region` varchar(100) DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL,
  `zipcode` varchar(30) DEFAULT NULL,
  `cc_name` varchar(150) DEFAULT NULL,
  `cc_number` varchar(30) DEFAULT NULL,
  `cc_expiration` varchar(10) DEFAULT NULL,
  `cc_cvv` varchar(10) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `id_customer` (`id_customer`),
  CONSTRAINT `customer_billing_address_ibfk_1` FOREIGN KEY (`id_customer`) REFERENCES `customers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `customers` */

DROP TABLE IF EXISTS `customers`;

CREATE TABLE `customers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `password` varchar(250) NOT NULL,
  `email` varchar(100) NOT NULL,
  `id_number` varchar(100) DEFAULT NULL COMMENT 'ID, SSN, PASSAPORT..',
  `email_confirmed` tinyint(1) unsigned DEFAULT '0' COMMENT '0-NAO | 1-SIM',
  `cell_number` varchar(20) DEFAULT NULL,
  `cell_number_confirmed` tinyint(1) unsigned DEFAULT '0' COMMENT '0-NAO | 1-SIM',
  `dob` date DEFAULT NULL COMMENT 'Date Of Birthday - Nascimento',
  `suspect` tinyint(1) DEFAULT '0' COMMENT '0-NAO | 1-SIM',
  `zipcode` varchar(50) DEFAULT NULL COMMENT 'CEP, ZipCODE',
  `address_1` varchar(255) DEFAULT NULL,
  `address_2` varchar(255) DEFAULT NULL,
  `city` varchar(150) DEFAULT NULL,
  `region` varchar(150) DEFAULT NULL,
  `country` varchar(150) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `email` (`email`),
  KEY `id_number` (`id_number`),
  KEY `zipcode` (`zipcode`),
  KEY `city` (`city`),
  KEY `region` (`region`),
  KEY `country` (`country`)
) ENGINE=InnoDB AUTO_INCREMENT=3266 DEFAULT CHARSET=utf8;

/*Table structure for table `delivery_types` */

DROP TABLE IF EXISTS `delivery_types`;

CREATE TABLE `delivery_types` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

/*Table structure for table `events` */

DROP TABLE IF EXISTS `events`;

CREATE TABLE `events` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `ticket_sub_name` varchar(200) DEFAULT NULL COMMENT 'Aparece no Ticket (tanto eticket qto impresso) abaixo do nome do evento',
  `id_place` int(11) unsigned DEFAULT NULL,
  `id_city` int(11) unsigned DEFAULT NULL,
  `id_region` int(11) unsigned DEFAULT NULL,
  `id_organizer` int(11) unsigned DEFAULT NULL,
  `date_start` timestamp NULL DEFAULT NULL,
  `date_opening` timestamp NULL DEFAULT NULL,
  `date_sales_start` timestamp NULL DEFAULT NULL,
  `date_sales_end` timestamp NULL DEFAULT NULL,
  `resume` mediumtext COMMENT 'Resumo - Aparece ao lado da capa, nas buscas, na home quando compartilha, na description html da pagina',
  `description` text COMMENT 'Descrição completa sobre o evento - aparece na página do evento',
  `instructions` text COMMENT 'Instruções - Vai na tela de confirmação do evento',
  `parental_rating` varchar(200) DEFAULT NULL COMMENT 'Classificação de idade',
  `slug` varchar(200) DEFAULT NULL COMMENT 'url amigável',
  `logo` varchar(255) DEFAULT NULL,
  `logo_pos` varchar(255) DEFAULT NULL,
  `visit` int(11) unsigned DEFAULT '0' COMMENT 'Quantas visitas o evento teve',
  `display_in_cover` enum('0','1') DEFAULT NULL COMMENT '0 NAO | 1 SIM',
  `max_installment_without_interest` tinyint(2) DEFAULT '1' COMMENT 'Parcelas SEM juros',
  `max_installment_with_interest` tinyint(2) DEFAULT '1' COMMENT 'Parcelas COM juros',
  `interest_rate` decimal(10,2) DEFAULT '0.00' COMMENT 'Porcentagem mensal dos juros',
  `negotiation` text COMMENT 'Negociaçao deste evento',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `place_idx` (`id_place`),
  KEY `city_idx` (`id_city`),
  KEY `region_idx` (`id_region`),
  KEY `organizer_idx` (`id_organizer`),
  KEY `date_start` (`date_start`),
  KEY `date_opening` (`date_opening`),
  KEY `date_sales_start` (`date_sales_start`),
  KEY `date_sales_end` (`date_sales_end`),
  KEY `name` (`name`),
  KEY `display_in_cover` (`display_in_cover`),
  CONSTRAINT `city-events` FOREIGN KEY (`id_city`) REFERENCES `cities` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `organizer-events` FOREIGN KEY (`id_organizer`) REFERENCES `organizers` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `place-events` FOREIGN KEY (`id_place`) REFERENCES `places` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `region-events` FOREIGN KEY (`id_region`) REFERENCES `regions` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8;

/*Table structure for table `events_deliveries` */

DROP TABLE IF EXISTS `events_deliveries`;

CREATE TABLE `events_deliveries` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_event` int(10) unsigned DEFAULT NULL,
  `id_delivery_type` int(10) unsigned DEFAULT NULL,
  `value` decimal(10,2) DEFAULT NULL COMMENT 'Custo da entrega',
  `value_tax` decimal(10,2) DEFAULT NULL COMMENT 'Valor do imposto sobre a entrega',
  `resume` varchar(255) DEFAULT NULL COMMENT 'Resumo sobre a forma de entrega',
  `description` mediumtext COMMENT 'Detalhes completos da forma de entrega',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `event_idx` (`id_event`),
  KEY `delivery_idx` (`id_delivery_type`),
  CONSTRAINT `delivery-events_deliveries` FOREIGN KEY (`id_delivery_type`) REFERENCES `delivery_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `event-events_deliveries` FOREIGN KEY (`id_event`) REFERENCES `events` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `events_deliveries_terminal` */

DROP TABLE IF EXISTS `events_deliveries_terminal`;

CREATE TABLE `events_deliveries_terminal` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_event` int(10) unsigned DEFAULT NULL COMMENT 'ID do Evento',
  `id_terminal` int(10) unsigned DEFAULT NULL COMMENT 'ID o Terminal',
  `id_delivery_type` int(10) unsigned DEFAULT NULL COMMENT 'ID da Forma de entrega',
  `value` decimal(10,2) DEFAULT NULL COMMENT 'Custo da entrega',
  `value_tax` decimal(10,2) DEFAULT NULL COMMENT 'Valor do imposto sobre a entrega',
  `title` varchar(50) DEFAULT NULL COMMENT 'Nome - Sobrescreve o nome da forma de entrega',
  `resume` varchar(255) DEFAULT NULL COMMENT 'Resumo sobre a forma de entrega',
  `description` mediumtext COMMENT 'Detalhes completos da forma de entrega',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `event_idx` (`id_event`),
  KEY `delivery_idx` (`id_delivery_type`),
  KEY `id_terminal` (`id_terminal`),
  CONSTRAINT `events_deliveries_terminal_ibfk_1` FOREIGN KEY (`id_event`) REFERENCES `events` (`id`),
  CONSTRAINT `events_deliveries_terminal_ibfk_2` FOREIGN KEY (`id_terminal`) REFERENCES `sales_terminal` (`id`),
  CONSTRAINT `events_deliveries_terminal_ibfk_3` FOREIGN KEY (`id_delivery_type`) REFERENCES `delivery_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `events_embedded` */

DROP TABLE IF EXISTS `events_embedded`;

CREATE TABLE `events_embedded` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL COMMENT 'titulo da página',
  `slug` varchar(255) DEFAULT NULL COMMENT 'link da url --- events.titkx/slug',
  `organizer` text COMMENT 'organizador, pode se separado por virgula',
  `place` text COMMENT 'local, pode se separado por virgula',
  `city` text COMMENT 'cidade, pode se separado por virgula',
  `region` text COMMENT 'estado, pode se separado por virgula',
  `event` text COMMENT 'eventos separados por virgula',
  `config` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

/*Table structure for table `events_extra_data` */

DROP TABLE IF EXISTS `events_extra_data`;

CREATE TABLE `events_extra_data` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_event` int(10) unsigned DEFAULT NULL COMMENT 'Evento',
  `id_product` int(10) unsigned DEFAULT NULL COMMENT 'Produto',
  `id_product_type` int(10) unsigned DEFAULT NULL COMMENT 'Tipo do Produto',
  `id_extra_data` int(10) unsigned DEFAULT NULL COMMENT 'Qual Dado Extra',
  `limit_order` int(10) unsigned DEFAULT '0' COMMENT 'Limite por compra',
  `limit_customer` int(10) unsigned DEFAULT '0' COMMENT 'Limite por cliente',
  `editable` tinyint(1) DEFAULT '0' COMMENT '0->NAO | 1->SIM',
  `description` text COMMENT 'Descrição - aparece abaixo do input pra preencher o dado',
  `required_start` timestamp NULL DEFAULT NULL COMMENT 'Obrigatório a partir desta data',
  `required_end` timestamp NULL DEFAULT NULL COMMENT 'Obrigatório até esta data',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id_event` (`id_event`),
  KEY `id_product` (`id_product`),
  KEY `id_product_type` (`id_product_type`),
  KEY `id_extra_data` (`id_extra_data`),
  CONSTRAINT `events_extra_data_ibfk_1` FOREIGN KEY (`id_event`) REFERENCES `events` (`id`),
  CONSTRAINT `events_extra_data_ibfk_2` FOREIGN KEY (`id_product`) REFERENCES `products` (`id`),
  CONSTRAINT `events_extra_data_ibfk_3` FOREIGN KEY (`id_product_type`) REFERENCES `products_types` (`id`),
  CONSTRAINT `events_extra_data_ibfk_4` FOREIGN KEY (`id_extra_data`) REFERENCES `extra_data` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=525 DEFAULT CHARSET=utf8;

/*Table structure for table `events_finances` */

DROP TABLE IF EXISTS `events_finances`;

CREATE TABLE `events_finances` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_event` int(10) unsigned DEFAULT NULL,
  `type` enum('debit','credit') DEFAULT NULL COMMENT 'Tipo de lançamento DÉBITO ou CRÉDITO',
  `qty` int(10) unsigned DEFAULT NULL,
  `unitary_value` float(10,2) DEFAULT NULL,
  `total_value` float(10,2) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id_event` (`id_event`),
  CONSTRAINT `events_finances_ibfk_1` FOREIGN KEY (`id_event`) REFERENCES `events` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `events_images` */

DROP TABLE IF EXISTS `events_images`;

CREATE TABLE `events_images` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_event` int(10) unsigned DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `base64` longtext COMMENT 'base64 da img antes de gerar a imagem compactada para o site',
  `order` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `id_event` (`id_event`),
  CONSTRAINT `events_images_ibfk_1` FOREIGN KEY (`id_event`) REFERENCES `events` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=295 DEFAULT CHARSET=utf8;

/*Table structure for table `events_payments` */

DROP TABLE IF EXISTS `events_payments`;

CREATE TABLE `events_payments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_event` int(10) unsigned DEFAULT NULL,
  `id_payment_types` int(10) unsigned DEFAULT NULL,
  `id_sale_point` int(10) unsigned DEFAULT NULL,
  `qtt_plots` int(11) DEFAULT NULL COMMENT 'Máximo de parcelas',
  `qtt_plots_fee` int(11) DEFAULT NULL COMMENT 'Máximo de parcelas com juros',
  `plots_fee` decimal(10,2) DEFAULT NULL,
  `fee_type` tinyint(1) DEFAULT NULL COMMENT '1 - Fixo | 2 - Percentual',
  `value_minimum` decimal(10,2) DEFAULT NULL,
  `value_maximum` decimal(10,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `event_idx` (`id_event`),
  KEY `payment_idx` (`id_payment_types`),
  KEY `id_sale_point` (`id_sale_point`),
  CONSTRAINT `event-events_payments` FOREIGN KEY (`id_event`) REFERENCES `events` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `events_payments_ibfk_1` FOREIGN KEY (`id_sale_point`) REFERENCES `sales_points` (`id`),
  CONSTRAINT `payment-events_payments` FOREIGN KEY (`id_payment_types`) REFERENCES `payment_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `events_performes` */

DROP TABLE IF EXISTS `events_performes`;

CREATE TABLE `events_performes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_event` int(10) unsigned DEFAULT NULL,
  `id_performer` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id_event` (`id_event`),
  KEY `id_performer` (`id_performer`),
  CONSTRAINT `events_performes_ibfk_1` FOREIGN KEY (`id_event`) REFERENCES `events` (`id`),
  CONSTRAINT `events_performes_ibfk_2` FOREIGN KEY (`id_performer`) REFERENCES `performers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

/*Table structure for table `extra_data` */

DROP TABLE IF EXISTS `extra_data`;

CREATE TABLE `extra_data` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

/*Table structure for table `fee_org_values` */

DROP TABLE IF EXISTS `fee_org_values`;

CREATE TABLE `fee_org_values` (
  `id` int(10) unsigned NOT NULL DEFAULT '0',
  `id_fee` int(10) unsigned DEFAULT NULL COMMENT 'ID da taxa',
  `start_value` decimal(10,2) DEFAULT NULL COMMENT 'Valor inicial',
  `end_value` decimal(10,2) DEFAULT NULL COMMENT 'Valor final',
  `duty` decimal(10,2) DEFAULT NULL COMMENT 'Taxa dentro do valor estabelecido',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 - Porcentual | 2 - Fixo',
  `tax` decimal(10,2) DEFAULT NULL COMMENT 'Valor do imposto sobre a taxa do organizador',
  `tax_type` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Tipo do imposto = 1 - Porcentual | 2 - Fixo',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  KEY `id_fee` (`id_fee`),
  CONSTRAINT `fee_org_values_ibfk_1` FOREIGN KEY (`id_fee`) REFERENCES `fees_org` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Valores da taxa do organizador - este valor é um uma sobretaxa no produto - cobra do cliente e repasse ao organizador, mas no painel nao aparece somado ao produto';

/*Table structure for table `fee_values` */

DROP TABLE IF EXISTS `fee_values`;

CREATE TABLE `fee_values` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_fee` int(10) unsigned DEFAULT NULL COMMENT 'ID da taxa',
  `start_value` decimal(10,2) DEFAULT NULL COMMENT 'Valor inicial',
  `end_value` decimal(10,2) DEFAULT NULL COMMENT 'Valor final',
  `duty` decimal(10,2) DEFAULT NULL COMMENT 'Taxa dentro do valor estabelecido',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 - Porcentual | 2 - Fixo',
  `tax` decimal(10,2) DEFAULT NULL COMMENT 'Valor do imposto sobre a taxa de serviço',
  `tax_type` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Tipo do imposto = 1 - Porcentual | 2 - Fixo',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  KEY `id` (`id`),
  KEY `id_fee` (`id_fee`),
  CONSTRAINT `fee_values_ibfk_1` FOREIGN KEY (`id_fee`) REFERENCES `fees` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

/*Table structure for table `fees` */

DROP TABLE IF EXISTS `fees`;

CREATE TABLE `fees` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

/*Table structure for table `fees_org` */

DROP TABLE IF EXISTS `fees_org`;

CREATE TABLE `fees_org` (
  `id` int(10) unsigned NOT NULL DEFAULT '0',
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `helpdesk_answers` */

DROP TABLE IF EXISTS `helpdesk_answers`;

CREATE TABLE `helpdesk_answers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_helpdesk` int(10) unsigned DEFAULT NULL,
  `author` varchar(150) DEFAULT NULL,
  `admin` tinyint(1) DEFAULT '0' COMMENT '0 NÃO | 1 SIM',
  `message` text,
  `ip` varchar(100) DEFAULT NULL,
  `session` varchar(150) DEFAULT NULL,
  `agent` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `session` (`session`),
  KEY `created_at` (`created_at`),
  KEY `id_helpdesk` (`id_helpdesk`),
  CONSTRAINT `helpdesk_answers_ibfk_1` FOREIGN KEY (`id_helpdesk`) REFERENCES `helpdesk_opening` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=218 DEFAULT CHARSET=utf8;

/*Table structure for table `helpdesk_opening` */

DROP TABLE IF EXISTS `helpdesk_opening`;

CREATE TABLE `helpdesk_opening` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `subject` varchar(250) DEFAULT NULL,
  `status` tinyint(1) DEFAULT '0' COMMENT '0 Novo | 1 Lido | 2 Respondido | 3 Finalizado',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `email` (`email`),
  KEY `created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8;

/*Table structure for table `identifier` */

DROP TABLE IF EXISTS `identifier`;

CREATE TABLE `identifier` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(20) DEFAULT NULL COMMENT 'Código Localizador',
  `id_event` int(10) unsigned DEFAULT NULL,
  `id_product` int(10) unsigned DEFAULT NULL,
  `id_product_type` int(10) unsigned DEFAULT NULL,
  `id_lot` int(10) unsigned DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL COMMENT 'Preço do lote na criação',
  `fee` decimal(10,2) DEFAULT NULL COMMENT 'Taxa sobre o valor',
  `quantity` int(10) unsigned DEFAULT NULL COMMENT 'Qtd de tickets',
  `created_by` int(10) unsigned DEFAULT NULL COMMENT 'ID do USER',
  `description` text,
  `id_sale` int(10) unsigned DEFAULT NULL COMMENT 'ID da SALE (pedido vinculado)',
  `printed_at` timestamp NULL DEFAULT NULL COMMENT 'Hora que foi impresso',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id_event` (`id_event`),
  KEY `id_product` (`id_product`),
  KEY `id_product_type` (`id_product_type`),
  KEY `created_by` (`created_by`),
  KEY `code` (`code`),
  KEY `code_2` (`code`),
  KEY `id_sale` (`id_sale`),
  CONSTRAINT `identifier_ibfk_1` FOREIGN KEY (`id_event`) REFERENCES `events` (`id`),
  CONSTRAINT `identifier_ibfk_2` FOREIGN KEY (`id_product`) REFERENCES `products` (`id`),
  CONSTRAINT `identifier_ibfk_3` FOREIGN KEY (`id_product_type`) REFERENCES `products_types` (`id`),
  CONSTRAINT `identifier_ibfk_4` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `identifier_ibfk_5` FOREIGN KEY (`id_sale`) REFERENCES `sales` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

/*Table structure for table `languages` */

DROP TABLE IF EXISTS `languages`;

CREATE TABLE `languages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `string` varchar(100) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `pt_br` varchar(500) DEFAULT NULL COMMENT 'Portugues do Brasil',
  `en_us` varchar(500) DEFAULT NULL COMMENT 'Ingles do EUA',
  `es_do` varchar(500) DEFAULT NULL COMMENT 'Spanish (Dominican republic)	es_DO',
  PRIMARY KEY (`id`,`string`),
  KEY `id` (`id`),
  KEY `string` (`string`)
) ENGINE=InnoDB AUTO_INCREMENT=500 DEFAULT CHARSET=utf8;

/*Table structure for table `maps` */

DROP TABLE IF EXISTS `maps`;

CREATE TABLE `maps` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `img_or_html` varchar(10) DEFAULT NULL,
  `img` varchar(255) DEFAULT NULL,
  `html` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Table structure for table `maps_seats` */

DROP TABLE IF EXISTS `maps_seats`;

CREATE TABLE `maps_seats` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_map` int(10) unsigned DEFAULT NULL,
  `id_map_sector` int(10) unsigned DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `salable` enum('0','1') DEFAULT NULL COMMENT '0 -> Nao é vendável |  1-> vendável',
  `row` varchar(25) DEFAULT NULL,
  `seat` varchar(25) DEFAULT NULL,
  `label` varchar(50) DEFAULT NULL,
  `left` varchar(10) DEFAULT NULL,
  `top` varchar(10) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id_map` (`id_map`),
  KEY `id_map_sector` (`id_map_sector`),
  CONSTRAINT `maps_seats_ibfk_1` FOREIGN KEY (`id_map`) REFERENCES `maps` (`id`),
  CONSTRAINT `maps_seats_ibfk_2` FOREIGN KEY (`id_map_sector`) REFERENCES `maps_sector` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=275 DEFAULT CHARSET=utf8;

/*Table structure for table `maps_seats_icons` */

DROP TABLE IF EXISTS `maps_seats_icons`;

CREATE TABLE `maps_seats_icons` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `img_or_html` varchar(10) DEFAULT NULL COMMENT 'Define o ícone vai ser uma IMG estática ou SVG/Canvas',
  `img` varchar(100) DEFAULT NULL COMMENT 'Nome da imagem que representa o ícone',
  `html` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `maps_sector` */

DROP TABLE IF EXISTS `maps_sector`;

CREATE TABLE `maps_sector` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_map` int(10) unsigned DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `img_or_html` varchar(10) DEFAULT NULL,
  `img` varchar(255) DEFAULT NULL,
  `html` longtext,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id_map` (`id_map`),
  CONSTRAINT `maps_sector_ibfk_1` FOREIGN KEY (`id_map`) REFERENCES `maps` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

/*Table structure for table `newsletter` */

DROP TABLE IF EXISTS `newsletter`;

CREATE TABLE `newsletter` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(150) DEFAULT NULL,
  `session` varchar(500) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8;

/*Table structure for table `order_sale` */

DROP TABLE IF EXISTS `order_sale`;

CREATE TABLE `order_sale` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `id_order` int(10) unsigned NOT NULL,
  `id_sale` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  KEY `id` (`id`),
  KEY `id_order` (`id_order`),
  KEY `id_sale` (`id_sale`),
  CONSTRAINT `order_sale_ibfk_1` FOREIGN KEY (`id_order`) REFERENCES `orders` (`id`),
  CONSTRAINT `order_sale_ibfk_2` FOREIGN KEY (`id_sale`) REFERENCES `sales` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10177 DEFAULT CHARSET=utf8 COMMENT='Faz o vinculo entre uma ORDEM de compra e as SALES vendas para cada evento';

/*Table structure for table `orders` */

DROP TABLE IF EXISTS `orders`;

CREATE TABLE `orders` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID da ordem de compra',
  `id_customer` int(11) unsigned DEFAULT NULL COMMENT 'Cliente',
  `id_payment_type` int(11) unsigned DEFAULT NULL COMMENT 'Forma de pgto',
  `id_sale_point` int(11) unsigned DEFAULT NULL COMMENT 'PDV',
  `id_sale_terminal` int(11) unsigned DEFAULT NULL COMMENT 'POS',
  `id_orders_status` tinyint(2) unsigned DEFAULT '1' COMMENT 'Status da ordem de compra - se foi recebida ou cancelada',
  `id_orders_payment_status` tinyint(2) unsigned DEFAULT '1' COMMENT 'Status do pgto - Se falta pagar, foi pago, reembolsado, expirado',
  `id_billing_address` int(10) unsigned DEFAULT NULL COMMENT 'Qdo o Customer já tem cadastro - Usa algum dos Billing Address que ele já tem',
  `value_total` decimal(10,2) DEFAULT NULL COMMENT 'Valor total do pedido',
  `value_tax` decimal(10,2) DEFAULT NULL COMMENT 'Valor total dos impostos',
  `value_interest` decimal(10,2) DEFAULT '0.00' COMMENT 'Valor total de juros d parcelamento',
  `installments` tinyint(2) DEFAULT '1' COMMENT 'Parcelas',
  `email_sent` tinyint(1) unsigned DEFAULT '0' COMMENT '0 -> nao | 1 -> sim',
  `send_to_email` varchar(100) DEFAULT NULL COMMENT 'Email para qual o pedido será enviado - Isto é resultado da venda no PDV',
  `customer_id` varchar(100) DEFAULT NULL COMMENT 'ID do comprador no PDV - Usado para validar o acesso aos ingressos',
  `billing_address` text COMMENT 'Dados de cobrança do cartao',
  `ref` varchar(100) DEFAULT NULL COMMENT 'Referencia de indicação - Passado pelo link - Pode ser comissário ou qualquer coisa',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `created` (`created_at`),
  KEY `payment_type` (`id_payment_type`),
  KEY `value_total` (`value_total`),
  KEY `status` (`id_orders_status`),
  KEY `id_customer` (`id_customer`),
  KEY `sale_point` (`id_sale_point`),
  KEY `sale_terminal` (`id_sale_terminal`),
  KEY `id_orders_payment_status` (`id_orders_payment_status`),
  KEY `referencia_indicacao` (`ref`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`id_customer`) REFERENCES `customers` (`id`),
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`id_payment_type`) REFERENCES `payment_types` (`id`),
  CONSTRAINT `orders_ibfk_3` FOREIGN KEY (`id_orders_status`) REFERENCES `orders_status` (`id`),
  CONSTRAINT `orders_ibfk_4` FOREIGN KEY (`id_sale_point`) REFERENCES `sales_points` (`id`),
  CONSTRAINT `orders_ibfk_5` FOREIGN KEY (`id_sale_terminal`) REFERENCES `sales_terminal` (`id`),
  CONSTRAINT `orders_ibfk_6` FOREIGN KEY (`id_orders_payment_status`) REFERENCES `orders_payment_status` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10398 DEFAULT CHARSET=utf8 COMMENT='Cada compra no site, gera um registro ORDER, que podem conter vários eventos SALES';

/*Table structure for table `orders_payment` */

DROP TABLE IF EXISTS `orders_payment`;

CREATE TABLE `orders_payment` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID do PGTO',
  `id_order` int(10) unsigned DEFAULT NULL COMMENT 'ID do pedido',
  `id_payment_type` int(10) unsigned DEFAULT NULL COMMENT 'Forma de pgto',
  `amount` decimal(10,2) DEFAULT NULL COMMENT 'Valor do pagamento',
  `expiration_date` timestamp NULL DEFAULT NULL COMMENT 'Vencimento deste pgto - Mais utilizado se for boleto',
  `release_date` timestamp NULL DEFAULT NULL COMMENT 'Data liberação do dinheiro - Utilizado para repasse ao organizador',
  `cc_name` varchar(100) DEFAULT NULL COMMENT 'Nome no cartao de credito',
  `cc_number` varchar(50) DEFAULT NULL COMMENT 'Numero do cartao',
  `cc_expiration` varchar(20) DEFAULT NULL COMMENT 'Expiracao',
  `cc_cvv` varchar(10) DEFAULT NULL COMMENT 'Cod Seguranca',
  `cc_zipcode` varchar(20) DEFAULT NULL COMMENT 'ZIP code do billing address',
  `cc_authcode` varchar(100) DEFAULT NULL,
  `cc_transactionid` varchar(100) DEFAULT NULL,
  `cc_response` mediumtext COMMENT 'Resposta da transacao de cartao',
  `billet_number` varchar(200) DEFAULT NULL,
  `billet_expiration` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id_order` (`id_order`),
  KEY `id_payment_type` (`id_payment_type`),
  CONSTRAINT `orders_payment_ibfk_1` FOREIGN KEY (`id_order`) REFERENCES `orders` (`id`),
  CONSTRAINT `orders_payment_ibfk_4` FOREIGN KEY (`id_payment_type`) REFERENCES `payment_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8515 DEFAULT CHARSET=utf8 COMMENT='Esta tabela faz o vinculo entre a COMPRA e o PGTO (Sale x Payment)\r\nTambém registra os dados do pgto - Mas as parcelas ficam na tabela payments\r\nPois pode ocorrer um pedido com mais de 1 evento - Cada evento gera um pedido - No futuro pode haver outras formas de pgto';

/*Table structure for table `orders_payment_status` */

DROP TABLE IF EXISTS `orders_payment_status`;

CREATE TABLE `orders_payment_status` (
  `id` tinyint(2) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

/*Table structure for table `orders_status` */

DROP TABLE IF EXISTS `orders_status`;

CREATE TABLE `orders_status` (
  `id` tinyint(2) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL COMMENT 'Nome do Status',
  `description` varchar(500) DEFAULT NULL COMMENT 'Descrição - Complemento para facilitar - visivel ao usuario',
  `private_description` varchar(500) DEFAULT NULL COMMENT 'Decrição interna - Nao é visível pro usuario',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

/*Table structure for table `organizers` */

DROP TABLE IF EXISTS `organizers`;

CREATE TABLE `organizers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `slug` varchar(255) DEFAULT NULL COMMENT 'url utilizada para listar os eventos embeded',
  `description` text,
  `information` text,
  `negotiation` text COMMENT 'Negociaçao padrao do organizador',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8;

/*Table structure for table `payment_types` */

DROP TABLE IF EXISTS `payment_types`;

CREATE TABLE `payment_types` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;

/*Table structure for table `payments` */

DROP TABLE IF EXISTS `payments`;

CREATE TABLE `payments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_payment_type` int(10) unsigned DEFAULT NULL,
  `id_sale` int(10) unsigned DEFAULT NULL,
  `id_order` int(10) unsigned DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL COMMENT 'Valor deste pgto/parcela',
  `parcel` int(11) DEFAULT NULL COMMENT 'Numero desta parcela',
  `id_cc` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id_payment_type` (`id_payment_type`),
  CONSTRAINT `payment-type` FOREIGN KEY (`id_payment_type`) REFERENCES `payment_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `performers` */

DROP TABLE IF EXISTS `performers`;

CREATE TABLE `performers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `logo` varchar(100) DEFAULT NULL,
  `description` text,
  `type` varchar(50) DEFAULT NULL COMMENT 'Usado para os metadatas schema',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Table structure for table `performers_images` */

DROP TABLE IF EXISTS `performers_images`;

CREATE TABLE `performers_images` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_performer` int(10) unsigned NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `order` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id_performer` (`id_performer`),
  CONSTRAINT `performers_images_ibfk_1` FOREIGN KEY (`id_performer`) REFERENCES `performers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `permissions` */

DROP TABLE IF EXISTS `permissions`;

CREATE TABLE `permissions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `profilesId` int(10) unsigned NOT NULL,
  `resource` varchar(16) NOT NULL,
  `action` varchar(16) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `profilesId` (`profilesId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `places` */

DROP TABLE IF EXISTS `places`;

CREATE TABLE `places` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `location` text,
  `description` text,
  `id_city` int(10) unsigned DEFAULT NULL,
  `id_region` int(10) unsigned DEFAULT NULL,
  `id_country` int(10) unsigned DEFAULT NULL,
  `zipcode` varchar(20) DEFAULT NULL,
  `gps` varchar(200) DEFAULT NULL COMMENT 'Latitude e Longitude - Carrega o mapa do local',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `city_idx` (`id_city`),
  KEY `region_idx` (`id_region`),
  KEY `country_idx` (`id_country`),
  CONSTRAINT `city-place` FOREIGN KEY (`id_city`) REFERENCES `cities` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `country-place` FOREIGN KEY (`id_country`) REFERENCES `countries` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `region-place` FOREIGN KEY (`id_region`) REFERENCES `regions` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8;

/*Table structure for table `places_maps` */

DROP TABLE IF EXISTS `places_maps`;

CREATE TABLE `places_maps` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_map` int(10) unsigned DEFAULT NULL,
  `id_place` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_map` (`id_map`),
  KEY `id_place` (`id_place`),
  CONSTRAINT `places_maps_ibfk_1` FOREIGN KEY (`id_map`) REFERENCES `maps` (`id`),
  CONSTRAINT `places_maps_ibfk_2` FOREIGN KEY (`id_place`) REFERENCES `places` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Table structure for table `products` */

DROP TABLE IF EXISTS `products`;

CREATE TABLE `products` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_event` int(10) unsigned DEFAULT NULL,
  `id_genre` int(10) unsigned DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `description` text,
  `current_lot` tinyint(2) unsigned DEFAULT NULL,
  `fraction` tinyint(2) DEFAULT '1' COMMENT 'Produto fracionado - 1 é o padrão',
  `priority` int(10) unsigned DEFAULT '0',
  `show_previous_lot` tinyint(1) DEFAULT '0' COMMENT 'Mostra lotes anteriores - 0->NAO | 1-> SIM-Todos | 2->Somente o anterior',
  `show_next_lot` tinyint(1) DEFAULT '0' COMMENT 'Mostra próximos lotes - 0->NAO | 1-> SIM-Todos | 2->Somente o próximo',
  `hidden` tinyint(1) DEFAULT '0' COMMENT 'Produto OCULTO - Usado para exibir qdo utilizar CUPOM de desconto',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `event_idx` (`id_event`),
  KEY `genre_idx` (`id_genre`),
  CONSTRAINT `event-products` FOREIGN KEY (`id_event`) REFERENCES `events` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `genre-products` FOREIGN KEY (`id_genre`) REFERENCES `products_genres` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=268 DEFAULT CHARSET=utf8;

/*Table structure for table `products_genres` */

DROP TABLE IF EXISTS `products_genres`;

CREATE TABLE `products_genres` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Table structure for table `products_groups` */

DROP TABLE IF EXISTS `products_groups`;

CREATE TABLE `products_groups` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_event` int(10) unsigned DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY `id` (`id`),
  KEY `id_event` (`id_event`),
  CONSTRAINT `products_groups_ibfk_1` FOREIGN KEY (`id_event`) REFERENCES `events` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `products_lots` */

DROP TABLE IF EXISTS `products_lots`;

CREATE TABLE `products_lots` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_event` int(10) unsigned DEFAULT NULL,
  `id_product` int(10) unsigned NOT NULL,
  `id_type` int(10) unsigned NOT NULL,
  `lot_number` int(5) unsigned DEFAULT NULL,
  `lot_name` varchar(50) DEFAULT NULL COMMENT 'Este nome substitui o numero do lote - Ex: Promocional',
  `price` decimal(10,2) DEFAULT NULL COMMENT 'Valor deste produto neste lote',
  `tax` decimal(10,2) DEFAULT NULL COMMENT 'Imposto sobre o valor do produto',
  `id_product_group` int(11) unsigned DEFAULT NULL COMMENT 'Grupo ao qual esta vinculado - pode ser nulo',
  `date_start` timestamp NULL DEFAULT NULL,
  `date_end` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`id_product`),
  KEY `type_idx` (`id_type`),
  KEY `event_idx` (`id_event`),
  KEY `product-products_lots` (`id_product`),
  CONSTRAINT `event-products_lots` FOREIGN KEY (`id_event`) REFERENCES `events` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `product-products_lots` FOREIGN KEY (`id_product`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `type-products_lots` FOREIGN KEY (`id_type`) REFERENCES `products_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=475 DEFAULT CHARSET=utf8;

/*Table structure for table `products_sales` */

DROP TABLE IF EXISTS `products_sales`;

CREATE TABLE `products_sales` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_event` int(10) unsigned DEFAULT NULL COMMENT 'Evento',
  `id_product` int(10) unsigned DEFAULT NULL COMMENT 'Produto',
  `id_type` int(10) unsigned DEFAULT NULL,
  `id_sale_point` int(10) unsigned DEFAULT NULL COMMENT 'PDV',
  `id_fee` int(10) unsigned DEFAULT NULL COMMENT 'ID da taxa cobrada para nossa empresa',
  `id_fee_org` int(10) unsigned DEFAULT NULL COMMENT 'ID da taxa do organizador - sera repassado pra ele',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `product_idx` (`id_product`),
  KEY `sale_point_idx` (`id_sale_point`),
  KEY `fee_idx` (`id_fee`),
  KEY `event_idx` (`id_event`),
  KEY `id_fee_org` (`id_fee_org`),
  KEY `products_sales_ibfk_1` (`id_type`),
  CONSTRAINT `event-products_sales` FOREIGN KEY (`id_event`) REFERENCES `events` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fee-products_sales` FOREIGN KEY (`id_fee`) REFERENCES `fees` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `free_org-product_sales` FOREIGN KEY (`id_fee_org`) REFERENCES `fees_org` (`id`),
  CONSTRAINT `product-products_sales` FOREIGN KEY (`id_product`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `products_sales_ibfk_1` FOREIGN KEY (`id_type`) REFERENCES `products_types` (`id`),
  CONSTRAINT `sale_point-products_sales` FOREIGN KEY (`id_sale_point`) REFERENCES `sales_points` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1410 DEFAULT CHARSET=utf8;

/*Table structure for table `products_sales_limit` */

DROP TABLE IF EXISTS `products_sales_limit`;

CREATE TABLE `products_sales_limit` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_event` int(10) unsigned NOT NULL,
  `id_product` int(10) unsigned DEFAULT NULL,
  `id_product_group` int(11) unsigned DEFAULT NULL,
  `id_product_type` int(10) unsigned DEFAULT NULL,
  `id_sale_point` int(10) unsigned DEFAULT NULL,
  `product_lot` int(10) unsigned DEFAULT NULL,
  `sales_limit` int(11) DEFAULT '0' COMMENT 'Quantidade que pode ser vendida',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `key_unique` (`id_event`,`id_product`,`id_product_group`,`id_product_type`,`id_sale_point`,`product_lot`),
  KEY `id` (`id`),
  KEY `id_product` (`id_product`),
  KEY `id_product_group` (`id_product_group`),
  KEY `id_product_type` (`id_product_type`),
  KEY `id_sale_point` (`id_sale_point`),
  CONSTRAINT `products_sales_limit_ibfk_2` FOREIGN KEY (`id_product`) REFERENCES `products` (`id`),
  CONSTRAINT `products_sales_limit_ibfk_3` FOREIGN KEY (`id_product_group`) REFERENCES `products_groups` (`id`),
  CONSTRAINT `products_sales_limit_ibfk_4` FOREIGN KEY (`id_product_type`) REFERENCES `products_types` (`id`),
  CONSTRAINT `products_sales_limit_ibfk_5` FOREIGN KEY (`id_sale_point`) REFERENCES `sales_points` (`id`),
  CONSTRAINT `products_sales_limit_ibfk_6` FOREIGN KEY (`id_event`) REFERENCES `events` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=273 DEFAULT CHARSET=utf8;

/*Table structure for table `products_type_groups` */

DROP TABLE IF EXISTS `products_type_groups`;

CREATE TABLE `products_type_groups` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_product_group` int(10) unsigned DEFAULT NULL,
  `id_product` int(10) unsigned DEFAULT NULL,
  `id_product_type` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `id_group` (`id_product_group`,`id_product`,`id_product_type`),
  KEY `id` (`id`),
  KEY `id_product` (`id_product`),
  KEY `id_product_type` (`id_product_type`),
  CONSTRAINT `products_type_groups_ibfk_1` FOREIGN KEY (`id_product_group`) REFERENCES `products_groups` (`id`),
  CONSTRAINT `products_type_groups_ibfk_2` FOREIGN KEY (`id_product`) REFERENCES `products` (`id`),
  CONSTRAINT `products_type_groups_ibfk_3` FOREIGN KEY (`id_product_type`) REFERENCES `products_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `products_types` */

DROP TABLE IF EXISTS `products_types`;

CREATE TABLE `products_types` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

/*Table structure for table `profiles` */

DROP TABLE IF EXISTS `profiles`;

CREATE TABLE `profiles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `active` char(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `active` (`active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `regions` */

DROP TABLE IF EXISTS `regions`;

CREATE TABLE `regions` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL COMMENT 'Nome do estado',
  `id_country` int(11) unsigned DEFAULT NULL COMMENT 'ID do país',
  `acronym` varchar(10) DEFAULT NULL COMMENT 'Abreviatura',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id_country` (`id_country`),
  KEY `acronym` (`acronym`),
  CONSTRAINT `country-regions` FOREIGN KEY (`id_country`) REFERENCES `countries` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8;

/*Table structure for table `sales` */

DROP TABLE IF EXISTS `sales`;

CREATE TABLE `sales` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_order` int(11) unsigned DEFAULT NULL COMMENT 'Numero da ORDER',
  `id_event` int(10) unsigned NOT NULL COMMENT 'Evento',
  `id_customer` int(10) unsigned DEFAULT NULL COMMENT 'Cliente',
  `id_sale_point` int(10) unsigned DEFAULT NULL COMMENT 'Numero do PDV',
  `id_sale_terminal` int(10) unsigned DEFAULT NULL COMMENT 'Numero da POS',
  `id_payment_type` int(10) unsigned DEFAULT NULL COMMENT 'Tipo de pagamento',
  `id_delivery_type` int(10) unsigned DEFAULT NULL COMMENT 'Tipo de entrega',
  `value_total` decimal(10,2) DEFAULT NULL COMMENT 'Valor total desta compra',
  `value_product` decimal(10,2) DEFAULT NULL COMMENT 'Valor dos produtos',
  `value_product_tax` decimal(10,2) DEFAULT NULL COMMENT 'Valor de imposto sobre o produto',
  `value_fee` decimal(10,2) DEFAULT NULL COMMENT 'Valor da taxa',
  `value_fee_tax` decimal(10,2) DEFAULT NULL COMMENT 'Valor do imposto sobre a taxa',
  `value_fee_org` decimal(10,2) DEFAULT NULL COMMENT 'Valor da taxa do organizador',
  `value_fee_org_tax` decimal(10,2) DEFAULT NULL COMMENT 'Valor do imposto sobre a taxa do organizador',
  `value_interest` decimal(10,2) DEFAULT NULL COMMENT 'Valor do juros',
  `value_interest_tax` decimal(10,2) DEFAULT NULL COMMENT 'Valor do imposto sobre o juros',
  `value_delivery` decimal(10,2) DEFAULT NULL COMMENT 'Valor da entrega',
  `value_delivery_tax` decimal(10,2) DEFAULT NULL COMMENT 'valor do imposto sobre o custo de entrega',
  `installments` tinyint(2) DEFAULT '1' COMMENT 'Qtd de parcelas',
  `status` tinyint(2) unsigned DEFAULT '1',
  `id_identifier` int(10) unsigned DEFAULT NULL COMMENT 'ID do IDENTIFIER para relacionar com CODE do localizador',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `customer_idx` (`id_customer`),
  KEY `sale_point_idx` (`id_sale_point`),
  KEY `sale_terminal_idx` (`id_sale_terminal`),
  KEY `payment_idx` (`id_payment_type`),
  KEY `delivery_idx` (`id_delivery_type`),
  KEY `event_idx` (`id_event`),
  KEY `sales-status` (`status`),
  KEY `id_order` (`id_order`),
  KEY `id_identifier` (`id_identifier`),
  CONSTRAINT `delivery-sales` FOREIGN KEY (`id_delivery_type`) REFERENCES `delivery_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `payment-sales` FOREIGN KEY (`id_payment_type`) REFERENCES `payment_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `sale_point-sales` FOREIGN KEY (`id_sale_point`) REFERENCES `sales_points` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `sale_terminal-sales` FOREIGN KEY (`id_sale_terminal`) REFERENCES `sales_terminal` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `sales-customers` FOREIGN KEY (`id_customer`) REFERENCES `customers` (`id`),
  CONSTRAINT `sales-status` FOREIGN KEY (`status`) REFERENCES `sales_status` (`id`),
  CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`id_event`) REFERENCES `events` (`id`),
  CONSTRAINT `sales_ibfk_2` FOREIGN KEY (`id_order`) REFERENCES `orders` (`id`),
  CONSTRAINT `sales_ibfk_3` FOREIGN KEY (`id_identifier`) REFERENCES `identifier` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10179 DEFAULT CHARSET=utf8;

/*Table structure for table `sales_items` */

DROP TABLE IF EXISTS `sales_items`;

CREATE TABLE `sales_items` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ticket` varchar(10) DEFAULT NULL COMMENT 'codigo do ingresso',
  `status` int(10) unsigned DEFAULT NULL,
  `validated` enum('0','1') DEFAULT '0' COMMENT '0-NÃO | 1-SIM',
  `validated_at` timestamp NULL DEFAULT NULL,
  `id_sale` int(10) unsigned DEFAULT NULL COMMENT 'Codigo da venda',
  `id_event` int(10) unsigned DEFAULT NULL COMMENT 'Codigo do evento',
  `id_product` int(10) unsigned DEFAULT NULL COMMENT 'Codigo do produto',
  `id_product_type` int(10) unsigned DEFAULT NULL COMMENT 'Codigo do tipo produto',
  `product_lot` int(10) unsigned DEFAULT NULL COMMENT 'Lote em qual foi vendido',
  `value_product` decimal(10,2) DEFAULT NULL COMMENT 'Valor do produto',
  `value_product_tax` decimal(10,2) DEFAULT NULL COMMENT 'Valor imposto sobre produto',
  `value_fee` decimal(10,2) DEFAULT NULL COMMENT 'Valor taxa',
  `value_fee_tax` decimal(10,2) DEFAULT NULL COMMENT 'Valor imposto sobre taxa',
  `value_fee_org` decimal(10,2) DEFAULT NULL COMMENT 'Valor taxa do organizador',
  `value_fee_org_tax` decimal(10,2) DEFAULT NULL COMMENT 'Valor imposto da taxa organizador',
  `fraction` tinyint(2) DEFAULT '1' COMMENT 'Fração do produto',
  `ticket_sequence` tinyint(2) DEFAULT '1' COMMENT 'sequencia - ordem de todos tickets no pedido',
  `product_sequence` tinyint(2) DEFAULT '1' COMMENT 'Sequencia- ordem do mesmo produto',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `sale_idx` (`id_sale`),
  KEY `product_idx` (`id_product`),
  KEY `product_type_idx` (`id_product_type`),
  KEY `ticket` (`ticket`),
  KEY `status_idx` (`status`),
  KEY `event-sale` (`id_event`),
  KEY `value_product` (`value_product`),
  KEY `validated` (`validated`),
  CONSTRAINT `event-sale` FOREIGN KEY (`id_event`) REFERENCES `events` (`id`),
  CONSTRAINT `product-sales_items` FOREIGN KEY (`id_product`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `product_type-sales_items` FOREIGN KEY (`id_product_type`) REFERENCES `products_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `sale-sales_items` FOREIGN KEY (`id_sale`) REFERENCES `sales` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `status-sales_items` FOREIGN KEY (`status`) REFERENCES `tickets_status` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=19855 DEFAULT CHARSET=utf8;

/*Table structure for table `sales_payment` */

DROP TABLE IF EXISTS `sales_payment`;

CREATE TABLE `sales_payment` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID do PGTO',
  `id_sale` int(10) unsigned DEFAULT NULL COMMENT 'ID da venda',
  `id_payment` int(10) unsigned DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL COMMENT 'Valor do pagamento',
  `id_payment_type` int(10) unsigned DEFAULT NULL COMMENT 'Forma de pgto',
  `expiration_date` timestamp NULL DEFAULT NULL,
  `id_cc` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  KEY `id` (`id`),
  KEY `sale` (`id_sale`),
  KEY `payment_type` (`id_payment_type`),
  KEY `sale_payment` (`id_payment`),
  CONSTRAINT `sales_payment_ibfk_1` FOREIGN KEY (`id_sale`) REFERENCES `sales` (`id`),
  CONSTRAINT `sales_payment_ibfk_2` FOREIGN KEY (`id_payment_type`) REFERENCES `payment_types` (`id`),
  CONSTRAINT `sales_payment_type` FOREIGN KEY (`id_payment`) REFERENCES `payments` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Esta tabela faz o vinculo entre a COMPRA e o PGTO (Sale x Payment)\r\nPois pode ocorrer um pedido com mais de 1 evento - Cada evento gera um pedido - No futuro pode haver outras formas de pgto';

/*Table structure for table `sales_points` */

DROP TABLE IF EXISTS `sales_points`;

CREATE TABLE `sales_points` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `id_organizer` int(11) unsigned DEFAULT NULL,
  `description` text,
  `information` text,
  `default_fee` int(11) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `organizer_idx` (`id_organizer`),
  CONSTRAINT `organizer_sales_points` FOREIGN KEY (`id_organizer`) REFERENCES `organizers` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8;

/*Table structure for table `sales_points_payment_type` */

DROP TABLE IF EXISTS `sales_points_payment_type`;

CREATE TABLE `sales_points_payment_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_sale_point` int(10) unsigned DEFAULT NULL,
  `id_payment_type` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `id_sale_point` (`id_sale_point`),
  KEY `id_payment_type` (`id_payment_type`),
  CONSTRAINT `sales_points_payment_type_ibfk_1` FOREIGN KEY (`id_sale_point`) REFERENCES `sales_points` (`id`),
  CONSTRAINT `sales_points_payment_type_ibfk_2` FOREIGN KEY (`id_payment_type`) REFERENCES `payment_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=147 DEFAULT CHARSET=utf8;

/*Table structure for table `sales_status` */

DROP TABLE IF EXISTS `sales_status`;

CREATE TABLE `sales_status` (
  `id` tinyint(2) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  `private_description` varchar(500) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

/*Table structure for table `sales_terminal` */

DROP TABLE IF EXISTS `sales_terminal`;

CREATE TABLE `sales_terminal` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `id_sales_points` int(11) unsigned DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `description` text,
  `password` varchar(100) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `serial` varchar(100) DEFAULT NULL,
  `token_embedded` varchar(100) DEFAULT NULL COMMENT 'Caso possua EMBEDDED - vincula o TOKEN',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id_sales_points` (`id_sales_points`),
  KEY `email` (`email`),
  KEY `serial` (`serial`),
  KEY `token_embedded` (`token_embedded`),
  CONSTRAINT `sales_terminal_ibfk_1` FOREIGN KEY (`id_sales_points`) REFERENCES `sales_points` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=130 DEFAULT CHARSET=utf8;

/*Table structure for table `terminal_withdrawal` */

DROP TABLE IF EXISTS `terminal_withdrawal`;

CREATE TABLE `terminal_withdrawal` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_event` int(10) unsigned NOT NULL COMMENT 'Evento',
  `id_sale_point` int(10) unsigned DEFAULT NULL COMMENT 'Numero do PDV',
  `id_sale_terminal` int(10) unsigned DEFAULT NULL COMMENT 'Numero da POS',
  `id_payment_type` int(10) unsigned DEFAULT NULL COMMENT 'Tipo de pagamento',
  `value_total` decimal(10,2) DEFAULT NULL COMMENT 'Valor total desta compra',
  `value_product` decimal(10,2) DEFAULT NULL COMMENT 'Valor dos produtos',
  `value_product_tax` decimal(10,2) DEFAULT NULL COMMENT 'Valor de imposto sobre o produto',
  `value_fee` decimal(10,2) DEFAULT NULL COMMENT 'Valor da taxa',
  `value_fee_tax` decimal(10,2) DEFAULT NULL COMMENT 'Valor do imposto sobre a taxa',
  `value_fee_org` decimal(10,2) DEFAULT NULL COMMENT 'Valor da taxa do organizador',
  `value_fee_org_tax` decimal(10,2) DEFAULT NULL COMMENT 'Valor do imposto sobre a taxa do organizador',
  `value_interest` decimal(10,2) DEFAULT NULL COMMENT 'Valor do juros',
  `value_interest_tax` decimal(10,2) DEFAULT NULL COMMENT 'Valor do imposto sobre o juros',
  `value_delivery` decimal(10,2) DEFAULT NULL COMMENT 'Valor da entrega',
  `value_delivery_tax` decimal(10,2) DEFAULT NULL COMMENT 'valor do imposto sobre o custo de entrega',
  `status` tinyint(2) unsigned DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `sale_point_idx` (`id_sale_point`),
  KEY `sale_terminal_idx` (`id_sale_terminal`),
  KEY `payment_idx` (`id_payment_type`),
  KEY `event_idx` (`id_event`),
  KEY `sales-status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

/*Table structure for table `ticket_extra_data` */

DROP TABLE IF EXISTS `ticket_extra_data`;

CREATE TABLE `ticket_extra_data` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_event` int(11) unsigned DEFAULT NULL,
  `ticket` varchar(10) DEFAULT NULL,
  `id_extra_data` int(10) unsigned DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `chave_unica` (`id_event`,`ticket`,`id_extra_data`),
  KEY `id` (`id`),
  KEY `id_extra_data` (`id_extra_data`),
  KEY `ticket` (`ticket`),
  KEY `id_event` (`id_event`),
  CONSTRAINT `ticket_extra_data_ibfk_1` FOREIGN KEY (`id_extra_data`) REFERENCES `extra_data` (`id`),
  CONSTRAINT `ticket_extra_data_ibfk_2` FOREIGN KEY (`id_event`) REFERENCES `events` (`id`),
  CONSTRAINT `ticket_extra_data_ibfk_3` FOREIGN KEY (`ticket`) REFERENCES `sales_items` (`ticket`)
) ENGINE=InnoDB AUTO_INCREMENT=1253 DEFAULT CHARSET=utf8;

/*Table structure for table `ticket_stock` */

DROP TABLE IF EXISTS `ticket_stock`;

CREATE TABLE `ticket_stock` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ticket` varchar(50) NOT NULL,
  `status` enum('0','1','2') DEFAULT '0' COMMENT '0->Disponivel | 1->Utilizado | 2->Validado pelo Array',
  `id_event` int(11) unsigned NOT NULL,
  `id_product` int(10) unsigned DEFAULT NULL,
  `id_product_type` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ticket_2` (`ticket`,`id_event`),
  KEY `ticket` (`ticket`),
  KEY `id_event` (`id_event`),
  KEY `id_product` (`id_product`),
  KEY `id_product_type` (`id_product_type`),
  KEY `status` (`status`),
  CONSTRAINT `ticket_stock_ibfk_1` FOREIGN KEY (`id_event`) REFERENCES `events` (`id`),
  CONSTRAINT `ticket_stock_ibfk_2` FOREIGN KEY (`id_product`) REFERENCES `products` (`id`),
  CONSTRAINT `ticket_stock_ibfk_3` FOREIGN KEY (`id_product_type`) REFERENCES `products_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `ticket_validation` */

DROP TABLE IF EXISTS `ticket_validation`;

CREATE TABLE `ticket_validation` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `id_event` int(11) unsigned NOT NULL,
  `ticket` varchar(200) NOT NULL,
  `status` int(10) unsigned NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id_event` (`id_event`),
  KEY `ticket` (`ticket`),
  KEY `created_at` (`created_at`),
  KEY `status` (`status`),
  CONSTRAINT `ticket_validation_ibfk_1` FOREIGN KEY (`id_event`) REFERENCES `events` (`id`),
  CONSTRAINT `ticket_validation_ibfk_3` FOREIGN KEY (`status`) REFERENCES `ticket_validation_status` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=276 DEFAULT CHARSET=utf8;

/*Table structure for table `ticket_validation_status` */

DROP TABLE IF EXISTS `ticket_validation_status`;

CREATE TABLE `ticket_validation_status` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

/*Table structure for table `tickets_status` */

DROP TABLE IF EXISTS `tickets_status`;

CREATE TABLE `tickets_status` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `name_private` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

/*Table structure for table `users` */

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(250) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8;

/*Table structure for table `users_events` */

DROP TABLE IF EXISTS `users_events`;

CREATE TABLE `users_events` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_user` int(10) unsigned NOT NULL,
  `id_event` int(10) unsigned NOT NULL,
  `active` tinyint(1) DEFAULT '0' COMMENT '0->NAO | 1->SIM',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `chave` (`id_user`,`id_event`),
  KEY `id_user` (`id_user`),
  KEY `id_event` (`id_event`),
  CONSTRAINT `users_events_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `users` (`id`),
  CONSTRAINT `users_events_ibfk_2` FOREIGN KEY (`id_event`) REFERENCES `events` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1356 DEFAULT CHARSET=utf8;

/*Table structure for table `users_organizers` */

DROP TABLE IF EXISTS `users_organizers`;

CREATE TABLE `users_organizers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_user` int(10) unsigned NOT NULL,
  `id_organizer` int(10) unsigned DEFAULT NULL,
  `active` tinyint(1) DEFAULT '0' COMMENT '0->NAO | 1->SIM',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_user_2` (`id_user`,`id_organizer`),
  KEY `id_user` (`id_user`),
  KEY `id_organizer` (`id_organizer`),
  CONSTRAINT `users_organizers_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `users` (`id`),
  CONSTRAINT `users_organizers_ibfk_2` FOREIGN KEY (`id_organizer`) REFERENCES `organizers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=382 DEFAULT CHARSET=utf8;

/*Table structure for table `waiting_list` */

DROP TABLE IF EXISTS `waiting_list`;

CREATE TABLE `waiting_list` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_event` int(10) unsigned DEFAULT NULL,
  `email` varchar(200) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id_event` (`id_event`),
  CONSTRAINT `waiting_list_ibfk_1` FOREIGN KEY (`id_event`) REFERENCES `events` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `zipcode` */

DROP TABLE IF EXISTS `zipcode`;

CREATE TABLE `zipcode` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `zip` varchar(50) DEFAULT NULL,
  `id_city` int(11) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `id_region` int(11) unsigned DEFAULT NULL,
  `region` varchar(255) DEFAULT NULL,
  `id_country` int(11) DEFAULT NULL,
  `country` varchar(150) DEFAULT NULL,
  `lat` varchar(150) DEFAULT NULL,
  `lon` varchar(150) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY `id_region` (`id_region`),
  KEY `id` (`id`),
  CONSTRAINT `zipcode_ibfk_1` FOREIGN KEY (`id_region`) REFERENCES `regions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

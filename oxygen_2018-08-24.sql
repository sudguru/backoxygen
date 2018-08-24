# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: localhost (MySQL 5.7.17)
# Database: oxygen
# Generation Time: 2018-08-24 14:09:15 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table container_asset
# ------------------------------------------------------------

DROP TABLE IF EXISTS `container_asset`;

CREATE TABLE `container_asset` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `container_id` int(11) NOT NULL,
  `party_id` int(11) NOT NULL,
  `datetime` datetime NOT NULL,
  `added` double(10,2) NOT NULL,
  `deducted` double(10,2) NOT NULL,
  `remarks` text NOT NULL,
  `inital` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table container_inital_stock
# ------------------------------------------------------------

DROP TABLE IF EXISTS `container_inital_stock`;

CREATE TABLE `container_inital_stock` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `party_id` int(11) unsigned NOT NULL,
  `container_id` int(11) unsigned NOT NULL,
  `quantity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `party_id` (`party_id`),
  KEY `container_id` (`container_id`),
  CONSTRAINT `container_inital_stock_ibfk_1` FOREIGN KEY (`party_id`) REFERENCES `parties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `container_inital_stock_ibfk_2` FOREIGN KEY (`container_id`) REFERENCES `containers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table containers
# ------------------------------------------------------------

DROP TABLE IF EXISTS `containers`;

CREATE TABLE `containers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  `capacity` double(10,2) NOT NULL,
  `unit` varchar(20) NOT NULL DEFAULT '',
  `initial_quantity` double(10,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table parties
# ------------------------------------------------------------

DROP TABLE IF EXISTS `parties`;

CREATE TABLE `parties` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL DEFAULT '',
  `name` varchar(60) NOT NULL DEFAULT '',
  `address` varchar(100) NOT NULL DEFAULT '',
  `email` varchar(50) NOT NULL DEFAULT '',
  `deposit` double(15,2) NOT NULL DEFAULT '0.00',
  `initial_balance` double(15,2) DEFAULT NULL,
  `self` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `parties` WRITE;
/*!40000 ALTER TABLE `parties` DISABLE KEYS */;

INSERT INTO `parties` (`id`, `code`, `name`, `address`, `email`, `deposit`, `initial_balance`, `self`)
VALUES
	(11,'one','Party One','Sinamanagal','one@party.com',12000.00,12000.00,1),
	(12,'two','Party Two','Thamel','tow@party.com',30000.00,20000.00,0);

/*!40000 ALTER TABLE `parties` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table product_price
# ------------------------------------------------------------

DROP TABLE IF EXISTS `product_price`;

CREATE TABLE `product_price` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int(11) unsigned NOT NULL,
  `party_id` int(11) unsigned NOT NULL,
  `rate` double(15,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  KEY `party_id` (`party_id`),
  CONSTRAINT `product_price_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `product_price_ibfk_2` FOREIGN KEY (`party_id`) REFERENCES `parties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table products
# ------------------------------------------------------------

DROP TABLE IF EXISTS `products`;

CREATE TABLE `products` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  `unit` varchar(20) NOT NULL DEFAULT '',
  `base_rate` double(15,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table staffs
# ------------------------------------------------------------

DROP TABLE IF EXISTS `staffs`;

CREATE TABLE `staffs` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `party_id` int(11) NOT NULL,
  `name` varchar(60) NOT NULL DEFAULT '',
  `mobile` varchar(25) NOT NULL DEFAULT '',
  `email` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `staffs` WRITE;
/*!40000 ALTER TABLE `staffs` DISABLE KEYS */;

INSERT INTO `staffs` (`id`, `party_id`, `name`, `mobile`, `email`)
VALUES
	(1,10,'Hari Gopal','9851000899','harigopal@gmail.com'),
	(4,9,'Bigyan Lama','9876556356',''),
	(5,8,'Sumnima Pandey','9876787666','gurung_sudeep1972@gmail.com');

/*!40000 ALTER TABLE `staffs` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table transactions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `transactions`;

CREATE TABLE `transactions` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `in_out` varchar(3) NOT NULL DEFAULT '',
  `datetime` datetime NOT NULL,
  `user_id` int(11) NOT NULL,
  `from_party_id` int(11) NOT NULL,
  `from_staff_id` int(11) NOT NULL,
  `to_party_id` int(11) NOT NULL,
  `to_staff_id` int(11) NOT NULL,
  `remarks` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table transactions_detail
# ------------------------------------------------------------

DROP TABLE IF EXISTS `transactions_detail`;

CREATE TABLE `transactions_detail` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `transaction_id` int(11) NOT NULL,
  `full_or_empty` varchar(5) DEFAULT NULL,
  `container_id` int(11) DEFAULT NULL,
  `container_quantity` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `product_quantity` double(10,2) DEFAULT NULL,
  `product_rate` double(15,2) DEFAULT NULL,
  `discount` double(15,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL DEFAULT '',
  `isAdmin` tinyint(4) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

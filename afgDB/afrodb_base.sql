# ------------------------------------------------------------
# This file is part of the African Farmer Game - Multiplayer version.
#
# African Farmer Game - Multiplayer version is free software: you can redistribute 
# it and/or modify it under the terms of the GNU General Public License as published 
# by the Free Software Foundation, either version 3 of the License, or (at your option) 
# any later version.
#
# African Farmer Game - Multiplayer version is distributed in the hope that it will 
# be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of 
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public 
# License for more details.
#
# You should have received a copy of the GNU General Public License along with 
# African Farmer Game - Multiplayer version.  If not, see <http://www.gnu.org/licenses/>.
# ------------------------------------------------------------

# Ensure database 'afrodb' exists
# ------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS `afrodb2`;
USE `afrodb2`;

# ************************************************************
# Database: afrodb
# ************************************************************
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

# Dump of table asset_owners
# ------------------------------------------------------------

DROP TABLE IF EXISTS `asset_owners`;

CREATE TABLE `asset_owners` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `asset` int(11) DEFAULT NULL,
  `player_char` int(11) DEFAULT NULL,
  `hearth` int(11) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


# Dump of table assets
# ------------------------------------------------------------

DROP TABLE IF EXISTS `assets`;

CREATE TABLE `assets` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  `measurement` varchar(50) NOT NULL DEFAULT '',
  `edible` int(1) DEFAULT '0',
  `type` varchar(50) DEFAULT 'CROP',
  `subtype` varchar(50) DEFAULT NULL,
  `guide_buy_price` double DEFAULT NULL,
  `guide_sell_price` double DEFAULT NULL,
  `notes` text,
  `initial_stock` double DEFAULT NULL,
  `reclaim_order` INT(3) NOT NULL,
  `discriminator` varchar(50) NOT NULL DEFAULT 'ASSET',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

LOCK TABLES `assets` WRITE;
/*!40000 ALTER TABLE `assets` DISABLE KEYS */;

INSERT INTO `assets` (`id`, `name`, `measurement`, `edible`, `type`, `subtype`, `guide_buy_price`, `guide_sell_price`, `notes`, `initial_stock`, `reclaim_order`, `discriminator`)
VALUES
	(1,'Manure','Bag',0,'FERTILISER','ORGANIC',3,4,'Manure is a low-cost, highly available source of fertilisation for your fields.',30, 11, 'ASSET'),
	(2,'Maize','Bag',1,'FOOD','MAIZE',5,7,'Local maize is a low-cost variety of maize that produces lower yields than more expensive hybrid varieties. Nutritionally it is a good source of carbohydrate. This can be eaten or sown in the fields.',500, 12, 'ASSET_FOOD'),
	(3,'HY Maize Seed','Bag',1,'CROP','MAIZE',8,11,'High Yield Maize is a hybrid variety that can give significantly higher yields than local varieties. The yield is edible, but the seed is not.',300, 8, 'ASSET_CROP'),
	(4,'Cotton Seed','Bag',0,'CROP','COTTON',20,24,'Cotton seed grows into cotton for a high-value product.',150, 6, 'ASSET_CROP'),
	(5,'Herbicide','Drum',0,'HERBICIDE','HERBICIDE',6,8,'Spraying fields with herbicide is a labour-free alternative to hand weeding.',120, 4, 'ASSET'),
	(6,'Pesticide','Drum',0,'INSECTICIDE','INSECTICIDE',9,11,'Pesticide can help to mitigate the effects of crop hazards.',120, 5, 'ASSET'),
	(7,'Beans','Bag',1,'FOOD','BEAN',9,12,'Beans are a good source of protein. This can be eaten or sown in the fields.',250, 14, 'ASSET_FOOD'),
	(8,'Cash','Afri',0,'CASH','CASH',1,1,'Cash is useful for buying things, particularly from the market.',NULL,1,'ASSET'),
	(9,'NPK Fertiliser','Drum',0,'FERTILISER','INORGANIC',8,10,'NPK (Nitrogen-Phosphorus-Potassium) component fertilizers can significantly increase crop yields.',150, 10, 'ASSET'),
	(10,'DT Maize Seed','Bag',1,'CROP','MAIZE',12,14,'Drought-tolerant maize copes well with low rainfall. The yield is edible, but the seed is not.',250, 9, 'ASSET_CROP'),
	(11,'Horticulture','Bag',1,'FOOD','HORTICULTURE',12,15,'Horticulture is a good source of nutrients. This can be eaten or sown in the fields.',250, 13, 'ASSET_FOOD'),
	(12,'Spray Kit','Unit',0,'OTHER','OTHER',9,18,'A spray kit is used to apply both pesticide and herbicide.',60,2,'ASSET'),
	(13,'School Vouchers','Unit',0,'OTHER','OTHER',16,20,'These are required before you can send your children to school.',120,3,'ASSET'),
	(14,'Land','Field',0,'LAND','BUY',88,110,'Buy more land to plant with extra crops.',25,15,'ASSET_LAND'),
	(15,'Cotton','Bale',0,'OTHER','COTTON',20,24,'Cotton is a valuable cash crop.',0,7,'ASSET');

/*!40000 ALTER TABLE `assets` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table assets_crop
# ------------------------------------------------------------

DROP TABLE IF EXISTS `assets_crop`;

CREATE TABLE `assets_crop` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `asset` int(11) DEFAULT NULL,
  `ep_yield` int(11) DEFAULT NULL,
  `lp_yield` int(11) DEFAULT NULL,
  `outputAsset` int(11) DEFAULT NULL,
  `maturity` int(11) DEFAULT NULL,
  `weed_loss` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `assets_crop` WRITE;
/*!40000 ALTER TABLE `assets_crop` DISABLE KEYS */;

INSERT INTO `assets_crop` (`id`, `asset`, `ep_yield`, `lp_yield`, `outputAsset`, `maturity`, `weed_loss`)
VALUES
	(1,3,12,9,2,3,40),
	(2,4,13,10,15,3,40),
	(3,10,9,7,2,3,40);

/*!40000 ALTER TABLE `assets_crop` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table assets_food
# ------------------------------------------------------------

DROP TABLE IF EXISTS `assets_food`;

CREATE TABLE `assets_food` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `asset` int(11) NOT NULL,
  `protein` int(11) DEFAULT NULL,
  `nutrients` int(11) DEFAULT NULL,
  `carbs` int(11) DEFAULT NULL,
  `ep_yield` int(11) DEFAULT NULL,
  `lp_yield` int(11) DEFAULT NULL,
  `outputAsset` int(11) DEFAULT NULL,
  `maturity` int(11) DEFAULT NULL,
  `weed_loss` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `assets_food` WRITE;
/*!40000 ALTER TABLE `assets_food` DISABLE KEYS */;

INSERT INTO `assets_food` (`id`, `asset`, `protein`, `nutrients`, `carbs`, `ep_yield`, `lp_yield`, `outputAsset`, `maturity`, `weed_loss`)
VALUES
	(1,2,1,1,2,6,4,2,3,40),
	(2,7,2,1,1,9,6,7,3,40),
	(3,11,1,2,1,7,5,11,3,40);

/*!40000 ALTER TABLE `assets_food` ENABLE KEYS */;
UNLOCK TABLES;

# Dump of table character_all
# ------------------------------------------------------------

DROP TABLE IF EXISTS `character_all`;

CREATE TABLE `character_all` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `givenname` varchar(50) DEFAULT NULL,
  `familyname` varchar(50) DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

# Dump of table character_np
# ------------------------------------------------------------

DROP TABLE IF EXISTS `character_np`;

CREATE TABLE `character_np` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `diet` int(11) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `school` int(11) DEFAULT NULL,
  `parent` int(11) DEFAULT NULL,
  `allCharId` int(11) DEFAULT NULL,
  `hearth` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

# Dump of table character_player
# ------------------------------------------------------------

DROP TABLE IF EXISTS `character_player`;

CREATE TABLE `character_player` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `game` int(11) NOT NULL,
  `user` varchar(50) DEFAULT NULL,
  `avatarBody` int(11) DEFAULT NULL,
  `socialStatus` int(11) NOT NULL DEFAULT '5',
  `allCharId` int(11) DEFAULT NULL,
  `hearth` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

# Dump of table crop_hazard
# ------------------------------------------------------------

DROP TABLE IF EXISTS `crop_hazard`;

CREATE TABLE `crop_hazard` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  `probability` int(11) DEFAULT NULL,
  `notes` blob,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

LOCK TABLES `crop_hazard` WRITE;
/*!40000 ALTER TABLE `crop_hazard` DISABLE KEYS */;

INSERT INTO `crop_hazard` (`id`, `name`, `probability`, `notes`)
VALUES
	(1,'Army Worms',10,NULL),
	(2,'Stalk Borers',10,NULL),
	(3,'Rust',10,NULL),
	(4,'Bollworm',10,NULL),
	(5,'Fusarium Wilt',10,NULL),
	(6,'Root Rot',10,NULL),
	(7,'Leaf Blight',10,NULL);

/*!40000 ALTER TABLE `crop_hazard` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table crop_hazard_effect
# ------------------------------------------------------------

DROP TABLE IF EXISTS `crop_hazard_effect`;

CREATE TABLE `crop_hazard_effect` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `hazard` int(11) DEFAULT NULL,
  `crop` int(11) DEFAULT NULL,
  `planting` int(11) NOT NULL DEFAULT '0',
  `crop_age` int(11) DEFAULT NULL,
  `reduction` int(11) DEFAULT NULL,
  `mitigated` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

LOCK TABLES `crop_hazard_effect` WRITE;
/*!40000 ALTER TABLE `crop_hazard_effect` DISABLE KEYS */;

INSERT INTO `crop_hazard_effect` (`id`, `hazard`, `crop`, `planting`, `crop_age`, `reduction`, `mitigated`)
VALUES
	(1,1,2,0,1,35,16),
	(2,1,2,0,2,35,16),
	(3,1,2,1,1,35,16),
	(4,1,2,1,2,35,16),
	(5,1,10,0,1,35,16),
	(6,1,10,0,2,35,16),
	(7,1,10,1,1,35,16),
	(8,1,10,1,2,35,16),
	(9,1,3,0,1,35,16),
	(10,1,3,0,2,35,16),
	(11,1,3,1,1,35,16),
	(12,1,3,1,2,35,16),
	(13,2,2,0,1,35,16),
	(14,2,2,0,2,35,16),
	(15,2,2,1,1,35,16),
	(16,2,2,1,2,35,16),
	(17,2,10,0,1,35,16),
	(18,2,10,0,2,35,16),
	(19,2,10,1,1,35,16),
	(20,2,10,1,2,35,16),
	(21,2,3,0,1,35,16),
	(22,2,3,0,2,35,16),
	(23,2,3,1,1,35,16),
	(24,2,3,1,2,35,16),
	(25,3,2,0,1,35,16),
	(26,3,2,0,2,35,16),
	(27,3,2,1,1,35,16),
	(28,3,2,1,2,35,16),
	(29,3,10,0,1,35,16),
	(30,3,10,0,2,35,16),
	(31,3,10,1,1,35,16),
	(32,3,10,1,2,35,16),
	(33,3,3,0,1,35,16),
	(34,3,3,0,2,35,16),
	(35,3,3,1,1,35,16),
	(36,3,3,1,2,35,16),
	(37,4,4,0,1,20,10),
	(38,4,4,0,2,20,10),
	(39,4,4,1,1,20,10),
	(40,4,4,1,2,20,10),
	(41,5,4,0,1,20,10),
	(42,5,4,0,2,20,10),
	(43,5,4,1,1,20,10),
	(44,5,4,1,2,20,10),
	(45,6,7,0,1,20,15),
	(46,6,7,0,2,35,16),
	(47,6,7,1,1,20,15),
	(48,6,7,1,2,35,16),
	(49,7,11,0,1,20,15),
	(50,7,11,0,2,35,16),
	(51,7,11,1,1,20,15),
	(52,7,11,1,2,35,16);

/*!40000 ALTER TABLE `crop_hazard_effect` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table diet_allocation_items
# ------------------------------------------------------------

DROP TABLE IF EXISTS `diet_allocation_items`;

CREATE TABLE `diet_allocation_items` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `allocation_id` int(11) NOT NULL,
  `asset_id` int(11) NOT NULL,
  `amount` int(11) DEFAULT NULL,
  `all_char_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;



# Dump of table diet_allocations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `diet_allocations`;

CREATE TABLE `diet_allocations` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  `household` int(11) NOT NULL,
  `selected` int(1) DEFAULT '0',
  `deleted` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;



# Dump of table diet_items
# ------------------------------------------------------------

DROP TABLE IF EXISTS `diet_items`;

CREATE TABLE `diet_items` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `diet_id` int(11) NOT NULL,
  `asset_id` int(11) NOT NULL,
  `amount` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;



# Dump of table diets
# ------------------------------------------------------------

DROP TABLE IF EXISTS `diets`;

CREATE TABLE `diets` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `household` int(11) DEFAULT NULL,
  `target` int(1) DEFAULT NULL COMMENT 'Who is this diet for? Men, Women, Children or Babies?',
  `deleted` int(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;



# Dump of table fertiliser_crop_effect
# ------------------------------------------------------------

DROP TABLE IF EXISTS `fertiliser_crop_effect`;

CREATE TABLE `fertiliser_crop_effect` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `fertiliser_id` int(11) NOT NULL,
  `crop_id` int(11) NOT NULL,
  `ep_yield` int(11) NOT NULL,
  `lp_yield` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `fertiliser_crop_effect` WRITE;
/*!40000 ALTER TABLE `fertiliser_crop_effect` DISABLE KEYS */;

INSERT INTO `fertiliser_crop_effect` (`id`, `fertiliser_id`, `crop_id`, `ep_yield`, `lp_yield`)
VALUES
	(1,1,2,8,6),
	(2,1,3,15,11),
	(3,1,4,16,12),
	(4,1,7,12,8),
	(5,1,10,13,10),
	(6,1,11,10,7),
	(7,9,2,10,7),
	(8,9,3,20,16),
	(9,9,4,19,14),
	(10,9,7,15,12),
	(11,9,10,16,13),
	(12,9,11,13,10);

/*!40000 ALTER TABLE `fertiliser_crop_effect` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table field
# ------------------------------------------------------------

DROP TABLE IF EXISTS `field`;

CREATE TABLE `field` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `owner` int(11) DEFAULT NULL,
  `quality` int(11) NOT NULL,
  `hearth` int(11) DEFAULT NULL,
  `location_id` int(11) NOT NULL,
  `crop` int(11) DEFAULT NULL,
  `crop_age` int(11) DEFAULT NULL,
  `crop_health` int(11) DEFAULT NULL,
  `crop_planting` int(1) DEFAULT NULL COMMENT 'Whether the crop was planted early or late.',
  `fertiliser` int(3) DEFAULT NULL,
  `crop_weeded` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

# Dump of table field_hazard_history
# ------------------------------------------------------------

DROP TABLE IF EXISTS `field_hazard_history`;

CREATE TABLE `field_hazard_history` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `field` int(11) NOT NULL,
  `hazard_effect` int(11) NOT NULL,
  `mitigated` int(1) NOT NULL DEFAULT '0',
  `season_detail` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

# Dump of table fines
# ------------------------------------------------------------

DROP TABLE IF EXISTS `fines`;

CREATE TABLE `fines` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(200) DEFAULT NULL,
  `early_rate` double DEFAULT NULL,
  `late_rate` double DEFAULT NULL,
  `payee` int(11) DEFAULT NULL,
  `season` int(11) DEFAULT NULL,
  `paid` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

# Dump of table game
# ------------------------------------------------------------

DROP TABLE IF EXISTS `game`;

CREATE TABLE `game` (
  `id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(50) NOT NULL,
  `maxPlayers` int(11) NOT NULL DEFAULT '20',
  `password` varchar(50) DEFAULT NULL,
  `active` int(1) NOT NULL DEFAULT '1',
  `currentSeasonDetail` int(11) DEFAULT NULL,
  `village` varchar(50) NOT NULL DEFAULT '',
  `gametype` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

# Dump of table hearth
# ------------------------------------------------------------

DROP TABLE IF EXISTS `hearth`;

CREATE TABLE `hearth` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `game` int(11) NOT NULL,
  `housenumber` int(10) NOT NULL DEFAULT '0',
  `cash` float DEFAULT NULL,
  `location_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

# Dump of table location
# ------------------------------------------------------------

DROP TABLE IF EXISTS `location`;

CREATE TABLE `location` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

# Dump of table log
# ------------------------------------------------------------

DROP TABLE IF EXISTS `log`;

CREATE TABLE `log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` text NOT NULL,
  `generator` varchar(50) NOT NULL,
  `timestamp` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

# Dump of table log_errors
# ------------------------------------------------------------

DROP TABLE IF EXISTS `log_errors`;

CREATE TABLE `log_errors` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `message` text NOT NULL,
  `function` varchar(50) NOT NULL DEFAULT '',
  `timestamp` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;



# Dump of table market_assets
# ------------------------------------------------------------

DROP TABLE IF EXISTS `market_assets`;

CREATE TABLE `market_assets` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `asset` int(11) NOT NULL,
  `game` int(11) NOT NULL,
  `amount` double DEFAULT NULL,
  `sell_price` double DEFAULT NULL,
  `buy_price` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


# Dump of table role
# ------------------------------------------------------------

DROP TABLE IF EXISTS `role`;

CREATE TABLE `role` (
  `id` varchar(50) NOT NULL DEFAULT '',
  `name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;

INSERT INTO `role` (`id`, `name`)
VALUES
	('BANKER','Banker'),
	('MAN','Man'),
	('WOMAN','Woman');

/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

# Dump of table season
# ------------------------------------------------------------

DROP TABLE IF EXISTS `season`;

CREATE TABLE `season` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `next` int(11) DEFAULT NULL,
  `rainfall` double DEFAULT NULL,
  `tempmax` double DEFAULT NULL,
  `tempmin` double DEFAULT NULL,
  `displayOrder` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

LOCK TABLES `season` WRITE;
/*!40000 ALTER TABLE `season` DISABLE KEYS */;

INSERT INTO `season` (`id`, `name`, `next`, `rainfall`, `tempmax`, `tempmin`, `displayOrder`)
VALUES
	(2,'Early Rains',3,100,20,10,1),
	(3,'Main Rains',4,150,30,15,2),
	(4,'Early Harvest',5,20,30,15,3),
	(5,'Late Harvest',2,20,20,10,4),
	(1,'Pre-game',2,NULL,NULL,NULL,0),
	(6,'End-game',0,NULL,NULL,NULL,0);

/*!40000 ALTER TABLE `season` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table season_detail
# ------------------------------------------------------------

DROP TABLE IF EXISTS `season_detail`;

CREATE TABLE `season_detail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `game` int(11) NOT NULL,
  `season` varchar(50) NOT NULL DEFAULT '',
  `stage` varchar(50) DEFAULT '',
  `weather` varchar(11) DEFAULT NULL,
  `previous` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

# Dump of table task
# ------------------------------------------------------------

DROP TABLE IF EXISTS `task`;

CREATE TABLE `task` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `season` int(11) NOT NULL,
  `household` int(11) NOT NULL,
  `location` int(11) DEFAULT NULL,
  `actor` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `task_type` varchar(50) NOT NULL DEFAULT '',
  `asset` int(11) DEFAULT NULL,
  `asset_amount` int(11) DEFAULT NULL,
  `notes` blob,
  `deleted` int(1) NOT NULL DEFAULT '0',
  `task_number` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

# Dump of table textmessages
# ------------------------------------------------------------

DROP TABLE IF EXISTS `textmessages`;

CREATE TABLE `textmessages` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `sender` int(11) NOT NULL,
  `receiver` int(11) NOT NULL,
  `message` text NOT NULL,
  `timestamp` int(11) NOT NULL,
  `unread` int(1) NOT NULL DEFAULT '1',
  `deleted` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

# Dump of table ticker
# ------------------------------------------------------------

DROP TABLE IF EXISTS `ticker`;

CREATE TABLE `ticker` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `sender` int(11) DEFAULT NULL,
  `season_detail` int(11) DEFAULT NULL,
  `message` text,
  `duration` int(11) DEFAULT NULL COMMENT 'Storing in seconds?',
  `active` int(1) DEFAULT NULL,
  `game`int(11) DEFAULT NULL,
  `timestamp` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
# Dump of table user
# ------------------------------------------------------------

DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `active` int(1) NOT NULL DEFAULT '1',
  `currentgame` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

#-----------------------------------------------------------
# Update 20130201
#------------------------------------------------------------
ALTER TABLE `game`
	ADD (`current_year` int(10) NOT NULL DEFAULT '0');

UPDATE `game` g
	SET `current_year` = (SELECT ceil((count(sd.id) - 1)/4) FROM season_detail sd WHERE sd.game = g.name);
	
ALTER TABLE `season_detail` 
	ADD (`game_year` int(10) NOT NULL DEFAULT '0');

ALTER TABLE `diet_allocations`
	ADD (`game_year` int(10) NOT NULL DEFAULT '0');
	
UPDATE `diet_allocations` da
	SET `game_year` = (SELECT g.current_year 
						FROM game g 
						WHERE g.name = (SELECT h.game 
										FROM hearth h
										WHERE h.id = da.household));
#-----------------------------------------------------------
# Update v1.0.1
#------------------------------------------------------------
DROP TABLE IF EXISTS `version`;


CREATE TABLE `version` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `currentversion` varchar(11) DEFAULT NULL,
  `updated` TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

ALTER TABLE `character_all` 
	ADD (`alive` int(1) NOT NULL DEFAULT '1');

LOCK TABLES `character_all` WRITE;	
UPDATE `character_all`
	SET `alive` = 1;
UNLOCK TABLES;

ALTER TABLE `game`
	ADD (`household_size` INT(11) NOT NULL DEFAULT '2');

LOCK TABLES `game` WRITE;	
UPDATE `game`
	SET `household_size` = 2;
UNLOCK TABLES;

#-----------------------------------------------------------
# Update v1.0.2
#------------------------------------------------------------

ALTER TABLE `diet_allocations`
  ADD (`actual` int(1) DEFAULT '0');
  
LOCK TABLES `diet_allocations` WRITE;	
  UPDATE `diet_allocations`
  	SET `actual` = 0;
UNLOCK TABLES;

#------------------------------------------------------------
# Update vdb1.0.3
#-------------------------------------------------------------

ALTER TABLE `character_all` 
	ADD (`diet` VARCHAR(1) DEFAULT 'C');

LOCK TABLES `character_all` WRITE;	
UPDATE `character_all`
	SET `diet` = 'C';
UNLOCK TABLES;

#------------------------------------------------------------
# Build release, version number updated to db1.1.0
#-----------------------------------------------------------

#--------------------------------------------------------------
# Update to db1.1.1 - altered some of the assets and added a reclaim order.
#------------------------------------------------------------

ALTER TABLE `fines`
	ADD (`type` VARCHAR(20) NOT NULL);

LOCK TABLES `fines` WRITE;
UPDATE `fines` SET `type` = 'seasonal';
UNLOCK TABLES;

#-------------------------------------------------------------
# Update to db1.1.2
#--------------------------------------------------------------
# Create table health_hazards
# ------------------------------------------------------------

DROP TABLE IF EXISTS `health_hazards`;

CREATE TABLE `health_hazards` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `diet_level` varchar(1) NOT NUll,
  `hospital` int(11) NOT NULL,
  `death` int(11) NOT NULL, 
  `medicine_cost` double NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

LOCK TABLES `health_hazards` WRITE;

INSERT INTO `health_hazards` (`id`, `name`, `diet_level`, `hospital`, `death`, `medicine_cost`)
VALUES
	(1,'Kidney damage','A',0, 0, 20.00),
	(2,'Kidney damage','B',6, 0, 20.00),
	(3,'Kidney damage','C',6, 0, 20.00),
	(4,'Malaria','A',0, 0, 20.00),
	(5,'Malaria','B',0, 0, 20.00),
	(6,'Malaria','C',6, 6, 20.00),
	(7,'Dysentery','A',0, 0, 20.00),
	(8,'Dysentery','B',6, 0, 20.00),
	(9,'Dysentery','C',6, 6, 20.00),
	(10,'Eye trouble','A', 0, 0, 20.00),
	(11,'Eye trouble','B', 0, 0, 20.00),
	(12,'Eye trouble','C', 6, 0, 20.00),
	(13,'Fever','A', 0, 0, 20.00),
	(14,'Fever','B', 6, 0, 20.00),
	(15,'Fever','C', 18, 12, 20.00),
	(16,'Heart disorder','A', 0, 0, 20.00),
	(17,'Heart disorder','B', 0, 0, 20.00),
	(18,'Heart disorder','C', 0, 0, 20.00),
	(19,'Liver failure','A', 0, 0, 20.00),
	(20,'Liver failure','B', 0, 0, 20.00),
	(21,'Liver failure','C', 6, 0, 20.00),
	(22,'Stomach disorder','A', 0, 0, 20.00),
	(23,'Stomach disorder','B', 0, 0, 20.00),
	(24,'Stomach disorder','C', 0, 6, 20.00),
	(25,'Skin trouble','A', 0, 0, 20.00),
	(26,'Skin trouble','B', 6, 0, 20.00),
	(27,'Skin trouble','C', 0, 0, 20.00);

UNLOCK TABLES;

# Create table char_hazard_history
#-----------------------------------------------------------

DROP TABLE IF EXISTS `char_hazard_history`;

CREATE TABLE `char_hazard_history` (
	`id` int(11) unsigned NOT NULL AUTO_INCREMENT, 
	`char_id` int(11) NOT NULL, 
	`hazard_id` int(11) NOT NULL, 
	`season_id` int(11) NOT NULL,
	`outcome` int(1) NOT NULL,
	`charge_id` int(11) NOT NULL,
	PRIMARY KEY(`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `bills`;

LOCK TABLES `fines` WRITE;

ALTER TABLE `fines`
  RENAME TO `bills`;
UNLOCK TABLES;

LOCK TABLES `bills` WRITE;	
ALTER TABLE `bills`
  CHANGE `type` `duration` VARCHAR(20);

ALTER TABLE `bills` 
	ADD (`bill_type` VARCHAR(20) NOT NULL);

UPDATE `bills`
	SET `bill_type` = 'BILL_PENALTY';
UNLOCK TABLES;

# ------------------------------------------------------------
# Build version db1.2.0 - only changed version number
# ------------------------------------------------------------
# ------------------------------------------------------------
# Update version db1.2.1
# ------------------------------------------------------------

# Create table call_history
# ------------------------------------------------------------

DROP TABLE IF EXISTS `call_history`;

CREATE TABLE `call_history` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `call_from` int(11) NOT NULL,
  `call_to` int(11) NOT NULL,
  `started` int(11) NOT NULL,
  `answered` int(11) DEFAULT '0',
  `finished` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

# ------------------------------------------------------------
# Build version db1.2.0 - only changed version number
# ------------------------------------------------------------
# ------------------------------------------------------------
# Update version db1.3.1
# ------------------------------------------------------------

# Create table season_notification
# ------------------------------------------------------------

DROP TABLE IF EXISTS `season_notification`;

CREATE TABLE `season_notification` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `previous_season_id` int(11) DEFAULT NULL,
  `next_season_id` int(11) DEFAULT NULL,
  `previous_stage` varchar(50) DEFAULT NULL,
  `next_stage` varchar(50) DEFAULT NULL,
  `notification` blob NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=72 DEFAULT CHARSET=latin1;

# ------------------------------------------------------------
# Build version db1.4.0 - only changed version number
# ------------------------------------------------------------

# ------------------------------------------------------------
# Update version db1.4.1
# ------------------------------------------------------------

LOCK TABLES `assets` WRITE;
UPDATE `assets` SET subtype = "SPRAYKIT" where id = 12;
UPDATE `assets` SET subtype = "VOUCHERS" where id = 13;
UPDATE `assets` SET subtype = "CROPSTORE" where id = 14;
UNLOCK TABLES;

LOCK TABLES `character_all` WRITE, `character_player` WRITE;
ALTER TABLE `character_all` 
	ADD (`avatarBody` INT(11) NOT NULL);
ALTER TABLE `character_player` 
	DROP `avatarBody`;
UNLOCK TABLES;

# ------------------------------------------------------------
# Build version db1.5.0 - only changed version number
# ------------------------------------------------------------

#------------------------------------------------------------
# Build version db2.0.0 - add two tables for seasonal logging
#------------------------------------------------------------

DROP TABLE IF EXISTS `season_hearth_status`;

CREATE TABLE `season_hearth_status` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `hearth` int(11) DEFAULT NULL,
  `season_detail` int(11) DEFAULT NULL,
  `num_fields` int(11) DEFAULT NULL,
  `total_family` int(11) DEFAULT NULL,
  `living_family` int(11) DEFAULT NULL,
  `dead_family` int(11) DEFAULT NULL,
  `total_adults` int(11) DEFAULT NULL,
  `num_pcs` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `season_hearth_assets`;

CREATE TABLE `season_hearth_assets` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `season_detail` int(11) DEFAULT NULL,
  `hearth` int(11) DEFAULT NULL,
  `asset` int(11) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#------------------------------------------------------------
# Build version db2.0.1 - add messages table
#------------------------------------------------------------
DROP TABLE IF EXISTS `messages`;

CREATE TABLE `messages` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `recipient` int(11) NOT NULL,
  `timestamp` int(11) NOT NULL,
  `subject` varchar(100) NOT NULL DEFAULT '',
  `body` blob NOT NULL,
  `unread` int(1) NOT NULL DEFAULT '1',
  `deleted` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#------------------------------------------------------------
# Build version db2.0.2 - added an id column to game, made that the 
# primary key, added a unique key to name. Changed all the references.
#------------------------------------------------------------
#------------------------------------------------------------
# Build version db2.0.3 - deleted teamSelfSelect column from game table.
#--------------------------------------------------------------

#----------------------------------------------------------------
# Build version db3.0.0 - added a new table called proposals. May change 
# a bit yet, but fingers crossed this will help.
#----------------------------------------------------------------

# Dump of table proposals
# ------------------------------------------------------------

DROP TABLE IF EXISTS `proposals`;

CREATE TABLE `proposals` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `proposer` int(11) DEFAULT NULL,
  `proposing_hearth` int(11) DEFAULT NULL,
  `target` int(11) DEFAULT NULL,
  `current_hearth` int(11) DEFAULT NULL,
  `target_hearth` int(11) DEFAULT NULL,
  `status` int(1) DEFAULT NULL,
  `deleted` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#----------------------------------------------------------------
# Build version db3.0.1 - added a new column (current_hearth) to 
# proposals above.
#----------------------------------------------------------------
#----------------------------------------------------------------
# Build version db3.0.2 - added a new table for grading
#----------------------------------------------------------------

DROP TABLE IF EXISTS `grading`;

CREATE TABLE `grading` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `grading_type` varchar(50) DEFAULT NULL,
  `player_id` int(11) DEFAULT NULL,
  `hearth_id` int(11) DEFAULT NULL,
  `game_year` int(11) DEFAULT NULL,
  `grade_value` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#----------------------------------------------------------------
# Build version db3.0.3 - add an extra column in Bills to show who is affected.
#----------------------------------------------------------------

LOCK TABLES `bills` WRITE;	

ALTER TABLE `bills` 
	ADD (`all_char_id` int(11) DEFAULT NULL);

UNLOCK TABLES;

#----------------------------------------------------------------
# Build version db4.1.0 - added a table to record what happens to fields 
# throughout the game. 
#----------------------------------------------------------------

DROP TABLE IF EXISTS `field_history`;

CREATE TABLE `field_history` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `field` int(11) DEFAULT NULL,
  `game_year` int(11) DEFAULT NULL,
  `planting_time` int(11) DEFAULT NULL,
  `crop` int(11) DEFAULT NULL,
  `weeded` int(1) DEFAULT NULL,
  `fertilised` int(1) DEFAULT NULL,
  `owner` int(11) DEFAULT NULL,
  `hearth` int(11) DEFAULT NULL,
  `yield` int(11) DEFAULT NULL,
  `field_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=latin1;

#----------------------------------------------------------------
# Build version db4.1.1 - removed crop store and added cotton seed. 
#----------------------------------------------------------------
#----------------------------------------------------------------
# Build version db4.1.2 - changed the land buy and sell price around. 
#----------------------------------------------------------------
#----------------------------------------------------------------
# Build version db4.1.3 - completed the asset descriptions. 
#----------------------------------------------------------------
#----------------------------------------------------------------
# Build version db4.1.3 - more asset descriptions. 
#----------------------------------------------------------------
#----------------------------------------------------------------
# Build version db5.0.1 - more asset descriptions. 
#----------------------------------------------------------------

#--------------------------------------------------------------
# Insert later updates above here
#--------------------------------------------------------------

#------------------------------------------------------------
# Update the current version number
#-------------------------------------------------------------

LOCK TABLES `version` WRITE;
INSERT INTO `version` (`currentversion`, `updated`)
VALUES
	('db5.0.1', CURRENT_TIMESTAMP());
UNLOCK TABLES;

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;


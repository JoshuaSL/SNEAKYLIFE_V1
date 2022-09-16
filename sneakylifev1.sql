-- --------------------------------------------------------
-- Hôte:                         145.239.44.0
-- Version du serveur:           10.3.31-MariaDB-0+deb10u1 - Debian 10
-- SE du serveur:                debian-linux-gnu
-- HeidiSQL Version:             11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Listage de la structure de la base pour california_dev
CREATE DATABASE IF NOT EXISTS `california_dev` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `california_dev`;

-- Listage de la structure de la table california_dev. account_info
CREATE TABLE IF NOT EXISTS `account_info` (
  `account_id` int(11) NOT NULL AUTO_INCREMENT,
  `license` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `steam` varchar(22) COLLATE utf8mb4_bin DEFAULT NULL,
  `xbl` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `discord` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `live` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `fivem` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `name` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `ip` varchar(20) COLLATE utf8mb4_bin DEFAULT NULL,
  `tokens` text COLLATE utf8mb4_bin DEFAULT NULL,
  `guid` varchar(20) COLLATE utf8mb4_bin DEFAULT NULL,
  `first_connection` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`account_id`),
  UNIQUE KEY `license` (`license`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Listage des données de la table california_dev.account_info : 0 rows
/*!40000 ALTER TABLE `account_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_info` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. addon_account
CREATE TABLE IF NOT EXISTS `addon_account` (
  `name` varchar(60) COLLATE utf8mb4_bin NOT NULL,
  `label` varchar(100) COLLATE utf8mb4_bin NOT NULL,
  `shared` int(11) NOT NULL,
  PRIMARY KEY (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Listage des données de la table california_dev.addon_account : ~64 rows (environ)
/*!40000 ALTER TABLE `addon_account` DISABLE KEYS */;
INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
	('property_dirtycash', 'Argent Sale Propriété', 0),
	('society_410', '410', 1),
	('society_agentimmo', 'Agence Immobilière', 1),
	('society_ambulance', 'Ambulance', 1),
	('society_aod', 'Angels of Death', 1),
	('society_avocat', 'Avocat', 1),
	('society_aztecas', 'Aztecas', 1),
	('society_bahamas', 'Bahamas Mamas', 1),
	('society_ballas', 'Ballas', 1),
	('society_bandadiaz', 'Banda Diaz', 1),
	('society_biker', 'Sons of Anarchy', 1),
	('society_blackv', 'Mafia Jashari', 1),
	('society_blueboys', 'Blue Boys', 1),
	('society_bmf', 'Black Mafia Family', 1),
	('society_boneli', 'Boneli', 1),
	('society_burgershot', 'Burgershot', 1),
	('society_carshop', 'Concessionnaire Voitures', 1),
	('society_castillo', 'Cartel Castillo', 1),
	('society_coronado', 'Cartel del Coronado', 1),
	('society_cosanostra', 'Cosa Nostra', 1),
	('society_duggan', 'Duggan Crime Family', 1),
	('society_fag', 'Fuere Apache Grande', 1),
	('society_families', 'Families', 1),
	('society_fbi', 'Federal Bureau of Investigation', 1),
	('society_forelli', 'Forelli Crime Family', 1),
	('society_fuerza', 'Fuerza Argentina', 1),
	('society_gouvernement', 'Gouvernement', 1),
	('society_harmony', 'Harmony Repair & Custom', 1),
	('society_hudson', 'Famille Hudson', 1),
	('society_jashari', 'Mafia Jashari', 1),
	('society_kkangpae', 'Kkangpae', 1),
	('society_loco', 'Loco Syndicate', 1),
	('society_lssd', 'Los Santos Shériff Department', 1),
	('society_ltd_nord', 'LTD Nord', 1),
	('society_ltd_sud', 'LTD Sud', 1),
	('society_madrazo', 'Carte de madrazo', 1),
	('society_mafiaarmenienne', 'Mafia arménienne', 1),
	('society_marabunta', 'Marabunta', 1),
	('society_mayans', 'Mayans MC', 1),
	('society_mcreary', 'Mcreary', 1),
	('society_mecano', 'Mécano', 1),
	('society_medelin', 'Cartel de medelin', 1),
	('society_mendez', 'Cartel de Mendez', 1),
	('society_michoacana', 'Familia Michoacana', 1),
	('society_mnc', 'Min Night Click', 1),
	('society_motoshop', 'Concessionnaire Motos', 1),
	('society_noodle', 'Noodle Exchange', 1),
	('society_oneil', 'O\'Neil', 1),
	('society_pawnshop', 'Pawnshop', 1),
	('society_pizza', 'Drusilla\'s Pizza', 1),
	('society_police', 'Police', 1),
	('society_professionnels', 'Les Professionnels', 1),
	('society_redent', 'Redent', 1),
	('society_reiffen', 'Reiffen', 1),
	('society_russe', 'Mafia russe', 1),
	('society_sula', 'Cartel Sula', 1),
	('society_taxi', 'Downtown Cab Co', 1),
	('society_triade', 'Triade', 1),
	('society_unicorn', 'Unicorn', 1),
	('society_vagos', 'Vagos', 1),
	('society_yakuza', 'Yakuza', 1),
	('society_yellowjack', 'YellowJack', 1),
	('society_zetas', 'Zetas', 1),
	('trunk_dirtycash', 'Argent Sale Coffre Véhicule', 0);
/*!40000 ALTER TABLE `addon_account` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. addon_account_data
CREATE TABLE IF NOT EXISTS `addon_account_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_name` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `money` double NOT NULL,
  `owner` varchar(60) COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `index_addon_account_data_account_name` (`account_name`(191)) USING BTREE,
  KEY `index_addon_account_data_account_name_owner` (`account_name`(191),`owner`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=47266 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Listage des données de la table california_dev.addon_account_data : ~62 rows (environ)
/*!40000 ALTER TABLE `addon_account_data` DISABLE KEYS */;
INSERT INTO `addon_account_data` (`id`, `account_name`, `money`, `owner`) VALUES
	(113, 'society_ambulance', 0, NULL),
	(119, 'society_carshop', 0, NULL),
	(120, 'society_motoshop', 0, NULL),
	(131, 'society_mecano', 0, NULL),
	(18567, 'society_police', 0, NULL),
	(19990, 'society_unicorn', 0, NULL),
	(21210, 'society_avocat', 0, NULL),
	(21807, 'society_burgershot', 0, NULL),
	(22496, 'society_pizza', 0, NULL),
	(23826, 'society_lssd', 0, NULL),
	(25536, 'society_yellowjack', 0, NULL),
	(26514, 'society_gouvernement', 0, NULL),
	(27755, 'society_pawnshop', 0, NULL),
	(29411, 'society_taxi', 0, NULL),
	(33818, 'society_bahamas', 0, NULL),
	(35204, 'society_ltd_nord', 0, NULL),
	(36560, 'society_fbi', 0, NULL),
	(42003, 'society_ltd_sud', 0, NULL),
	(43805, 'society_harmony', 0, NULL),
	(47223, 'society_410', 0, NULL),
	(47224, 'society_agentimmo', 0, NULL),
	(47225, 'society_aod', 0, NULL),
	(47226, 'society_aztecas', 0, NULL),
	(47227, 'society_ballas', 0, NULL),
	(47228, 'society_bandadiaz', 0, NULL),
	(47229, 'society_biker', 0, NULL),
	(47230, 'society_blackv', 0, NULL),
	(47231, 'society_blueboys', 0, NULL),
	(47232, 'society_bmf', 0, NULL),
	(47233, 'society_boneli', 0, NULL),
	(47234, 'society_castillo', 0, NULL),
	(47235, 'society_coronado', 0, NULL),
	(47236, 'society_cosanostra', 0, NULL),
	(47237, 'society_duggan', 0, NULL),
	(47238, 'society_fag', 0, NULL),
	(47239, 'society_families', 0, NULL),
	(47240, 'society_forelli', 0, NULL),
	(47241, 'society_fuerza', 0, NULL),
	(47242, 'society_hudson', 0, NULL),
	(47243, 'society_jashari', 0, NULL),
	(47244, 'society_kkangpae', 0, NULL),
	(47245, 'society_loco', 0, NULL),
	(47246, 'society_madrazo', 0, NULL),
	(47247, 'society_mafiaarmenienne', 0, NULL),
	(47248, 'society_marabunta', 0, NULL),
	(47249, 'society_mayans', 0, NULL),
	(47250, 'society_mcreary', 0, NULL),
	(47251, 'society_medelin', 0, NULL),
	(47252, 'society_mendez', 0, NULL),
	(47253, 'society_michoacana', 0, NULL),
	(47254, 'society_mnc', 0, NULL),
	(47255, 'society_noodle', 0, NULL),
	(47256, 'society_oneil', 0, NULL),
	(47257, 'society_professionnels', 0, NULL),
	(47258, 'society_redent', 0, NULL),
	(47259, 'society_reiffen', 0, NULL),
	(47260, 'society_russe', 0, NULL),
	(47261, 'society_sula', 0, NULL),
	(47262, 'society_triade', 0, NULL),
	(47263, 'society_vagos', 0, NULL),
	(47264, 'society_yakuza', 0, NULL),
	(47265, 'society_zetas', 0, NULL);
/*!40000 ALTER TABLE `addon_account_data` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. addon_inventory
CREATE TABLE IF NOT EXISTS `addon_inventory` (
  `name` varchar(60) COLLATE utf8mb4_bin NOT NULL,
  `label` varchar(100) COLLATE utf8mb4_bin NOT NULL,
  `shared` int(11) NOT NULL,
  PRIMARY KEY (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Listage des données de la table california_dev.addon_inventory : ~64 rows (environ)
/*!40000 ALTER TABLE `addon_inventory` DISABLE KEYS */;
INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
	('property', 'Propriété', 0),
	('society_410', '410', 1),
	('society_agentimmo', 'Agence Immobilière', 1),
	('society_ambulance', 'Ambulance', 1),
	('society_aod', 'Angels of Death', 1),
	('society_avocat', 'Avocat', 1),
	('society_aztecas', 'Aztecas', 1),
	('society_bahamas', 'Bahamas Mamas', 1),
	('society_ballas', 'Ballas', 1),
	('society_bandadiaz', 'Banda Diaz', 1),
	('society_biker', 'Sons of Anarchy', 1),
	('society_blackv', 'Mafia Jashari', 1),
	('society_blueboys', 'Blue Boys', 1),
	('society_bmf', 'Black Mafia Family', 1),
	('society_boneli', 'Boneli', 1),
	('society_burgershot', 'Burgershot', 1),
	('society_carshop', 'Concessionnaire Voitures', 1),
	('society_castillo', 'Cartel Castillo', 1),
	('society_coronado', 'Cartel del Coronado', 1),
	('society_cosanostra', 'Cosa Nostra', 1),
	('society_duggan', 'Duggan Crime Family', 1),
	('society_fag', 'Fuere Apache Grande', 1),
	('society_families', 'Families', 1),
	('society_fbi', 'Federal Bureau of Investigation', 1),
	('society_forelli', 'Forelli Crime Family', 1),
	('society_fuerza', 'Fuerza Argentina', 1),
	('society_gouvernement', 'Gouvernement', 1),
	('society_harmony', 'Harmony Repair & Custom', 1),
	('society_hudson', 'Famille Hudson', 1),
	('society_jashari', 'Mafia Jashari', 1),
	('society_kkangpae', 'Kkangpae', 1),
	('society_loco', 'Loco Syndicate', 1),
	('society_lssd', 'Los Santos Shériff Department', 1),
	('society_ltd_nord', 'LTD Nord', 1),
	('society_ltd_sud', 'LTD Sud', 1),
	('society_madrazo', 'Carte de madrazo', 1),
	('society_mafiaarmenienne', 'Mafia arménienne', 1),
	('society_marabunta', 'Marabunta', 1),
	('society_mayans', 'Mayans MC', 1),
	('society_mcreary', 'Mcreary', 1),
	('society_mecano', 'Mécano', 1),
	('society_medelin', 'Cartel de medelin', 1),
	('society_mendez', 'Cartel de Mendez', 1),
	('society_michoacana', 'Familia Michoacana', 1),
	('society_mnc', 'Min Night Click', 1),
	('society_motoshop', 'Concessionnaire Motos', 1),
	('society_noodle', 'Noodle Exchange', 1),
	('society_oneil', 'O\'Neil', 1),
	('society_pawnshop', 'Pawnshop', 1),
	('society_pizza', 'Drusilla\'s Pizza', 1),
	('society_police', 'Police', 1),
	('society_professionnels', 'Les Professionnels', 1),
	('society_redent', 'Redent', 1),
	('society_reiffen', 'Reiffen', 1),
	('society_russe', 'Mafia russe', 1),
	('society_sula', 'Cartel Sula', 1),
	('society_taxi', 'Downtown Cab Co', 1),
	('society_triade', 'Triade', 1),
	('society_unicorn', 'Unicorn', 1),
	('society_vagos', 'Vagos', 1),
	('society_yakuza', 'Yakuza', 1),
	('society_yellowjack', 'YellowJack', 1),
	('society_zetas', 'Zetas', 1),
	('trunk', 'Coffre Véhicule', 0);
/*!40000 ALTER TABLE `addon_inventory` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. addon_inventory_items
CREATE TABLE IF NOT EXISTS `addon_inventory_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `inventory_name` varchar(100) COLLATE utf8mb4_bin NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_bin NOT NULL,
  `count` int(11) NOT NULL,
  `owner` varchar(60) COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `index_addon_inventory_items_inventory_name_name` (`inventory_name`,`name`) USING BTREE,
  KEY `index_addon_inventory_items_inventory_name_name_owner` (`inventory_name`,`name`,`owner`) USING BTREE,
  KEY `index_addon_inventory_inventory_name` (`inventory_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Listage des données de la table california_dev.addon_inventory_items : ~0 rows (environ)
/*!40000 ALTER TABLE `addon_inventory_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `addon_inventory_items` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. billing
CREATE TABLE IF NOT EXISTS `billing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(55) NOT NULL,
  `sender` varchar(55) NOT NULL,
  `target_type` varchar(55) NOT NULL,
  `target` varchar(55) NOT NULL,
  `label` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Listage des données de la table california_dev.billing : ~0 rows (environ)
/*!40000 ALTER TABLE `billing` DISABLE KEYS */;
/*!40000 ALTER TABLE `billing` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. cardealer_vehicles
CREATE TABLE IF NOT EXISTS `cardealer_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `price` int(11) NOT NULL,
  `job` varchar(255) NOT NULL DEFAULT 'carshop',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;

-- Listage des données de la table california_dev.cardealer_vehicles : 0 rows
/*!40000 ALTER TABLE `cardealer_vehicles` DISABLE KEYS */;
/*!40000 ALTER TABLE `cardealer_vehicles` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. datastore
CREATE TABLE IF NOT EXISTS `datastore` (
  `name` varchar(60) COLLATE utf8mb4_bin NOT NULL,
  `label` varchar(100) COLLATE utf8mb4_bin NOT NULL,
  `shared` int(11) NOT NULL,
  PRIMARY KEY (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Listage des données de la table california_dev.datastore : ~68 rows (environ)
/*!40000 ALTER TABLE `datastore` DISABLE KEYS */;
INSERT INTO `datastore` (`name`, `label`, `shared`) VALUES
	('property', 'Propriété', 0),
	('society_410', '410', 1),
	('society_agentimmo', 'Agence Immobilière', 1),
	('society_ambulance', 'Ambulance', 1),
	('society_aod', 'Angels of Death', 1),
	('society_avocat', 'Avocat', 1),
	('society_aztecas', 'Aztecas', 1),
	('society_bahamas', 'Bahamas Mamas', 1),
	('society_ballas', 'Ballas', 1),
	('society_bandadiaz', 'Banda Diaz', 1),
	('society_biker', 'Sons of Anarchy', 1),
	('society_blackv', 'Mafia Jashari', 1),
	('society_blueboys', 'Blue Boys', 1),
	('society_bmf', 'Black Mafia Family', 1),
	('society_boneli', 'Boneli', 1),
	('society_burgershot', 'Burgershot', 1),
	('society_carshop', 'Concessionnaire Voitures', 1),
	('society_castillo', 'Cartel Castillo', 1),
	('society_coronado', 'Cartel del Coronado', 1),
	('society_cosanostra', 'Cosa Nostra', 1),
	('society_duggan', 'Duggan Crime Family', 1),
	('society_fag', 'Fuere Apache Grande', 1),
	('society_families', 'Families', 1),
	('society_fbi', 'Federal Bureau of Investigation', 1),
	('society_forelli', 'Forelli Crime Family', 1),
	('society_fuerza', 'Fuerza Argentina', 1),
	('society_gouvernement', 'Gouvernement', 1),
	('society_harmony', 'Harmony Repair & Custom', 1),
	('society_hudson', 'Famille Hudson', 1),
	('society_jashari', 'Mafia Jashari', 1),
	('society_kkangpae', 'Kkangpae', 1),
	('society_loco', 'Loco Syndicate', 1),
	('society_lssd', 'Los Santos Shériff Department', 1),
	('society_ltd_nord', 'LTD Nord', 1),
	('society_ltd_sud', 'LTD Sud', 1),
	('society_madrazo', 'Carte de madrazo', 1),
	('society_mafiaarmenienne', 'Mafia arménienne', 1),
	('society_marabunta', 'Marabunta', 1),
	('society_mayans', 'Mayans MC', 1),
	('society_mcreary', 'Mcreary', 1),
	('society_mecano', 'Mécano', 1),
	('society_medelin', 'Cartel de medelin', 1),
	('society_mendez', 'Cartel de Mendez', 1),
	('society_michoacana', 'Familia Michoacana', 1),
	('society_mnc', 'Min Night Click', 1),
	('society_motoshop', 'Concessionnaire Motos', 1),
	('society_noodle', 'Noodle Exchange', 1),
	('society_oneil', 'O\'Neil', 1),
	('society_pawnshop', 'Pawnshop', 1),
	('society_pizza', 'Drusilla\'s Pizza', 1),
	('society_police', 'Police', 1),
	('society_professionnels', 'Les Professionnels', 1),
	('society_redent', 'Redent', 1),
	('society_reiffen', 'Reiffen', 1),
	('society_russe', 'Mafia russe', 1),
	('society_sula', 'Cartel Sula', 1),
	('society_taxi', 'Downtown Cab Co', 1),
	('society_triade', 'Triade', 1),
	('society_unicorn', 'Unicorn', 1),
	('society_vagos', 'Vagos', 1),
	('society_yakuza', 'Yakuza', 1),
	('society_yellowjack', 'YellowJack', 1),
	('society_zetas', 'Zetas', 1),
	('trunk', 'Coffre Véhicule', 0),
	('user_ears', 'Ears', 0),
	('user_glasses', 'Glasses', 0),
	('user_helmet', 'Helmet', 0),
	('user_mask', 'Mask', 0);
/*!40000 ALTER TABLE `datastore` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. datastore_data
CREATE TABLE IF NOT EXISTS `datastore_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) COLLATE utf8mb4_bin NOT NULL,
  `data` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `owner` varchar(60) COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `index_datastore_data_name` (`name`) USING BTREE,
  KEY `index_datastore_data_name_owner` (`name`,`owner`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=14152 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Listage des données de la table california_dev.datastore_data : ~63 rows (environ)
/*!40000 ALTER TABLE `datastore_data` DISABLE KEYS */;
INSERT INTO `datastore_data` (`id`, `name`, `data`, `owner`) VALUES
	(2953, 'society_madrazo', '{"dirtycash":0,"weapons":[]}', NULL),
	(3097, 'society_carshop', '{"weapons":[],"dirtycash":0}', NULL),
	(3113, 'society_coronado', '{"weapons":[{"count":0,"name":"WEAPON_PISTOL"},{"count":0,"name":"WEAPON_PISTOL50"},{"count":0,"name":"WEAPON_PISTOL_MK2"},{"count":0,"name":"WEAPON_SNSPISTOL"},{"count":0,"name":"WEAPON_HEAVYPISTOL"},{"count":0,"name":"WEAPON_REVOLVER"},{"count":0,"name":"WEAPON_DOUBLEACTION"},{"count":0,"name":"WEAPON_MACHINEPISTOL"},{"count":0,"name":"WEAPON_MINISMG"},{"count":0,"name":"WEAPON_MICROSMG"},{"count":0,"name":"WEAPON_ASSAULTSMG"},{"count":0,"name":"WEAPON_PUMPSHOTGUN"},{"count":0,"name":"WEAPON_SAWNOFFSHOTGUN"},{"count":0,"name":"WEAPON_GUSENBERG"},{"count":0,"name":"WEAPON_ASSAULTRIFLE"},{"count":0,"name":"WEAPON_PUMPSHOTGUN_MK2"},{"count":0,"name":"WEAPON_POOLCUE"},{"count":0,"name":"WEAPON_SWITCHBLADE"},{"count":0,"name":"WEAPON_MOLOTOV"},{"count":0,"name":"WEAPON_STONE_HATCHET"}]}', NULL),
	(3239, 'society_unicorn', '{"dirtycash":0,"weapons":[]}', NULL),
	(3277, 'society_crips', '{"weapons":[{"count":0,"name":"WEAPON_BAT"},{"count":0,"name":"WEAPON_GOLFCLUB"},{"count":0,"name":"WEAPON_SNSPISTOL"},{"count":0,"name":"WEAPON_KNUCKLE"}],"dirtycash":0}', NULL),
	(3562, 'society_police', '{"dirtycash":551486,"weapons":[{"name":"WEAPON_BAT","count":8},{"name":"WEAPON_KNIFE","count":4},{"name":"WEAPON_NIGHTSTICK","count":2},{"name":"WEAPON_GOLFCLUB","count":45},{"name":"WEAPON_SWITCHBLADE","count":336},{"name":"WEAPON_KNUCKLE","count":77},{"name":"WEAPON_WRENCH","count":3},{"name":"WEAPON_SNSPISTOL","count":5},{"name":"WEAPON_DAGGER","count":14},{"name":"WEAPON_HATCHET","count":70},{"name":"WEAPON_CROWBAR","count":4},{"name":"WEAPON_PISTOL","count":214},{"name":"WEAPON_POOLCUE","count":1},{"name":"WEAPON_PISTOL50","count":11},{"name":"WEAPON_BATTLEAXE","count":6},{"name":"WEAPON_MACHINEPISTOL","count":4},{"name":"WEAPON_STONE_HATCHET","count":2},{"name":"WEAPON_BZGAS","count":4},{"name":"WEAPON_FLARE","count":9},{"name":"WEAPON_SMG","count":3},{"name":"WEAPON_ASSAULTSMG","count":0},{"name":"WEAPON_COMBATPDW","count":7},{"name":"WEAPON_FLAREGUN","count":3},{"name":"WEAPON_GUSENBERG","count":0},{"name":"WEAPON_COMBATMG","count":0},{"name":"WEAPON_GRENADE","count":0},{"name":"WEAPON_MG","count":0},{"name":"WEAPON_ASSAULTRIFLE","count":1},{"name":"WEAPON_BULLPUPSHOTGUN","count":0},{"name":"WEAPON_FIREEXTINGUISHER","count":1},{"name":"WEAPON_SAWNOFFSHOTGUN","count":2},{"name":"WEAPON_BOTTLE","count":5},{"name":"WEAPON_MINISMG","count":1},{"name":"WEAPON_MICROSMG","count":12},{"name":"WEAPON_MOLOTOV","count":1},{"name":"WEAPON_ASSAULTRIFLE_MK2","count":0},{"name":"WEAPON_PISTOL_MK2","count":1},{"name":"WEAPON_SPECIALCARBINE","count":3},{"name":"WEAPON_SMOKEGRENADE","count":2},{"name":"WEAPON_REVOLVER","count":1},{"name":"GADGET_PARACHUTE","count":0},{"name":"WEAPON_CERAMICPISTOL","count":2},{"ammo":0,"count":27,"name":"WEAPON_COMBATPISTOL"},{"ammo":0,"count":2,"name":"WEAPON_MACHETE"},{"ammo":20,"count":1,"name":"WEAPON_FIREWORK"}]}', NULL),
	(4011, 'society_zetas', '{"dirtycash":0,"weapons":[{"name":"WEAPON_KNUCKLE","count":0},{"name":"WEAPON_BATTLEAXE","count":0},{"name":"WEAPON_WRENCH","count":0},{"name":"WEAPON_CROWBAR","count":0},{"name":"WEAPON_POOLCUE","count":0},{"name":"WEAPON_GOLFCLUB","count":0},{"name":"WEAPON_MINISMG","count":0}]}', NULL),
	(4178, 'society_burgershot', '{"weapons":[],"dirtycash":0}', NULL),
	(4228, 'society_biker', '{"weapons":[],"dirtycash":0}', NULL),
	(5243, 'society_mecano', '{"dirtycash":0,"weapons":[]}', NULL),
	(5271, 'society_vagos', '{"dirtycash":27052,"weapons":[{"count":0,"name":"WEAPON_SWITCHBLADE"},{"count":0,"name":"WEAPON_GOLFCLUB"},{"count":0,"name":"WEAPON_KNUCKLE"},{"count":0,"name":"WEAPON_HATCHET"},{"count":0,"name":"WEAPON_BOTTLE"},{"count":0,"name":"WEAPON_STONE_HATCHET"},{"count":0,"name":"WEAPON_PISTOL"},{"count":0,"name":"WEAPON_DAGGER"},{"count":0,"name":"WEAPON_PISTOL50"}]}', NULL),
	(5368, 'society_marabunta', '{"weapons":[{"name":"WEAPON_SWITCHBLADE","count":0},{"name":"WEAPON_HATCHET","count":0},{"name":"WEAPON_GOLFCLUB","count":0},{"name":"WEAPON_PISTOL","count":0}],"dirtycash":0}', NULL),
	(5474, 'society_ballas', '{"dirtycash":95431,"weapons":[{"name":"WEAPON_SWITCHBLADE","count":0},{"name":"WEAPON_GOLFCLUB","count":2},{"name":"WEAPON_HATCHET","count":0},{"name":"WEAPON_KNUCKLE","count":0},{"name":"WEAPON_PISTOL","count":0},{"name":"WEAPON_POOLCUE","count":0},{"name":"WEAPON_BOTTLE","count":0},{"name":"WEAPON_SMG","count":0},{"name":"WEAPON_DOUBLEACTION","count":0},{"name":"WEAPON_MOLOTOV","count":0}]}', NULL),
	(5649, 'society_families', '{"weapons":[{"name":"WEAPON_SWITCHBLADE","count":0},{"name":"WEAPON_GOLFCLUB","count":0},{"name":"WEAPON_STONE_HATCHET","count":0},{"name":"WEAPON_KNUCKLE","count":0},{"name":"WEAPON_PISTOL","count":0},{"name":"WEAPON_WRENCH","count":0},{"name":"WEAPON_POOLCUE","count":0},{"name":"WEAPON_HATCHET","count":0},{"name":"WEAPON_MICROSMG","count":0},{"name":"WEAPON_PISTOL50","count":0},{"name":"WEAPON_MACHINEPISTOL","count":0},{"name":"WEAPON_FLARE","count":0},{"name":"WEAPON_SNSPISTOL","count":0},{"name":"WEAPON_BAT","count":0},{"name":"WEAPON_BATTLEAXE","count":0},{"name":"WEAPON_CERAMICPISTOL","count":0},{"name":"WEAPON_CROWBAR","count":0}],"dirtycash":0}', NULL),
	(5651, 'society_medelin', '{"weapons":[{"name":"WEAPON_GOLFCLUB","count":0},{"name":"WEAPON_SWITCHBLADE","count":0},{"name":"WEAPON_PISTOL50","count":0},{"name":"WEAPON_DAGGER","count":0},{"name":"WEAPON_CERAMICPISTOL","count":0},{"name":"WEAPON_BATTLEAXE","count":0},{"name":"WEAPON_HATCHET","count":0},{"name":"WEAPON_PISTOL","count":0},{"name":"WEAPON_SNSPISTOL","count":0}],"dirtycash":0}', NULL),
	(5664, 'society_pizza', '{"weapons":[{"count":0,"name":"WEAPON_HATCHET"},{"count":0,"name":"WEAPON_SNSPISTOL"},{"count":0,"name":"WEAPON_KNUCKLE"},{"count":0,"name":"WEAPON_SWITCHBLADE"},{"count":0,"name":"WEAPON_BOTTLE"},{"count":0,"name":"WEAPON_PISTOL"},{"count":0,"name":"WEAPON_GOLFCLUB"},{"count":0,"name":"WEAPON_WRENCH"},{"count":0,"name":"WEAPON_PISTOL50"}]}', NULL),
	(5731, 'society_russe', '{"weapons":[{"count":1,"name":"WEAPON_STONE_HATCHET"},{"count":0,"name":"WEAPON_POOLCUE"},{"count":0,"name":"WEAPON_BOTTLE"},{"count":1,"ammo":50,"name":"WEAPON_SNSPISTOL"}],"dirtycash":0}', NULL),
	(5743, 'society_lssd', '{"weapons":[{"name":"WEAPON_DAGGER","count":2},{"name":"WEAPON_SWITCHBLADE","count":67},{"name":"WEAPON_KNUCKLE","count":21},{"name":"WEAPON_CROWBAR","count":1},{"name":"WEAPON_BATTLEAXE","count":3},{"name":"WEAPON_STONE_HATCHET","count":1},{"name":"WEAPON_BAT","count":1},{"name":"WEAPON_MICROSMG","count":1},{"name":"WEAPON_PISTOL50","count":6},{"name":"WEAPON_PISTOL","count":51},{"name":"WEAPON_HATCHET","count":12},{"name":"WEAPON_GOLFCLUB","count":5},{"name":"WEAPON_FLASHLIGHT","count":0},{"name":"GADGET_PARACHUTE","count":0},{"name":"WEAPON_FLARE","count":3},{"name":"WEAPON_ASSAULTSMG","count":0},{"name":"WEAPON_MINISMG","count":2},{"name":"WEAPON_SNSPISTOL","count":3},{"name":"WEAPON_WRENCH","count":2},{"name":"WEAPON_SNIPERRIFLE","count":3},{"name":"WEAPON_BOTTLE","count":3},{"name":"WEAPON_SMOKEGRENADE","count":1},{"count":5,"name":"WEAPON_COMBATPISTOL","ammo":0},{"count":1,"name":"WEAPON_MACHINEPISTOL","ammo":0}],"dirtycash":56367}', NULL),
	(5750, 'society_ambulance', '{"weapons":[],"dirtycash":0}', NULL),
	(5761, 'society_410', '{"weapons":[{"name":"WEAPON_POOLCUE","count":0},{"name":"WEAPON_SWITCHBLADE","count":0},{"name":"WEAPON_GOLFCLUB","count":0},{"name":"WEAPON_BAT","count":0},{"name":"WEAPON_WRENCH","count":0},{"name":"WEAPON_PISTOL","count":1},{"name":"WEAPON_CROWBAR","count":0}],"dirtycash":0}', NULL),
	(5771, 'society_yakuza', '{"dirtycash":7296.490000000004,"weapons":[{"name":"WEAPON_HATCHET","count":3},{"name":"WEAPON_SNSPISTOL","count":0},{"name":"WEAPON_SWITCHBLADE","count":0}]}', NULL),
	(5793, 'society_agentimmo', '{"weapons":[]}', NULL),
	(5797, 'society_mnc', '{"dirtycash":0,"weapons":[{"count":0,"name":"WEAPON_STONE_HATCHET"}]}', NULL),
	(5939, 'society_motoshop', '{"dirtycash":0,"weapons":[]}', NULL),
	(6303, 'society_yellowjack', '{"dirtycash":0,"weapons":[]}', NULL),
	(6526, 'society_boneli', '{"dirtycash":0}', NULL),
	(6528, 'society_gouvernement', '{"weapons":[{"ammo":250,"name":"WEAPON_COMBATPISTOL","count":1}]}', NULL),
	(6577, 'society_cosanostra', '{"weapons":[{"name":"WEAPON_BOTTLE","count":0},{"name":"WEAPON_SWITCHBLADE","count":0},{"name":"WEAPON_PISTOL","count":0},{"name":"WEAPON_KNUCKLE","count":0}],"dirtycash":0}', NULL),
	(6590, 'society_aztecas', '{"weapons":[{"name":"WEAPON_GOLFCLUB","count":0},{"name":"WEAPON_SWITCHBLADE","count":0},{"name":"WEAPON_PISTOL","count":0}],"dirtycash":724}', NULL),
	(6792, 'society_kkangpae', '{"dirtycash":179538}', NULL),
	(6825, 'society_triade', '{"dirtycash":0,"weapons":[{"count":3,"name":"WEAPON_PISTOL"},{"count":0,"name":"WEAPON_HEAVYPISTOL"},{"count":0,"name":"WEAPON_VINTAGEPISTOL"},{"count":0,"name":"WEAPON_MOLOTOV"},{"count":0,"name":"WEAPON_BZGAS"},{"count":0,"name":"WEAPON_MINISMG"},{"count":2,"name":"WEAPON_BAT"},{"count":4,"name":"WEAPON_FLARE"},{"count":7,"name":"WEAPON_SAWNOFFSHOTGUN"}]}', NULL),
	(6827, 'society_mayans', '{"weapons":[{"name":"WEAPON_BAT","count":0},{"name":"WEAPON_PISTOL","count":0},{"name":"WEAPON_POOLCUE","count":0},{"name":"WEAPON_STONE_HATCHET","count":0},{"name":"WEAPON_GOLFCLUB","count":0},{"name":"WEAPON_HATCHET","count":0},{"name":"WEAPON_SWITCHBLADE","count":0},{"name":"WEAPON_DAGGER","count":0},{"name":"WEAPON_MACHETE","count":0},{"name":"WEAPON_FLARE","count":0}],"dirtycash":0}', NULL),
	(6828, 'society_hudson', '{"dirtycash":0,"weapons":[{"name":"WEAPON_PISTOL","count":0},{"name":"WEAPON_KNUCKLE","count":0},{"name":"WEAPON_SNSPISTOL","count":0},{"name":"WEAPON_FLARE","count":0}]}', NULL),
	(6896, 'society_pawnshop', '{"weapons":[{"count":1,"name":"WEAPON_GOLFCLUB"}],"dirtycash":25}', NULL),
	(7023, 'society_mcreary', '{"weapons":[{"name":"WEAPON_GOLFCLUB","count":0}]}', NULL),
	(7708, 'society_noodle', '{"weapons":[]}', NULL),
	(8429, 'society_bahamas', '{"dirtycash":0}', NULL),
	(9024, 'society_oneil', '{"weapons":[],"dirtycash":4000}', NULL),
	(12133, 'society_ltd_sud', '{"weapons":[{"name":"WEAPON_DAGGER","count":1,"ammo":0}],"dirtycash":0}', NULL),
	(14128, 'society_aod', '{}', NULL),
	(14129, 'society_avocat', '{}', NULL),
	(14130, 'society_bandadiaz', '{}', NULL),
	(14131, 'society_blackv', '{}', NULL),
	(14132, 'society_blueboys', '{}', NULL),
	(14133, 'society_bmf', '{}', NULL),
	(14134, 'society_castillo', '{}', NULL),
	(14135, 'society_duggan', '{}', NULL),
	(14136, 'society_fag', '{}', NULL),
	(14137, 'society_fbi', '{}', NULL),
	(14138, 'society_forelli', '{}', NULL),
	(14139, 'society_fuerza', '{}', NULL),
	(14140, 'society_harmony', '{}', NULL),
	(14141, 'society_jashari', '{}', NULL),
	(14142, 'society_loco', '{}', NULL),
	(14143, 'society_ltd_nord', '{}', NULL),
	(14144, 'society_mafiaarmenienne', '{}', NULL),
	(14145, 'society_mendez', '{}', NULL),
	(14146, 'society_michoacana', '{}', NULL),
	(14147, 'society_professionnels', '{}', NULL),
	(14148, 'society_redent', '{}', NULL),
	(14149, 'society_reiffen', '{}', NULL),
	(14150, 'society_sula', '{}', NULL),
	(14151, 'society_taxi', '{}', NULL);
/*!40000 ALTER TABLE `datastore_data` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. fine_types
CREATE TABLE IF NOT EXISTS `fine_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label` varchar(255) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `category` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=latin1;

-- Listage des données de la table california_dev.fine_types : ~114 rows (environ)
/*!40000 ALTER TABLE `fine_types` DISABLE KEYS */;
INSERT INTO `fine_types` (`id`, `label`, `amount`, `category`) VALUES
	(1, 'Refus de présenter ses papiers', 150, 0),
	(2, 'Rassemblement illégal / Manifestation non autorisée', 200, 0),
	(3, 'Pollution sonore', 200, 0),
	(4, 'Ebriété sur la voie publique', 200, 0),
	(5, 'Téléphone au volant', 200, 0),
	(6, 'Mendicité en lieu public', 200, 0),
	(7, 'Phares éteint la nuit', 250, 0),
	(8, 'Non port du casque en deux roues', 250, 0),
	(9, 'Griller un stop / feu rouge', 250, 0),
	(10, 'Excès de vitesse léger (-30km/h)', 250, 0),
	(11, 'Stationnement gênant / interdit', 250, 0),
	(12, 'Conduite dangereuse mineure', 250, 0),
	(13, 'Conduite en contresens', 250, 0),
	(14, 'Dissimulation de visage / Port du masque / Port de holster', 250, 0),
	(15, 'Menaces', 250, 0),
	(16, 'Présence piétonne sur une autoroute', 250, 0),
	(17, 'Agression verbal d’un civil', 300, 0),
	(18, 'Propos racistes', 300, 0),
	(19, 'Propos sexistes', 300, 0),
	(20, 'Conduite dangereuse mineure avec circonstances aggravantes', 300, 0),
	(21, 'Véhicule en non état de circulation (portière cassée / moteur fumant / etc...)', 300, 0),
	(22, 'Outrage à agent', 300, 0),
	(23, 'Conduite en état d’ivresse', 350, 0),
	(24, 'Possession d\'arme blanche', 500, 0),
	(25, 'Refus d\'obtemperer', 500, 0),
	(26, 'Harcelement verbal / Cyber-harcèlement', 500, 0),
	(27, 'Possession d\'objets illégaux (Kit crochetage, etc...)', 800, 0),
	(28, 'Possesion de pochons légère +2 mais -5', 850, 0),
	(29, 'Excès de vitesse moyen (+30km/h)', 850, 0),
	(30, 'Abus de pouvoir léger', 850, 0),
	(31, 'Véhicule non homologué pour la route (Aucunes plaques, Etc...)', 1000, 0),
	(32, 'Menaces sur agent asermenté', 2500, 0),
	(33, 'Conduite d’un véhicule volé', 450, 1),
	(34, 'Vol de véhicule en flagrant délit', 450, 1),
	(35, 'Conduite dangereuse majeure', 800, 1),
	(36, 'Entrave à la justice / Action de police', 800, 1),
	(37, 'Défaut de permis', 800, 1),
	(38, 'Trouble à l\'ordre publique', 800, 1),
	(39, 'Tentative de corruption légère', 800, 1),
	(40, 'Conduite dangereuse majeure avec circonstances aggravantes', 850, 1),
	(41, 'Diffamation', 1000, 1),
	(42, 'Possession d\'argent sale entre 3 000$ et 6 000$', 1000, 1),
	(43, 'Racket', 1200, 1),
	(44, 'Sortie d\'arme à feu', 1200, 1),
	(45, 'Agression physique d’un civil', 1500, 1),
	(46, 'Intrusion dans une propriété privée', 1500, 1),
	(47, 'Abus de pouvoir moyen', 1500, 1),
	(48, 'Possession de drogues moyenne +5 mais -20', 2500, 1),
	(49, 'Excès de vitesse lourd (+ de 60km/h)', 3000, 1),
	(50, 'Agression physique d’un policier en service', 5000, 1),
	(51, 'Course illégale', 250, 1),
	(52, 'Arnaque Moyenne', 350, 1),
	(53, 'Abus de Confiance sur agent de l\'état', 350, 1),
	(54, 'Abus de Faiblesse', 350, 1),
	(55, 'Braquer une personne avec une arme à feu', 500, 1),
	(56, 'Complicité de délit de fuite', 600, 1),
	(57, 'Association de malfaiteurs', 600, 1),
	(58, 'Agression physique avec arme blanche', 650, 1),
	(59, 'Car-jacking', 650, 1),
	(60, 'Arnaque légère', 350, 1),
	(61, 'Chantage', 800, 1),
	(62, 'Délit de fuite', 900, 1),
	(63, 'Complicité de braquage de supérette', 200, 2),
	(64, 'Agression en bande organisé sans dommage corporel de la ou les victimes', 450, 2),
	(65, 'Dégradations de bien publics', 500, 2),
	(66, 'Faux Appel 911 / Harcelement du répondeur', 500, 2),
	(67, 'Traffic d\'arme blanche', 750, 2),
	(68, 'Braquage de supérette', 800, 2),
	(69, 'Fabrication de drogue légère', 800, 2),
	(70, 'Abus de pouvoir grave', 800, 2),
	(71, 'Non assistance à personne en danger', 800, 2),
	(72, 'Intrusion dans une base sécurisée', 800, 2),
	(73, 'Possession d’arme(s) à feu illégale(s) légère(s)', 950, 2),
	(74, 'Possession d\'explosif(s) léger(s)', 950, 2),
	(75, 'Possession d\'équipements tactiques (Kevlar, etc...)', 950, 2),
	(76, 'Tentative de Braquage de Banque (Carte d\'accès au coffre)', 1200, 2),
	(77, 'Flagrant délit de vente de drogue', 1200, 2),
	(78, 'Possession d\'arme(s) à feu illégale(s) moyenne(s)', 1250, 2),
	(79, 'Possession d\'explosif(s) moyen(s)', 1250, 2),
	(80, 'Fabrication de drogue forte (> 100 dans le véhicule)', 1250, 2),
	(81, 'Complicité de Prise d\'otage', 2500, 2),
	(82, 'Tentative d’évasion de Prison', 2500, 2),
	(83, 'Tirer en lieu publique', 2500, 2),
	(84, 'Tentative de meurtre', 3500, 2),
	(85, 'Évasion de Prison', 3500, 2),
	(86, 'Possession de drogues lourde 20 & +', 4500, 2),
	(87, 'Tentative de corruption légère', 5000, 2),
	(88, 'Kidnapping', 5000, 2),
	(89, 'Possession d\'argent sale entre 6 000$ et 50 000$', 5000, 2),
	(90, 'Séquestration avec arme blanche', 3500, 3),
	(91, 'Règlement de compte entre groupes avec armes a feu', 3500, 3),
	(92, 'Braquage de banque avec arme', 3500, 3),
	(93, 'Arnaque Grave', 4000, 3),
	(94, 'Homicide involontaire / sous contrainte', 4000, 3),
	(95, 'Mutilations', 4500, 3),
	(96, 'Séquestration avec arme à feu', 5000, 3),
	(97, 'Commanditation de meurtre / Assassinat', 5000, 3),
	(98, 'Fraude Fiscale (Amende : Patron & Entreprise donc 2 Amendes)', 5000, 3),
	(99, 'Trafic de drogue', 5000, 3),
	(100, 'Possession d\'explosif(s) lourd(s)', 6000, 3),
	(101, 'Possession d’arme(s) à feu illégale(s) lourde(s)', 6000, 3),
	(102, 'Agression en bande organisé ayant entraîné des dommages corporel à la ou les victimes', 7500, 3),
	(103, 'Prise d’otage', 7500, 3),
	(104, 'Détournement de fond', 7500, 3),
	(105, 'Possession d\'argent sale + de 50 000$', 10000, 3),
	(106, 'Détournement de fond', 15000, 3),
	(107, 'Homicide volontaire / Préméditation', 25000, 3),
	(108, 'Non paiement d\'amende (+ de 200 000$ d\'amendes impayées)', 25000, 3),
	(109, 'Complicité de prise d\'otage sur agent de l\'état', 50000, 3),
	(110, 'Tentative de meutre sur agent du gouvernement (Procureur/Magistrat/Gouverneur)', 75000, 3),
	(111, 'Tentative de meurtre sur agent de l’etat', 75000, 3),
	(112, 'Kidnapping d\'agent assermenté / Chien y comprit', 250000, 3),
	(113, 'Prise d’otage sur agent de l’état', 250000, 3),
	(114, 'Meurtre d\'un agent de l\'état/services publiques', 400000, 3);
/*!40000 ALTER TABLE `fine_types` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. garage
CREATE TABLE IF NOT EXISTS `garage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(80) NOT NULL,
  `ownerInfo` varchar(255) NOT NULL DEFAULT 'none',
  `infos` text NOT NULL,
  `vehicles` text NOT NULL,
  `createdAt` text NOT NULL,
  `createdBy` varchar(80) NOT NULL,
  `street` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Listage des données de la table california_dev.garage : ~0 rows (environ)
/*!40000 ALTER TABLE `garage` DISABLE KEYS */;
/*!40000 ALTER TABLE `garage` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. items
CREATE TABLE IF NOT EXISTS `items` (
  `name` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `label` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `weight` float NOT NULL DEFAULT 1,
  `rare` tinyint(1) NOT NULL DEFAULT 0,
  `can_remove` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Listage des données de la table california_dev.items : ~113 rows (environ)
/*!40000 ALTER TABLE `items` DISABLE KEYS */;
INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
	('armor', 'Kevlar', 5, 0, 1),
	('assiette_de_sushis', 'Assiette de Sushis', 1, 0, 1),
	('bandage', 'Bandage', 0.5, 0, 1),
	('bed', 'Lit', 20, 0, 1),
	('beer', 'Bière', 0.2, 0, 1),
	('beer_2', 'Bière sans alcool', 1, 0, 1),
	('big_fish', 'Gros poisson', 1, 0, 1),
	('bmx', 'BMX', 10, 0, 1),
	('bol_de_nouilles', 'Bol de Nouilles', 1, 0, 1),
	('bread', 'Pain', 0.5, 0, 1),
	('burger', 'Burger', 0.8, 0, 1),
	('canne_peche', 'Canne à pêche', 2, 0, 1),
	('carpecuir', 'Carpe cuir', 8, 0, 1),
	('casserole', 'Casserole', 3, 0, 1),
	('chips', 'Chips', 1, 0, 1),
	('chocolate', 'Tablette de chocolat', 1, 0, 1),
	('clip', 'Chargeur', 1, 0, 1),
	('coca', 'Coca', 0.5, 0, 1),
	('coca_acide', 'Acide chlorhydrique', 1, 0, 1),
	('coca_feuille', 'Feuille de coca', 1, 0, 1),
	('coke', 'Coke', 1, 0, 1),
	('coke_coupe', 'Coke coupée', 1, 0, 1),
	('coke_pooch', 'Pochon de coke', 1, 0, 1),
	('cola', 'Cola', 0.5, 0, 1),
	('cruiser', 'Cruiser', 10, 0, 1),
	('cutter', 'Cutter', 2, 0, 1),
	('diable', 'Diable', 10, 0, 1),
	('donut', 'Donut', 1, 0, 1),
	('engine', 'Moteur', 10, 0, 1),
	('fish', 'Poisson', 1, 0, 1),
	('fishd', 'Poisson abattu', 1, 0, 1),
	('fixkit', 'Kit réparation', 5, 0, 1),
	('fixter', 'Fixter', 10, 0, 1),
	('fixtool', 'Outils réparation', 4, 0, 1),
	('frites', 'Frites', 0.5, 0, 1),
	('frites_chauffe', 'Frites chauffé', 0.5, 0, 1),
	('golf', 'Balle de golf', 1, 0, 1),
	('golf_green', 'Balle de golf (verte)', 1, 0, 1),
	('golf_pink', 'Balle de golf (rose)', 1, 0, 1),
	('golf_yellow', 'Balle de golf (jaune)', 1, 0, 1),
	('hotdog', 'Hot-dog', 1, 0, 1),
	('id_card_f', 'Malicious Access Card', 2, 0, 1),
	('jumelles', 'Jumelles', 0.5, 0, 0),
	('jus_leechi', 'Jus de Leechi', 1, 0, 1),
	('jus_orange', 'Jus d\'orange', 1, 0, 1),
	('kit_de_crochetage', 'Kit de Crochetage', 5, 0, 1),
	('kit_de_lavage', 'Kit de lavage', 7, 0, 1),
	('limonade', 'Limonade', 0.5, 0, 1),
	('lockpick', 'Lockpick', 0.4, 0, 1),
	('loot_flare', 'Loot flare', 1, 0, 1),
	('maki', 'Maki', 0.5, 0, 1),
	('medikit', 'Medikit', 2, 0, 1),
	('meth', 'Meth', 1, 0, 1),
	('meth_coupe', 'Methamphétamine coupée', 1, 0, 1),
	('meth_lode', 'Iode cristalisé', 1, 0, 1),
	('meth_phosphore', 'Phosphore rouge', 1, 0, 1),
	('meth_pooch', 'Pochon de meth', 1, 0, 1),
	('mor_fish', 'Morceau de poisson', 0.5, 0, 1),
	('morbig_fish', 'Morceau de gros poisson', 1, 0, 1),
	('morviande_1', 'Morceau de viande blanche', 1, 0, 1),
	('morviande_2', 'Morceau de viande rouge', 1, 0, 1),
	('moteur', 'Moteur', 7, 0, 1),
	('oeuvreart', 'Œuvre d\'art', 8, 0, 1),
	('oeuvreart_luxe', 'Œuvre d\'art de luxe', 8, 0, 1),
	('opium', 'Opium', 1, 0, 1),
	('opium_pooch', 'Pochon d\'Opium', 1, 0, 1),
	('ors', 'Pépites d\'or', 2, 0, 1),
	('outils', 'Trousse à outils', 5, 0, 1),
	('oxygen_mask', 'Masque à Oxygène', 0.6, 0, 1),
	('pate', 'Pâte fraîche', 0.5, 0, 1),
	('peinture', 'Peinture', 10, 0, 1),
	('peinture_luxe', 'Peinture de luxe', 10, 0, 1),
	('pelle', 'Pelle', 5, 0, 1),
	('perfusion', 'Perfusion', 1, 0, 1),
	('phone', 'Téléphone', 0.5, 0, 1),
	('pizza', 'Pizza', 0.5, 0, 1),
	('pneu', 'Roue de secours', 9, 0, 1),
	('pompom', 'Poisson pompom', 1, 0, 1),
	('radio', 'Radio', 1, 0, 1),
	('redbull', 'Redbull', 0.3, 0, 1),
	('redfish', 'Poisson rouge', 1, 0, 1),
	('repairkit', 'kit réparation', 5, 0, 1),
	('rouleau_de_printemps', 'Rouleau de Printemps', 1, 0, 1),
	('sake', 'Saké', 2, 0, 1),
	('salade', 'Salade', 0.5, 0, 1),
	('salade_fraiche', 'Salade fraîche', 0.5, 0, 1),
	('sandwich', 'Sandwich', 1, 0, 1),
	('secure_card', 'Secure ID Card', 2, 3, 1),
	('soda', 'Soda', 1, 0, 1),
	('soupe_de_nouille', 'Soupe de Nouille', 1, 0, 1),
	('spaghetti_bolognaise', 'Spaghetti bolognaise', 1, 0, 1),
	('spike', 'Herse', 10, 0, 1),
	('steaks_cuit', 'Steak cuit', 0.5, 0, 1),
	('tequila', 'Tequila', 0.7, 0, 1),
	('terre', 'Terre', 3, 0, 1),
	('the_vert', 'Thé vert', 0.5, 0, 1),
	('tomate', 'Tomate', 0.5, 0, 1),
	('tomate_coupe', 'Tomate coupé', 0.5, 0, 1),
	('tribike', 'TriBike Jaune', 10, 0, 1),
	('tribike2', 'TriBike Rouge', 10, 0, 1),
	('tribike3', 'TriBike Bleu', 10, 0, 1),
	('ventouse', 'Ventouse', 3, 0, 1),
	('viande_1', 'Viande Blanche', 2, 0, 1),
	('viande_2', 'Viande Rouge', 2, 0, 1),
	('vodka', 'Vodka', 1, 0, 1),
	('water', 'Bouteille d\'eau', 0.7, 0, 1),
	('weed', 'Weed', 1, 0, 1),
	('weed_fertiligene', 'Fertiligène', 1, 0, 1),
	('weed_graine', 'Graine de cannabis', 1, 0, 1),
	('weed_pooch', 'Pochon de weed', 1, 0, 1),
	('wheelchair', 'Fauteuil Roulant', 10, 0, 1),
	('whisky', 'Whisky', 0.7, 0, 1),
	('whitefish', 'Poisson blanc', 3, 0, 1);
/*!40000 ALTER TABLE `items` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. jobs
CREATE TABLE IF NOT EXISTS `jobs` (
  `name` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `label` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Listage des données de la table california_dev.jobs : ~65 rows (environ)
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
INSERT INTO `jobs` (`name`, `label`) VALUES
	('410', '410'),
	('agentimmo', 'Agent Immobilier'),
	('ambulance', 'Emergency Medical Services'),
	('aod', 'Angels of Death'),
	('avocat', 'Avocat'),
	('aztecas', 'Aztecas'),
	('bahamas', 'Bahamas Mamas'),
	('ballas', 'Ballas'),
	('bandadiaz', 'Banda Diaz'),
	('biker', 'Sons of Anarchy'),
	('blackv', 'Black Vanguard'),
	('blueboys', 'Blue Boys'),
	('bmf', 'Black Mafia Family'),
	('boneli', 'Boneli'),
	('burgershot', 'Burgershot'),
	('carshop', 'Concessionnaire'),
	('castillo', 'Cartel Castillo'),
	('coronado', 'Cartel de Coronado'),
	('cosanostra', 'Cosa Nostra'),
	('duggan', 'Duggan Crime Family'),
	('fag', 'Fuere Apache Grande'),
	('families', 'Chamberlain Hills Families'),
	('fbi', 'Federal Bureau of Investigation'),
	('forelli', 'Forelli Crime Family'),
	('fuerza', 'Fuerza Argentina'),
	('gouvernement', 'Gouvernement'),
	('harmony', 'Harmony Repair & Custom'),
	('hudson', 'Famille Hudson'),
	('jashari', 'Mafia Jashari'),
	('kkangpae', 'Kkangpae'),
	('loco', 'Loco Syndicate'),
	('lssd', 'Los Santos Sheriff\'s Department'),
	('ltd_nord', 'LTD Nord'),
	('ltd_sud', 'LTD Sud'),
	('madrazo', 'Cartel de Madrazo'),
	('mafiaarmenienne', 'Mafia arménienne'),
	('marabunta', 'Marabunta'),
	('mayans', 'Mayans MC'),
	('mcreary', 'Mcreary'),
	('mecano', 'Mécano'),
	('medelin', 'Cartel de Medellín'),
	('mendez', 'Cartel de Mendez'),
	('michoacana', 'Familia Michoacana'),
	('mnc', 'MinNightClick'),
	('motoshop', 'Concessionnaire Moto'),
	('noodle', 'Noodle Exchange'),
	('oneil', 'O\'Neil'),
	('pawnshop', 'Pawnshop'),
	('pizza', 'Drusilla\'s Pizza'),
	('police', 'Los Santos Police Department'),
	('postop', 'Post OP'),
	('professionnels', 'Les Professionnels'),
	('redent', 'Redent'),
	('reiffen', 'Reiffen'),
	('russe', 'Mafia russe'),
	('sula', 'Cartel Sula'),
	('taxi', 'Downtown Cab Co'),
	('triade', 'Triade'),
	('unemployed', 'Chômeur'),
	('unemployed2', 'Aucune'),
	('unicorn', 'Unicorn'),
	('vagos', 'Vagos'),
	('yakuza', 'Yakuza'),
	('yellowjack', 'YellowJack'),
	('zetas', 'Zetas');
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. job_grades
CREATE TABLE IF NOT EXISTS `job_grades` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job_name` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `grade` int(11) NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `label` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `salary` int(11) NOT NULL,
  `skin_male` longtext COLLATE utf8mb4_bin NOT NULL,
  `skin_female` longtext COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1068 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Listage des données de la table california_dev.job_grades : ~320 rows (environ)
/*!40000 ALTER TABLE `job_grades` DISABLE KEYS */;
INSERT INTO `job_grades` (`id`, `job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
	(43, 'mecano', 0, 'recrue', 'Recrue', 70, '{}', '{}'),
	(44, 'mecano', 1, 'novice', 'Novice', 80, '{}', '{}'),
	(45, 'mecano', 2, 'experimente', 'Experimente', 90, '{}', '{}'),
	(46, 'mecano', 3, 'chief', 'Chef', 100, '{}', '{}'),
	(47, 'mecano', 4, 'boss', 'Patron', 120, '{}', '{}'),
	(74, 'unemployed', 0, 'unemployed', 'RSA', 25, '{}', '{}'),
	(157, 'unemployed2', 0, 'unemployed2', 'Citoyen', 0, '{}', '{}'),
	(462, 'carshop', 0, 'novice', 'Novice', 50, '{}', '{}'),
	(463, 'carshop', 1, 'sergeant', 'Intermediaire', 60, '{}', '{}'),
	(464, 'carshop', 2, 'experienced', 'Experimente', 70, '{}', '{}'),
	(465, 'carshop', 3, 'boss', 'Patron', 80, '{}', '{}'),
	(524, 'motoshop', 0, 'novice', 'Novice', 70, '{}', '{}'),
	(525, 'motoshop', 1, 'sergeant', 'Intermediaire', 80, '{}', '{}'),
	(526, 'motoshop', 2, 'experienced', 'Experimente', 90, '{}', '{}'),
	(527, 'motoshop', 3, 'boss', 'Patron', 100, '{}', '{}'),
	(528, 'postop', 0, 'novice', 'Novice', 150, '{}', '{}'),
	(656, 'biker', 0, 'small', 'Prospect', 150, '{}', '{}'),
	(657, 'biker', 1, 'big', 'Road Captain', 150, '{}', '{}'),
	(658, 'biker', 2, 'sgt', 'SGT At arms', 150, '{}', '{}'),
	(659, 'biker', 3, 'tres', 'Trésorier', 150, '{}', '{}'),
	(660, 'biker', 4, 'vpres', 'Vice-président', 150, '{}', '{}'),
	(661, 'biker', 5, 'boss', 'Président', 150, '{}', '{}'),
	(662, 'unicorn', 0, 'small', 'Serveur', 70, '{}', '{}'),
	(663, 'unicorn', 1, 'big', 'Gérant', 80, '{}', '{}'),
	(664, 'unicorn', 2, 'boss', 'Patron', 90, '{}', '{}'),
	(665, 'agentimmo', 0, 'novice', 'Employé', 80, '{}', '{}'),
	(666, 'agentimmo', 1, 'co_pdg', 'Co-Pdg', 90, '{}', '{}'),
	(667, 'agentimmo', 2, 'boss', 'Patron', 100, '{}', '{}'),
	(692, 'avocat', 0, 'avocat', 'Avocat', 150, '{}', '{}'),
	(693, 'avocat', 1, 'boss', 'Patron', 250, '{}', '{}'),
	(696, 'marabunta', 0, 'ninos', 'Ninos', 0, '{}', '{}'),
	(697, 'marabunta', 1, 'miembro', 'Miembro', 0, '{}', '{}'),
	(698, 'marabunta', 2, 'matador', 'Matador', 0, '{}', '{}'),
	(699, 'marabunta', 3, 'manoderecho', 'Mano derecho', 0, '{}', '{}'),
	(700, 'marabunta', 4, 'boss', 'Jefe', 0, '{}', '{}'),
	(710, 'zetas', 0, 'pequeno', 'Pequeno', 0, '{}', '{}'),
	(711, 'zetas', 1, 'soldado', 'Soldado', 0, '{}', '{}'),
	(712, 'zetas', 2, 'soldadoconfirmado', 'Soldado Confirmado', 0, '{}', '{}'),
	(713, 'zetas', 3, 'commandante', 'Commandante', 0, '{}', '{}'),
	(714, 'zetas', 4, 'dirigentes', 'Dirigentes', 0, '{}', '{}'),
	(715, 'zetas', 5, 'boss', 'Jefe', 0, '{}', '{}'),
	(721, 'burgershot', 0, 'recrue', 'Recrue', 70, '{}', '{}'),
	(722, 'burgershot', 1, 'employe', 'Employé', 80, '{}', '{}'),
	(723, 'burgershot', 2, 'boss', 'Patron', 100, '{}', '{}'),
	(724, 'pizza', 0, 'recruit', 'Recrue', 50, '{}', '{}'),
	(725, 'pizza', 1, 'employer', 'Employer', 60, '{}', '{}'),
	(726, 'pizza', 2, 'boss', 'Patron', 70, '{}', '{}'),
	(741, 'families', 0, 'gangsta', 'Gangsta', 0, '{}', '{}'),
	(742, 'families', 1, 'homie', 'Homie', 0, '{}', '{}'),
	(743, 'families', 2, 'boss', 'OG', 0, '{}', '{}'),
	(744, 'madrazo', 0, 'pequenio', 'Pequenio', 0, '{}', '{}'),
	(745, 'madrazo', 1, 'soldado', 'Soldado', 0, '{}', '{}'),
	(746, 'madrazo', 2, 'teniente', 'Teniente', 0, '{}', '{}'),
	(747, 'madrazo', 3, 'brazoderecho', 'Brazo derecho', 0, '{}', '{}'),
	(748, 'madrazo', 4, 'boss', 'Jefe', 0, '{}', '{}'),
	(761, 'medelin', 0, 'recrue', 'Recrue', 0, '{}', '{}'),
	(762, 'medelin', 1, 'hommedemain', 'Homme de main', 0, '{}', '{}'),
	(763, 'medelin', 2, 'sergent', 'Sergent', 0, '{}', '{}'),
	(764, 'medelin', 3, 'lieutenant', 'Lieutenant', 0, '{}', '{}'),
	(765, 'medelin', 4, 'brasdroit', 'Bras droit', 0, '{}', '{}'),
	(766, 'medelin', 5, 'boss', 'Patron', 0, '{}', '{}'),
	(767, 'mnc', 0, 'member', 'Member', 0, '{}', '{}'),
	(768, 'mnc', 1, 'hit', 'Hit', 0, '{}', '{}'),
	(769, 'mnc', 2, 'underboss', 'Under boss', 0, '{}', '{}'),
	(770, 'mnc', 3, 'boss', 'MNC', 0, '{}', '{}'),
	(771, 'yakuza', 0, 'shatei', 'Shatei', 0, '{}', '{}'),
	(772, 'yakuza', 1, 'kyodai', 'Kyodai', 0, '{}', '{}'),
	(773, 'yakuza', 2, 'saiki', 'Saiki', 0, '{}', '{}'),
	(774, 'yakuza', 3, 'gashia', 'Gashia', 0, '{}', '{}'),
	(775, 'yakuza', 4, 'waka', 'Waka', 0, '{}', '{}'),
	(776, 'yakuza', 5, 'boss', 'Oyabun', 0, '{}', '{}'),
	(777, '410', 0, 'younger', 'Younger', 0, '{}', '{}'),
	(778, '410', 1, 'realgangsta', 'Real Gangsta', 0, '{}', '{}'),
	(779, '410', 2, 'older', 'Older', 0, '{}', '{}'),
	(780, '410', 3, 'boss', 'Leader', 0, '{}', '{}'),
	(795, 'cosanostra', 0, 'recrue', 'Recrue', 0, '{}', '{}'),
	(796, 'cosanostra', 1, 'soldat', 'Soldat', 0, '{}', '{}'),
	(797, 'cosanostra', 2, 'lieutenant', 'Lieutenant', 0, '{}', '{}'),
	(798, 'cosanostra', 3, 'capos', 'Capos', 0, '{}', '{}'),
	(799, 'cosanostra', 4, 'sousboss', 'Sous Boss', 0, '{}', '{}'),
	(800, 'cosanostra', 5, 'boss', 'Patron', 0, '{}', '{}'),
	(801, 'coronado', 0, 'soldado', 'Soldado', 0, '{}', '{}'),
	(802, 'coronado', 1, 'teniente', 'Teniente', 0, '{}', '{}'),
	(803, 'coronado', 2, 'brazo', 'Brazo', 0, '{}', '{}'),
	(804, 'coronado', 3, 'boss', 'Patron', 0, '{}', '{}'),
	(805, 'ballas', 0, 'petit', 'Petit', 0, '{}', '{}'),
	(806, 'ballas', 1, 'dealer', 'Young Homies', 0, '{}', '{}'),
	(807, 'ballas', 2, 'thug', 'Homies', 0, '{}', '{}'),
	(808, 'ballas', 3, 'grand', 'Street Homies', 0, '{}', '{}'),
	(809, 'ballas', 4, 'ancien', 'Hustler', 0, '{}', '{}'),
	(810, 'ballas', 5, 'brasdroit', 'YG', 0, '{}', '{}'),
	(811, 'ballas', 6, 'boss', 'OG', 0, '{}', '{}'),
	(812, 'russe', 0, 'soldat', 'Soldat', 0, '{}', '{}'),
	(813, 'russe', 1, 'soldatelite', 'Soldat elite', 0, '{}', '{}'),
	(814, 'russe', 2, 'caporal', 'Caporal', 0, '{}', '{}'),
	(815, 'russe', 3, 'lieutenant', 'Lieutenant', 0, '{}', '{}'),
	(816, 'russe', 4, 'brasdroit', 'Bras-droit', 0, '{}', '{}'),
	(817, 'russe', 5, 'boss', 'Parrain', 0, '{}', '{}'),
	(834, 'redent', 0, 'redent', 'Redent', 0, '{}', '{}'),
	(835, 'yellowjack', 0, 'serveur', 'Serveur', 70, '{}', '{}'),
	(836, 'yellowjack', 1, 'gerant', 'Gérant', 80, '{}', '{}'),
	(837, 'yellowjack', 2, 'boss', 'Patron', 90, '{}', '{}'),
	(838, 'gouvernement', 0, 'recruesecurite', 'Recrue Sécurité', 45, '{}', '{}'),
	(839, 'gouvernement', 1, 'agentsecurite', 'Agent Sécurité', 55, '{}', '{}'),
	(840, 'gouvernement', 2, 'superviseursecurite', 'Superviseur Sécurité', 70, '{}', '{}'),
	(841, 'gouvernement', 3, 'directeursecurite', 'Directeur Sécurité', 90, '{}', '{}'),
	(842, 'gouvernement', 4, 'avocat', 'Avocat', 100, '{}', '{}'),
	(843, 'gouvernement', 5, 'directeuravocat', 'Directeur Avocat', 105, '{}', '{}'),
	(844, 'gouvernement', 6, 'assistantgouvernemental', 'Assistant Gouvernemental', 75, '{}', '{}'),
	(845, 'gouvernement', 7, 'huissierjustice', 'Huissier de Justice', 100, '{}', '{}'),
	(846, 'gouvernement', 8, 'magistrat', 'Magistrat', 100, '{}', '{}'),
	(847, 'gouvernement', 9, 'procureur', 'Procureur', 100, '{}', '{}'),
	(848, 'gouvernement', 10, 'boss', 'Gouverneur', 200, '{}', '{}'),
	(849, 'aztecas', 0, 'nuevo', 'Nuevo', 0, '{}', '{}'),
	(850, 'aztecas', 1, 'sangre', 'Sangre', 0, '{}', '{}'),
	(851, 'aztecas', 2, 'hermanomayor', 'Hermano Mayor', 0, '{}', '{}'),
	(852, 'aztecas', 3, 'brazoderecho', 'Brazo Derecho', 0, '{}', '{}'),
	(853, 'aztecas', 4, 'boss', 'Jefe', 0, '{}', '{}'),
	(854, 'boneli', 0, 'cugino', 'Cugino', 0, '{}', '{}'),
	(855, 'boneli', 1, 'fratello', 'Fratello', 0, '{}', '{}'),
	(856, 'boneli', 2, 'capo', 'Capo', 0, '{}', '{}'),
	(857, 'boneli', 3, 'brasdroit', 'Bras Droit', 0, '{}', '{}'),
	(858, 'boneli', 4, 'boss', 'Don', 0, '{}', '{}'),
	(859, 'mayans', 0, 'pequeno', 'Pequeno', 0, '{}', '{}'),
	(860, 'mayans', 1, 'miembro', 'Miembro', 0, '{}', '{}'),
	(861, 'mayans', 2, 'elpacificador', 'El Pacificador', 0, '{}', '{}'),
	(862, 'mayans', 3, 'elsecretario', 'El Secretario', 0, '{}', '{}'),
	(863, 'mayans', 4, 'videpresidente', 'Vice-Presidente', 0, '{}', '{}'),
	(864, 'mayans', 5, 'boss', 'Presidente', 0, '{}', '{}'),
	(865, 'hudson', 0, 'aine', 'Ainée', 0, '{}', '{}'),
	(866, 'hudson', 1, 'boss', 'Famille Hudson', 0, '{}', '{}'),
	(867, 'triade', 0, 'kobun', 'Kobun', 0, '{}', '{}'),
	(868, 'triade', 1, 'kenshou', 'Ken\'Shou', 0, '{}', '{}'),
	(869, 'triade', 2, 'saiko', 'Saiko', 0, '{}', '{}'),
	(870, 'triade', 3, 'souke', 'Souke', 0, '{}', '{}'),
	(871, 'triade', 4, 'boss', 'Oyabun', 0, '{}', '{}'),
	(872, 'mcreary', 0, 'litleboy', 'Little Boy', 0, '{}', '{}'),
	(873, 'mcreary', 1, 'boy', 'Boy', 0, '{}', '{}'),
	(874, 'mcreary', 2, 'bigboy', 'Big boy', 0, '{}', '{}'),
	(875, 'mcreary', 3, 'mac', 'Mac', 0, '{}', '{}'),
	(876, 'mcreary', 4, 'advisor', 'Advisor', 0, '{}', '{}'),
	(877, 'mcreary', 5, 'underboss', 'Under boss', 0, '{}', '{}'),
	(878, 'mcreary', 6, 'boss', 'Boss', 0, '{}', '{}'),
	(879, 'kkangpae', 0, 'soldat', 'Soldat', 0, '{}', '{}'),
	(880, 'kkangpae', 1, 'capot', 'Capot', 0, '{}', '{}'),
	(881, 'kkangpae', 2, 'brasgauche', 'Bras gauche', 0, '{}', '{}'),
	(882, 'kkangpae', 3, 'brasdroit', 'Bras droit', 0, '{}', '{}'),
	(883, 'kkangpae', 4, 'boss', 'Chef', 0, '{}', '{}'),
	(884, 'pawnshop', 0, 'vendeur', 'Vendeur', 0, '{}', '{}'),
	(885, 'pawnshop', 1, 'commercial', 'Commercial', 0, '{}', '{}'),
	(886, 'pawnshop', 2, 'boss', 'Patron', 0, '{}', '{}'),
	(887, 'harmony', 0, 'recrue', 'Recrue', 60, '{}', '{}'),
	(888, 'harmony', 1, 'novice', 'Novice', 70, '{}', '{}'),
	(889, 'harmony', 2, 'experimente', 'Experimente', 90, '{}', '{}'),
	(890, 'harmony', 3, 'chef', 'Chef', 100, '{}', '{}'),
	(891, 'harmony', 4, 'boss', 'Patron', 120, '{}', '{}'),
	(892, 'taxi', 0, 'chauffeur', 'Chauffeur', 70, '{}', '{}'),
	(893, 'taxi', 1, 'experimente', 'Experimente', 80, '{}', '{}'),
	(894, 'taxi', 2, 'boss', 'Patron', 100, '{}', '{}'),
	(895, 'noodle', 0, 'recrue', 'Recrue', 70, '{}', '{}'),
	(896, 'noodle', 1, 'employe', 'Employé', 80, '{}', '{}'),
	(897, 'noodle', 2, 'boss', 'Patron', 100, '{}', '{}'),
	(898, 'ltd_sud', 0, 'recrue', 'Recrue', 70, '{}', '{}'),
	(899, 'ltd_sud', 1, 'employe', 'Employé', 80, '{}', '{}'),
	(900, 'ltd_sud', 2, 'boss', 'Patron', 90, '{}', '{}'),
	(901, 'ltd_nord', 0, 'recrue', 'Recrue', 70, '{}', '{}'),
	(902, 'ltd_nord', 1, 'employe', 'Employé', 80, '{}', '{}'),
	(903, 'ltd_nord', 2, 'boss', 'Patron', 90, '{}', '{}'),
	(904, 'bahamas', 0, 'serveur', 'Serveur', 50, '{}', '{}'),
	(905, 'bahamas', 1, 'dj', 'Disc Jockey', 70, '{}', '{}'),
	(906, 'bahamas', 2, 'securite', 'Sécurité', 50, '{}', '{}'),
	(907, 'bahamas', 3, 'boss', 'Patron', 90, '{}', '{}'),
	(914, 'oneil', 0, 'cadet', 'Cadet', 0, '{}', '{}'),
	(915, 'oneil', 1, 'benjamin', 'Benjamin(e)', 0, '{}', '{}'),
	(916, 'oneil', 2, 'tresorier', 'Trésorier', 0, '{}', '{}'),
	(917, 'oneil', 3, 'secretaire', 'Secretaire', 0, '{}', '{}'),
	(918, 'oneil', 4, 'second', 'Second', 0, '{}', '{}'),
	(919, 'oneil', 5, 'boss', 'Lead O\'Neil', 0, '{}', '{}'),
	(920, 'blueboys', 0, 'recruit', 'Blue Recruit', 0, '{}', '{}'),
	(921, 'blueboys', 1, 'militiaman', 'Militiaman', 0, '{}', '{}'),
	(922, 'blueboys', 2, 'warrior', 'Colonel', 0, '{}', '{}'),
	(923, 'blueboys', 3, 'underleader', 'Advisor', 0, '{}', '{}'),
	(924, 'blueboys', 4, 'boss', 'Leader', 0, '{}', '{}'),
	(925, 'bandadiaz', 0, 'recrue', 'Recrue', 0, '{}', '{}'),
	(926, 'bandadiaz', 1, 'soldado', 'Soldado', 0, '{}', '{}'),
	(927, 'bandadiaz', 2, 'commandant', 'Commandant', 0, '{}', '{}'),
	(928, 'bandadiaz', 3, 'brasdroit', 'Bras droit', 0, '{}', '{}'),
	(929, 'bandadiaz', 4, 'boss', 'Patron', 0, '{}', '{}'),
	(930, 'mafiaarmenienne', 0, 'havak', 'Havak', 0, '{}', '{}'),
	(931, 'mafiaarmenienne', 1, 'henchman', 'Henchman', 0, '{}', '{}'),
	(932, 'mafiaarmenienne', 2, 'zinvor', 'Zinvor', 0, '{}', '{}'),
	(933, 'mafiaarmenienne', 3, 'zenk', 'Zenk', 0, '{}', '{}'),
	(934, 'mafiaarmenienne', 4, 'major', 'Major', 0, '{}', '{}'),
	(935, 'mafiaarmenienne', 5, 'boss', 'Shef', 0, '{}', '{}'),
	(936, 'vagos', 0, 'pequeno', 'Pequeno', 0, '{}', '{}'),
	(937, 'vagos', 1, 'soldado', 'Soldado', 0, '{}', '{}'),
	(938, 'vagos', 2, 'commandante', 'Commandante', 0, '{}', '{}'),
	(939, 'vagos', 3, 'teniente', 'Teniente', 0, '{}', '{}'),
	(940, 'vagos', 4, 'segundo', 'Segundo', 0, '{}', '{}'),
	(941, 'vagos', 5, 'boss', 'Jefe', 0, '{}', '{}'),
	(942, 'fbi', 0, 'agent', 'Agent', 0, '{}', '{}'),
	(943, 'fbi', 1, 'boss', 'Directeur', 0, '{}', '{}'),
	(944, 'ambulance', 0, 'recrue', 'Recrue', 55, '{}', '{}'),
	(945, 'ambulance', 1, 'urgentiste', 'Urgentiste', 60, '{}', '{}'),
	(946, 'ambulance', 2, 'infirmier', 'Infirmier', 65, '{}', '{}'),
	(947, 'ambulance', 3, 'medecin', 'Médecin', 70, '{}', '{}'),
	(948, 'ambulance', 4, 'medecin_chef', 'Médecin en chef', 75, '{}', '{}'),
	(949, 'ambulance', 5, 'superviseur', 'Superviseur', 80, '{}', '{}'),
	(950, 'ambulance', 6, 'assistant_de_direction', 'Assistant de direction', 85, '{}', '{}'),
	(951, 'ambulance', 7, 'sous_directeur', 'Sous directeur', 90, '{}', '{}'),
	(952, 'ambulance', 8, 'boss', 'Directeur', 95, '{}', '{}'),
	(953, 'police', 0, 'officier1', 'Officer I', 55, '{}', '{}'),
	(954, 'police', 1, 'officier2', 'Officer II', 60, '{}', '{}'),
	(955, 'police', 2, 'officier3', 'Officer III', 65, '{}', '{}'),
	(956, 'police', 3, 'senior_lead_officier', 'Senior lead officer', 70, '{}', '{}'),
	(957, 'police', 4, 'sergeant1', 'Sergeant I', 75, '{}', '{}'),
	(958, 'police', 5, 'sergeant2', 'Sergeant II', 80, '{}', '{}'),
	(959, 'police', 6, 'lieutenant1', 'Lieutenant I', 85, '{}', '{}'),
	(960, 'police', 7, 'lieutenant2', 'Lieutenant II', 90, '{}', '{}'),
	(961, 'police', 8, 'boss', 'Captain', 95, '{}', '{}'),
	(962, 'lssd', 0, 'deputy1', 'Deputy I', 55, '{}', '{}'),
	(963, 'lssd', 1, 'deputy2', 'Deputy II', 60, '{}', '{}'),
	(964, 'lssd', 2, 'deputy3', 'Deputy III', 65, '{}', '{}'),
	(965, 'lssd', 3, 'deputy_senior', 'Deputy senior', 70, '{}', '{}'),
	(966, 'lssd', 4, 'sergeant', 'Sergeant', 75, '{}', '{}'),
	(967, 'lssd', 5, 'lieutenant', 'Lieutenant', 80, '{}', '{}'),
	(968, 'lssd', 6, 'boss', 'Captain', 85, '{}', '{}'),
	(969, 'professionnels', 0, 'corps', 'Corps', 0, '{}', '{}'),
	(970, 'professionnels', 1, 'generale', 'General', 0, '{}', '{}'),
	(971, 'professionnels', 2, 'boss', 'Patron', 0, '{}', '{}'),
	(972, 'reiffen', 0, 'soldats', 'Soldats', 55, '{}', '{}'),
	(973, 'reiffen', 1, 'colonel', 'Colonel', 60, '{}', '{}'),
	(974, 'reiffen', 2, 'bras_droit', 'Bras droit', 65, '{}', '{}'),
	(975, 'reiffen', 3, 'boss', 'Parrain', 95, '{}', '{}'),
	(976, 'jashari', 0, 'nouveaux', 'Nouveaux', 55, '{}', '{}'),
	(977, 'jashari', 1, 'homme_de_mains', 'Homme de main', 60, '{}', '{}'),
	(978, 'jashari', 2, 'gestionnaire', 'Gestionnaire', 65, '{}', '{}'),
	(979, 'jashari', 3, 'caporal', 'Caporal', 65, '{}', '{}'),
	(980, 'jashari', 4, 'bras_droit', 'Bras droit', 65, '{}', '{}'),
	(981, 'jashari', 5, 'boss', 'Parrain', 95, '{}', '{}'),
	(982, 'aod', 0, 'prospect', 'Prospect', 0, '{}', '{}'),
	(983, 'aod', 1, 'tailgunner', 'Tail Gunner', 0, '{}', '{}'),
	(984, 'aod', 2, 'safety', 'Safety', 0, '{}', '{}'),
	(985, 'aod', 3, 'board_arrow', 'Board Arrow', 0, '{}', '{}'),
	(986, 'aod', 4, 'ass_kicker', 'Ass Kicker', 0, '{}', '{}'),
	(987, 'aod', 5, 'enforcer', 'Enforcer', 0, '{}', '{}'),
	(988, 'aod', 6, 'road_captain', 'Road Captain', 0, '{}', '{}'),
	(989, 'aod', 7, 'sgt', 'Sgt at arms', 0, '{}', '{}'),
	(990, 'aod', 8, 'treasurer', 'Treasurer', 0, '{}', '{}'),
	(991, 'aod', 9, 'secretary', 'Secretary', 0, '{}', '{}'),
	(992, 'aod', 10, 'vice_president', 'Vice President', 0, '{}', '{}'),
	(993, 'aod', 11, 'boss', 'Président', 0, '{}', '{}'),
	(994, 'loco', 0, 'hustlers', 'Hustler\'s', 0, '{}', '{}'),
	(995, 'loco', 1, 'soldier', 'Soldier', 0, '{}', '{}'),
	(996, 'loco', 2, 'caporal', 'Caporal', 0, '{}', '{}'),
	(997, 'loco', 3, 'vaudou', 'Vaudou', 0, '{}', '{}'),
	(998, 'loco', 4, 'sous_chief', 'Sous chief', 0, '{}', '{}'),
	(999, 'loco', 5, 'boss', 'Chief', 0, '{}', '{}'),
	(1006, 'duggan', 0, 'rookie', 'Rookie', 55, '{}', '{}'),
	(1007, 'duggan', 1, 'associes', 'Associé', 60, '{}', '{}'),
	(1008, 'duggan', 2, 'membre', 'Membre', 65, '{}', '{}'),
	(1009, 'duggan', 3, 'secretaire', 'Secrétaire', 65, '{}', '{}'),
	(1010, 'duggan', 4, 'comptable', 'Comptable', 65, '{}', '{}'),
	(1011, 'duggan', 5, 'leader', 'Leader', 65, '{}', '{}'),
	(1012, 'duggan', 6, 'conseiller', 'Conseiller', 65, '{}', '{}'),
	(1013, 'duggan', 7, 'brasdroit', 'Bras Droit', 65, '{}', '{}'),
	(1014, 'duggan', 8, 'boss', 'Chief', 95, '{}', '{}'),
	(1015, 'blackv', 0, 'recrue', 'Recrue', 55, '{}', '{}'),
	(1016, 'blackv', 1, 'soldat', 'Soldat', 55, '{}', '{}'),
	(1017, 'blackv', 2, 'sergent', 'Sergent', 60, '{}', '{}'),
	(1018, 'blackv', 3, 'caporal', 'Caporal', 65, '{}', '{}'),
	(1019, 'blackv', 4, 'colonel', 'Colonel', 65, '{}', '{}'),
	(1020, 'blackv', 5, 'advisor', 'Advisor', 65, '{}', '{}'),
	(1021, 'blackv', 6, 'boss', 'Lead', 95, '{}', '{}'),
	(1022, 'sula', 0, 'iniciado', 'Iniciado', 55, '{}', '{}'),
	(1023, 'sula', 1, 'armado', 'Armado', 60, '{}', '{}'),
	(1024, 'sula', 2, 'conseillero', 'Conseillero', 65, '{}', '{}'),
	(1025, 'sula', 3, 'tesorero', 'Tesorero', 65, '{}', '{}'),
	(1026, 'sula', 4, 'lider', 'Lider', 65, '{}', '{}'),
	(1027, 'sula', 5, 'teniente', 'Teniente', 95, '{}', '{}'),
	(1028, 'sula', 6, 'segundo', 'Segundo', 95, '{}', '{}'),
	(1029, 'sula', 7, 'boss', 'Jefe', 95, '{}', '{}'),
	(1030, 'michoacana', 0, 'pequeno', 'Pequeno', 55, '{}', '{}'),
	(1031, 'michoacana', 1, 'soldado', 'Soldado', 60, '{}', '{}'),
	(1032, 'michoacana', 2, 'sicario', 'Sicario', 65, '{}', '{}'),
	(1033, 'michoacana', 3, 'teniente', 'Teniente', 65, '{}', '{}'),
	(1034, 'michoacana', 4, 'commandante', 'Commandante', 65, '{}', '{}'),
	(1035, 'michoacana', 5, 'segundo', 'Segundo', 95, '{}', '{}'),
	(1036, 'michoacana', 6, 'boss', 'Jefe', 95, '{}', '{}'),
	(1037, 'bmf', 0, 'soldat', 'Soldat', 55, '{}', '{}'),
	(1038, 'bmf', 1, 'caporal', 'Caporal', 60, '{}', '{}'),
	(1039, 'bmf', 2, 'colonel', 'Colonel', 65, '{}', '{}'),
	(1040, 'bmf', 3, 'brasdroit', 'Bras droit', 65, '{}', '{}'),
	(1041, 'bmf', 4, 'boss', 'Boss', 95, '{}', '{}'),
	(1042, 'forelli', 0, 'hommedmain', 'Homme de main', 55, '{}', '{}'),
	(1043, 'forelli', 1, 'soldado', 'Soldado', 60, '{}', '{}'),
	(1044, 'forelli', 2, 'capo', 'Capo', 65, '{}', '{}'),
	(1045, 'forelli', 3, 'comandante', 'Comandante', 65, '{}', '{}'),
	(1046, 'forelli', 4, 'segundo', 'Segundo', 95, '{}', '{}'),
	(1047, 'forelli', 5, 'boss', 'Don', 95, '{}', '{}'),
	(1048, 'mendez', 0, 'nuevo', 'Nuevo', 55, '{}', '{}'),
	(1049, 'mendez', 1, 'soldato', 'Soldato', 60, '{}', '{}'),
	(1050, 'mendez', 2, 'teniente', 'Teniente', 65, '{}', '{}'),
	(1051, 'mendez', 3, 'commandante', 'Commandante', 65, '{}', '{}'),
	(1052, 'mendez', 4, 'segundo', 'Segundo', 95, '{}', '{}'),
	(1053, 'mendez', 5, 'boss', 'Jefe', 95, '{}', '{}'),
	(1054, 'fag', 0, 'fag', 'FAG', 55, '{}', '{}'),
	(1055, 'fag', 1, 'boss', 'Jefe del Jefes', 60, '{}', '{}'),
	(1056, 'fuerza', 0, 'dragoneante', 'Dragoneante', 55, '{}', '{}'),
	(1057, 'fuerza', 1, 'cabo', 'Cabo', 60, '{}', '{}'),
	(1058, 'fuerza', 2, 'sargente', 'Sargente', 65, '{}', '{}'),
	(1059, 'fuerza', 3, 'teniente', 'Teniente', 65, '{}', '{}'),
	(1060, 'fuerza', 4, 'consejero', 'Consejero', 65, '{}', '{}'),
	(1061, 'fuerza', 5, 'boss', 'Jefe', 95, '{}', '{}'),
	(1062, 'castillo', 0, 'esperanza', 'Esperanza', 55, '{}', '{}'),
	(1063, 'castillo', 1, 'soldado', 'Soldado', 60, '{}', '{}'),
	(1064, 'castillo', 2, 'guerillero', 'Guerillero', 65, '{}', '{}'),
	(1065, 'castillo', 3, 'teniente', 'Teniente', 65, '{}', '{}'),
	(1066, 'castillo', 4, 'generalissimo', 'Generalissimo', 65, '{}', '{}'),
	(1067, 'castillo', 7, 'boss', 'El Commandante', 95, '{}', '{}');
/*!40000 ALTER TABLE `job_grades` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. lab_list
CREATE TABLE IF NOT EXISTS `lab_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(150) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `pos` longtext DEFAULT NULL,
  `owner` varchar(125) DEFAULT NULL,
  `ownerName` varchar(255) DEFAULT NULL,
  `time` int(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=92 DEFAULT CHARSET=utf8mb4;

-- Listage des données de la table california_dev.lab_list : ~9 rows (environ)
/*!40000 ALTER TABLE `lab_list` DISABLE KEYS */;
INSERT INTO `lab_list` (`id`, `type`, `name`, `price`, `pos`, `owner`, `ownerName`, `time`) VALUES
	(61, 'lab_weed', 'Laboratoire de Weed', 35000, '{"x":-1104.1396484375,"y":-2248.319580078125,"z":13.19552612304687}', 'families', 'Families', 1633116606),
	(68, 'lab_weed', 'Laboratoire de Weed', 35000, '{"x":-1487.020263671875,"y":-909.8809814453125,"z":10.02359104156494}', 'vagos', 'Vagos', 1634720621),
	(73, 'lab_weed', 'Laboratoire de Weed', 35000, '{"y":-2700.638671875,"z":7.17169046401977,"x":681.4620971679688}', 'ballas', 'Ballas', 1636066785),
	(76, 'lab_meth', 'Laboratoire de Meth', 35000, '{"y":-1152.768798828125,"z":26.06329345703125,"x":915.0977783203125}', 'mafiaarmenienne', 'Mafia arménienne', 1636251858),
	(77, 'lab_coke', 'Laboratoire de Coke', 35000, '{"y":3651.865478515625,"z":51.73753356933594,"x":-202.75828552246095}', 'duggan', 'Duggan Crime Family', 1636311677),
	(85, 'lab_weed', 'Laboratoire de Weed', 35000, '{"y":-627.7540283203125,"x":-458.2253723144531,"z":26.33480262756347}', 'marabunta', 'Marabunta', 1638120817),
	(88, 'lab_meth', 'Laboratoire de Meth', 35000, '{"y":137.5659637451172,"x":583.7686157226563,"z":99.4747543334961}', 'bmf', 'Black Mafia Family', 1638127295),
	(90, 'lab_coke', 'Laboratoire de Coke', 35000, '{"y":6228.52294921875,"z":31.48822402954101,"x":-333.8487854003906}', 'castillo', 'Cartel Castillo', 1639000574),
	(91, 'lab_coke', 'Laboratoire de Coke', 35000, '{"z":195.36134338378907,"x":-38.63895797729492,"y":1908.240478515625}', NULL, NULL, 1639771333);
/*!40000 ALTER TABLE `lab_list` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. licenses
CREATE TABLE IF NOT EXISTS `licenses` (
  `type` varchar(60) COLLATE utf8mb4_bin NOT NULL,
  `label` varchar(60) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Listage des données de la table california_dev.licenses : ~5 rows (environ)
/*!40000 ALTER TABLE `licenses` DISABLE KEYS */;
INSERT INTO `licenses` (`type`, `label`) VALUES
	('dmv', 'Code de la route'),
	('drive', 'Permis de conduire'),
	('drive_bike', 'Permis moto'),
	('drive_truck', 'Permis camion'),
	('weapon', 'Permis de port d\'arme');
/*!40000 ALTER TABLE `licenses` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. mdt_reports
CREATE TABLE IF NOT EXISTS `mdt_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `incident` longtext DEFAULT NULL,
  `charges` longtext DEFAULT NULL,
  `author` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `date` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Listage des données de la table california_dev.mdt_reports : ~0 rows (environ)
/*!40000 ALTER TABLE `mdt_reports` DISABLE KEYS */;
/*!40000 ALTER TABLE `mdt_reports` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. mdt_warrants
CREATE TABLE IF NOT EXISTS `mdt_warrants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `identifier` varchar(50) DEFAULT NULL,
  `report_id` int(11) DEFAULT NULL,
  `report_title` varchar(255) DEFAULT NULL,
  `charges` longtext DEFAULT NULL,
  `date` varchar(255) DEFAULT NULL,
  `expire` varchar(255) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `author` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Listage des données de la table california_dev.mdt_warrants : ~0 rows (environ)
/*!40000 ALTER TABLE `mdt_warrants` DISABLE KEYS */;
/*!40000 ALTER TABLE `mdt_warrants` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. motodealer_vehicles
CREATE TABLE IF NOT EXISTS `motodealer_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL,
  `price` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4;

-- Listage des données de la table california_dev.motodealer_vehicles : 0 rows
/*!40000 ALTER TABLE `motodealer_vehicles` DISABLE KEYS */;
/*!40000 ALTER TABLE `motodealer_vehicles` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. open_car
CREATE TABLE IF NOT EXISTS `open_car` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `plate` varchar(8) COLLATE utf8mb4_bin DEFAULT NULL,
  `NB` int(11) DEFAULT 0,
  `donated` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `index_open_car_owner` (`owner`) USING BTREE,
  KEY `index_open_car_owner_plate` (`owner`,`plate`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Listage des données de la table california_dev.open_car : ~0 rows (environ)
/*!40000 ALTER TABLE `open_car` DISABLE KEYS */;
/*!40000 ALTER TABLE `open_car` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. owned_vehicles
CREATE TABLE IF NOT EXISTS `owned_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` longtext NOT NULL,
  `plate` longtext DEFAULT NULL,
  `model` longtext DEFAULT NULL,
  `props` longtext DEFAULT NULL,
  `parked` int(11) DEFAULT 1,
  `label` longtext DEFAULT NULL,
  `donated` int(11) NOT NULL DEFAULT 0,
  `garage_private` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Listage des données de la table california_dev.owned_vehicles : ~0 rows (environ)
/*!40000 ALTER TABLE `owned_vehicles` DISABLE KEYS */;
/*!40000 ALTER TABLE `owned_vehicles` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. phone_app_chat
CREATE TABLE IF NOT EXISTS `phone_app_chat` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `channel` varchar(20) CHARACTER SET utf8 NOT NULL,
  `message` varchar(255) CHARACTER SET utf8 NOT NULL,
  `time` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  KEY `index_phone_app_chat_channel` (`channel`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Listage des données de la table california_dev.phone_app_chat : ~0 rows (environ)
/*!40000 ALTER TABLE `phone_app_chat` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_app_chat` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. phone_calls
CREATE TABLE IF NOT EXISTS `phone_calls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(10) COLLATE utf8mb4_bin NOT NULL COMMENT 'Num tel proprio',
  `num` varchar(10) COLLATE utf8mb4_bin NOT NULL COMMENT 'Num reférence du contact',
  `incoming` int(11) NOT NULL COMMENT 'Défini si on est à l''origine de l''appels',
  `time` timestamp NOT NULL DEFAULT current_timestamp(),
  `accepts` int(11) NOT NULL COMMENT 'Appels accepter ou pas',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `index_phone_calls_owner` (`owner`) USING BTREE,
  KEY `index_phone_calls_owner_num` (`owner`,`num`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Listage des données de la table california_dev.phone_calls : ~0 rows (environ)
/*!40000 ALTER TABLE `phone_calls` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_calls` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. phone_messages
CREATE TABLE IF NOT EXISTS `phone_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transmitter` varchar(10) COLLATE utf8mb4_bin NOT NULL,
  `receiver` varchar(10) COLLATE utf8mb4_bin NOT NULL,
  `message` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '0',
  `time` timestamp NOT NULL DEFAULT current_timestamp(),
  `isRead` int(11) NOT NULL DEFAULT 0,
  `owner` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `index_phone_messages_receiver` (`receiver`) USING BTREE,
  KEY `index_phone_messages_receiver_transmitter` (`receiver`,`transmitter`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Listage des données de la table california_dev.phone_messages : 0 rows
/*!40000 ALTER TABLE `phone_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_messages` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. phone_users_contacts
CREATE TABLE IF NOT EXISTS `phone_users_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `number` varchar(10) COLLATE utf8mb4_bin DEFAULT NULL,
  `display` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `index_phone_users_contacts_identifier` (`identifier`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Listage des données de la table california_dev.phone_users_contacts : 0 rows
/*!40000 ALTER TABLE `phone_users_contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_users_contacts` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. playerstattoos
CREATE TABLE IF NOT EXISTS `playerstattoos` (
  `identifier` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `tattoos` longtext COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`identifier`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Listage des données de la table california_dev.playerstattoos : ~0 rows (environ)
/*!40000 ALTER TABLE `playerstattoos` DISABLE KEYS */;
/*!40000 ALTER TABLE `playerstattoos` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. players_ban
CREATE TABLE IF NOT EXISTS `players_ban` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `License` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `Discord` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `Xbox` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `Live` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `Tokens` varchar(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '[]',
  `Reason` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `isBanned` int(11) NOT NULL DEFAULT 0,
  `Expire` int(11) NOT NULL DEFAULT 0,
  `timeat` int(55) DEFAULT 0,
  `permanent` int(1) DEFAULT 0,
  `moderatorName` varchar(55) DEFAULT 'Anticheat',
  KEY `ID` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Listage des données de la table california_dev.players_ban : ~0 rows (environ)
/*!40000 ALTER TABLE `players_ban` DISABLE KEYS */;
/*!40000 ALTER TABLE `players_ban` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. players_banhistory
CREATE TABLE IF NOT EXISTS `players_banhistory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `moderator` varchar(50) DEFAULT 'Inconnu',
  `date` varchar(255) DEFAULT NULL,
  `unbandate` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Listage des données de la table california_dev.players_banhistory : ~0 rows (environ)
/*!40000 ALTER TABLE `players_banhistory` DISABLE KEYS */;
/*!40000 ALTER TABLE `players_banhistory` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. players_clothesitem
CREATE TABLE IF NOT EXISTS `players_clothesitem` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(60) NOT NULL,
  `identifier` text DEFAULT NULL,
  `nom` longtext DEFAULT NULL,
  `clothe` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Listage des données de la table california_dev.players_clothesitem : ~0 rows (environ)
/*!40000 ALTER TABLE `players_clothesitem` DISABLE KEYS */;
/*!40000 ALTER TABLE `players_clothesitem` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. players_warns
CREATE TABLE IF NOT EXISTS `players_warns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `moderator` varchar(50) NOT NULL DEFAULT '0',
  `date` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Listage des données de la table california_dev.players_warns : ~0 rows (environ)
/*!40000 ALTER TABLE `players_warns` DISABLE KEYS */;
/*!40000 ALTER TABLE `players_warns` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. property
CREATE TABLE IF NOT EXISTS `property` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(80) NOT NULL,
  `ownerInfo` varchar(255) NOT NULL DEFAULT 'none',
  `infos` text NOT NULL,
  `inventory` text NOT NULL,
  `keys` text NOT NULL,
  `createdAt` text NOT NULL,
  `createdBy` varchar(80) NOT NULL,
  `street` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Listage des données de la table california_dev.property : ~0 rows (environ)
/*!40000 ALTER TABLE `property` DISABLE KEYS */;
/*!40000 ALTER TABLE `property` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. property_inventory
CREATE TABLE IF NOT EXISTS `property_inventory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `propertyId` int(11) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `count` int(255) DEFAULT NULL,
  `ammo` int(255) DEFAULT NULL,
  `type` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Listage des données de la table california_dev.property_inventory : ~0 rows (environ)
/*!40000 ALTER TABLE `property_inventory` DISABLE KEYS */;
/*!40000 ALTER TABLE `property_inventory` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. tebex_accounts
CREATE TABLE IF NOT EXISTS `tebex_accounts` (
  `steam` varchar(50) NOT NULL DEFAULT '0',
  `fivem` varchar(50) NOT NULL DEFAULT '0',
  `vip` tinyint(4) NOT NULL DEFAULT 0,
  `expiration` int(255) NOT NULL DEFAULT 0,
  PRIMARY KEY (`steam`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Listage des données de la table california_dev.tebex_accounts : ~0 rows (environ)
/*!40000 ALTER TABLE `tebex_accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `tebex_accounts` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. tebex_boutique
CREATE TABLE IF NOT EXISTS `tebex_boutique` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` int(11) NOT NULL,
  `name` text NOT NULL,
  `descriptions` text NOT NULL,
  `price` int(11) NOT NULL,
  `is_enabled` tinyint(1) NOT NULL DEFAULT 1,
  `action` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4;

-- Listage des données de la table california_dev.tebex_boutique : ~42 rows (environ)
/*!40000 ALTER TABLE `tebex_boutique` DISABLE KEYS */;
INSERT INTO `tebex_boutique` (`id`, `category`, `name`, `descriptions`, `price`, `is_enabled`, `action`, `created_at`, `updated_at`) VALUES
	(3, 3, 'Caisse ~y~Gold', 'Contient : ', 300, 1, ' {"case":[{"type":"case_1","name":"global_1"}]}\r\n\r\n', '2021-04-21 11:38:05', '2021-04-21 11:38:05'),
	(4, 3, 'Caisse ~b~Diamond', '~b~DIAMOND', 800, 1, ' {"case":[{"type":"case_2","name":"global_2"}]}\r\n', '2021-04-21 11:38:05', '2021-04-21 11:38:05'),
	(5, 2, 'BMW M760i', '17m760i', 2000, 1, ' {"vehicles":[{"type":"17m760i","name":"17m760i"}]}\n\n', '2021-04-21 11:38:05', '2021-04-21 11:38:05'),
	(6, 2, 'BMW X5M 2020', '20x5m', 2800, 1, ' {"vehicles":[{"type":"20x5m","name":"20x5m"}]}\n', '2021-04-21 11:38:05', '2021-04-21 11:38:05'),
	(7, 2, 'BMW M8', 'bmwm8wb', 3000, 1, ' {"vehicles":[{"type":"bmwm8wb","name":"bmwm8wb"}]}\r\n', '2021-04-21 11:38:05', '2021-04-21 11:38:05'),
	(8, 2, 'BMW M5', 'BMWM5CS', 2200, 1, ' {"vehicles":[{"type":"BMWM5CS","name":"BMWM5CS"}]}\r\n', '2021-04-21 11:38:05', '2021-04-21 11:38:05'),
	(9, 2, 'Brabus 800 E63', 'b800e63', 1800, 1, ' {"vehicles":[{"type":"b800e63","name":"b800e63"}]}\n', '2021-04-21 11:38:05', '2021-04-21 11:38:05'),
	(10, 2, 'Brabus W140', 'w140', 1500, 1, ' {"vehicles":[{"type":"w140","name":"w140"}]}\r\n', '2021-04-21 11:38:05', '2021-04-21 11:38:05'),
	(11, 2, 'Brabus 700', 'bg700w', 2000, 1, ' {"vehicles":[{"type":"bg700w","name":"bg700w"}]}\n', '2021-04-21 11:38:05', '2021-04-21 11:38:05'),
	(12, 2, 'Brabus 500', 'brabus500', 2800, 1, ' {"vehicles":[{"type":"brabus500","name":"brabus500"}]}\r\n', '2021-04-21 11:38:05', '2021-04-21 11:38:05'),
	(13, 2, 'Mercedes G650 AMG', 'g650', 2900, 1, ' {"vehicles":[{"type":"g650","name":"g650"}]}\r\n', '2021-04-21 11:38:05', '2021-04-21 11:38:05'),
	(14, 2, 'Mercedes GLE 53 AMG', 'gle53', 2200, 1, ' {"vehicles":[{"type":"gle53","name":"gle53"}]}\r\n', '2021-04-21 11:38:05', '2021-04-21 11:38:05'),
	(15, 2, 'Mercedes GLS 63 AMG', 'gls63', 2000, 1, ' {"vehicles":[{"type":"gls63","name":"gls63"}]}\r\n', '2021-04-21 11:38:05', '2021-04-21 11:38:05'),
	(16, 2, 'Mercedes AMG GT63S', 'rmodgt63', 1700, 1, ' {"vehicles":[{"type":"rmodgt63","name":"rmodgt63"}]}\r\n', '2021-04-21 11:38:05', '2021-04-21 11:38:05'),
	(17, 2, 'Mercedes CLS', 'clssb', 1500, 1, ' {"vehicles":[{"type":"clssb","name":"clssb"}]}\r\n', '2021-04-21 11:38:05', '2021-04-21 11:38:05'),
	(19, 2, 'Audi RS6 ABT', 'RS6ABTP', 3000, 1, ' {"vehicles":[{"type":"RS6ABTP","name":"RS6ABTP"}]}\r\n', '2021-04-21 11:38:05', '2021-04-21 11:38:05'),
	(20, 2, 'Lamborgini SVJ', 'svjr', 3500, 1, ' {"vehicles":[{"type":"svjr","name":"svjr"}]}\r\n', '2021-04-21 11:38:05', '2021-04-21 11:38:05'),
	(21, 2, 'Bugatti Veyron', 'bugwbprzemo', 3600, 1, ' {"vehicles":[{"type":"bugwbprzemo","name":"bugwbprzemo"}]}\n', '2021-04-21 11:38:05', '2021-04-21 11:38:05'),
	(22, 2, 'Yamaha T-MAX', 'tmax', 1200, 1, ' {"vehicles":[{"type":"tmax","name":"tmax"}]}\r\n', '2021-04-21 11:38:05', '2021-04-21 11:38:05'),
	(23, 2, 'BRABUS 700 2021', '4444', 3500, 1, '{"vehicles":[{"type":"4444","name":"4444"}]}', '2021-05-23 21:28:08', '2021-05-23 21:28:08'),
	(24, 2, 'Mercedes A45 2021', 'a45', 2500, 1, ' {"vehicles":[{"type":"a45","name":"a45"}]}\r\n', '2021-05-23 21:32:13', '2021-05-23 21:32:13'),
	(25, 2, 'Alfa Romeo Giulietta\r\n', 'giuliagtam', 2100, 1, ' {"vehicles":[{"type":"giuliagtam","name":"giuliagtam"}]}\r\n', '2021-05-23 21:35:07', '2021-05-23 21:35:07'),
	(26, 2, 'GLS 63 ARMORED', 'gls63_de_dmz', 3700, 1, ' {"vehicles":[{"type":"gls63_de_dmz","name":"gls63_de_dmz"}]}\n', '2021-05-23 21:44:34', '2021-05-23 21:44:34'),
	(27, 2, 'Jaguar CLR F', 'jlumma', 2700, 1, ' {"vehicles":[{"type":"jlumma","name":"jlumma"}]}', '2021-05-23 21:48:06', '2021-05-23 21:48:06'),
	(28, 2, 'BMW M3 ARMORED', 'm3f801', 3100, 1, ' {"vehicles":[{"type":"m3f801","name":"m3f801"}]}', '2021-05-23 21:49:28', '2021-05-23 21:49:28'),
	(29, 2, 'Porsche Panamera', 'pmansory', 2800, 1, ' {"vehicles":[{"type":"pmansory","name":"pmansory"}]}', '2021-05-23 21:55:03', '2021-05-23 21:55:03'),
	(30, 2, 'Porsche Mansory', 'pturismo', 3100, 1, ' {"vehicles":[{"type":"pturismo","name":"pturismo"}]}', '2021-05-23 21:56:11', '2021-05-23 21:56:11'),
	(31, 2, 'JEEP SRT', 'rmodjeep', 2600, 1, ' {"vehicles":[{"type":"rmodjeep","name":"rmodjeep"}]}', '2021-05-23 21:56:45', '2021-05-23 21:56:45'),
	(32, 2, 'Porsche Macan', 'ursa', 3000, 1, ' {"vehicles":[{"type":"ursa","name":"ursa"}]}', '2021-05-23 21:57:35', '2021-05-23 21:57:35'),
	(33, 2, 'RS6 Coupé 2021', 'rs6c8', 2500, 1, ' {"vehicles":[{"type":"rs6c8","name":"rs6c8"}]}', '2021-05-23 21:58:19', '2021-05-23 21:58:19'),
	(34, 4, '1 Ticket', '~r~Information~s~ : vous permet de jouer à la roue de la fortune dans le casino', 500, 1, ' {"roue":[{"price":500,"count":"1"}]}\n\n', '2021-05-29 17:25:13', '2021-05-29 17:25:13'),
	(35, 4, '2 Tickets', '~r~Information~s~ : vous permet de jouer à la roue de la fortune dans le casino', 1000, 1, ' {"roue":[{"price":1000,"count":"2"}]}\n\n', '2021-05-29 17:25:13', '2021-05-29 17:25:13'),
	(36, 4, '5 Tickets', '~r~Information~s~ : vous permet de jouer à la roue de la fortune dans le casino', 2000, 1, ' {"roue":[{"price":2000,"count":"5"}]}\n\n', '2021-05-29 17:25:13', '2021-05-29 17:25:13'),
	(37, 3, 'Caisse ~o~Fast and Furious', '~o~FAST AND FURIOUS', 3000, 1, ' {"case":[{"type":"case_3","name":"global_3"}]}\r\n', '2021-04-21 11:38:05', '2021-04-21 11:38:05'),
	(38, 2, 'BMW Lumma X7', '19x7m', 4500, 1, ' {"vehicles":[{"type":"19x7m","name":"19x7m"}]}', '2021-05-23 21:58:19', '2021-05-23 21:58:19'),
	(39, 2, 'Yamaha R1', '20r1', 3000, 1, ' {"vehicles":[{"type":"20r1","name":"20r1"}]}', '2021-05-23 21:58:19', '2021-05-23 21:58:19'),
	(40, 2, 'BMW M3 2021', 'm3g80c', 3000, 1, ' {"vehicles":[{"type":"m3g80c","name":"m3g80c"}]}', '2021-05-23 21:58:19', '2021-05-23 21:58:19'),
	(41, 2, 'Mclaren GT Roadster', 'novgtprzemo', 3600, 1, ' {"vehicles":[{"type":"novgtprzemo","name":"novgtprzemo"}]}', '2021-05-23 21:58:19', '2021-05-23 21:58:19'),
	(42, 2, 'Land Rover Defender', 'defenderoffp', 3600, 1, ' {"vehicles":[{"type":"defenderoffp","name":"defenderoffp"}]}', '2021-05-23 21:58:19', '2021-05-23 21:58:19'),
	(43, 2, 'Jaguar Ftype SVR', 'ftype', 3000, 1, ' {"vehicles":[{"type":"ftype","name":"ftype"}]}', '2021-05-23 21:58:19', '2021-05-23 21:58:19'),
	(44, 2, 'Brabus G800 XLP', '2019G800', 3480, 1, ' {"vehicles":[{"type":"2019G800","name":"2019G800"}]}', '2021-05-23 21:58:19', '2021-05-23 21:58:19'),
	(45, 2, 'Pagani Huayra', 'zondacinque', 4200, 1, ' {"vehicles":[{"type":"zondacinque","name":"zondacinque"}]}', '2021-05-23 21:58:19', '2021-05-23 21:58:19');
/*!40000 ALTER TABLE `tebex_boutique` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. tebex_boutique_category
CREATE TABLE IF NOT EXISTS `tebex_boutique_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text NOT NULL,
  `descriptions` text NOT NULL,
  `is_enabled` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

-- Listage des données de la table california_dev.tebex_boutique_category : ~4 rows (environ)
/*!40000 ALTER TABLE `tebex_boutique_category` DISABLE KEYS */;
INSERT INTO `tebex_boutique_category` (`id`, `name`, `descriptions`, `is_enabled`, `created_at`, `updated_at`) VALUES
	(1, 'VIP', 'Vip', 0, '2020-10-31 21:28:00', '2020-10-31 21:28:00'),
	(2, 'Véhicules', 'Choisis ton véhicule préféré !', 0, '2020-10-31 21:28:00', '2020-10-31 21:28:00'),
	(3, 'Caisses', 'Caisse ~y~GOLD~s~ contient : ~n~2 niveaux de raretés : ~n~ - Commun ~n~ - Épique ~n~Caisse ~b~DIAMOND~s~ contient : ~n~3 niveaux de raretés : ~n~ - Commun ~n~ - Épique ~n~ - Légendaire ~n~', 1, '2020-10-31 21:28:00', '2020-10-31 21:28:00'),
	(4, 'Roue de la fortune', 'Cette catégorie consiste à acheter des tickets pour ~b~la roue de la fortune~s~ au Casino', 0, '2020-10-31 21:28:00', '2020-10-31 21:28:00');
/*!40000 ALTER TABLE `tebex_boutique_category` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. tebex_commands
CREATE TABLE IF NOT EXISTS `tebex_commands` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `fivem` varchar(50) NOT NULL DEFAULT '0',
  `command` varchar(50) NOT NULL DEFAULT '0',
  `argument` varchar(50) NOT NULL DEFAULT '0',
  `transaction` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Listage des données de la table california_dev.tebex_commands : ~0 rows (environ)
/*!40000 ALTER TABLE `tebex_commands` DISABLE KEYS */;
/*!40000 ALTER TABLE `tebex_commands` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. tebex_logs_commands
CREATE TABLE IF NOT EXISTS `tebex_logs_commands` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `fivem` varchar(50) NOT NULL DEFAULT '0',
  `command` varchar(50) NOT NULL DEFAULT '0',
  `argument` varchar(50) NOT NULL DEFAULT '0',
  `transaction` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Listage des données de la table california_dev.tebex_logs_commands : ~0 rows (environ)
/*!40000 ALTER TABLE `tebex_logs_commands` DISABLE KEYS */;
/*!40000 ALTER TABLE `tebex_logs_commands` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. tebex_players_wallet
CREATE TABLE IF NOT EXISTS `tebex_players_wallet` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifiers` text NOT NULL,
  `transaction` text DEFAULT NULL,
  `price` text NOT NULL,
  `currency` text DEFAULT NULL,
  `points` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Listage des données de la table california_dev.tebex_players_wallet : ~0 rows (environ)
/*!40000 ALTER TABLE `tebex_players_wallet` DISABLE KEYS */;
/*!40000 ALTER TABLE `tebex_players_wallet` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. truck_inventory2
CREATE TABLE IF NOT EXISTS `truck_inventory2` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plate` varchar(8) NOT NULL,
  `data` text NOT NULL,
  `owned` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `plate` (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Listage des données de la table california_dev.truck_inventory2 : ~0 rows (environ)
/*!40000 ALTER TABLE `truck_inventory2` DISABLE KEYS */;
/*!40000 ALTER TABLE `truck_inventory2` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. users
CREATE TABLE IF NOT EXISTS `users` (
  `character_id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `permission_group` varchar(50) COLLATE utf8mb4_bin DEFAULT 'user',
  `permission_level` int(11) DEFAULT 0,
  `position` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `skin` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `firstname` varchar(20) COLLATE utf8mb4_bin DEFAULT 'None',
  `lastname` varchar(20) COLLATE utf8mb4_bin DEFAULT 'None',
  `birthday` varchar(10) COLLATE utf8mb4_bin DEFAULT 'None',
  `height` int(3) DEFAULT NULL,
  `accounts` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `inventory` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `loadout` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `job` varchar(50) COLLATE utf8mb4_bin DEFAULT 'unemployed',
  `job_grade` int(11) DEFAULT 0,
  `job2` varchar(50) COLLATE utf8mb4_bin DEFAULT 'unemployed2',
  `job2_grade` int(11) DEFAULT 0,
  `status` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `phone_number` varchar(10) COLLATE utf8mb4_bin DEFAULT NULL,
  `xp` int(11) DEFAULT 1,
  `dead` int(11) DEFAULT 0,
  `pet` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`character_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Listage des données de la table california_dev.users : ~0 rows (environ)
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. user_convictions
CREATE TABLE IF NOT EXISTS `user_convictions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) DEFAULT NULL,
  `offense` varchar(255) DEFAULT NULL,
  `count` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Listage des données de la table california_dev.user_convictions : ~0 rows (environ)
/*!40000 ALTER TABLE `user_convictions` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_convictions` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. user_licenses
CREATE TABLE IF NOT EXISTS `user_licenses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(60) COLLATE utf8mb4_bin NOT NULL,
  `owner` varchar(60) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Listage des données de la table california_dev.user_licenses : ~0 rows (environ)
/*!40000 ALTER TABLE `user_licenses` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_licenses` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. user_mdt
CREATE TABLE IF NOT EXISTS `user_mdt` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `mugshot_url` varchar(255) DEFAULT NULL,
  `bail` bit(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Listage des données de la table california_dev.user_mdt : ~0 rows (environ)
/*!40000 ALTER TABLE `user_mdt` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_mdt` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. vehicles
CREATE TABLE IF NOT EXISTS `vehicles` (
  `model` varchar(60) COLLATE utf8mb4_bin NOT NULL,
  `name` varchar(60) COLLATE utf8mb4_bin NOT NULL,
  `price` int(11) NOT NULL,
  `category` varchar(60) COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`model`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Listage des données de la table california_dev.vehicles : ~402 rows (environ)
/*!40000 ALTER TABLE `vehicles` DISABLE KEYS */;
INSERT INTO `vehicles` (`model`, `name`, `price`, `category`) VALUES
	('adder', 'adder', 95000, 'super'),
	('akuma', 'akuma', 20000, 'mototcycles'),
	('alpha', 'alpha', 30000, 'sports'),
	('asbo', 'Asbo', 8500, 'compact'),
	('asea', 'Asea', 7500, 'sedans'),
	('asterope', 'Asterope', 7500, 'sedans'),
	('autarch', 'autarch', 110000, 'super'),
	('avarus', 'avarus', 17500, 'mototcycles'),
	('bagger', 'bagger', 12500, 'mototcycles'),
	('baller', 'baller', 20000, 'suvs'),
	('baller2', 'baller2', 21000, 'suvs'),
	('baller3', 'baller3', 22000, 'suvs'),
	('baller4', 'baller4', 27000, 'suvs'),
	('banshee', 'banshee', 32000, 'sports'),
	('banshee2', 'banshee2', 40000, 'super'),
	('bati', 'bati', 30500, 'mototcycles'),
	('bati2', 'bati2', 33000, 'mototcycles'),
	('bestiagts', 'bestiagts', 30550, 'sports'),
	('bf400', 'bf400', 30000, 'mototcycles'),
	('bfinjection', 'bfinjection', 9500, 'offroad'),
	('bifta', 'bifta', 10500, 'offroad'),
	('bison', 'bison', 26650, 'vans'),
	('bjxl', 'bjxl', 20000, 'suvs'),
	('blade', 'blade', 12500, 'muscle'),
	('blazer', 'blazer', 12000, 'mototcycles'),
	('blazer3', 'blazer3', 15500, 'mototcycles'),
	('blazer4', 'blazer4', 16500, 'mototcycles'),
	('blista', 'Blista', 8250, 'compact'),
	('blista2', 'blista2', 25000, 'sports'),
	('blista3', 'blista3', 25750, 'sports'),
	('bobcatxl', 'bobcatxl', 25000, 'vans'),
	('bodhi2', 'bodhi2', 12000, 'offroad'),
	('brawler', 'brawler', 18000, 'offroad'),
	('brioso', 'Brioso', 4950, 'compact'),
	('brioso2', 'Brioso2', 5180, 'compact'),
	('btype', 'btype', 54000, 'sportsclassics'),
	('btype2', 'btype2', 53000, 'sportsclassics'),
	('btype3', 'btype3', 55000, 'sportsclassics'),
	('buccaneer', 'buccaneer', 12500, 'muscle'),
	('buccaneer2', 'buccaneer2', 13000, 'muscle'),
	('buffalo', 'buffalo', 20500, 'sports'),
	('buffalo2', 'buffalo2', 27500, 'sports'),
	('buffalo3', 'buffalo3', 25500, 'sports'),
	('bullet', 'bullet', 73000, 'super'),
	('burrito3', 'burrito3', 13620, 'vans'),
	('calico', 'calico', 92000, 'sports'),
	('caracara2', 'caracara2', 35000, 'offroad'),
	('carbonizzare', 'carbonizzare', 38500, 'sports'),
	('carbonrs', 'carbonrs', 23000, 'mototcycles'),
	('casco', 'casco', 45000, 'sportsclassics'),
	('cavalcade', 'cavalcade', 15000, 'suvs'),
	('cavalcade2', 'cavalcade2', 18500, 'suvs'),
	('cheburek', 'cheburek', 30000, 'sportsclassics'),
	('cheetah', 'cheetah', 75000, 'super'),
	('cheetah2', 'cheetah2', 48000, 'sportsclassics'),
	('chimera', 'chimera', 21000, 'mototcycles'),
	('chino', 'chino', 12500, 'muscle'),
	('chino2', 'chino2', 13500, 'muscle'),
	('cliffhanger', 'cliffhanger', 22500, 'mototcycles'),
	('clique', 'clique', 12500, 'muscle'),
	('club', 'Club', 8850, 'compact'),
	('cog55', 'Cog55', 64500, 'sedans'),
	('cogcabrio', 'Cogcabrio', 10750, 'coupes'),
	('cognoscenti', 'Cognoscenti', 48000, 'sedans'),
	('comet2', 'comet2', 44500, 'sports'),
	('comet3', 'comet3', 45000, 'sports'),
	('comet5', 'comet5', 47000, 'sports'),
	('comet6', 'comet6', 65000, 'sports'),
	('contender', 'contender', 34000, 'suvs'),
	('coquette', 'coquette', 38000, 'sports'),
	('coquette2', 'coquette2', 50000, 'sportsclassics'),
	('coquette3', 'coquette3', 13000, 'muscle'),
	('coquette4', 'coquette4', 50000, 'sports'),
	('cyclone', 'cyclone', 120000, 'super'),
	('cypher', 'cypher', 50500, 'sports'),
	('daemon', 'daemon', 16500, 'mototcycles'),
	('daemon2', 'daemon2', 16750, 'mototcycles'),
	('defiler', 'defiler', 24000, 'mototcycles'),
	('deveste', 'deveste', 125000, 'sports'),
	('deviant', 'deviant', 15000, 'muscle'),
	('diablous', 'diablous', 20300, 'mototcycles'),
	('diablous2', 'diablous2', 23000, 'mototcycles'),
	('dilettante', 'Dilettante', 5700, 'compact'),
	('dloader', 'dloader', 10000, 'offroad'),
	('dominator', 'dominator', 13000, 'muscle'),
	('dominator2', 'dominator2', 23000, 'muscle'),
	('dominator3', 'dominator3', 26500, 'muscle'),
	('dominator7', 'dominator7', 55000, 'sports'),
	('dominator8', 'dominator8', 31000, 'muscle'),
	('double', 'double', 27500, 'mototcycles'),
	('drafter', 'drafter', 50100, 'sports'),
	('dubsta', 'dubsta', 22800, 'suvs'),
	('dubsta2', 'dubsta2', 22000, 'suvs'),
	('dubsta3', 'dubsta3', 38000, 'offroad'),
	('dukes', 'dukes', 14500, 'muscle'),
	('dukes3', 'dukes3', 13500, 'muscle'),
	('dune', 'dune', 11500, 'offroad'),
	('dynasty', 'dynasty', 24000, 'sportsclassics'),
	('elegy', 'elegy', 34500, 'sports'),
	('elegy2', 'elegy2', 41000, 'sports'),
	('ellie', 'ellie', 16500, 'muscle'),
	('emerus', 'emerus', 155000, 'super'),
	('emperor', 'Emperor', 10480, 'sedans'),
	('emperor2', 'Emperor2', 9580, 'sedans'),
	('enduro', 'enduro', 20000, 'mototcycles'),
	('entity2', 'entity2', 142000, 'super'),
	('entityxf', 'entityxf', 112000, 'super'),
	('esskey', 'esskey', 24000, 'mototcycles'),
	('euros', 'euros', 46000, 'sports'),
	('everon', 'everon', 43000, 'offroad'),
	('exemplar', 'Exemplar', 24500, 'coupes'),
	('f620', 'F620', 26000, 'coupes'),
	('faction', 'faction', 14000, 'muscle'),
	('faction2', 'faction2', 19500, 'muscle'),
	('faction3', 'faction3', 21500, 'muscle'),
	('fagaloa', 'fagaloa', 24500, 'sportsclassics'),
	('faggio', 'faggio', 5500, 'mototcycles'),
	('faggio2', 'faggio2', 5700, 'mototcycles'),
	('faggio3', 'faggio3', 6000, 'mototcycles'),
	('fcr', 'fcr', 22000, 'mototcycles'),
	('fcr2', 'fcr2', 22500, 'mototcycles'),
	('felon', 'Felon', 15620, 'coupes'),
	('felon2', 'Felon2', 16750, 'coupes'),
	('feltzer2', 'feltzer2', 39500, 'sports'),
	('feltzer3', 'feltzer3', 55000, 'sportsclassics'),
	('flashgt', 'flashgt', 41000, 'sports'),
	('fmj', 'fmj', 120000, 'super'),
	('fq2', 'fq2', 22500, 'suvs'),
	('freecrawler', 'freecrawler', 21000, 'offroad'),
	('fugitive', 'Fugitive', 12450, 'sedans'),
	('furia', 'furia', 115000, 'super'),
	('furoregt', 'furoregt', 38500, 'sports'),
	('fusilade', 'fusilade', 39000, 'sports'),
	('futo', 'futo', 35500, 'sports'),
	('futo2', 'futo2', 32000, 'sports'),
	('gargoyle', 'gargoyle', 22500, 'mototcycles'),
	('gauntlet', 'gauntlet', 14500, 'muscle'),
	('gauntlet2', 'gauntlet2', 15500, 'muscle'),
	('gauntlet3', 'gauntlet3', 16500, 'muscle'),
	('gauntlet4', 'gauntlet4', 31500, 'muscle'),
	('gauntlet5', 'gauntlet5', 27000, 'muscle'),
	('gb200', 'gb200', 35500, 'sports'),
	('gburrito', 'gburrito', 16500, 'vans'),
	('gburrito2', 'gburrito2', 16500, 'vans'),
	('glendale', 'Glendale', 15700, 'sedans'),
	('glendale2', 'Glendale2', 20500, 'sedans'),
	('gp1', 'gp1', 86000, 'super'),
	('granger', 'granger', 24000, 'suvs'),
	('gresley', 'gresley', 20500, 'suvs'),
	('growler', 'growler', 67000, 'sports'),
	('gt500', 'gt500', 45000, 'sportsclassics'),
	('guardian', 'guardian', 39000, 'offroad'),
	('habanero', 'habanero', 13500, 'suvs'),
	('hakuchou', 'hakuchou', 33500, 'mototcycles'),
	('hakuchou2', 'hakuchou2', 34500, 'mototcycles'),
	('hellion', 'hellion', 31000, 'offroad'),
	('hermes', 'hermes', 27500, 'muscle'),
	('hexer', 'hexer', 20500, 'mototcycles'),
	('hotknife', 'hotknife', 17000, 'muscle'),
	('hotring', 'hotring', 35000, 'sports'),
	('huntley', 'huntley', 13500, 'suvs'),
	('hustler', 'hustler', 20000, 'muscle'),
	('imorgon', 'imorgon', 90000, 'sports'),
	('impaler', 'impaler', 15000, 'muscle'),
	('imperator', 'imperator', 18000, 'muscle'),
	('infernus', 'infernus', 72000, 'super'),
	('infernus2', 'infernus2', 62000, 'sportsclassics'),
	('ingot', 'Ingot', 10490, 'sedans'),
	('innovation', 'innovation', 26500, 'mototcycles'),
	('intruder', 'Intruder', 11980, 'sedans'),
	('issi2', 'Issi', 5300, 'compact'),
	('issi3', 'Issi Classique', 5480, 'compact'),
	('issi7', 'issi7', 40200, 'sports'),
	('italigtb', 'italigtb', 100000, 'super'),
	('italigtb2', 'italigtb2', 125000, 'super'),
	('italigto', 'italigto', 52000, 'sports'),
	('italirsx', 'italirsx', 145000, 'super'),
	('jackal', 'Jackal', 21500, 'coupes'),
	('jb700', 'jb700', 56500, 'sportsclassics'),
	('jb7002', 'jb7002', 54800, 'sportsclassics'),
	('jester', 'jester', 42000, 'sports'),
	('jester2', 'jester2', 43000, 'sports'),
	('jester3', 'jester3', 45000, 'sports'),
	('jester4', 'jester4', 70000, 'sports'),
	('jugular', 'jugular', 75000, 'sports'),
	('kalahari', 'kalahari', 12500, 'offroad'),
	('kamacho', 'kamacho', 32800, 'offroad'),
	('kanjo', 'Kanjo', 7350, 'compact'),
	('khamelion', 'khamelion', 41500, 'sports'),
	('komoda', 'komoda', 68000, 'sports'),
	('krieger', 'krieger', 170000, 'super'),
	('kuruma', 'kuruma', 40731, 'sports'),
	('landstalker', 'landstalker', 14500, 'suvs'),
	('landstalker2', 'landstalker2', 16000, 'suvs'),
	('le7b', 'le7b', 300000, 'super'),
	('lectro', 'lectro', 25000, 'mototcycles'),
	('locust', 'locust', 61000, 'sports'),
	('lurcher', 'lurcher', 21000, 'muscle'),
	('lynx', 'lynx', 41750, 'sports'),
	('mamba', 'mamba', 42700, 'sportsclassics'),
	('manana', 'manana', 12500, 'sportsclassics'),
	('manana2', 'manana2', 13500, 'sportsclassics'),
	('manchez', 'manchez', 16500, 'mototcycles'),
	('manchez2', 'manchez2', 17500, 'mototcycles'),
	('massacro', 'massacro', 42500, 'sports'),
	('massacro2', 'massacro2', 43000, 'sports'),
	('mesa', 'mesa', 16500, 'suvs'),
	('mesa3', 'mesa3', 25000, 'offroad'),
	('michelli', 'michelli', 32000, 'sportsclassics'),
	('minivan', 'minivan', 13500, 'vans'),
	('minivan2', 'minivan2', 14500, 'vans'),
	('monroe', 'monroe', 36000, 'sportsclassics'),
	('moonbeam', 'moonbeam', 15800, 'muscle'),
	('moonbeam2', 'moonbeam2', 16250, 'muscle'),
	('nebula', 'nebula', 34000, 'sportsclassics'),
	('nemesis', 'nemesis', 22100, 'mototcycles'),
	('neo', 'neo', 45500, 'sports'),
	('neon', 'neon', 39800, 'sports'),
	('nero', 'nero', 180000, 'super'),
	('nero2', 'nero2', 210000, 'super'),
	('nightblade', 'nightblade', 29500, 'mototcycles'),
	('nightshade', 'nightshade', 24000, 'muscle'),
	('ninef', 'ninef', 40500, 'sports'),
	('ninef2', 'ninef2', 40500, 'sports'),
	('novak', 'novak', 78000, 'suvs'),
	('omnis', 'omnis', 39000, 'sports'),
	('oracle', 'Oracle', 21500, 'coupes'),
	('oracle2', 'Oracle2', 20250, 'coupes'),
	('osiris', 'osiris', 140000, 'super'),
	('panto', 'Panto', 3650, 'compact'),
	('paradise', 'paradise', 15600, 'vans'),
	('paragon', 'paragon', 42800, 'sports'),
	('pariah', 'pariah', 49950, 'sports'),
	('patriot', 'patriot', 17800, 'suvs'),
	('pcj', 'pcj', 21500, 'mototcycles'),
	('penetrator', 'penetrator', 60000, 'super'),
	('penumbra', 'penumbra', 32000, 'sports'),
	('penumbra2', 'penumbra2', 39000, 'sports'),
	('peyote', 'peyote', 16700, 'muscle'),
	('peyote2', 'peyote2', 13500, 'muscle'),
	('peyote3', 'peyote3', 21250, 'muscle'),
	('pfister811', 'pfister811', 72000, 'super'),
	('phoenix', 'phoenix', 15000, 'muscle'),
	('picador', 'picador', 15000, 'muscle'),
	('pigalle', 'pigalle', 31160, 'sportsclassics'),
	('prairie', 'Prairie', 8750, 'compact'),
	('premier', 'Premier', 10480, 'sedans'),
	('previon', 'previon', 47000, 'sports'),
	('primo', 'Primo', 11750, 'sedans'),
	('primo2', 'Primo2', 11750, 'sedans'),
	('prototipo', 'prototipo', 240000, 'super'),
	('radi', 'radi', 11500, 'suvs'),
	('raiden', 'raiden', 38150, 'sports'),
	('rancherxl', 'rancherxl', 16500, 'offroad'),
	('rapidgt', 'rapidgt', 39500, 'sports'),
	('rapidgt2', 'rapidgt2', 39750, 'sports'),
	('rapidgt3', 'rapidgt3', 29100, 'sportsclassics'),
	('raptor', 'raptor', 36850, 'sports'),
	('ratbike', 'ratbike', 17500, 'mototcycles'),
	('ratloader', 'ratloader', 12500, 'muscle'),
	('ratloader2', 'ratloader2', 14500, 'muscle'),
	('reaper', 'reaper', 84000, 'super'),
	('rebel', 'rebel', 17500, 'offroad'),
	('rebel2', 'rebel2', 18000, 'offroad'),
	('rebla', 'rebla', 82000, 'suvs'),
	('regina', 'Regina', 9400, 'sedans'),
	('remus', 'remus', 58750, 'sports'),
	('retinue', 'retinue', 28200, 'sportsclassics'),
	('retinue2', 'retinue2', 29700, 'sportsclassics'),
	('revolter', 'revolter', 43000, 'sports'),
	('rhapsody', 'Rhapsody', 8350, 'compact'),
	('riata', 'riata', 19000, 'offroad'),
	('rocoto', 'rocoto', 13000, 'suvs'),
	('rt3000', 'rt3000', 38500, 'sports'),
	('ruffian', 'ruffian', 18800, 'mototcycles'),
	('ruiner', 'ruiner', 16850, 'muscle'),
	('rumpo3', 'rumpo3', 32500, 'vans'),
	('ruston', 'ruston', 42000, 'sports'),
	('s80', 's80', 289000, 'super'),
	('sabregt', 'sabregt', 18000, 'muscle'),
	('sabregt2', 'sabregt2', 18500, 'muscle'),
	('sadler', 'sadler', 13000, 'suvs'),
	('sanchez', 'sanchez', 21500, 'mototcycles'),
	('sanchez2', 'sanchez2', 21000, 'mototcycles'),
	('sanctus', 'sanctus', 27000, 'mototcycles'),
	('sandking', 'sandking', 23000, 'offroad'),
	('sandking2', 'sandking2', 24000, 'offroad'),
	('savestra', 'savestra', 29050, 'sportsclassics'),
	('sc1', 'sc1', 103000, 'super'),
	('schafter2', 'schafter2', 30600, 'sports'),
	('schafter3', 'schafter3', 31500, 'sports'),
	('schafter4', 'schafter4', 34500, 'sports'),
	('schlagen', 'schlagen', 43000, 'sports'),
	('schwarzer', 'schwarzer', 41000, 'sports'),
	('seminole', 'seminole', 10500, 'suvs'),
	('seminole2', 'seminole2', 11000, 'suvs'),
	('sentinel', 'Sentinel', 10000, 'coupes'),
	('sentinel2', 'Sentinel2', 10950, 'coupes'),
	('sentinel3', 'sentinel3', 25600, 'sports'),
	('serrano', 'serrano', 10000, 'suvs'),
	('seven70', 'seven70', 40500, 'sports'),
	('sheava', 'sheava', 126000, 'super'),
	('slamvan', 'slamvan', 17000, 'muscle'),
	('slamvan2', 'slamvan2', 18250, 'muscle'),
	('slamvan3', 'slamvan3', 21000, 'muscle'),
	('sovereign', 'sovereign', 25600, 'mototcycles'),
	('specter', 'specter', 40500, 'sports'),
	('specter2', 'specter2', 40500, 'sports'),
	('speedo', 'speedo', 16200, 'vans'),
	('speedo4', 'speedo4', 16750, 'vans'),
	('stafford', 'Stafford', 42000, 'sedans'),
	('stalion', 'stalion', 22000, 'muscle'),
	('stalion2', 'stalion2', 21850, 'muscle'),
	('stanier', 'Stanier', 21460, 'sedans'),
	('stinger', 'stinger', 28000, 'sportsclassics'),
	('stingergt', 'stingergt', 33000, 'sportsclassics'),
	('stratum', 'Stratum', 11500, 'sedans'),
	('streiter', 'streiter', 26000, 'suvs'),
	('sugoi', 'sugoi', 32500, 'sports'),
	('sultan', 'sultan', 30500, 'sports'),
	('sultan2', 'sultan2', 31000, 'sports'),
	('sultan3', 'sultan3', 40000, 'sports'),
	('sultanrs', 'sultanrs', 130000, 'super'),
	('superd', 'Superd', 52000, 'sedans'),
	('surano', 'surano', 32000, 'sports'),
	('surfer', 'surfer', 13600, 'vans'),
	('surfer2', 'surfer2', 13250, 'vans'),
	('surge', 'Surge', 9500, 'sedans'),
	('swinger', 'swinger', 41000, 'sportsclassics'),
	('t20', 't20', 160000, 'super'),
	('tailgater', 'Tailgater', 13210, 'sedans'),
	('tailgater2', 'tailgater2', 45000, 'sports'),
	('taipan', 'taipan', 120000, 'super'),
	('tampa', 'tampa', 15500, 'muscle'),
	('tampa2', 'tampa2', 32000, 'sports'),
	('tempesta', 'tempesta', 125000, 'super'),
	('tezeract', 'tezeract', 230000, 'super'),
	('thrax', 'thrax', 230000, 'super'),
	('thrust', 'thrust', 30000, 'mototcycles'),
	('tigon', 'tigon', 115000, 'super'),
	('torero', 'torero', 13650, 'sportsclassics'),
	('tornado', 'tornado', 13700, 'sportsclassics'),
	('tornado2', 'tornado2', 11520, 'sportsclassics'),
	('tornado3', 'tornado3', 11520, 'sportsclassics'),
	('tornado4', 'tornado4', 13750, 'sportsclassics'),
	('tornado5', 'tornado5', 40605, 'sportsclassics'),
	('tornado6', 'tornado6', 15500, 'sportsclassics'),
	('toros', 'toros', 57000, 'suvs'),
	('tractor2', 'tractor2', 12000, 'offroad'),
	('trophytruck', 'trophytruck', 24000, 'offroad'),
	('trophytruck2', 'trophytruck2', 28000, 'offroad'),
	('tropos', 'tropos', 34000, 'sports'),
	('tulip', 'tulip', 22500, 'muscle'),
	('turismo2', 'turismo2', 51000, 'sportsclassics'),
	('turismor', 'turismor', 150000, 'super'),
	('tyrant', 'tyrant', 132000, 'super'),
	('tyrus', 'tyrus', 86000, 'super'),
	('vacca', 'vacca', 75000, 'super'),
	('vader', 'vader', 18500, 'mototcycles'),
	('vagner', 'vagner', 121000, 'super'),
	('vagrant', 'vagrant', 18000, 'offroad'),
	('vamos', 'vamos', 17000, 'muscle'),
	('vectre', 'vectre', 85000, 'sports'),
	('verlierer2', 'verlierer2', 38000, 'sports'),
	('verus', 'verus', 22000, 'mototcycles'),
	('vigero', 'vigero', 16000, 'muscle'),
	('vindicator', 'vindicator', 32000, 'mototcycles'),
	('virgo', 'virgo', 17500, 'muscle'),
	('virgo2', 'virgo2', 18000, 'muscle'),
	('virgo3', 'virgo3', 18500, 'muscle'),
	('viseris', 'viseris', 56000, 'sportsclassics'),
	('visione', 'visione', 133000, 'super'),
	('voltic', 'voltic', 71000, 'super'),
	('voodoo', 'voodoo', 21000, 'muscle'),
	('voodoo2', 'voodoo2', 22500, 'muscle'),
	('vortex', 'vortex', 24500, 'mototcycles'),
	('vstr', 'vstr', 60500, 'sports'),
	('warrener', 'Warrener', 11600, 'sedans'),
	('washington', 'washington', 12850, 'sedans'),
	('weevil', 'Weevil', 6280, 'compact'),
	('windsor', 'Windsor', 80000, 'coupes'),
	('windsor2', 'Windsor2', 85650, 'coupes'),
	('winky', 'winky', 27500, 'offroad'),
	('wolfsbane', 'wolfsbane', 20500, 'mototcycles'),
	('xa21', 'xa21', 143000, 'super'),
	('xls', 'xls', 42000, 'suvs'),
	('yosemite', 'yosemite', 24000, 'muscle'),
	('yosemite2', 'yosemite2', 26000, 'muscle'),
	('yosemite3', 'yosemite3', 38000, 'offroad'),
	('youga', 'youga', 16200, 'vans'),
	('youga2', 'youga2', 16750, 'vans'),
	('youga3', 'youga3', 19500, 'vans'),
	('z190', 'z190', 51000, 'sportsclassics'),
	('zentorno', 'zentorno', 120000, 'super'),
	('zion', 'Zion', 12400, 'coupes'),
	('zion2', 'Zion2', 14900, 'coupes'),
	('zion3', 'zion3', 50800, 'sportsclassics'),
	('zombiea', 'zombiea', 15800, 'mototcycles'),
	('zombieb', 'zombieb', 16700, 'mototcycles'),
	('zorrusso', 'zorrusso', 145000, 'super'),
	('zr350', 'zr350', 60000, 'sports'),
	('ztype', 'ztype', 57000, 'sportsclassics');
/*!40000 ALTER TABLE `vehicles` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. vehicle_categories
CREATE TABLE IF NOT EXISTS `vehicle_categories` (
  `name` varchar(60) COLLATE utf8mb4_bin NOT NULL,
  `label` varchar(60) COLLATE utf8mb4_bin NOT NULL,
  `society` varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT 'carshop',
  PRIMARY KEY (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Listage des données de la table california_dev.vehicle_categories : ~14 rows (environ)
/*!40000 ALTER TABLE `vehicle_categories` DISABLE KEYS */;
INSERT INTO `vehicle_categories` (`name`, `label`, `society`) VALUES
	('avionfdp', 'Avion - Hélico', 'planeshop'),
	('compacts', 'Compacts', 'carshop'),
	('coupes', 'Coupes', 'carshop'),
	('imports', 'Imports', 'carshop'),
	('motorcycles', 'Motos', 'carshop'),
	('muscle', 'Muscle', 'carshop'),
	('offroad', 'Off Road', 'carshop'),
	('sedans', 'Sedans', 'carshop'),
	('sports', 'Sports', 'carshop'),
	('sportsclassics', 'Sports Classics', 'carshop'),
	('super', 'Super', 'carshop'),
	('superboat', 'Bateau', 'boatshop'),
	('suvs', 'SUVs', 'carshop'),
	('vans', 'Vans', 'carshop');
/*!40000 ALTER TABLE `vehicle_categories` ENABLE KEYS */;

-- Listage de la structure de la table california_dev. vehicle_mdt
CREATE TABLE IF NOT EXISTS `vehicle_mdt` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plate` varchar(255) DEFAULT NULL,
  `stolen` bit(1) DEFAULT b'0',
  `notes` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Listage des données de la table california_dev.vehicle_mdt : ~0 rows (environ)
/*!40000 ALTER TABLE `vehicle_mdt` DISABLE KEYS */;
/*!40000 ALTER TABLE `vehicle_mdt` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;

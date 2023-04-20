CREATE DATABASE  IF NOT EXISTS `bloodbankvarshneyabindrap` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `bloodbankvarshneyabindrap`;
-- MySQL dump 10.13  Distrib 8.0.31, for macos12 (x86_64)
--
-- Host: localhost    Database: bloodbankvarshneyabindrap
-- ------------------------------------------------------
-- Server version	8.0.32

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `administrator`
--

DROP TABLE IF EXISTS `administrator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `administrator` (
  `volunteer_id` int NOT NULL AUTO_INCREMENT,
  `user_name` varchar(30) NOT NULL,
  `user_password` varchar(20) NOT NULL,
  PRIMARY KEY (`volunteer_id`),
  UNIQUE KEY `user_name` (`user_name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `administrator`
--

LOCK TABLES `administrator` WRITE;
/*!40000 ALTER TABLE `administrator` DISABLE KEYS */;
INSERT INTO `administrator` VALUES (1,'admin1','root'),(2,'admin2','pass');
/*!40000 ALTER TABLE `administrator` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admission`
--

DROP TABLE IF EXISTS `admission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admission` (
  `type_of_admission` varchar(30) NOT NULL,
  `severity` int NOT NULL,
  PRIMARY KEY (`type_of_admission`,`severity`),
  CONSTRAINT `admission_chk_1` CHECK ((`severity` between 1 and 10))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admission`
--

LOCK TABLES `admission` WRITE;
/*!40000 ALTER TABLE `admission` DISABLE KEYS */;
INSERT INTO `admission` VALUES ('Accident',1),('Accident',2),('Accident',3),('Accident',4),('Accident',5),('Accident',6),('Accident',7),('Accident',8),('Accident',9),('Accident',10),('Anemia',1),('Anemia',2),('Anemia',3),('Anemia',4),('Anemia',5),('Anemia',6),('Anemia',7),('Anemia',8),('Anemia',9),('Anemia',10),('Bleeding disorders',1),('Bleeding disorders',2),('Bleeding disorders',3),('Bleeding disorders',4),('Bleeding disorders',5),('Bleeding disorders',6),('Bleeding disorders',7),('Bleeding disorders',8),('Bleeding disorders',9),('Bleeding disorders',10),('General Checkup',5),('General Checkup',6),('General Checkup',7),('General Checkup',8),('General Checkup',9),('General Checkup',10),('Surgery',1),('Surgery',2),('Surgery',3),('Surgery',4),('Surgery',5),('Surgery',6),('Surgery',7),('Surgery',8),('Surgery',9),('Surgery',10);
/*!40000 ALTER TABLE `admission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `approve_requests_archive`
--

DROP TABLE IF EXISTS `approve_requests_archive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `approve_requests_archive` (
  `approved_request_id` int NOT NULL AUTO_INCREMENT,
  `request_id` int DEFAULT NULL,
  `inventory_id` int DEFAULT NULL,
  `hospital_id` int DEFAULT NULL,
  `bag_id` int DEFAULT NULL,
  `blood_group_requested` varchar(3) DEFAULT NULL,
  `blood_group_received` varchar(3) DEFAULT NULL,
  `datetime_of_dispatch` date DEFAULT NULL,
  `approver_id` int DEFAULT NULL,
  PRIMARY KEY (`approved_request_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `approve_requests_archive`
--

LOCK TABLES `approve_requests_archive` WRITE;
/*!40000 ALTER TABLE `approve_requests_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `approve_requests_archive` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blood_bag`
--

DROP TABLE IF EXISTS `blood_bag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blood_bag` (
  `bag_id` int NOT NULL AUTO_INCREMENT,
  `blood_group` varchar(3) DEFAULT NULL,
  `date_of_issue` date NOT NULL,
  `date_of_use` date NOT NULL,
  `inventory_id` int DEFAULT NULL,
  `donor_id` int DEFAULT NULL,
  `available` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`bag_id`),
  KEY `blood_bag_group_fk` (`blood_group`),
  KEY `inventory_blood_fk` (`inventory_id`),
  KEY `blood_donor_fk` (`donor_id`),
  CONSTRAINT `blood_bag_group_fk` FOREIGN KEY (`blood_group`) REFERENCES `blood_group` (`blood_group_type`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `blood_donor_fk` FOREIGN KEY (`donor_id`) REFERENCES `donor` (`donor_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `inventory_blood_fk` FOREIGN KEY (`inventory_id`) REFERENCES `inventory` (`inventory_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blood_bag`
--

LOCK TABLES `blood_bag` WRITE;
/*!40000 ALTER TABLE `blood_bag` DISABLE KEYS */;
INSERT INTO `blood_bag` VALUES (1,'B+','2023-04-19','2023-04-26',1,1,0),(2,'B+','2023-04-19','2023-04-26',1,2,0),(3,'B+','2023-04-20','2023-04-27',1,1,0),(4,'O+','2023-04-20','2023-04-27',1,3,1),(5,'O+','2023-04-20','2023-04-27',1,3,1),(6,'O+','2023-04-20','2023-04-27',1,3,1),(7,'O+','2023-04-20','2023-04-27',1,3,1);
/*!40000 ALTER TABLE `blood_bag` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `update_inventory_after_bag_added` AFTER INSERT ON `blood_bag` FOR EACH ROW BEGIN
	call refresh_inventory(NEW.inventory_id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `update_inventory_after_blood_bag_updated` AFTER UPDATE ON `blood_bag` FOR EACH ROW BEGIN
	call refresh_inventory(NEW.inventory_id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `blood_group`
--

DROP TABLE IF EXISTS `blood_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blood_group` (
  `blood_group_type` varchar(3) NOT NULL,
  `text_description` text,
  PRIMARY KEY (`blood_group_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blood_group`
--

LOCK TABLES `blood_group` WRITE;
/*!40000 ALTER TABLE `blood_group` DISABLE KEYS */;
INSERT INTO `blood_group` VALUES ('A-','type A negative'),('A+','type A positive'),('AB-','type AB negative'),('AB+','type AB positive'),('B-','type B negative'),('B+','type B positive'),('O-','type O negative'),('O+','type O positive');
/*!40000 ALTER TABLE `blood_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blood_group_receiver`
--

DROP TABLE IF EXISTS `blood_group_receiver`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blood_group_receiver` (
  `blood_group_donor` varchar(3) NOT NULL,
  `blood_group_receiver` varchar(3) NOT NULL,
  PRIMARY KEY (`blood_group_donor`,`blood_group_receiver`),
  KEY `blood_group_receiver_fk` (`blood_group_receiver`),
  CONSTRAINT `blood_group_donor_fk` FOREIGN KEY (`blood_group_donor`) REFERENCES `blood_group` (`blood_group_type`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `blood_group_receiver_fk` FOREIGN KEY (`blood_group_receiver`) REFERENCES `blood_group` (`blood_group_type`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blood_group_receiver`
--

LOCK TABLES `blood_group_receiver` WRITE;
/*!40000 ALTER TABLE `blood_group_receiver` DISABLE KEYS */;
INSERT INTO `blood_group_receiver` VALUES ('A-','A-'),('O-','A-'),('A-','A+'),('A+','A+'),('O-','A+'),('O+','A+'),('A-','AB-'),('AB-','AB-'),('B-','AB-'),('O-','AB-'),('A-','AB+'),('A+','AB+'),('AB-','AB+'),('AB+','AB+'),('B-','AB+'),('B+','AB+'),('O-','AB+'),('O+','AB+'),('B-','B-'),('O-','B-'),('B-','B+'),('B+','B+'),('O-','B+'),('O+','B+'),('O-','O-'),('O-','O+'),('O+','O+');
/*!40000 ALTER TABLE `blood_group_receiver` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `donor`
--

DROP TABLE IF EXISTS `donor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `donor` (
  `donor_id` int NOT NULL AUTO_INCREMENT,
  `first_name` char(30) NOT NULL,
  `last_name` char(30) NOT NULL,
  `street` varchar(30) DEFAULT NULL,
  `state` char(30) DEFAULT NULL,
  `zip_code` char(5) NOT NULL,
  `phone` varchar(10) NOT NULL,
  `gender` char(15) NOT NULL,
  `age` int NOT NULL,
  `medical_remarks` text,
  `blood_group` varchar(3) DEFAULT NULL,
  `date_of_registration` date NOT NULL,
  `registrar_id` int DEFAULT NULL,
  PRIMARY KEY (`donor_id`),
  UNIQUE KEY `phone` (`phone`),
  KEY `donor_bg_fk` (`blood_group`),
  KEY `donor_registered_by_fk` (`registrar_id`),
  CONSTRAINT `donor_bg_fk` FOREIGN KEY (`blood_group`) REFERENCES `blood_group` (`blood_group_type`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `donor_registered_by_fk` FOREIGN KEY (`registrar_id`) REFERENCES `administrator` (`volunteer_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `donor`
--

LOCK TABLES `donor` WRITE;
/*!40000 ALTER TABLE `donor` DISABLE KEYS */;
INSERT INTO `donor` VALUES (1,'test1','user2','12','MA','02120','8573179963','F',24,'test remark 2','B+','2023-04-19',1),(2,'test1','user2','12','MA','02120','98987865','F',24,'test remark 2','B+','2023-04-19',1),(3,'user2','test','address','MA','02120','8575447133','F',24,'test remark','O+','2023-04-20',1);
/*!40000 ALTER TABLE `donor` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `insert_blood_bag_after_adding_donor` AFTER INSERT ON `donor` FOR EACH ROW BEGIN
	declare inventory_id_var int;
    set inventory_id_var = 1;
		insert into blood_bag(blood_group, date_of_issue, date_of_use, inventory_id, donor_id)
								values (NEW.blood_group, 
									curdate(), date_add(curdate(), INTERVAL 7 DAY), inventory_id_var, 
                                    NEW.donor_id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `hospital`
--

DROP TABLE IF EXISTS `hospital`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hospital` (
  `hospital_id` int NOT NULL AUTO_INCREMENT,
  `hospital_name` varchar(30) DEFAULT NULL,
  `street` varchar(30) NOT NULL,
  `state` char(30) NOT NULL,
  `zip_code` char(5) NOT NULL,
  PRIMARY KEY (`hospital_id`),
  UNIQUE KEY `street` (`street`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hospital`
--

LOCK TABLES `hospital` WRITE;
/*!40000 ALTER TABLE `hospital` DISABLE KEYS */;
INSERT INTO `hospital` VALUES (1,'hospital 2','111','MA','02115');
/*!40000 ALTER TABLE `hospital` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hospital_requests_blood`
--

DROP TABLE IF EXISTS `hospital_requests_blood`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hospital_requests_blood` (
  `request_id` int NOT NULL AUTO_INCREMENT,
  `inventory_id` int DEFAULT NULL,
  `hospital_id` int DEFAULT NULL,
  `bag_id` int DEFAULT NULL,
  `blood_group_requested` varchar(3) DEFAULT NULL,
  `blood_group_received` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`request_id`),
  KEY `hospital_inventory_fk` (`inventory_id`),
  KEY `hospital_fk` (`hospital_id`),
  KEY `blood_bag_id_fk` (`bag_id`),
  KEY `blood_group_requested_fk` (`blood_group_requested`),
  KEY `blood_group_received_fk` (`blood_group_received`),
  CONSTRAINT `blood_bag_id_fk` FOREIGN KEY (`bag_id`) REFERENCES `blood_bag` (`bag_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `blood_group_received_fk` FOREIGN KEY (`blood_group_received`) REFERENCES `blood_group` (`blood_group_type`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `blood_group_requested_fk` FOREIGN KEY (`blood_group_requested`) REFERENCES `blood_group` (`blood_group_type`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `hospital_fk` FOREIGN KEY (`hospital_id`) REFERENCES `hospital` (`hospital_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `hospital_inventory_fk` FOREIGN KEY (`inventory_id`) REFERENCES `inventory` (`inventory_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hospital_requests_blood`
--

LOCK TABLES `hospital_requests_blood` WRITE;
/*!40000 ALTER TABLE `hospital_requests_blood` DISABLE KEYS */;
INSERT INTO `hospital_requests_blood` VALUES (3,1,1,3,'B+','B+');
/*!40000 ALTER TABLE `hospital_requests_blood` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory`
--

DROP TABLE IF EXISTS `inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory` (
  `inventory_id` int NOT NULL AUTO_INCREMENT,
  `street` varchar(30) NOT NULL,
  `state` char(30) NOT NULL,
  `zip_code` char(5) NOT NULL,
  `blood_bag_available_quantity` int DEFAULT '0',
  PRIMARY KEY (`inventory_id`),
  UNIQUE KEY `street` (`street`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory`
--

LOCK TABLES `inventory` WRITE;
/*!40000 ALTER TABLE `inventory` DISABLE KEYS */;
INSERT INTO `inventory` VALUES (1,'1','test_inventory','02115',4);
/*!40000 ALTER TABLE `inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patient`
--

DROP TABLE IF EXISTS `patient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient` (
  `patient_id` int NOT NULL AUTO_INCREMENT,
  `first_name` char(30) DEFAULT NULL,
  `last_name` char(30) DEFAULT NULL,
  `blood_group` varchar(3) DEFAULT NULL,
  `remarks` text,
  `hospital_id` int DEFAULT NULL,
  `admission_reason` varchar(30) DEFAULT NULL,
  `severity` int DEFAULT NULL,
  PRIMARY KEY (`patient_id`),
  KEY `blood_group_fk` (`blood_group`),
  KEY `patient_hospital_fk` (`hospital_id`),
  KEY `patient_reason_fk` (`admission_reason`,`severity`),
  CONSTRAINT `blood_group_fk` FOREIGN KEY (`blood_group`) REFERENCES `blood_group` (`blood_group_type`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `patient_hospital_fk` FOREIGN KEY (`hospital_id`) REFERENCES `hospital` (`hospital_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `patient_reason_fk` FOREIGN KEY (`admission_reason`, `severity`) REFERENCES `admission` (`type_of_admission`, `severity`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient`
--

LOCK TABLES `patient` WRITE;
/*!40000 ALTER TABLE `patient` DISABLE KEYS */;
INSERT INTO `patient` VALUES (1,'user','test','B+','test add',1,'anemia',4),(2,'user','test','B+','test add',1,'anemia',4);
/*!40000 ALTER TABLE `patient` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `hospital_request_blood_from_inventory` AFTER INSERT ON `patient` FOR EACH ROW BEGIN
	declare bag_id_chosen int;
	declare severity_var int;
    
    select NEW.severity into severity_var;
    
    if severity_var < 5 then
    
		select bag_id into bag_id_chosen 
		from blood_bag where blood_group = any( 
			select blood_group_donor 
			from blood_group_receiver 
			where blood_group_receiver = (select blood_group from patient where patient_id = NEW.patient_id))
            and available = true
		order by date_of_use limit 1;
		
        if bag_id_chosen is null then        
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Sorry, no blood units currently available';
        else
			insert into hospital_requests_blood(inventory_id, hospital_id, bag_id, blood_group_requested, blood_group_received)
			 values 
			((select inventory_id from blood_bag where bag_id = bag_id_chosen), 
			NEW.hospital_id, bag_id_chosen, NEW.blood_group, 
			(select blood_group from blood_bag where bag_id = bag_id_chosen));    
			
			update blood_bag set available = false where bag_id = bag_id_chosen;
        end if;
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping routines for database 'bloodbankvarshneyabindrap'
--
/*!50003 DROP PROCEDURE IF EXISTS `add_additional_blood_bag` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_additional_blood_bag`(in patient_id_in int)
begin
	declare bag_id_chosen int;
    select bag_id into bag_id_chosen 
		from blood_bag where blood_group = any( 
			select blood_group_donor 
			from blood_group_receiver 
			where blood_group_receiver = (select blood_group from patient where patient_id = patient_id_in))
            and available = true
		order by date_of_use limit 1;
		
        if bag_id_chosen is null then        
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Sorry, no blood units currently available';
        else
			insert into hospital_requests_blood(inventory_id, hospital_id, bag_id, blood_group_requested, blood_group_received)
			 values 
			((select inventory_id from blood_bag where bag_id = bag_id_chosen), 
			(select hospital_id from patient where patient_id = patient_id_in), 
            bag_id_chosen,
            (select blood_group from patient where patient_id = patient_id_in), 
			(select blood_group from blood_bag where bag_id = bag_id_chosen));    
			
			update blood_bag set available = false where bag_id = bag_id_chosen;
        end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `add_admin` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_admin`(IN username varchar(30), 
							IN u_password varchar(30))
BEGIN
	INSERT INTO administrator(user_name, user_password)
	VALUES (username, u_password); 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `add_blood_bag` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_blood_bag`(in phone_num CHAR(10))
begin
	declare inventory_id_var int;
    set inventory_id_var = 1;
	if phone_num not in (select phone from donor where phone = phone_num) then
     SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'User not yet registered, please register first';
	else
     insert into blood_bag(blood_group, date_of_issue, date_of_use, inventory_id, donor_id)
								values ((select blood_group from donor where phone = phone_num), 
									curdate(), date_add(curdate(), INTERVAL 7 DAY), inventory_id_var, 
                                    (select donor_id from donor where phone_num = phone));
	update inventory set blood_bag_available_quantity = (select count(available) 
														  from blood_bag 
                                                          group by inventory_id 
														) 
							where inventory_id = inventory_id_var;
    end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `add_hospital` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_hospital`(in hospital_name_in VARCHAR(30),
							in street_in VARCHAR(30),
							in state_in CHAR(30),
							in zip_code_in CHAR(5))
begin
	insert into hospital(hospital_name, street, state, zip_code)
     values
	(hospital_name_in, street_in, state_in, zip_code_in);
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `add_patient_to_hospital` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_patient_to_hospital`(in fname CHAR(30),
										in lname CHAR(30),
										in blood_group_in VARCHAR(3),
										in remarks_in TEXT(100),
										in hospital_name_in VARCHAR(30),
										in admission_reason_in VARCHAR(30),
                                        in severity_in int)
begin
	
	insert into patient(first_name, last_name, blood_group, remarks, hospital_id,  admission_reason,severity)
     values
	(fname, lname, blood_group_in, remarks_in, (SELECT hospital_id FROM hospital WHERE hospital_name = hospital_name_in), admission_reason_in,severity_in);
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `approve_hospital_request` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `approve_hospital_request`(in request_id_in int,
										 in approver_id_in int)
begin
	declare approve_id int;
    
	insert into approve_requests_archive(request_id, inventory_id, hospital_id, bag_id, blood_group_requested, blood_group_received)
		 (select * from hospital_requests_blood where hospital_requests_blood.request_id = request_id_in);
    
    select approved_request_id into approve_id from approve_requests_archive where request_id = request_id_in;
    
	update approve_requests_archive set approver_id = approver_id_in, datetime_of_dispatch = current_timestamp()
     where approved_request_id = approve_id;
     
    delete from hospital_requests_blood where request_id = request_id_in;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_donor` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_donor`(in first_name_v CHAR(30),
							in last_name_v CHAR(30), 
                            in street_v varchar(30), 
                            in state_v CHAR(30), 
                            in zip_code_v CHAR(5), 
                            in phone_v VARCHAR(10), 
                            in gender_v CHAR(15), 
                            in age_v INT, 
                            in medical_remarks_v TEXT(200), 
                            in blood_group_v VARCHAR(3), 
                            in registrar_id_v INT)
BEGIN 
	DECLARE duplicate_entry_for_key TINYINT DEFAULT FALSE; 
    BEGIN 
		DECLARE EXIT HANDLER FOR 1062
			SET duplicate_entry_for_key = TRUE;
		INSERT INTO donor(first_name, last_name, street, state, zip_code, phone, gender, age, medical_remarks, 
						blood_group, date_of_registration, registrar_id)
		VALUES (first_name_v, last_name_v, street_v, state_v, zip_code_v, phone_v, gender_v, age_v, medical_remarks_v,
					blood_group_v, current_date(), registrar_id_v); 
	END; 
	
    IF duplicate_entry_for_key = TRUE THEN
		SIGNAL SQLSTATE '23000'
			SET MESSAGE_TEXT = "Phone number already exists"; 
	END IF; 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_donor` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_donor`(in phone_num CHAR(10))
begin
	declare find_phone CHAR(10);
	
    select count(phone) into find_phone 
     from donor where phone = phone_num; 
	
    if find_phone = 0 then
     SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No user found, please recheck phone';
	else
		delete from donor where phone = phone_num;
	end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_blood_by_group` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_blood_by_group`()
begin
	select inventory_id, bg.blood_group_type, t.c as available_count 
		from(select inventory_id, blood_group, count(available) as c
			from blood_bag as count_bg
			group by blood_group, available, inventory_id
				having available = 1) as t
		right join blood_group bg
		on bg.blood_group_type = t.blood_group
		group by bg.blood_group_type, inventory_id, t.c
		order by available_count desc;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_current_blood_stock_at_inventory` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_current_blood_stock_at_inventory`()
begin
	select inventory_id, blood_bag_available_quantity from inventory;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_hospitals` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_hospitals`()
begin
	SELECT hospital_id,hospital_name from hospital;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_reasonofadmission` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_reasonofadmission`()
begin
	SELECT type_of_admission,severity from admission;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `refresh_inventory` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `refresh_inventory`(in inventory_id_in int)
begin
	update inventory set blood_bag_available_quantity = (select count(bag_id) 
														  from blood_bag 
                                                          group by inventory_id, available
                                                          having available = true) 
							where inventory_id = inventory_id_in;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `select_blood_group` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `select_blood_group`()
BEGIN
	SELECT blood_group_type
	 FROM blood_group; 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `select_hospital_requests` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `select_hospital_requests`()
begin
	select request_id, inventory_id, hospital_name, bag_id, blood_group_requested, blood_group_received 
     from hospital_requests_blood 
     join hospital ON hospital_requests_blood.hospital_id = hospital.hospital_id;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_donor_details` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_donor_details`(in phone_num CHAR(10),
								in fname char(30),
								in lname char(30),
                                in street_updated varchar(30),
                                in state_updated char(30),
                                in zip_code_updated CHAR(5),
                                in gender_updated CHAR(15),
								in age_updated INT,
								in medical_remarks_updated TEXT(200))
BEGIN
	DECLARE find_phone INT;
    DECLARE donor_match_id INT;
    
    SELECT count(phone) INTO find_phone 
     FROM donor WHERE phone = phone_num; 
	
    IF find_phone = 0 THEN
     SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No user found, please recheck phone';
	ELSE
		select donor_id into donor_match_id from donor where phone = phone_num;
        
		if fname is not null then
			update donor set first_name = fname where donor_id = donor_match_id;
        end if;
        if lname is not null then
			update donor set last_name = lname where donor_id = donor_match_id;
        end if;
		if street_updated is not null then
			update donor set street = street_updated where donor_id = donor_match_id;
        end if;
        if zip_code_updated is not null then
			update donor set zip_code = zip_code_updated where donor_id = donor_match_id;
        end if;
        if gender_updated is not null then
			update donor set gender = gender_updated where donor_id = donor_match_id;
        end if;
        if age_updated is not null then
			update donor set age = age_updated where donor_id = donor_match_id;
        end if;
        if medical_remarks_updated is not null then
			update donor set medical_remarks = medical_remarks_updated where donor_id = donor_match_id;
        end if;
	end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-04-20 10:35:01

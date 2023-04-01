CREATE DATABASE IF NOT EXISTS `project_database` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `project_database`;

CREATE TABLE IF NOT EXISTS `admin` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
  	`username` varchar(50) NOT NULL,
  	`password` varchar(255) NOT NULL,
  	`email` varchar(100) NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

INSERT INTO `admin` (`id`, `username`, `password`, `email`) VALUES (1, 'test', 'test', 'test@test.com');
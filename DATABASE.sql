CREATE DATABASE  IF NOT EXISTS `libman`
USE `libman`;


DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int NOT NULL UNIQUE AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL UNIQUE,
  `password` varchar(255) DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phoneNumber` varchar(255) DEFAULT NULL,
  `role` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `reader`;
CREATE TABLE `reader` (
  `id` int NOT NULL UNIQUE AUTO_INCREMENT,
  `readerCode` varchar(255) NOT NULL UNIQUE,
  PRIMARY KEY (`id`),
  CONSTRAINT `reader_ibfk_1` FOREIGN KEY (`id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `readercard`;
CREATE TABLE `readercard` (
  `id` int NOT NULL UNIQUE AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `birthday` date NOT NULL,
  `cardType` varchar(50) NOT NULL,
  `registerDate` date NOT NULL,
  `expiryDate` date NOT NULL,
  `readerId` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `readerId` (`readerId`),
  CONSTRAINT `readercard_ibfk_1` FOREIGN KEY (`readerId`) REFERENCES `reader` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `librarian`;
CREATE TABLE `librarian` (
  `id` int NOT NULL UNIQUE AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  CONSTRAINT `librarian_ibfk_1` FOREIGN KEY (`id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `document`;
CREATE TABLE `document` (
  `id` int NOT NULL UNIQUE AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `author` varchar(255) DEFAULT NULL,
  `publishedYear` date DEFAULT NULL,
  `price` float DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `borrowslip`;
CREATE TABLE `borrowslip` (
  `id` int NOT NULL UNIQUE AUTO_INCREMENT,
  `borrowDate` date DEFAULT NULL,
  `dueDate` date DEFAULT NULL,
  `librarianUserId` int DEFAULT NULL,
  `readerUserId` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `librarianUserId` (`librarianUserId`),
  KEY `readerUserId` (`readerUserId`),
  CONSTRAINT `borrowslip_ibfk_1` FOREIGN KEY (`librarianUserId`) REFERENCES `librarian` (`id`),
  CONSTRAINT `borrowslip_ibfk_2` FOREIGN KEY (`readerUserId`) REFERENCES `reader` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `borrowslipdetail`;
CREATE TABLE `borrowslipdetail` (
  `id` int NOT NULL UNIQUE AUTO_INCREMENT,
  `borrowSlipId` int DEFAULT NULL,
  `documentId` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `borrowSlipId` (`borrowSlipId`),
  KEY `documentId` (`documentId`),
  CONSTRAINT `borrowslipdetail_ibfk_1` FOREIGN KEY (`borrowSlipId`) REFERENCES `borrowslip` (`id`),
  CONSTRAINT `borrowslipdetail_ibfk_2` FOREIGN KEY (`documentId`) REFERENCES `document` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `fine`;
CREATE TABLE `fine` (
  `id` int NOT NULL UNIQUE AUTO_INCREMENT,
  `type` varchar(255) DEFAULT NULL,
  `amount` float DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `returnslip`;
CREATE TABLE `returnslip` (
  `id` int NOT NULL UNIQUE AUTO_INCREMENT,
  `returnDate` date DEFAULT NULL,
  `librarianUserId` int DEFAULT NULL,
  `readerUserId` int DEFAULT NULL,
  `totalFine` float DEFAULT '0',
  `status` varchar(50) DEFAULT 'Pending',
  PRIMARY KEY (`id`),
  KEY `librarianUserId` (`librarianUserId`),
  KEY `readerUserId` (`readerUserId`),
  CONSTRAINT `returnslip_ibfk_1` FOREIGN KEY (`librarianUserId`) REFERENCES `librarian` (`id`),
  CONSTRAINT `returnslip_ibfk_2` FOREIGN KEY (`readerUserId`) REFERENCES `reader` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `returnslipdetail`;
CREATE TABLE `returnslipdetail` (
  `id` int NOT NULL UNIQUE AUTO_INCREMENT,
  `returnSlipId` int DEFAULT NULL,
  `totalFineDetail` float DEFAULT '0',
  `borrowSlipDetailId` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `returnslipdetail_ibfk_1` (`returnSlipId`),
  KEY `returnslipdetail_ibfk_2` (`borrowSlipDetailId`),
  CONSTRAINT `returnslipdetail_ibfk_1` FOREIGN KEY (`returnSlipId`) REFERENCES `returnslip` (`id`),
  CONSTRAINT `returnslipdetail_ibfk_2` FOREIGN KEY (`borrowSlipDetailId`) REFERENCES `borrowslipdetail` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `finedetail`;
CREATE TABLE `finedetail` (
  `id` int NOT NULL UNIQUE AUTO_INCREMENT,
  `note` varchar(255) DEFAULT NULL,
  `fineId` int DEFAULT NULL,
  `returnSlipDetailId` int DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fineId` (`fineId`),
  KEY `returnSlipDetailId` (`returnSlipDetailId`),
  CONSTRAINT `finedetail_ibfk_1` FOREIGN KEY (`fineId`) REFERENCES `fine` (`id`),
  CONSTRAINT `finedetail_ibfk_2` FOREIGN KEY (`returnSlipDetailId`) REFERENCES `returnslipdetail` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
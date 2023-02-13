
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
DROP TABLE IF EXISTS `ar_internal_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ar_internal_metadata` (
  `key` varchar(255) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comments` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `author_id` bigint(20) NOT NULL,
  `comment` text DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `course_id` bigint(20) NOT NULL,
  `course_valid_end` date NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_comments_on_author_id` (`author_id`),
  KEY `fk_rails_d0f578074a` (`course_id`),
  KEY `fk_rails_224c6870e0` (`course_valid_end`),
  CONSTRAINT `fk_rails_224c6870e0` FOREIGN KEY (`course_valid_end`) REFERENCES `courses` (`valid_end`) ON DELETE CASCADE,
  CONSTRAINT `fk_rails_d0f578074a` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `course_programs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_programs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `semester` int(11) DEFAULT NULL,
  `required` text DEFAULT NULL,
  `course_valid_end` date NOT NULL,
  `program_valid_end` date NOT NULL,
  `course_id` bigint(20) NOT NULL,
  `program_id` bigint(20) NOT NULL,
  `change_list` text DEFAULT NULL,
  `author_id` bigint(20) DEFAULT NULL,
  `transaction_start` timestamp(6) GENERATED ALWAYS AS ROW START,
  `transaction_end` timestamp(6) GENERATED ALWAYS AS ROW END,
  PRIMARY KEY (`id`,`transaction_end`),
  KEY `fk_rails_f83525775e` (`course_valid_end`),
  KEY `fk_rails_aed77cf7f2` (`program_valid_end`),
  KEY `fk_rails_931b445d8c` (`course_id`),
  KEY `fk_rails_6fe0a9b905` (`program_id`),
  KEY `fk_rails_3c473c8eda` (`author_id`),
  PERIOD FOR SYSTEM_TIME (`transaction_start`, `transaction_end`),
  CONSTRAINT `fk_rails_3c473c8eda` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_6fe0a9b905` FOREIGN KEY (`program_id`) REFERENCES `programs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_rails_931b445d8c` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_rails_aed77cf7f2` FOREIGN KEY (`program_valid_end`) REFERENCES `programs` (`valid_end`) ON DELETE CASCADE,
  CONSTRAINT `fk_rails_f83525775e` FOREIGN KEY (`course_valid_end`) REFERENCES `courses` (`valid_end`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci WITH SYSTEM VERSIONING;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `courses` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` text DEFAULT NULL,
  `code` text DEFAULT NULL,
  `mission` text DEFAULT NULL,
  `ects` int(11) DEFAULT NULL,
  `examination` text DEFAULT NULL,
  `objectives` text DEFAULT NULL,
  `contents` text DEFAULT NULL,
  `prerequisites` text DEFAULT NULL,
  `literature` text DEFAULT NULL,
  `methods` text DEFAULT NULL,
  `skills_knowledge_understanding` text DEFAULT NULL,
  `skills_intellectual` text DEFAULT NULL,
  `skills_practical` text DEFAULT NULL,
  `skills_general` text DEFAULT NULL,
  `lectureHrs` decimal(10,1) DEFAULT NULL,
  `labHrs` decimal(10,1) DEFAULT NULL,
  `tutorialHrs` decimal(10,1) DEFAULT NULL,
  `equipment` text DEFAULT NULL,
  `room` text DEFAULT NULL,
  `aasm_state` varchar(255) DEFAULT NULL,
  `responsible_person` varchar(255) DEFAULT NULL,
  `comment` text DEFAULT NULL,
  `valid_start` date NOT NULL,
  `valid_end` date NOT NULL,
  `change_list` text DEFAULT NULL,
  `author_id` bigint(20) DEFAULT NULL,
  `transaction_start` timestamp(6) GENERATED ALWAYS AS ROW START,
  `transaction_end` timestamp(6) GENERATED ALWAYS AS ROW END,
  PERIOD FOR `p` (`valid_start`, `valid_end`),
  PRIMARY KEY (`id`,`valid_end`,`transaction_end`),
  KEY `fk_rails_8419f1d78e` (`author_id`),
  KEY `index_courses_on_valid_end` (`valid_end`),
  PERIOD FOR SYSTEM_TIME (`transaction_start`, `transaction_end`),
  CONSTRAINT `fk_rails_8419f1d78e` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci WITH SYSTEM VERSIONING;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `faculties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `faculties` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `programs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `programs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` text DEFAULT NULL,
  `code` text DEFAULT NULL,
  `mission` text DEFAULT NULL,
  `degree` text DEFAULT NULL,
  `ects` int(11) DEFAULT NULL,
  `valid_start` date NOT NULL,
  `valid_end` date NOT NULL,
  `change_list` text DEFAULT NULL,
  `author_id` bigint(20) DEFAULT NULL,
  `transaction_start` timestamp(6) GENERATED ALWAYS AS ROW START,
  `transaction_end` timestamp(6) GENERATED ALWAYS AS ROW END,
  PERIOD FOR `p` (`valid_start`, `valid_end`),
  PRIMARY KEY (`id`,`valid_end`,`transaction_end`),
  KEY `fk_rails_75ab144467` (`author_id`),
  KEY `index_programs_on_valid_end` (`valid_end`),
  PERIOD FOR SYSTEM_TIME (`transaction_start`, `transaction_end`),
  CONSTRAINT `fk_rails_75ab144467` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci WITH SYSTEM VERSIONING;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) NOT NULL DEFAULT 0,
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) DEFAULT NULL,
  `last_sign_in_ip` varchar(255) DEFAULT NULL,
  `confirmation_token` varchar(255) DEFAULT NULL,
  `confirmed_at` datetime DEFAULT NULL,
  `confirmation_sent_at` datetime DEFAULT NULL,
  `unconfirmed_email` varchar(255) DEFAULT NULL,
  `failed_attempts` int(11) NOT NULL DEFAULT 0,
  `unlock_token` varchar(255) DEFAULT NULL,
  `locked_at` datetime DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `approved` tinyint(1) NOT NULL DEFAULT 0,
  `role` varchar(255) DEFAULT NULL,
  `full_name` varchar(255) DEFAULT NULL,
  `faculty_id` bigint(20) DEFAULT NULL,
  `readable` tinyint(1) DEFAULT NULL,
  `about` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_email` (`email`),
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`),
  UNIQUE KEY `index_users_on_confirmation_token` (`confirmation_token`),
  UNIQUE KEY `index_users_on_unlock_token` (`unlock_token`),
  KEY `index_users_on_approved` (`approved`),
  KEY `index_users_on_faculty_id` (`faculty_id`),
  CONSTRAINT `fk_rails_25393b3b56` FOREIGN KEY (`faculty_id`) REFERENCES `faculties` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

INSERT INTO `schema_migrations` (version) VALUES
('20200422183338'),
('20200422184210'),
('20200422184728'),
('20200425204522'),
('20200426075557'),
('20200601130310'),
('20200601130712'),
('20201116222314'),
('20201121135410'),
('20201206144629'),
('20201206144651'),
('20210317102716'),
('20210610095625'),
('20210610095626'),
('20221117095500'),
('20221117095501'),
('20221117095504'),
('20221117095505'),
('20221117095506'),
('20221124100158'),
('20221124100547'),
('20221126141328'),
('20221209104330'),
('20221213142950'),
('20221217080356'),
('20221217083615'),
('20221221114112');



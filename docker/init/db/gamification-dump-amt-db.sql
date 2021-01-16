-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: impl_db
-- Generation Time: Jan 16, 2021 at 05:15 PM
-- Server version: 8.0.22
-- PHP Version: 7.4.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `amt-db`
--

-- --------------------------------------------------------

--
-- Table structure for table `application_entity`
--

CREATE TABLE `application_entity` (
  `id` bigint NOT NULL,
  `api_key` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `application_entity`
--

INSERT INTO `application_entity` (`id`, `api_key`, `name`) VALUES
(1, '84af416b-cf8f-4e4f-9b4c-37eb9209e4ba', 'S7ack'),
(2, 'fa0440b2-f1d4-4f1b-a08f-65e8cd1c65b3', 'Starbucks'),
(3, 'c6c8f75f-543e-46da-bd02-c564c7005d31', 'Digitec');

-- --------------------------------------------------------

--
-- Table structure for table `badge_entity`
--

CREATE TABLE `badge_entity` (
  `id` bigint NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `application_entity_id` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `badge_entity`
--

INSERT INTO `badge_entity` (`id`, `description`, `name`, `application_entity_id`) VALUES
(1, 'Vous avez posté votre premier commentaire', 'First', 1),
(2, 'Vous avez posé votre première question', 'Besoin d\'aide', 1),
(3, 'Vous avez posé votre 10ème question', 'Novice', 1),
(4, 'Vous avez posé votre 100ème question', 'Amateur', 1),
(5, 'Vous avez donné votre 10ème réponse', 'Expérimenté', 1),
(6, 'Vous avez donné votre 50ème réponse', 'Expert', 1),
(7, 'Vous avez donné votre 100ème réponse', 'Connaisseur', 1),
(8, 'Vous avez donné votre 10ème commentaire', 'Fanboy', 1),
(9, 'Vous avez donné votre 100ème commentaire', 'Communautariste', 1),
(10, 'Vous avez donné votre 500ème réponse', 'Einstein', 1);

-- --------------------------------------------------------

--
-- Table structure for table `badge_reward_entity`
--

CREATE TABLE `badge_reward_entity` (
  `id` bigint NOT NULL,
  `timestamp` datetime(6) DEFAULT NULL,
  `badge_entity_id` bigint DEFAULT NULL,
  `user_entity_id` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `badge_reward_entity`
--

INSERT INTO `badge_reward_entity` (`id`, `timestamp`, `badge_entity_id`, `user_entity_id`) VALUES
(1, '2021-01-16 17:14:06.090086', 1, 1),
(2, '2021-01-16 17:14:21.645486', 2, 1),
(3, '2021-01-16 17:14:22.873986', 3, 1),
(4, '2021-01-16 17:14:24.035258', 4, 1),
(5, '2021-01-16 17:14:27.331648', 5, 1);

-- --------------------------------------------------------

--
-- Table structure for table `event_entity`
--

CREATE TABLE `event_entity` (
  `id` bigint NOT NULL,
  `app_user_id` varchar(255) DEFAULT NULL,
  `event_type` varchar(255) DEFAULT NULL,
  `timestamp` datetime(6) DEFAULT NULL,
  `application_entity_id` bigint DEFAULT NULL,
  `badge_entity_id` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `point_reward_entity`
--

CREATE TABLE `point_reward_entity` (
  `id` bigint NOT NULL,
  `points` int NOT NULL,
  `timestamp` datetime(6) DEFAULT NULL,
  `point_scale_entity_id` bigint DEFAULT NULL,
  `user_entity_id` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `point_reward_entity`
--

INSERT INTO `point_reward_entity` (`id`, `points`, `timestamp`, `point_scale_entity_id`, `user_entity_id`) VALUES
(1, 1, '2021-01-16 17:14:06.064469', 3, 1),
(2, 1, '2021-01-16 17:14:21.621051', 1, 1),
(3, 1, '2021-01-16 17:14:22.858943', 1, 1),
(4, 10, '2021-01-16 17:14:24.014577', 1, 1),
(5, 1, '2021-01-16 17:14:27.316686', 2, 1);

-- --------------------------------------------------------

--
-- Table structure for table `point_scale_entity`
--

CREATE TABLE `point_scale_entity` (
  `id` bigint NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `application_entity_id` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `point_scale_entity`
--

INSERT INTO `point_scale_entity` (`id`, `description`, `name`, `application_entity_id`) VALUES
(1, 'Echelle de points pour les questions', 'Questions', 1),
(2, 'Echelle de points pour les réponses', 'Réponses', 1),
(3, 'Echelle de points pour les commentaires', 'Commentaires', 1);

-- --------------------------------------------------------

--
-- Table structure for table `rule_entity`
--

CREATE TABLE `rule_entity` (
  `id` bigint NOT NULL,
  `amount` int NOT NULL,
  `amount_to_get` int NOT NULL,
  `award_badge` varchar(255) DEFAULT NULL,
  `award_points` varchar(255) DEFAULT NULL,
  `event_type` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `application_entity_id` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `rule_entity`
--

INSERT INTO `rule_entity` (`id`, `amount`, `amount_to_get`, `award_badge`, `award_points`, `event_type`, `name`, `application_entity_id`) VALUES
(1, 1, 10, 'Novice', 'Questions', 'question', '10ème question', 1),
(2, 10, 100, 'Amateur', 'Questions', 'question', '100ème question', 1),
(3, 1, 10, 'Fanboy', 'Commentaires', 'comment', '10ème commentaire', 1),
(4, 10, 100, 'Communautariste', 'Commentaires', 'comment', '100ème commentaire', 1),
(5, 1, 1, 'First', 'Commentaires', 'comment', '1er commentaire', 1),
(6, 1, 1, 'Besoin d\'aide', 'Questions', 'question', '1ère question', 1),
(7, 1, 10, 'Expérimenté', 'Réponses', 'answer', '10ème réponse', 1),
(8, 10, 50, 'Expert', 'Réponses', 'answer', '50ème réponse', 1),
(9, 10, 100, 'Connaisseur', 'Réponses', 'answer', '100ème réponse', 1),
(10, 25, 500, 'Einstein', 'Réponses', 'answer', '500ème réponse', 1);

-- --------------------------------------------------------

--
-- Table structure for table `user_entity`
--

CREATE TABLE `user_entity` (
  `id` bigint NOT NULL,
  `app_user_id` varchar(255) DEFAULT NULL,
  `nb_badges` int NOT NULL,
  `application_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `user_entity`
--

INSERT INTO `user_entity` (`id`, `app_user_id`, `nb_badges`, `application_id`) VALUES
(1, 'c53ed5d3-1efd-409f-a139-8d3bdef43c96', 5, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `application_entity`
--
ALTER TABLE `application_entity`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `badge_entity`
--
ALTER TABLE `badge_entity`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK4bxv5g78uhxtg32o1u0322hs3` (`application_entity_id`);

--
-- Indexes for table `badge_reward_entity`
--
ALTER TABLE `badge_reward_entity`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK19fgra7vmd5c8exmlfbe5ijau` (`badge_entity_id`),
  ADD KEY `FKnu9y7amob1yeqgqprcmib8y6h` (`user_entity_id`);

--
-- Indexes for table `event_entity`
--
ALTER TABLE `event_entity`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FKhhr0yo3gw9rjom16a2nq9eypb` (`application_entity_id`),
  ADD KEY `FKagmilatu4g1nqfbeo8wgg6pm5` (`badge_entity_id`);

--
-- Indexes for table `point_reward_entity`
--
ALTER TABLE `point_reward_entity`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FKdscpu50ix3xnno9w2tcvs7q5o` (`point_scale_entity_id`),
  ADD KEY `FK926i3b3j0prankl74d94a4gem` (`user_entity_id`);

--
-- Indexes for table `point_scale_entity`
--
ALTER TABLE `point_scale_entity`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK686rlx2ie95f1t1o17f5mre99` (`application_entity_id`);

--
-- Indexes for table `rule_entity`
--
ALTER TABLE `rule_entity`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FKnn89qg126y4mq4uoswcrm00e0` (`application_entity_id`);

--
-- Indexes for table `user_entity`
--
ALTER TABLE `user_entity`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK79i1v8q1oo1pxma2e58w6dv87` (`application_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `application_entity`
--
ALTER TABLE `application_entity`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `badge_entity`
--
ALTER TABLE `badge_entity`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `badge_reward_entity`
--
ALTER TABLE `badge_reward_entity`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `event_entity`
--
ALTER TABLE `event_entity`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `point_reward_entity`
--
ALTER TABLE `point_reward_entity`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `point_scale_entity`
--
ALTER TABLE `point_scale_entity`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `rule_entity`
--
ALTER TABLE `rule_entity`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `user_entity`
--
ALTER TABLE `user_entity`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `badge_entity`
--
ALTER TABLE `badge_entity`
  ADD CONSTRAINT `FK4bxv5g78uhxtg32o1u0322hs3` FOREIGN KEY (`application_entity_id`) REFERENCES `application_entity` (`id`);

--
-- Constraints for table `badge_reward_entity`
--
ALTER TABLE `badge_reward_entity`
  ADD CONSTRAINT `FK19fgra7vmd5c8exmlfbe5ijau` FOREIGN KEY (`badge_entity_id`) REFERENCES `badge_entity` (`id`),
  ADD CONSTRAINT `FKnu9y7amob1yeqgqprcmib8y6h` FOREIGN KEY (`user_entity_id`) REFERENCES `user_entity` (`id`);

--
-- Constraints for table `event_entity`
--
ALTER TABLE `event_entity`
  ADD CONSTRAINT `FKagmilatu4g1nqfbeo8wgg6pm5` FOREIGN KEY (`badge_entity_id`) REFERENCES `badge_entity` (`id`),
  ADD CONSTRAINT `FKhhr0yo3gw9rjom16a2nq9eypb` FOREIGN KEY (`application_entity_id`) REFERENCES `application_entity` (`id`);

--
-- Constraints for table `point_reward_entity`
--
ALTER TABLE `point_reward_entity`
  ADD CONSTRAINT `FK926i3b3j0prankl74d94a4gem` FOREIGN KEY (`user_entity_id`) REFERENCES `user_entity` (`id`),
  ADD CONSTRAINT `FKdscpu50ix3xnno9w2tcvs7q5o` FOREIGN KEY (`point_scale_entity_id`) REFERENCES `point_scale_entity` (`id`);

--
-- Constraints for table `point_scale_entity`
--
ALTER TABLE `point_scale_entity`
  ADD CONSTRAINT `FK686rlx2ie95f1t1o17f5mre99` FOREIGN KEY (`application_entity_id`) REFERENCES `application_entity` (`id`);

--
-- Constraints for table `rule_entity`
--
ALTER TABLE `rule_entity`
  ADD CONSTRAINT `FKnn89qg126y4mq4uoswcrm00e0` FOREIGN KEY (`application_entity_id`) REFERENCES `application_entity` (`id`);

--
-- Constraints for table `user_entity`
--
ALTER TABLE `user_entity`
  ADD CONSTRAINT `FK79i1v8q1oo1pxma2e58w6dv87` FOREIGN KEY (`application_id`) REFERENCES `application_entity` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

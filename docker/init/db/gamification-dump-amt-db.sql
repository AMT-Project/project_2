-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: impl_db
-- Generation Time: Jan 08, 2021 at 03:24 PM
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
(1, 'eca8983f-c4c9-4093-a975-0a2178e130ef', 'Stack');

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
(1, 'Lorem ipsum description', 'Champion', 1),
(2, 'Lorem ipsum description 2', 'Génie', 1),
(3, 'Lorem ipsum description 3', 'Boss', 1);

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

-- --------------------------------------------------------

--
-- Table structure for table `event_entity`
--

CREATE TABLE `event_entity` (
  `id` bigint NOT NULL,
  `event_type` varchar(255) DEFAULT NULL,
  `timestamp` datetime(6) DEFAULT NULL,
  `user_id` varchar(255) DEFAULT NULL,
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
(1, 'Echelle de points pour les questions', 'QuestionPS', 1),
(2, 'Echelle de points pour les réponses', 'AnswerPS', 1);

-- --------------------------------------------------------

--
-- Table structure for table `rule_entity`
--

CREATE TABLE `rule_entity` (
  `id` bigint NOT NULL,
  `amount` int NOT NULL,
  `award_badge` varchar(255) DEFAULT NULL,
  `award_points` varchar(255) DEFAULT NULL,
  `event_type` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `application_entity_id` bigint DEFAULT NULL,
  `amount_to_get` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `rule_entity`
--

INSERT INTO `rule_entity` (`id`, `amount`, `award_badge`, `award_points`, `event_type`, `name`, `application_entity_id`, `amount_to_get`) VALUES
(1, 10, 'Champion', 'questionPS', 'question', 'question palier 1', 1, 100),
(2, 50, 'Génie', 'questionPS', 'question', 'question palier 2', 1, 1000),
(3, 100, 'Boss', 'questionPS', 'question', 'question palier 3', 1, 10000),
(4, 5, 'Champion', 'answerPS', 'answer', 'answer palier 1', 1, 50),
(5, 10, 'Génie', 'answerPS', 'answer', 'answer palier 2', 1, 300);

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
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `badge_entity`
--
ALTER TABLE `badge_entity`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `badge_reward_entity`
--
ALTER TABLE `badge_reward_entity`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `event_entity`
--
ALTER TABLE `event_entity`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `point_reward_entity`
--
ALTER TABLE `point_reward_entity`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `point_scale_entity`
--
ALTER TABLE `point_scale_entity`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `rule_entity`
--
ALTER TABLE `rule_entity`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `user_entity`
--
ALTER TABLE `user_entity`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

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

-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 03, 2026 at 12:01 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `onlynotes`
--

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `message_id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `message_text` text NOT NULL,
  `sent_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `messages`
--

INSERT INTO `messages` (`message_id`, `sender_id`, `message_text`, `sent_at`) VALUES
(1, 2, 'Hello', '2026-01-02 22:41:17'),
(2, 2, 'I need notes on software engineering', '2026-01-02 22:41:48'),
(3, 3, 'I think i can give it to u', '2026-01-02 22:42:35'),
(4, 3, 'lemme check', '2026-01-02 22:42:40'),
(5, 2, 'oh wow thankss ur a saviour', '2026-01-02 22:43:06');

-- --------------------------------------------------------

--
-- Table structure for table `note`
--

CREATE TABLE `note` (
  `note_id` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `subtitle` varchar(255) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `uploader_id` int(11) NOT NULL,
  `upvotes` int(11) DEFAULT 0,
  `visibility` enum('public','hidden') DEFAULT 'public'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `note`
--

INSERT INTO `note` (`note_id`, `title`, `subtitle`, `content`, `created_at`, `uploader_id`, `upvotes`, `visibility`) VALUES
(1, 'CSE', 'csee', 'cseeee', '2026-01-01 19:57:22', 2, 2, 'public'),
(2, 'PHY', 'phyyy', 'phyyyyy', '2026-01-01 20:00:29', 2, 0, 'public'),
(3, 'MATHS', 'mathhhhhh', 'mathhhhhhhhh', '2026-01-01 20:00:56', 2, 2, 'public'),
(5, 'chem', 'chemmm', 'sdaoda', '2026-01-02 21:45:27', 3, 0, 'public'),
(6, 'chem 2', 'notes for chem part 2', 'chemmmmmmmmmmmm', '2026-01-02 21:45:56', 3, 0, 'public');

-- --------------------------------------------------------

--
-- Table structure for table `note_tag`
--

CREATE TABLE `note_tag` (
  `note_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `note_tag`
--

INSERT INTO `note_tag` (`note_id`, `tag_id`) VALUES
(1, 1),
(2, 2),
(3, 3),
(5, 4),
(6, 4);

-- --------------------------------------------------------

--
-- Table structure for table `reports`
--

CREATE TABLE `reports` (
  `report_id` int(11) NOT NULL,
  `reporter_id` int(11) NOT NULL,
  `note_id` int(11) NOT NULL,
  `reason` text NOT NULL,
  `status` enum('open','resolved') DEFAULT 'open',
  `reported_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reports`
--

INSERT INTO `reports` (`report_id`, `reporter_id`, `note_id`, `reason`, `status`, `reported_at`) VALUES
(3, 3, 1, 'this has nothing in it', 'resolved', '2026-01-02 20:12:59'),
(4, 3, 3, 'this has nothing in it', 'resolved', '2026-01-02 20:13:08');

-- --------------------------------------------------------

--
-- Table structure for table `saved_notes`
--

CREATE TABLE `saved_notes` (
  `user_id` int(11) NOT NULL,
  `note_id` int(11) NOT NULL,
  `swiped_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tag`
--

CREATE TABLE `tag` (
  `tag_id` int(11) NOT NULL,
  `tag_name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tag`
--

INSERT INTO `tag` (`tag_id`, `tag_name`) VALUES
(4, 'CHEM'),
(1, 'CSE'),
(3, 'MATH'),
(2, 'PHY');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `user_id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `role` enum('user','admin') DEFAULT 'user',
  `points` int(11) DEFAULT 0,
  `rank_level` varchar(50) DEFAULT 'Beginner',
  `status` enum('active','banned') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_id`, `name`, `email`, `password`, `created_at`, `role`, `points`, `rank_level`, `status`) VALUES
(1, 'Admin', 'admin_onlynotes@gmail.com', '$2b$10$LCqGb9W1n5ODn3EyAo0Gx.iSVybJ6gC8BaNIsgWJrpGSN0.0Jz1wi', '2026-01-02 18:09:19', 'admin', 0, 'New Uploader', 'active'),
(2, 'mahdi', 'mahdirahman268@gmail.com', '$2b$10$7O9SDS2PZkMN5yChWRPKv.CKyZAkQkFIjQIE1B75hzFG3oiO6jwkq', '2026-01-01 18:15:22', 'user', 230, 'Expert Uploader', 'active'),
(3, 'Paromita', 'paromitarasheeed@gmail.com', '$2b$10$Ooqlm5eGtuUGbHAjrfu2iOJwLsv6TEFiDsHxgHGgAUIyRuiL8TBsW', '2026-01-01 20:01:14', 'user', 70, 'Active Uploader', 'active'),
(4, 'abc', 'qwerty@gmail.com', '$2b$10$5UwPgGMPhI8DlejS8hVOXeGvQEXZ9kElGTaV.C2bNA9qdp.zFYDv6', '2026-01-01 21:39:40', 'user', 0, 'New Uploader', 'active');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`message_id`),
  ADD KEY `sender_id` (`sender_id`);

--
-- Indexes for table `note`
--
ALTER TABLE `note`
  ADD PRIMARY KEY (`note_id`),
  ADD KEY `fk_note_uploader` (`uploader_id`);

--
-- Indexes for table `note_tag`
--
ALTER TABLE `note_tag`
  ADD PRIMARY KEY (`note_id`,`tag_id`),
  ADD KEY `tag_id` (`tag_id`);

--
-- Indexes for table `reports`
--
ALTER TABLE `reports`
  ADD PRIMARY KEY (`report_id`),
  ADD KEY `reporter_id` (`reporter_id`),
  ADD KEY `note_id` (`note_id`);

--
-- Indexes for table `saved_notes`
--
ALTER TABLE `saved_notes`
  ADD PRIMARY KEY (`user_id`,`note_id`),
  ADD KEY `note_id` (`note_id`);

--
-- Indexes for table `tag`
--
ALTER TABLE `tag`
  ADD PRIMARY KEY (`tag_id`),
  ADD UNIQUE KEY `tag_name` (`tag_name`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `message_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `note`
--
ALTER TABLE `note`
  MODIFY `note_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `reports`
--
ALTER TABLE `reports`
  MODIFY `report_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `tag`
--
ALTER TABLE `tag`
  MODIFY `tag_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `note`
--
ALTER TABLE `note`
  ADD CONSTRAINT `fk_note_uploader` FOREIGN KEY (`uploader_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `note_tag`
--
ALTER TABLE `note_tag`
  ADD CONSTRAINT `fk_note` FOREIGN KEY (`note_id`) REFERENCES `note` (`note_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_tag` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`tag_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `note_tag_ibfk_1` FOREIGN KEY (`note_id`) REFERENCES `note` (`note_id`),
  ADD CONSTRAINT `note_tag_ibfk_2` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`tag_id`);

--
-- Constraints for table `reports`
--
ALTER TABLE `reports`
  ADD CONSTRAINT `reports_ibfk_1` FOREIGN KEY (`reporter_id`) REFERENCES `user` (`user_id`),
  ADD CONSTRAINT `reports_ibfk_2` FOREIGN KEY (`note_id`) REFERENCES `note` (`note_id`) ON DELETE CASCADE;

--
-- Constraints for table `saved_notes`
--
ALTER TABLE `saved_notes`
  ADD CONSTRAINT `saved_notes_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `saved_notes_ibfk_2` FOREIGN KEY (`note_id`) REFERENCES `note` (`note_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

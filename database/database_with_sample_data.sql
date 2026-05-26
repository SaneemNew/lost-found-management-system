-- CampusFind Demo Database with Sample Data
-- Database: lostfound_db
-- This script recreates the database with sample users, categories, items, claims, bookmarks, and item image paths.
-- Use only for fresh setup, testing, or demonstration.

DROP DATABASE IF EXISTS lostfound_db;
CREATE DATABASE lostfound_db;
USE lostfound_db;

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

/*---------------------------------
  users table
----------------------------------*/
CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `student_id` varchar(20) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','student') DEFAULT 'student',
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*---------------------------------
  categories table
----------------------------------*/
CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*---------------------------------
  items table
----------------------------------*/
CREATE TABLE `items` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `type` enum('lost','found') NOT NULL,
  `title` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `location` varchar(150) DEFAULT NULL,
  `date_reported` date DEFAULT NULL,
  `image_path` varchar(255) DEFAULT NULL,
  `status` enum('open','claimed','resolved') DEFAULT 'open',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*---------------------------------
  claims table
----------------------------------*/
CREATE TABLE `claims` (
  `id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `claimant_id` int(11) NOT NULL,
  `description` text DEFAULT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*---------------------------------
  bookmarks table
----------------------------------*/
CREATE TABLE `bookmarks` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*---------------------------------
  sample data: users
----------------------------------*/
INSERT INTO `users` (`id`, `full_name`, `email`, `student_id`, `phone`, `password`, `role`, `status`, `created_at`) VALUES
(26, 'Admin User', 'admin@campus.com', 'ADMIN-001', '9800000000', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'admin', 'approved', '2026-05-04 06:07:03'),
(38, 'Test Student 01', 'teststudent01@campus.edu', 'STU-TEST-001', '9800000099', 'ad454dc5db203e4280041fcd250c3de1188cf66613d03a8fc6f0eadc3d1bec97', 'student', 'approved', '2026-05-17 08:24:35'),
(39, 'Pending Login Student', 'pendinglogin@campus.edu', 'STU-PENDING-001', '9800000003', '703b0a3d6ad75b649a28adde7d83c6251da457549263bc7ff45ec709b0a8448b', 'student', 'pending', '2026-05-17 08:37:32'),
(40, 'Rejected Login Student', 'rejectedlogin@campus.edu', 'STU-REJECT-001', '9800000004', '703b0a3d6ad75b649a28adde7d83c6251da457549263bc7ff45ec709b0a8448b', 'student', 'rejected', '2026-05-17 08:40:12'),
(41, 'Claim Test Student', 'claimstudent01@campus.edu', 'STU-CLAIM-001', '9800000005', '703b0a3d6ad75b649a28adde7d83c6251da457549263bc7ff45ec709b0a8448b', 'student', 'approved', '2026-05-17 09:00:59');

/*---------------------------------
  sample data: categories
----------------------------------*/
INSERT INTO `categories` (`id`, `name`) VALUES
(1, 'Electronics'),
(2, 'Clothing'),
(3, 'Books & Stationery'),
(4, 'Keys'),
(5, 'Bags & Wallets'),
(6, 'ID Cards'),
(7, 'Jewellery'),
(8, 'Sports Equipment'),
(9, 'Other');

/*---------------------------------
  sample data: items
----------------------------------*/
INSERT INTO `items` (`id`, `user_id`, `type`, `title`, `description`, `category_id`, `location`, `date_reported`, `image_path`, `status`, `created_at`) VALUES
(19, 38, 'found', 'Found Calculator', 'Scientific calculator found in classroom.', 1, 'Classroom', '2026-05-05', 'uploads/items/found_38_1779008112245.png', 'resolved', '2026-05-17 08:55:12'),
(20, 38, 'found', 'Found USB Drive', 'USB drive found near the computer lab.', 1, 'Computer Lab', '2026-05-08', 'uploads/items/found_38_1779009834472.png', 'claimed', '2026-05-17 09:23:54'),
(21, 38, 'found', 'Found Notebook', 'Notebook found near the library.', 3, 'Library', '2026-05-07', 'uploads/items/found_38_1779011100897.png', 'open', '2026-05-17 09:45:00'),
(22, 38, 'found', 'Found Water Bottle', 'Blue water bottle found near the sports ground.', 9, 'Sports Ground', '2026-05-12', 'uploads/items/found_38_1779013255242.png', 'open', '2026-05-17 10:20:55'),
(23, 38, 'found', 'Found Backpack', 'Black backpack found near the library entrance.', 5, 'Library Entrance', '2026-05-09', 'uploads/items/found_38_1779013283209.png', 'open', '2026-05-17 10:21:23'),
(25, 38, 'found', 'Speaker', 'I found a Marshall speaker.', 1, 'London Block', '2026-05-08', 'uploads/items/found_38_1779355114245.png', 'open', '2026-05-21 09:18:34');

/*---------------------------------
  sample data: claims
----------------------------------*/
INSERT INTO `claims` (`id`, `item_id`, `claimant_id`, `description`, `status`, `created_at`) VALUES
(5, 20, 41, 'This USB drive may belong to me. I can describe the files inside for verification.', 'approved', '2026-05-17 09:25:28'),
(6, 21, 41, 'This notebook may be mine. I can identify the cover design.', 'rejected', '2026-05-17 09:45:28');

/*---------------------------------
  sample data: bookmarks
----------------------------------*/
INSERT INTO `bookmarks` (`id`, `user_id`, `item_id`, `created_at`) VALUES
(7, 38, 22, '2026-05-18 05:12:44');

/*---------------------------------
  indexes and constraints
----------------------------------*/
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `student_id` (`student_id`);

ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

ALTER TABLE `items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `idx_items_type` (`type`),
  ADD KEY `idx_items_status` (`status`),
  ADD KEY `idx_items_category` (`category_id`);

ALTER TABLE `claims`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_claim` (`item_id`,`claimant_id`),
  ADD KEY `item_id` (`item_id`),
  ADD KEY `claimant_id` (`claimant_id`),
  ADD KEY `idx_claims_status` (`status`);

ALTER TABLE `bookmarks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_bookmark` (`user_id`,`item_id`),
  ADD KEY `item_id` (`item_id`);

ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

ALTER TABLE `items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

ALTER TABLE `claims`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

ALTER TABLE `bookmarks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

ALTER TABLE `items`
  ADD CONSTRAINT `items_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `items_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL;

ALTER TABLE `claims`
  ADD CONSTRAINT `claims_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `claims_ibfk_2` FOREIGN KEY (`claimant_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

ALTER TABLE `bookmarks`
  ADD CONSTRAINT `bookmarks_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `bookmarks_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`) ON DELETE CASCADE;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

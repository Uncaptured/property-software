-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 30, 2024 at 03:43 PM
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
-- Database: `real_estate_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `firstname` varchar(255) NOT NULL,
  `lastname` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `firstname`, `lastname`, `email`, `phone`, `password`, `created_at`, `updated_at`) VALUES
(1, 'Vallerian', 'Mchau', 'vallerian@gmail.com', '075621588', '$2y$12$lfj7CSgQgi8ZZEbZIKHmMuLUJaxCTzgbcmuZ43labALmX4D7gcbrq', '2024-09-18 08:12:31', '2024-09-18 08:17:34');

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `collections`
--

CREATE TABLE `collections` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `property_id` bigint(20) UNSIGNED NOT NULL,
  `type` varchar(255) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `ammount` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `collections`
--

INSERT INTO `collections` (`id`, `property_id`, `type`, `subject`, `ammount`, `description`, `status`, `created_at`, `updated_at`) VALUES
(2, 19, 'Maintenance', 'Broken Mirror', '35000', 'Payment for broken mirror', 'Not-Paid', '2024-09-13 07:04:36', '2024-09-13 07:04:36'),
(3, 19, 'Maintenance', 'Unit Damage', '30000', 'The collections for unit damage on a site', 'Paid', '2024-09-17 16:53:59', '2024-09-19 10:42:05');

-- --------------------------------------------------------

--
-- Table structure for table `companies`
--

CREATE TABLE `companies` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `company_name` varchar(255) NOT NULL,
  `company_address` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `leases`
--

CREATE TABLE `leases` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `property_id` bigint(20) UNSIGNED NOT NULL,
  `unity_id` bigint(20) UNSIGNED NOT NULL,
  `tenant_id` bigint(20) UNSIGNED NOT NULL,
  `startDate` varchar(255) NOT NULL,
  `endDate` varchar(255) NOT NULL,
  `ammount` varchar(255) NOT NULL,
  `frequency` varchar(255) NOT NULL,
  `document` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `leases`
--

INSERT INTO `leases` (`id`, `property_id`, `unity_id`, `tenant_id`, `startDate`, `endDate`, `ammount`, `frequency`, `document`, `created_at`, `updated_at`) VALUES
(1, 18, 7, 1, '2024-09-06', '2024-11-06', '106000', '2', 'lease_documents/1725627227-2102302220415 - ARRAY ASSIGNMENT.pdf', '2024-09-06 09:53:48', '2024-09-06 09:53:48'),
(3, 18, 7, 1, '2024-09-19', '2025-04-19', '371000', '7', 'lease_documents/1726753173-HCI3.pdf', '2024-09-19 10:39:38', '2024-09-19 10:39:38');

-- --------------------------------------------------------

--
-- Table structure for table `maintenances`
--

CREATE TABLE `maintenances` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `property_id` bigint(20) UNSIGNED NOT NULL,
  `subject` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `item` varchar(255) NOT NULL,
  `price` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `maintenances`
--

INSERT INTO `maintenances` (`id`, `property_id`, `subject`, `description`, `item`, `price`, `status`, `created_at`, `updated_at`) VALUES
(1, 18, 'Unit 60', 'payment for Unit 60 for broken mirror', 'Mirror', '40000', 'Not-Paid', '2024-09-10 17:06:30', '2024-09-10 17:06:30'),
(3, 19, 'unit 33', 'payment request for the gas stove on unit 33 in salamander tower', 'gas stove', '50000', 'Paid', '2024-09-11 05:27:49', '2024-09-11 07:47:41');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2024_08_15_093530_create_companies_table', 1),
(5, '2024_08_15_093540_create_admins_table', 1),
(6, '2024_08_15_093553_create_roles_table', 1),
(7, '2024_08_15_093739_create_staff_table', 1),
(8, '2024_08_15_094658_create_properties_table', 1),
(9, '2024_08_15_094659_create_unities_table', 1),
(10, '2024_08_15_094751_create_tenants_table', 1),
(11, '2024_08_15_094835_create_leases_table', 1),
(12, '2024_08_15_094858_create_maintenances_table', 1),
(13, '2024_08_15_105747_create_personal_access_tokens_table', 1),
(14, '2024_09_01_225025_update_tenants_table_add_status_column', 2),
(15, '2024_09_02_103922_update_unities_table_add_status_column', 3),
(16, '2024_09_03_104422_create_collections_table', 4),
(17, '2024_09_03_104423_create_tenants_table', 5),
(18, '2024_09_04_094835_create_leases_table', 6),
(19, '2024_09_05_225025_update_tenants_table_add_status_column', 7),
(20, '2024_09_09_093435_update_tenants_table_add_tenant_id_column', 8),
(21, '2024_09_10_104422_create_collections_table', 9);

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\Staff', 7, 'secret', 'a38f0dc577e2339de4680ac60f0e087e4eceb0e8aa5f40cda073d170e2573aa0', '[\"*\"]', NULL, NULL, '2024-08-23 10:37:35', '2024-08-23 10:37:35'),
(2, 'App\\Models\\Staff', 7, 'authToken', 'e01816d9a416a6a40b9a247f93f988ebd7923fc37842992e3cd9420e42fd67c9', '[\"*\"]', NULL, NULL, '2024-08-23 10:39:34', '2024-08-23 10:39:34'),
(3, 'App\\Models\\Staff', 7, 'authToken', '0000d55bb7a6222e760cc54016d8ffae62ca89fc1fa35e8cb4ef1bfbb68dfcaf', '[\"*\"]', NULL, NULL, '2024-08-23 10:40:41', '2024-08-23 10:40:41'),
(4, 'App\\Models\\Staff', 7, 'authToken', '3a90b7b919a13b59fc853b6c487a2ba5663747000269f57662784bd44b3721d7', '[\"*\"]', NULL, NULL, '2024-08-23 11:16:04', '2024-08-23 11:16:04'),
(5, 'App\\Models\\Staff', 7, 'authToken', 'ff3ed07f6c06d7c1c22a5d35b8b7354d58a40e06e9572cdabd71fe8b4d222659', '[\"*\"]', NULL, NULL, '2024-08-23 11:17:27', '2024-08-23 11:17:27'),
(6, 'App\\Models\\Staff', 7, 'authToken', '16bc3945d79d331381d7fe18708eb09cd87579f15ec88bb37a441731c3cd311b', '[\"*\"]', NULL, NULL, '2024-08-23 11:18:08', '2024-08-23 11:18:08'),
(7, 'App\\Models\\Staff', 7, 'authToken', '1ab6ccbf1e5a9db8ca5360495c7e6184be5f00abad476a1201123c6be5075e9b', '[\"*\"]', NULL, NULL, '2024-08-23 11:21:30', '2024-08-23 11:21:30'),
(8, 'App\\Models\\Staff', 7, 'authToken', '6f68890689e58f8995c11f6fdd69f60776594e80e77db38745867509252f73df', '[\"*\"]', NULL, NULL, '2024-08-23 11:52:01', '2024-08-23 11:52:01'),
(9, 'App\\Models\\Staff', 7, 'authToken', 'c75a946f91bf4b728009399a10a28a37d27212a202082fe570785285cec783a3', '[\"*\"]', NULL, NULL, '2024-08-23 12:02:04', '2024-08-23 12:02:04'),
(10, 'App\\Models\\Staff', 7, 'authToken', 'a87fa3fd8b7f00170b36d08cebf19d75766b655c1a2ba7374486401f8ec4bdfc', '[\"*\"]', NULL, NULL, '2024-08-23 12:03:19', '2024-08-23 12:03:19'),
(11, 'App\\Models\\Staff', 7, 'authToken', 'ab031893f3831c31faf88898fa0d42c1eace827abd16774cfa6bbe6af95b3451', '[\"*\"]', NULL, NULL, '2024-08-23 12:53:44', '2024-08-23 12:53:44'),
(12, 'App\\Models\\Staff', 7, 'authToken', 'ac10e16c0ebc1568da1a04e0754a86998f1613f1ebe8937c0b51c4f8e2a39ba7', '[\"*\"]', NULL, NULL, '2024-08-23 12:55:46', '2024-08-23 12:55:46'),
(13, 'App\\Models\\Staff', 7, 'authToken', 'afa84c4f7a94b3080a8fa63594f8a55f3276daa546cc780f1bbdf74b1eeedfcf', '[\"*\"]', NULL, NULL, '2024-08-26 05:58:42', '2024-08-26 05:58:42'),
(14, 'App\\Models\\Staff', 7, 'authToken', 'c1d48f61411f01b1fb2bffedc00f690eda2967e1063f87b8164b22f6b5e1f758', '[\"*\"]', NULL, NULL, '2024-08-26 06:06:30', '2024-08-26 06:06:30'),
(15, 'App\\Models\\Staff', 7, 'authToken', 'a010565d440762edc4e809fdf692cabbae74b86a39f2a006632e73e3fbac3581', '[\"*\"]', NULL, NULL, '2024-08-26 06:50:25', '2024-08-26 06:50:25'),
(16, 'App\\Models\\Staff', 7, 'authToken', 'eb94bde5f62ad8313c1f4f4ba2ebce74924ca24cc97af99ca5194a4724172213', '[\"*\"]', NULL, NULL, '2024-08-26 06:52:49', '2024-08-26 06:52:49'),
(17, 'App\\Models\\Staff', 7, 'authToken', '894639c9f7b11362ea62f639c1a650d0db384db9e3fa7516e1bcda2b6e614403', '[\"*\"]', NULL, NULL, '2024-08-26 07:16:49', '2024-08-26 07:16:49'),
(18, 'App\\Models\\Staff', 7, 'authToken', '9bfc70420809d596dc1d6af2e8cb803dd84fd66f91964136abf7801d99db4608', '[\"*\"]', NULL, NULL, '2024-08-26 07:21:59', '2024-08-26 07:21:59'),
(19, 'App\\Models\\Staff', 7, 'authToken', 'c12d5a91d4916b30e8e7e4a4f253dd4d6d511b6b08f91d9a05e3d1de13626cf3', '[\"*\"]', NULL, NULL, '2024-08-26 07:22:54', '2024-08-26 07:22:54'),
(20, 'App\\Models\\Staff', 7, 'authToken', '030c2bac63085c11a88f800782f6f17e905e2efe768aac98afa9b7bfbdb831eb', '[\"*\"]', NULL, NULL, '2024-08-26 07:38:38', '2024-08-26 07:38:38'),
(21, 'App\\Models\\Staff', 7, 'authToken', '942a5c3c41967c16921184879873814d9d21cd9299031a8a030396b887215d22', '[\"*\"]', NULL, NULL, '2024-08-26 07:41:01', '2024-08-26 07:41:01'),
(22, 'App\\Models\\Staff', 7, 'authToken', 'cae293cef0a10002323b4c65dc41871187a81623c76bc8411085e3227da0e70e', '[\"*\"]', NULL, NULL, '2024-08-26 07:51:45', '2024-08-26 07:51:45'),
(23, 'App\\Models\\Staff', 7, 'authToken', 'a707a9a682cdef1b01f3dfde8335e28f8ca8f34f0f3320fe8ff12e2847130f78', '[\"*\"]', NULL, NULL, '2024-08-26 08:02:53', '2024-08-26 08:02:53'),
(24, 'App\\Models\\Staff', 7, 'authToken', '2baf9b07a893cd0b18c2c697845ebd7a5f8fb453825b018dcd36835bc045e22c', '[\"*\"]', NULL, NULL, '2024-08-26 08:11:49', '2024-08-26 08:11:49'),
(25, 'App\\Models\\Staff', 7, 'authToken', '218f95117fdb573f34b0b4b55c1a0ec6835f23ac375c8d68126a6163fb4ef40d', '[\"*\"]', NULL, NULL, '2024-08-26 08:15:09', '2024-08-26 08:15:09'),
(26, 'App\\Models\\Staff', 7, 'authToken', '98da4bdbe2759bb24f9a65a534422c51bd29b57381c3adef141723ea8614855c', '[\"*\"]', NULL, NULL, '2024-08-26 08:17:41', '2024-08-26 08:17:41'),
(27, 'App\\Models\\Staff', 7, 'authToken', '5094f12d81fcf8c840c090ee55adf4c108d75f6277df613ad9c91102edf5dfbb', '[\"*\"]', NULL, NULL, '2024-08-26 08:19:46', '2024-08-26 08:19:46'),
(28, 'App\\Models\\Staff', 7, 'authToken', '8f886b0ddeb16beec629fabfb8cea66b9e82c9a9ababb143b8a2c3274e1ce8cf', '[\"*\"]', NULL, NULL, '2024-08-26 08:20:32', '2024-08-26 08:20:32'),
(29, 'App\\Models\\Staff', 7, 'authToken', 'f302ee0c093bc1514f25fcc5abacd199ebe0a0df26d3f0390b0d78679752ce35', '[\"*\"]', NULL, NULL, '2024-08-26 08:27:47', '2024-08-26 08:27:47'),
(30, 'App\\Models\\Staff', 8, 'secret', 'e212736b2fa0341a5d173a9b3c4047f415184f611fcf4b99aa611ab04419d055', '[\"*\"]', NULL, NULL, '2024-08-26 14:25:44', '2024-08-26 14:25:44'),
(31, 'App\\Models\\Staff', 8, 'authToken', '8dcd5c7a9c646c18c16643c67cc57f38e04516d325aa5b092166bbec15f07c69', '[\"*\"]', NULL, NULL, '2024-08-26 14:26:07', '2024-08-26 14:26:07'),
(32, 'App\\Models\\Staff', 8, 'authToken', 'a66635e0f57b96520e537205fd9eb2e1bca6b9e52c55cd2416914ead0bc5e3bc', '[\"*\"]', NULL, NULL, '2024-08-26 14:57:44', '2024-08-26 14:57:44'),
(33, 'App\\Models\\Staff', 8, 'authToken', 'b6c592a474f8218b51ad51580f21478d442d359421b78d3aea3ae2f91ea2e06d', '[\"*\"]', NULL, NULL, '2024-08-26 15:01:03', '2024-08-26 15:01:03'),
(34, 'App\\Models\\Staff', 8, 'authToken', '518d74fd81ef218f4c90c21d3c58546c368767df163beaddd3fe817a5b7355c4', '[\"*\"]', NULL, NULL, '2024-08-26 15:03:58', '2024-08-26 15:03:58'),
(35, 'App\\Models\\Staff', 8, 'authToken', '92734226f2ca987ad5bfd6e3aadf0da03cd95d3f4e2d19ae04881d06f740cdbd', '[\"*\"]', NULL, NULL, '2024-08-26 15:06:42', '2024-08-26 15:06:42'),
(36, 'App\\Models\\Staff', 8, 'authToken', 'b9c7f22e5cb271c146a707d826f2978d269415075c3217cc456da18479470e21', '[\"*\"]', NULL, NULL, '2024-08-26 15:08:34', '2024-08-26 15:08:34'),
(37, 'App\\Models\\Staff', 8, 'authToken', '2bee1a3f68e29afb7c8a00b0142117715864c21ea4dcaa185b5975c1e22690d4', '[\"*\"]', NULL, NULL, '2024-08-26 15:11:59', '2024-08-26 15:11:59'),
(38, 'App\\Models\\Staff', 8, 'authToken', '6eb2789e0d91f7ae0054a7ac8e5f407424b9ccc0ed8470ec078513c7ccdb2777', '[\"*\"]', NULL, NULL, '2024-08-26 15:14:39', '2024-08-26 15:14:39'),
(39, 'App\\Models\\Staff', 8, 'authToken', '437ac45166675f5791efb3bd287db4ac14d384d68cd4c7f8821a7edd38e46cc8', '[\"*\"]', NULL, NULL, '2024-08-26 15:22:58', '2024-08-26 15:22:58'),
(40, 'App\\Models\\Staff', 8, 'authToken', '3729c93a3ec462231aee2511fbb4e3a1d9a56867a9f6c0632770d2cc21c020ba', '[\"*\"]', NULL, NULL, '2024-08-26 15:24:25', '2024-08-26 15:24:25'),
(41, 'App\\Models\\Staff', 8, 'authToken', '923b2af221786c63081869bcc888016e3e5d44519a8684c4909e4904e761f257', '[\"*\"]', NULL, NULL, '2024-08-26 15:39:24', '2024-08-26 15:39:24'),
(42, 'App\\Models\\Staff', 8, 'authToken', 'f864e1c045e74a52685b4f39e75c81ecb01168aed50973db796bce0b497d905b', '[\"*\"]', NULL, NULL, '2024-08-26 16:07:36', '2024-08-26 16:07:36'),
(43, 'App\\Models\\Staff', 8, 'authToken', '4274f32ddc0b2173ee069f476cd2f2b82ecf083bf8c460f00a25e7a6f555635f', '[\"*\"]', NULL, NULL, '2024-08-26 16:09:02', '2024-08-26 16:09:02'),
(44, 'App\\Models\\Staff', 8, 'authToken', 'a9a7cc9852d9f3c7c67abe67a4155856997f8e7878a15d91aeb974132f086463', '[\"*\"]', NULL, NULL, '2024-08-26 16:10:01', '2024-08-26 16:10:01'),
(45, 'App\\Models\\Staff', 8, 'authToken', 'd9809b834fa68c7278a33830721a3512b1286f4f9d44e1130bcce67a938da9de', '[\"*\"]', NULL, NULL, '2024-08-26 16:13:10', '2024-08-26 16:13:10'),
(46, 'App\\Models\\Staff', 8, 'authToken', 'a13e33547fb40198533e0450dabd5c76b3e906af58aae4f7214cd3b1cd126ffe', '[\"*\"]', NULL, NULL, '2024-08-26 16:15:39', '2024-08-26 16:15:39'),
(47, 'App\\Models\\Staff', 8, 'authToken', '289643c219a4e99d5913e2b95037b9a654de8364111bd48ce8c813e4b983124d', '[\"*\"]', NULL, NULL, '2024-08-26 16:20:27', '2024-08-26 16:20:27'),
(48, 'App\\Models\\Staff', 8, 'authToken', 'f33310f5bdcdf5aa9e65b0b5e4c784ec24eb07757400737d8e03462718f26724', '[\"*\"]', NULL, NULL, '2024-08-26 16:21:46', '2024-08-26 16:21:46'),
(49, 'App\\Models\\Staff', 8, 'authToken', '0dca6592b0f6f1723fd76a83f4edb1dbbee99b68c58d4e39e346e1a5f333eeb4', '[\"*\"]', NULL, NULL, '2024-08-26 16:23:45', '2024-08-26 16:23:45'),
(50, 'App\\Models\\Staff', 8, 'authToken', 'd8f37965e0594c3f67b96eddebb1e8bb56390385d5f1618267cdc05dfeb3ec0f', '[\"*\"]', NULL, NULL, '2024-08-26 16:25:32', '2024-08-26 16:25:32'),
(51, 'App\\Models\\Staff', 8, 'authToken', 'dd81958791a1ca4c8aa52b7628d5ced855f2e0966731b298e1e0c668ad901865', '[\"*\"]', NULL, NULL, '2024-08-26 16:26:39', '2024-08-26 16:26:39'),
(52, 'App\\Models\\Staff', 8, 'authToken', '1f2fc10a9a527e8cfb5fd7a52856e77b7dc82ac720321fd1da13166e84177089', '[\"*\"]', NULL, NULL, '2024-08-26 16:29:31', '2024-08-26 16:29:31'),
(53, 'App\\Models\\Staff', 8, 'authToken', '1c517b6b64f3fbaed6826178aa1a3daf3485c6bc44c0efce6484a06564a6be64', '[\"*\"]', NULL, NULL, '2024-08-26 16:30:54', '2024-08-26 16:30:54'),
(54, 'App\\Models\\Staff', 8, 'authToken', '398dbefe237bba4bc1506addca3bc1a03443f6ee807b3b5f539ce44ce8f9d5ea', '[\"*\"]', NULL, NULL, '2024-08-26 16:32:27', '2024-08-26 16:32:27'),
(55, 'App\\Models\\Staff', 8, 'authToken', '8fa993e79f0ba41f455c851ddbeea52f1bae6d40da3e88b03b88dbcb64c49a2e', '[\"*\"]', NULL, NULL, '2024-08-26 16:34:03', '2024-08-26 16:34:03'),
(56, 'App\\Models\\Staff', 8, 'authToken', 'c1f9f230c0ae264c36faa36824c54bdd39201732eb8da75138c522b0fcf4b86a', '[\"*\"]', NULL, NULL, '2024-08-26 16:35:33', '2024-08-26 16:35:33'),
(57, 'App\\Models\\Staff', 8, 'authToken', '894ee2ee53ed1255671f83c396268fbcfb803ebf7772a59ef67e53e98079bcbf', '[\"*\"]', NULL, NULL, '2024-08-26 16:37:11', '2024-08-26 16:37:11'),
(58, 'App\\Models\\Staff', 8, 'authToken', 'bfa4a4d9a834a1473fa4b714a792dca11ddbd12d70d808040095359b52f7d939', '[\"*\"]', NULL, NULL, '2024-08-26 16:38:25', '2024-08-26 16:38:25'),
(59, 'App\\Models\\Staff', 8, 'authToken', 'cc85b9ee8f48c393fffd323838e166f61ebba44a4a68573c15d897f849e56a2c', '[\"*\"]', NULL, NULL, '2024-08-26 16:40:53', '2024-08-26 16:40:53'),
(60, 'App\\Models\\Staff', 8, 'authToken', '2c9d447ac9b075e9d4dae7d890ab797e5267ae58bdb5bb04792bb9ed5e73a632', '[\"*\"]', NULL, NULL, '2024-08-26 17:24:23', '2024-08-26 17:24:23'),
(61, 'App\\Models\\Staff', 8, 'authToken', '1e3319939b9ab5a2e29d614064c7a902fc50641735fdd510a944fb3acdda42e4', '[\"*\"]', NULL, NULL, '2024-08-26 17:26:15', '2024-08-26 17:26:15'),
(62, 'App\\Models\\Staff', 8, 'authToken', 'a82c5cff8a6d872ed76444e57f37b950620c819685d026cd0265943c50096060', '[\"*\"]', NULL, NULL, '2024-08-26 17:33:03', '2024-08-26 17:33:03'),
(63, 'App\\Models\\Staff', 8, 'authToken', 'c170e1b5fd8025ff05b901f80f1db0d6534e1579b0b1a700d7ec832fcb86fcfa', '[\"*\"]', NULL, NULL, '2024-08-26 17:34:56', '2024-08-26 17:34:56'),
(64, 'App\\Models\\Staff', 8, 'authToken', '0286ec66b4ef7f10711dd98d1315978b267fa01acddf47eb86c56d794abfe867', '[\"*\"]', NULL, NULL, '2024-08-26 17:37:24', '2024-08-26 17:37:24'),
(65, 'App\\Models\\Staff', 8, 'authToken', '3e6f2307847a9d5e2f786b2ea18d02e5186d7c9c433e8d0a5f4a64236e7bacc5', '[\"*\"]', NULL, NULL, '2024-08-26 17:39:36', '2024-08-26 17:39:36'),
(66, 'App\\Models\\Staff', 8, 'authToken', '0e0a5fe18dce975b388437c285d6b4b7ced9a6faabfab5497edca441fb8c5149', '[\"*\"]', NULL, NULL, '2024-08-27 07:13:49', '2024-08-27 07:13:49'),
(67, 'App\\Models\\Staff', 8, 'authToken', '0fe67852414f1c0939bbcf5b9f1d21f7f54f105b25c0b9b0248c61dd2797670e', '[\"*\"]', NULL, NULL, '2024-08-27 07:27:27', '2024-08-27 07:27:27'),
(68, 'App\\Models\\Staff', 9, 'secret', '468413bb0a82273d992c3392197047726f95823ba17008b0dd5ade70aa6921ed', '[\"*\"]', NULL, NULL, '2024-08-27 07:46:34', '2024-08-27 07:46:34'),
(69, 'App\\Models\\Staff', 8, 'authToken', 'b20a36ea44fdee3f10f39c36859bed05b55db87dcb31871eac3d491fef4315f7', '[\"*\"]', NULL, NULL, '2024-08-27 07:52:47', '2024-08-27 07:52:47'),
(70, 'App\\Models\\Staff', 8, 'authToken', '36b8d9a230f9481748afae20027a9c5503163adba9ac362033c19fe60b7d7ab4', '[\"*\"]', NULL, NULL, '2024-08-27 07:55:26', '2024-08-27 07:55:26'),
(71, 'App\\Models\\Staff', 8, 'authToken', 'dec8048d741adaaf6b1ee7c0ec330b6e098e6c9c3a578c4e677de7447d8aff44', '[\"*\"]', NULL, NULL, '2024-08-27 07:58:34', '2024-08-27 07:58:34'),
(72, 'App\\Models\\Staff', 10, 'secret', '1e6beed374014f92f3263178d729aeb8e9e102192a3f2c3962c933e69337a70a', '[\"*\"]', NULL, NULL, '2024-08-27 07:59:13', '2024-08-27 07:59:13'),
(73, 'App\\Models\\Staff', 8, 'authToken', '86e0edda413ae7438a80d0059a3d7bf28ee163202e3b34f137839d8c9445f33b', '[\"*\"]', NULL, NULL, '2024-08-27 08:17:39', '2024-08-27 08:17:39'),
(74, 'App\\Models\\Staff', 11, 'secret', 'e0632d11ffa1a8a9e5718aa3cde99f0029fdcf2ffb34e16a216607e97aec5d42', '[\"*\"]', NULL, NULL, '2024-08-27 08:18:44', '2024-08-27 08:18:44'),
(75, 'App\\Models\\Staff', 8, 'authToken', 'f481fb8bb0da046f86e2b1c4160f039a5f3039374c468ddc37e9bb1d0e42827c', '[\"*\"]', NULL, NULL, '2024-08-27 09:06:39', '2024-08-27 09:06:39'),
(76, 'App\\Models\\Staff', 12, 'secret', '29189eb097d09f8a8c4bb0381af7d36a37d3db4f6ce3eec45b3a6d99f290ae0d', '[\"*\"]', NULL, NULL, '2024-08-27 09:07:54', '2024-08-27 09:07:54'),
(77, 'App\\Models\\Staff', 8, 'authToken', 'd6fb680863be163d08e592b17078d8f5c9b4b96c2b728da4d5caddf50bd28fe5', '[\"*\"]', NULL, NULL, '2024-08-27 09:17:06', '2024-08-27 09:17:06'),
(78, 'App\\Models\\Staff', 8, 'authToken', '85de21ee12340366d368510f2009d45db6dd45b26d01b33d0fa7551bd7b81fa7', '[\"*\"]', NULL, NULL, '2024-08-27 09:39:02', '2024-08-27 09:39:02'),
(79, 'App\\Models\\Staff', 8, 'authToken', 'd039a1a7984149934fd801110b31d67ae161342a3080234bc4e15b0e3309048b', '[\"*\"]', NULL, NULL, '2024-08-27 09:48:43', '2024-08-27 09:48:43'),
(80, 'App\\Models\\Staff', 8, 'authToken', 'ba14bc03a5e8bda7e832cb4c1f74cfdb69b80618f8107c3fab44ebad16644d59', '[\"*\"]', NULL, NULL, '2024-08-27 09:50:28', '2024-08-27 09:50:28'),
(81, 'App\\Models\\Staff', 8, 'authToken', '7b6417338b30e290ccb9d1ca552cf77f4d8171042c6f74031ae4b6fb581fbbac', '[\"*\"]', NULL, NULL, '2024-08-27 09:52:43', '2024-08-27 09:52:43'),
(82, 'App\\Models\\Staff', 8, 'authToken', '3e57612e4977d7e70362ffbfcca76f7bcd543533c44e33303a03650270d04832', '[\"*\"]', NULL, NULL, '2024-08-27 09:57:33', '2024-08-27 09:57:33'),
(83, 'App\\Models\\Staff', 8, 'authToken', '8c8816b937a83c57f5eed7e51746f436622679013f0f3936707ad8641351de5f', '[\"*\"]', NULL, NULL, '2024-08-27 09:59:53', '2024-08-27 09:59:53'),
(84, 'App\\Models\\Staff', 8, 'authToken', '6d5107a0cc13fd64990839b7032609a0337023c195d4b68a8888491d3308802e', '[\"*\"]', NULL, NULL, '2024-08-27 10:04:37', '2024-08-27 10:04:37'),
(85, 'App\\Models\\Staff', 8, 'authToken', '415e8dfda499ad83fdbe753ad93d02cb66c9fc98515e6078eabfb8e9a87a0d45', '[\"*\"]', NULL, NULL, '2024-08-27 10:07:13', '2024-08-27 10:07:13'),
(86, 'App\\Models\\Staff', 13, 'secret', '6a3dfe2f7541a9bbb5a8a01d4dc2b19f73d7621f61ede1cb9a55ccfa012b6aef', '[\"*\"]', NULL, NULL, '2024-08-28 05:13:29', '2024-08-28 05:13:29'),
(87, 'App\\Models\\Staff', 8, 'authToken', 'a7607277c78ede4e395fb14cc3f8a65d7f2f5965c6c0c00c10eae0feb9ce0758', '[\"*\"]', NULL, NULL, '2024-08-28 05:57:05', '2024-08-28 05:57:05'),
(88, 'App\\Models\\Staff', 8, 'authToken', 'e7e57097a5e497a4c1091a17bd28cb28d70bf2e6fb6141188de4fe5b01706976', '[\"*\"]', NULL, NULL, '2024-08-28 06:18:13', '2024-08-28 06:18:13'),
(89, 'App\\Models\\Staff', 8, 'authToken', '82b3427e480f73c7bd042dab43f4f1da80f4b82ef8ac8e3a97c6f18b3c4ffa5c', '[\"*\"]', NULL, NULL, '2024-08-28 06:23:14', '2024-08-28 06:23:14'),
(90, 'App\\Models\\Staff', 8, 'authToken', '6ffe2d4f47f3c1a128988ea31823bcd4fd39ae6a24af47317217597d48345765', '[\"*\"]', NULL, NULL, '2024-08-29 05:03:56', '2024-08-29 05:03:56'),
(91, 'App\\Models\\Staff', 8, 'authToken', '6964388ec99040e55e5ac90fd733e830194067912a1c7faff3cfbf41122a4507', '[\"*\"]', NULL, NULL, '2024-08-29 05:12:23', '2024-08-29 05:12:23'),
(92, 'App\\Models\\Staff', 8, 'authToken', '30698e8836e08085a25b927f46211d3cd24caeb992f12776a382fb5ea62cfb09', '[\"*\"]', NULL, NULL, '2024-08-29 05:22:09', '2024-08-29 05:22:09'),
(93, 'App\\Models\\Staff', 8, 'authToken', '2cea3fdb79082e9f8cbb554080ba123f6c0cbae7da315045b1618fcd3f5a0fb4', '[\"*\"]', NULL, NULL, '2024-08-29 06:10:08', '2024-08-29 06:10:08'),
(94, 'App\\Models\\Staff', 8, 'authToken', 'd883295b25a5742c44f458ec32d07081c27b3df40da2d8537ff9c95f6844af20', '[\"*\"]', NULL, NULL, '2024-08-29 06:29:30', '2024-08-29 06:29:30'),
(95, 'App\\Models\\Staff', 8, 'authToken', '2b9f9b1c890a8f58730cc36d501d1ab0eaddf0884c7597b4fc7253f95701ee83', '[\"*\"]', NULL, NULL, '2024-08-29 06:41:32', '2024-08-29 06:41:32'),
(96, 'App\\Models\\Staff', 8, 'authToken', '0145b699da4ff5a587e2fbf04905a0ff5fe1b472fd6c69bafe7b873bd0f1afc0', '[\"*\"]', NULL, NULL, '2024-08-29 07:08:54', '2024-08-29 07:08:54'),
(97, 'App\\Models\\Staff', 8, 'authToken', '79a1cc96f36d16533097c109f2f1be015592b1c68c6ec73f526c93bdb7de1899', '[\"*\"]', NULL, NULL, '2024-08-29 07:22:53', '2024-08-29 07:22:53'),
(98, 'App\\Models\\Staff', 8, 'authToken', 'fcd306608336293322810d16bb93dd9f4d3a7fdf48607e8d7b8bfee8df84a9b0', '[\"*\"]', NULL, NULL, '2024-08-29 07:22:55', '2024-08-29 07:22:55'),
(99, 'App\\Models\\Staff', 8, 'authToken', '85ab1266a20cec85483aa8b26bf701ca2f07e7f60570adbb8228aa49e0e23e1a', '[\"*\"]', NULL, NULL, '2024-08-29 07:50:39', '2024-08-29 07:50:39'),
(100, 'App\\Models\\Staff', 8, 'authToken', 'e740f6831ed135f397d840a71639959763b73c2e080ade198a600a3c1a5d65d3', '[\"*\"]', NULL, NULL, '2024-08-29 07:52:53', '2024-08-29 07:52:53'),
(101, 'App\\Models\\Staff', 8, 'authToken', '961fb2f4fcb558aa4b4797b497422ad68b3b37821c71c6c6a4ad33da361346d4', '[\"*\"]', NULL, NULL, '2024-08-29 07:59:20', '2024-08-29 07:59:20'),
(102, 'App\\Models\\Staff', 8, 'authToken', 'b5efdefa2a24353b48bc3c1d6276d27f6c77250055e74659f9c876f9d8aa8ed3', '[\"*\"]', NULL, NULL, '2024-08-29 08:02:31', '2024-08-29 08:02:31'),
(103, 'App\\Models\\Staff', 8, 'authToken', '72edf381164bb8419c1d12663e9edb4817bba23af37588e9e374353d2b8894b5', '[\"*\"]', NULL, NULL, '2024-08-30 05:17:26', '2024-08-30 05:17:26'),
(104, 'App\\Models\\Staff', 8, 'authToken', '5be2a9772c6c5930a3cc4217495b09142557d08f658bebbf9384eea478a39cc2', '[\"*\"]', NULL, NULL, '2024-08-30 05:23:04', '2024-08-30 05:23:04'),
(105, 'App\\Models\\Staff', 8, 'authToken', 'c7bbbe4dc0729cf303cdc4d0b785b0fe98038fbde9aeff2be53d65f38c1049fa', '[\"*\"]', NULL, NULL, '2024-08-30 05:30:18', '2024-08-30 05:30:18'),
(106, 'App\\Models\\Staff', 8, 'authToken', 'fc19a7e2307015dfcc1e2fc7f053c23fd73c3fa4f38215c7192c294a87dbcbf6', '[\"*\"]', NULL, NULL, '2024-08-30 05:36:47', '2024-08-30 05:36:47'),
(107, 'App\\Models\\Staff', 8, 'authToken', '0a9498061555be38ccfcadd1ca5c0962ac5c408913630b70a9c1916e933a3b22', '[\"*\"]', NULL, NULL, '2024-08-30 05:39:22', '2024-08-30 05:39:22'),
(108, 'App\\Models\\Staff', 8, 'authToken', '2772f60a7b3ad96b71257dfe98f73b8ec734c542f1a09ccee757d4056cfd8840', '[\"*\"]', NULL, NULL, '2024-08-30 07:34:26', '2024-08-30 07:34:26'),
(109, 'App\\Models\\Staff', 8, 'authToken', 'e0557c5059afc6603cb99cc89363632e44daf340c290a17d8646c3367362b38f', '[\"*\"]', NULL, NULL, '2024-08-30 07:45:33', '2024-08-30 07:45:33'),
(110, 'App\\Models\\Staff', 8, 'authToken', '914585e8d2fad20667c69eafc2d5575bf5d8fc88792d111941901144e201fc49', '[\"*\"]', NULL, NULL, '2024-09-01 20:56:02', '2024-09-01 20:56:02'),
(111, 'App\\Models\\Staff', 14, 'secret', '02804122064c50baee9482b6aa20b9b4525b37a3eaa3dc6b091f68ce14b159b1', '[\"*\"]', NULL, NULL, '2024-09-04 10:58:11', '2024-09-04 10:58:11'),
(112, 'App\\Models\\Staff', 8, 'authToken', '3423b0f615c84b5b3d22bfc5e4fba0f7719a7fa20529127f7369689a41d20540', '[\"*\"]', NULL, NULL, '2024-09-17 05:54:45', '2024-09-17 05:54:45'),
(113, 'App\\Models\\Staff', 8, 'authToken', '9090bcc8fb76ed25ad2eedf85a577040ab4faca87d9823ffc7eedbc9d2e9ee71', '[\"*\"]', NULL, NULL, '2024-09-17 06:56:34', '2024-09-17 06:56:34'),
(114, 'App\\Models\\Staff', 8, 'authToken', 'eed2d81b01cdb29557bd407708c3e92e93ba14248a66d061ab6053d5cc8526fc', '[\"*\"]', NULL, NULL, '2024-09-17 07:00:11', '2024-09-17 07:00:11'),
(115, 'App\\Models\\Staff', 8, 'authToken', '184e5f1dac84a79a15153eeb22265a4590b53ff25074e14e9ce212a860d8cfe9', '[\"*\"]', NULL, NULL, '2024-09-17 07:09:47', '2024-09-17 07:09:47'),
(116, 'App\\Models\\Staff', 8, 'authToken', '9e850c12ab04f764068372e5348533509e3441e37493b78aad7b5e1db9cf4f54', '[\"*\"]', NULL, NULL, '2024-09-17 16:51:01', '2024-09-17 16:51:01'),
(117, 'App\\Models\\Staff', 8, 'authToken', 'bbeaf6b4c621c1e9c5b80b8c6b041a4d3b47c17cfcda145df5182585617d25c6', '[\"*\"]', NULL, NULL, '2024-09-17 17:03:45', '2024-09-17 17:03:45'),
(118, 'App\\Models\\Staff', 8, 'authToken', 'de918a6d7af3699dc06e4ff5cae9cf8d39c377c6cbbbc0afbbc7169d52e26fb2', '[\"*\"]', NULL, NULL, '2024-09-17 17:38:45', '2024-09-17 17:38:45'),
(119, 'App\\Models\\Staff', 8, 'authToken', 'b941ed2186b7347da57977091a01f2d40e0af4a1d0044bfc5da883a3d144a424', '[\"*\"]', NULL, NULL, '2024-09-17 17:41:18', '2024-09-17 17:41:18'),
(120, 'App\\Models\\Staff', 10, 'authToken', '0175ca09e377bb7a195044524fd06e82c66a70c430b799b166af77e5aeb29bd7', '[\"*\"]', NULL, NULL, '2024-09-18 06:06:18', '2024-09-18 06:06:18'),
(121, 'App\\Models\\Staff', 10, 'authToken', '3edfe0b7ab6c411791dabb1d4852807bf591a651214ad642d777e729ea2714f9', '[\"*\"]', NULL, NULL, '2024-09-18 09:40:27', '2024-09-18 09:40:27'),
(122, 'App\\Models\\Admin', 1, 'authToken', '36eb22d0ec4f3d6fba417b930292790a0f912979e93333d3e71de8db896efa50', '[\"*\"]', NULL, NULL, '2024-09-18 10:17:29', '2024-09-18 10:17:29'),
(123, 'App\\Models\\Staff', 10, 'authToken', '86b6bb2e7cd32f79fababdc3d4c4aaaf21d55ea6bec4b0f4336d6cdc4cd17cf9', '[\"*\"]', NULL, NULL, '2024-09-18 10:38:47', '2024-09-18 10:38:47'),
(124, 'App\\Models\\Staff', 10, 'authToken', '82ddcd234829764702190be3a73106ea58fb82d564a10606a4069bc04685d476', '[\"*\"]', NULL, NULL, '2024-09-19 05:01:19', '2024-09-19 05:01:19'),
(125, 'App\\Models\\Admin', 1, 'authToken', 'd80430128fe0dcbe46dae04dc4b0a6e37f89c21e81688990d9aa3544335ddc37', '[\"*\"]', NULL, NULL, '2024-09-19 05:03:23', '2024-09-19 05:03:23'),
(126, 'App\\Models\\Staff', 15, 'secret', '664b97ab93904d4a54aba273a0e4943e6336db167d43787920562b686ac0c97b', '[\"*\"]', NULL, NULL, '2024-09-19 05:31:55', '2024-09-19 05:31:55'),
(127, 'App\\Models\\Staff', 15, 'authToken', '18b24d239de30f0a55bc57a05515a57e5782d775726f3849ddc02fcaeae29f87', '[\"*\"]', NULL, NULL, '2024-09-19 05:32:30', '2024-09-19 05:32:30'),
(128, 'App\\Models\\Staff', 15, 'authToken', 'b7489a93a70afac4149de76b5a4395f9bbb731c1fa98bfaf939d3ebda628d8bf', '[\"*\"]', NULL, NULL, '2024-09-19 05:38:35', '2024-09-19 05:38:35'),
(129, 'App\\Models\\Admin', 1, 'authToken', '7e4366ff2f273239e2655f427e998ab5992f3e20116a1d62e55cc2a707561427', '[\"*\"]', NULL, NULL, '2024-09-19 10:14:18', '2024-09-19 10:14:18'),
(130, 'App\\Models\\Staff', 10, 'authToken', 'd51e9eb8052ec00d59413869c510b0521625ae5f199cae3d7de9b875ea39fb8f', '[\"*\"]', NULL, NULL, '2024-09-19 10:16:44', '2024-09-19 10:16:44'),
(131, 'App\\Models\\Staff', 15, 'authToken', '1fbbb512bf8c8505d3e8d87cbd82575c23a4f8db378a8c85de94a2df29d3fd35', '[\"*\"]', NULL, NULL, '2024-09-19 10:23:13', '2024-09-19 10:23:13'),
(132, 'App\\Models\\Staff', 8, 'authToken', '6a33975abcbdf1fe6898e065ab2a65a25e650667fe3a39c9ca0cf883d326ccb5', '[\"*\"]', NULL, NULL, '2024-09-19 10:32:13', '2024-09-19 10:32:13'),
(133, 'App\\Models\\Admin', 1, 'authToken', '99997a2b237a87ff4e5b0af1b96a426096837a35a55ca0aef4051ca23bb70c9f', '[\"*\"]', NULL, NULL, '2024-09-19 10:35:38', '2024-09-19 10:35:38'),
(134, 'App\\Models\\Admin', 1, 'authToken', '6b8ff7f2f40baad1c4f3f45f175704f97687a21ee3d2554fdfa42de6e6a8fd99', '[\"*\"]', NULL, NULL, '2024-09-23 06:36:02', '2024-09-23 06:36:02');

-- --------------------------------------------------------

--
-- Table structure for table `properties`
--

CREATE TABLE `properties` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `property_name` varchar(255) NOT NULL,
  `property_type` varchar(255) NOT NULL,
  `property_address` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `properties`
--

INSERT INTO `properties` (`id`, `property_name`, `property_type`, `property_address`, `created_at`, `updated_at`) VALUES
(15, 'Samora Tower', 'Residential', 'Dar-es-salaam, Posta', '2024-08-29 06:47:01', '2024-09-04 10:49:41'),
(18, 'Uncaptured Tower', 'Residential', 'Dar-es-salaam, Posta', '2024-09-04 10:52:10', '2024-09-04 11:06:35'),
(19, 'Salamander Tower', 'Business', 'Dar-es-salaam, Posta', '2024-09-04 11:08:13', '2024-09-23 06:37:08');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `role_name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `role_name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'Maintenance', 'This role manages and controls all maintenance', '2024-08-26 14:27:30', '2024-08-27 09:06:56'),
(2, 'Admin', 'Admin role manages all functionality and users', '2024-08-23 18:21:05', '2024-08-23 18:21:05'),
(3, 'Tenants', 'This role manage all tenants', '2024-08-23 18:39:28', '2024-08-26 16:44:13'),
(5, 'Property', 'This role manages all properties', '2024-08-23 18:42:57', '2024-08-23 18:42:57'),
(7, 'Collections', 'The role manages all collections and payments', '2024-08-23 19:27:40', '2024-08-26 16:45:04'),
(11, 'Accountants', 'Deals with money', '2024-09-04 11:14:11', '2024-09-04 11:14:11');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `staff`
--

CREATE TABLE `staff` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `firstname` varchar(255) NOT NULL,
  `lastname` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `staff`
--

INSERT INTO `staff` (`id`, `role_id`, `firstname`, `lastname`, `email`, `phone`, `password`, `created_at`, `updated_at`) VALUES
(8, 7, 'off.cial_test', 'test', 'test@gmail.com', '0756215388', '$2y$12$AVBg.Nrj0dHNORCs1qKAqul6OPSA3uDdpbI.W1jYoR.ruNVWfYE2K', '2024-08-26 14:25:42', '2024-08-26 15:25:27'),
(10, 3, 'Vallerian', 'Mchau', 'v@gmail.com', '0756215388', '$2y$12$ZHokIl6WtJ3oSby5iEnU8e9CN/1uRww8A7zwW3JV0AhcYznED4hou', '2024-08-27 07:59:13', '2024-08-27 07:59:13'),
(15, 5, 'Edson', 'eddy', 'edson@gmail.com', '0756215388', '$2y$12$lhU3srRUhNAfh6nD0JyItOIlziiEFbVrSYgwscjKp.hFScyolmf9K', '2024-09-19 05:31:53', '2024-09-19 05:31:53');

-- --------------------------------------------------------

--
-- Table structure for table `tenants`
--

CREATE TABLE `tenants` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `firstname` varchar(255) NOT NULL,
  `lastname` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(255) NOT NULL,
  `company_name` varchar(255) DEFAULT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'not-paid',
  `unity_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `tenant_id` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tenants`
--

INSERT INTO `tenants` (`id`, `firstname`, `lastname`, `email`, `phone`, `company_name`, `status`, `unity_id`, `created_at`, `updated_at`, `tenant_id`) VALUES
(1, 'Vallerian', 'Mchau', 'vallerian@gmail.com', '0756215388', NULL, 'Not-Paid', 7, '2024-09-06 09:46:53', '2024-09-06 09:46:53', NULL),
(6, 'Edson', 'Macha', 'edson@gmail.com', '0756215388', NULL, 'Not-Paid', 6, '2024-09-23 07:56:04', '2024-09-23 07:56:04', NULL),
(7, 'Edson', 'Mangi', 'edsonmangi@gmail.com', '07562153999', 'Uncaptured LTD', 'Not-Paid', 10, '2024-09-23 07:56:58', '2024-09-23 07:56:58', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `unities`
--

CREATE TABLE `unities` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `unity_name` varchar(255) NOT NULL,
  `unity_beds` varchar(255) NOT NULL,
  `unity_baths` varchar(255) NOT NULL,
  `sqm` varchar(255) NOT NULL,
  `unity_price` varchar(255) NOT NULL,
  `status` varchar(255) DEFAULT NULL,
  `property_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `unities`
--

INSERT INTO `unities` (`id`, `unity_name`, `unity_beds`, `unity_baths`, `sqm`, `unity_price`, `status`, `property_id`, `created_at`, `updated_at`) VALUES
(1, 'L90', '12', '30', '400', '3000', 'not-taken', 15, '2024-08-29 06:47:02', '2024-09-03 11:03:41'),
(2, 'L91', '15', '10', '800', '3500', 'not-taken', 15, '2024-08-29 06:47:02', '2024-08-30 06:14:42'),
(6, 'L200', '19', '12', '100', '53000', 'pending', 18, '2024-09-04 10:52:10', '2024-09-23 07:56:04'),
(7, 'L201', '20', '15', '200', '53000', 'pending', 18, '2024-09-04 10:52:10', '2024-09-06 09:42:53'),
(8, 'L202', '22', '12', '100', '50000', 'not-taken', 18, '2024-09-04 10:52:10', '2024-09-04 11:12:12'),
(9, 'L310', '10', '10', '2001', '40000', 'not-taken', 18, '2024-09-04 10:53:48', '2024-09-04 10:53:48'),
(10, 'A100', '20', '18', '300', '40000', 'pending', 19, '2024-09-04 11:08:13', '2024-09-23 07:56:58'),
(11, 'A101', '12', '10', '400', '44000', 'not-taken', 19, '2024-09-04 11:08:13', '2024-09-09 05:55:14'),
(12, 'A102', '15', '10', '201', '45000', 'not-taken', 19, '2024-09-04 11:08:14', '2024-09-06 09:25:09'),
(13, 'W200', '30', '10', '300', '40000', 'not-taken', 18, '2024-09-04 11:09:57', '2024-09-04 11:09:57');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `admins_email_unique` (`email`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `collections`
--
ALTER TABLE `collections`
  ADD PRIMARY KEY (`id`),
  ADD KEY `collections_property_id_foreign` (`property_id`);

--
-- Indexes for table `companies`
--
ALTER TABLE `companies`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `leases`
--
ALTER TABLE `leases`
  ADD PRIMARY KEY (`id`),
  ADD KEY `leases_property_id_foreign` (`property_id`),
  ADD KEY `leases_unity_id_foreign` (`unity_id`),
  ADD KEY `leases_tenant_id_foreign` (`tenant_id`);

--
-- Indexes for table `maintenances`
--
ALTER TABLE `maintenances`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `properties`
--
ALTER TABLE `properties`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `staff`
--
ALTER TABLE `staff`
  ADD PRIMARY KEY (`id`),
  ADD KEY `staff_role_id_foreign` (`role_id`);

--
-- Indexes for table `tenants`
--
ALTER TABLE `tenants`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `tenants_email_unique` (`email`),
  ADD KEY `tenants_unity_id_foreign` (`unity_id`),
  ADD KEY `tenants_tenant_id_foreign` (`tenant_id`);

--
-- Indexes for table `unities`
--
ALTER TABLE `unities`
  ADD PRIMARY KEY (`id`),
  ADD KEY `unities_property_id_foreign` (`property_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `collections`
--
ALTER TABLE `collections`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `companies`
--
ALTER TABLE `companies`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `leases`
--
ALTER TABLE `leases`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `maintenances`
--
ALTER TABLE `maintenances`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=135;

--
-- AUTO_INCREMENT for table `properties`
--
ALTER TABLE `properties`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `staff`
--
ALTER TABLE `staff`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `tenants`
--
ALTER TABLE `tenants`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `unities`
--
ALTER TABLE `unities`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `collections`
--
ALTER TABLE `collections`
  ADD CONSTRAINT `collections_property_id_foreign` FOREIGN KEY (`property_id`) REFERENCES `properties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `leases`
--
ALTER TABLE `leases`
  ADD CONSTRAINT `leases_property_id_foreign` FOREIGN KEY (`property_id`) REFERENCES `properties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `leases_tenant_id_foreign` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `leases_unity_id_foreign` FOREIGN KEY (`unity_id`) REFERENCES `unities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `staff`
--
ALTER TABLE `staff`
  ADD CONSTRAINT `staff_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tenants`
--
ALTER TABLE `tenants`
  ADD CONSTRAINT `tenants_tenant_id_foreign` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tenants_unity_id_foreign` FOREIGN KEY (`unity_id`) REFERENCES `unities` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `unities`
--
ALTER TABLE `unities`
  ADD CONSTRAINT `unities_property_id_foreign` FOREIGN KEY (`property_id`) REFERENCES `properties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 23, 2026 at 02:22 PM
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
-- Database: `sewain.db`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity_log`
--

CREATE TABLE `activity_log` (
  `logId` int(11) NOT NULL,
  `userId` int(11) DEFAULT NULL,
  `action` varchar(255) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `activity_log`
--

INSERT INTO `activity_log` (`logId`, `userId`, `action`, `timestamp`, `description`) VALUES
(1, 23, 'Login', '2026-06-12 08:35:39', 'Admin SewaIn login ke sistem'),
(7, 23, 'FLAG PROPERTY', '2026-06-14 03:47:17', 'Admin Admin SewaIn menandai (flagged) properti: Kost Sage Green Exclusive Men (ID: 9) karena: Ahay'),
(8, 23, 'FLAG PROPERTY', '2026-06-14 03:50:04', 'Admin Admin SewaIn menandai (flagged) properti: Perumahan Lisvie Village C3 no8 (ID: 6) karena: Boohong'),
(9, 23, 'RESOLVE REPORT', '2026-06-14 04:24:43', 'Admin Admin SewaIn menyelesaikan laporan ID: 7'),
(10, 23, 'RESOLVE REPORT', '2026-06-14 04:24:51', 'Admin Admin SewaIn menyelesaikan laporan ID: 8'),
(11, 23, 'FLAG PROPERTY', '2026-06-14 04:26:16', 'Admin Admin SewaIn menandai (flagged) properti: Perumahan Lisvie Village C3 no8 (ID: 6) karena: Bacot'),
(12, 23, 'VERIFY PROPERTY', '2026-06-20 16:13:30', 'Admin Admin SewaIn menyetujui properti: rainshee (ID: 8)'),
(13, 23, 'VERIFY PROPERTY', '2026-06-20 16:47:14', 'Admin Admin SewaIn menyetujui properti: Bismillah Berhasil (ID: 30)'),
(14, 23, 'FLAG PROPERTY', '2026-06-20 19:00:13', 'Admin Admin SewaIn menandai (flagged) properti: rainshee (ID: 8) karena: Betul adanya lebih mahal'),
(15, 23, 'VERIFY PROPERTY', '2026-06-21 02:35:55', 'Admin Admin SewaIn menyetujui properti: Bismillah jadi Allhamdulillah (ID: 31)'),
(16, 23, 'VERIFY PROPERTY', '2026-06-21 02:38:02', 'Admin Admin SewaIn menolak properti: Bisa (ID: 32) karena: Gk normal kamarnya 12'),
(17, 23, 'VERIFY PROPERTY', '2026-06-21 02:58:09', 'Admin Admin SewaIn menolak properti: a (ID: 34) karena: Gambar tidak ada'),
(18, 23, 'VERIFY PROPERTY', '2026-06-21 03:02:09', 'Admin Admin SewaIn menyetujui properti: Blabala (ID: 33)'),
(19, 23, 'SUSPEND USER', '2026-06-21 05:01:51', 'Admin Admin SewaIn mengubah status Allhamdulilllah menjadi Suspended'),
(20, 23, 'FLAG PROPERTY', '2026-06-23 10:58:58', 'Admin Admin SewaIn menandai (flagged) properti: Kost Putri Muslimah Syariah (ID: 10) karena: Iklan palsu'),
(21, 23, 'LOGIN', '2026-06-23 12:03:24', 'Admin SewaIn berhasil login sebagai admin'),
(22, 32, 'LOGIN', '2026-06-23 12:04:11', 'Tenant berhasil login sebagai tenant'),
(23, 32, 'LOGOUT', '2026-06-23 12:04:37', 'Tenant logout dari sistem'),
(24, 1, 'LOGIN', '2026-06-23 12:04:48', 'ANS berhasil login sebagai owner'),
(25, 1, 'LOGOUT', '2026-06-23 12:05:28', 'ANS logout dari sistem'),
(26, 34, 'LOGIN', '2026-06-23 12:06:41', 'Bismillah bisa berhasil login sebagai tenant'),
(27, 34, 'LOGIN', '2026-06-23 12:11:49', 'Bismillah bisa berhasil login sebagai tenant'),
(28, 23, 'LOGIN', '2026-06-23 12:12:43', 'Admin SewaIn berhasil login sebagai admin'),
(29, 23, 'APPROVE_OWNER_REQUEST', '2026-06-23 12:12:53', 'Admin SewaIn menyetujui permintaan Owner dari: Bismillah bisa');

-- --------------------------------------------------------

--
-- Table structure for table `flags`
--

CREATE TABLE `flags` (
  `flagId` int(11) NOT NULL,
  `propertyId` int(11) NOT NULL,
  `reason` text NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `flags`
--

INSERT INTO `flags` (`flagId`, `propertyId`, `reason`, `date`) VALUES
(2, 10, 'Iklan palsu', '2026-06-23 10:58:58');

-- --------------------------------------------------------

--
-- Table structure for table `owner_requests`
--

CREATE TABLE `owner_requests` (
  `request_id` int(11) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  `status` varchar(20) DEFAULT 'pending',
  `request_date` datetime DEFAULT current_timestamp(),
  `reason` text DEFAULT NULL,
  `ktp_photo_url` varchar(500) NOT NULL,
  `reject_reason` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `owner_requests`
--

INSERT INTO `owner_requests` (`request_id`, `tenant_id`, `status`, `request_date`, `reason`, `ktp_photo_url`, `reject_reason`) VALUES
(1, 26, 'approved', '2026-06-21 00:59:55', 'Saya mau jadi owner Loli Caffe', 'https://res.cloudinary.com/dxffgd86l/image/upload/v1781978396/sewain/f1f5244d-90a1-498d-8551-3bf837385c43.png', NULL),
(2, 27, 'approved', '2026-06-21 01:30:10', 'a', 'https://res.cloudinary.com/dxffgd86l/image/upload/v1781980211/sewain/b91f00aa-e9bb-4c0f-b8c7-b12ec4ad58e8.png', NULL),
(3, 29, 'approved', '2026-06-21 01:40:30', 'q', 'https://res.cloudinary.com/dxffgd86l/image/upload/v1781980831/sewain/325a0aa6-2255-4b3d-b096-43ae0f67384e.png', NULL),
(4, 30, 'approved', '2026-06-21 01:55:28', 'z', 'https://res.cloudinary.com/dxffgd86l/image/upload/v1781981729/sewain/604cf7da-9e4a-45b4-9a5d-65a4bd5bf4f2.png', NULL),
(5, 31, 'approved', '2026-06-21 09:32:23', 'Mau aja plisss', 'https://res.cloudinary.com/dxffgd86l/image/upload/v1782009144/sewain/5ac3d791-68d1-4604-a842-b5902851a337.png', NULL),
(6, 33, 'approved', '2026-06-21 20:46:52', 'Saya ingin menjadi owner agar dapat mempromosikan properti saya di Sewain', 'https://res.cloudinary.com/dxffgd86l/image/upload/v1782049612/sewain/26e57093-5e7f-44a3-ab0d-b66bc0110c82.png', NULL),
(7, 25, 'Pending', '2026-06-21 21:28:00', 'Saya ingin menyewakan kost kosong milik ibu saya yang ada di sebelah rumah.', 'https://images.unsplash.com/photo-1621861009139-3074558509e5?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60', NULL),
(8, 34, 'rejected', '2026-06-23 19:07:41', 'Bismillah Bisa', 'https://res.cloudinary.com/dxffgd86l/image/upload/v1782216460/sewain/7da7fecc-1898-4e33-aef4-4f3dd582958d.jpg', 'KTP Tidak Valid'),
(9, 34, 'approved', '2026-06-23 19:12:23', 'Bismillah sudah bisa', 'https://res.cloudinary.com/dxffgd86l/image/upload/v1782216742/sewain/8df6b4a1-1b45-4060-b72e-d0c3ad2164da.jpg', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `properties`
--

CREATE TABLE `properties` (
  `propertyId` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `location` varchar(255) NOT NULL,
  `price` double NOT NULL,
  `propertyType` varchar(100) NOT NULL,
  `availability` tinyint(4) NOT NULL DEFAULT 1,
  `verificationStatus` varchar(50) NOT NULL DEFAULT 'Pending',
  `flagStatus` varchar(50) NOT NULL DEFAULT 'None',
  `photos` text DEFAULT NULL,
  `description` text DEFAULT NULL,
  `facilities` text DEFAULT NULL,
  `ownerId` int(11) NOT NULL DEFAULT 1,
  `gender` varchar(50) DEFAULT NULL,
  `roomType` varchar(100) DEFAULT NULL,
  `jumlahKamar` int(11) DEFAULT NULL,
  `luasTanah` double DEFAULT NULL,
  `durasiMinimum` int(11) DEFAULT NULL,
  `lantai` int(11) DEFAULT NULL,
  `nomorUnit` varchar(50) DEFAULT NULL,
  `tipeUnit` varchar(50) DEFAULT NULL,
  `flagReason` text DEFAULT NULL,
  `flagCount` int(11) NOT NULL DEFAULT 0,
  `rejectionReason` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `properties`
--

INSERT INTO `properties` (`propertyId`, `name`, `location`, `price`, `propertyType`, `availability`, `verificationStatus`, `flagStatus`, `photos`, `description`, `facilities`, `ownerId`, `gender`, `roomType`, `jumlahKamar`, `luasTanah`, `durasiMinimum`, `lantai`, `nomorUnit`, `tipeUnit`, `flagReason`, `flagCount`, `rejectionReason`) VALUES
(9, 'Kost Sage Green Exclusive Men', 'Jl. Sukabirus No. 12, Dayeuhkolot, Bandung', 1500000, 'Kost', 1, 'Approved', 'Flagged', 'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af', 'Kost khusus pria dengan nuansa minimalis modern dekat dengan gerbang belakang kampus. Suasana tenang dan sangat cocok untuk belajar.', 'AC, Wi-Fi / Internet, Kamar Mandi Dalam, Kasur / Bed, Lemari Pakaian, Parkir Mobil / Motor, Keamanan / CCTV', 1, 'Pria', 'Deluxe Room', NULL, NULL, NULL, NULL, NULL, NULL, 'Ahay', 1, NULL),
(10, 'Kost Putri Muslimah Syariah', 'Jl. Sukawening No. 45, Dayeuhkolot, Bandung', 1200000, 'Kost', 1, 'Approved', 'Flagged', 'https://images.unsplash.com/photo-1598928506311-c55ded91a20c', 'Kost putri syariah lingkungan aman, bersih, dan dijaga 24 jam. Lengkap dengan dapur bersama dan area jemur yang luas.', 'Wi-Fi / Internet, Kamar Mandi Dalam, Kasur / Bed, Lemari Pakaian, Dapur / Kitchen, Keamanan / CCTV', 1, 'Wanita', 'Standard Room', NULL, NULL, NULL, NULL, NULL, NULL, 'Iklan palsu', 2, NULL),
(11, 'D-S Sage Mansion (Mixed Luxury)', 'Jl. Telekomunikasi No. 88, Terusan Buah Batu, Bandung', 2500000, 'Kost', 1, 'Approved', 'None', 'https://images.unsplash.com/photo-1505691938895-1758d7feb511', 'Kost campur premium setara hotel berbintang. Menyediakan fasilitas laundry gratis dan pembersihan kamar berkala.', 'AC, Wi-Fi / Internet, Kamar Mandi Dalam, Kasur / Bed, Lemari Pakaian, Dapur / Kitchen, Parkir Mobil / Motor, Mesin Cuci / Laundry, Listrik Include, Keamanan / CCTV', 1, 'Campur', 'Suite Room', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL),
(12, 'Kost Pods Minimalis Sukabirus', 'Jl. Sukabirus Gang PGA No. 3, Bandung', 850000, 'Kost', 1, 'Approved', 'None', 'https://images.unsplash.com/photo-1554995207-c18c203602cb', 'Kost ekonomis dengan konsep kapsul/pods modern. Sangat hemat dan cocok untuk mahasiswa yang aktif di luar ruangan.', 'Wi-Fi / Internet, Kasur / Bed, Lemari Pakaian, Dapur / Kitchen, Parkir Mobil / Motor, Listrik Include', 1, 'Pria', 'Single Pod', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL),
(13, 'Kost Putri Anggrek Sage', 'Jl. Radio No. 14, Dayeuhkolot, Bandung', 1350000, 'Kost', 1, 'Approved', 'None', 'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace', 'Kost putri dengan desain interior estetik. Setiap kamar dilengkapi jendela besar dengan sirkulasi udara yang optimal.', 'AC, Wi-Fi / Internet, Kamar Mandi Dalam, Kasur / Bed, Lemari Pakaian, Parkir Mobil / Motor', 1, 'Wanita', 'Premium Single', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL),
(14, 'Rumah Cluster Emerald Buah Batu', 'Cluster Emerald Blok C No. 8, Buah Batu, Bandung', 45000000, 'Rumah', 1, 'Approved', 'None', 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c', 'Disewakan rumah cluster minimalis siap huni. Sistem gerbang satu pintu (one-gate system), lingkungan sangat asri, aman, dan bebas dari banjir.', 'Dapur / Kitchen, Parkir Mobil / Motor, Keamanan / CCTV', 1, NULL, NULL, 3, 120, NULL, NULL, NULL, NULL, NULL, 0, NULL),
(15, 'Rumah Sudut Modern Podomoro', 'Kawasan Podomoro Park, Blok Tulip No. 1, Bandung', 75000000, 'Rumah', 1, 'Approved', 'None', 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9', 'Rumah sudut tipe premium dengan halaman luas di kawasan elit. Pencahayaan alami luar biasa berkat dinding kaca modern.', 'AC, Wi-Fi / Internet, Dapur / Kitchen, Parkir Mobil / Motor, Mesin Cuci / Laundry, Keamanan / CCTV', 1, NULL, NULL, 4, 200, NULL, NULL, NULL, NULL, NULL, 0, NULL),
(16, 'Rumah Hub Minimalis dekat Pintu Tol', 'Jl. Batununggal Indah Raya No. 4, Bandung', 38000000, 'Rumah', 1, 'Approved', 'None', 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0', 'Rumah minimalis fungsional sangat dekat dengan akses pintu tol Buah Batu. Pilihan paling efisien untuk mobilitas tinggi.', 'Dapur / Kitchen, Parkir Mobil / Motor', 1, NULL, NULL, 2, 90, NULL, NULL, NULL, NULL, NULL, 0, NULL),
(17, 'Rumah Klasik Kolonial Asri', 'Jl. Pelajar Pejuang 45 No. 19, Lengkong, Bandung', 60000000, 'Rumah', 1, 'Approved', 'None', 'https://images.unsplash.com/photo-1564013799919-ab600027ffc6', 'Rumah dengan arsitektur klasik kolonial yang terawat baik. Memiliki langit-langit plafon tinggi sehingga ruangan selalu sejuk.', 'Dapur / Kitchen, Parkir Mobil / Motor, Keamanan / CCTV', 1, NULL, NULL, 5, 250, NULL, NULL, NULL, NULL, NULL, 0, NULL),
(18, 'Rumah Kontemporer Sage Wood', 'Komp. Singgasana Pradana Blok D, Bandung', 55000000, 'Rumah', 1, 'Approved', 'None', 'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c', 'Rumah desain kontemporer dengan aksen kayu jati dan cat sage green. Sudah termasuk beberapa perabotan utama (semi-furnished).', 'AC, Dapur / Kitchen, Parkir Mobil / Motor, Keamanan / CCTV', 1, NULL, NULL, 3, 150, NULL, NULL, NULL, NULL, NULL, 0, NULL),
(19, 'The Suites Metro Luxury Apartment', 'Tower A Lt. 12 No. 05, Jl. Soekarno-Hatta, Bandung', 4500000, 'Apartement', 1, 'Approved', 'None', 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00', 'Apartemen luxury tipe 2 BR full furnished dengan view langsung menghadap ke Gunung Manglayang. Akses mal dan kuliner sangat dekat.', 'AC, Wi-Fi / Internet, Kamar Mandi Dalam, Kasur / Bed, Lemari Pakaian, Dapur / Kitchen, Parkir Mobil / Motor, Keamanan / CCTV', 1, NULL, NULL, NULL, NULL, NULL, 12, 'A-1205', '2BR Studio', NULL, 0, NULL),
(20, 'Newton Residence Studio Unit', 'Tower B Lt. 22 No. 11, Buah Batu, Bandung', 3200000, 'Apartement', 1, 'Approved', 'None', 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688', 'Unit studio minimalis yang sangat rapi dan praktis. Cocok untuk profesional muda atau mahasiswa tingkat akhir.', 'AC, Wi-Fi / Internet, Kamar Mandi Dalam, Kasur / Bed, Lemari Pakaian, Dapur / Kitchen, Keamanan / CCTV', 1, NULL, NULL, NULL, NULL, NULL, 22, 'B-2211', '1BR Studio', NULL, 0, NULL),
(21, 'Grand Asia Afrika Penthouse Suite', 'Tower C Lt. 25 No. 01, Jl. Asia Afrika, Bandung', 8500000, 'Apartement', 1, 'Approved', 'None', 'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d', 'Unit penthouse premium di pusat bersejarah Kota Bandung. Luas, mewah, dan dilengkapi dengan privat bathtub.', 'AC, Wi-Fi / Internet, Kamar Mandi Dalam, Kasur / Bed, Lemari Pakaian, Dapur / Kitchen, Parkir Mobil / Motor, Mesin Cuci / Laundry, Keamanan / CCTV', 1, NULL, NULL, NULL, NULL, NULL, 25, 'C-2501', 'Penthouse Suite', NULL, 0, NULL),
(22, 'Apartemen Galeri Ciumbuleuit Asri', 'Tower 1 Lt. 08 No. 14, Ciumbuleuit, Bandung', 3800000, 'Apartement', 1, 'Approved', 'None', 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2', 'Unit apartemen sejuk di Bandung Utara dengan pemandangan lembah hijau yang asri. Sangat tenang terbebas dari kebisingan kota.', 'AC, Wi-Fi / Internet, Kamar Mandi Dalam, Kasur / Bed, Lemari Pakaian, Dapur / Kitchen, Parkir Mobil / Motor, Keamanan / CCTV', 1, NULL, NULL, NULL, NULL, NULL, 8, 'T1-0814', '1BR Executive', NULL, 0, NULL),
(23, 'Hatten Place Urban Studio Apartment', 'Tower Utama Lt. 15 No. 32, Soekarno-Hatta, Bandung', 2900000, 'Apartement', 1, 'Approved', 'None', 'https://images.unsplash.com/photo-1536376072261-38c75010e6c9', 'Apartemen tipe studio ekonomis dengan desain fungsional perkotaan (Smart Urban Living Space).', 'AC, Wi-Fi / Internet, Kamar Mandi Dalam, Kasur / Bed, Lemari Pakaian, Keamanan / CCTV', 1, NULL, NULL, NULL, NULL, NULL, 15, 'M-1532', 'Compact Studio', NULL, 0, NULL),
(24, 'Kontrakan Paviliun Sukabirus 2 Kamar', 'Jl. Sukabirus Gg. Bakti No. 10, Dayeuhkolot, Bandung', 18000000, 'Kontrakan', 1, 'Approved', 'None', 'https://images.unsplash.com/photo-1484154218962-a197022b5858', 'Kontrakan tipe petak paviliun, bangunan baru gres. Memiliki ruang tamu mandiri, dapur bersih, dan token listrik terpisah tiap unit.', 'Dapur / Kitchen, Parkir Mobil / Motor', 1, NULL, NULL, 2, NULL, 12, NULL, NULL, NULL, NULL, 0, NULL),
(25, 'Kontrakan Petakan Murah Segar', 'Jl. Mengger Hilir No. 27, Bandung', 12000000, 'Kontrakan', 1, 'Approved', 'None', 'https://images.unsplash.com/photo-1513694203232-719a280e022f', 'Kontrakan petak ekonomis tahunan, lokasi strategis bebas banjir. Sangat cocok untuk keluarga kecil yang baru menikah.', 'Dapur / Kitchen, Parkir Mobil / Motor', 1, NULL, NULL, 1, NULL, 12, NULL, NULL, NULL, NULL, 0, NULL),
(26, 'Kontrakan Townhouse Semi-Furnished', 'Komp. Bojongsoang Asri No. B5, Bandung', 22000000, 'Kontrakan', 1, 'Approved', 'None', 'https://images.unsplash.com/photo-1582268611958-ebfd161ef9cf', 'Kontrakan tipe rumah minimalis 2 lantai di dalam kompleks swadaya. Sudah terpasang gorden, pompa air jetpump bersih, dan jemuran.', 'Kasur / Bed, Dapur / Kitchen, Parkir Mobil / Motor', 1, NULL, NULL, 2, NULL, 6, NULL, NULL, NULL, NULL, 0, NULL),
(27, 'Kontrakan Cluster Minimalis Bojongsoang', 'Jl. Raya Bojongsoang No. 142, Bandung', 20000000, 'Kontrakan', 1, 'Approved', 'None', 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750', 'Kontrakan cluster asri satu lantai. Keamanan terjamin karena dijaga pos ronda malam, jalanan depan rumah lebar masuk dua mobil.', 'Dapur / Kitchen, Parkir Mobil / Motor, Keamanan / CCTV', 1, NULL, NULL, 2, NULL, 12, NULL, NULL, NULL, NULL, 0, NULL),
(28, 'Kontrakan Rumah Petak Asri PGA', 'Jl. PGA Gg. Sentosa No. 9, Dayeuhkolot, Bandung', 15000000, 'Kontrakan', 1, 'Approved', 'None', 'https://images.unsplash.com/photo-1568605114967-8130f3a36994', 'Kontrakan asri dekat persawahan lokal Dayeuhkolot. Udara segar, air jernih tidak berbau, dekat akses jalan utama bojongsoang.', 'Dapur / Kitchen, Parkir Mobil / Motor', 1, NULL, NULL, 2, NULL, 12, NULL, NULL, NULL, NULL, 0, NULL),
(35, 'Kost Eksklusif Tenant', 'Kawasan Kampus Telkom', 1250000, 'Kost', 1, 'Approved', 'None', 'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af', 'Kost nyaman, aman, dan bersih yang didaftarkan khusus untuk user tenant.', 'AC, Wi-Fi / Internet, Kamar Mandi Dalam', 32, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `reports`
--

CREATE TABLE `reports` (
  `reportId` int(11) NOT NULL,
  `propertyId` int(11) DEFAULT NULL,
  `tenantId` int(11) DEFAULT NULL,
  `issueType` enum('Harga Tidak Sesuai','Gambar Tidak Sesuai','Indikasi Penipuan/Scam','Fasilitas Rusak','Lainnya') NOT NULL,
  `description` text NOT NULL,
  `status` enum('Pending','Investigating','Resolved','Rejected') DEFAULT 'Pending',
  `reportDate` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reports`
--

INSERT INTO `reports` (`reportId`, `propertyId`, `tenantId`, `issueType`, `description`, `status`, `reportDate`) VALUES
(7, 9, 1, 'Harga Tidak Sesuai', 'bagus', 'Resolved', '2026-06-11 05:31:11'),
(8, 10, 24, 'Lainnya', 'Bisbisbaa', 'Resolved', '2026-06-11 06:41:26'),
(10, 35, 25, 'Gambar Tidak Sesuai', 'Saya ngecek ke lokasi, ternyata fotonya ngambil dari Google! Tolong Admin segera ditindaklanjuti!', 'Pending', '2026-06-21 14:09:27'),
(11, 10, 32, 'Gambar Tidak Sesuai', 'Mahal tapi gambarnya tidak sama', 'Resolved', '2026-06-23 10:57:17');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `userId` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `role` enum('admin','tenant','owner') NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'Active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`userId`, `name`, `email`, `password`, `phone`, `role`, `status`) VALUES
(1, 'ANS', 'rian29062006@gmail.com', '10000:KZRbJf13D3Xx5xiuyQEK9w==:TOUKUmdkE88myYhd92H+fJRHv+MuqlkdGuY/X4yjPis=', '', 'owner', 'Active'),
(3, 'andinaifahhafisah', 'adriananis06@gmail.com', '10000:PHjPNxJ1WKLi4xfqdzcRVA==:M98B/7qnzyjDo972nSrp1Z+dVI8zEphBKtoQ6JOWyCg=', '082187003476', 'owner', 'Active'),
(23, 'Admin SewaIn', 'admin@sewain.com', '10000:HyxRh7mjeyJ9+SrFSoBTJg==:NfkhtCnjEw37JodN8n+CLAzSIEfu1UlqnB+hS4vHtmY=', '081234567890', 'admin', 'Active'),
(24, 'Tenant Test', 'tenant_test@gmail.com', 'password123', '081234567890', 'owner', 'Active'),
(25, 'MBG Wowo', 'mbg@gmail.com', '10000:OvOaMkOexV6k/Xt35t78LA==:D5hPlCjQqyATPELdwqv9l4cm6/YHEJYZDh5ovRJ4ifY=', '0823456789', 'tenant', 'Active'),
(26, 'Jane Doe', 'janedoe@gmail.com', '10000:MBQP0kUpVbSieb3SuHESAA==:B2OSXwIp/2stlJy9Q+TkydD7g78arRkUJAMOUWEYvx0=', '08123456789', 'owner', 'Active'),
(27, 'aa', 'a', '10000:8FUP314FxahocGGRTf/vhw==:zsW82BXJTHesuks8HtH0oH9dO+RpR61D1HYBxWW7iV0=', '08123456789', 'owner', 'Active'),
(29, 'q', 'q', '10000:n01tDlK7VqAFMb7qnIB7aQ==:e4wyKoOPi2hrsIzFyRNfE1Udkv+iGG78i56VU0wQkV0=', '1', 'owner', 'Active'),
(30, 'z', 'z', '10000:DldQHbWjdNZeTjlCAZiAvQ==:XHbAkivJkt7Dw3rGB9rCz1fFiQSTKMBdsrI0/vbixcI=', '1', 'owner', 'Active'),
(31, 'Allhamdulilllah', 'rn@gmail.com', '10000:+BaIwtvKLKdjw77VyCMsNg==:133Y8bJWWxtBwa0quFowhXEvlwGUAxY/asLm6/Zg0bQ=', '082187003476', 'owner', 'Suspended'),
(32, 'Tenant', 'tenant@sewain.com', '10000:OPoWOubZ1RJPmQQfEFGQbg==:UBuQHjU9GpcCssWr7lx2OrlDVnleZ4YQjJd/Xmy1v7E=', '08212345678', 'tenant', 'Active'),
(33, 'owner', 'owner@sewain.com', '10000:R+DmbU2RCLb1bQcpr3zSxw==:7lAL8rqn3U67EoPXQE1XnV8AQiNsvBQqP8+5C3CVjvA=', '0821987654321', 'owner', 'Active'),
(34, 'Bismillah bisa', 'bisa@gmail.com', '10000:vLUSJxI7mZdELzRRNqJuVg==:OwhwT6nO+MhODHH8inXu3EhzcnO/N7+j6xIpC/eTpGI=', '082187003476', 'owner', 'Active');

-- --------------------------------------------------------

--
-- Table structure for table `wishlists`
--

CREATE TABLE `wishlists` (
  `wishlistId` int(11) NOT NULL,
  `tenantId` int(11) NOT NULL,
  `propertyId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `wishlists`
--

INSERT INTO `wishlists` (`wishlistId`, `tenantId`, `propertyId`) VALUES
(4, 1, 11),
(3, 1, 12),
(2, 1, 13),
(6, 29, 11),
(7, 29, 12),
(9, 30, 11),
(11, 31, 13),
(15, 32, 11);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activity_log`
--
ALTER TABLE `activity_log`
  ADD PRIMARY KEY (`logId`),
  ADD KEY `userId` (`userId`);

--
-- Indexes for table `flags`
--
ALTER TABLE `flags`
  ADD PRIMARY KEY (`flagId`),
  ADD KEY `propertyId` (`propertyId`);

--
-- Indexes for table `owner_requests`
--
ALTER TABLE `owner_requests`
  ADD PRIMARY KEY (`request_id`),
  ADD KEY `tenant_id` (`tenant_id`);

--
-- Indexes for table `properties`
--
ALTER TABLE `properties`
  ADD PRIMARY KEY (`propertyId`);

--
-- Indexes for table `reports`
--
ALTER TABLE `reports`
  ADD PRIMARY KEY (`reportId`),
  ADD KEY `propertyId` (`propertyId`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`userId`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `wishlists`
--
ALTER TABLE `wishlists`
  ADD PRIMARY KEY (`wishlistId`),
  ADD UNIQUE KEY `tenantId` (`tenantId`,`propertyId`),
  ADD KEY `propertyId` (`propertyId`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity_log`
--
ALTER TABLE `activity_log`
  MODIFY `logId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `flags`
--
ALTER TABLE `flags`
  MODIFY `flagId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `owner_requests`
--
ALTER TABLE `owner_requests`
  MODIFY `request_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `properties`
--
ALTER TABLE `properties`
  MODIFY `propertyId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `reports`
--
ALTER TABLE `reports`
  MODIFY `reportId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `userId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `wishlists`
--
ALTER TABLE `wishlists`
  MODIFY `wishlistId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `activity_log`
--
ALTER TABLE `activity_log`
  ADD CONSTRAINT `activity_log_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`userId`) ON DELETE SET NULL;

--
-- Constraints for table `flags`
--
ALTER TABLE `flags`
  ADD CONSTRAINT `flags_ibfk_1` FOREIGN KEY (`propertyId`) REFERENCES `properties` (`propertyId`) ON DELETE CASCADE;

--
-- Constraints for table `owner_requests`
--
ALTER TABLE `owner_requests`
  ADD CONSTRAINT `owner_requests_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `users` (`userId`);

--
-- Constraints for table `reports`
--
ALTER TABLE `reports`
  ADD CONSTRAINT `reports_ibfk_1` FOREIGN KEY (`propertyId`) REFERENCES `properties` (`propertyId`) ON DELETE CASCADE;

--
-- Constraints for table `wishlists`
--
ALTER TABLE `wishlists`
  ADD CONSTRAINT `wishlists_ibfk_1` FOREIGN KEY (`tenantId`) REFERENCES `users` (`userId`) ON DELETE CASCADE,
  ADD CONSTRAINT `wishlists_ibfk_2` FOREIGN KEY (`propertyId`) REFERENCES `properties` (`propertyId`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

# SewaIn - Panduan Instalasi dan Menjalankan Project

Panduan langkah demi langkah ini ditujukan bagi siapa saja (developer/teman tim) yang baru saja melakukan *clone* atau *pull* *repository* ini dari GitHub agar dapat menjalankan project secara lokal tanpa menemui masalah *error missing library*.

---

## 1. Prasyarat Sistem (*Requirements*)
Pastikan *software* berikut sudah terinstal di komputer Anda:
*   **JDK (Java Development Kit)**: Versi 8 atau yang lebih baru.
*   **Apache NetBeans IDE**: Untuk membuka, mem-*build*, dan menjalankan project Java Web.
*   **Apache Tomcat Server**: Digunakan sebagai *web server* (direkomendasikan v8.5 atau v9.0).
*   **XAMPP (MySQL/MariaDB)**: Sebagai *database server* lokal.

---

## 2. Persiapan Database
Proyek ini membutuhkan *database* MySQL untuk dapat berjalan. Berikut adalah cara untuk mem-*setup* *database*-nya:

1. Buka **XAMPP Control Panel**.
2. Klik tombol **Start** pada modul **Apache** dan **MySQL**.
3. Buka *browser* dan akses **`http://localhost/phpmyadmin`**.
4. Klik *New*, lalu buat sebuah *database* baru dengan nama persis seperti ini: **`sewain.db`** (pastikan penulisan sama persis).
5. Setelah berhasil terbuat, klik pada *database* `sewain.db` di sebelah kiri.
6. Masuk ke tab **Import** di bagian atas layar.
7. Pilih *Choose File* dan cari file bernama **`sewain_db.sql`** yang ada di *root folder* dari *project* ini.
8. Scroll ke bawah lalu klik **Import** (atau **Go**).
9. Tunggu hingga proses selesai dan pastikan seluruh tabel sudah muncul di dalam *database* `sewain.db`.

---

## 3. Membuka Project di NetBeans
1. Buka aplikasi **Apache NetBeans**.
2. Pilih menu **File** -> **Open Project...**
3. Arahkan direktori ke folder **`SewainV1`** hasil *clone* dari GitHub, lalu klik Open.

---

## 4. Konfigurasi Server Tomcat
Karena setiap komputer memiliki letak instalasi Tomcat yang berbeda, Anda harus memetakan ulang server Tomcat di NetBeans Anda ke project ini:
1. Di panel *Projects* sebelah kiri NetBeans, **Klik Kanan** pada project **`SewainV1`**.
2. Pilih **Properties**.
3. Pada menu sebelah kiri jendela *Properties*, klik bagian **Run**.
4. Di sisi kanan, perhatikan menu dropdown **Server**:
   *   Pilih **Apache Tomcat** atau **Tomcat**.
   *   *(Jika kosong, klik tombol **Manage...** -> **Add Server...** lalu hubungkan NetBeans dengan folder instalasi Apache Tomcat di komputer Anda).*
5. Klik **OK**.

---

## 5. Sinkronisasi Library (Aman dari *Error*)
File *library* penting seperti `mysql-connector` dan komponen *cloud* lainnya sudah di-*bundle* secara permanen di dalam folder `web/WEB-INF/lib/` dengan sistem *relative path*.
*   Project ini seharusnya **langsung bisa ter-compile** tanpa peringatan *missing library*.
*   Jika masih muncul tanda seru merah (`!`) pada icon project Anda, klik kanan project lalu pilih **Resolve Missing Server Problem** (biasanya ini hanya konfirmasi penyamaan versi Tomcat).

---

## 6. Compile & Run! 🚀
Langkah terakhir untuk menjalankan aplikasi:
1. **Klik Kanan** pada project **`SewainV1`**, lalu pilih **Clean and Build**.
   *   *Tunggu hingga proses selesai dan panel Output di bawah memunculkan tulisan `BUILD SUCCESSFUL` berwarna hijau.*
2. Klik tombol **Run** (ikon "Play" hijau di toolbar atas) atau cukup tekan **F6** pada keyboard.
3. Tunggu beberapa detik, Apache Tomcat akan menyala dan *browser* *default* Anda akan otomatis terbuka.

**💡 PENTING SAAT PERTAMA KALI JALAN:**
Saat Anda pertama kali membuka halaman web, cobalah untuk langsung melakukan simulasi klik (seperti mencoba *Login* atau *Register* sembarang). Jangan panik jika percobaan detik pertama terasa sedikit lama (sekitar 1-2 detik *loading*). Di detik itu, Java sedang secara otomatis merakit seluruh kerangka tabel di dalam database MySQL Anda! Setelah itu aplikasi akan berjalan sangat mulus dan normal.

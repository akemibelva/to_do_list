# todolist
Aplikasi To-Do List sederhana tapi lengkap untuk mencatat tugas harian. Bisa menambahkan, mengedit, mencari, dan menandai tugas sudah selesai. Ada juga fitur login/registrasi sederhana menggunakan Hive sebagai database lokal.

## Fitur Utama
- Splash Screen: Tampilan awal saat membuka aplikasi.
- Login & Registrasi: Membuat akun baru dan masuk dengan username/password.
- Home Page:
  - Menampilkan daftar tugas.
  - Bisa menandai tugas sudah selesai.
  - Cari tugas berdasarkan judul.
  - Mode warna: standar atau cerah.
  - Logout.
- Tambah/Edit Tugas:
  - Tambah tugas baru dengan judul, deskripsi, dan tanggal jatuh tempo.
  - - Edit tugas yang sudah ada.
- Glassmorphism UI: Efek blur transparan di login/registrasi.

## Penjelasan file
1. Folder Database
   a. model.dart → Model Task untuk menyimpan tugas di Hive.
   b. model.g.dart → File auto-generated Hive adapter untuk Task.
   c. user.dart → Model User untuk menyimpan data akun.
   d. user.g.dart → File auto-generated Hive adapter untuk User.

2. Folder Feature
   a. task.dart → Halaman tambah dan edit tugas (AddEditTaskPage) dengan pemilihan tanggal.

3. Folder Login
   a. login.dart → Halaman login.
   b. regis.dart → Halaman registrasi akun baru.
   c. splash_page.dart → Halaman splash screen awal.
   d. welcome.dart → Halaman sambutan sebelum login.

4. Folder Service
   a. effect.dart → Fungsi atau helper untuk UI/efek visual.
   b. people.dart → AuthService, login & register menggunakan Hive.

5. home.dart : Halaman utama daftar tugas, toggle mode warna, fitur logout, search bar, dan akses ke tambah/edit tugas.
6. main.dart : File utama Flutter, inisialisasi Hive, routing halaman, dan tema aplikasi.

## Cara Menggunakan Aplikasi To-Do-List
1. Buka aplikasi → Akan muncul splash screen 3 detik.
2. Halaman Welcome → Tekan Let's Start! untuk masuk ke login/registrasi.
3. Registrasi → Buat akun baru dengan username & password.
4. Login → Masuk menggunakan akun yang sudah dibuat.
5. Home Page →
   - Lihat daftar tugas.
   - Tandai tugas selesai dengan checkbox.
   - Cari tugas dengan search bar.
   - Klik tombol + untuk tambah tugas baru.
   - Klik tugas untuk edit.
   - Toggle mode warna untuk ganti tema.
   - Logout untuk keluar.
6. Tambah/Edit Tugas → Masukkan judul, deskripsi opsional, pilih tanggal & jam, lalu simpan.

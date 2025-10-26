import 'package:flutter/material.dart';
import 'login.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background halaman welcome
      backgroundColor: Color(0xFFfff7d1),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0), // Jarak tepi dari semua sisi
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Kolom ditengah layar
            children: [
              // Icon utama
              const Icon(
                Icons.list_alt,
                size: 80, // ukuran ikon
                color: Color(0xFF3a5a40), // warna ikon
              ),
              const SizedBox(height: 20), // Spasi vertikal antar widget

              // Judul utama
              const Text(
                'Kelola Tugas Anda dengan Mudah',
                textAlign: TextAlign.center, // teks di tengah
                style: TextStyle(
                  fontSize: 28, // ukuran font
                  fontWeight: FontWeight.bold, // tebal
                  color: Color(0xFF3a5a40), // warna teks
                ),
              ),
              const SizedBox(height: 10), // spasi vertikal

              // Deskripsi singkat
              const Text(
                'Aplikasi To-Do List yang dapat menyimpan data Anda secara aman dan persisten.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16, // ukuran font deskripsi
                  color: Color(0xFF997b66), // warna teks deskripsi
                ),
              ),
              const SizedBox(height: 50), // spasi vertikal untuk memisahkan tombol

              // Tombol "Let's Start"
              SizedBox(
                width: double.infinity, // tombol full-width
                child: ElevatedButton(
                  onPressed: () {
                    // Navigasi ke halaman Login dan menghapus riwayat halaman sebelumnya
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3a5a40), // warna latar tombol
                    padding: const EdgeInsets.symmetric(vertical: 18), // tinggi tombol
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // sudut tombol membulat
                    ),
                  ),
                  child: const Text(
                    'Let\'s Start!', // teks tombol
                    style: TextStyle(
                      fontSize: 18, // ukuran font tombol
                      color: Colors.white, // warna teks tombol
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

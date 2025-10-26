import 'package:flutter/material.dart';
import 'package:todolist/login/welcome.dart';
import 'welcome.dart'; // Import halaman tujuan (WelcomePage)

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    // Fungsi Future.delayed digunakan untuk memberi penundaan (delay) sebelum berpindah halaman
    // Di sini delay-nya 3 detik (3000 ms)
    Future.delayed(const Duration(seconds: 3), () {
      // Navigasi ke halaman WelcomePage setelah splash screen selesai
      // pushReplacement digunakan supaya user tidak bisa kembali ke SplashPage dengan tombol back
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold menyediakan struktur halaman utama
    return const Scaffold(
      // Warna background halaman splash screen
      backgroundColor: Color(0xFFfffed5),
      body: Center(
        // Column untuk menata widget secara vertikal
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Menempatkan widget di tengah layar
          children: [
            // Icon utama di splash screen
            Icon(
              Icons.task_alt, // Ikon centang tugas
              size: 150, // Ukuran ikon
              color: Color(0xFF663399), // Warna ikon
            ),
            SizedBox(height: 20), // Spasi vertikal antar widget
            // Teks judul aplikasi
            Text(
              "TO-DO LIST",
              style: TextStyle(
                color: Color(0xFF663399), // Warna teks
                fontSize: 30, // Ukuran font
                fontWeight: FontWeight.bold, // Tebal
              ),
            ),
            SizedBox(height: 50), // Spasi sebelum loading indicator
            // Loading indicator (putar-putar) untuk memberi feedback user
            CircularProgressIndicator(color: Color(0xFF663399)),
          ],
        ),
      ),
    );
  }
}

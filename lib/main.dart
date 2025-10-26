import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todolist/service/effect.dart';
import 'package:todolist/database/user.dart';
import 'package:todolist/login/splash_page.dart';
import 'package:todolist/login/welcome.dart';

import 'home.dart';
import 'login/login.dart';
import 'login/regis.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Pastikan Flutter siap sebelum async
  await HiveService.initHive(); // Inisialisasi Hive (database lokal)

  Hive.registerAdapter(UserAdapter()); // Daftarkan adapter untuk User

  // Buka semua box Hive sebelum menjalankan app
  await Hive.openBox<User>('user_box'); // Box untuk data user
  await Hive.openBox('app_settings_box'); // Box untuk data setting

  runApp(const MyApp()); // Jalankan aplikasi
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const Color customPrimaryColor = Color(0xFF001845); // Warna utama aplikasi

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true, // Aktifkan Material 3
        colorScheme: ColorScheme.fromSeed(seedColor: customPrimaryColor)
            .copyWith(primary: customPrimaryColor), // Skema warna dari seed
        appBarTheme: const AppBarTheme(
          backgroundColor: customPrimaryColor, // Warna AppBar
          foregroundColor: Color(0xFFe2eafc), // Warna teks dan ikon di AppBar
          elevation: 4.0, // Shadow AppBar
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: customPrimaryColor, // Warna tombol
            foregroundColor: Color(0xFFe2eafc), // Warna teks tombol
          ),
        ),
      ),
      initialRoute: '/splash', // Halaman awal aplikasi

      // --- onGenerateRoute untuk navigasi dinamis & kirim argumen ---
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/splash':
            return MaterialPageRoute(builder: (_) => const SplashPage()); // Splash screen
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginPage()); // Login
          case '/register':
            return MaterialPageRoute(builder: (_) => const Register()); // Registrasi
          case '/welcome':
            return MaterialPageRoute(builder: (_) => const WelcomePage()); // Welcome
          case '/home':
          // Ambil argumen username yang dikirim saat navigasi
            final args = settings.arguments as String?;
            if (args != null) {
              // Jika ada username → kirim ke HomePage
              return MaterialPageRoute(
                  builder: (_) => HomePage(username: args));
            }
            // Default username jika tidak ada argumen
            return MaterialPageRoute(
                builder: (_) => const HomePage(username: 'User'));
          default:
            return null; // Rute tidak ditemukan
        }
      },
    );
  }
}

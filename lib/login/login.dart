import 'package:flutter/material.dart';
import 'dart:ui'; // Diperlukan untuk ImageFilter.blur (efek Glassmorphism)
import 'package:todolist/service/people.dart'; // Service untuk login/register Hive

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers untuk mengambil input teks dari TextField
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State untuk loading dan visibilitas password
  bool _isLoading = false; // true saat proses login
  bool _obscurePassword = true; // true = sembunyikan password

  // Instance AuthService untuk memanggil fungsi login Hive
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    // Penting: membuang controller saat widget dihancurkan
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- Fungsi Login ---
  void _handleLogin() async {
    // Validasi input kosong
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username dan Password wajib diisi.')),
      );
      return;
    }

    setState(() => _isLoading = true); // Aktifkan indikator loading
    await _authService.init(); // Inisialisasi Hive

    // Panggil fungsi login dari AuthService
    final success = _authService.loginUser(
      _usernameController.text.trim(), // pastikan tidak ada spasi di awal/akhir
      _passwordController.text,
    );

    setState(() => _isLoading = false); // Nonaktifkan indikator loading

    if (success) {
      // Jika login berhasil → navigasi ke HomePage & kirim username sebagai argumen
      Navigator.of(context).pushReplacementNamed(
        '/home',
        arguments: _usernameController.text.trim(),
      );
    } else {
      // Jika gagal → tampilkan snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Gagal. Cek username dan password.')),
      );
    }
  }

  // --- Fungsi pembantu untuk dekorasi TextField (Glassmorphism style) ---
  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      hintText: label, // Placeholder teks
      hintStyle: const TextStyle(color: Colors.white54),
      prefixIcon: Icon(icon, color: Colors.white70), // Ikon di depan input
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(10), // Radius border saat tidak fokus
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white), // Saat fokus
        borderRadius: BorderRadius.circular(10),
      ),
      fillColor: Color(0xFFcc8160).withOpacity(0.6), // Latar input transparan
      filled: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // SingleChildScrollView agar konten bisa digulir saat keyboard muncul
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height, // Tinggi penuh layar
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Background image
              Image.asset(
                'images/list2.jpg', // Ganti sesuai path gambar
                fit: BoxFit.cover,
              ),

              // 2. Tint overlay (opsional, agar teks lebih kontras)
              Container(
                // color: Colors.black.withOpacity(0.5),
              ),

              // 3. Kotak login dengan efek blur (Glassmorphism)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20), // Border radius kotak
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Blur background
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 350), // Maksimal lebar
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Color(0xFF6798c0).withOpacity(0.5), // Transparan
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black.withOpacity(0.3)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // Ambil ruang minimum
                          children: [
                            // Judul Login
                            const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 30),

                            // TextField Username
                            TextField(
                              controller: _usernameController,
                              style: const TextStyle(color: Colors.white),
                              decoration: _buildInputDecoration('Username', Icons.person),
                            ),
                            const SizedBox(height: 20),

                            // TextField Password dengan toggle visibility
                            TextField(
                              controller: _passwordController,
                              obscureText: _obscurePassword, // Sembunyikan teks
                              style: const TextStyle(color: Colors.white),
                              decoration: _buildInputDecoration('Password', Icons.lock)
                                  .copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.white70,
                                  ),
                                  onPressed: () {
                                    // Toggle visibilitas password
                                    setState(() => _obscurePassword = !_obscurePassword);
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),

                            // Tombol Login
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleLogin, // Nonaktifkan saat loading
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF001845), // Warna tombol
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                    : const Text(
                                  'Login',
                                  style: TextStyle(fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Tombol navigasi ke halaman Register
                            TextButton(
                              onPressed: () => Navigator.of(context).pushNamed('/register'),
                              child: const Text(
                                "Don't have an account? Register",
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ],
                        ),
                      ),
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

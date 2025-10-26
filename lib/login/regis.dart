import 'package:flutter/material.dart';
import 'dart:ui'; // Diperlukan untuk efek blur (Glassmorphism)
import 'package:todolist/service/people.dart'; // Untuk AuthService registrasi

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<Register> {
  // --- STATE UNTUK PASSWORD & LOADING ---
  bool _passwordObscure = true; // Toggle visibilitas password
  bool _confirmObscure = true; // Toggle visibilitas konfirmasi password
  bool _isLoading = false; // State untuk menampilkan loading spinner saat submit

  // --- FORM KEY UNTUK VALIDASI ---
  final _formKey = GlobalKey<FormState>();

  // --- CONTROLLER UNTUK MENGAMBIL INPUT ---
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  // --- INSTANCE AUTH SERVICE UNTUK REGISTRASI ---
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    // Penting: Melepaskan memory controller saat widget dihancurkan
    _username.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  // --- VALIDATOR FIELD ---
  // Validator untuk field wajib diisi
  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Wajib Diisi' : null;

  // Validator untuk memastikan password dan konfirmasi cocok
  String? _passwordMatchValidator(String? v) {
    if (v == null || v.isEmpty) return 'Konfirmasi Password wajib diisi';
    if (v != _password.text) return 'Password tidak cocok';
    return null;
  }

  // --- LOGIKA SUBMIT REGISTRASI ---
  void _submit() async {
    // 1. Cek validasi form
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true); // Tampilkan loading spinner

      await _authService.init(); // Inisialisasi Hive
      final username = _username.text.trim();
      final password = _password.text;

      // 2. Panggil fungsi registrasi
      final success = await _authService.registerUser(username, password);

      if (mounted) {
        setState(() => _isLoading = false); // Matikan loading spinner

        if (success) {
          // 3. Registrasi berhasil → notifikasi + kembali ke login
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registrasi Berhasil! Silakan masuk (Login).'))
          );
          Navigator.of(context).pop(); // Kembali ke halaman login
        } else {
          // 4. Registrasi gagal → notifikasi username sudah dipakai
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registrasi Gagal. Username sudah digunakan.'))
          );
        }
      }
    }
  }

  // --- FUNGSION INPUT DECORATION UNTUK GLASSMORPHISM ---
  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      hintText: label, // Placeholder
      hintStyle: const TextStyle(color: Colors.white54),
      prefixIcon: Icon(icon, color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
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
      extendBodyBehindAppBar: true, // Memungkinkan body berada di belakang AppBar
      appBar: AppBar(
        title: const Text('Registrasi Akun', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent, // AppBar transparan
        elevation: 0, // Hilangkan shadow
        iconTheme: const IconThemeData(color: Colors.white), // Warna ikon AppBar
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // --- BACKGROUND IMAGE ---
          Image.asset(
            'images/list2.jpg',
            fit: BoxFit.cover,
          ),
          // --- KOTAK FORM DENGAN GLASSMORPHISM ---
          Center(
            child: SingleChildScrollView( // Agar form bisa digulir saat keyboard muncul
              padding: const EdgeInsets.all(24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Efek blur
                  child: Container(
                    width: 350,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Color(0xFF6798c0).withOpacity(0.5), // Transparan
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black.withOpacity(0.3)),
                    ),
                    child: Form(
                      key: _formKey, // Untuk validasi
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Judul Form
                          const Text(
                            'Daftar Akun Baru',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 30),

                          // --- INPUT USERNAME ---
                          TextFormField(
                            controller: _username,
                            style: const TextStyle(color: Colors.white),
                            decoration: _buildInputDecoration('Username', Icons.person),
                            validator: _required,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 15),

                          // --- INPUT PASSWORD ---
                          TextFormField(
                            controller: _password,
                            style: const TextStyle(color: Colors.white),
                            decoration: _buildInputDecoration('Password', Icons.lock).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordObscure ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.white70,
                                ),
                                onPressed: () => setState(() => _passwordObscure = !_passwordObscure),
                              ),
                            ),
                            obscureText: _passwordObscure, // Sembunyikan password
                            validator: (v) => (v == null || v.length < 6)
                                ? 'Password minimal 6 karakter'
                                : null,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 15),

                          // --- INPUT KONFIRMASI PASSWORD ---
                          TextFormField(
                            controller: _confirmPassword,
                            style: const TextStyle(color: Colors.white),
                            decoration: _buildInputDecoration('Konfirmasi Password', Icons.lock).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _confirmObscure ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.white70,
                                ),
                                onPressed: () => setState(() => _confirmObscure = !_confirmObscure),
                              ),
                            ),
                            obscureText: _confirmObscure,
                            validator: _passwordMatchValidator,
                            textInputAction: TextInputAction.done,
                          ),
                          const SizedBox(height: 30),

                          // --- TOMBOL DAFTAR ---
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _isLoading ? null : _submit, // Nonaktif saat loading
                              icon: _isLoading
                                  ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white))
                                  : const Icon(Icons.check, color: Colors.white),
                              label: Text(
                                  _isLoading ? 'Mendaftarkan...' : 'Daftar',
                                  style: const TextStyle(fontSize: 18, color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF001845),
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

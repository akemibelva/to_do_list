import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/database/user.dart';

class AuthService {
  static const String _userBox = 'user_box'; // Nama box untuk menyimpan data user
  static const String _appSettingsBox = 'app_settings_box'; // Box untuk menyimpan setting, misal login status

  late Box<User> _userBoxInstance; // Instance Hive untuk user
  late Box _appSettings; // Instance Hive untuk settings

  /// 🔹 Inisialisasi Hive box
  /// Harus dipanggil sekali sebelum menggunakan AuthService (misalnya di main.dart)
  Future<void> init() async {
    // Buka box user jika belum terbuka
    if (!Hive.isBoxOpen(_userBox)) {
      _userBoxInstance = await Hive.openBox<User>(_userBox);
    } else {
      _userBoxInstance = Hive.box<User>(_userBox);
    }

    // Buka box settings jika belum terbuka
    if (!Hive.isBoxOpen(_appSettingsBox)) {
      _appSettings = await Hive.openBox(_appSettingsBox);
    } else {
      _appSettings = Hive.box(_appSettingsBox);
    }
  }

  // --- Fungsi Authentication ---

  /// Simpan status login di box settings
  Future<void> setLoginStatus(bool isLoggedIn) async {
    await _appSettings.put('isLoggedIn', isLoggedIn);
  }

  /// Ambil status login dari box settings
  bool getLoginStatus() {
    return _appSettings.get('isLoggedIn') ?? false; // default false jika belum ada
  }

  /// Registrasi user baru
  /// Return false jika username sudah dipakai
  Future<bool> registerUser(String username, String password) async {
    // Cek apakah username sudah ada di Hive
    final existingUser =
    _userBoxInstance.values.where((user) => user.username == username);

    if (existingUser.isNotEmpty) {
      return false; // Username sudah digunakan
    }

    // Jika belum ada, buat user baru dan simpan ke Hive
    final newUser = User(username: username, password: password);
    await _userBoxInstance.add(newUser);
    return true;
  }

  /// Login user
  /// Return true jika login berhasil
  bool loginUser(String username, String password) {
    // Cari user sesuai username dan password
    final user = _userBoxInstance.values.firstWhere(
          (user) => user.username == username && user.password == password,
      orElse: () => User(username: '', password: ''), // default jika tidak ada
    );

    if (user.username.isNotEmpty) {
      setLoginStatus(true); // Set login status ke true
      return true; // Login berhasil
    }
    return false; // Login gagal
  }

  /// Logout user
  Future<void> logoutUser() async {
    await setLoginStatus(false); // Set login status ke false
  }
}

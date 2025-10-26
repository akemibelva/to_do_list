import 'package:hive_flutter/hive_flutter.dart';
import '../database/model.dart';

class HiveService {
  static const String _boxName = 'tasks_box'; // Nama box untuk menyimpan task

  /// Inisialisasi Hive
  /// Harus dipanggil sekali sebelum menggunakan HiveService
  static Future<void> initHive() async {
    await Hive.initFlutter(); // Inisialisasi Hive untuk Flutter
    // Daftarkan adapter Task jika belum terdaftar
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskAdapter());
    }
    // Buka box task
    await Hive.openBox<Task>(_boxName);
  }

  // Property untuk akses box task
  Box<Task> get _taskBox => Hive.box<Task>(_boxName);

  // Ambil semua task dari Hive
  List<Task> getAllTasks() {
    return _taskBox.values.toList(); // Mengembalikan list task
  }

  // Tambah task baru ke Hive
  Future<void> addTask(Task task) async {
    await _taskBox.add(task); // Menambahkan task ke box
  }

  // Update status task (selesai/belum selesai)
  Future<void> updateTaskStatus(Task task) async {
    task.isCompleted = !task.isCompleted; // Toggle status isCompleted
    await task.save(); // Simpan perubahan ke Hive
  }

  // Hapus task dari Hive
  Future<void> deleteTask(Task task) async {
    await task.delete(); // Menghapus task dari box
  }
}

import 'package:hive/hive.dart';
part 'model.g.dart'; // Diperlukan untuk kode generator Hive (adapter)

//  Definisi model Task untuk Hive
@HiveType(typeId: 0) // typeId harus unik untuk tiap model Hive agar tidak bentrok
class Task extends HiveObject {
  @HiveField(0)
  late String title; // Judul tugas, wajib diisi

  @HiveField(1)
  late String description; // Deskripsi tugas (opsional), default kosong

  @HiveField(2)
  late bool isCompleted; // Status tugas: true = selesai, false = belum

  @HiveField(3)
  late DateTime createdAt; // Waktu pembuatan task, otomatis dicatat saat tambah task

  @HiveField(4)
  late DateTime dueDate; // Tanggal & waktu jatuh tempo task

  // Konstruktor untuk membuat instance Task
  Task({
    required this.title, // Judul wajib
    this.description = '', // Jika tidak diisi, default ''
    this.isCompleted = false, // Default belum selesai
    required this.createdAt, // Wajib diisi
    required this.dueDate, // Wajib diisi
  });
}

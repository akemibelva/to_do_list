import 'package:flutter/material.dart';
import '../service/effect.dart';
import '../database/model.dart';
import 'package:todolist/home.dart';
import 'package:intl/intl.dart';

class AddEditTaskPage extends StatefulWidget {
  final Task? task; // Jika task tidak null, berarti mode edit
  final AppColorMode colorMode; // Mode warna dari HomePage (standard/vibrant)

  const AddEditTaskPage({super.key, this.task, required this.colorMode});

  @override
  State<AddEditTaskPage> createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  final _formKey = GlobalKey<FormState>(); // Key untuk validasi form
  final TextEditingController _titleController = TextEditingController(); // Controller untuk judul tugas
  final TextEditingController _descController = TextEditingController(); // Controller untuk deskripsi tugas
  final HiveService _hiveService = HiveService(); // Instance HiveService untuk CRUD task

  bool get isEditing => widget.task != null; // Cek apakah mode edit atau tambah baru
  DateTime _selectedDate = DateTime.now(); // Default tanggal jatuh tempo sekarang

  @override
  void initState() {
    super.initState();
    // Jika edit, isi field dengan data task yang ada
    if (isEditing) {
      _titleController.text = widget.task!.title;
      _descController.text = widget.task!.description;
      _selectedDate = widget.task!.dueDate;
    }
  }

  // Fungsi untuk menentukan warna background berdasarkan mode warna
  Color _getBackgroundColor() => widget.colorMode == AppColorMode.vibrant ? Color(0xFFe8fccf) : Color(0xFFfdf0d5);
  // Fungsi untuk warna AppBar
  Color _getAppBarColor() => widget.colorMode == AppColorMode.vibrant ? Color(0xFFffcad4) : Color(0xFFbb9457);
  // Fungsi untuk warna tombol
  Color _getButtonColor() => _getAppBarColor();

  // Fungsi memilih tanggal dan waktu jatuh tempo
  Future<void> _selectDateTime(BuildContext context) async {
    // Pilih tanggal
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)), // Minimal 1 tahun sebelumnya
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)), // Maksimal 5 tahun ke depan
      builder: (context, child) {
        // Custom tema untuk date picker
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _getAppBarColor(),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      // Pilih waktu setelah memilih tanggal
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
        builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _getButtonColor(),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        ),
      );

      if (time != null) {
        // Gabungkan tanggal dan waktu menjadi DateTime penuh
        setState(() {
          _selectedDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        });
      }
    }
  }

  // Fungsi simpan atau update task
  void _saveTask() async {
    if (_formKey.currentState!.validate()) { // Validasi form
      _formKey.currentState!.save();

      if (isEditing) {
        // Jika edit, update task yang ada
        widget.task!.title = _titleController.text;
        widget.task!.description = _descController.text;
        widget.task!.dueDate = _selectedDate;
        await widget.task!.save(); // Simpan perubahan ke Hive
        _showSnackbar('Tugas berhasil diubah', Colors.blue);
      } else {
        // Jika tambah baru, buat task baru
        final newTask = Task(
          title: _titleController.text,
          description: _descController.text,
          createdAt: DateTime.now(),
          dueDate: _selectedDate,
          isCompleted: false,
        );
        await _hiveService.addTask(newTask); // Tambahkan task ke Hive
        _showSnackbar('Tugas berhasil ditambahkan', Colors.green);
      }

      Navigator.pop(context); // Kembali ke halaman sebelumnya (HomePage)
    }
  }

  // Fungsi menampilkan Snackbar
  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('EEEE, dd MMM yyyy HH:mm').format(_selectedDate); // Format tanggal jatuh tempo

    return Scaffold(
      backgroundColor: _getBackgroundColor(),
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Tugas' : 'Tambah Tugas Baru'),
        backgroundColor: _getAppBarColor(),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Form untuk validasi
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Field Judul
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Judul Tugas',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: _getButtonColor(), width: 2), borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Judul tidak boleh kosong' : null, // Validasi wajib diisi
              ),
              const SizedBox(height: 16),

              // Field Deskripsi (Opsional)
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(
                  labelText: 'Deskripsi (Opsional)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: _getButtonColor(), width: 2), borderRadius: BorderRadius.circular(8)),
                ),
                maxLines: 3, // Bisa menulis beberapa baris
              ),
              const SizedBox(height: 20),

              // Pilih tanggal dan waktu jatuh tempo
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Jatuh Tempo: $formattedDate", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ElevatedButton.icon(
                    onPressed: () => _selectDateTime(context), // Memanggil fungsi select date & time
                    style: ElevatedButton.styleFrom(backgroundColor: _getButtonColor(), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('PILIH WAKTU'),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Tombol simpan
              ElevatedButton(
                onPressed: _saveTask, // Memanggil fungsi simpan
                style: ElevatedButton.styleFrom(backgroundColor: _getButtonColor(), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: Text(isEditing ? 'Simpan Perubahan' : 'Tambah Tugas', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Buang controller untuk mencegah memory leak
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }
}

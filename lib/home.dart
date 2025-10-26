import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../database/model.dart';
import '../service/effect.dart';
import 'package:todolist/feature/task.dart';
import 'package:intl/intl.dart';
import 'package:todolist/database/user.dart';

// Enum untuk mode warna: standard atau vibrant
enum AppColorMode { standard, vibrant }

class HomePage extends StatefulWidget {
  final String username; // Nama user yang login
  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HiveService _hiveService = HiveService(); // Service untuk CRUD Hive

  AppColorMode _colorMode = AppColorMode.standard; // Mode warna default
  final TextEditingController _searchController = TextEditingController(); // Controller input search
  String _searchQuery = ''; // String untuk filter task

  // Fungsi toggle mode warna
  void _toggleColorMode() {
    setState(() {
      _colorMode = _colorMode == AppColorMode.standard
          ? AppColorMode.vibrant
          : AppColorMode.standard;
    });

    // Tampilkan Snackbar sebagai feedback perubahan mode warna
    _showSnackbar(
      _colorMode == AppColorMode.vibrant
          ? 'Mode Warna: Cerah Diterapkan ✨'
          : 'Mode Warna: Standar Diterapkan ⚙️',
      Colors.green,
    );
  }

  // Fungsi helper untuk menampilkan Snackbar
  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message),
          backgroundColor: color,
          duration: const Duration(seconds: 2)),
    );
  }

  // Warna background sesuai mode warna
  Color _getBackgroundColor() =>
      _colorMode == AppColorMode.vibrant ? Color(0xFFe8fccf) : Color(0xFFfdf0d5);

  // Warna AppBar sesuai mode warna
  Color _getAppBarColor() =>
      _colorMode == AppColorMode.vibrant ? Color(0xFFffcad4) : Color(0xFFbb9457);

  @override
  Widget build(BuildContext context) {
    // Gunakan ValueListenableBuilder agar UI otomatis update saat data Hive berubah
    return ValueListenableBuilder(
      valueListenable: Hive.box<Task>('tasks_box').listenable(),
      builder: (context, box, _) {
        // Ambil semua task dari Hive dan urutkan
        final allTasks = _hiveService.getAllTasks()
          ..sort((a, b) => a.isCompleted ? 1 : -1);

        // Filter task berdasarkan search query
        final filteredTasks = allTasks
            .where((task) => task.title.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

        return Scaffold(
          backgroundColor: _getBackgroundColor(),
          appBar: AppBar(
            title: const Text('To-Do List 📝'),
            backgroundColor: _getAppBarColor(),
            foregroundColor: Colors.white,
            actions: [
              // Tombol toggle mode warna
              IconButton(
                icon: Icon(
                  _colorMode == AppColorMode.standard
                      ? Icons.color_lens_outlined
                      : Icons.color_lens,
                ),
                onPressed: _toggleColorMode,
                tooltip: 'Ganti Mode Warna',
              ),
              // Tombol logout
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Logout',
                onPressed: () async {
                  // Hapus data user dari Hive
                  final userBox = Hive.box<User>('user_box');
                  await userBox.clear();

                  // Navigasi ke halaman login dan hapus semua rute sebelumnya
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false);
                },
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tampilan welcome user
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  "Welcome, ${widget.username} 👋",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _getAppBarColor()),
                ),
              ),
              // Input search task
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Cari judul tugas...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: _getAppBarColor(), width: 2)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Daftar task
              Expanded(
                child: filteredTasks.isEmpty
                    ? Center(
                  child: Text(
                    allTasks.isEmpty
                        ? 'Tidak ada tugas. Tambahkan satu!'
                        : 'Tidak ditemukan hasil untuk "$_searchQuery"',
                    style: const TextStyle(fontSize: 16),
                  ),
                )
                    : ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    final formattedDate = DateFormat(
                        'EEEE, dd MMM yyyy HH:mm')
                        .format(task.dueDate);
                    final isOverdue =
                        !task.isCompleted &&
                            task.dueDate.isBefore(DateTime.now());

                    return Card(
                      color: isOverdue
                          ? Colors.red.shade100
                          : (_colorMode == AppColorMode.vibrant
                          ? Colors.lightGreen.shade50
                          : Colors.white),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      child: ListTile(
                        title: Text(
                          task.title,
                          style: TextStyle(
                            color: isOverdue
                                ? Colors.red.shade800
                                : Colors.black,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "Jatuh Tempo: $formattedDate ${isOverdue ? ' (TERLAMBAT!)' : ''}\n${task.description}",
                          style: TextStyle(
                              color: (isOverdue
                                  ? Colors.red.shade800
                                  : Colors.black)
                                  .withOpacity(0.8)),
                        ),
                        // Checkbox status selesai
                        leading: Checkbox(
                          value: task.isCompleted,
                          onChanged: (bool? newValue) async {
                            await _hiveService.updateTaskStatus(task);
                            _showSnackbar(
                              task.isCompleted
                                  ? 'Tugas diselesaikan 🎉'
                                  : 'Tugas dibuka kembali',
                              task.isCompleted
                                  ? Colors.blue
                                  : Colors.orange,
                            );
                          },
                        ),
                        // Tombol hapus task
                        trailing: IconButton(
                          icon: Icon(Icons.delete,
                              color: isOverdue
                                  ? Colors.red.shade400
                                  : Colors.grey),
                          onPressed: () async {
                            await _hiveService.deleteTask(task);
                            _showSnackbar(
                                'Tugas "${task.title}" dihapus',
                                Colors.red);
                          },
                        ),
                        // Tap untuk edit task
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AddEditTaskPage(
                                        task: task,
                                        colorMode: _colorMode)),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          // Tombol tambah task baru
          floatingActionButton: FloatingActionButton(
            backgroundColor: _getAppBarColor(),
            foregroundColor: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AddEditTaskPage(colorMode: _colorMode)),
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose search controller
    super.dispose();
  }
}

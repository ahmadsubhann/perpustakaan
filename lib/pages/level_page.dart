import 'package:flutter/material.dart';

class LevelPage extends StatelessWidget {
  const LevelPage({super.key});

  // Fungsi bantu untuk menentukan warna berdasarkan level
  Color _getLevelColor(int level) {
    switch (level) {
      case 1:
        return Colors.grey;
      case 2:
        return Colors.blueAccent;
      case 3:
        return Colors.purpleAccent;
      case 4:
        return Colors.orangeAccent;
      case 5:
        return Colors.amberAccent;
      default:
        return Colors.white;
    }
  }

  // Fungsi bantu untuk membuat tampilan satu level
  Widget _buildLevelCard(int level, double progress) {
    return Card(
      color: const Color(0xFF1A103F),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Menampilkan diamond sesuai level
                Row(
                  children: List.generate(
                    level,
                    (index) => const Icon(
                      Icons.diamond,
                      color: Colors.amberAccent,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "Level $level",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _getLevelColor(level),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white24,
              color: _getLevelColor(level),
              minHeight: 10,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 8),
            Text(
              "${(progress * 100).toStringAsFixed(0)}% menuju level berikutnya",
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0829),
      appBar: AppBar(
        title: const Text("Level / VIP"),
        backgroundColor: const Color(0xFF1A103F),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          const Center(
            child: Text(
              "Status VIP & Level Pengguna",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Contoh: 5 Level dengan progress berbeda
          _buildLevelCard(1, 1.0),
          _buildLevelCard(2, 0.8),
          _buildLevelCard(3, 0.5),
          _buildLevelCard(4, 0.3),
          _buildLevelCard(5, 0.1),

          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Tingkatkan level Anda untuk mendapatkan lebih banyak bonus, cashback, dan hak istimewa VIP!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

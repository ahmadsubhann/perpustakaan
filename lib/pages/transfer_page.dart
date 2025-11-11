import 'package:flutter/material.dart';

class TransferPage extends StatelessWidget {
  const TransferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transfer")),
      body: const Center(
        child: Text("Ini halaman Transfer", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class DepositPage extends StatelessWidget {
  const DepositPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0829),
      appBar: AppBar(
        title: const Text("Deposit"),
        backgroundColor: const Color(0xFF1A103F),
      ),
      body: const Center(
        child: Text(
          "Halaman Deposit — Tambahkan saldo ke akun Anda",
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

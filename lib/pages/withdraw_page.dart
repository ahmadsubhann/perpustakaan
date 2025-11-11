import 'package:flutter/material.dart';

class WithdrawPage extends StatelessWidget {
  const WithdrawPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0829),
      appBar: AppBar(
        title: const Text("Withdraw"),
        backgroundColor: const Color(0xFF1A103F),
      ),
      body: const Center(
        child: Text(
          "Halaman Withdraw — Tarik saldo dari akun Anda",
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

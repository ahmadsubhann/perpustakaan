import 'package:flutter/material.dart';
import 'register_page.dart';
import 'login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0829),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔷 Logo Jaringan
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                      center: Alignment.center,
                      radius: 0.9,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purpleAccent.withOpacity(0.6),
                        blurRadius: 30,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                  child: CustomPaint(painter: _NetworkPainter()),
                ),
                const Text(
                  "S",
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              "Nebula X",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Future of Digital Trading",
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 60),

            // 🔘 Tombol Register
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purpleAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                );
              },
              child: const Text(
                "Buat Akun",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            // 🔘 Tombol Login
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.purpleAccent),
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
              child: const Text(
                "Masuk Akun",
                style: TextStyle(
                  color: Colors.purpleAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NetworkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1.2;
    final paintDot = Paint()
      ..color = Colors.purpleAccent
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    final points = List.generate(
      6,
      (i) => Offset(
        center.dx + radius * (i.isEven ? 1 : -1) * 0.7 * (i / 5),
        center.dy + radius * (i.isOdd ? 1 : -1) * 0.7 * (1 - i / 6),
      ),
    );

    for (var i = 0; i < points.length; i++) {
      for (var j = i + 1; j < points.length; j++) {
        canvas.drawLine(points[i], points[j], paintLine);
      }
    }

    for (var p in points) {
      canvas.drawCircle(p, 3, paintDot);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

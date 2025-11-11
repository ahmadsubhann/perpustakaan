import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'detail_page.dart';
import 'deposit_page.dart';
import 'withdraw_page.dart';
import 'level_page.dart';
import 'transfer_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<dynamic> _coins = [];

  @override
  void initState() {
    super.initState();
    fetchCoins();
  }

  Future<void> fetchCoins() async {
    final url =
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        _coins = json.decode(response.body);
      });
    } else {
      debugPrint('Gagal memuat data: ${response.statusCode}');
    }
  }

  // ===================== WIDGET PARTNERS =====================
  Widget _buildPartners() {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 24),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A103F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            "🤝 Mitra Resmi",
            style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _partnerLogo(
                  name: "Binance",
                  logoUrl:
                      "https://assets.coingecko.com/coins/images/825/large/binance-coin-logo.png",
                  url: "https://www.binance.com",
                ),
                const SizedBox(width: 20),
                _partnerLogo(
                  name: "KuCoin",
                  logoUrl:
                      "https://assets.coingecko.com/coins/images/1047/large/kucoin.png",
                  url: "https://www.kucoin.com",
                ),
                const SizedBox(width: 20),
                _partnerLogo(
                  name: "OKX",
                  logoUrl:
                      "https://assets.coingecko.com/coins/images/4463/large/okx.png",
                  url: "https://www.okx.com",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _partnerLogo({
    required String name,
    required String logoUrl,
    required String url,
  }) {
    return GestureDetector(
      onTap: () => _openWeb(url),
      child: Column(
        children: [
          Image.network(
            logoUrl,
            width: 40,
            height: 40,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.broken_image,
              color: Colors.white54,
              size: 40,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: const TextStyle(color: Colors.purpleAccent, fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _openWeb(String url) async {
    final uri = Uri.parse(url);
    if (await launcher.canLaunchUrl(uri)) {
      await launcher.launchUrl(uri, mode: launcher.LaunchMode.externalApplication);
    }
  }

  // ===================== HALAMAN BERANDA =====================
  Widget _buildMarketPage() {
    return Column(
      children: [
        Expanded(
          child: _coins.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _coins.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _coins.length) {
                      return _buildPartners();
                    }

                    final coin = _coins[index];
                    final change = coin['price_change_percentage_24h'];
                    final bool isUp = (change ?? 0) > 0;

                    String changeText;
                    if (change == null ||
                        (change is num && (change.isNaN || change.isInfinite))) {
                      changeText = "-";
                    } else {
                      changeText = "${change.toStringAsFixed(2)}%";
                    }

                    return Card(
                      color: const Color(0xFF1A103F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Image.network(
                          coin['image'],
                          width: 36,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.currency_bitcoin,
                                  color: Colors.white70),
                        ),
                        title: Text(
                          coin['symbol'].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "\$${coin['current_price']}",
                          style: const TextStyle(color: Colors.white70),
                        ),
                        trailing: Text(
                          changeText,
                          style: TextStyle(
                            color: isUp ? Colors.greenAccent : Colors.redAccent,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailPage(
                                coinId: coin['id'],
                                coinName: coin['name'],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ===================== HALAMAN PERDAGANGAN =====================
  Widget _buildTradePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Saldo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Saldo Kamu",
                    style: TextStyle(color: Colors.white70, fontSize: 16)),
                SizedBox(height: 6),
                Text(
                  "\$ 5,320.75",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Tombol Aksi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTradeButton(Icons.account_balance_wallet, "Deposit", const DepositPage()),
               _buildTradeButton(Icons.credit_card, "Withdraw", const WithdrawPage()),
              _buildTradeButton(Icons.workspace_premium, "Level / VIP", const LevelPage()),
              _buildTradeButton(Icons.swap_horiz, "Transfer", const TransferPage()),
            ],
          ),

          const SizedBox(height: 40),
          const Text("📈 Fitur peningkatan sedang dikembangkan...",
              style: TextStyle(color: Colors.white54)),
        ],
      ),
    );
  }

  Widget _buildTradeButton(IconData icon, String label, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1A103F),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.purpleAccent, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 13)),
        ],
      ),
    );
  }

  // ===================== HALAMAN LAIN =====================
  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildMarketPage();
      case 1:
        return _buildTradePage();
      case 2:
        return const Center(
            child: Text("💸 Transfer Coming Soon",
                style: TextStyle(color: Colors.white)));
      case 3:
        return const Center(
            child: Text("👤 Akun Coming Soon",
                style: TextStyle(color: Colors.white)));
      default:
        return _buildMarketPage();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0829),
      appBar: AppBar(
        title: const Text("USDT Pasar"),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A103F),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1A103F),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.purpleAccent,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Perdagangan'),
          BottomNavigationBarItem(
              icon: Icon(Icons.swap_horiz), label: 'Transfer'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
      ),
    );
  }
}

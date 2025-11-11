import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:candlesticks/candlesticks.dart';

class DetailPage extends StatefulWidget {
  final String coinId;
  final String coinName;

  const DetailPage({
    Key? key,
    required this.coinId,
    required this.coinName,
  }) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<Candle> _candles = [];
  bool _isLoading = true;
  bool _hasError = false;
  double? _currentPrice;

  @override
  void initState() {
    super.initState();
    fetchCandles();
    fetchCurrentPrice();
  }

  Future<void> fetchCandles() async {
    try {
      final url =
          'https://api.coingecko.com/api/v3/coins/${widget.coinId}/ohlc?vs_currency=usd&days=7';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);

        // 🧹 Filter candle invalid
        final validData = data.where((candle) {
          final open = candle[1]?.toDouble() ?? 0;
          final high = candle[2]?.toDouble() ?? 0;
          final low = candle[3]?.toDouble() ?? 0;
          final close = candle[4]?.toDouble() ?? 0;
          return open > 0 && high > 0 && low > 0 && close > 0;
        }).toList();

        setState(() {
          _candles = validData.map((c) {
            return Candle(
              date: DateTime.fromMillisecondsSinceEpoch(c[0]),
              open: c[1].toDouble(),
              high: c[2].toDouble(),
              low: c[3].toDouble(),
              close: c[4].toDouble(),
              volume: 0,
            );
          }).toList();
          _isLoading = false;
        });
      } else {
        setState(() => _hasError = true);
      }
    } catch (e) {
      setState(() => _hasError = true);
    }
  }

  Future<void> fetchCurrentPrice() async {
    try {
      final url =
          'https://api.coingecko.com/api/v3/simple/price?ids=${widget.coinId}&vs_currencies=usd';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _currentPrice = data[widget.coinId]['usd']?.toDouble();
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0829),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A103F),
        title: Text(widget.coinName,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.purpleAccent))
          : _hasError || _candles.isEmpty
              ? const Center(
                  child: Text(
                    "⚠️ Gagal memuat grafik atau data tidak tersedia.",
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                )
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      color: const Color(0xFF1A103F),
                      width: double.infinity,
                      child: Column(
                        children: [
                          Text(
                            widget.coinName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _currentPrice != null
                                ? "\$${_currentPrice!.toStringAsFixed(2)}"
                                : "Memuat harga...",
                            style: const TextStyle(
                                color: Colors.purpleAccent, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Theme(
                        data: ThemeData.dark().copyWith(
                          scaffoldBackgroundColor: const Color(0xFF0F0829),
                          cardColor: const Color(0xFF1A103F),
                          colorScheme: const ColorScheme.dark(
                            primary: Colors.greenAccent,
                            secondary: Colors.redAccent,
                          ),
                        ),
                        child: Candlesticks(
                          candles: _candles,
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}

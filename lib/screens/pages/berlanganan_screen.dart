import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projek_akhir_mobile/services/konversi_network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BerlangananScreen extends StatefulWidget {
  const BerlangananScreen({super.key});

  @override
  State<BerlangananScreen> createState() => _BerlangananScreenState();
}

class _BerlangananScreenState extends State<BerlangananScreen> {
  final TextEditingController dompetController = TextEditingController();
  final TextEditingController konversiController = TextEditingController();

  String _mataUangKonversi = "USD";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    cekSession();
    _cekPembayaran();
  }

  Future<void> cekSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionToken = prefs.getString('session_token');
    String? username = prefs.getString('username');

    if (sessionToken == null || username == null) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  Future<void> _cekPembayaran() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? userList = prefs.getStringList('user_list');

    if (userList == null || userList.isEmpty) {
      _navigateToLogin();
      return;
    }

    final String? usernameSession = prefs.getString('username');

    if (usernameSession == null || usernameSession.isEmpty) {
      _navigateToLogin();
      return;
    }

    final String? userString = userList.firstWhere((element) {
      try {
        final Map<String, dynamic> userMap = jsonDecode(element);
        return userMap['username'] == usernameSession;
      } catch (_) {
        return false;
      }
    }, orElse: () => '');

    if (userString == null || userString.isEmpty) {
      _navigateToLogin();
      return;
    }

    try {
      final Map<String, dynamic> dataUser = jsonDecode(userString);
      if (dataUser['sudah_bayar'] == true) {
        Navigator.pushReplacementNamed(context, '/jadwal');
      }
    } catch (e) {
      debugPrint('Error parsing user data: $e');
    }
  }

  void _navigateToLogin() {
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> konversi() async {
    final text = dompetController.text;
    if (text.isEmpty) {
      setState(() => konversiController.text = '');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await CurrencyService().fetchCurrencyRates();
      final rate = result.data.rates[_mataUangKonversi]?.value;
      if (rate != null) {
        final converted = double.parse(text) * rate;
        konversiController.text = converted.toStringAsFixed(5);
      } else {
        konversiController.text = 'Rate tidak tersedia';
      }
    } catch (e) {
      konversiController.text = 'Error konversi';
      debugPrint('Error fetchCurrencyRates: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _bayarBerlanganan() async {
    final uangPalsuText = dompetController.text;
    if (uangPalsuText.isEmpty) {
      _showSnackBar("Masukkan jumlah uang terlebih dahulu");
      return;
    }

    final uangPalsu = int.tryParse(uangPalsuText);
    if (uangPalsu == null) {
      _showSnackBar("Jumlah uang tidak valid");
      return;
    }

    const hargaBerlanganan = 100000;
    if (uangPalsu < hargaBerlanganan) {
      _showSnackBar("Uang anda kurang, tambahkan lagi uang palsu anda");
      return;
    }

    _showSnackBar("Berlanganan berhasil");

    final prefs = await SharedPreferences.getInstance();
    final List<String>? userList = prefs.getStringList('user_list');
    if (userList != null) {
      final usernameSession = prefs.getString('username');
      for (final userString in userList) {
        final dataUser = jsonDecode(userString);
        if (dataUser['username'] == usernameSession) {
          dataUser['sudah_bayar'] = true;
          dataUser['waktu_bayar'] = DateTime.now().toIso8601String();
          final index = userList.indexOf(userString);
          userList[index] = jsonEncode(dataUser);
          await prefs.setStringList('user_list', userList);
          break;
        }
      }
    }

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/jadwal');
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.blue.shade400,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    dompetController.dispose();
    konversiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text("Berlanganan"), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Berlanganan Page",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Dengan berlanganan dapat fitur: Akses selamanya",
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 6),
              Text(
                "Harga untuk membeli berlanganan: Rp. 100.000 /bulan",
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: theme.colorScheme.secondary,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Dompet Palsu mu, silahkan bayar untuk membeli berlanganan",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    "IDR:",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: dompetController,
                      decoration: InputDecoration(
                        hintText: "Masukkan jumlah dalam IDR",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Fitur kami untuk mencoba konversi mata uang untuk pembayaranmu",
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    "Pilih Mata Uang:",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.colorScheme.primary),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButton<String>(
                        value: _mataUangKonversi,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                        underline: const SizedBox(),
                        onChanged: (String? newValue) async {
                          if (newValue == null) return;
                          setState(() {
                            _mataUangKonversi = newValue;
                          });
                          if (dompetController.text.isNotEmpty) {
                            await konversi();
                          }
                        },
                        items:
                            <String>[
                              'USD',
                              'BTC',
                              'CNY',
                              'EUR',
                              'JPY',
                              'SGD',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    "Hasil Konversi:",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: konversiController,
                      decoration: InputDecoration(
                        hintText: "Hasil konversi mata uang",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      readOnly: true,
                    ),
                  ),
                  if (_isLoading) ...[
                    const SizedBox(width: 10),
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 32),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _bayarBerlanganan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(fontSize: 14),
                    ),
                    child: const Text(
                      "Berlanganan",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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

  @override
  void initState() {
    super.initState();
  }

  Future<void> _cekPembayaran() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? userList = prefs.getStringList('user_list');

    if (userList == null || userList.isEmpty) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    final String? usernameSession = prefs.getString('username');

    if (usernameSession == null || usernameSession.isEmpty) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    final String? userString = userList.firstWhere((element) {
      try {
        final Map<String, dynamic> userMap = jsonDecode(element);
        return userMap['username'] == usernameSession;
      } catch (e) {
        return false;
      }
    }, orElse: () => '');

    if (userString == null || userString.isEmpty) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    try {
      final Map<String, dynamic> dataUser = jsonDecode(userString);
      if (dataUser['sudah_bayar'] == true) {
        Navigator.pushReplacementNamed(context, '/jadwal');
      } else {
        Navigator.pushReplacementNamed(context, '/berlanganan');
      }
    } catch (e) {
      print('Error parsing user data: $e');
    }
  }

  Future<void> konversi() async {
    final text = dompetController.text;
    if (text.isEmpty) {
      konversiController.text = '';
      return;
    }

    final result = await CurrencyService().fetchCurrencyRates();
    final rate = result.data.rates[_mataUangKonversi]?.value;
    if (rate != null) {
      konversiController.text = (double.parse(text) * rate).toStringAsFixed(5);
    }
  }

  Future<void> _bayarBerlanganan() async {
    final int uangPalsu = int.parse(dompetController.text);
    final int hargaBerlanganan = 100000;
    if (uangPalsu < hargaBerlanganan) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Uang anda kurang, tambahkan lagi uang palsu anda"),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Berlanganan berhasil")));

      // Update Data
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

      // Pindah Halaman
      Navigator.pushReplacementNamed(context, '/jadwal');
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
    return Scaffold(
      appBar: AppBar(title: const Text("Berlanganan Page")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Berlanganan Page",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text("Dengan berlanganan dapat fitur : Akses selamanya"),
              const SizedBox(height: 6),
              const Text("Harga untuk membeli berlanganan : Rp. 100.000"),
              const SizedBox(height: 24),
              const Text(
                "Dompet Palsu mu, silahkan bayar untuk membeli berlanganan",
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  const Text("IDR : "),
                  Flexible(
                    child: TextFormField(
                      controller: dompetController,
                      decoration: const InputDecoration(
                        hintText: "Masukkan jumlah dalam IDR",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const Text(
                "Fitur Kami untuk mencoba konversi mata uang untuk pembayaranmu",
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  const Text("Pilih Mata Uang: "),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButton<String>(
                      value: _mataUangKonversi,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String? newValue) async {
                        if (newValue == null) return;
                        setState(() {
                          _mataUangKonversi = newValue;
                        });
                        final text = dompetController.text;
                        if (text.isNotEmpty) {
                          final result =
                              await CurrencyService().fetchCurrencyRates();
                          final rate =
                              result.data.rates[_mataUangKonversi]?.value;
                          if (rate != null) {
                            konversiController.text =
                                (double.parse(text) * rate).toStringAsFixed(2);
                          }
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
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text("Hasil Konversi: "),
                  Flexible(
                    child: TextFormField(
                      controller: konversiController,
                      decoration: const InputDecoration(
                        hintText: "Hasil konversi USD",
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Center(
                child: ElevatedButton(
                  onPressed: () => konversi(),
                  child: const Text("Komversi"),
                ),
              ),

              const SizedBox(height: 24),

              Center(
                child: ElevatedButton(
                  onPressed: () => _bayarBerlanganan(),
                  child: const Text("Berlanganan"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

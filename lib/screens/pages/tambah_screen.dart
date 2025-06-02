import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projek_akhir_mobile/models/hafalan_model.dart';
import 'package:projek_akhir_mobile/services/hafalan_save.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TambahScreen extends StatefulWidget {
  const TambahScreen({super.key});

  @override
  State<TambahScreen> createState() => _TambahScreenState();
}

class _TambahScreenState extends State<TambahScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaSuratController = TextEditingController();
  final _tanggalMulaiController = TextEditingController();
  final _tanggalSelesaiController = TextEditingController();

  String? _namaSurat;
  String? _tipeHafalan;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    cekSession();

    _tanggalMulaiController.text = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime.now());
  }

  Future<void> cekSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionToken = prefs.getString('session_token');
    String? username = prefs.getString('username');

    if (sessionToken == null || username == null) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && _namaSurat == null) {
      _namaSurat = args['nama'];
      _tipeHafalan = args['tipe'];
      _namaSuratController.text = _namaSurat.toString();
    }
  }

  @override
  void dispose() {
    _namaSuratController.dispose();
    _tanggalMulaiController.dispose();
    _tanggalSelesaiController.dispose();
    super.dispose();
  }

  Future<void> _pickTanggalSelesai() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate:
          DateTime.tryParse(_tanggalSelesaiController.text) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      _tanggalSelesaiController.text = DateFormat(
        'yyyy-MM-dd',
      ).format(pickedDate);
      setState(() {});
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final hafalanList = await HafalanSave().getHafalan();
      final newId = hafalanList.isNotEmpty ? hafalanList.last.id + 1 : 1;
      Hafalan newHafalan = Hafalan(
        id: newId,
        idHafalan: newId, // Since nomor surat dihapus, pakai id baru
        namaHafalan: _namaSuratController.text,
        tipeHafalan: _tipeHafalan ?? 'noData',
        tanggalMulai: _tanggalMulaiController.text,
        tanggalSelesai: _tanggalSelesaiController.text,
      );

      final success = await HafalanSave().addHafalan(newHafalan);

      if (success) {
        Navigator.pop(context);
      } else {
        setState(() {
          _error = 'Gagal tambah data';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Gagal tambah data';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Hafalan'),
        centerTitle: true,
        elevation: 2,
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator(color: primaryColor))
              : SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul
                      Text(
                        'Masukkan Detail Hafalan',
                        style: TextStyle(fontSize: 22, color: primaryColor),
                      ),
                      SizedBox(height: 24),

                      // Nama Surat
                      TextFormField(
                        controller: _namaSuratController,
                        decoration: InputDecoration(
                          labelText: 'Nama Surat',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(
                            Icons.menu_book_outlined,
                            color: primaryColor,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Nama surat wajib diisi';
                          return null;
                        },
                      ),

                      SizedBox(height: 20),

                      // Tanggal Mulai (readonly)
                      TextFormField(
                        controller: _tanggalMulaiController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Tanggal Mulai',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(
                            Icons.date_range,
                            color: primaryColor,
                          ),
                        ),
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate:
                                DateTime.tryParse(
                                  _tanggalMulaiController.text,
                                ) ??
                                DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            _tanggalMulaiController.text = DateFormat(
                              'yyyy-MM-dd',
                            ).format(picked);
                            setState(() {});
                          }
                        },
                      ),

                      SizedBox(height: 20),

                      // Tanggal Selesai (bisa pilih via date picker)
                      TextFormField(
                        controller: _tanggalSelesaiController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Tanggal Selesai',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(
                            Icons.date_range,
                            color: primaryColor,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.calendar_today,
                              color: primaryColor,
                            ),
                            onPressed: _pickTanggalSelesai,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Tanggal selesai wajib diisi';
                          return null;
                        },
                      ),

                      SizedBox(height: 30),

                      if (_error != null) ...[
                        Center(
                          child: Text(
                            _error!,
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child:
                              _isLoading
                                  ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                  : Text(
                                    'Simpan Hafalan',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
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

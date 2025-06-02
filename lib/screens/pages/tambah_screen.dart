import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projek_akhir_mobile/models/hafalan_model.dart';
import 'package:projek_akhir_mobile/services/hafalan_save.dart';

class TambahScreen extends StatefulWidget {
  const TambahScreen({super.key});

  @override
  State<TambahScreen> createState() => _TambahScreenState();
}

class _TambahScreenState extends State<TambahScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomorSuratController = TextEditingController();
  final _namaSuratController = TextEditingController();
  final _tanggalMulaiController = TextEditingController();
  final _tanggalSelesaiController = TextEditingController();
  int? _nomorSurat;
  String? _namaSurat;
  String? _tipeHafalan;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tanggalMulaiController.text = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime.now());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && _nomorSurat == null) {
      _nomorSurat = args['nomor'];
      _namaSurat = args['nama'];
      _tipeHafalan = args['tipe'];
      _nomorSuratController.text = _nomorSurat.toString();
      _namaSuratController.text = _namaSurat.toString();
    }
  }

  @override
  void dispose() {
    _nomorSuratController.dispose();
    _namaSuratController.dispose();
    _tanggalMulaiController.dispose();
    _tanggalSelesaiController.dispose();
    super.dispose();
  }

  Future<void> _pickTanggalSelesai() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
        idHafalan: int.parse(_nomorSuratController.text),
        namaHafalan: _namaSuratController.text,
        tipeHafalan: _tipeHafalan ?? 'noData',
        tanggalMulai: _tanggalMulaiController.text,
        tanggalSelesai: _tanggalSelesaiController.text,
      );

      final success = await HafalanSave().addHafalan(newHafalan);

      if (success) {
        Navigator.pop(context);
      } else {
        _error = 'Gagal tambah data';
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
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Hafalan'), centerTitle: true),
      body:
          _isLoading || _nomorSurat == null
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Nomor Surat
                      TextFormField(
                        controller: _nomorSuratController,
                        decoration: InputDecoration(labelText: 'Nomor Surat'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Nomor surat wajib diisi';
                          if (int.tryParse(value) == null)
                            return 'Nomor surat harus angka';
                          return null;
                        },
                      ),

                      // Nama Surat
                      TextFormField(
                        controller: _namaSuratController,
                        decoration: InputDecoration(labelText: 'Nama Surat'),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Nama surat wajib diisi';
                          return null;
                        },
                      ),

                      // Tanggal Mulai (readonly)
                      TextFormField(
                        controller: _tanggalMulaiController,
                        decoration: InputDecoration(labelText: 'Tanggal Mulai'),
                        readOnly: true,
                        onTap: () async {
                          // Bisa juga pakai datepicker kalau mau
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
                          }
                        },
                      ),

                      // Tanggal Selesai (bisa pilih via date picker)
                      TextFormField(
                        controller: _tanggalSelesaiController,
                        decoration: InputDecoration(
                          labelText: 'Tanggal Selesai',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: _pickTanggalSelesai,
                          ),
                        ),
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Tanggal selesai wajib diisi';
                          return null;
                        },
                      ),

                      SizedBox(height: 20),

                      if (_error != null) ...[
                        Text(_error!, style: TextStyle(color: Colors.red)),
                        SizedBox(height: 20),
                      ],

                      ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        child:
                            _isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text('Simpan Hafalan'),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:projek_akhir_mobile/models/surat_detail_model.dart';
import 'package:projek_akhir_mobile/services/surat_network.dart';

class DetailHafalanScreen extends StatefulWidget {
  const DetailHafalanScreen({super.key});

  @override
  State<DetailHafalanScreen> createState() => _DetailHafalanScreenState();
}

class _DetailHafalanScreenState extends State<DetailHafalanScreen> {
  late Future<SuratDetail> _suratDetailFuture;
  int? _nomorSurat;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && _nomorSurat == null) {
      _nomorSurat = args['nomor'];
      _suratDetailFuture = _fetchSuratDetail(_nomorSurat!);
    }
  }

  Future<SuratDetail> _fetchSuratDetail(int id) async {
    SuratDetail suratDetail = await SuratNetwork().getDetailData(id);
    return suratDetail;
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

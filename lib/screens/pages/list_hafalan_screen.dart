import 'package:flutter/material.dart';
import 'package:projek_akhir_mobile/models/hafalan_model.dart';
import 'package:projek_akhir_mobile/services/hafalan_save.dart';

class ListHafalanScreen extends StatefulWidget {
  const ListHafalanScreen({super.key});

  @override
  State<ListHafalanScreen> createState() => _ListHafalanScreenState();
}

class _ListHafalanScreenState extends State<ListHafalanScreen> {
  late Future<List<Hafalan>> _hafalanListFuture;

  @override
  void initState() {
    super.initState();
    _hafalanListFuture = HafalanSave().getHafalan();
  }

  void hapusData(int id) async {
    final List<Hafalan> hafalanList = await HafalanSave().getHafalan();
    final index = hafalanList.indexWhere((h) => h.id == id);
    if (index == -1) {
      debugPrint('Hafalan tidak ditemukan');
      return;
    }

    Hafalan hafalan = hafalanList[index];
    hafalanList.removeAt(index);
    final success = await HafalanSave().saveHafalanList(hafalanList);
    if (success) {
      setState(() {
        _hafalanListFuture = HafalanSave().getHafalan();
      });
      debugPrint('Hafalan dengan id=$id dihapus');
    } else {
      debugPrint('Gagal menghapus hafalan');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List User')),
      body: FutureBuilder<List<Hafalan>>(
        future: _hafalanListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak Ada Data'));
          }

          final hafalanList = snapshot.data!;

          return ListView.builder(
            itemCount: hafalanList.length,
            itemBuilder: (context, index) {
              final hafalan = hafalanList[index];
              return ListTile(
                title: Text(
                  'User ke-${index + 1}',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('id Hafalan: ${hafalan.idHafalan}'),
                    Text('Nama Hafalan: ${hafalan.namaHafalan}'),
                    Text('Tanggal Mulai Hafalan: ${hafalan.tanggalMulai}'),
                    Text('Tanggal Selesai Hafalan: ${hafalan.tanggalSelesai}'),
                    Text('Tipe Hafalan: ${hafalan.tipeHafalan}'),
                    SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          hapusData(hafalan.id);
                        },
                        child: Text("Hapus"),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

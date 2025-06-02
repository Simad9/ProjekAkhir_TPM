import 'package:flutter/material.dart';
import 'package:projek_akhir_mobile/models/user_model.dart';
import 'package:projek_akhir_mobile/services/user_save.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListUserScreen extends StatefulWidget {
  const ListUserScreen({super.key});

  @override
  State<ListUserScreen> createState() => _ListUserScreenState();
}

class _ListUserScreenState extends State<ListUserScreen> {
  late Future<List<User>> _userListFuture;

  @override
  void initState() {
    super.initState();
    cekSession();
    _userListFuture = UserSave().getUserList();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List User')),
      body: FutureBuilder<List<User>>(
        future: _userListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak Ada Data'));
          }

          final userList = snapshot.data!;

          return ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              final user = userList[index];
              return ListTile(
                title: Text(
                  'User ke-${index + 1}',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Username: ${user.username}'),
                    Text('Email: ${user.email}'),
                    Text('PasswordHash: ${user.passwordHash}'),
                    Text('Sudah Bayar (nullable): ${user.sudah_bayar}'),
                    Text('Waktu Bayar (nullable): ${user.waktu_bayar}'),
                    SizedBox(height: 8),
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

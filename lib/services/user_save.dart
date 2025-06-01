import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:projek_akhir_mobile/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSave {
  // Simpan user ke local
  Future<bool> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    return await prefs.setString('user', userJson);
  }

  // Ambil data user dari local
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson == null) return null;
    final Map<String, dynamic> userMap = jsonDecode(userJson);
    return User.fromJson(userMap);
  }

  // Tambahkan user ke list user yang sudah ada
  Future<bool> addUser(User user) async {
    final List<User> userList = (await getUserList());
    userList.add(user);
    return await saveUserList(userList);
  }

  // Simpan list user ke local
  Future<bool> saveUserList(List<User> userList) async {
    final prefs = await SharedPreferences.getInstance();
    final userListJson = userList.map((e) => jsonEncode(e.toJson())).toList();
    return await prefs.setStringList('user_list', userListJson);
  }

  // Ambil list user dari local
  Future<List<User>> getUserList() async {
    final prefs = await SharedPreferences.getInstance();
    final userListJson = prefs.getStringList('user_list');
    if (userListJson == null || userListJson.isEmpty) return [];
    return userListJson.map((e) {
      final Map<String, dynamic> userMap = jsonDecode(e);
      return User.fromJson(userMap);
    }).toList();
  }

  // Ambil data sesuai username
  Future<User?> getUserByUsername(String username) async {
    final userList = await getUserList();
    for (final user in userList) {
      if (user.username == username) return user;
    }
    return null;
  }

  // Registrasi user
  Future<bool> register(String username, String email, String password) async {
    final userList = await getUserList();

    for (final user in userList) {
      if (user.username == username) {
        return false; // sudah ada user dengan username itu
      }
    }

    final passwordHash = hashPassword(password);
    final user = User(
      username: username,
      email: email,
      passwordHash: passwordHash,
    );
    return addUser(user);
  }

  // Hash password dengan SHA-256
  String hashPassword(String password) {
    final bytes = utf8.encode(password); // encode password jadi bytes
    final digest = sha256.convert(bytes); // hash dengan SHA-256
    return digest.toString(); // return hash sebagai string heksadesimal
  }

  // Login user
  Future<bool> login(String usernameInput, String passwordInput) async {
    final userList = await getUserList();
    if (userList.isEmpty) return false;
    for (final user in userList) {
      if (user.username == usernameInput &&
          user.passwordHash == hashPassword(passwordInput)) {
        return true;
      }
    }
    return false;
  }

  
}

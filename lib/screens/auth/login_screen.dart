// Services
import 'package:projek_akhir_mobile/services/user_save.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../../components/button_primary.dart';
import '../../components/form_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cekUsername().then((value) {
      if (value) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    });
  }

  Future<bool> _cekUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    return username != null;
  }

  Future<void> _login() async {
    if (usernameController.text.isNotEmpty ||
        passwordController.text.isNotEmpty) {
      String session = usernameController.text + passwordController.text;

      final success = await UserSave().login(
        usernameController.text,
        passwordController.text,
      );

      if (success) {
        // Masukin Session
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('session_token', session);
        await prefs.setString('username', usernameController.text);
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } else {
        await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text('Login Gagal'),
                content: Text('Username atau Password salah'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('OK'),
                  ),
                ],
              ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: Color(0xFFF9F9FB),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Selamat Datang!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Pake usernammu dan password untuk ",
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  "Masuk",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 25),
            FormInput(
              hint: "Username",
              icon: Icons.person_outline,
              controller: usernameController,
            ),
            SizedBox(height: 10),
            FormInput(
              hint: "Password",
              icon: Icons.lock_outline,
              controller: passwordController,
              obscureText: true, // Set to true for password input
            ),
            SizedBox(height: 10),
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: Text(
            //     "Lupa password?",
            //     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            //   ),
            // ),
            SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ButtonPrimary(
                text: "Masuk",
                onPressed: _login, // Call the login function when pressed),
              ),
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Kamu belum punya akun? "),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/register',
                      (route) => false,
                    );
                  },
                  child: Text(
                    "Daftar",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

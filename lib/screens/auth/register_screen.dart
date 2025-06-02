import 'package:flutter/material.dart';
import 'package:projek_akhir_mobile/services/user_save.dart';
import '../../components/button_primary.dart';
import '../../components/form_input.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _rePasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Tidak boleh ada kolom yang kosong")),
      );
      return;
    }

    if (_passwordController.text != _rePasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Password tidak sama")));
      return;
    }

    final success = await UserSave().register(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
    );

    if (success) {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => LoginScreen()),
      // );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Register berhasil")));
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Akun Sudah Terdaftar, coba dengna yang lain")),
      );
      return;
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
                  "Pake emailmu dan password untuk ",
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  "Daftar",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 25),
            FormInput(
              hint: "Nama",
              icon: Icons.person_outline,
              controller: _nameController,
            ),
            SizedBox(height: 10),
            FormInput(
              hint: "Email",
              icon: Icons.email_outlined,
              controller: _emailController,
            ),
            SizedBox(height: 10),
            FormInput(
              hint: "Password",
              icon: Icons.lock_outline,
              obscureText: true,
              controller: _passwordController,
            ),
            SizedBox(height: 10),
            FormInput(
              hint: "Re-Password",
              icon: Icons.lock_outline,
              obscureText: true,
              controller: _rePasswordController,
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
                text: "Daftar",
                onPressed: () => _register(),
              ),
            ),
            SizedBox(height: 25),
            // Text("Atau Masuk pake", style: TextStyle(fontSize: 14)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Kamu belum punya akun? "),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  },
                  child: Text(
                    "Masuk",
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

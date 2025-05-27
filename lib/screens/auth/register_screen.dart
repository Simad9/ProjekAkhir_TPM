import 'package:flutter/material.dart';
import '../../components/button_primary.dart';
import '../../components/form_input.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
            FormInput(hint: "Nama", icon: Icons.person_outline),
            SizedBox(height: 10),
            FormInput(hint: "Email", icon: Icons.email_outlined),
            SizedBox(height: 10),
            FormInput(hint: "Password", icon: Icons.lock_outline),
            SizedBox(height: 10),
            FormInput(hint: "Re-Password", icon: Icons.lock_outline),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Lupa password?",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ButtonPrimary(
                text: "Daftar",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
            ),
            SizedBox(height: 25),
            Text("Atau Masuk pake", style: TextStyle(fontSize: 14)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Kamu belum punya akun? "),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
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

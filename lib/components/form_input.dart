import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  final IconData icon;
  final String hint;
  final TextEditingController? controller;
  final bool obscureText;

  const FormInput({
    super.key,
    required this.icon,
    required this.hint,
    this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            prefixIcon: Container(
              padding: EdgeInsets.all(10),
              child: Icon(icon, color: Color(0xFFBFC3C4)),
            ),
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color(0xFFBFC3C4)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color(0xFFBFC3C4)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color.fromARGB(255, 88, 91, 91)),
            ),
          ),
        ),
      ],
    );
  }
}

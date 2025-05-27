import 'package:flutter/material.dart';

class MenuList extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function() onPress;
  const MenuList({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPress,
      icon: Icon(icon),
      label: Expanded(
        child: Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14),
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        alignment: Alignment.centerLeft,
      ),
    );
  }
}

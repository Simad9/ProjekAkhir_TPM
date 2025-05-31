// Services
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Pages
import 'package:projek_akhir_mobile/screens/auth/login_screen.dart';
import 'package:projek_akhir_mobile/screens/home/profile_screen.dart';
import 'package:projek_akhir_mobile/screens/home/list_screen.dart';
import 'home/home_screen.dart';

class NavigasiScreen extends StatefulWidget {
  const NavigasiScreen({super.key});

  @override
  State<NavigasiScreen> createState() => _NavigasiScreenState();
}

class _NavigasiScreenState extends State<NavigasiScreen> {
  int _currentIndex = 1;
  String? sessionToken;

  @override
  void initState() {
    super.initState();
    checkSession();
  }

  Future<void> checkSession() async {
    // Ambil session token dari SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sessionToken = prefs.getString(
      'session_token',
    ); // Mendapatkan session token

    // Jika session token tidak ada, arahkan ke halaman login
    if (sessionToken == null) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    }
  }

  final List<Widget> _pages = <Widget>[
    ListScreen(),
    HomeScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Center(child: _pages.elementAt(_currentIndex))),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "List"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type:
            BottomNavigationBarType
                .fixed, // Agar item tidak hilang saat ada banyak
      ),
    );
  }
}

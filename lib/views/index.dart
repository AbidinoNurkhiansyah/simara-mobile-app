import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/navigation_provider.dart';
import '../widgets/bottom_navbar.dart';
import 'beranda_page.dart';
import 'suscatin_page.dart';
import 'profil.dart';

class IndexScreen extends StatefulWidget {
  IndexScreen({super.key});

  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  int idUser = 0;

  @override
  void initState() {
    super.initState();
    _getidUser();
  }

  Future<void> _getidUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      idUser = prefs.getInt("idUser") ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Tampilkan loading jika idUser belum didapat
    if (idUser == 0) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final navigationProvider = Provider.of<NavigationProvider>(context);

    final List<Widget> _screens = [
      BerandaPage(), // Beranda utama
      SuscatinPage(idUser: idUser), // Suscatin
      ProfilScreen(), // Profil
    ];

    return Scaffold(
      body: _screens[navigationProvider.currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: navigationProvider.currentIndex,
        onTap: (index) {
          navigationProvider.changePage(index);
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import 'package:simara_app/providers/user_provider.dart';
import 'package:simara_app/providers/navigation_provider.dart';
import 'change_password_page.dart';
import 'detail_profile_page.dart';
import 'formulir_pernikahan_page.dart';

class ProfilScreen extends StatefulWidget {
  @override
  _ProfilScreenState createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  Future<void> saveUserId(int idUser) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('idUser', idUser);
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getInt('idUser');
    print("Loading profile for user ID from Provider: $idUser");

    if (idUser != null) {
      await Provider.of<UserProvider>(context, listen: false).fetchUser(idUser);
    } else {
      print("⚠️ Gagal memuat ID user dari SharedPreferences");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: Color(0xFF31502C),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Color(0xFF31502C)),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFF7FAF2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    "Profil",
                    Icons.person,
                    context,
                    DetailProfilePage(),
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    "Ganti Kata Sandi",
                    Icons.lock,
                    context,
                    ChangePasswordPage(),
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    "Contoh Formulir Pernikahan",
                    Icons.description,
                    context,
                    ContohFormulirPernikahanPage(),
                  ),
                  _buildDivider(),
                  _buildLogoutItem("Keluar", Icons.exit_to_app, context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    String title,
    IconData icon,
    BuildContext context,
    Widget? page,
  ) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      leading: Icon(icon, color: Color(0xFF31502C)),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Color(0xFF31502C),
      ),
      onTap: () {
        if (page != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        } else {
          // Untuk item yang belum ada halaman
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("$title belum tersedia")));
        }
      },
    );
  }

  Widget _buildLogoutItem(String title, IconData icon, BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      leading: Icon(icon, color: Colors.red.shade800),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.red.shade800,
      ),
      onTap: () {
        _showLogoutDialog(context);
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi Keluar"),
          content: Text("Apakah Anda yakin ingin keluar?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
              },
              child: Text("Tidak"),
            ),
            TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                // Reset navigation index ke beranda
                Provider.of<NavigationProvider>(
                  context,
                  listen: false,
                ).changePage(0);

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              child: Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, color: Colors.grey.shade300);
  }
}

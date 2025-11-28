import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
<<<<<<< HEAD
  final String baseUrl = "https://simara.my.id/api_simara";
=======
  final String baseUrl = "http://20.60.20.11/api_simara";
>>>>>>> 7050fa841f57996f4de8349b6d8e113339461c91
  User? _user;
  bool _isLoading = false;
  List<int> jadwalYangSudahDipesan = [];

  User? get user => _user;
  bool get isLoading => _isLoading;

  void loadUserProfile(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getInt('idUser');

    print("🔍 Loading profile for user ID from Provider: $idUser");

    if (idUser != null) {
      await Provider.of<UserProvider>(context, listen: false).fetchUser(idUser);
    } else {
      print("⚠️ User ID not found in SharedPreferences");
    }
  }

  // Fungsi untuk mengambil data user dari server
  Future<void> fetchUser(int idUser) async {
    print("🔄 Fetching user data for ID: $idUser"); // Debugging

    final response = await http.get(
      Uri.parse('$baseUrl/get_user.php?id_user=$idUser'),
    );
    print("🔍 Response Status: ${response.statusCode}");
    print("🔍 Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        _user = User.fromJson(data["user"]);
        print("✅ User Loaded: ${user!.idUser}");
      } else {
        print("❌ Gagal mendapatkan user data.");
      }
    } else {
      print("❌ Error saat fetch user data.");
    }

    notifyListeners();
  }

  Future<void> _saveUserName(String newName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', newName);
  }

  // Fungsi update data user
  Future<void> updateUserProfile({
    required int idUser,
    required String name,
    required String email,
    required String nohp,
    required String domisili,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.put(
        Uri.parse("$baseUrl/profile.php"), // Use baseUrl constant
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id_user": idUser,
          "name": name,
          "email": email,
          "nohp": nohp,
          "domisili": domisili,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception("Server error: ${response.statusCode}");
      }

      final data = json.decode(response.body);
      if (data['status'] != "success") {
        throw Exception(data['message'] ?? "Update failed");
      }

      _user = User(
        idUser: idUser,
        name: name,
        email: email,
        nohp: nohp,
        domisili: domisili,
      );

      await _saveUserName(name);
    } catch (e) {
      print("Error updating user: $e");
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPemesananUser(int idUser) async {
    final response = await http.get(
      Uri.parse(
<<<<<<< HEAD
        'https://simara.my.id/api_simara/get_pemesanan.php?id_user=$idUser',
=======
        'http://20.60.20.11/api_simara/get_pemesanan.php?id_user=$idUser',
>>>>>>> 7050fa841f57996f4de8349b6d8e113339461c91
      ),
    );
    final data = jsonDecode(response.body);

    jadwalYangSudahDipesan = List<int>.from(
      data.map((item) => item['id_jadwal']),
    );
    notifyListeners();
  }

  // Fungsi untuk mengganti kata sandi
  Future<bool> changePassword({
    required int idUser,
    required String oldPassword,
    required String newPassword,
  }) async {
    final url = Uri.parse('$baseUrl/change_password.php');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_user': idUser,
          'old_password': oldPassword,
          'new_password': newPassword,
        }),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print('Error changing password: $e');
      return false;
    }
  }
}

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthController {
  final String baseUrl = "http://localhost/api_simara";

  Future<bool> checkServerConnection() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health_check.php'));
      return response.statusCode == 200;
    } catch (e) {
      print("Error checking server connection: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/login.php'),
            headers: {
              "Content-Type": "application/json",
            }, // 🔥 Wajib pakai headers JSON
            body: jsonEncode({"email": email, "password": password}),
          )
          .timeout(Duration(seconds: 10));

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      final data = json.decode(response.body);
      if (data["status"] == "success") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String userName = data["user"]?["name"] ?? "Pengguna";
        int id_user = data["user"]?["id_user"] ?? 0;

        if (id_user > 0) {
          await prefs.setInt('id_user', id_user);
          await prefs.setString('user_name', userName);

          // 🔥 Tambahkan debug ini setelah menyimpan
          print("✅ Data yang disimpan:");
          print("User ID: ${prefs.getInt('id_user')}");
          print("User Name: ${prefs.getString('user_name')}");
        } else {
          print("❌ Gagal menyimpan data, ID tidak valid.");
        }

        // Debugging setelah penyimpanan
        print("🔍 Cek ulang dari SharedPreferences:");
        print("User ID: ${prefs.getInt('id_user')}");
        print("User Name: ${prefs.getString('user_name')}");

        return data;
      }

      return data;
    } catch (e) {
      print("Error dalam login: $e");
      return {"status": "error", "message": "Terjadi kesalahan saat login."};
    }
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String nohp,
    String domisili,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "nohp": nohp,
          "domisili": domisili,
          "password": password,
        }),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      return json.decode(response.body);
    } catch (e) {
      print("Error dalam register: $e");
      throw Exception("Gagal mendaftar: $e");
    }
  }
}

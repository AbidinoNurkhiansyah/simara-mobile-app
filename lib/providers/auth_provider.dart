import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyAuthProvider with ChangeNotifier {
  int? idUser;
  String? name;

  Future<void> loadUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      idUser = prefs.getInt('idUser');
      name = prefs.getString('user_name');

      print("🔍 AuthProvider - User ID loaded: $idUser");
      print("🔍 AuthProvider - User Name loaded: $name");

      notifyListeners();
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://20.60.20.11/api_simara/login.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      print('Login Response Status: ${response.statusCode}');
      print('Login Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final responseData = json.decode(response.body);

          if (responseData['status'] == 'success' &&
              responseData['user'] != null) {
            final userData = responseData['user'];
            final prefs = await SharedPreferences.getInstance();

            // Store user data - ensure ID is stored as integer
            final userId = int.parse(userData['id_user'].toString());
            await prefs.setInt('idUser', userId);
            await prefs.setString('user_name', userData['name'].toString());

            // Update provider state
            idUser = userId;
            name = userData['name'].toString();

            // Verify storage
            final storedId = prefs.getInt('idUser');
            print('Stored user ID: $storedId');

            notifyListeners();
            return true;
          } else {
            print(
              'Login failed: ${responseData['message'] ?? 'Unknown error'}',
            );
            return false;
          }
        } catch (e) {
          print('Error parsing response: $e');
          print('Raw response: ${response.body}');
          return false;
        }
      } else {
        print('Server error: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('idUser');
      await prefs.remove('user_name');

      idUser = null;
      name = null;

      notifyListeners();
    } catch (e) {
      print('Logout error: $e');
    }
  }
}

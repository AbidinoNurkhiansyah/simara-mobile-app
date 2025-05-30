import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences package
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileProvider extends ChangeNotifier {
  Map<String, dynamic>? _profileData;
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? get profileData => _profileData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProfile(int idUser) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('🔄 Fetching profile for user ID: $idUser');
      final response = await http.get(
        Uri.parse(
          'https://simara.my.id/api_simara/get_user.php?id_user=$idUser',
        ),
      );

      print('🔍 Response Status: ${response.statusCode}');
      print('🔍 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        if (decodedResponse['status'] == 'success' &&
            decodedResponse['user'] != null) {
          _profileData = decodedResponse['user'];
          print('✅ Profile data loaded successfully');
        } else {
          _error = decodedResponse['message'] ?? 'Failed to load profile';
          print('❌ Error: $_error');
        }
      } else {
        _error = 'Server returned status code: ${response.statusCode}';
        print('❌ Error: $_error');
      }
    } catch (e) {
      _error = 'Error fetching profile: $e';
      print('❌ Error: $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.put(
        Uri.parse('https://simara.my.id/api_simara/profile.php'),
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );

      print('🔍 Update Response Status: ${response.statusCode}');
      print('🔍 Update Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        if (decodedResponse['status'] == 'success') {
          _profileData = data;
          print('✅ Profile updated successfully');
          if (data.containsKey('name')) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('user_name', data['name']);
          }
          return true;
        } else {
          _error = decodedResponse['message'] ?? 'Failed to update profile';
          print('❌ Error: $_error');
          return false;
        }
      } else {
        _error = 'Server returned status code: ${response.statusCode}';
        print('❌ Error: $_error');
        return false;
      }
    } catch (e) {
      _error = 'Error updating profile: $e';
      print('❌ Error: $_error');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

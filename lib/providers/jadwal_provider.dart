import 'package:flutter/material.dart';
import '../models/jadwal_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/notification_service.dart';

class JadwalProvider with ChangeNotifier {
  List<Jadwal> _jadwalList = [];
  List<Jadwal> _jadwalUser = []; // Pemesanan user dalam bentuk List<Jadwal>
  final notificationService = NotificationService();

  List<Jadwal> get jadwalList => _jadwalList;
  List<Jadwal> get jadwalUser => _jadwalUser;

  Future<void> fetchJadwal() async {
    final url = 'http://localhost/api_simara/get_jadwal.php';
    final response = await http.get(Uri.parse(url));
    print('API Response: ${response.body}');
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      _jadwalList = data.map((item) => Jadwal.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<void> fetchPemesananUser(int idUser) async {
    try {
      print('Fetching bookings for user: $idUser');
      final url =
          'http://localhost/api_simara/get_pemesanan.php?id_user=$idUser';
      final response = await http.get(Uri.parse(url));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Decoded data: $data');

        if (data != null && data is List) {
          _jadwalUser =
              data.map<Jadwal>((item) {
                print('Processing item: $item');
                return Jadwal.fromJson(item);
              }).toList();
          print(
            'Processed jadwalUser: ${_jadwalUser.map((j) => 'idPemesanan: ${j.idPemesanan}, idJadwal: ${j.idJadwal}').join(', ')}',
          );
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error fetching user bookings: $e');
      _jadwalUser = [];
      notifyListeners();
    }
  }

  Future<void> bookSesi(int idUser, int idJadwal) async {
    try {
      // Dapatkan jadwal yang akan dipesan
      final bookedJadwal = _jadwalList.firstWhere(
        (j) => j.idJadwal == idJadwal,
      );

      // Perbaikan konversi sesi
      int sesiNumber;
      if (bookedJadwal.sesi.toString().contains("09:00")) {
        sesiNumber = 1;
      } else if (bookedJadwal.sesi.toString().contains("13:00")) {
        sesiNumber = 2;
      } else {
        throw Exception('Format sesi tidak valid');
      }

      final String timeString = sesiNumber == 1 ? '09:00:00' : '13:00:00';
      final dateTimeString = '${bookedJadwal.tanggal} $timeString';
      DateTime sessionDateTime;
      try {
        sessionDateTime = DateTime.parse(dateTimeString).toLocal();
      } catch (e) {
        throw Exception('Format tanggal tidak valid');
      }

      // Validasi tanggal dan waktu
      DateTime now = DateTime.now();
      if (sessionDateTime.isBefore(now)) {
        throw Exception(
          'Maaf, sesi yang Anda pilih sudah lewat. Silakan pilih sesi di waktu mendatang.',
        );
      }

      // Lanjutkan dengan proses pemesanan
      final response = await http.post(
        Uri.parse('http://localhost/api_simara/pemesanan.php'),
        body: {'id_user': idUser.toString(), 'id_jadwal': idJadwal.toString()},
      );
      final data = jsonDecode(response.body);

      if (data['success'] != null) {
        // Pemesanan berhasil, fetch ulang data pemesanan user
        await fetchPemesananUser(idUser);
        await fetchJadwal();

        // Schedule notifications for the booked session
        try {
          await notificationService.scheduleReminders(
            bookedJadwal.tanggal,
            sesiNumber,
          );
        } catch (e) {
          print('Error scheduling notifications: $e');
          // Tidak melempar exception agar proses pemesanan tetap dianggap berhasil
        }
      } else {
        throw Exception(data['error'] ?? 'Gagal memesan');
      }
    } catch (e) {
      print('Error booking session: $e');
      throw e;
    }
  }

  Future<void> cancelSesi(int idUser, int idPemesanan) async {
    final url = 'http://localhost/api_simara/batal_pemesanan.php';

    try {
      print(
        'Attempting to cancel booking: idUser=$idUser, idPemesanan=$idPemesanan',
      );
      final response = await http.post(
        Uri.parse(url),
        body: {
          'id_pemesanan': idPemesanan.toString(),
          'id_user': idUser.toString(),
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Decoded response: $responseData');

        if (responseData['status'] == 'success') {
          print('Cancellation successful, removing from local list');
          _jadwalUser.removeWhere(
            (jadwal) => jadwal.idPemesanan == idPemesanan,
          );

          // Refresh jadwal list untuk memperbarui current_participants
          await fetchJadwal();

          // Refresh jadwal user
          await fetchPemesananUser(idUser);

          notifyListeners();
          print('Booking cancelled successfully');
        } else {
          print('Cancellation failed: ${responseData['message']}');
          throw Exception(responseData['message']);
        }
      } else {
        print('HTTP error: ${response.statusCode}');
        throw Exception('Failed to cancel booking');
      }
    } catch (e) {
      print('Error during cancellation: $e');
      throw e;
    }
  }
}

import 'package:flutter/material.dart';
import '../providers/jadwal_provider.dart';
import 'package:provider/provider.dart';
import '../models/jadwal_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class JadwalController {
  static Future<void> fetchJadwal(BuildContext context) async {
    await Provider.of<JadwalProvider>(context, listen: false).fetchJadwal();
  }

  static Future<bool> showConfirmationDialog(
    BuildContext context,
    Jadwal jadwal,
  ) async {
    final date = DateTime.parse(jadwal.tanggal);
    final formattedDate = DateFormat('dd MMMM yyyy').format(date);
    return await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text('Konfirmasi Pemesanan'),
                content: Text(
                  'Apakah Anda yakin ingin memesan sesi ini?\n${jadwal.hari} - $formattedDate - ${jadwal.sesi}',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text('Batal'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text('Ya'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  static Future<void> bookSesi(
    BuildContext context,
    int idUser,
    int idJadwal,
  ) async {
    try {
      // Gunakan provider untuk melakukan pemesanan
      await Provider.of<JadwalProvider>(
        context,
        listen: false,
      ).bookSesi(idUser, idJadwal);

      // Tampilkan pesan sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pemesanan berhasil'),
          backgroundColor: Colors.green,
        ),
      );

      // Update jadwal setelah pemesanan berhasil
      await Provider.of<JadwalProvider>(context, listen: false).fetchJadwal();
    } catch (e) {
      // Tampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  static Future<void> cancelBooking(
    BuildContext context,
    int idUser,
    int idPemesanan,
  ) async {
    try {
      final response = await http.post(
<<<<<<< HEAD
        Uri.parse('https://simara.my.id/api_simara/batal_pemesanan.php'),
=======
        Uri.parse('http://20.60.20.11/api_simara/batal_pemesanan.php'),
>>>>>>> 7050fa841f57996f4de8349b6d8e113339461c91
        body: {
          'id_user': idUser.toString(),
          'id_pemesanan': idPemesanan.toString(),
        },
      );

      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(data['message'])));

        // Update pemesanan user setelah pembatalan berhasil
        await Provider.of<JadwalProvider>(
          context,
          listen: false,
        ).fetchPemesananUser(idUser);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Gagal membatalkan')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    }
  }
}

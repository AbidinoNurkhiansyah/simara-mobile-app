import 'package:intl/intl.dart';

class Jadwal {
  final int idJadwal;
  final int idPemesanan;
  final String hari;
  final String tanggal; // yyyy-MM-dd
  final String sesi;
  final int maxParticipants;
  final int currentParticipants;
  final String konsultanName;

  Jadwal({
    required this.idJadwal,
    required this.idPemesanan,
    required this.hari,
    required this.tanggal,
    required this.sesi,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.konsultanName,
  });

  // Getter tambahan (opsional) untuk tampilkan dalam format Indonesia
  String get tanggalFormatted {
    try {
      final inputFormat = DateFormat('yyyy-MM-dd');
      final outputFormat = DateFormat('dd MMMM yyyy', 'id_ID');
      final parsedDate = inputFormat.parse(tanggal);
      return outputFormat.format(parsedDate);
    } catch (e) {
      print('Tanggal tidak valid: $e');
      return tanggal; // fallback
    }
  }

  factory Jadwal.fromJson(Map<String, dynamic> json) {
    return Jadwal(
      idJadwal: int.tryParse(json['id_jadwal'].toString()) ?? 0,
      idPemesanan: int.tryParse(json['id_pemesanan']?.toString() ?? '0') ?? 0,
      hari: json['hari'] ?? '',
      tanggal: json['tanggal'] ?? '',
      sesi: json['sesi'] ?? '',
      maxParticipants: int.tryParse(json['max_participants'].toString()) ?? 0,
      currentParticipants:
          int.tryParse(json['current_participants'].toString()) ?? 0,
      konsultanName: json['name_konsultan']?.toString() ?? '',
    );
  }
}

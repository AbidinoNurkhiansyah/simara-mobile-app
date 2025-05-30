import 'package:flutter/material.dart';
import 'package:simara_app/models/jadwal_model.dart';

final Color yellowColor = Color(0xFFF3CD00);
Widget buildPemesananCard(Jadwal jadwal, VoidCallback onCancel) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      // color: Colors.white,
      border: Border.all(color: yellowColor),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.grey, size: 18),
            SizedBox(width: 6),
            Text(
              "Hari & Tanggal",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Text(
              "${jadwal.hari}, ${jadwal.tanggal}",
              style: TextStyle(
                color: Color(0xFF31502C),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.access_time, color: Colors.grey, size: 18),
            SizedBox(width: 6),
            Text(
              "Sesi",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Text(
              jadwal.sesi,
              style: TextStyle(
                color: Color(0xFF31502C),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.person, color: Colors.grey, size: 18),
            SizedBox(width: 6),
            Text(
              "Konsultan",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Text(
              jadwal.konsultanName,
              style: TextStyle(
                color: Color(0xFF31502C),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onCancel,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(vertical: 10),
            ),
            child: Text(
              "Batalkan",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

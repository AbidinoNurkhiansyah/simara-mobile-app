import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/jadwal_provider.dart';
import '../models/jadwal_model.dart';
import 'package:intl/intl.dart';
import '../services/notification_service.dart';

void showScheduleModal(BuildContext context, int idUser) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return ScheduleSelector(idUser: idUser);
    },
  );
}

class ScheduleSelector extends StatefulWidget {
  final int idUser;
  const ScheduleSelector({Key? key, required this.idUser}) : super(key: key);

  @override
  _ScheduleSelectorState createState() => _ScheduleSelectorState();
}

class _ScheduleSelectorState extends State<ScheduleSelector> {
  final Color greenColor = Color(0xFF31502C);
  final Color greyColor = Color(0xFF636573);
  final Color blackColor = Color(0xFF3B3E51);
  final Color yellowColor = Color(0xFFF3CD00);

  String? selectedDay;
  String? selectedSession;
  String? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Consumer<JadwalProvider>(
      builder: (context, provider, child) {
        final hasActiveBooking = provider.jadwalUser.isNotEmpty;
        // Ambil semua hari unik dari jadwalList
        final days =
            provider.jadwalList
                .map((j) => j.hari[0].toUpperCase() + j.hari.substring(1))
                .toSet()
                .toList();
        // Ambil semua sesi unik dari jadwalList
        final sessions =
            provider.jadwalList.map((j) => j.sesi).toSet().toList();

        // Cek status penuh untuk setiap kombinasi hari & sesi
        bool isSessionFull(String hari, String sesi) {
          final jadwal = provider.jadwalList.firstWhere(
            (j) => j.hari.toLowerCase() == hari.toLowerCase() && j.sesi == sesi,
            orElse:
                () => Jadwal(
                  idJadwal: 0,
                  idPemesanan: 0,
                  hari: hari,
                  tanggal: '',
                  sesi: sesi,
                  maxParticipants: 1,
                  currentParticipants: 1,
                  konsultanName: '',
                ),
          );
          return jadwal.currentParticipants >= jadwal.maxParticipants;
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              // Garis di atas modal
              Container(
                width: 80,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Atur Jadwal",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: greenColor,
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Hari",
                  style: GoogleFonts.poppins(
                    color: greenColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(days.length * 2 - 1, (index) {
                  if (index.isOdd) return SizedBox(width: 20);
                  int dayIndex = index ~/ 2;
                  final day = days[dayIndex];
                  final allSessionsFull = sessions.every(
                    (sesi) => isSessionFull(day, sesi),
                  );
                  final disable = hasActiveBooking || allSessionsFull;
                  return Expanded(
                    child: GestureDetector(
                      onTap:
                          disable
                              ? null
                              : () {
                                setState(() {
                                  selectedDay = day;
                                  selectedSession = null;
                                  final jadwal = provider.jadwalList.firstWhere(
                                    (j) =>
                                        j.hari.toLowerCase() ==
                                        day.toLowerCase(),
                                    orElse:
                                        () => Jadwal(
                                          idJadwal: 0,
                                          idPemesanan: 0,
                                          hari: day,
                                          tanggal: '',
                                          sesi: '',
                                          maxParticipants: 0,
                                          currentParticipants: 0,
                                          konsultanName: '',
                                        ),
                                  );
                                  if (jadwal != null) {
                                    selectedDate = jadwal.tanggal;
                                  } else {
                                    selectedDate =
                                        null; // Atur default jika tidak ada jadwal yang ditemukan
                                  }
                                });
                              },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color:
                              selectedDay == day && !disable
                                  ? greenColor
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: greenColor, width: 2),
                          boxShadow:
                              disable
                                  ? [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      blurRadius: 0,
                                    ),
                                  ]
                                  : [],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          day,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color:
                                disable
                                    ? Colors.grey
                                    : (selectedDay == day
                                        ? Colors.white
                                        : greenColor),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Sesi",
                  style: GoogleFonts.poppins(
                    color: greenColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(sessions.length * 2 - 1, (index) {
                  if (index.isOdd) return SizedBox(width: 20);
                  int sessionIndex = index ~/ 2;
                  final sesi = sessions[sessionIndex];
                  final disable =
                      hasActiveBooking ||
                      selectedDay == null ||
                      isSessionFull(selectedDay!, sesi);
                  return Expanded(
                    child: GestureDetector(
                      onTap:
                          disable
                              ? null
                              : () {
                                setState(() {
                                  selectedSession = sesi;
                                });
                              },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color:
                              selectedSession == sesi && !disable
                                  ? greenColor
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: greenColor, width: 2),
                          boxShadow:
                              disable
                                  ? [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      blurRadius: 0,
                                    ),
                                  ]
                                  : [],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          sesi,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color:
                                disable
                                    ? Colors.grey
                                    : (selectedSession == sesi
                                        ? Colors.white
                                        : greenColor),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 20),
              if (hasActiveBooking)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Batalkan dulu pemesanan sebelumnya",
                    style: GoogleFonts.poppins(
                      color: Colors.red[800],
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      !hasActiveBooking &&
                              selectedDay != null &&
                              selectedSession != null &&
                              !isSessionFull(selectedDay!, selectedSession!)
                          ? () async {
                            try {
                              // Cari jadwal yang sesuai dengan hari dan sesi yang dipilih
                              final selectedJadwal = provider.jadwalList
                                  .firstWhere(
                                    (j) =>
                                        j.hari.toLowerCase() ==
                                            selectedDay!.toLowerCase() &&
                                        j.sesi == selectedSession!,
                                  );

                              // Tampilkan dialog konfirmasi
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: Text('Konfirmasi Pemesanan'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Apakah Anda yakin ingin memesan jadwal ini?',
                                          ),
                                          SizedBox(height: 8),
                                          Text('Hari: ${selectedDay}'),
                                          Text(
                                            'Tanggal: ${DateFormat.yMMMMd('id').format(DateTime.parse(selectedDate!))}',
                                          ),
                                          Text('Sesi: ${selectedSession}'),
                                          Text(
                                            'Konsultan: ${selectedJadwal.konsultanName}',
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, false),
                                          child: Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, true),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: greenColor,
                                          ),
                                          child: Text(
                                            'Ya, Pesan',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                              );

                              if (confirm == true) {
                                try {
                                  // Lakukan pemesanan
                                  await provider.bookSesi(
                                    widget.idUser,
                                    selectedJadwal.idJadwal,
                                  );

                                  // Tutup modal hanya jika pemesanan berhasil
                                  Navigator.pop(context);

                                  // Tampilkan notifikasi sukses
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Pemesanan berhasil!'),
                                      backgroundColor: Colors.green,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );

                                  // Tambahkan notifikasi lokal
                                  final NotificationService
                                  notificationService = NotificationService();
                                  await notificationService
                                      .showBookingSuccessNotification(
                                        title: 'Pemesanan Suscatin Berhasil!',
                                        body:
                                            '$selectedDay ${DateFormat.yMMMMd('id').format(DateTime.parse(selectedDate!))}\n'
                                            'Sesi: $selectedSession',
                                      );

                                  // Jadwalkan reminder untuk H-1 dan hari H
                                  await notificationService.scheduleReminders(
                                    selectedDate!,
                                    selectedSession! == "Sesi 1" ? 1 : 2,
                                  );
                                } catch (e) {
                                  // Tampilkan pesan error yang lebih bersih
                                  final errorMessage = e.toString().replaceAll(
                                    'Exception: ',
                                    '',
                                  );

                                  // Tampilkan snackbar di lapisan paling atas
                                  final overlay = Overlay.of(context);
                                  final overlayEntry = OverlayEntry(
                                    builder:
                                        (context) => Positioned(
                                          top:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.4,
                                          left:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.1,
                                          right:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.1,
                                          child: Material(
                                            color: Colors.transparent,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 12,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    blurRadius: 8,
                                                  ),
                                                ],
                                              ),
                                              child: Text(
                                                errorMessage,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                  );

                                  overlay.insert(overlayEntry);

                                  // Hapus overlay setelah 3 detik
                                  Future.delayed(Duration(seconds: 3), () {
                                    overlayEntry.remove();
                                  });
                                }
                              }
                            } catch (e) {
                              // Tampilkan pesan error
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Gagal melakukan pemesanan: ${e.toString()}',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        !hasActiveBooking &&
                                selectedDay != null &&
                                selectedSession != null &&
                                !isSessionFull(selectedDay!, selectedSession!)
                            ? greenColor
                            : Colors.grey,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Pesan",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

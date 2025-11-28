import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/jadwal_provider.dart';
import '../widgets/bottom_modal.dart';
import '../models/jadwal_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/pemesananCard.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class SuscatinPage extends StatefulWidget {
  final int idUser;
  SuscatinPage({super.key, required this.idUser});

  @override
  _SuscatinPageState createState() => _SuscatinPageState();
}

class _SuscatinPageState extends State<SuscatinPage> {
  String userName = "Pengguna";
  bool _isFirstBuild = true;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final provider = Provider.of<JadwalProvider>(context, listen: false);
        await Future.wait([
          _getUserName(),
          provider.fetchJadwal(),
          provider.fetchPemesananUser(widget.idUser),
        ]);
        // Tambahkan timer untuk memperbarui data setiap 30 detik
        _refreshTimer = Timer.periodic(Duration(seconds: 30), (_) async {
          if (mounted) {
            try {
              final provider = Provider.of<JadwalProvider>(
                context,
                listen: false,
              );
              await Future.wait([
                provider.fetchJadwal(),
                provider.fetchPemesananUser(widget.idUser),
              ]);
            } catch (e) {
              print('Error refreshing data: $e');
            }
          }
        });
      } catch (e) {
        print('Error initializing data: $e');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _refreshTimer?.cancel(); // Batalkan timer saat widget dihapus
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isFirstBuild) {
      // Gunakan setState untuk memastikan UI diperbarui setelah mendapatkan username baru
      _getUserName().then((_) {
        if (mounted) {
          setState(() {});
        }
      });
    }
    _isFirstBuild = false;
  }

  Future<void> _getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("user_name") ?? "Pengguna";
    });
  }

  final Color greenColor = Color(0xFF31502C);
  final Color greyColor = Color(0xFF5C5C5C);
  final Color blackColor = Color(0xFF1E1E1E);
  final Color yellowColor = Color(0xFFF3CD00);
  final Color redColor = Colors.red[800]!;

  @override
  Widget build(BuildContext context) {
    print("ID User di SuscatinPage: ${widget.idUser}");
    return Scaffold(
      body: Consumer<JadwalProvider>(
        builder: (context, provider, child) {
          if (provider.jadwalList.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          final grouped = groupJadwalByHariKonsultan(provider.jadwalList);

          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: ListView(
              children: [
                const SizedBox(height: 10),
                Text(
                  "Halo, $userName",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: blackColor,
                  ),
                ),
                const SizedBox(height: 16),
                _buildJadwalCard(),
                ...grouped.entries.map(
                  (hariEntry) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        hariEntry.key[0].toUpperCase() +
                            hariEntry.key.substring(1),
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: blackColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...hariEntry.value.entries.map(
                        (entry) => _buildScheduleItem(entry.key, entry.value),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Jika ada perubahan jadwal harap konfirmasi kepada pihak KUA dan melakukan penjadwalan ulang.",
                  style: GoogleFonts.poppins(fontSize: 11, color: greyColor),
                ),
                const SizedBox(height: 16),
                Text(
                  "Jadwal saya",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: blackColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                if (provider.jadwalUser.isNotEmpty)
                  ...provider.jadwalUser.map(
                    (jadwal) => Column(
                      children: [
                        buildPemesananCard(jadwal, () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: Text('Konfirmasi Pembatalan'),
                                  content: Text(
                                    'Apakah Anda yakin ingin membatalkan pemesanan ini?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: Text('Tidak'),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, true),
                                      child: Text(
                                        'Ya, Batalkan',
                                        style: GoogleFonts.poppins(
                                          color: redColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          );

                          if (confirm == true) {
                            try {
                              await Provider.of<JadwalProvider>(
                                context,
                                listen: false,
                              ).cancelSesi(widget.idUser, jadwal.idPemesanan);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Jadwal berhasil dibatalkan',
                                    style: GoogleFonts.poppins(),
                                  ),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Gagal membatalkan jadwal: ${e.toString()}',
                                    style: GoogleFonts.poppins(),
                                  ),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        }),
                        const SizedBox(height: 16),
                      ],
                    ),
                  )
                else
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      Image.asset(
                        'assets/images/empty_schedule.png',
                        height: 70,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.calendar_month,
                            size: 30,
                            color: greyColor,
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Belum ada jadwal yang dipesan",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: blackColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Silakan pesan jadwal terlebih dahulu",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: greyColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showScheduleModal(context, widget.idUser),
        backgroundColor: greenColor,
        child: const Icon(Icons.calendar_month, color: Colors.white),
      ),
    );
  }

  Widget _buildJadwalCard() {
    // Get unique dates from jadwalList
    final uniqueDates =
        Provider.of<JadwalProvider>(
            context,
            listen: true,
          ).jadwalList.map((j) => j.tanggal).toSet().toList()
          ..sort(); // Sort dates chronologically

    // Format dates for display
    final formattedDates = uniqueDates
        .map((date) {
          return DateFormat.yMMMMd(
            'id',
          ).format(DateTime.parse(date)); // Format date to Indonesian
        })
        .join(" & ");

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: greenColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Jadwal Suscatin",
                style: GoogleFonts.poppins(
                  color: yellowColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                formattedDates,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "KUA Pusaka Karawang Barat",
                style: GoogleFonts.poppins(
                  color: yellowColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Image.asset(
            'assets/images/image-banner.png',
            height: 70,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.image_not_supported,
                color: yellowColor,
                size: 40,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(String name, List<Jadwal> sessions) {
    // Urutkan sesi agar 09.00 - 11.00 di atas
    sessions.sort((a, b) => a.sesi.compareTo(b.sesi));
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(color: yellowColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Column(
            children: List.generate(sessions.length, (index) {
              final session = sessions[index];
              final isFull =
                  session.currentParticipants >= session.maxParticipants;
              final statusColor = isFull ? redColor : greenColor;
              final statusText =
                  isFull ? "Penuh" : "${session.currentParticipants} Pasangan";
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          session.sesi + " WIB",
                          style: TextStyle(fontSize: 14, color: greyColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          statusText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (index < sessions.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(color: yellowColor, thickness: 1),
                    ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Map<String, Map<String, List<Jadwal>>> groupJadwalByHariKonsultan(
    List<Jadwal> jadwalList,
  ) {
    final Map<String, Map<String, List<Jadwal>>> grouped = {};
    for (var jadwal in jadwalList) {
      final hari = jadwal.hari.toLowerCase();
      final konsultan = jadwal.konsultanName;
      grouped.putIfAbsent(hari, () => {});
      grouped[hari]!.putIfAbsent(konsultan, () => []);
      grouped[hari]![konsultan]!.add(jadwal);
    }
    return grouped;
  }
}

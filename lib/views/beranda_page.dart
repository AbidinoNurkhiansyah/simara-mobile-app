import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class BerandaPage extends StatefulWidget {
  BerandaPage({super.key});

  @override
  _BerandaPageState createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  final Color greenColor = Color(0xFF31502C);
  final Color greyColor = Color(0xFF636573);
  final Color blackColor = Color(0xFF3B3E51);
  final Color yellowColor = Color(0xFFF3CD00);

  void _openGoogleMaps() async {
    double latitude = -6.306323292223427; // Contoh: Monas
    double longitude = 107.30478128398964;

    final Uri url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw "Tidak dapat membuka Google Maps";
    }
  }

  final List<Map<String, dynamic>> steps = [
    {
      'title': 'Persiapkan dokumen yang dibutuhkan',
      'description': [
        "KTP calon pengantin",
        "Akta kelahiran atau kartu keluarga",
        "Surat pengantar dari kelurahan/desa atau catatan sipil",
        "Foto terbaru (biasanya ukuran 4x6)",
        "Surat izin dari orangtua (jika diperlukan, terutama bagi yang masih di bawah usia pernikahan)",
      ],
      'icon': 'assets/images/step1.png',
    },
    {
      'title': 'Datang Ke Kelurahan/Desa',
      'description': [
        "Di sana, Anda bisa mendaftar untuk mengikuti kursus SUSCATIN. Biasanya, Anda perlu mengisi formulir pendaftaran.",
      ],
      'icon': 'assets/images/step2.png',
    },
    {
      'title': 'Pendaftaran dan pembayaran',
      'description': [
        "Lakukan pendaftaran dengan mengisi formulir yang disediakan dan membayar biaya kursus jika ada (biaya bisa berbeda-beda tergantung lokasi dan lembaga). Pastikan Anda mengetahui jadwal kursus yang tersedia.",
      ],
      'icon': 'assets/images/step3.png',
    },
    {
      'title': 'Ikuti kursus',
      'description': [
        "Kursus calon pengantin biasanya berlangsung selama beberapa hari hingga beberapa minggu, tergantung pada kebijakan lembaga penyelenggara. Kursus ini akan mencakup materi terkait persiapan pernikahan, hukum perkawinan, kesehatan reproduksi, hingga etika rumah tangga.",
      ],
      'icon': 'assets/images/step4.png',
    },
    {
      'title': 'Ujian dan Sertifikat',
      'description': [
        "Setelah menyelesaikan kursus, biasanya ada ujian atau tes untuk menilai pemahaman Anda. Jika lulus, pasangan calon pengantin akan diberikan sertifikat sebagai bukti telah mengikuti kursus SUSCATIN.",
      ],
      'icon': 'assets/images/step5.png',
    },
    {
      'title': 'Lanjutkan ke Proses Pernikahan',
      'description': [
        "Setelah mendapatkan sertifikat SUSCATIN, Anda bisa melanjutkan proses pernikahan di KUA atau tempat yang Anda pilih sesuai dengan regulasi yang berlaku.",
      ],
      'icon': 'assets/images/step6.png',
    },
    {
      'title': 'Belum paham atau ada yang ingin di tanyakan?',
      'description': [
        "Silahkan hubungi kami untuk penjelasan lebih lanjut. Terima kasih.",
      ],
      'icon': '', // Tidak ada ikon untuk elemen ini
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: greenColor,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo-appbar.png',
              height: 30,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.image_not_supported, color: yellowColor);
              },
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "KUA PUSAKA KARAWANG BARAT",
                    style: GoogleFonts.poppins(
                      color: yellowColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Sistem Manajemen Data Religi & Agama",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              // Background Banner
              Container(
                width: double.infinity,
                height: 190,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/beranda_banner.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Overlay dengan informasi
              Container(
                width: double.infinity,
                height: 190,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                color: Colors.black.withOpacity(0.4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Kantor Urusan Agama\nKecamatan Karawang Barat",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: yellowColor,
                        ),
                        softWrap: true,
                      ),
                    ),
                    Text(
                      "Buka Senin - Jum'at 07.00 s/d 16.00",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: ElevatedButton(
                          onPressed: _openGoogleMaps,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize:
                                MainAxisSize
                                    .min, // Menghindari tombol terlalu lebar
                            children: [
                              Text(
                                "Kunjungi",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: greenColor,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ), // Memberi jarak antara teks dan ikon
                              Icon(
                                Icons.open_in_new,
                                size: 18,
                                color: greenColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          InkWell(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              color: greenColor,
              child: Text(
                "Tahap mendaftar ke-Suscatin",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: steps.length,
              separatorBuilder: (context, index) => SizedBox(height: 25),
              itemBuilder: (context, index) {
                final step = steps[index];
                final isLastItem =
                    index == steps.length - 1; // Cek apakah elemen terakhir
                return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isLastItem) // Tampilkan nomor dan judul hanya jika bukan elemen terakhir
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: greenColor,
                              radius: 18,
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: yellowColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                step['title'],
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: blackColor,
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      if (isLastItem) // Tampilkan judul tanpa nomor untuk elemen terakhir
                        Container(
                          child: Text(
                            step['title'],
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: greenColor,
                            ),
                          ),
                        ),
                      SizedBox(height: 20),
                      if (step['icon'] != null &&
                          step['icon']!.isNotEmpty &&
                          !isLastItem)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.transparent,
                              child: Image.asset(
                                step['icon'],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.image_not_supported,
                                    color: yellowColor,
                                    size: 30,
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                  step['description'].length,
                                  (i) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 2,
                                      ),
                                      child: Text(
                                        '${i + 1}. ${step['description'][i]}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: greenColor,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                      else // Tampilkan deskripsi tanpa ikon untuk elemen terakhir
                        Container(
                          child: Text(
                            step['description'].join('\n'),
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: greenColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

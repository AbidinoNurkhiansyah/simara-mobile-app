import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';

class ContohFormulirPernikahanPage extends StatelessWidget {
  ContohFormulirPernikahanPage({super.key});

  final Color greenColor = Color(0xFF31502C);

  final List<Map<String, String>> formulirList = const [
    {'title': 'Formulir N1', 'image': 'assets/images/form-n1.png', 'tag': 'n1'},
    {'title': 'Formulir N2', 'image': 'assets/images/form-n2.png', 'tag': 'n2'},
    {'title': 'Formulir N3', 'image': 'assets/images/form-n3.png', 'tag': 'n3'},
    {'title': 'Formulir N4', 'image': 'assets/images/form-n4.png', 'tag': 'n4'},
    {'title': 'Formulir N5', 'image': 'assets/images/form-n5.png', 'tag': 'n5'},
    {'title': 'Formulir N6', 'image': 'assets/images/form-n6.png', 'tag': 'n6'},
    {'title': 'Formulir N7', 'image': 'assets/images/form-n7.png', 'tag': 'n7'},
    {'title': 'Formulir N8', 'image': 'assets/images/form-n8.png', 'tag': 'n8'},
    {
      'title': 'Formulir N9 1',
      'image': 'assets/images/form-n9[1].png',
      'tag': 'n9',
    },
    {
      'title': 'Formulir N9 2',
      'image': 'assets/images/form-n9[2].png',
      'tag': 'n9',
    },
    {
      'title': 'Surat Pernyataan Belum Nikah',
      'image': 'assets/images/form-pbn.png',
      'tag': 'pbn',
    },
    {
      'title': 'Surat Keterangan Numpang Nikah',
      'image': 'assets/images/form-sknn.png',
      'tag': 'sknn',
    },
    {
      'title': 'Surat Keterangan Wali Nikah',
      'image': 'assets/images/form-skwn.png',
      'tag': 'sknn',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: greenColor,
        title: Text(
          'Contoh Formulir Pernikahan',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 20),
          children: [
            // Banner
            Image.asset(
              'assets/images/banner-form-nikah.png',
              fit: BoxFit.cover,
            ),
            // Judul
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Berikut adalah contoh Formulir Pencatatan Nikah',
                style: GoogleFonts.poppins(
                  color: greenColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // List Formulir
            ...formulirList.map((form) {
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8.0,
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => FullscreenImagePage(
                                tag: form['tag']!,
                                imagePath: form['image']!,
                              ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: greenColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.insert_drive_file,
                              color: greenColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  form['title']!,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Tap untuk lihat',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.chevron_right,
                            color: greenColor,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

// =====================
// Fullscreen + Zoomable Page
// =====================
class FullscreenImagePage extends StatelessWidget {
  final String tag;
  final String imagePath;

  const FullscreenImagePage({
    super.key,
    required this.tag,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: Hero(
            tag: tag,
            child: PhotoView(
              imageProvider: AssetImage(imagePath),
              backgroundDecoration: const BoxDecoration(color: Colors.black),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 3,
            ),
          ),
        ),
      ),
    );
  }
}

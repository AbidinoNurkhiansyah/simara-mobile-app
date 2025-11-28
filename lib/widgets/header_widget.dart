// This widget will draw header section of all page. Wich you will get with the project source code.

import 'package:flutter/material.dart';

class HeaderWidget extends StatefulWidget {
  final double _height;
  final bool _showImage;
  final String? imagePath;

  const HeaderWidget(this._height, this._showImage, {this.imagePath, Key? key})
    : super(key: key);

  @override
  _HeaderWidgetState createState() =>
      _HeaderWidgetState(_height, _showImage, imagePath);
}

class _HeaderWidgetState extends State<HeaderWidget> {
  double _height;
  bool _showImage;
  String? _imagePath;

  _HeaderWidgetState(this._height, this._showImage, this._imagePath);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      child: Stack(
        children: [
          ClipPath(
            child: Container(
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  colors: [
                    // ignore: deprecated_member_use
                    Theme.of(context).primaryColor.withOpacity(0.4),
                    // ignore: deprecated_member_use
                    Theme.of(context).colorScheme.secondary.withOpacity(0.4),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
            ),
            clipper: new ShapeClipper([
              Offset(width / 5, _height),
              Offset(width / 10 * 5, _height - 60),
              Offset(width / 5 * 4, _height + 20),
              Offset(width, _height - 18),
            ]),
          ),
          ClipPath(
            child: Container(
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  colors: [
                    // ignore: deprecated_member_use
                    Theme.of(context).primaryColor.withOpacity(0.4),
                    // ignore: deprecated_member_use
                    Theme.of(context).colorScheme.secondary.withOpacity(0.4),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
            ),
            clipper: new ShapeClipper([
              Offset(width / 3, _height + 20),
              Offset(width / 10 * 8, _height - 60),
              Offset(width / 5 * 4, _height - 60),
              Offset(width, _height - 20),
            ]),
          ),
          ClipPath(
            child: Container(
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).colorScheme.secondary,
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
            ),
            clipper: new ShapeClipper([
              Offset(width / 5, _height),
              Offset(width / 2, _height - 40),
              Offset(width / 5 * 4, _height - 80),
              Offset(width, _height - 20),
            ]),
          ),
          Visibility(
            visible: _showImage,
            child: SizedBox(
              height: _height * 0.6, // Sesuaikan tinggi logo agar proporsional
              child: Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.transparent, // Efek bayangan
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    _imagePath!,
                    width:
                        MediaQuery.of(context).size.width *
                        0.5, // 50% dari layar
                    height: _height * 0.7, // 40% dari tinggi header
                    fit: BoxFit.contain, // Supaya gambar tidak terpotong
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShapeClipper extends CustomClipper<Path> {
  List<Offset> _offsets = [];
  ShapeClipper(this._offsets);
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height - 20);

    // path.quadraticBezierTo(size.width/5, size.height, size.width/2, size.height-40);
    // path.quadraticBezierTo(size.width/5*4, size.height-80, size.width, size.height-20);

    path.quadraticBezierTo(
      _offsets[0].dx,
      _offsets[0].dy,
      _offsets[1].dx,
      _offsets[1].dy,
    );
    path.quadraticBezierTo(
      _offsets[2].dx,
      _offsets[2].dy,
      _offsets[3].dx,
      _offsets[3].dy,
    );

    // path.lineTo(size.width, size.height-20);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

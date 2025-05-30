import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ConvexAppBar(
      backgroundColor: Color(0xFF31502C),
      color: Colors.white,
      activeColor: Color.fromRGBO(243, 205, 0, 1),
      style: TabStyle.react,
      initialActiveIndex: currentIndex,
      items: [
        TabItem(icon: Icons.home, title: 'Beranda'),
        TabItem(icon: Icons.book, title: 'Suscatin'),
        TabItem(icon: Icons.person, title: 'Profil'),
      ],
      onTap: onTap,
    );
  }
}

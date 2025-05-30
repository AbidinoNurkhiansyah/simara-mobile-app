import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/views/index.dart';
import 'providers/auth_provider.dart';
import 'providers/jadwal_provider.dart';
import 'providers/navigation_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/user_provider.dart';
import 'services/notification_service.dart';
import 'views/auth/login_page.dart';
import 'views/splash_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  // Initialize notification service
  await NotificationService().init();

  final authProvider = MyAuthProvider();
  await authProvider.loadUserData();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => JadwalProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simara App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 62, 101, 56),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/home': (context) => IndexScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

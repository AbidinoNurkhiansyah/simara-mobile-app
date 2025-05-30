import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/auth_controller.dart';
import '../../utilities/snackbar_helper.dart';
import '../../widgets/buildTextField.dart';
import '../../widgets/header_widget.dart';
import '../index.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<void> saveUserId(int idUser) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('idUser', idUser);
  }

  final double _headerHeight = 250;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = AuthController();
  bool isPasswordVisible = false;

  void login() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await authController.login(
          emailController.text,
          passwordController.text,
        );
        if (response['status'] == 'success') {
          final prefs = await SharedPreferences.getInstance();
          final idUser =
              response['idUser'] ??
              response['id_user'] ??
              (response['user']?['id_user']);
          if (idUser != null) {
            await prefs.setInt('idUser', int.parse(idUser.toString()));
            showCustomSnackbar(context, "Login Berhasil!", true);
            Future.delayed(Duration(seconds: 1), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => IndexScreen()),
              );
            });
          } else {
            showCustomSnackbar(
              context,
              "Login Berhasil, tapi id user tidak ditemukan!",
              false,
            );
          }
        } else {
          showCustomSnackbar(
            context,
            "Login Gagal: ${response['message']}",
            false,
          );
        }
      } catch (e) {
        showCustomSnackbar(context, "Terjadi kesalahan: $e", false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: _headerHeight,
              child: HeaderWidget(
                _headerHeight,
                true,
                imagePath: 'assets/images/logo-simara.png',
              ),
            ),
            SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                margin: EdgeInsets.fromLTRB(0, 30, 0, 30),
                child: Column(
                  children: [
                    Text(
                      'Selamat Datang',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'Masuk Dengan Akun Anda',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 30.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          buildTextField(
                            controller: emailController,
                            label: 'Email',
                            hint: 'Masukkan Email anda',
                            prefixIcon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Email Tidak boleh kosong";
                              }
                              if (!RegExp(r'[@":{}|<>]').hasMatch(value)) {
                                return 'Email harus mengandung @gmail.com';
                              }
                              return null;
                            },
                          ),
                          buildTextField(
                            controller: passwordController,
                            label: 'Kata Sandi',
                            hint: 'Masukkan Kata Sandi anda',
                            obscureText: !isPasswordVisible,
                            prefixIcon: Icons.lock,
                            keyboardType: TextInputType.text,
                            suffixIcon: IconButton(
                              icon: Icon(
                                isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                            ),
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "Kata sandi tidak boleh kosong";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  login();
                                }
                              },
                              child: const Text(
                                "Masuk",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.all(20.0),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(text: "Belum punya akun? "),
                                  TextSpan(
                                    text: 'Daftar',

                                    recognizer:
                                        TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                              context,
                                              PageTransition(
                                                type:
                                                    PageTransitionType
                                                        .fade, // Jenis animasi
                                                duration: Duration(
                                                  milliseconds: 600,
                                                ), // Durasi transisi
                                                child:
                                                    RegisterPage(), // Tujuan halaman
                                              ),
                                            );
                                          },
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

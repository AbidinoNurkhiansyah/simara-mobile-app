import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_page.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/buildTextField.dart';
import '../../widgets/header_widget.dart';
import '../../utilities/snackbar_helper.dart';
import 'package:page_transition/page_transition.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nohpController = TextEditingController();
  final TextEditingController domisiliController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = AuthController();
  bool isPasswordVisible = false;

  void register(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final response = await authController.register(
        nameController.text,
        emailController.text,
        nohpController.text,
        domisiliController.text,
        passwordController.text,
      );

      if (response != null && response.containsKey('status')) {
        showCustomSnackbar(
          context,
          response['message'],
          response['status'] == 'success',
        );

        if (response['status'] == 'success') {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false,
          );
        }
      } else {
        throw Exception("Response tidak valid");
      }
    } catch (e) {
      showCustomSnackbar(context, "Gagal mendaftar: $e", false);
    }
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kata sandi tidak boleh kosong';
    }
    if (value.length < 8) {
      return 'Kata sandi minimal 8 karakter';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Kata sandi harus mengandung huruf besar';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Kata sandi harus mengandung huruf kecil';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Kata sandi harus mengandung angka';
    }
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Kata sandi harus mengandung karakter spesial (!@#\$%^&*)';
    }
    return null; // ✅ Jika semua validasi lolos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SizedBox(
              height: 150,
              child: HeaderWidget(
                150,
                false,
                imagePath: 'assets/images/logo_simara.png',
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(16, 50, 16, 10),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/images/logo-simara.png',
                            width: 150,
                            height: 150,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'Daftar Sekarang',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          'Atur jadwal Suscatin jadi lebih Mudah',
                          style: TextStyle(color: Colors.grey),
                        ),

                        const SizedBox(height: 30),
                        buildTextField(
                          controller: nameController,
                          label: 'Nama Lengkap',
                          hint: 'Masukkan Nama Lengkap anda',
                          keyboardType: TextInputType.text,
                          prefixIcon: Icons.person,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Nama Lengkap Tidak boleh kosong";
                            }
                            return null;
                          },
                        ),
                        buildTextField(
                          controller: emailController,
                          label: 'Email',
                          hint: 'Masukkan Akun Email anda',
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
                          controller: nohpController,
                          label: 'No Handphone',
                          hint: 'Masukkan Nomor Handphone anda',
                          prefixIcon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Nomor HP tidak boleh kosong";
                            } else if (!RegExp(
                              r'^[0-9]{10,13}$',
                            ).hasMatch(value)) {
                              return "Masukkan nomor HP yang valid (10-13 digit angka)";
                            }
                            return null; // ✅ Jika valid, error akan hilang
                          },
                        ),
                        buildTextField(
                          controller: domisiliController,
                          label: 'Domisili',
                          hint: 'Masukkan Domisili anda',
                          keyboardType: TextInputType.text,
                          prefixIcon: Icons.location_on,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Domisili tidak boleh kosong";
                            }
                            return null;
                          },
                        ),
                        buildTextField(
                          controller: passwordController,
                          label: 'Kata Sandi',
                          hint: 'Masukkan Kata Sandi anda',
                          obscureText: !isPasswordVisible,
                          keyboardType: TextInputType.text,
                          prefixIcon: Icons.lock,
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
                          validator: validatePassword, // ✅ Tambahkan validator
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: SizedBox(
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
                                  register(context);
                                }
                              },
                              child: const Text(
                                "Daftar",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(text: "Sudah punya akun? "),
                                TextSpan(
                                  text: 'Masuk',
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              child: LoginPage(),
                                              type: PageTransitionType.fade,
                                              duration: const Duration(
                                                milliseconds: 600,
                                              ),
                                            ),
                                          );
                                        },
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
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
          ],
        ),
      ),
    );
  }
}

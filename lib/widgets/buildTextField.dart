import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/utilities/theme_helper.dart'; // Ganti dengan path yang sesuai

/// Fungsi buildTextField dipisahkan agar lebih reusable
Widget buildTextField({
  required TextEditingController controller,
  required String label,
  required String hint,
  bool obscureText = false,
  TextInputType keyboardType = TextInputType.text,
  List<TextInputFormatter>? inputFormatters,
  IconData? prefixIcon,
  Widget? suffixIcon,
  String? Function(String?)? validator,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Container(
      decoration: ThemeHelper().inputBoxDecorationShaddow(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            autovalidateMode:
                AutovalidateMode.onUserInteraction, // ✅ Solusi utama
            decoration: ThemeHelper()
                .textInputDecoration(label, hint)
                .copyWith(
                  label: Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                    ), // atur sesuai kebutuhan
                    child: Text(label),
                  ),
                  prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
                  suffixIcon: suffixIcon,
                  contentPadding: const EdgeInsets.only(
                    bottom: 20,
                  ), // <-- Atur tinggi di sini
                ),
            validator: validator,
          ),
        ],
      ),
    ),
  );
}

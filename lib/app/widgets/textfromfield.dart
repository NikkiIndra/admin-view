import 'package:flutter/material.dart';

import '../styles/apps_colors.dart';
import '../styles/apps_style.dart';

class TextFromFieldTemplate extends StatelessWidget {
  const TextFromFieldTemplate({
    super.key,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.isPassword = false,
    this.isPasswordHidden = true,
    this.onToggle,
    required this.controller,
  });

  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool isPassword;
  final bool isPasswordHidden;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppStyles.bodyTextBlack.copyWith(
              fontSize: 13,
              color: Colors.black87,
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 12,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            fillColor: AppColors.white35,
            filled: true,
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isPasswordHidden
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: onToggle,
                  )
                : null,
          ),
          keyboardType: keyboardType,
          obscureText: isPassword ? isPasswordHidden : obscureText,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

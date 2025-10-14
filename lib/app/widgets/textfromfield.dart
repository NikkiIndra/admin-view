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
    this.validator,
    this.onTap,
    this.onChanged,
    this.errorText,
  });

  final Function()? onTap;
  final Function(String)? onChanged;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool isPassword;
  final bool isPasswordHidden;
  final VoidCallback? onToggle;

  /// Tambahan baru — validator
  final FormFieldValidator<String>? validator;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          onTap: onTap,
          onChanged: onChanged,
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isPassword ? isPasswordHidden : obscureText,
          validator: validator, // <-- gunakan di sini
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppStyles.bodyTextBlack.copyWith(
              fontSize: 13,
              color: Colors.black87,
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.bluePrimary),
            ),
            fillColor: AppColors.white35,
            filled: true,
            errorText: errorText,
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
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

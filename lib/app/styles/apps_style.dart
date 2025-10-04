// app_styles.dart
import 'package:flutter/material.dart';

import 'apps_colors.dart';

class AppStyles {
  static const TextStyle authText = TextStyle(
    fontFamily: "KeaniaOne",
    fontSize: 50,
    fontWeight: FontWeight.w300,
    color: Color(0xFFFFFEFE),
  );

  static const TextStyle bodyTextWhite = TextStyle(
    fontFamily: "Outfit",
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );
  static const TextStyle bodyTextBlack = TextStyle(
    fontFamily: "Outfit",
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  static const TextStyle teksButtonKeania = TextStyle(
    fontSize: 16,
    fontFamily: "KeaniaOne",
    color: Color(0xFF070707),
  );

  static const TextStyle teksButtonOutfit = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    fontFamily: "Outfit",
    color: Color(0xFF070707),
  );

  // Button style (gradient)
  static ButtonStyle elevatedButtonStyleWhite = ElevatedButton.styleFrom(
    elevation: 2,
    backgroundColor: AppColors.white35, // default biru
    foregroundColor: AppColors.white35, // warna teks/icon
    shadowColor: AppColors.white35, // warna shadow
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
  );
  static ButtonStyle elevatedButtonStylePurpel = ElevatedButton.styleFrom(
    elevation: 2,
    backgroundColor: AppColors.bluePrimary, // default biru
    foregroundColor: AppColors.white80, // warna teks/icon
    shadowColor: AppColors.white35, // warna shadow
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
  );
}

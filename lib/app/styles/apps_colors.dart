import 'package:flutter/material.dart';

class AppColors {
  static const Color white80 = Color.fromRGBO(255, 255, 255, 0.8); // putih 80%
  static const Color bluePrimary = Color(0xFF2630E9); // biru solid
  static const Color white35 = Color.fromRGBO(255, 255, 255, 0.35); // putih 35%
  static LinearGradient primaryGradien = LinearGradient(
    colors: [Color(0xFF000000).withOpacity(0.15), Color(0xFF0022FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

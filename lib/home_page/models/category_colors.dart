import 'package:flutter/material.dart';

class CategoryColors {
   static Color? returnColorByCategoryID(int categoryID) {
    switch (categoryID) {
      case 1:
        return const Color(0xFFB1E193);
      case 2:
        return const Color(0xFFF2E7C1);
      case 3:
        return const Color(0xFF964B00);
      case 4:
        return const Color(0xFFCD853F);
      case 5:
        return const Color(0xFF0072BB);
      case 6:
        return const Color(0xFFFFBC6D);
      case 7:
        return const Color(0xFF93E1D8);
      case 8:
        return const Color(0xFF9F8A3C);
    }
    return null;
  }
}
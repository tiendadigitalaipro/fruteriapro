import 'package:flutter/material.dart';

/// Identidad "mercado tropical": naranja fruta sobre verde bosque casi
/// negro — hereda la paleta ya usada en la web de Frutería Pro (naranja
/// #f77f00 + verdes #1b4332/#2d6a4f/#52b788), y es distinta de BarberFlow
/// (dorado), ZYNC (cian), Mercado Logic Pro (terracota) y Nail Studio Pro
/// (fucsia).
class AppColors {
  static const orange = Color(0xFFF77F00);
  static const orangeDim = Color(0xFFC96500);
  static const green = Color(0xFF52B788);
  static const background = Color(0xFF0D1410);
  static const surface = Color(0xFF14211A);
  static const surfaceLight = Color(0xFF1C2E23);
}

class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.orange,
        secondary: AppColors.green,
        surface: AppColors.surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.orange,
        elevation: 0,
        centerTitle: false,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.surface,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.orange,
        foregroundColor: Colors.black,
      ),
      fontFamily: 'Roboto',
    );
  }
}

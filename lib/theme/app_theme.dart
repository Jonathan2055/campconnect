import 'package:flutter/material.dart';

class AppColors {
  static const dark = Color(0xFF0D1117);
  static const bg = Color(0xFFEFF6FF);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceAlt = Color(0xFFE0EFFE);
  // accent (kept as "gold" throughout the app for compatibility)
  static const emerald = Color(0xFF059669);
  static const onEmerald = Color(0xFFFFFFFF);
  static const purple = Color(0xFF4F46E5);  // indigo
  static const blue = Color(0xFF0EA5E9);    // sky blue
  static const green = Color(0xFF16A34A);   // vivid green
  static const pink = Color(0xFFF43F5E);    // rose
  static const teal = Color(0xFF0D9488);    // teal
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF64748B);
  static const border = Color(0xFFCBD5E1);
}

class AppTheme {
  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: base.colorScheme.copyWith( 
        primary: AppColors.emerald,
        onPrimary: AppColors.onEmerald,
        secondary: AppColors.blue,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.emerald, width: 1.5),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.dark,
        indicatorColor: AppColors.emerald.withValues(alpha: 0.18),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            color: selected ? AppColors.emerald : Colors.white54,
            fontSize: 11,
            fontWeight:
                selected ? FontWeight.w600 : FontWeight.normal,
          );
        }),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
    );
  }
}

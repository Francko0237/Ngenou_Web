import 'package:material_ui/material_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Configuration du thème global Material 3 de Ngenou Web
class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    // Évite le conflit TextTheme entre material_ui et flutter
    // en construisant chaque style directement.
    final base = ThemeData.dark();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.card,
        primary: AppColors.cyan,
        secondary: AppColors.gold,
        onSurface: AppColors.text,
        onPrimary: AppColors.background,
        onSecondary: AppColors.background,
        error: AppColors.error,
        onError: Colors.white,
      ),
      textTheme: base.textTheme.copyWith(
        displayLarge: GoogleFonts.fraunces(
          color: AppColors.text,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          fontSize: base.textTheme.displayLarge?.fontSize,
        ),
        displayMedium: GoogleFonts.fraunces(
          color: AppColors.text,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          fontSize: base.textTheme.displayMedium?.fontSize,
        ),
        displaySmall: GoogleFonts.fraunces(
          color: AppColors.text,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
          fontSize: base.textTheme.displaySmall?.fontSize,
        ),
        headlineLarge: GoogleFonts.fraunces(
          color: AppColors.text,
          fontWeight: FontWeight.w700,
          fontSize: base.textTheme.headlineLarge?.fontSize,
        ),
        headlineMedium: GoogleFonts.fraunces(
          color: AppColors.text,
          fontWeight: FontWeight.w600,
          fontSize: base.textTheme.headlineMedium?.fontSize,
        ),
        headlineSmall: GoogleFonts.fraunces(
          color: AppColors.text,
          fontWeight: FontWeight.w600,
          fontSize: base.textTheme.headlineSmall?.fontSize,
        ),
        titleLarge: GoogleFonts.manrope(
          color: AppColors.text,
          fontWeight: FontWeight.w700,
          fontSize: base.textTheme.titleLarge?.fontSize,
        ),
        titleMedium: GoogleFonts.manrope(
          color: AppColors.text,
          fontWeight: FontWeight.w600,
          fontSize: base.textTheme.titleMedium?.fontSize,
        ),
        titleSmall: GoogleFonts.manrope(
          color: AppColors.textMuted,
          fontWeight: FontWeight.w500,
          fontSize: base.textTheme.titleSmall?.fontSize,
        ),
        bodyLarge: GoogleFonts.manrope(
          color: AppColors.text,
          height: 1.6,
          fontSize: base.textTheme.bodyLarge?.fontSize,
        ),
        bodyMedium: GoogleFonts.manrope(
          color: AppColors.textMuted,
          height: 1.5,
          fontSize: base.textTheme.bodyMedium?.fontSize,
        ),
        bodySmall: GoogleFonts.manrope(
          color: AppColors.textMuted,
          height: 1.4,
          fontSize: base.textTheme.bodySmall?.fontSize,
        ),
        labelLarge: GoogleFonts.manrope(
          color: AppColors.text,
          fontWeight: FontWeight.w600,
          fontSize: base.textTheme.labelLarge?.fontSize,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF0B1426),
        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
        labelStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.cyan, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cyan,
          foregroundColor: AppColors.background,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.manrope(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.text,
          side: const BorderSide(color: AppColors.cardBorder),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.manrope(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.cardBorder),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.cardBorder,
        thickness: 1,
      ),
    );
  }
}

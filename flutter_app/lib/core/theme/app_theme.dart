import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Modernized color palette — indigo/violet primary with warm accent.
class AppColors {
  AppColors._();

  // Primary — deep indigo
  static const primary = Color(0xFF4F46E5);
  static const primaryLight = Color(0xFF818CF8);
  static const primaryDark = Color(0xFF1E1B4B);
  static const primaryBg = Color(0xFFEEF2FF);

  // Accent — warm amber
  static const accent = Color(0xFFF59E0B);
  static const accentLight = Color(0xFFFCD34D);
  static const accentDark = Color(0xFFD97706);

  // Surfaces
  static const background = Color(0xFFF8F9FC);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceAlt = Color(0xFFF1F5F9);
  static const surfaceHover = Color(0xFFE2E8F0);

  // Sidebar gradient
  static const sidebarStart = Color(0xFF1E1B4B);
  static const sidebarEnd = Color(0xFF312E81);

  // Text
  static const text = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF64748B);
  static const textLight = Color(0xFF94A3B8);
  static const textInverse = Color(0xFFFFFFFF);

  // Borders
  static const border = Color(0xFFE2E8F0);
  static const borderLight = Color(0xFFF1F5F9);

  // Status colors
  static const success = Color(0xFF10B981);
  static const successBg = Color(0xFFECFDF5);
  static const warning = Color(0xFFF59E0B);
  static const warningBg = Color(0xFFFEF3C7);
  static const danger = Color(0xFFEF4444);
  static const dangerBg = Color(0xFFFEE2E2);
  static const info = Color(0xFF3B82F6);
  static const infoBg = Color(0xFFEFF6FF);

  // Extended palette
  static const purple = Color(0xFF8B5CF6);
  static const purpleBg = Color(0xFFF5F3FF);
  static const pink = Color(0xFFEC4899);
  static const pinkBg = Color(0xFFFDF2F8);
  static const teal = Color(0xFF14B8A6);
  static const tealBg = Color(0xFFF0FDFA);

  // Basics
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const overlay = Color(0x990F172A);
}

/// Spacing scale (in logical pixels).
class AppSpacing {
  AppSpacing._();

  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
  static const xxxl = 64.0;
}

/// Border radius scale.
class AppRadius {
  AppRadius._();

  static const sm = 6.0;
  static const md = 10.0;
  static const lg = 14.0;
  static const xl = 20.0;
  static const xxl = 28.0;
  static const pill = 999.0;
}

/// Font size scale.
class AppFontSize {
  AppFontSize._();

  static const xs = 11.0;
  static const sm = 13.0;
  static const md = 15.0;
  static const lg = 18.0;
  static const xl = 22.0;
  static const xxl = 28.0;
  static const title = 34.0;
  static const hero = 42.0;
}

/// Layout constants.
class AppLayout {
  AppLayout._();

  static const sidebarWidth = 280.0;
  static const tabBarHeight = 60.0;
  static const headerHeight = 64.0;
}

/// Pre-built shadow lists.
class AppShadows {
  AppShadows._();

  static const List<BoxShadow> sm = [
    BoxShadow(color: Color(0x0F0F4C75), offset: Offset(0, 1), blurRadius: 3),
  ];

  static const List<BoxShadow> md = [
    BoxShadow(color: Color(0x140F4C75), offset: Offset(0, 2), blurRadius: 8),
  ];

  static const List<BoxShadow> lg = [
    BoxShadow(color: Color(0x1A0F4C75), offset: Offset(0, 4), blurRadius: 16),
  ];

  static const List<BoxShadow> xl = [
    BoxShadow(color: Color(0x24062B3D), offset: Offset(0, 8), blurRadius: 24),
  ];

  static const List<BoxShadow> glow = [
    BoxShadow(color: Color(0x404F46E5), offset: Offset(0, 2), blurRadius: 12),
  ];
}

/// Complete app theme.
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surface,
        error: AppColors.danger,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.interTextTheme().copyWith(
        headlineLarge: GoogleFonts.inter(
          fontSize: AppFontSize.xxl,
          fontWeight: FontWeight.bold,
          color: AppColors.text,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: AppFontSize.xl,
          fontWeight: FontWeight.bold,
          color: AppColors.text,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: AppFontSize.lg,
          fontWeight: FontWeight.bold,
          color: AppColors.text,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: AppFontSize.md,
          fontWeight: FontWeight.w600,
          color: AppColors.text,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: AppFontSize.md,
          color: AppColors.text,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: AppFontSize.sm,
          color: AppColors.textSecondary,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: AppFontSize.xs,
          color: AppColors.textLight,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: AppFontSize.sm,
          fontWeight: FontWeight.w600,
          color: AppColors.text,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.text,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: AppFontSize.lg,
          fontWeight: FontWeight.bold,
          color: AppColors.text,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceAlt,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: AppColors.primaryLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: AppColors.danger, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 2,
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: AppFontSize.sm,
          color: AppColors.textSecondary,
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: AppFontSize.sm,
          color: AppColors.textLight,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm + 4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: AppFontSize.md,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primaryLight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
    );
  }
}

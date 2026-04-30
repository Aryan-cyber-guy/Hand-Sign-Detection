import 'package:flutter/material.dart';

// ─── Access tokens anywhere: context.colors.accent ───────────────────────────
extension AppColorsX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}

// ─── Theme definitions ────────────────────────────────────────────────────────
class AppTheme {
  static const cyan   = Color(0xFF00FFFF);
  static const purple = Color(0xFF8A2BE2);

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFF0F1729),
    colorScheme: const ColorScheme.dark(
      primary:   cyan,
      secondary: purple,
      surface:   Color(0xFF1A0F2E),
    ),
    extensions: const [_dark],
  );

  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFF0F4FF),
    colorScheme: const ColorScheme.light(
      primary:   Color(0xFF0066CC),
      secondary: Color(0xFF7C3AED),
      surface:   Colors.white,
    ),
    extensions: const [_light],
  );

  static const _dark = AppColors(
    bgPage:       Color(0xFF0F1729),
    bgCard:       Color(0x0DFFFFFF),
    bgCardStrong: Color(0x1AFFFFFF),
    border:       Color(0x1FFFFFFF),
    textPrimary:  Colors.white,
    textSecondary:Color(0xB3FFFFFF),
    textMuted:    Color(0x66FFFFFF),
    accent:       Color(0xFF00FFFF),
    accentSoft:   Color(0x3300FFFF),
    navBg:        Color(0x14FFFFFF),
    navBorder:    Color(0x33FFFFFF),
    gradStart:    Color(0xFF0A0A1F),
    gradMid:      Color(0xFF1A0F2E),
    gradEnd:      Color(0xFF0F1729),
    isDark:       true,
  );

  static const _light = AppColors(
    bgPage:       Color(0xFFF0F4FF),
    bgCard:       Colors.white,
    bgCardStrong: Color(0xFFF8FAFF),
    border:       Color(0x1A0000FF),
    textPrimary:  Color(0xFF0D1B3E),
    textSecondary:Color(0xFF3D5A80),
    textMuted:    Color(0xFF8899AA),
    accent:       Color(0xFF0066CC),
    accentSoft:   Color(0x200066CC),
    navBg:        Color(0xF0FFFFFF),
    navBorder:    Color(0x33000080),
    gradStart:    Color(0xFFE8F0FE),
    gradMid:      Color(0xFFDDE8FF),
    gradEnd:      Color(0xFFF0F4FF),
    isDark:       false,
  );
}

// ─── Token extension ─────────────────────────────────────────────────────────
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.bgPage,
    required this.bgCard,
    required this.bgCardStrong,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.accent,
    required this.accentSoft,
    required this.navBg,
    required this.navBorder,
    required this.gradStart,
    required this.gradMid,
    required this.gradEnd,
    required this.isDark,
  });

  final Color bgPage, bgCard, bgCardStrong;
  final Color border;
  final Color textPrimary, textSecondary, textMuted;
  final Color accent, accentSoft;
  final Color navBg, navBorder;
  final Color gradStart, gradMid, gradEnd;
  final bool  isDark;

  @override
  AppColors copyWith({
    Color? bgPage, Color? bgCard, Color? bgCardStrong,
    Color? border,
    Color? textPrimary, Color? textSecondary, Color? textMuted,
    Color? accent, Color? accentSoft,
    Color? navBg, Color? navBorder,
    Color? gradStart, Color? gradMid, Color? gradEnd,
    bool?  isDark,
  }) => AppColors(
    bgPage:       bgPage       ?? this.bgPage,
    bgCard:       bgCard       ?? this.bgCard,
    bgCardStrong: bgCardStrong ?? this.bgCardStrong,
    border:       border       ?? this.border,
    textPrimary:  textPrimary  ?? this.textPrimary,
    textSecondary:textSecondary?? this.textSecondary,
    textMuted:    textMuted    ?? this.textMuted,
    accent:       accent       ?? this.accent,
    accentSoft:   accentSoft   ?? this.accentSoft,
    navBg:        navBg        ?? this.navBg,
    navBorder:    navBorder    ?? this.navBorder,
    gradStart:    gradStart    ?? this.gradStart,
    gradMid:      gradMid      ?? this.gradMid,
    gradEnd:      gradEnd      ?? this.gradEnd,
    isDark:       isDark       ?? this.isDark,
  );

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      bgPage:       Color.lerp(bgPage,       other.bgPage,       t)!,
      bgCard:       Color.lerp(bgCard,       other.bgCard,       t)!,
      bgCardStrong: Color.lerp(bgCardStrong, other.bgCardStrong, t)!,
      border:       Color.lerp(border,       other.border,       t)!,
      textPrimary:  Color.lerp(textPrimary,  other.textPrimary,  t)!,
      textSecondary:Color.lerp(textSecondary,other.textSecondary,t)!,
      textMuted:    Color.lerp(textMuted,    other.textMuted,    t)!,
      accent:       Color.lerp(accent,       other.accent,       t)!,
      accentSoft:   Color.lerp(accentSoft,   other.accentSoft,   t)!,
      navBg:        Color.lerp(navBg,        other.navBg,        t)!,
      navBorder:    Color.lerp(navBorder,    other.navBorder,    t)!,
      gradStart:    Color.lerp(gradStart,    other.gradStart,    t)!,
      gradMid:      Color.lerp(gradMid,      other.gradMid,      t)!,
      gradEnd:      Color.lerp(gradEnd,      other.gradEnd,      t)!,
      isDark:       t < 0.5 ? isDark : other.isDark,
    );
  }
}
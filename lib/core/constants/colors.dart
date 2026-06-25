import 'package:flutter/material.dart';

/// 🎨 UniCourse Design System — "Aurora Indigo + Gold"
///
/// A modern, premium palette built around a vivid indigo brand, a bright
/// sky accent and a luxury gold highlight. Tokens are provided for both
/// light and dark modes through [AppPalette] (resolved via [ThemeData]),
/// while the legacy [AppColors] constants are kept (mapped to the new
/// light palette) so screens that haven't been migrated yet still look
/// refreshed and keep compiling.
abstract class AppColors {
  // ── Brand ──────────────────────────────────────────────────────────────
  /// Primary brand — vivid indigo/violet.
  static const Color primary = Color(0xFF5A55E0);

  /// Deep indigo, used for pressed states & dark gradients.
  static const Color primaryDark = Color(0xFF3E3A9E);

  /// Slightly brighter brand tint, used on dark surfaces.
  static const Color primaryLight = Color(0xFF7B79F2);

  /// Secondary accent — bright sky/cyan (evolution of the old secondary).
  static const Color secondray = Color(0xFF3FC4E8); // legacy spelling kept
  static const Color secondary = Color(0xFF3FC4E8);

  /// Luxury gold highlight — premium touches, ratings, badges.
  static const Color gold = Color(0xFFF2B544);

  // ── Legacy tokens (kept for unmigrated screens) ──────────────────────────
  static const Color scaffoldBackgroundColor = Color(0xFFF4F5FB);
  static const Color borderColor = Color(0xFFE2E5F0);
  static const Color darkRed = Color(0xFFE5484D);

  // ── Status ───────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF2BB673);
  static const Color warning = Color(0xFFF5A623);
  static const Color error = Color(0xFFE5484D);

  // ── Hero gradients ────────────────────────────────────────────────────────
  /// Signature brand gradient (violet → blue).
  static const List<Color> brandGradient = [
    Color(0xFF6A5BF0),
    Color(0xFF4E8DF5),
  ];

  /// Cool aurora gradient (indigo → cyan), great for hero banners.
  static const List<Color> auroraGradient = [
    Color(0xFF5A55E0),
    Color(0xFF3FC4E8),
  ];

  /// Premium gold gradient for special highlights.
  static const List<Color> goldGradient = [
    Color(0xFFF6C75B),
    Color(0xFFE8A23A),
  ];
}

/// Theme-aware color tokens. Read through `Theme.of(context).extension<AppPalette>()`
/// or the `context.palette` shortcut, so colors automatically adapt to
/// light / dark mode.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  final Color brand;
  final Color brandSoft; // subtle brand-tinted background
  final Color accent; // sky/cyan accent
  final Color gold;

  final Color background;
  final Color surface; // cards
  final Color surfaceAlt; // elevated / secondary surfaces
  final Color surfaceMuted; // inputs, chips

  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;

  final Color border;
  final Color shadow;

  final Color success;
  final Color warning;
  final Color error;

  final List<Color> heroGradient;

  const AppPalette({
    required this.brand,
    required this.brandSoft,
    required this.accent,
    required this.gold,
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.surfaceMuted,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
    required this.shadow,
    required this.success,
    required this.warning,
    required this.error,
    required this.heroGradient,
  });

  static const AppPalette light = AppPalette(
    brand: Color(0xFF5A55E0),
    brandSoft: Color(0xFFEDECFD),
    accent: Color(0xFF3FC4E8),
    gold: Color(0xFFF2B544),
    background: Color(0xFFF4F5FB),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFEEF0F8),
    surfaceMuted: Color(0xFFF1F2F9),
    textPrimary: Color(0xFF16172A),
    textSecondary: Color(0xFF5B5E74),
    textMuted: Color(0xFF9296AD),
    border: Color(0xFFE3E6F1),
    shadow: Color(0x1A2A2E55),
    success: Color(0xFF2BB673),
    warning: Color(0xFFF5A623),
    error: Color(0xFFE5484D),
    heroGradient: [Color(0xFF6A5BF0), Color(0xFF4E8DF5)],
  );

  static const AppPalette dark = AppPalette(
    brand: Color(0xFF7B79F2),
    brandSoft: Color(0xFF20203A),
    accent: Color(0xFF52CEEC),
    gold: Color(0xFFF4C05A),
    background: Color(0xFF0D0E1A),
    surface: Color(0xFF181A2B),
    surfaceAlt: Color(0xFF21243A),
    surfaceMuted: Color(0xFF1E2034),
    textPrimary: Color(0xFFECEDF6),
    textSecondary: Color(0xFFAEB1C8),
    textMuted: Color(0xFF777B96),
    border: Color(0xFF2C2F47),
    shadow: Color(0x40000000),
    success: Color(0xFF35C988),
    warning: Color(0xFFF7B53E),
    error: Color(0xFFF26068),
    heroGradient: [Color(0xFF6A5BF0), Color(0xFF3FA9F5)],
  );

  @override
  AppPalette copyWith({
    Color? brand,
    Color? brandSoft,
    Color? accent,
    Color? gold,
    Color? background,
    Color? surface,
    Color? surfaceAlt,
    Color? surfaceMuted,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? border,
    Color? shadow,
    Color? success,
    Color? warning,
    Color? error,
    List<Color>? heroGradient,
  }) {
    return AppPalette(
      brand: brand ?? this.brand,
      brandSoft: brandSoft ?? this.brandSoft,
      accent: accent ?? this.accent,
      gold: gold ?? this.gold,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      border: border ?? this.border,
      shadow: shadow ?? this.shadow,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      heroGradient: heroGradient ?? this.heroGradient,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      brand: Color.lerp(brand, other.brand, t)!,
      brandSoft: Color.lerp(brandSoft, other.brandSoft, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      border: Color.lerp(border, other.border, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      heroGradient: [
        Color.lerp(heroGradient.first, other.heroGradient.first, t)!,
        Color.lerp(heroGradient.last, other.heroGradient.last, t)!,
      ],
    );
  }
}

/// Convenient access: `context.palette.brand`, `context.isDark`.
extension AppPaletteX on BuildContext {
  AppPalette get palette =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.light;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}

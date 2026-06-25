import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../../gen/fonts.gen.dart';

/// Central theme factory for UniCourse.
///
/// Produces fully-fledged light & dark [ThemeData] objects wired to the
/// "Aurora Indigo + Gold" palette, the DIN Arabic font family and a set of
/// consistent component themes (cards, inputs, buttons, app bar…).
abstract class AppTheme {
  static ThemeData light = _build(AppPalette.light, Brightness.light);
  static ThemeData dark = _build(AppPalette.dark, Brightness.dark);

  static ThemeData _build(AppPalette p, Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: p.brand,
      onPrimary: Colors.white,
      secondary: p.accent,
      onSecondary: Colors.white,
      tertiary: p.gold,
      onTertiary: const Color(0xFF3A2A05),
      error: p.error,
      onError: Colors.white,
      surface: p.surface,
      onSurface: p.textPrimary,
      surfaceContainerHighest: p.surfaceAlt,
      outline: p.border,
      shadow: p.shadow,
    );

    final textTheme = _textTheme(p.textPrimary, p.textSecondary);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: FontFamily.dINArabicMedium,
      scaffoldBackgroundColor: p.background,
      colorScheme: colorScheme,
      textTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      extensions: <ThemeExtension<dynamic>>[p],

      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        iconTheme: IconThemeData(color: p.textPrimary),
        titleTextStyle: TextStyle(
          fontFamily: FontFamily.dINArabicBold,
          fontSize: 18,
          color: p.textPrimary,
        ),
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),

      cardTheme: CardThemeData(
        color: p.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      dividerTheme: DividerThemeData(
        color: p.border,
        thickness: 1,
        space: 1,
      ),

      iconTheme: IconThemeData(color: p.textPrimary),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.surfaceMuted,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: TextStyle(color: p.textMuted, fontSize: 14),
        labelStyle: TextStyle(color: p.textSecondary, fontSize: 14),
        prefixIconColor: p.textMuted,
        suffixIconColor: p.textMuted,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: p.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: p.brand, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: p.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: p.error, width: 1.6),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: p.brand,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontFamily: FontFamily.dINArabicBold,
            fontSize: 16,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: p.brand),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: p.surfaceAlt,
        contentTextStyle: TextStyle(color: p.textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(color: p.brand),

      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: _FadeThroughTransitionBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  static TextTheme _textTheme(Color primary, Color secondary) {
    return TextTheme(
      displayLarge: TextStyle(
          fontFamily: FontFamily.dINArabicBold, color: primary),
      headlineMedium: TextStyle(
          fontFamily: FontFamily.dINArabicBold, color: primary),
      titleLarge:
          TextStyle(fontFamily: FontFamily.dINArabicBold, color: primary),
      titleMedium:
          TextStyle(fontFamily: FontFamily.dINArabicMedium, color: primary),
      bodyLarge:
          TextStyle(fontFamily: FontFamily.dINArabicMedium, color: primary),
      bodyMedium:
          TextStyle(fontFamily: FontFamily.dINArabicMedium, color: secondary),
      labelLarge:
          TextStyle(fontFamily: FontFamily.dINArabicBold, color: primary),
    );
  }
}

/// A soft fade + slight upward slide page transition that feels modern on
/// Android without the heavy default material slide.
class _FadeThroughTransitionBuilder extends PageTransitionsBuilder {
  const _FadeThroughTransitionBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.035),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}

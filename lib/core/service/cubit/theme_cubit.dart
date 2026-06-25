import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cache/cache_helper.dart';

/// Drives the app-wide light / dark / system theme and persists the choice.
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(_fromString(CacheHelper.getThemeMode()));

  static ThemeCubit get(BuildContext context) => BlocProvider.of(context);

  static ThemeMode _fromString(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static String _toString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  bool isDark(BuildContext context) {
    if (state == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    return state == ThemeMode.dark;
  }

  Future<void> setMode(ThemeMode mode) async {
    if (mode == state) return;
    emit(mode);
    await CacheHelper.setThemeMode(_toString(mode));
  }

  /// Toggles between explicit light and dark (used by the quick switch).
  Future<void> toggle(BuildContext context) async {
    final goingDark = !isDark(context);
    await setMode(goingDark ? ThemeMode.dark : ThemeMode.light);
  }
}

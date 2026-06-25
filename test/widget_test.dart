// Smoke test for the UniCourse design system.
//
// Verifies that the light & dark themes build and expose the custom
// [AppPalette] extension used across the app.

import 'package:flutter_test/flutter_test.dart';

import 'package:unicourse/core/constants/colors.dart';
import 'package:unicourse/core/theme/app_theme.dart';

void main() {
  test('themes expose the AppPalette extension', () {
    expect(AppTheme.light.extension<AppPalette>(), isNotNull);
    expect(AppTheme.dark.extension<AppPalette>(), isNotNull);
  });

  test('light and dark palettes differ', () {
    expect(AppPalette.light.background, isNot(AppPalette.dark.background));
    expect(AppPalette.light.textPrimary, isNot(AppPalette.dark.textPrimary));
  });
}

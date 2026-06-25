import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/constants/colors.dart';
import '../../../../core/service/cubit/theme_cubit.dart';

/// Compact 3-way segmented control for Light / System / Dark theme modes.
class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) {
        final cubit = ThemeCubit.get(context);
        return Container(
          padding: EdgeInsets.all(3.r),
          decoration: BoxDecoration(
            color: palette.surfaceAlt,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _seg(context, Icons.light_mode_rounded, mode == ThemeMode.light,
                  () => cubit.setMode(ThemeMode.light)),
              _seg(context, Icons.brightness_auto_rounded,
                  mode == ThemeMode.system,
                  () => cubit.setMode(ThemeMode.system)),
              _seg(context, Icons.dark_mode_rounded, mode == ThemeMode.dark,
                  () => cubit.setMode(ThemeMode.dark)),
            ],
          ),
        );
      },
    );
  }

  Widget _seg(
      BuildContext context, IconData icon, bool active, VoidCallback onTap) {
    final palette = context.palette;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.all(7.r),
        decoration: BoxDecoration(
          gradient: active
              ? LinearGradient(colors: [palette.brand, palette.accent])
              : null,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18.sp,
          color: active ? Colors.white : palette.textMuted,
        ),
      ),
    );
  }
}

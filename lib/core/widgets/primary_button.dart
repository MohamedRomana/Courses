import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../gen/fonts.gen.dart';
import '../constants/colors.dart';

/// A premium, theme-aware gradient button with a built-in loading state.
/// Used as the primary call-to-action across auth and form screens.
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool loading;
  final IconData? icon;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final List<Color>? gradient;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.loading = false,
    this.icon,
    this.width,
    this.margin,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final colors = gradient ?? [palette.brand, palette.accent];

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: GestureDetector(
        onTap: loading ? null : onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 54.h,
          width: width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: colors.first.withValues(alpha: 0.4),
                blurRadius: 16.r,
                offset: Offset(0, 6.r),
              ),
            ],
          ),
          child: loading
              ? SizedBox(
                  height: 26.w,
                  width: 26.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.6,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: Colors.white, size: 20.sp),
                      SizedBox(width: 8.w),
                    ],
                    Text(
                      text,
                      style: TextStyle(
                        fontFamily: FontFamily.dINArabicBold,
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

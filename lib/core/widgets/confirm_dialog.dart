import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../generated/locale_keys.g.dart';
import '../../gen/fonts.gen.dart';
import '../constants/colors.dart';

/// Reusable confirmation dialog body (icon + title + subtitle + two actions),
/// designed to live inside [customAlertDialog]. Theme-aware.
class ConfirmDialogContent extends StatelessWidget {
  final IconData icon;
  final Color accent;
  final String title;
  final String subtitle;
  final VoidCallback onConfirm;
  final String? confirmText;

  const ConfirmDialogContent({
    super.key,
    required this.icon,
    required this.accent,
    required this.title,
    required this.subtitle,
    required this.onConfirm,
    this.confirmText,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 22.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70.w,
            height: 70.w,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accent, size: 36.sp),
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: FontFamily.dINArabicBold,
              fontSize: 18.sp,
              color: palette.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              height: 1.5,
              color: palette.textSecondary,
            ),
          ),
          SizedBox(height: 22.h),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 48.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: palette.surfaceAlt,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: palette.border),
                    ),
                    child: Text(
                      LocaleKeys.no.tr(),
                      style: TextStyle(
                        fontFamily: FontFamily.dINArabicBold,
                        fontSize: 14.sp,
                        color: palette.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: GestureDetector(
                  onTap: onConfirm,
                  child: Container(
                    height: 48.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(14.r),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withValues(alpha: 0.35),
                          blurRadius: 12.r,
                          offset: Offset(0, 5.r),
                        ),
                      ],
                    ),
                    child: Text(
                      confirmText ?? LocaleKeys.yes.tr(),
                      style: TextStyle(
                        fontFamily: FontFamily.dINArabicBold,
                        fontSize: 14.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

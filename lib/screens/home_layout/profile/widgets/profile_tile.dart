import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/constants/colors.dart';
import '../../../../gen/fonts.gen.dart';

/// A reusable settings row used across the profile screen.
class ProfileTile extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool danger;

  const ProfileTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.trailing,
    this.iconColor,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final color = danger ? palette.error : (iconColor ?? palette.brand);
    final isAr = context.locale.languageCode == 'ar';

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 7.h),
        child: Row(
          children: [
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(13.r),
              ),
              child: Icon(icon, color: color, size: 21.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: FontFamily.dINArabicBold,
                  fontSize: 15.sp,
                  color: danger ? palette.error : palette.textPrimary,
                ),
              ),
            ),
            if (trailing != null)
              trailing!
            else if (onTap != null)
              Icon(
                isAr
                    ? Icons.arrow_back_ios_new_rounded
                    : Icons.arrow_forward_ios_rounded,
                size: 15.sp,
                color: palette.textMuted,
              ),
          ],
        ),
      ),
    );
  }
}

/// A titled card that groups a set of [ProfileTile]s.
class ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const ProfileSection({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 8.h, top: 4.h),
          child: Text(
            title,
            style: TextStyle(
              fontFamily: FontFamily.dINArabicBold,
              fontSize: 13.sp,
              color: palette.textMuted,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: palette.border),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

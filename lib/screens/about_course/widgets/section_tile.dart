import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/colors.dart';
import '../../../gen/fonts.gen.dart';

/// A collapsible section header used in the course content tab (free sample
/// and each paid module). Shows a leading icon, title, subtitle and an
/// animated chevron.
class SectionTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData leadingIcon;
  final Color leadingColor;
  final bool expanded;
  final VoidCallback onTap;

  const SectionTile({
    super.key,
    required this.title,
    required this.leadingIcon,
    required this.expanded,
    required this.onTap,
    this.subtitle,
    this.leadingColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: palette.surfaceAlt,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: leadingColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(leadingIcon, color: leadingColor, size: 20.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: FontFamily.dINArabicBold,
                      fontSize: 14.sp,
                      color: palette.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: palette.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            AnimatedRotation(
              turns: expanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 250),
              child: Icon(Icons.keyboard_arrow_down_rounded,
                  size: 26.sp, color: palette.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

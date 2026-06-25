import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/colors.dart';
import '../../../gen/fonts.gen.dart';

/// A single lesson row used in both the free-sample and paid-content lists.
class LessonTile extends StatelessWidget {
  final int index;
  final String title;
  final String time;
  final bool isFree;
  final bool isLocked;
  final bool isPlaying;
  final VoidCallback onTap;

  const LessonTile({
    super.key,
    required this.index,
    required this.title,
    required this.time,
    required this.onTap,
    this.isFree = false,
    this.isLocked = false,
    this.isPlaying = false,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isAr = context.locale.languageCode == 'ar';

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: isPlaying ? palette.brandSoft : palette.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isPlaying ? palette.brand : palette.border,
            width: isPlaying ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            // leading state badge
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: isLocked
                    ? palette.surfaceAlt
                    : palette.brand.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                isLocked
                    ? Icons.lock_outline_rounded
                    : (isPlaying
                        ? Icons.play_arrow_rounded
                        : Icons.play_circle_outline_rounded),
                color: isLocked ? palette.textMuted : palette.brand,
                size: 22.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$index. $title',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: FontFamily.dINArabicMedium,
                      fontSize: 13.sp,
                      height: 1.3,
                      color: palette.textPrimary,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    children: [
                      if (isFree)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 7.w, vertical: 2.h),
                          margin: EdgeInsetsDirectional.only(end: 8.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2BB673)
                                .withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            isAr ? 'مجاني' : 'Free',
                            style: TextStyle(
                              fontFamily: FontFamily.dINArabicBold,
                              fontSize: 10.sp,
                              color: const Color(0xFF2BB673),
                            ),
                          ),
                        ),
                      Icon(Icons.schedule_rounded,
                          size: 13.sp, color: palette.textMuted),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          time,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: palette.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isPlaying)
              Padding(
                padding: EdgeInsetsDirectional.only(start: 6.w),
                child: Icon(Icons.graphic_eq_rounded,
                    color: palette.brand, size: 20.sp),
              ),
          ],
        ),
      ),
    );
  }
}

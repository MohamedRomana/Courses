import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../gen/fonts.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../constants/colors.dart';
import '../models/courses.dart';

/// Premium, theme-aware vertical course card used in the home rails,
/// search results and listing screens.
class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback onTap;
  final double? width;

  const CourseCard({
    super.key,
    required this.course,
    required this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final w = width ?? 168.w;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: w,
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(color: palette.border),
          boxShadow: [
            BoxShadow(
              color: palette.shadow,
              blurRadius: 18.r,
              offset: Offset(0, 8.r),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Cover ──
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
                  child: Image.asset(
                    course.image,
                    height: 118.h,
                    width: w,
                    fit: BoxFit.cover,
                  ),
                ),
                // price chip
                PositionedDirectional(
                  top: 10.h,
                  start: 10.w,
                  child: _PriceChip(price: course.price),
                ),
                // rating pill
                if (course.rate > 0)
                  PositionedDirectional(
                    bottom: 10.h,
                    end: 10.w,
                    child: _RatingPill(rate: course.rate),
                  ),
              ],
            ),
            // ── Body ──
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 38.h,
                    child: Text(
                      course.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: FontFamily.dINArabicBold,
                        fontSize: 13.5.sp,
                        height: 1.25,
                        color: palette.textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 9.r,
                        backgroundColor: palette.brandSoft,
                        backgroundImage: AssetImage(course.image),
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          course.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: palette.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Divider(height: 1, color: palette.border),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      _MetaIcon(
                        icon: Icons.play_circle_outline_rounded,
                        label: '${course.videosNum}',
                        color: palette.brand,
                      ),
                      SizedBox(width: 12.w),
                      _MetaIcon(
                        icon: Icons.schedule_rounded,
                        label: '${course.time} ${LocaleKeys.time.tr()}',
                        color: palette.accent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Wide, cinematic featured card used in the "most viewed" hero rail.
class FeaturedCourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback onTap;
  final double? width;

  const FeaturedCourseCard({
    super.key,
    required this.course,
    required this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final w = width ?? 290.w;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: w,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: palette.shadow,
              blurRadius: 20.r,
              offset: Offset(0, 10.r),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(course.image2, fit: BoxFit.cover),
            // gradient scrim
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xCC000000)],
                  stops: [0.35, 1],
                ),
              ),
            ),
            PositionedDirectional(
              top: 12.h,
              start: 12.w,
              child: _PriceChip(price: course.price),
            ),
            PositionedDirectional(
              top: 12.h,
              end: 12.w,
              child: Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                ),
                child: Icon(Icons.play_arrow_rounded,
                    color: Colors.white, size: 24.sp),
              ),
            ),
            PositionedDirectional(
              bottom: 14.h,
              start: 14.w,
              end: 14.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    course.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: FontFamily.dINArabicBold,
                      fontSize: 17.sp,
                      height: 1.2,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(Icons.person_rounded,
                          size: 13.sp, color: Colors.white70),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          course.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      Icon(Icons.play_circle_outline_rounded,
                          size: 13.sp, color: Colors.white70),
                      SizedBox(width: 4.w),
                      Text(
                        '${course.videosNum}',
                        style:
                            TextStyle(fontSize: 12.sp, color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceChip extends StatelessWidget {
  final int price;
  const _PriceChip({required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: AppColors.goldGradient),
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.45),
            blurRadius: 10.r,
            offset: Offset(0, 3.r),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$price',
            style: TextStyle(
              fontFamily: FontFamily.dINArabicBold,
              fontSize: 12.sp,
              color: const Color(0xFF3A2A05),
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            LocaleKeys.sar.tr(),
            style: TextStyle(
              fontSize: 9.sp,
              color: const Color(0xFF3A2A05),
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingPill extends StatelessWidget {
  final double rate;
  const _RatingPill({required this.rate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 13.sp, color: AppColors.gold),
          SizedBox(width: 3.w),
          Text(
            rate.toStringAsFixed(1),
            style: TextStyle(
              fontFamily: FontFamily.dINArabicBold,
              fontSize: 11.sp,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _MetaIcon(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15.sp, color: color),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(fontSize: 11.sp, color: palette.textSecondary),
        ),
      ],
    );
  }
}

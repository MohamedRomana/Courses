import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/constants/colors.dart';
import 'package:unicourse/core/service/cubit/app_cubit.dart';
import '../../../core/widgets/app_router.dart';
import '../../../gen/fonts.gen.dart';
import '../../../generated/locale_keys.g.dart';

class LearningProgramDetails extends StatelessWidget {
  final int index;
  const LearningProgramDetails({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';
    final course = AppCubit.get(context).courses[index];
    return SizedBox(
      height: 250.h,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(course.image2, fit: BoxFit.cover),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x66000000), Color(0xE6000000)],
                stops: [0.25, 1],
              ),
            ),
          ),
          // back button
          PositionedDirectional(
            top: MediaQuery.of(context).padding.top + 8.h,
            start: 12.w,
            child: GestureDetector(
              onTap: () => AppRouter.pop(context),
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.25)),
                ),
                child: Icon(
                  isAr
                      ? Icons.arrow_forward_ios_rounded
                      : Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
            ),
          ),
          PositionedDirectional(
            top: MediaQuery.of(context).padding.top + 10.h,
            end: 14.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: AppColors.goldGradient),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_stories_rounded,
                      color: const Color(0xFF3A2A05), size: 13.sp),
                  SizedBox(width: 5.w),
                  Text(
                    LocaleKeys.learning_program.tr(),
                    style: TextStyle(
                      fontFamily: FontFamily.dINArabicBold,
                      fontSize: 11.sp,
                      color: const Color(0xFF3A2A05),
                    ),
                  ),
                ],
              ),
            ),
          ),
          PositionedDirectional(
            start: 20.w,
            end: 20.w,
            bottom: 18.h,
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
                    fontSize: 26.sp,
                    height: 1.2,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    _chip(Icons.play_circle_outline_rounded,
                        '${course.videosNum} ${isAr ? "كورسات" : "courses"}'),
                    SizedBox(width: 8.w),
                    _chip(Icons.schedule_rounded,
                        '${course.time} ${isAr ? "ساعة" : "h"}'),
                    SizedBox(width: 8.w),
                    _chip(Icons.bar_chart_rounded, isAr ? 'متقدم' : 'Advanced'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.sp, color: Colors.white),
          SizedBox(width: 4.w),
          Text(text,
              style: TextStyle(fontSize: 11.sp, color: Colors.white)),
        ],
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/service/cubit/app_cubit.dart';
import '../../../core/widgets/app_text.dart';
import '../../../gen/fonts.gen.dart';
import '../../../generated/locale_keys.g.dart';

class LearningProgramDetails extends StatelessWidget {
  final int index;
  const LearningProgramDetails({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          AppCubit.get(context).courses[index].image2,
          height: 250.h,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          height: 250.h,
          width: double.infinity,
          color: Colors.black.withAlpha(150),
        ),
        PositionedDirectional(
          start: 10.w,
          top: 10.h,
          child: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(70),
              borderRadius: BorderRadius.circular(5.r),
              border: Border.all(color: Colors.white, width: 0.2.w),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.play_circle_outline,
                  color: Colors.white,
                  size: 15.sp,
                ),
                AppText(
                  text: LocaleKeys.learning_program.tr(),
                  color: Colors.white,
                  size: context.locale.languageCode == 'ar' ? 12.sp : 8.sp,
                  family: FontFamily.dINArabicBold,
                  lines: 2,
                  start: 5.w,
                ),
              ],
            ),
          ),
        ),
        PositionedDirectional(
          start: 16.w,
          bottom: 0.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 343.w,
                child: AppText(
                  bottom: 5.h,
                  text: AppCubit.get(context).courses[index].title,
                  color: Colors.white,
                  lines: 2,
                  size: 30.sp,
                  family: FontFamily.dINArabicBold,
                ),
              ),
              SizedBox(
                width: 343.w,
                child: AppText(
                  text:
                      '${AppCubit.get(context).courses[index].videosNum} كورسات . ${AppCubit.get(context).courses[index].time} ساعة . متقدم',
                  bottom: 10.h,
                  lines: 2,
                  color: Colors.grey,
                  size: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

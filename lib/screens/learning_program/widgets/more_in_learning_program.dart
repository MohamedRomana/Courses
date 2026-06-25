import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/generated/locale_keys.g.dart';
import '../../../core/constants/colors.dart';
import '../../../core/service/cubit/app_cubit.dart';
import '../../../core/widgets/app_text.dart';
import '../../../gen/fonts.gen.dart';

class MoreInLearningProgram extends StatelessWidget {
  final int index;
  const MoreInLearningProgram({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final learningProgramsList =
        AppCubit.get(context).learningProgramsList[index];
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            top: 16.h,
            start: 16.w,
            text: LocaleKeys.experts.tr(),
            size: 20.sp,
            color: AppColors.primary,
            family: FontFamily.dINArabicBold,
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(16.r),
            itemCount: learningProgramsList.doctors.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder:
                (context, index) => Container(
                  clipBehavior: Clip.antiAlias,
                  padding: EdgeInsets.all(16.r),
                  width: 343.w,
                  decoration: BoxDecoration(
                    color: AppColors.borderColor,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(100),
                        blurRadius: 5.r,
                        spreadRadius: 1.r,
                        offset: Offset(0, 5.r),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 70.w,
                        width: 70.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1000.r),
                          image: DecorationImage(
                            image: AssetImage(
                              learningProgramsList.doctors[index].image,
                            ),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withAlpha(100),
                              blurRadius: 5.r,
                              spreadRadius: 1.r,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 220.w,
                            child: AppText(
                              start: 16.w,
                              color: Colors.black,
                              family: FontFamily.dINArabicBold,
                              text: learningProgramsList.doctors[index].name,
                            ),
                          ),
                          SizedBox(
                            width: 220.w,
                            child: AppText(
                              start: 16.w,
                              bottom: 5.h,
                              color: AppColors.primary,
                              text: learningProgramsList.doctors[index].title,
                              lines: 2,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.only(start: 16.w),
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.timer_outlined, size: 20.sp),
                                    SizedBox(
                                      width: 100.w,
                                      child: AppText(
                                        start: 3.w,
                                        end: 5.w,
                                        text:
                                            '${learningProgramsList.doctors[index].followersCount} ${LocaleKeys.learners.tr()}',
                                        color: Colors.black,
                                        size: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.volume_up, size: 20.sp),
                                    SizedBox(
                                      width: 80.w,
                                      child: AppText(
                                        start: 3.w,
                                        text:
                                            '${learningProgramsList.doctors[index].coursesCount} دورات',
                                        color: Colors.black,
                                        size: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
          ),
        ],
      ),
    );
  }
}

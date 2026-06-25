import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/widgets/app_router.dart';
import '../../../core/constants/colors.dart';
import '../../../core/service/cubit/app_cubit.dart';
import '../../../core/widgets/app_text.dart';
import '../../../gen/fonts.gen.dart';
import '../../../generated/locale_keys.g.dart';
import '../../about_course/about_course.dart';

class CoursesInLearningProgram extends StatelessWidget {
  final int index;
  const CoursesInLearningProgram({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final learningProgramsList =
        AppCubit.get(context).learningProgramsList[index];
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                top: 16.h,
                start: 16.w,
                text:
                    '${learningProgramsList.coursesCount} ${LocaleKeys.courses.tr()}',
                size: 20.sp,
                color: AppColors.primary,
                family: FontFamily.dINArabicBold,
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(16.r),
                itemCount: learningProgramsList.learningProgramsCourses.length,
                separatorBuilder: (context, subindex) => SizedBox(height: 16.h),
                itemBuilder:
                    (context, subindex) => InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        AppRouter.navigateTo(
                          context,
                          AboutCourse(
                            course: AppCubit.get(context).courses[index],
                          ),
                        );
                      },
                      child: Container(
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
                            ClipRRect(
                              borderRadius: BorderRadiusDirectional.only(
                                bottomStart: Radius.circular(10.r),
                                topStart: Radius.circular(10.r),
                              ),
                              child: Image.asset(
                                learningProgramsList
                                    .learningProgramsCourses[subindex]
                                    .image,
                                height: 100.w,
                                width: 100.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 220.w,
                                  child: AppText(
                                    start: 16.w,
                                    color: AppColors.primary,
                                    family: FontFamily.dINArabicBold,
                                    text:
                                        learningProgramsList
                                            .learningProgramsCourses[subindex]
                                            .title,
                                    lines: 2,
                                  ),
                                ),
                                SizedBox(
                                  width: 220.w,
                                  child: AppText(
                                    start: 16.w,
                                    color: Colors.black,
                                    text:
                                        learningProgramsList
                                            .learningProgramsCourses[subindex]
                                            .name,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/constants/colors.dart';
import 'package:unicourse/core/widgets/app_router.dart';
import '../../../core/service/cubit/app_cubit.dart';
import '../../../gen/fonts.gen.dart';
import '../../../generated/locale_keys.g.dart';
import '../../about_course/about_course.dart';

class CoursesInLearningProgram extends StatelessWidget {
  final int index;
  const CoursesInLearningProgram({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final program = AppCubit.get(context).learningProgramsList[index];
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${program.coursesCount} ${LocaleKeys.courses.tr()}',
                style: TextStyle(
                  fontFamily: FontFamily.dINArabicBold,
                  fontSize: 18.sp,
                  color: palette.textPrimary,
                ),
              ),
              SizedBox(height: 14.h),
              ...List.generate(program.learningProgramsCourses.length, (i) {
                final c = program.learningProgramsCourses[i];
                return Padding(
                  padding: EdgeInsets.only(bottom: 14.h),
                  child: GestureDetector(
                    onTap: () => AppRouter.navigateTo(
                      context,
                      AboutCourse(course: AppCubit.get(context).courses[index]),
                    ),
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: palette.surface,
                        borderRadius: BorderRadius.circular(18.r),
                        border: Border.all(color: palette.border),
                        boxShadow: [
                          BoxShadow(
                            color: palette.shadow,
                            blurRadius: 14.r,
                            offset: Offset(0, 6.r),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Image.asset(c.image,
                              height: 88.w, width: 88.w, fit: BoxFit.cover),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: FontFamily.dINArabicBold,
                                    fontSize: 14.sp,
                                    color: palette.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    Icon(Icons.person_outline_rounded,
                                        size: 13.sp, color: palette.textMuted),
                                    SizedBox(width: 4.w),
                                    Expanded(
                                      child: Text(
                                        c.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: palette.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.only(end: 12.w),
                            child: Icon(Icons.play_circle_fill_rounded,
                                color: palette.brand, size: 28.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/constants/colors.dart';
import 'package:unicourse/core/service/cubit/app_cubit.dart';
import 'package:unicourse/core/widgets/app_router.dart';
import 'package:unicourse/core/widgets/section_header.dart';
import 'package:unicourse/screens/learning_program/learning_program.dart';
import '../../../../gen/fonts.gen.dart';
import '../../../../generated/locale_keys.g.dart';

class LearningProgramList extends StatelessWidget {
  const LearningProgramList({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = AppCubit.get(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 22.h),
        SectionHeader(
          title: LocaleKeys.learning_programs.tr(),
          subtitle: LocaleKeys.discover_curated_courses.tr(),
        ),
        SizedBox(
          height: 312.h,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 4.h),
            itemCount: cubit.learningProgramsList.length,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (_, __) => SizedBox(width: 16.w),
            itemBuilder: (context, index) {
              final program = cubit.learningProgramsList[index];
              return _ProgramCard(
                image: program.image,
                title: program.title,
                desc: program.desc,
                coursesCount: program.coursesCount,
                onTap: () => AppRouter.navigateTo(
                  context,
                  LearningProgram(index: index),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ProgramCard extends StatelessWidget {
  final String image;
  final String title;
  final String desc;
  final int coursesCount;
  final VoidCallback onTap;

  const _ProgramCard({
    required this.image,
    required this.title,
    required this.desc,
    required this.coursesCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 268.w,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(24.r),
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
          children: [
            Stack(
              children: [
                Image.asset(
                  image,
                  height: 132.h,
                  width: 268.w,
                  fit: BoxFit.cover,
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.35),
                        ],
                      ),
                    ),
                  ),
                ),
                PositionedDirectional(
                  top: 12.h,
                  start: 12.w,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      gradient:
                          const LinearGradient(colors: AppColors.brandGradient),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.auto_stories_rounded,
                            color: Colors.white, size: 13.sp),
                        SizedBox(width: 5.w),
                        Text(
                          LocaleKeys.learning_program.tr(),
                          style: TextStyle(
                            fontFamily: FontFamily.dINArabicBold,
                            fontSize: 11.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                PositionedDirectional(
                  bottom: 12.h,
                  end: 12.w,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.play_circle_outline_rounded,
                            color: Colors.white, size: 13.sp),
                        SizedBox(width: 5.w),
                        Text(
                          '$coursesCount ${LocaleKeys.courses.tr()}',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: FontFamily.dINArabicBold,
                      fontSize: 15.sp,
                      color: palette.textPrimary,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  SizedBox(
                    height: 32.h,
                    child: Text(
                      desc,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        height: 1.3,
                        color: palette.textSecondary,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    height: 42.h,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient:
                          LinearGradient(colors: [palette.brand, palette.accent]),
                      borderRadius: BorderRadius.circular(14.r),
                      boxShadow: [
                        BoxShadow(
                          color: palette.brand.withValues(alpha: 0.3),
                          blurRadius: 12.r,
                          offset: Offset(0, 5.r),
                        ),
                      ],
                    ),
                    child: Text(
                      LocaleKeys.view_learning_program.tr(),
                      style: TextStyle(
                        fontFamily: FontFamily.dINArabicBold,
                        fontSize: 13.sp,
                        color: Colors.white,
                      ),
                    ),
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

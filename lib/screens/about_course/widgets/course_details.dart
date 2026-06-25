import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:unicourse/core/constants/colors.dart';
import 'package:unicourse/core/service/cubit/app_cubit.dart';
import '../../../core/cache/cache_helper.dart';
import '../../../core/models/courses.dart';
import '../../../gen/fonts.gen.dart';

class CourseDetails extends StatelessWidget {
  final Course course;
  const CourseDetails({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    AppCubit cubit = AppCubit.get(context);
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final saved = cubit.savedCourses.any((c) => c.title == course.title) &&
            CacheHelper.getUserId() != "";
        return Padding(
          padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // category chip + actions
              Row(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: palette.brandSoft,
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Text(
                      course.type,
                      style: TextStyle(
                        fontFamily: FontFamily.dINArabicBold,
                        fontSize: 11.sp,
                        color: palette.brand,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _ActionButton(
                    icon: saved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_outline_rounded,
                    active: saved,
                    onTap: () => cubit.addOrRemoveSavedCourse(course),
                  ),
                  SizedBox(width: 8.w),
                  _ActionButton(
                    icon: Icons.share_outlined,
                    onTap: () => Share.share(course.youTubeLink),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              Text(
                course.title,
                style: TextStyle(
                  fontFamily: FontFamily.dINArabicBold,
                  fontSize: 21.sp,
                  height: 1.3,
                  color: palette.textPrimary,
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  CircleAvatar(
                    radius: 16.r,
                    backgroundColor: palette.brandSoft,
                    backgroundImage: AssetImage(course.image),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: FontFamily.dINArabicBold,
                            fontSize: 13.sp,
                            color: palette.textPrimary,
                          ),
                        ),
                        Text(
                          course.doctorDesc,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: palette.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star_rounded,
                            size: 16.sp, color: AppColors.gold),
                        SizedBox(width: 3.w),
                        Text(
                          course.rate > 0
                              ? course.rate.toStringAsFixed(1)
                              : '5.0',
                          style: TextStyle(
                            fontFamily: FontFamily.dINArabicBold,
                            fontSize: 12.sp,
                            color: palette.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool active;
  const _ActionButton(
      {required this.icon, required this.onTap, this.active = false});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: active ? palette.brandSoft : palette.surfaceAlt,
          shape: BoxShape.circle,
          border: Border.all(color: palette.border),
        ),
        child: Icon(
          icon,
          size: 20.sp,
          color: active ? palette.brand : palette.textSecondary,
        ),
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/service/cubit/app_cubit.dart';
import 'package:unicourse/core/widgets/app_router.dart';
import 'package:unicourse/core/widgets/course_card.dart';
import 'package:unicourse/core/widgets/section_header.dart';
import 'package:unicourse/generated/locale_keys.g.dart';
import 'package:unicourse/screens/about_course/about_course.dart';
import 'package:unicourse/screens/selected_courses/selected_courses.dart';
import '../../../../core/cache/cache_helper.dart';

class CoursesListView extends StatelessWidget {
  const CoursesListView({super.key});

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final visible =
            cubit.selectedCourses.isNotEmpty && CacheHelper.getUserId() != "";
        if (!visible) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            SectionHeader(
              title: LocaleKeys.selected_courses.tr(),
              onSeeAll: () =>
                  AppRouter.navigateTo(context, const SelectedCourses()),
            ),
            SizedBox(
              height: 260.h,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 4.h),
                itemCount: cubit.selectedCourses.length,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (_, __) => SizedBox(width: 14.w),
                itemBuilder: (context, index) {
                  final course = cubit.selectedCourses[index];
                  return CourseCard(
                    course: course,
                    onTap: () => AppRouter.navigateTo(
                      context,
                      AboutCourse(course: course),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

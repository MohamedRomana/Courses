import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/models/courses.dart';
import 'package:unicourse/core/widgets/app_router.dart';
import 'package:unicourse/core/widgets/course_card.dart';
import 'package:unicourse/core/widgets/section_header.dart';
import 'package:unicourse/screens/about_course/about_course.dart';

/// A titled horizontal rail of course cards used across the "My Courses" tab.
class CoursesRail extends StatelessWidget {
  final String title;
  final List<Course> courses;

  const CoursesRail({super.key, required this.title, required this.courses});

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 22.h),
        SectionHeader(title: title),
        SizedBox(
          height: 260.h,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 4.h),
            itemCount: courses.length,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (_, __) => SizedBox(width: 14.w),
            itemBuilder: (context, index) {
              final course = courses[index];
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
  }
}

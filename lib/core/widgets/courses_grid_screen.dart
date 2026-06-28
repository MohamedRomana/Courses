import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../models/courses.dart';
import 'app_router.dart';
import 'course_card.dart';
import 'custom_lottie_widget.dart';
import '../../gen/assets.gen.dart';
import '../../screens/about_course/about_course.dart';
import 'custom_appbar.dart';

/// A reusable full-screen grid of courses used by the "Most viewed",
/// "Latest courses" and "Selected courses" listing screens.
class CoursesGridScreen extends StatelessWidget {
  final String title;
  final List<Course> courses;

  const CoursesGridScreen({
    super.key,
    required this.title,
    required this.courses,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: title, isNoti: true),
      body: courses.isEmpty
          ? Center(child: CustomLottieWidget(lottieName: Assets.img.emptyorder))
          : AnimationLimiter(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
                itemCount: courses.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14.w,
                  mainAxisSpacing: 16.h,
                  childAspectRatio: 0.62,
                ),
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    columnCount: 2,
                    duration: const Duration(milliseconds: 400),
                    child: ScaleAnimation(
                      scale: 0.94,
                      child: FadeInAnimation(
                        child: CourseCard(
                          course: course,
                          width: double.infinity,
                          onTap: () => AppRouter.navigateTo(
                            context,
                            AboutCourse(course: course),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:unicourse/core/service/cubit/app_cubit.dart';
import 'widgets/courses_list_view.dart';
import 'widgets/home_header.dart';
import 'widgets/learning_programs_list.dart';
import 'widgets/most_view_list.dart';
import 'widgets/newer_courses.dart';
import 'widgets/swiper_container.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            child: AnimationLimiter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 500),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: 40,
                    curve: Curves.easeOutCubic,
                    child: FadeInAnimation(child: widget),
                  ),
                  children: [
                    const HomeHeader(),
                    SizedBox(height: 18.h),
                    const SwiperContainer(),
                    SizedBox(height: 8.h),
                    const CoursesListView(),
                    const LearningProgramList(),
                    const MostViewList(),
                    const NewerCourses(),
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

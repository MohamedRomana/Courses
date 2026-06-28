import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/constants/colors.dart';
import 'package:unicourse/core/service/cubit/app_cubit.dart';
import 'package:unicourse/gen/fonts.gen.dart';
import '../../generated/locale_keys.g.dart';
import 'widgets/about_learning_program.dart';
import 'widgets/courses_in_learning_program.dart';
import 'widgets/learning_program_details.dart';
import 'widgets/more_in_learning_program.dart';

class LearningProgram extends StatelessWidget {
  final int index;
  const LearningProgram({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Scaffold(
          body: Column(
            children: [
              LearningProgramDetails(index: index),
              Expanded(
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 8.h),
                        child: Container(
                          padding: EdgeInsets.all(5.r),
                          decoration: BoxDecoration(
                            color: palette.surfaceAlt,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: TabBar(
                            labelColor: Colors.white,
                            dividerColor: Colors.transparent,
                            unselectedLabelColor: palette.textSecondary,
                            labelStyle: TextStyle(
                              fontSize: 12.5.sp,
                              fontFamily: FontFamily.dINArabicBold,
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                            splashBorderRadius: BorderRadius.circular(12.r),
                            indicator: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [palette.brand, palette.accent]),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            tabs: [
                              Tab(height: 38.h, text: LocaleKeys.about_course.tr()),
                              Tab(
                                  height: 38.h,
                                  text: LocaleKeys.training_courses.tr()),
                              Tab(height: 38.h, text: LocaleKeys.more.tr()),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            AboutLearningProgram(index: index),
                            CoursesInLearningProgram(index: index),
                            MoreInLearningProgram(index: index),
                          ],
                        ),
                      ),
                    ],
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

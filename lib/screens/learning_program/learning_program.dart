import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/service/cubit/app_cubit.dart';
import 'package:unicourse/gen/fonts.gen.dart';
import '../../core/constants/colors.dart';
import '../../core/widgets/custom_appbar.dart';
import '../../core/widgets/custom_bottom_nav.dart';
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
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(
            title: LocaleKeys.learning_program.tr(),
            isNoti: true,
          ),
          bottomNavigationBar: const CustomBottomNav(),
          body: Column(
            children: [
              LearningProgramDetails(index: index),
              Expanded(
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      TabBar(
                        splashBorderRadius: BorderRadius.circular(5.r),
                        labelColor: Colors.white,
                        dividerColor: AppColors.primary.withAlpha(50),
                        indicatorSize: TabBarIndicatorSize.tab,
                        unselectedLabelColor: AppColors.primary,
                        overlayColor: const WidgetStatePropertyAll(
                          AppColors.scaffoldBackgroundColor,
                        ),
                        labelStyle: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: FontFamily.dINArabicBold,
                        ),
                        indicatorColor: AppColors.primary,
                        tabs: [
                          Tab(text: LocaleKeys.about_course.tr()),
                          Tab(text: LocaleKeys.training_courses.tr()),
                          Tab(text: LocaleKeys.more.tr()),
                        ],
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

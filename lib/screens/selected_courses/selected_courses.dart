import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/service/cubit/app_cubit.dart';
import 'package:unicourse/core/widgets/custom_appbar.dart';
import 'package:unicourse/core/widgets/custom_bottom_nav.dart';
import '../../core/widgets/app_router.dart';
import '../../core/widgets/app_text.dart';
import '../../gen/fonts.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../about_course/about_course.dart';

class SelectedCourses extends StatelessWidget {
  const SelectedCourses({super.key});

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(title: LocaleKeys.selected_courses.tr()),
          bottomNavigationBar: const CustomBottomNav(),
          body: GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
            itemCount: cubit.selectedCourses.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.59,
            ),
            itemBuilder:
                (context, index) => InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    AppRouter.navigateTo(
                      context,
                      AboutCourse(course: cubit.selectedCourses[index]),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 200.h,
                        width: 160.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          image: DecorationImage(
                            image: AssetImage(
                              cubit.selectedCourses[index].image,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 130.w,
                        child: AppText(
                          top: 5.h,
                          bottom: 3.h,
                          textAlign: TextAlign.start,
                          text: cubit.selectedCourses[index].title,
                          size: 14.sp,
                          lines: 2,
                          family: FontFamily.dINArabicBold,
                        ),
                      ),
                      SizedBox(
                        width: 130.w,
                        child: AppText(
                          text: cubit.selectedCourses[index].name,
                          size: 12.sp,
                          lines: 2,
                          color: Colors.black.withAlpha(100),
                          family: FontFamily.dINArabicBold,
                        ),
                      ),
                    ],
                  ),
                ),
          ),
        );
      },
    );
  }
}

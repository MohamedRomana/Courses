import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/service/cubit/app_cubit.dart';
import 'package:unicourse/core/widgets/app_router.dart';
import 'package:unicourse/generated/locale_keys.g.dart';
import 'package:unicourse/screens/about_course/about_course.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../gen/fonts.gen.dart';

class MyCoursesListview extends StatelessWidget {
  const MyCoursesListview({super.key});

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Visibility(
          visible: cubit.selectedCourses.isNotEmpty,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                top: 16.h,
                start: 16.w,
                text: LocaleKeys.myCourses.tr(),
                size: 20.sp,
                family: FontFamily.dINArabicBold,
              ),
              SizedBox(
                height: 280.h,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(right: 16.w, left: 16.w, top: 16.h),
                  itemCount: cubit.selectedCourses.length,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => SizedBox(width: 10.w),
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
                              height: 180.h,
                              width: 130.w,
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
                                textAlign: TextAlign.center,
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
              ),
            ],
          ),
        );
      },
    );
  }
}

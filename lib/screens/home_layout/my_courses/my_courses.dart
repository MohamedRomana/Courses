import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/constants/colors.dart';
import 'package:unicourse/core/service/cubit/app_cubit.dart';
import 'package:unicourse/generated/locale_keys.g.dart';
import '../../../core/cache/cache_helper.dart';
import '../../../core/widgets/custom_lottie_widget.dart';
import '../../../core/widgets/no_account_alert.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/fonts.gen.dart';
import 'widgets/compeleted_courses.dart';
import 'widgets/favourite_courses.dart';
import 'widgets/my_courses_listview.dart';

class MyCourses extends StatelessWidget {
  const MyCourses({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      body: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          final cubit = AppCubit.get(context);
          if (CacheHelper.getUserId() == "") return const NoAcoountAlert();

          final isEmpty = cubit.selectedCourses.isEmpty &&
              cubit.savedCourses.isEmpty &&
              cubit.completedCourses.isEmpty;

          return SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 4.h),
                  child: Text(
                    LocaleKeys.myCourses.tr(),
                    style: TextStyle(
                      fontFamily: FontFamily.dINArabicBold,
                      fontSize: 24.sp,
                      color: palette.textPrimary,
                    ),
                  ),
                ),
                Expanded(
                  child: isEmpty
                      ? Center(
                          child: CustomLottieWidget(
                              lottieName: Assets.img.emptyorder),
                        )
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.only(bottom: 110.h),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyCoursesListview(),
                              FavouriteCourses(),
                              CompeletedCourses(),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

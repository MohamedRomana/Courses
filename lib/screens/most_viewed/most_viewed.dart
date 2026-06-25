import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/service/cubit/app_cubit.dart';
import 'package:unicourse/core/widgets/custom_appbar.dart';
import 'package:unicourse/generated/locale_keys.g.dart';
import '../../core/widgets/app_router.dart';
import '../../core/widgets/app_text.dart';
import '../../core/widgets/custom_bottom_nav.dart';
import '../../gen/fonts.gen.dart';
import '../about_course/about_course.dart';

class MostViewed extends StatelessWidget {
  const MostViewed({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(
            title: LocaleKeys.most_viewed.tr(),
            isNoti: true,
          ),
          bottomNavigationBar: const CustomBottomNav(),
          body: GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
            itemCount: AppCubit.get(context).courses.length,
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
                      AboutCourse(course: AppCubit.get(context).courses[index]),
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
                              AppCubit.get(context).courses[index].image2,
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
                          text: AppCubit.get(context).courses[index].title,
                          size: 14.sp,
                          lines: 2,
                          family: FontFamily.dINArabicBold,
                        ),
                      ),
                      SizedBox(
                        width: 130.w,
                        child: AppText(
                          text: AppCubit.get(context).courses[index].name,
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

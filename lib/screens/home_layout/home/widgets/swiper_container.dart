import 'package:card_swiper/card_swiper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/service/cubit/app_cubit.dart';
import 'package:unicourse/core/widgets/app_router.dart';
import 'package:unicourse/screens/about_course/about_course.dart';
import '../../../../core/constants/colors.dart';
import '../../../../gen/fonts.gen.dart';
import '../../../../generated/locale_keys.g.dart';

class SwiperContainer extends StatelessWidget {
  const SwiperContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final cubit = AppCubit.get(context);
        final isAr = context.locale.languageCode == 'ar';

        return SizedBox(
          height: 210.h,
          width: double.infinity,
          child: Swiper(
            itemCount: cubit.courses.length,
            viewportFraction: 0.86,
            scale: 0.92,
            autoplay: true,
            autoplayDelay: 5000,
            duration: 700,
            curve: Curves.easeOutCubic,
            pagination: SwiperPagination(
              margin: EdgeInsets.only(top: 8.h),
              builder: DotSwiperPaginationBuilder(
                color: context.palette.border,
                activeColor: context.palette.brand,
                size: 7.r,
                activeSize: 18.r,
                space: 4.r,
              ),
            ),
            itemBuilder: (context, index) {
              final course = cubit.courses[index];
              return GestureDetector(
                onTap: () => AppRouter.navigateTo(
                  context,
                  AboutCourse(course: course),
                ),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26.r),
                    boxShadow: [
                      BoxShadow(
                        color: context.palette.shadow,
                        blurRadius: 22.r,
                        offset: Offset(0, 10.r),
                      ),
                    ],
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(course.image2, fit: BoxFit.cover),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0x33000000), Color(0xE6000000)],
                            stops: [0.3, 1],
                          ),
                        ),
                      ),
                      PositionedDirectional(
                        top: 14.h,
                        start: 14.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: AppColors.goldGradient),
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Text(
                            isAr ? '✦ دورة مميّزة' : '✦ Featured',
                            style: TextStyle(
                              fontFamily: FontFamily.dINArabicBold,
                              fontSize: 11.sp,
                              color: const Color(0xFF3A2A05),
                            ),
                          ),
                        ),
                      ),
                      PositionedDirectional(
                        bottom: 16.h,
                        start: 16.w,
                        end: 16.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              course.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: FontFamily.dINArabicBold,
                                fontSize: 19.sp,
                                height: 1.2,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                _heroPill(
                                  icon: Icons.play_circle_outline_rounded,
                                  label: '${course.videosNum}',
                                ),
                                SizedBox(width: 8.w),
                                _heroPill(
                                  icon: Icons.schedule_rounded,
                                  label:
                                      '${course.time} ${LocaleKeys.time.tr()}',
                                ),
                                const Spacer(),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 14.w, vertical: 8.h),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14.r),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        isAr ? 'ابدأ الآن' : 'Start',
                                        style: TextStyle(
                                          fontFamily: FontFamily.dINArabicBold,
                                          fontSize: 12.sp,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                      Icon(Icons.arrow_forward_rounded,
                                          size: 14.sp,
                                          color: AppColors.primary),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _heroPill({required IconData icon, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.sp, color: Colors.white),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(fontSize: 11.sp, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

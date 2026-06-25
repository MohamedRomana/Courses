import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/service/cubit/app_cubit.dart';
import 'package:unicourse/core/widgets/app_router.dart';
import '../../../core/constants/colors.dart';
import '../../../core/models/courses.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/flash_message.dart';
import '../../../gen/fonts.gen.dart';
import '../../../generated/locale_keys.g.dart';

class CustomRating extends StatefulWidget {
  final Course course;
  const CustomRating({super.key, required this.course});

  @override
  State<CustomRating> createState() => _CustomRatingState();
}

class _CustomRatingState extends State<CustomRating> {
  double rate = 1.0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is RateSuccessState) {
          AppRouter.pop(context);
          showFlashMessage(
            context: context,
            type: FlashMessageType.success,
            message: LocaleKeys.ratingSuccess.tr(),
          );
        }
      },
      builder: (context, state) {
        final palette = context.palette;
        return widget.course.rate != 0.0
            ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AppText(
                  text: LocaleKeys.rating.tr(),
                  size: 18.sp,
                  color: palette.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                RatingBar.builder(
                  initialRating: widget.course.rate,
                  minRating: 1,
                  itemCount: 5,
                  itemSize: 46.sp,
                  glow: false,
                  direction: Axis.horizontal,
                  ignoreGestures: true,
                  itemBuilder:
                      (context, _) =>
                          const Icon(Icons.star_rounded, color: AppColors.gold),
                  onRatingUpdate: (rating) {},
                ),
              ],
            )
            : Column(
              children: [
                Container(
                  width: 64.w,
                  height: 64.w,
                  margin: EdgeInsets.only(top: 16.h),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.star_rounded,
                      color: AppColors.gold, size: 36.sp),
                ),
                AppText(
                  text: LocaleKeys.howWouldYouRateThisCourse.tr(),
                  size: 17.sp,
                  color: palette.textPrimary,
                  top: 14.h,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.bold,
                ),
                AppText(
                  text: LocaleKeys.selectRating.tr(),
                  color: palette.textSecondary,
                  size: 13.sp,
                  top: 6.h,
                  bottom: 16.h,
                ),
                RatingBar.builder(
                  initialRating: rate,
                  minRating: 1,
                  itemCount: 5,
                  itemSize: 44.sp,
                  glow: false,
                  direction: Axis.horizontal,
                  itemBuilder:
                      (context, _) =>
                          const Icon(Icons.star_rounded, color: AppColors.gold),
                  onRatingUpdate: (rating) {
                    rate = rating;
                    debugPrint(rate.toString());
                  },
                ),
                SizedBox(height: 22.h),
                GestureDetector(
                  onTap: () =>
                      AppCubit.get(context).rateCourse(widget.course, rate),
                  child: Container(
                    height: 50.h,
                    width: 250.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [palette.brand, palette.accent]),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: state is RateLoadingState
                        ? SizedBox(
                            height: 26.w,
                            width: 26.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.6,
                              color: Colors.white,
                            ),
                          )
                        : AppText(
                            text: LocaleKeys.addRating.tr(),
                            size: 15.sp,
                            color: Colors.white,
                            family: FontFamily.dINArabicBold,
                          ),
                  ),
                ),
                SizedBox(height: 8.h),
              ],
            );
      },
    );
  }
}

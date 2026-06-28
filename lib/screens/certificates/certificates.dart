import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/constants/colors.dart';
import 'package:unicourse/core/service/cubit/app_cubit.dart';
import 'package:unicourse/core/widgets/app_router.dart';
import '../../core/widgets/custom_appbar.dart';
import '../../core/widgets/custom_lottie_widget.dart';
import '../../gen/assets.gen.dart';
import '../../gen/fonts.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../certificate_details/certificate_details.dart';

class CertificatesScreen extends StatelessWidget {
  const CertificatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final certs = AppCubit.get(context).completedCourses;
        return Scaffold(
          appBar: CustomAppBar(
            title: LocaleKeys.certificates.tr(),
            isNoti: true,
          ),
          body: certs.isEmpty
              ? Center(
                  child: CustomLottieWidget(lottieName: Assets.img.emptyorder),
                )
              : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
                  itemCount: certs.length,
                  separatorBuilder: (_, __) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) {
                    final course = certs[index];
                    return Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: palette.surface,
                        borderRadius: BorderRadius.circular(22.r),
                        border: Border.all(color: palette.border),
                        boxShadow: [
                          BoxShadow(
                            color: palette.shadow,
                            blurRadius: 16.r,
                            offset: Offset(0, 8.r),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Image.asset(
                                course.image2,
                                height: 130.h,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              Positioned.fill(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withValues(alpha: 0.4),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              PositionedDirectional(
                                top: 12.h,
                                start: 12.w,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: AppColors.goldGradient,
                                    ),
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.emoji_events_rounded,
                                        color: const Color(0xFF3A2A05),
                                        size: 14.sp,
                                      ),
                                      SizedBox(width: 5.w),
                                      Text(
                                        LocaleKeys.certificate.tr(),
                                        style: TextStyle(
                                          fontFamily: FontFamily.dINArabicBold,
                                          fontSize: 11.sp,
                                          color: const Color(0xFF3A2A05),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(14.r),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: FontFamily.dINArabicBold,
                                    fontSize: 16.sp,
                                    color: palette.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  course.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: palette.textSecondary,
                                  ),
                                ),
                                SizedBox(height: 14.h),
                                GestureDetector(
                                  onTap: () => AppRouter.navigateTo(
                                    context,
                                    CertificateDetailScreen(course: course),
                                  ),
                                  child: Container(
                                    height: 46.h,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [palette.brand, palette.accent],
                                      ),
                                      borderRadius: BorderRadius.circular(14.r),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.visibility_rounded,
                                          color: Colors.white,
                                          size: 18.sp,
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          LocaleKeys.viewCertificate.tr(),
                                          style: TextStyle(
                                            fontFamily:
                                                FontFamily.dINArabicBold,
                                            fontSize: 14.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}

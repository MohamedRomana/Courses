import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/service/cubit/app_cubit.dart';
import 'package:unicourse/core/widgets/app_router.dart';
import '../../core/constants/colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text.dart';
import '../../core/widgets/custom_appbar.dart';
import '../../core/widgets/custom_bottom_nav.dart';
import '../../core/widgets/custom_lottie_widget.dart';
import '../../gen/assets.gen.dart';
import '../../gen/fonts.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../certificate_details/certificate_details.dart';

class CertificatesScreen extends StatelessWidget {
  const CertificatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(title: LocaleKeys.certificates.tr()),
          bottomNavigationBar: const CustomBottomNav(),
          body:
              cubit.completedCourses.isEmpty
                  ? CustomLottieWidget(lottieName: Assets.img.emptyorder)
                  : ListView.builder(
                    padding: EdgeInsets.all(16.r),
                    itemCount: cubit.completedCourses.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 250.w,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: AppColors.scaffoldBackgroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withAlpha(50),
                              blurRadius: 5.r,
                              spreadRadius: 1.r,
                              offset: Offset(0, 3.r),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              cubit.completedCourses[index].image,
                              height: 130.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              width: 325.w,
                              child: AppText(
                                top: 8.h,
                                bottom: 8.h,
                                start: 5.w,
                                text: cubit.completedCourses[index].title,
                                size: 18.sp,
                                lines: 2,
                                color: Colors.black,
                                family: FontFamily.dINArabicBold,
                              ),
                            ),
                            SizedBox(
                              width: 325.w,
                              child: AppText(
                                start: 5.w,
                                bottom: 12.h,
                                text: cubit.completedCourses[index].desc,
                                size: 12.sp,
                                lines: 3,
                                color: Colors.black.withAlpha(100),
                                family: FontFamily.dINArabicBold,
                              ),
                            ),
                            Center(
                              child: SizedBox(
                                height: 50.h,
                                child: AppButton(
                                  bottom: 10.h,
                                  onPressed:
                                      () => AppRouter.navigateTo(
                                        context,
                                        CertificateDetailScreen(
                                          course: cubit.completedCourses[index],
                                        ),
                                      ),
                                  width: 250.w,
                                  child: AppText(
                                    text: LocaleKeys.viewCertificate.tr(),
                                    size: 12.sp,
                                    color: Colors.white,
                                    family: FontFamily.dINArabicBold,
                                  ),
                                ),
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

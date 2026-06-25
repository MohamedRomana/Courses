import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/constants/colors.dart';
import 'package:unicourse/core/widgets/app_router.dart';
import 'package:unicourse/core/widgets/app_text.dart';
import 'package:unicourse/generated/locale_keys.g.dart';
import '../../../core/cache/cache_helper.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/no_account_alert.dart';
import '../../../gen/fonts.gen.dart';
import '../../certificates/certificates.dart';
import '../home_layout.dart';
import 'about_us/about_us.dart';
import 'contact_us/contact_us.dart';
import 'privacy_policy/privacy_policy.dart';
import 'widgets/custom_logout_dialog.dart';
import 'widgets/profile_image.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: LocaleKeys.profile.tr(), isNoti: false),
      body:
          CacheHelper.getUserId() == ""
              ? const NoAcoountAlert()
              : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const ProfileImage(),
                    SizedBox(height: 40.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.language, size: 28.sp),
                            AppText(
                              text: LocaleKeys.language.tr(),
                              size: 18.sp,
                              color: Colors.black,
                              family: FontFamily.dINArabicBold,
                              start: 10.w,
                            ),
                          ],
                        ),
                        if (context.locale.languageCode == 'en') ...{
                          InkWell(
                            onTap: () {
                              context.setLocale(const Locale('ar'));
                              AppRouter.navigateAndFinish(
                                context,
                                const HomeLayout(),
                              );
                            },
                            child: AppText(
                              text: 'العربية',
                              size: 18.sp,
                              color: Colors.lightBlue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        } else if (context.locale.languageCode == 'ar') ...{
                          InkWell(
                            onTap: () {
                              context.setLocale(const Locale('en'));
                              AppRouter.navigateAndFinish(
                                context,
                                const HomeLayout(),
                              );
                            },
                            child: AppText(
                              text: 'English',
                              size: 18.sp,
                              color: Colors.lightBlue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        },
                      ],
                    ),
                    Divider(color: AppColors.secondray, thickness: 1.h),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        AppRouter.navigateTo(
                          context,
                          const CertificatesScreen(),
                        );
                      },
                      child: SizedBox(
                        height: 40.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.workspace_premium_outlined,
                                  size: 28.sp,
                                ),
                                AppText(
                                  text: LocaleKeys.certificates.tr(),
                                  size: 18.sp,
                                  color: Colors.black,
                                  family: FontFamily.dINArabicBold,
                                  start: 10.w,
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 18.sp,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(color: AppColors.secondray, thickness: 1.h),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        AppRouter.navigateTo(context, const AboutUs());
                      },
                      child: SizedBox(
                        height: 40.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.info_outline, size: 28.sp),
                                AppText(
                                  text: LocaleKeys.aboutus.tr(),
                                  size: 18.sp,
                                  color: Colors.black,
                                  family: FontFamily.dINArabicBold,
                                  start: 10.w,
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 18.sp,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(color: AppColors.secondray, thickness: 1.h),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        AppRouter.navigateTo(context, const PrivacyPolicy());
                      },
                      child: SizedBox(
                        height: 40.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.description_outlined, size: 28.sp),
                                AppText(
                                  text: LocaleKeys.privacyPolicy.tr(),
                                  size: 18.sp,
                                  color: Colors.black,
                                  family: FontFamily.dINArabicBold,
                                  start: 10.w,
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 18.sp,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(color: AppColors.secondray, thickness: 1.h),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        AppRouter.navigateTo(context, const ContactUs());
                      },
                      child: SizedBox(
                        height: 40.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.mail_outline, size: 28.sp),
                                AppText(
                                  text: LocaleKeys.contactUs.tr(),
                                  size: 18.sp,
                                  color: Colors.black,
                                  family: FontFamily.dINArabicBold,
                                  start: 10.w,
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 18.sp,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(color: AppColors.secondray, thickness: 1.h),
                    const CustomLogOutDialog(),
                  ],
                ),
              ),
    );
  }
}

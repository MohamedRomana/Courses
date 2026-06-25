import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/constants/colors.dart';
import 'package:unicourse/core/widgets/app_router.dart';
import 'package:unicourse/generated/locale_keys.g.dart';
import '../../../core/cache/cache_helper.dart';
import '../../../core/widgets/no_account_alert.dart';
import '../../../gen/fonts.gen.dart';
import '../../certificates/certificates.dart';
import '../home_layout.dart';
import 'about_us/about_us.dart';
import 'contact_us/contact_us.dart';
import 'privacy_policy/privacy_policy.dart';
import 'widgets/custom_logout_dialog.dart';
import 'widgets/profile_image.dart';
import 'widgets/profile_tile.dart';
import 'widgets/theme_selector.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isAr = context.locale.languageCode == 'ar';

    return Scaffold(
      body: CacheHelper.getUserId() == ""
          ? const NoAcoountAlert()
          : SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 110.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.h, top: 4.h),
                      child: Text(
                        LocaleKeys.profile.tr(),
                        style: TextStyle(
                          fontFamily: FontFamily.dINArabicBold,
                          fontSize: 24.sp,
                          color: palette.textPrimary,
                        ),
                      ),
                    ),
                    const ProfileImage(),
                    SizedBox(height: 24.h),

                    // ── Preferences ──
                    ProfileSection(
                      title: isAr ? 'التفضيلات' : 'Preferences',
                      children: [
                        ProfileTile(
                          icon: Icons.dark_mode_outlined,
                          title: isAr ? 'المظهر' : 'Appearance',
                          trailing: const ThemeSelector(),
                        ),
                        Divider(height: 1, color: palette.border),
                        ProfileTile(
                          icon: Icons.language_rounded,
                          iconColor: palette.accent,
                          title: LocaleKeys.language.tr(),
                          trailing: _LangSwitch(isAr: isAr),
                          onTap: () => _toggleLang(context, isAr),
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),

                    // ── Account ──
                    ProfileSection(
                      title: isAr ? 'الحساب' : 'Account',
                      children: [
                        ProfileTile(
                          icon: Icons.workspace_premium_rounded,
                          iconColor: AppColors.gold,
                          title: LocaleKeys.certificates.tr(),
                          onTap: () => AppRouter.navigateTo(
                              context, const CertificatesScreen()),
                        ),
                        Divider(height: 1, color: palette.border),
                        ProfileTile(
                          icon: Icons.info_outline_rounded,
                          title: LocaleKeys.aboutus.tr(),
                          onTap: () =>
                              AppRouter.navigateTo(context, const AboutUs()),
                        ),
                        Divider(height: 1, color: palette.border),
                        ProfileTile(
                          icon: Icons.shield_outlined,
                          title: LocaleKeys.privacyPolicy.tr(),
                          onTap: () => AppRouter.navigateTo(
                              context, const PrivacyPolicy()),
                        ),
                        Divider(height: 1, color: palette.border),
                        ProfileTile(
                          icon: Icons.mail_outline_rounded,
                          title: LocaleKeys.contactUs.tr(),
                          onTap: () =>
                              AppRouter.navigateTo(context, const ContactUs()),
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),

                    // ── Danger zone (delete + logout) ──
                    const CustomLogOutDialog(),
                  ],
                ),
              ),
            ),
    );
  }

  void _toggleLang(BuildContext context, bool isAr) {
    context.setLocale(Locale(isAr ? 'en' : 'ar'));
    AppRouter.navigateAndFinish(context, const HomeLayout());
  }
}

class _LangSwitch extends StatelessWidget {
  final bool isAr;
  const _LangSwitch({required this.isAr});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: palette.brandSoft,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Text(
        isAr ? 'English' : 'العربية',
        style: TextStyle(
          fontFamily: FontFamily.dINArabicBold,
          fontSize: 12.sp,
          color: palette.brand,
        ),
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/colors.dart';
import 'app_router.dart';
import 'custom_lottie_widget.dart';
import 'primary_button.dart';
import '../../gen/assets.gen.dart';
import '../../gen/fonts.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../screens/auth/views/login/login.dart';

class NoAcoountAlert extends StatelessWidget {
  final bool isDialog;
  const NoAcoountAlert({super.key, this.isDialog = false});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomLottieWidget(
              lottieName: Assets.img.login,
              width: isDialog ? 220.w : 260.w,
              height: isDialog ? 220.w : 260.w,
            ),
            SizedBox(height: 8.h),
            Text(
              LocaleKeys.loginFirst.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: FontFamily.dINArabicBold,
                fontSize: isDialog ? 18.sp : 22.sp,
                color: palette.textPrimary,
              ),
            ),
            SizedBox(height: 24.h),
            PrimaryButton(
              text: LocaleKeys.login.tr(),
              icon: Icons.login_rounded,
              width: 240.w,
              onPressed: () => AppRouter.navigateTo(context, const LogIn()),
            ),
          ],
        ),
      ),
    );
  }
}

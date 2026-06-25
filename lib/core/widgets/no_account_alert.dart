import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_router.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/custom_lottie_widget.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../screens/auth/views/login/login.dart';

class NoAcoountAlert extends StatelessWidget {
  final bool isDialog;
  const NoAcoountAlert({super.key, this.isDialog = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(
          text: LocaleKeys.loginFirst.tr(),
          top: 50.h,
          size: isDialog ? 21.sp : 29.sp,
          textAlign: TextAlign.center,
          color: AppColors.primary,
          fontStyle: FontStyle.italic,
          family: FontFamily.dINArabicBold,
        ),
        CustomLottieWidget(
          lottieName: Assets.img.login,
          width: isDialog ? 500.w : double.infinity,
          height: isDialog ? 300.w : 400.w,
        ),
        AppButton(
          onPressed: () {
            AppRouter.navigateTo(context, const LogIn());
          },
          child: AppText(
            text: LocaleKeys.login.tr(),
            color: Colors.white,
            family: FontFamily.dINArabicBold,
          ),
        ),
      ],
    );
  }
}

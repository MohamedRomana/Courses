import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/widgets/app_router.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/custom_lottie_widget.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../gen/fonts.gen.dart';
import '../../screens/auth/data/auth_cubit.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(
          top: 20.h,
          text: LocaleKeys.logout.tr(),
          size: 18.sp,
          family: FontFamily.dINArabicBold,
          color: AppColors.primary,
          bottom: 18.h,
        ),
        AppText(
          text: LocaleKeys.logOutSubtitle.tr(),
          family: FontFamily.dINArabicBold,
          color: AppColors.primary,
        ),
        CustomLottieWidget(
          lottieName: Assets.img.alert,
          height: 90.w,
          width: 90.w,
          top: 20.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                AppRouter.pop(context);
                AuthCubit.get(context).logOut();
              },
              child: AppText(
                text: LocaleKeys.yes.tr(),
                color: Colors.red,
                family: FontFamily.dINArabicBold,
              ),
            ),
            TextButton(
              onPressed: () {
                AppRouter.pop(context);
              },
              child: AppText(
                text: LocaleKeys.no.tr(),
                color: AppColors.primary,
                family: FontFamily.dINArabicBold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

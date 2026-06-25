import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../gen/fonts.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../constants/colors.dart';
import 'app_button.dart';
import 'app_text.dart';

class TryAgainButton extends StatelessWidget {
  final void Function() onPressed;
  const TryAgainButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppButton(
        width: 300.w,
        onPressed: onPressed,
        child: AppText(
          text: LocaleKeys.tryAgain.tr(),
          color: AppColors.secondray,
          family: FontFamily.dINArabicBold,
        ),
      ),
    );
  }
}

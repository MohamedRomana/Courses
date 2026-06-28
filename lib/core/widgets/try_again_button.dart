import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../generated/locale_keys.g.dart';
import 'primary_button.dart';

class TryAgainButton extends StatelessWidget {
  final void Function() onPressed;
  const TryAgainButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PrimaryButton(
        text: LocaleKeys.tryAgain.tr(),
        icon: Icons.refresh_rounded,
        width: 300.w,
        onPressed: onPressed,
      ),
    );
  }
}

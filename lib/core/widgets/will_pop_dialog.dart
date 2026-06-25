// ignore_for_file: deprecated_member_use
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../gen/fonts.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../constants/colors.dart';

Future<bool?> willPopDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        title: Text(
          LocaleKeys.doYouWantToLeaveThisApp.tr(),
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 24.sp,
            fontFamily: FontFamily.dINArabicBold,
          ),
        ),
        content: Text(
          LocaleKeys.areYouSure.tr(),
          style: TextStyle(
            fontSize: 20.sp,
            color: AppColors.primary,
            fontFamily: FontFamily.dINArabicBold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            style: ButtonStyle(
              overlayColor: WidgetStatePropertyAll(Colors.red.withOpacity(0.1)),
            ),
            child: Text(
              LocaleKeys.yes.tr(),
              style: const TextStyle(
                color: Colors.red,
                fontFamily: FontFamily.dINArabicBold,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: ButtonStyle(
              overlayColor: WidgetStatePropertyAll(
                Colors.green.withOpacity(0.1),
              ),
            ),
            child: Text(
              LocaleKeys.no.tr(),
              style: const TextStyle(
                color: AppColors.primary,
                fontFamily: FontFamily.dINArabicBold,
              ),
            ),
          ),
        ],
      );
    },
  );
}

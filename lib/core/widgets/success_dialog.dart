import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../generated/locale_keys.g.dart';
import '../constants/colors.dart';
import 'app_text.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 36.h, horizontal: 36.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 90.w,
            width: 90.w,
            margin: EdgeInsets.only(bottom: 18.h),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF35C988), Color(0xFF0FCC5D)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0FCC5D).withValues(alpha: 0.4),
                  blurRadius: 18.r,
                ),
              ],
            ),
            child: Icon(Icons.check_rounded, color: Colors.white, size: 52.sp),
          ),
          AppText(
            text: LocaleKeys.hourRequestHasBeenSuccessfullySent.tr(),
            size: 18.sp,
            lines: 2,
            textAlign: TextAlign.center,
            color: context.palette.textPrimary,
          ),
        ],
      ),
    );
  }
}

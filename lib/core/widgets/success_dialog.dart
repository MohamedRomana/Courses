import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../generated/locale_keys.g.dart';
import 'app_text.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 36.h, horizontal: 48.w),
      child: Column(
        children: [
          Container(
            height: 90.66.w,
            width: 90.66.w,
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: const BoxDecoration(
              color: Color(0xff0FCC5D),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.check_circle_outline_outlined,
                color: Colors.white,
                size: 50.sp,
              ),
            ),
          ),
          AppText(
            text: LocaleKeys.hourRequestHasBeenSuccessfullySent.tr(),
            size: 20.sp,
          ),
        ],
      ),
    );
  }
}

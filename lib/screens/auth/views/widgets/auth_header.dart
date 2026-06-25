import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/constants/colors.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../gen/fonts.gen.dart';

class CustomAuthHeader extends StatelessWidget {
  final String text;
  final double? bottom;
  const CustomAuthHeader({super.key, required this.text, this.bottom});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Image.asset(
              Assets.img.logo.path,
              height: 140.w,
              width: 220.w,
              fit: BoxFit.cover,
            ),
            AppText(
              top: 20.h,
              bottom: bottom ?? 25.h,
              text: text,
              size: 24.sp,
              color: AppColors.primary,
              family: FontFamily.dINArabicBold,
            ),
          ],
        ),
      ),
    );
  }
}

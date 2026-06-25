import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/constants/colors.dart';
import '../../../../../core/widgets/app_router.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../gen/fonts.gen.dart';

class CustomAuthHeader extends StatelessWidget {
  final String text;
  final String? subtitle;
  final double? bottom;
  final bool showBack;

  const CustomAuthHeader({
    super.key,
    required this.text,
    this.subtitle,
    this.bottom,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final canPop = Navigator.canPop(context);

    return Column(
      children: [
        // Brand gradient banner
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(bottom: 26.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: palette.heroGradient,
            ),
            borderRadius:
                BorderRadius.vertical(bottom: Radius.circular(34.r)),
            boxShadow: [
              BoxShadow(
                color: palette.heroGradient.first.withValues(alpha: 0.35),
                blurRadius: 24.r,
                offset: Offset(0, 10.r),
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                SizedBox(height: 6.h),
                if (showBack && canPop)
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(start: 12.w),
                      child: GestureDetector(
                        onTap: () => AppRouter.pop(context),
                        child: Container(
                          width: 42.w,
                          height: 42.w,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.25)),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.all(18.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                        width: 1.5),
                  ),
                  child: Image.asset(
                    Assets.img.logo.path,
                    height: 64.w,
                    width: 64.w,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: FontFamily.dINArabicBold,
                    fontSize: 24.sp,
                    color: Colors.white,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 6.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.w),
                    child: Text(
                      subtitle!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.sp,
                        height: 1.4,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        SizedBox(height: bottom ?? 28.h),
      ],
    );
  }
}

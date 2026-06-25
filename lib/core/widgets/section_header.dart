import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../gen/fonts.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../constants/colors.dart';

/// A consistent, theme-aware section title used across the home & listing
/// screens — bold title, optional subtitle and an optional "see all" action
/// with a direction-aware chevron.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onSeeAll;
  final EdgeInsetsGeometry? padding;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onSeeAll,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isRtl = context.locale.languageCode == 'ar';

    return Padding(
      padding: padding ?? EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Accent bar + texts
          Container(
            width: 4.w,
            height: subtitle != null ? 34.h : 20.h,
            margin: EdgeInsetsDirectional.only(end: 10.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [palette.brand, palette.accent],
              ),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: FontFamily.dINArabicBold,
                    fontSize: 18.sp,
                    color: palette.textPrimary,
                  ),
                ),
                if (subtitle != null)
                  Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: palette.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: palette.brandSoft,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Row(
                  children: [
                    Text(
                      LocaleKeys.seeAll.tr(),
                      style: TextStyle(
                        fontFamily: FontFamily.dINArabicBold,
                        fontSize: 12.sp,
                        color: palette.brand,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      isRtl
                          ? Icons.arrow_back_ios_new_rounded
                          : Icons.arrow_forward_ios_rounded,
                      size: 11.sp,
                      color: palette.brand,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

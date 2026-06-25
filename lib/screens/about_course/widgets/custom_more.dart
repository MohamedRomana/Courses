import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/constants/colors.dart';
import 'package:unicourse/core/service/cubit/app_cubit.dart';
import 'package:unicourse/core/widgets/alert_dialog.dart';
import 'package:unicourse/generated/locale_keys.g.dart';
import '../../../core/models/courses.dart';
import '../../../core/widgets/app_router.dart';
import '../../../core/widgets/flash_message.dart';
import '../../../gen/fonts.gen.dart';
import '../../certificate_details/certificate_details.dart';
import 'custom_rating.dart';

class CustomMore extends StatelessWidget {
  final Course course;
  const CustomMore({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
        child: Column(
          children: [
            _MoreTile(
              icon: Icons.workspace_premium_rounded,
              color: AppColors.gold,
              title: LocaleKeys.course_completion_certificate.tr(),
              subtitle: isAr
                  ? 'استلم شهادتك بعد إتمام الدورة'
                  : 'Get your certificate after completion',
              onTap: () {
                if (AppCubit.get(context)
                    .completedCourses
                    .any((c) => c.title == course.title)) {
                  AppRouter.navigateTo(
                    context,
                    CertificateDetailScreen(course: course),
                  );
                } else {
                  showFlashMessage(
                    context: context,
                    type: FlashMessageType.warning,
                    message: isAr
                        ? 'لم تقم بالانتهاء من الدورة بعد'
                        : "You haven't completed the course yet",
                  );
                }
              },
            ),
            SizedBox(height: 12.h),
            _MoreTile(
              icon: Icons.star_rounded,
              color: context.palette.brand,
              title: LocaleKeys.rate_course_and_mentor.tr(),
              subtitle: isAr
                  ? 'شاركنا رأيك في الدورة والمدرّب'
                  : 'Share your feedback',
              onTap: () {
                customAlertDialog(
                  context: context,
                  dialogBackGroundColor: context.palette.surface,
                  alertDialogHeight: 280.h,
                  child: CustomRating(course: course),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MoreTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MoreTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isAr = context.locale.languageCode == 'ar';
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: palette.border),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(icon, color: color, size: 24.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: FontFamily.dINArabicBold,
                      fontSize: 14.sp,
                      color: palette.textPrimary,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      color: palette.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isAr
                  ? Icons.arrow_back_ios_new_rounded
                  : Icons.arrow_forward_ios_rounded,
              size: 14.sp,
              color: palette.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

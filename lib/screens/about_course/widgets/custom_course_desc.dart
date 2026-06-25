import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/colors.dart';
import '../../../core/models/courses.dart';
import '../../../core/service/cubit/app_cubit.dart';
import '../../../gen/fonts.gen.dart';
import '../../../generated/locale_keys.g.dart';

class CustomCourseDesc extends StatefulWidget {
  final Course course;
  const CustomCourseDesc({super.key, required this.course});

  @override
  State<CustomCourseDesc> createState() => _CustomCourseDescState();
}

class _CustomCourseDescState extends State<CustomCourseDesc> {
  @override
  void initState() {
    AppCubit.get(context).hasRead = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isAr = context.locale.languageCode == 'ar';
    final course = widget.course;

    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final collapsed = AppCubit.get(context).hasRead;
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Quick stats ──
                Row(
                  children: [
                    _StatCard(
                      icon: Icons.schedule_rounded,
                      label: LocaleKeys.course_duration.tr(),
                      value: '${course.time} ${isAr ? "ساعة" : "h"}',
                      color: palette.brand,
                    ),
                    SizedBox(width: 10.w),
                    _StatCard(
                      icon: Icons.translate_rounded,
                      label: LocaleKeys.course_language.tr(),
                      value: course.lang,
                      color: palette.accent,
                    ),
                    SizedBox(width: 10.w),
                    _StatCard(
                      icon: Icons.play_circle_outline_rounded,
                      label: isAr ? 'الدروس' : 'Lessons',
                      value: '${course.videosNum}',
                      color: AppColors.gold,
                    ),
                  ],
                ),
                SizedBox(height: 22.h),
                // ── Description ──
                Text(
                  LocaleKeys.description.tr(),
                  style: TextStyle(
                    fontFamily: FontFamily.dINArabicBold,
                    fontSize: 17.sp,
                    color: palette.textPrimary,
                  ),
                ),
                SizedBox(height: 10.h),
                AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  alignment: Alignment.topCenter,
                  child: Text(
                    course.desc,
                    maxLines: collapsed ? 4 : null,
                    overflow:
                        collapsed ? TextOverflow.ellipsis : TextOverflow.visible,
                    style: TextStyle(
                      fontSize: 14.5.sp,
                      height: 1.7,
                      color: palette.textSecondary,
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                GestureDetector(
                  onTap: () => AppCubit.get(context).readDesc(),
                  child: Row(
                    children: [
                      Text(
                        collapsed
                            ? (isAr ? 'قراءة المزيد' : 'Read more')
                            : (isAr ? 'عرض أقل' : 'Show less'),
                        style: TextStyle(
                          fontFamily: FontFamily.dINArabicBold,
                          fontSize: 13.sp,
                          color: palette.brand,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        collapsed
                            ? Icons.keyboard_arrow_down_rounded
                            : Icons.keyboard_arrow_up_rounded,
                        size: 20.sp,
                        color: palette.brand,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                // ── Instructor ──
                Text(
                  isAr ? 'المدرّب' : 'Instructor',
                  style: TextStyle(
                    fontFamily: FontFamily.dINArabicBold,
                    fontSize: 17.sp,
                    color: palette.textPrimary,
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: palette.surface,
                    borderRadius: BorderRadius.circular(18.r),
                    border: Border.all(color: palette.border),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 26.r,
                        backgroundColor: palette.brandSoft,
                        backgroundImage: AssetImage(course.image),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.name,
                              style: TextStyle(
                                fontFamily: FontFamily.dINArabicBold,
                                fontSize: 15.sp,
                                color: palette.textPrimary,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              course.doctorDesc,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: palette.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.verified_rounded,
                          color: palette.brand, size: 22.sp),
                    ],
                  ),
                ),
                SizedBox(height: 22.h),
                // ── Includes ──
                Text(
                  LocaleKeys.this_course_includes.tr(),
                  style: TextStyle(
                    fontFamily: FontFamily.dINArabicBold,
                    fontSize: 17.sp,
                    color: palette.textPrimary,
                  ),
                ),
                SizedBox(height: 12.h),
                _IncludeRow(
                  icon: Icons.schedule_rounded,
                  text:
                      '${course.time} ${isAr ? "ساعة من المحتوى" : "hours of content"}',
                ),
                _IncludeRow(
                  icon: Icons.ondemand_video_rounded,
                  text:
                      '${course.videosNum} ${isAr ? "مقطع متوفر في أي وقت" : "on-demand videos"}',
                ),
                _IncludeRow(
                  icon: Icons.workspace_premium_rounded,
                  text: isAr
                      ? 'شهادة إتمام الدورة'
                      : 'Certificate of completion',
                ),
                _IncludeRow(
                  icon: Icons.all_inclusive_rounded,
                  text: isAr ? 'وصول مدى الحياة' : 'Lifetime access',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 6.w),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: palette.border),
        ),
        child: Column(
          children: [
            Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: FontFamily.dINArabicBold,
                fontSize: 13.sp,
                color: palette.textPrimary,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 10.sp, color: palette.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

class _IncludeRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _IncludeRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(
              color: palette.brandSoft,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: palette.brand, size: 18.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13.sp, color: palette.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

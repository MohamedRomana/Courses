import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/constants/colors.dart';
import 'package:unicourse/generated/locale_keys.g.dart';
import '../../../core/service/cubit/app_cubit.dart';
import '../../../gen/fonts.gen.dart';

class MoreInLearningProgram extends StatelessWidget {
  final int index;
  const MoreInLearningProgram({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final program = AppCubit.get(context).learningProgramsList[index];
    final isAr = context.locale.languageCode == 'ar';

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.experts.tr(),
            style: TextStyle(
              fontFamily: FontFamily.dINArabicBold,
              fontSize: 18.sp,
              color: palette.textPrimary,
            ),
          ),
          SizedBox(height: 14.h),
          ...List.generate(program.doctors.length, (i) {
            final doctor = program.doctors[i];
            return Padding(
              padding: EdgeInsets.only(bottom: 14.h),
              child: Container(
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: palette.surface,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: palette.border),
                  boxShadow: [
                    BoxShadow(
                      color: palette.shadow,
                      blurRadius: 14.r,
                      offset: Offset(0, 6.r),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.r),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                                colors: [palette.brand, palette.accent]),
                          ),
                          child: CircleAvatar(
                            radius: 30.r,
                            backgroundColor: palette.brandSoft,
                            backgroundImage: AssetImage(doctor.image),
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doctor.name,
                                style: TextStyle(
                                  fontFamily: FontFamily.dINArabicBold,
                                  fontSize: 15.sp,
                                  color: palette.textPrimary,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                doctor.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        _stat(
                          context,
                          Icons.people_alt_rounded,
                          '${doctor.followersCount}',
                          LocaleKeys.learners.tr(),
                        ),
                        SizedBox(width: 10.w),
                        _stat(
                          context,
                          Icons.play_circle_outline_rounded,
                          '${doctor.coursesCount}',
                          isAr ? 'دورات' : 'courses',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _stat(
      BuildContext context, IconData icon, String value, String label) {
    final palette = context.palette;
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: palette.surfaceAlt,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18.sp, color: palette.brand),
            SizedBox(width: 6.w),
            Text(
              '$value ',
              style: TextStyle(
                fontFamily: FontFamily.dINArabicBold,
                fontSize: 13.sp,
                color: palette.textPrimary,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 11.sp, color: palette.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/generated/locale_keys.g.dart';
import '../../../core/constants/colors.dart';
import '../../../core/service/cubit/app_cubit.dart';
import '../../../gen/fonts.gen.dart';

class AboutLearningProgram extends StatefulWidget {
  final int index;
  const AboutLearningProgram({super.key, required this.index});

  @override
  State<AboutLearningProgram> createState() => _AboutLearningProgramState();
}

class _AboutLearningProgramState extends State<AboutLearningProgram> {
  @override
  void initState() {
    AppCubit.get(context).hasRead = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final program = AppCubit.get(context).learningProgramsList[widget.index];
    final isAr = context.locale.languageCode == 'ar';

    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final collapsed = AppCubit.get(context).hasRead;
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 30.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.what_you_will_learn.tr(),
                style: TextStyle(
                  fontFamily: FontFamily.dINArabicBold,
                  fontSize: 18.sp,
                  color: palette.textPrimary,
                ),
              ),
              SizedBox(height: 14.h),
              ...List.generate(program.whatYouLearn.length, (i) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 26.w,
                        height: 26.w,
                        decoration: BoxDecoration(
                          color: palette.brandSoft,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(Icons.check_rounded,
                            color: palette.brand, size: 16.sp),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 3.h),
                          child: Text(
                            program.whatYouLearn[i].title,
                            style: TextStyle(
                              fontSize: 14.sp,
                              height: 1.4,
                              color: palette.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              SizedBox(height: 14.h),
              Text(
                LocaleKeys.about_learning_program.tr(),
                style: TextStyle(
                  fontFamily: FontFamily.dINArabicBold,
                  fontSize: 18.sp,
                  color: palette.textPrimary,
                ),
              ),
              SizedBox(height: 10.h),
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                alignment: Alignment.topCenter,
                child: Text(
                  program.desc,
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
            ],
          ),
        );
      },
    );
  }
}

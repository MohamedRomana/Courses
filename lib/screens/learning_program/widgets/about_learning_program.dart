import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/generated/locale_keys.g.dart';

import '../../../core/constants/colors.dart';
import '../../../core/service/cubit/app_cubit.dart';
import '../../../core/widgets/app_text.dart';
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
    final learningProgramsList =
        AppCubit.get(context).learningProgramsList[widget.index];
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                start: 16.w,
                top: 24.h,
                text: LocaleKeys.what_you_will_learn.tr(),
                size: 18.sp,
                family: FontFamily.dINArabicBold,
              ),
              ListView.separated(
                padding: EdgeInsets.all(16.r),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: learningProgramsList.whatYouLearn.length,
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder:
                    (context, index) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.done, color: AppColors.primary, size: 24.sp),
                        SizedBox(
                          width: 300.w,
                          child: AppText(
                            text:
                                learningProgramsList.whatYouLearn[index].title,
                            size: 14.sp,
                            color: AppColors.primary,
                            start: 10.w,
                            lines: 5,
                          ),
                        ),
                      ],
                    ),
              ),
              AppText(
                start: 16.w,
                top: 24.h,
                bottom: 16.h,
                text: LocaleKeys.about_learning_program.tr(),
                size: 18.sp,
                family: FontFamily.dINArabicBold,
              ),
              Stack(
                children: [
                  AppText(
                    start: 16.w,
                    end: 16.w,
                    bottom: AppCubit.get(context).hasRead ? 16.h : 25.h,
                    textAlign: TextAlign.center,
                    text: learningProgramsList.desc,
                    lines: AppCubit.get(context).hasRead ? 4 : 100,
                    size: 16.sp,
                  ),
                  AppCubit.get(context).hasRead
                      ? Container(
                        height: 100.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.scaffoldBackgroundColor.withAlpha(100),
                              AppColors.scaffoldBackgroundColor.withAlpha(200),
                              AppColors.scaffoldBackgroundColor,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      )
                      : const SizedBox.shrink(),
                  PositionedDirectional(
                    bottom: AppCubit.get(context).hasRead ? 0.h : -10.h,
                    start: 16.w,
                    end: 16.w,
                    child: IconButton(
                      onPressed: () {
                        AppCubit.get(context).readDesc();
                      },
                      icon: Icon(
                        AppCubit.get(context).hasRead
                            ? Icons.arrow_circle_down
                            : Icons.arrow_circle_up,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
            ],
          ),
        );
      },
    );
  }
}

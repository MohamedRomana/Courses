import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unicourse/generated/locale_keys.g.dart';
import '../../../../core/service/cubit/app_cubit.dart';
import 'courses_rail.dart';

class CompeletedCourses extends StatelessWidget {
  const CompeletedCourses({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return CoursesRail(
          title: LocaleKeys.completed_courses.tr(),
          courses: AppCubit.get(context).completedCourses,
        );
      },
    );
  }
}

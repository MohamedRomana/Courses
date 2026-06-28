import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unicourse/core/service/cubit/app_cubit.dart';
import 'package:unicourse/core/widgets/courses_grid_screen.dart';
import '../../generated/locale_keys.g.dart';

class SelectedCourses extends StatelessWidget {
  const SelectedCourses({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return CoursesGridScreen(
          title: LocaleKeys.selected_courses.tr(),
          courses: AppCubit.get(context).selectedCourses,
        );
      },
    );
  }
}

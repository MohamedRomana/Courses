import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unicourse/core/service/cubit/app_cubit.dart';
import 'package:unicourse/core/widgets/courses_grid_screen.dart';
import 'package:unicourse/generated/locale_keys.g.dart';

class MostViewed extends StatelessWidget {
  const MostViewed({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return CoursesGridScreen(
          title: LocaleKeys.most_viewed.tr(),
          courses: AppCubit.get(context).courses,
        );
      },
    );
  }
}

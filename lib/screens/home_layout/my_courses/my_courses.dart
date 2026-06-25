import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unicourse/core/service/cubit/app_cubit.dart';
import 'package:unicourse/generated/locale_keys.g.dart';
import '../../../core/cache/cache_helper.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_lottie_widget.dart';
import '../../../core/widgets/no_account_alert.dart';
import '../../../gen/assets.gen.dart';
import 'widgets/compeleted_courses.dart';
import 'widgets/favourite_courses.dart';
import 'widgets/my_courses_listview.dart';

class MyCourses extends StatelessWidget {
  const MyCourses({super.key});

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(title: LocaleKeys.myCourses.tr(), isNoti: false),
          body:
              CacheHelper.getUserId() == ""
                  ? const NoAcoountAlert()
                  : cubit.selectedCourses.isEmpty &&
                      cubit.savedCourses.isEmpty &&
                      cubit.completedCourses.isEmpty
                  ? CustomLottieWidget(lottieName: Assets.img.emptyorder)
                  : const SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyCoursesListview(),
                        FavouriteCourses(),
                        CompeletedCourses(),
                      ],
                    ),
                  ),
        );
      },
    );
  }
}

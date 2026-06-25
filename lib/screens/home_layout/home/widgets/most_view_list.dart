import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/service/cubit/app_cubit.dart';
import 'package:unicourse/core/widgets/course_card.dart';
import 'package:unicourse/core/widgets/section_header.dart';
import 'package:unicourse/generated/locale_keys.g.dart';
import '../../../../core/widgets/app_router.dart';
import '../../../about_course/about_course.dart';
import '../../../most_viewed/most_viewed.dart';

class MostViewList extends StatelessWidget {
  const MostViewList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final cubit = AppCubit.get(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 22.h),
            SectionHeader(
              title: LocaleKeys.most_viewed.tr(),
              onSeeAll: () =>
                  AppRouter.navigateTo(context, const MostViewed()),
            ),
            SizedBox(
              height: 190.h,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 4.h),
                itemCount: cubit.courses.length,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (_, __) => SizedBox(width: 14.w),
                itemBuilder: (context, index) {
                  final course = cubit.courses[index];
                  return FeaturedCourseCard(
                    course: course,
                    onTap: () => AppRouter.navigateTo(
                      context,
                      AboutCourse(course: course),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

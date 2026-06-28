import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:unicourse/core/constants/colors.dart';
import 'package:unicourse/core/widgets/app_input.dart';
import 'package:unicourse/core/widgets/course_card.dart';
import 'package:unicourse/core/widgets/custom_lottie_widget.dart';
import 'package:unicourse/gen/assets.gen.dart';
import 'package:unicourse/generated/locale_keys.g.dart';
import '../../../core/service/cubit/app_cubit.dart';
import '../../../core/widgets/app_router.dart';
import '../../../gen/fonts.gen.dart';
import '../../about_course/about_course.dart';

final _searchController = TextEditingController();

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  void initState() {
    super.initState();
    _searchController.clear();
    AppCubit.get(context).searchCourses("");
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<AppCubit, AppState>(
          builder: (context, state) {
            final cubit = AppCubit.get(context);
            final query = cubit.searchQuery;
            final results = cubit.filteredCourses;

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 6.h),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      LocaleKeys.search.tr(),
                      style: TextStyle(
                        fontFamily: FontFamily.dINArabicBold,
                        fontSize: 24.sp,
                        color: palette.textPrimary,
                      ),
                    ),
                  ),
                ),
                AppInput(
                  start: 20.w,
                  end: 20.w,
                  top: 6.h,
                  bottom: 6.h,
                  filled: true,
                  textInputAction: TextInputAction.search,
                  hint: LocaleKeys.what_would_you_like_to_learn.tr(),
                  controller: _searchController,
                  prefixIcon: Icon(CupertinoIcons.search,
                      color: palette.brand, size: 22.sp),
                  suffixIcon: query.isEmpty
                      ? null
                      : InkWell(
                          onTap: () {
                            _searchController.clear();
                            cubit.searchCourses("");
                          },
                          child: Icon(Icons.close_rounded,
                              color: palette.textMuted, size: 20.sp),
                        ),
                  onChanged: cubit.searchCourses,
                  onSubmitted: cubit.searchCourses,
                ),
                Expanded(
                  child: query.isEmpty
                      ? _hint(context, palette)
                      : results.isEmpty
                          ? CustomLottieWidget(
                              lottieName: Assets.img.emptysearch)
                          : _grid(context, results),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _hint(BuildContext context, AppPalette palette) {
    final isAr = context.locale.languageCode == 'ar';
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96.w,
            height: 96.w,
            decoration: BoxDecoration(
              color: palette.brandSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(CupertinoIcons.search,
                size: 42.sp, color: palette.brand),
          ),
          SizedBox(height: 18.h),
          Text(
            isAr ? 'ابحث عن دورتك' : 'Search for a course',
            style: TextStyle(
              fontFamily: FontFamily.dINArabicBold,
              fontSize: 17.sp,
              color: palette.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            isAr
                ? 'اكتب اسم الدورة أو المدرّب'
                : 'Type a course or instructor name',
            style: TextStyle(fontSize: 13.sp, color: palette.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _grid(BuildContext context, List results) {
    return AnimationLimiter(
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 110.h),
        itemCount: results.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 0.62,
        ),
        itemBuilder: (context, index) {
          final course = results[index];
          return AnimationConfiguration.staggeredGrid(
            position: index,
            columnCount: 2,
            duration: const Duration(milliseconds: 400),
            child: ScaleAnimation(
              scale: 0.94,
              child: FadeInAnimation(
                child: CourseCard(
                  course: course,
                  width: double.infinity,
                  onTap: () => AppRouter.navigateTo(
                    context,
                    AboutCourse(course: course),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

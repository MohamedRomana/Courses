// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/widgets/app_input.dart';
import 'package:unicourse/core/widgets/app_text.dart';
import 'package:unicourse/core/widgets/custom_lottie_widget.dart';
import 'package:unicourse/gen/assets.gen.dart';
import 'package:unicourse/generated/locale_keys.g.dart';
import '../../../core/constants/colors.dart';
import '../../../core/service/cubit/app_cubit.dart';
import '../../../core/widgets/app_router.dart';
import '../../../core/widgets/custom_appbar.dart';
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
    _searchController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(title: LocaleKeys.search.tr(), isNoti: false),
          body: Column(
            children: [
              AppInput(
                top: 20.h,
                bottom: 5.h,
                filled: true,
                textInputAction: TextInputAction.search,
                hint: LocaleKeys.what_would_you_like_to_learn.tr(),
                controller: _searchController,
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  color: AppColors.primary,
                  size: 25.sp,
                ),
                onChanged: (value) {
                  final cubit = AppCubit.get(context);
                  if (value != null && value.trim().isNotEmpty) {
                    final searchValue = value.toLowerCase();

                    cubit.filteredCourses =
                        cubit.courses.where((course) {
                          final titleMatch = course.title
                              .toLowerCase()
                              .contains(searchValue);
                          final nameMatch = course.name.toLowerCase().contains(
                            searchValue,
                          );
                          return titleMatch || nameMatch;
                        }).toList();
                  } else {
                    cubit.filteredCourses = cubit.courses;
                  }
                  cubit.emit(ChangeIndex());
                },
                onSubmitted: (value) {
                  final cubit = AppCubit.get(context);
                  if (value != null && value.trim().isNotEmpty) {
                    final searchValue = value.toLowerCase();

                    cubit.filteredCourses =
                        cubit.courses.where((course) {
                          final titleMatch = course.title
                              .toLowerCase()
                              .contains(searchValue);
                          final nameMatch = course.name.toLowerCase().contains(
                            searchValue,
                          );
                          return titleMatch || nameMatch;
                        }).toList();
                  } else {
                    cubit.filteredCourses = cubit.courses;
                  }
                  cubit.emit(ChangeIndex());
                },
              ),
              Expanded(
                child:
                    _searchController.text.trim().isEmpty ||
                            AppCubit.get(context).filteredCourses.isEmpty
                        ? CustomLottieWidget(lottieName: Assets.img.emptysearch)
                        : GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            vertical: 24.h,
                            horizontal: 16.w,
                          ),
                          itemCount:
                              AppCubit.get(context).filteredCourses.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.59,
                              ),
                          itemBuilder:
                              (context, index) => InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  AppRouter.navigateTo(
                                    context,
                                    AboutCourse(
                                      course:
                                          AppCubit.get(
                                            context,
                                          ).filteredCourses[index],
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: 200.h,
                                      width: 160.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            AppCubit.get(
                                              context,
                                            ).filteredCourses[index].image,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 130.w,
                                      child: AppText(
                                        top: 5.h,
                                        bottom: 3.h,
                                        textAlign: TextAlign.start,
                                        text:
                                            AppCubit.get(
                                              context,
                                            ).filteredCourses[index].title,
                                        size: 14.sp,
                                        lines: 2,
                                        family: FontFamily.dINArabicBold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 130.w,
                                      child: AppText(
                                        text:
                                            AppCubit.get(
                                              context,
                                            ).filteredCourses[index].name,
                                        size: 12.sp,
                                        lines: 2,
                                        color: Colors.black.withAlpha(100),
                                        family: FontFamily.dINArabicBold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        ),
              ),
            ],
          ),
        );
      },
    );
  }
}

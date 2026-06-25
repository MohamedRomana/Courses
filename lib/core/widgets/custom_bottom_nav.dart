import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../generated/locale_keys.g.dart';
import '../../screens/home_layout/home_layout.dart';
import '../constants/colors.dart';
import '../service/cubit/app_cubit.dart';
import 'app_router.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: AppCubit.get(context).bottomNavIndex,
      backgroundColor: AppColors.primary,
      selectedItemColor: AppColors.borderColor,
      unselectedItemColor: AppColors.borderColor,
      showUnselectedLabels: true,
      elevation: 0,
      enableFeedback: true,
      selectedLabelStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.secondray,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.borderColor,
      ),
      onTap: (index) {
        AppCubit.get(context).changebottomNavIndex(index);
        AppRouter.navigateAndFinish(context, const HomeLayout());
      },
      items: [
        BottomNavigationBarItem(
          backgroundColor: AppColors.primary,
          icon: Icon(CupertinoIcons.house_fill, size: 25.sp),
          label: LocaleKeys.home.tr(),
        ),
        BottomNavigationBarItem(
          backgroundColor: AppColors.primary,
          icon: Icon(CupertinoIcons.search, size: 25.sp),
          label: LocaleKeys.search.tr(),
        ),
        BottomNavigationBarItem(
          backgroundColor: AppColors.primary,
          icon: Icon(Icons.school, size: 25.sp),
          label: LocaleKeys.myCourses.tr(),
        ),
        BottomNavigationBarItem(
          backgroundColor: AppColors.primary,
          icon: Icon(CupertinoIcons.profile_circled, size: 25.sp),
          label: LocaleKeys.profile.tr(),
        ),
      ],
    );
  }
}

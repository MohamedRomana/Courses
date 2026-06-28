import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/service/cubit/app_cubit.dart';
import '../../../../core/service/cubit/theme_cubit.dart';
import '../../../../core/widgets/app_router.dart';
import '../../../../gen/fonts.gen.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../notifications/notifications.dart';

/// The home screen's hero header — a brand gradient panel with a greeting,
/// a theme switch, a notifications button and a tappable search field that
/// jumps to the search tab.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isAr = context.locale.languageCode == 'ar';

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 22.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: palette.heroGradient,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.r)),
        boxShadow: [
          BoxShadow(
            color: palette.heroGradient.first.withValues(alpha: 0.35),
            blurRadius: 24.r,
            offset: Offset(0, 10.r),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAr ? 'مرحباً بك 👋' : 'Welcome 👋',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        isAr
                            ? 'اكتشف دورتك القادمة'
                            : 'Discover your next course',
                        style: TextStyle(
                          fontFamily: FontFamily.dINArabicBold,
                          fontSize: 20.sp,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const _ThemeToggleButton(),
                SizedBox(width: 10.w),
                _GlassIconButton(
                  icon: Icons.notifications_none_rounded,
                  onTap: () => AppRouter.navigateTo(
                      context, const NotificationsScreen()),
                  showDot: AppCubit.get(context).unreadNotifications > 0,
                ),
              ],
            ),
            SizedBox(height: 18.h),
            _SearchField(
              hint: LocaleKeys.what_would_you_like_to_learn.tr(),
              onTap: () => AppCubit.get(context).changebottomNavIndex(1),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeToggleButton extends StatelessWidget {
  const _ThemeToggleButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) {
        final isDark = ThemeCubit.get(context).isDark(context);
        return _GlassIconButton(
          icon: isDark
              ? Icons.dark_mode_rounded
              : Icons.light_mode_rounded,
          onTap: () => ThemeCubit.get(context).toggle(context),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, anim) => RotationTransition(
              turns: Tween(begin: 0.6, end: 1.0).animate(anim),
              child: FadeTransition(opacity: anim, child: child),
            ),
            child: Icon(
              isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              key: ValueKey(isDark),
              color: isDark ? AppColors.gold : Colors.white,
              size: 22.sp,
            ),
          ),
        );
      },
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool showDot;
  final Widget? child;

  const _GlassIconButton({
    required this.icon,
    required this.onTap,
    this.showDot = false,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            child ?? Icon(icon, color: Colors.white, size: 22.sp),
            if (showDot)
              PositionedDirectional(
                top: 11.h,
                end: 12.w,
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final String hint;
  final VoidCallback onTap;
  const _SearchField({required this.hint, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 14.r,
              offset: Offset(0, 6.r),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.search_rounded,
                color: AppColors.primary, size: 22.sp),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                hint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF8A8FA3),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(7.r),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: AppColors.brandGradient),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Icons.tune_rounded,
                  color: Colors.white, size: 16.sp),
            ),
          ],
        ),
      ),
    );
  }
}

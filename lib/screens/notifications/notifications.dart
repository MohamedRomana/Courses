import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:unicourse/core/constants/colors.dart';
import 'package:unicourse/core/models/app_notification.dart';
import 'package:unicourse/core/service/cubit/app_cubit.dart';
import 'package:unicourse/core/widgets/custom_appbar.dart';
import 'package:unicourse/generated/locale_keys.g.dart';
import '../../gen/fonts.gen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isAr = context.locale.languageCode == 'ar';
    return Scaffold(
      appBar: CustomAppBar(
        title: LocaleKeys.notifications.tr(),
        isNoti: true,
      ),
      body: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          final cubit = AppCubit.get(context);
          final items = cubit.notifications;

          if (items.isEmpty) {
            return _empty(context, isAr);
          }

          return Column(
            children: [
              if (cubit.unreadNotifications > 0)
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
                    child: GestureDetector(
                      onTap: cubit.markAllNotificationsRead,
                      child: Text(
                        isAr ? 'تعليم الكل كمقروء' : 'Mark all as read',
                        style: TextStyle(
                          fontFamily: FontFamily.dINArabicBold,
                          fontSize: 12.sp,
                          color: palette.brand,
                        ),
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: AnimationLimiter(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 24.h),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 350),
                        child: SlideAnimation(
                          verticalOffset: 30,
                          child: FadeInAnimation(
                            child: _NotificationCard(
                              item: items[index],
                              isAr: isAr,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _empty(BuildContext context, bool isAr) {
    final palette = context.palette;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96.w,
            height: 96.w,
            decoration:
                BoxDecoration(color: palette.brandSoft, shape: BoxShape.circle),
            child: Icon(Icons.notifications_off_outlined,
                size: 42.sp, color: palette.brand),
          ),
          SizedBox(height: 16.h),
          Text(
            LocaleKeys.noNotifications.tr(),
            style: TextStyle(
              fontFamily: FontFamily.dINArabicBold,
              fontSize: 17.sp,
              color: palette.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final AppNotification item;
  final bool isAr;
  const _NotificationCard({required this.item, required this.isAr});

  Color _accent(AppPalette palette) {
    switch (item.type) {
      case NotificationType.course:
        return palette.brand;
      case NotificationType.offer:
        return AppColors.gold;
      case NotificationType.achievement:
        return palette.success;
      case NotificationType.system:
        return palette.accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final accent = _accent(palette);
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: item.read ? palette.surface : palette.brandSoft,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: item.read ? palette.border : palette.brand.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46.w,
            height: 46.w,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(item.icon, color: accent, size: 24.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title(isAr),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: FontFamily.dINArabicBold,
                          fontSize: 14.sp,
                          color: palette.textPrimary,
                        ),
                      ),
                    ),
                    if (!item.read)
                      Container(
                        width: 8.w,
                        height: 8.w,
                        margin: EdgeInsetsDirectional.only(start: 6.w),
                        decoration:
                            BoxDecoration(color: accent, shape: BoxShape.circle),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  item.body(isAr),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    height: 1.4,
                    color: palette.textSecondary,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(Icons.schedule_rounded,
                        size: 12.sp, color: palette.textMuted),
                    SizedBox(width: 4.w),
                    Text(
                      item.time(isAr),
                      style: TextStyle(fontSize: 11.sp, color: palette.textMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

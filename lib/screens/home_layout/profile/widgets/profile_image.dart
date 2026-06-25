import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/constants/colors.dart';
import 'package:unicourse/core/service/cubit/app_cubit.dart';
import 'package:unicourse/core/widgets/custom_shimmer.dart';
import '../../../../gen/fonts.gen.dart';
import '../../../../core/widgets/app_router.dart';
import '../../../profile_edit/profile_edit.dart';

/// Profile header card: avatar (with edit badge), name and email.
class ProfileImage extends StatefulWidget {
  const ProfileImage({super.key});

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  @override
  void initState() {
    AppCubit.get(context).getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final cubit = AppCubit.get(context);
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final loading =
            state is GetUserDataLoading && cubit.userModel.isEmpty;
        final name = (cubit.userModel["first_name"] ?? '').toString();
        final email = (cubit.userModel["email"] ?? '').toString();
        final phone = (cubit.userModel["phone"] ?? '').toString();
        final avatar = (cubit.userModel["avatar"] ?? '').toString();

        return Container(
          padding: EdgeInsets.all(18.r),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: palette.heroGradient,
            ),
            borderRadius: BorderRadius.circular(26.r),
            boxShadow: [
              BoxShadow(
                color: palette.heroGradient.first.withValues(alpha: 0.35),
                blurRadius: 20.r,
                offset: Offset(0, 10.r),
              ),
            ],
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => AppRouter.navigateTo(context, const ProfileEdit()),
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(3.r),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.6),
                            width: 2),
                      ),
                      child: loading
                          ? CustomShimmer(
                              height: 72.w, width: 72.w, radius: 1000.r)
                          : _Avatar(avatar: avatar, name: name, size: 72.w),
                    ),
                    PositionedDirectional(
                      end: 0,
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.all(5.r),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.edit_rounded,
                            size: 13.sp, color: palette.brand),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loading ? '...' : name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: FontFamily.dINArabicBold,
                        fontSize: 18.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    if (email.isNotEmpty)
                      _line(Icons.email_outlined, email)
                    else if (phone.isNotEmpty)
                      _line(Icons.phone_outlined, phone),
                    SizedBox(height: 8.h),
                    GestureDetector(
                      onTap: () =>
                          AppRouter.navigateTo(context, const ProfileEdit()),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(30.r),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit_outlined,
                                size: 13.sp, color: Colors.white),
                            SizedBox(width: 5.w),
                            Text(
                              context.locale.languageCode == 'ar'
                                  ? 'تعديل الملف'
                                  : 'Edit profile',
                              style: TextStyle(
                                fontFamily: FontFamily.dINArabicBold,
                                fontSize: 11.sp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _line(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 13.sp, color: Colors.white70),
        SizedBox(width: 5.w),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ),
      ],
    );
  }
}

/// Renders a profile avatar from a network URL, a local file path, or falls
/// back to the user's initial on a soft background.
class _Avatar extends StatelessWidget {
  final String avatar;
  final String name;
  final double size;
  const _Avatar({required this.avatar, required this.name, required this.size});

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (avatar.isEmpty) {
      child = Container(
        color: Colors.white.withValues(alpha: 0.25),
        alignment: Alignment.center,
        child: Text(
          name.isNotEmpty ? name.characters.first : '?',
          style: TextStyle(
            fontFamily: FontFamily.dINArabicBold,
            fontSize: size * 0.4,
            color: Colors.white,
          ),
        ),
      );
    } else if (avatar.startsWith('http')) {
      child = CachedNetworkImage(
        imageUrl: avatar,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) =>
            Icon(Icons.person, color: Colors.white, size: size * 0.5),
      );
    } else {
      child = Image.file(
        File(avatar),
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            Icon(Icons.person, color: Colors.white, size: size * 0.5),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(1000.r),
      child: SizedBox(width: size, height: size, child: child),
    );
  }
}

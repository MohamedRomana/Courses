import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/widgets/app_text.dart';
import '../../gen/fonts.gen.dart';
import '../constants/colors.dart';
import 'app_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  /// When true a back button is shown (kept name for backwards-compat).
  final bool isNoti;

  const CustomAppBar({super.key, required this.title, this.isNoti = true});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final showBack = isNoti && Navigator.canPop(context);
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: palette.background,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleSpacing: 0,
      leadingWidth: showBack ? 56.w : 0,
      leading: showBack
          ? Padding(
              padding: EdgeInsetsDirectional.only(start: 16.w),
              child: GestureDetector(
                onTap: () => AppRouter.pop(context),
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: palette.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: palette.border),
                  ),
                  child: Icon(
                    Directionality.of(context) == TextDirection.rtl
                        ? Icons.arrow_forward_ios_rounded
                        : Icons.arrow_back_ios_new_rounded,
                    color: palette.textPrimary,
                    size: 17.sp,
                  ),
                ),
              ),
            )
          : null,
      title: AppText(
        text: title,
        size: 18.sp,
        color: palette.textPrimary,
        family: FontFamily.dINArabicBold,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

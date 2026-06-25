import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/widgets/app_text.dart';
import '../../gen/fonts.gen.dart';
import '../constants/colors.dart';
import 'app_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isNoti;

  const CustomAppBar({super.key, required this.title, this.isNoti = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.primary,
      surfaceTintColor: AppColors.primary,
      centerTitle: true,
      title: AppText(
        text: title,
        size: 18.sp,
        color: Colors.white,
        family: FontFamily.dINArabicBold,
      ),
      actions: [
        if (isNoti)
          IconButton(
            onPressed: () {
              AppRouter.pop(context);
            },
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

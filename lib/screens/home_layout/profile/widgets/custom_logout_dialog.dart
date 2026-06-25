import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/gen/fonts.gen.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/service/cubit/app_cubit.dart';
import '../../../../core/widgets/alert_dialog.dart';
import '../../../../core/widgets/app_router.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/flash_message.dart';
import '../../../../core/widgets/logout_dialog.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../auth/data/auth_cubit.dart';
import 'custom_delete_account.dart';

class CustomLogOutDialog extends StatelessWidget {
  const CustomLogOutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LogOutLoading) {
          showLoadingDialog(context: context, isLottie: true);
        } else if (state is LogOutSuccess) {
          AppCubit.get(context).userModel = {};
          AppRouter.pop(context);
          AppCubit.get(context).changebottomNavIndex(0);
          showFlashMessage(
            context: context,
            type: FlashMessageType.success,
            message: state.message,
          );
        } else if (state is LogOutFailure) {
          AppRouter.pop(context);
          showFlashMessage(
            context: context,
            type: FlashMessageType.error,
            message: state.error,
          );
        } else if (state is DeleteAccountLoading) {
          showLoadingDialog(context: context, isLottie: true);
        }
        if (state is DeleteAccountSuccess) {
          AppCubit.get(context).userModel = {};
          AppRouter.pop(context);
          AppCubit.get(context).changebottomNavIndex(0);
          showFlashMessage(
            context: context,
            type: FlashMessageType.success,
            message: state.message,
          );
        } else if (state is DeleteAccountFailure) {
          AppRouter.pop(context);
          showFlashMessage(
            context: context,
            type: FlashMessageType.error,
            message: state.error,
          );
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                customAlertDialog(
                  context: context,
                  dialogBackGroundColor: AppColors.scaffoldBackgroundColor,
                  child: const CustomDeleteAccount(),
                );
              },
              child: SizedBox(
                height: 40.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.block, size: 28.sp),
                        AppText(
                          text: LocaleKeys.deleteAccount.tr(),
                          size: 18.sp,
                          color: Colors.black,
                          family: FontFamily.dINArabicBold,
                          start: 10.w,
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 18.sp,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                customAlertDialog(
                  context: context,
                  dialogBackGroundColor: AppColors.scaffoldBackgroundColor,
                  child: const LogoutDialog(),
                );
              },
              child: AppText(
                text: LocaleKeys.logout.tr(),
                family: FontFamily.dINArabicBold,
                size: 18.sp,
              ),
            ),
          ],
        );
      },
    );
  }
}

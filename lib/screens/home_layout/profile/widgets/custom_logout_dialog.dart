import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/service/cubit/app_cubit.dart';
import '../../../../core/widgets/alert_dialog.dart';
import '../../../../core/widgets/app_router.dart';
import '../../../../core/widgets/flash_message.dart';
import '../../../../core/widgets/logout_dialog.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../auth/data/auth_cubit.dart';
import 'custom_delete_account.dart';
import 'profile_tile.dart';

class CustomLogOutDialog extends StatelessWidget {
  const CustomLogOutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';
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
        return ProfileSection(
          title: isAr ? 'الحساب والخروج' : 'Account & session',
          children: [
            ProfileTile(
              icon: Icons.logout_rounded,
              title: LocaleKeys.logout.tr(),
              onTap: () => customAlertDialog(
                context: context,
                dialogBackGroundColor: context.palette.surface,
                child: const LogoutDialog(),
              ),
            ),
            Divider(height: 1, color: context.palette.border),
            ProfileTile(
              icon: Icons.delete_outline_rounded,
              danger: true,
              title: LocaleKeys.deleteAccount.tr(),
              onTap: () => customAlertDialog(
                context: context,
                dialogBackGroundColor: context.palette.surface,
                child: const CustomDeleteAccount(),
              ),
            ),
          ],
        );
      },
    );
  }
}

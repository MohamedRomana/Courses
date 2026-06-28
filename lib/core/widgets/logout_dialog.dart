import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../generated/locale_keys.g.dart';
import '../constants/colors.dart';
import '../../screens/auth/data/auth_cubit.dart';
import 'app_router.dart';
import 'confirm_dialog.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ConfirmDialogContent(
      icon: Icons.logout_rounded,
      accent: context.palette.error,
      title: LocaleKeys.logout.tr(),
      subtitle: LocaleKeys.logOutSubtitle.tr(),
      confirmText: LocaleKeys.logout.tr(),
      onConfirm: () {
        AppRouter.pop(context);
        AuthCubit.get(context).logOut();
      },
    );
  }
}

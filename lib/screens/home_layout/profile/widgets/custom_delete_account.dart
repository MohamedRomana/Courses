import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../auth/data/auth_cubit.dart';

class CustomDeleteAccount extends StatelessWidget {
  const CustomDeleteAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return ConfirmDialogContent(
      icon: Icons.delete_outline_rounded,
      accent: context.palette.error,
      title: LocaleKeys.deleteAccount.tr(),
      subtitle: LocaleKeys.deleteAccountSubtitle.tr(),
      confirmText: LocaleKeys.deleteAccount.tr(),
      onConfirm: () => AuthCubit.get(context).deleteAccount(),
    );
  }
}

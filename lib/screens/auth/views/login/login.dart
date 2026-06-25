import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/constants/colors.dart';
import 'package:unicourse/core/widgets/app_router.dart';
import 'package:unicourse/core/widgets/primary_button.dart';
import 'package:unicourse/generated/locale_keys.g.dart';
import '../../../../../core/service/cubit/app_cubit.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/flash_message.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../home_layout/home_layout.dart';
import '../../data/auth_cubit.dart';
import '../forget_pass/forget_pass.dart';
import '../register/register.dart';
import '../widgets/auth_header.dart';
import 'widgets/login_fields.dart';

final _formKey = GlobalKey<FormState>();
final _phoneController = TextEditingController();
final _passController = TextEditingController();
String phoneCode = "";

class LogIn extends StatelessWidget {
  const LogIn({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            CustomAuthHeader(
              text: LocaleKeys.login.tr(),
              subtitle: isAr
                  ? 'سجّل دخولك وكمّل رحلة تعلّمك'
                  : 'Sign in and continue learning',
            ),
            CustomLoginFields(
              formKey: _formKey,
              phoneController: _phoneController,
              passController: _passController,
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: () =>
                    AppRouter.navigateTo(context, const ForgetPass()),
                child: AppText(
                  text: LocaleKeys.forgetPass.tr(),
                  size: 13.sp,
                  end: 18.w,
                  color: context.palette.brand,
                  family: FontFamily.dINArabicBold,
                ),
              ),
            ),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is LogInSuccess) {
                  AppCubit.get(context).changebottomNavIndex(0);
                  AppRouter.navigateAndFinish(context, const HomeLayout());
                  _phoneController.clear();
                  _passController.clear();
                  showFlashMessage(
                    context: context,
                    type: FlashMessageType.success,
                    message: LocaleKeys.welcomeValuedCustomer.tr(),
                  );
                } else if (state is LogInFailure) {
                  showFlashMessage(
                    context: context,
                    type: FlashMessageType.error,
                    message: state.error,
                  );
                }
              },
              builder: (context, state) {
                return PrimaryButton(
                  text: LocaleKeys.signin.tr(),
                  icon: Icons.login_rounded,
                  loading: state is LogInLoading,
                  margin: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 20.h),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await AuthCubit.get(context).logIn(
                        phone: _phoneController.text,
                        password: _passController.text,
                      );
                    }
                  },
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  text: LocaleKeys.dontHaveAccount.tr(),
                  size: 14.sp,
                  color: context.palette.textSecondary,
                ),
                TextButton(
                  onPressed: () =>
                      AppRouter.navigateTo(context, const Register()),
                  child: AppText(
                    text: LocaleKeys.newUser.tr(),
                    size: 14.sp,
                    color: context.palette.brand,
                    family: FontFamily.dINArabicBold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

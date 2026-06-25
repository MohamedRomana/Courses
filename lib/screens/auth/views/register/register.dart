import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/screens/auth/views/otp/otp.dart';
import 'package:unicourse/screens/auth/views/register/widgets/user_fields.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../data/auth_cubit.dart';
import '../widgets/auth_header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/widgets/app_button.dart';
import '../../../../../../core/widgets/app_router.dart';
import '../../../../../../core/widgets/app_text.dart';
import '../../../../../../core/widgets/flash_message.dart';
import '../../../../../../gen/fonts.gen.dart';

final _formKey = GlobalKey<FormState>();
final _nameController = TextEditingController();
final _phoneController = TextEditingController();
final _emailController = TextEditingController();
final _passController = TextEditingController();
final _confirmPassController = TextEditingController();

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(top: 72.h),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomAuthHeader(text: LocaleKeys.newUser.tr()),
              CustomUserRegisterFields(
                formKey: _formKey,
                nameController: _nameController,
                phoneController: _phoneController,
                emailController: _emailController,
                passController: _passController,
                confirmPassController: _confirmPassController,
              ),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is RegisterSuccess) {
                    AppRouter.navigateAndPop(context, const OTPscreen());
                    _nameController.clear();
                    _phoneController.clear();
                    _passController.clear();
                    _confirmPassController.clear();
                    showFlashMessage(
                      context: context,
                      type: FlashMessageType.success,
                      message: state.message,
                    );
                  } else if (state is RegisterFailure) {
                    showFlashMessage(
                      context: context,
                      type: FlashMessageType.error,
                      message: state.error,
                    );
                  }
                },
                builder: (context, state) {
                  return AppButton(
                    top: 24.h,
                    bottom: 29.h,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await AuthCubit.get(context).register(
                          firstName: _nameController.text,
                          phone: _phoneController.text,
                          email: _emailController.text,
                          password: _passController.text,
                        );
                      }
                    },
                    child:
                        state is RegisterLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : AppText(
                              text: LocaleKeys.signingUp.tr(),
                              color: Colors.white,
                              family: FontFamily.dINArabicBold,
                            ),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    text: LocaleKeys.alreadyHaveAccount.tr(),
                    size: 14.sp,
                  ),
                  TextButton(
                    onPressed: () => AppRouter.pop(context),
                    style: ButtonStyle(
                      overlayColor: WidgetStatePropertyAll(
                        AppColors.darkRed.withAlpha((0.1 * 255).toInt()),
                      ),
                    ),
                    child: AppText(
                      text: LocaleKeys.login.tr(),
                      size: 14.sp,
                      color: AppColors.darkRed,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

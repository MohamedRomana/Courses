import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/constants/colors.dart';
import 'package:unicourse/screens/auth/views/otp/otp.dart';
import 'package:unicourse/screens/auth/views/register/widgets/user_fields.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../data/auth_cubit.dart';
import '../widgets/auth_header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/widgets/app_router.dart';
import '../../../../../../core/widgets/app_text.dart';
import '../../../../../../core/widgets/flash_message.dart';
import '../../../../../../core/widgets/primary_button.dart';
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
    final isAr = context.locale.languageCode == 'ar';
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomAuthHeader(
                text: LocaleKeys.newUser.tr(),
                subtitle: isAr
                    ? 'أنشئ حسابك وابدأ التعلّم اليوم'
                    : 'Create your account and start learning',
              ),
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
                  return PrimaryButton(
                    text: LocaleKeys.signingUp.tr(),
                    icon: Icons.person_add_alt_1_rounded,
                    loading: state is RegisterLoading,
                    margin: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
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
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    text: LocaleKeys.alreadyHaveAccount.tr(),
                    size: 14.sp,
                    color: context.palette.textSecondary,
                  ),
                  TextButton(
                    onPressed: () => AppRouter.pop(context),
                    child: AppText(
                      text: LocaleKeys.login.tr(),
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
      ),
    );
  }
}

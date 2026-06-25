import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:unicourse/core/constants/colors.dart';
import 'package:unicourse/core/widgets/primary_button.dart';
import '../../../../../core/widgets/app_input.dart';
import '../../../../../core/widgets/flash_message.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../data/auth_cubit.dart';
import '../widgets/auth_header.dart';

class ResetPass extends StatefulWidget {
  const ResetPass({super.key});

  @override
  State<ResetPass> createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  final formKey = GlobalKey<FormState>();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();
  String otpCode = "";

  Widget _eye(bool secure, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.all(8.h),
        child: Icon(
          secure ? Icons.visibility_off : Icons.visibility,
          color: context.palette.brand,
          size: 21.sp,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              CustomAuthHeader(
                text: LocaleKeys.changePassword.tr(),
                subtitle: LocaleKeys.enterActivationCode.tr(),
                bottom: 16.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: PinCodeTextField(
                  appContext: context,
                  length: 4,
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.scale,
                  cursorColor: palette.brand,
                  textStyle: TextStyle(
                    fontSize: 24.sp,
                    color: palette.textPrimary,
                    fontFamily: FontFamily.dINArabicBold,
                  ),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(16.r),
                    fieldHeight: 58.h,
                    fieldWidth: 58.h,
                    borderWidth: 1.4,
                    activeColor: palette.brand,
                    inactiveColor: palette.border,
                    inactiveFillColor: palette.surfaceMuted,
                    activeFillColor: palette.brandSoft,
                    selectedColor: palette.brand,
                    selectedFillColor: palette.surfaceMuted,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  onCompleted: (code) => otpCode = code,
                  onChanged: (value) => otpCode = value,
                ),
              ),
              SizedBox(height: 20.h),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  final cubit = AuthCubit.get(context);
                  return AppInput(
                    filled: true,
                    bottom: 16.h,
                    hint: LocaleKeys.password.tr(),
                    controller: passController,
                    validate: (value) {
                      if (value!.isEmpty) return LocaleKeys.passwordValidate.tr();
                      return null;
                    },
                    prefixIcon:
                        Icon(Icons.lock, color: palette.brand, size: 24.sp),
                    secureText: cubit.isSecureNewPass1,
                    suffixIcon: _eye(
                      cubit.isSecureNewPass1,
                      () => cubit.isSecureNewPassIcon1(!cubit.isSecureNewPass1),
                    ),
                  );
                },
              ),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  final cubit = AuthCubit.get(context);
                  return AppInput(
                    filled: true,
                    hint: LocaleKeys.confirmPassword.tr(),
                    controller: confirmPassController,
                    validate: (value) {
                      if (passController.text != confirmPassController.text) {
                        return LocaleKeys.passwordDoesNotMatch.tr();
                      }
                      return null;
                    },
                    prefixIcon:
                        Icon(Icons.lock, color: palette.brand, size: 24.sp),
                    secureText: cubit.isSecureNewPass2,
                    suffixIcon: _eye(
                      cubit.isSecureNewPass2,
                      () => cubit.isSecureNewPassIcon2(!cubit.isSecureNewPass2),
                    ),
                  );
                },
              ),
              BlocConsumer<AuthCubit, AuthState>(
                listenWhen: (p, c) =>
                    c is ResetPassSuccess || c is ResetPassFailure,
                listener: (context, state) {
                  if (state is ResetPassFailure) {
                    showFlashMessage(
                      context: context,
                      type: FlashMessageType.error,
                      message: state.error,
                    );
                  } else if (state is ResetPassSuccess) {
                    Navigator.pop(context);
                    passController.clear();
                    confirmPassController.clear();
                    otpCode = "";
                    AuthCubit.get(context).resetPassId = "";
                    showFlashMessage(
                      context: context,
                      type: FlashMessageType.success,
                      message: state.message,
                    );
                  }
                },
                builder: (context, state) {
                  return PrimaryButton(
                    text: LocaleKeys.confirm.tr(),
                    icon: Icons.lock_reset_rounded,
                    loading: state is ResetPassLoading,
                    margin: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 28.h),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        AuthCubit.get(context).resetPass(
                          code: otpCode,
                          password: passController.text,
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

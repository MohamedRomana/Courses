import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_input.dart';
import '../../../../../core/widgets/app_text.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(top: 72.h),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                CustomAuthHeader(text: LocaleKeys.changePassword.tr()),
                AppText(
                  text: LocaleKeys.enterActivationCode.tr(),
                  family: FontFamily.dINArabicLight,
                  bottom: 27.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 35.w),
                  child: PinCodeTextField(
                    appContext: context,
                    length: 4,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    animationType: AnimationType.scale,
                    cursorColor: AppColors.primary,
                    textStyle: TextStyle(
                      fontSize: 24.sp,
                      color: Colors.white,
                      fontFamily: FontFamily.dINArabicBold,
                    ),
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(10.r),
                      fieldHeight: 60.h,
                      fieldWidth: 60.h,
                      activeColor: AppColors.primary,
                      inactiveColor: AppColors.primary.withAlpha(
                        (0.3 * 255).toInt(),
                      ),
                      inactiveFillColor: AppColors.scaffoldBackgroundColor,
                      activeFillColor: AppColors.primary,
                      selectedColor: AppColors.primary,
                      selectedFillColor: AppColors.scaffoldBackgroundColor,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    onCompleted: (code) {
                      otpCode = code;
                      debugPrint("Completed");
                    },
                    onChanged: (value) {
                      debugPrint(value);
                    },
                  ),
                ),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return AppInput(
                      filled: true,
                      bottom: 16.h,
                      hint: LocaleKeys.password.tr(),
                      controller: passController,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return LocaleKeys.passwordValidate.tr();
                        } else {
                          return null;
                        }
                      },
                      prefixIcon: Icon(
                        Icons.lock,
                        color: AppColors.primary,
                        size: 25.sp,
                      ),
                      secureText: AuthCubit.get(context).isSecureNewPass1,
                      suffixIcon:
                          AuthCubit.get(context).isSecureNewPass1
                              ? InkWell(
                                onTap: () {
                                  AuthCubit.get(
                                    context,
                                  ).isSecureNewPassIcon1(false);
                                },
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                child: Padding(
                                  padding: EdgeInsets.all(8.h),
                                  child: Icon(
                                    Icons.visibility_off,
                                    color: AppColors.primary,
                                    size: 21.sp,
                                  ),
                                ),
                              )
                              : InkWell(
                                onTap: () {
                                  AuthCubit.get(
                                    context,
                                  ).isSecureNewPassIcon1(true);
                                },
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                child: Padding(
                                  padding: EdgeInsets.all(8.h),
                                  child: Icon(
                                    Icons.visibility,
                                    color: AppColors.primary,
                                    size: 21.sp,
                                  ),
                                ),
                              ),
                    );
                  },
                ),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return AppInput(
                      filled: true,
                      hint: LocaleKeys.confirmPassword.tr(),
                      controller: confirmPassController,
                      validate: (value) {
                        if (passController.text != confirmPassController.text) {
                          return LocaleKeys.passwordDoesNotMatch.tr();
                        } else {
                          return null;
                        }
                      },
                      prefixIcon: Icon(
                        Icons.lock,
                        color: AppColors.primary,
                        size: 25.sp,
                      ),
                      secureText: AuthCubit.get(context).isSecureNewPass2,
                      suffixIcon:
                          AuthCubit.get(context).isSecureNewPass2
                              ? InkWell(
                                onTap: () {
                                  AuthCubit.get(
                                    context,
                                  ).isSecureNewPassIcon2(false);
                                },
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                child: Padding(
                                  padding: EdgeInsets.all(8.h),
                                  child: Icon(
                                    Icons.visibility_off,
                                    color: AppColors.primary,
                                    size: 21.sp,
                                  ),
                                ),
                              )
                              : InkWell(
                                onTap: () {
                                  AuthCubit.get(
                                    context,
                                  ).isSecureNewPassIcon2(true);
                                },
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                child: Padding(
                                  padding: EdgeInsets.all(8.h),
                                  child: Icon(
                                    Icons.visibility,
                                    color: AppColors.primary,
                                    size: 21.sp,
                                  ),
                                ),
                              ),
                    );
                  },
                ),
                BlocConsumer<AuthCubit, AuthState>(
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
                    return AppButton(
                      top: 32.h,
                      bottom: 29.h,
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          AuthCubit.get(context).resetPass(
                            code: otpCode,
                            password: passController.text,
                          );
                        }
                      },
                      child:
                          state is ResetPassLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : AppText(
                                text: LocaleKeys.confirm.tr(),
                                color: Colors.white,
                                family: FontFamily.dINArabicBold,
                              ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

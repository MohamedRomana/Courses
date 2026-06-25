import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/widgets/app_input.dart';
import '../../../../../../generated/locale_keys.g.dart';
import '../../../data/auth_cubit.dart';

class CustomUserRegisterFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController passController;
  final TextEditingController confirmPassController;

  const CustomUserRegisterFields({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.passController,
    required this.confirmPassController,
  });

  @override
  State<CustomUserRegisterFields> createState() =>
      _CustomUserRegisterFieldsState();
}

class _CustomUserRegisterFieldsState extends State<CustomUserRegisterFields> {
  @override
  void initState() {
    widget.nameController.clear();
    widget.phoneController.clear();
    widget.emailController.clear();
    widget.passController.clear();
    widget.confirmPassController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppInput(
          bottom: 16.h,
          filled: true,
          hint: LocaleKeys.username.tr(),
          controller: widget.nameController,
          inputType: TextInputType.name,
          validate: (value) {
            if (value!.isEmpty) {
              return LocaleKeys.usernameValidate.tr();
            } else {
              return null;
            }
          },
          prefixIcon: Icon(Icons.person, color: AppColors.primary, size: 25.sp),
        ),
        AppInput(
          bottom: 16.h,
          filled: true,
          hint: LocaleKeys.phone.tr(),
          controller: widget.phoneController,
          inputType: TextInputType.phone,
          validate: (value) {
            if (value!.isEmpty) {
              return LocaleKeys.phoneValidate.tr();
            } else {
              return null;
            }
          },
          prefixIcon: Icon(Icons.call, color: AppColors.primary, size: 25.sp),
        ),
        AppInput(
          bottom: 16.h,
          filled: true,
          hint: LocaleKeys.email.tr(),
          controller: widget.emailController,
          inputType: TextInputType.emailAddress,
          validate: (value) {
            if (value!.isEmpty) {
              return LocaleKeys.yourEmailValidate.tr();
            } else {
              return null;
            }
          },
          prefixIcon: Icon(Icons.email, color: AppColors.primary, size: 25.sp),
        ),
        BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return AppInput(
              filled: true,
              bottom: 16.h,
              hint: LocaleKeys.password.tr(),
              controller: widget.passController,
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
              secureText: AuthCubit.get(context).isSecureRegister1,
              suffixIcon:
                  AuthCubit.get(context).isSecureRegister1
                      ? InkWell(
                        onTap: () {
                          AuthCubit.get(context).isSecureRegisterIcon1(false);
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
                          AuthCubit.get(context).isSecureRegisterIcon1(true);
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
              controller: widget.confirmPassController,
              validate: (value) {
                if (widget.passController.text !=
                    widget.confirmPassController.text) {
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
              secureText: AuthCubit.get(context).isSecureRegister2,
              suffixIcon:
                  AuthCubit.get(context).isSecureRegister2
                      ? InkWell(
                        onTap: () {
                          AuthCubit.get(context).isSecureRegisterIcon2(false);
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
                          AuthCubit.get(context).isSecureRegisterIcon2(true);
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
      ],
    );
  }
}

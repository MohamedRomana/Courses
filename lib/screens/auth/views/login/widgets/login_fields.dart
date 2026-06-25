import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/widgets/app_input.dart';
import '../../../../../../generated/locale_keys.g.dart';
import '../../../data/auth_cubit.dart';

class CustomLoginFields extends StatefulWidget {
  final TextEditingController phoneController;
  final TextEditingController passController;
  final GlobalKey<FormState> formKey;

  const CustomLoginFields({
    super.key,
    required this.phoneController,
    required this.passController,
    required this.formKey,
  });

  @override
  State<CustomLoginFields> createState() => _CustomLoginFieldsState();
}

class _CustomLoginFieldsState extends State<CustomLoginFields> {
  @override
  void initState() {
    widget.phoneController.clear();
    widget.passController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
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
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return AppInput(
                filled: true,
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
                secureText: AuthCubit.get(context).isSecureLogIn,
                suffixIcon:
                    AuthCubit.get(context).isSecureLogIn
                        ? InkWell(
                          onTap: () {
                            AuthCubit.get(context).isSecureLogInIcon(false);
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
                            AuthCubit.get(context).isSecureLogInIcon(true);
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
      ),
    );
  }
}

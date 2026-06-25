// ignore_for_file: deprecated_member_use
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/service/cubit/app_cubit.dart';
import '../../../../core/widgets/app_input.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../generated/locale_keys.g.dart';

class EditProfileFields extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController passController;

  const EditProfileFields({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.passController,
  });

  @override
  State<EditProfileFields> createState() => _EditProfileFieldsState();
}

class _EditProfileFieldsState extends State<EditProfileFields> {
  @override
  void initState() {
    super.initState();
    AppCubit.get(context).removeProfileImage();
    widget.nameController.clear();
    widget.phoneController.clear();
    widget.emailController.clear();
    widget.passController.clear();
  }

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              start: 18.w,
              text: LocaleKeys.edit_personal_information.tr(),
              size: 18.sp,
              fontWeight: FontWeight.w500,
            ),
            Container(
              width: 343.w,
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 10.sp),
              margin: EdgeInsets.all(16.sp),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 1.r,
                    blurRadius: 5.r,
                    offset: Offset(0, 5.r),
                  ),
                ],
              ),
              child: Column(
                children: [
                  AppInput(
                    filled: true,
                    enabledBorderColor: Colors.grey,
                    hint: cubit.userModel["first_name"],
                    controller: widget.nameController,
                    prefixIcon: const Icon(
                      Icons.person_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  AppInput(
                    filled: true,
                    enabledBorderColor: Colors.grey,
                    hint: cubit.userModel["phone"],
                    controller: widget.phoneController,
                    inputType: TextInputType.phone,
                    prefixIcon: Icon(
                      Icons.phone_outlined,
                      color: AppColors.primary,
                      size: 25.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  AppInput(
                    filled: true,
                    enabledBorderColor: Colors.grey,
                    hint: cubit.userModel["email"],
                    controller: widget.emailController,
                    inputType: TextInputType.emailAddress,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: AppColors.primary,
                      size: 25.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  BlocBuilder<AppCubit, AppState>(
                    builder: (context, state) {
                      return AppInput(
                        filled: true,
                        hint: LocaleKeys.password.tr(),
                        enabledBorderColor: Colors.grey,
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
                        secureText: AppCubit.get(context).isSecureLogIn,
                        suffixIcon:
                            AppCubit.get(context).isSecureLogIn
                                ? InkWell(
                                  onTap: () {
                                    AppCubit.get(
                                      context,
                                    ).isSecureLogInIcon(false);
                                  },
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.h),
                                    child: Icon(
                                      Icons.visibility_off,
                                      color: Colors.grey,
                                      size: 21.sp,
                                    ),
                                  ),
                                )
                                : InkWell(
                                  onTap: () {
                                    AppCubit.get(
                                      context,
                                    ).isSecureLogInIcon(true);
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
            ),
          ],
        );
      },
    );
  }
}

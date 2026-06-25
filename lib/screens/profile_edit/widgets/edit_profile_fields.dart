import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/service/cubit/app_cubit.dart';
import '../../../../core/widgets/app_input.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../gen/fonts.gen.dart';

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
    final user = AppCubit.get(context).userModel;
    widget.nameController.text = (user["first_name"] ?? '').toString();
    widget.phoneController.text = (user["phone"] ?? '').toString();
    widget.emailController.text = (user["email"] ?? '').toString();
    widget.passController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final cubit = AppCubit.get(context);
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(start: 20.w, bottom: 12.h),
              child: AppText(
                text: LocaleKeys.edit_personal_information.tr(),
                size: 16.sp,
                family: FontFamily.dINArabicBold,
                color: palette.textPrimary,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 4.w),
              decoration: BoxDecoration(
                color: palette.surface,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: palette.border),
              ),
              child: Column(
                children: [
                  AppInput(
                    filled: true,
                    hint: LocaleKeys.username.tr(),
                    controller: widget.nameController,
                    prefixIcon: Icon(Icons.person_outline,
                        color: palette.brand, size: 22.sp),
                  ),
                  SizedBox(height: 14.h),
                  AppInput(
                    filled: true,
                    hint: LocaleKeys.phone.tr(),
                    controller: widget.phoneController,
                    inputType: TextInputType.phone,
                    prefixIcon: Icon(Icons.phone_outlined,
                        color: palette.brand, size: 22.sp),
                  ),
                  SizedBox(height: 14.h),
                  AppInput(
                    filled: true,
                    hint: LocaleKeys.email.tr(),
                    controller: widget.emailController,
                    inputType: TextInputType.emailAddress,
                    prefixIcon: Icon(Icons.email_outlined,
                        color: palette.brand, size: 22.sp),
                  ),
                  SizedBox(height: 14.h),
                  AppInput(
                    filled: true,
                    hint: LocaleKeys.password.tr(),
                    controller: widget.passController,
                    secureText: cubit.isSecureLogIn,
                    prefixIcon: Icon(Icons.lock_outline,
                        color: palette.brand, size: 22.sp),
                    suffixIcon: InkWell(
                      onTap: () =>
                          cubit.isSecureLogInIcon(!cubit.isSecureLogIn),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.all(8.h),
                        child: Icon(
                          cubit.isSecureLogIn
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: palette.textMuted,
                          size: 21.sp,
                        ),
                      ),
                    ),
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

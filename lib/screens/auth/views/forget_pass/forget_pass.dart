import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/widgets/app_text.dart';
import 'package:unicourse/generated/locale_keys.g.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_input.dart';
import '../../../../../core/widgets/flash_message.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../data/auth_cubit.dart';
import '../reset_pass/reset_pass.dart';
import '../widgets/auth_header.dart';

class ForgetPass extends StatefulWidget {
  const ForgetPass({super.key});

  @override
  State<ForgetPass> createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  String forgetPassPhoneCode = "";

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
                CustomAuthHeader(
                  text: LocaleKeys.verificationCode.tr(),
                  bottom: 18.h,
                ),
                AppText(
                  text: LocaleKeys.enterMobileNumberToSendActivationCode.tr(),
                  family: FontFamily.dINArabicLight,
                ),
                AppInput(
                  top: 27.h,
                  bottom: 24.h,
                  filled: true,
                  hint: LocaleKeys.phone.tr(),
                  controller: phoneController,
                  inputType: TextInputType.phone,
                  validate: (value) {
                    if (value!.isEmpty) {
                      return LocaleKeys.phoneValidate.tr();
                    } else {
                      return null;
                    }
                  },
                  prefixIcon: Icon(
                    Icons.call,
                    color: AppColors.primary,
                    size: 25.sp,
                  ),
                ),
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is ForgetPassFailure) {
                      showFlashMessage(
                        context: context,
                        type: FlashMessageType.error,
                        message: state.error,
                      );
                    } else if (state is ForgetPassSuccess) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResetPass(),
                        ),
                      );
                      phoneController.clear();
                      showFlashMessage(
                        context: context,
                        type: FlashMessageType.success,
                        message: state.message,
                      );
                    }
                  },
                  builder: (context, state) {
                    return AppButton(
                      bottom: 29.h,
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          AuthCubit.get(context).forgetPass(
                            phoneCode: forgetPassPhoneCode,
                            phone: phoneController.text,
                          );
                        }
                      },
                      child:
                          state is ForgetPassLoading
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

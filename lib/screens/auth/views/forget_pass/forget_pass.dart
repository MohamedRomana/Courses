import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/constants/colors.dart';
import 'package:unicourse/core/widgets/primary_button.dart';
import 'package:unicourse/generated/locale_keys.g.dart';
import '../../../../../core/widgets/app_input.dart';
import '../../../../../core/widgets/flash_message.dart';
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
        child: Form(
          key: formKey,
          child: Column(
            children: [
              CustomAuthHeader(
                text: LocaleKeys.verificationCode.tr(),
                subtitle: LocaleKeys.enterMobileNumberToSendActivationCode.tr(),
              ),
              AppInput(
                bottom: 24.h,
                filled: true,
                hint: LocaleKeys.phone.tr(),
                controller: phoneController,
                inputType: TextInputType.phone,
                validate: (value) {
                  if (value!.isEmpty) {
                    return LocaleKeys.phoneValidate.tr();
                  }
                  return null;
                },
                prefixIcon: Icon(Icons.call,
                    color: context.palette.brand, size: 24.sp),
              ),
              BlocConsumer<AuthCubit, AuthState>(
                listenWhen: (p, c) =>
                    c is ForgetPassSuccess || c is ForgetPassFailure,
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
                      MaterialPageRoute(builder: (context) => const ResetPass()),
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
                  return PrimaryButton(
                    text: LocaleKeys.confirm.tr(),
                    icon: Icons.send_rounded,
                    loading: state is ForgetPassLoading,
                    margin: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 28.h),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        AuthCubit.get(context).forgetPass(
                          phoneCode: forgetPassPhoneCode,
                          phone: phoneController.text,
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

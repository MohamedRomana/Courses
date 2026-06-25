import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/constants/colors.dart';
import 'package:unicourse/core/widgets/primary_button.dart';
import 'package:unicourse/gen/fonts.gen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/flash_message.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../data/auth_cubit.dart';
import '../widgets/auth_header.dart';

class OTPscreen extends StatelessWidget {
  const OTPscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isAr = context.locale.languageCode == 'ar';
    String otpCode = "";
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            CustomAuthHeader(
              text: LocaleKeys.verificationCode.tr(),
              subtitle: LocaleKeys.enterActivationCode.tr(),
              bottom: 14.h,
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
                  fieldHeight: 60.h,
                  fieldWidth: 60.h,
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
            SizedBox(height: 8.h),
            BlocConsumer<AuthCubit, AuthState>(
              listenWhen: (p, c) =>
                  c is ResendCodeSuccess || c is ResendCodeFailure,
              listener: (context, state) {
                if (state is ResendCodeSuccess) {
                  showFlashMessage(
                    context: context,
                    type: FlashMessageType.success,
                    message: state.message,
                  );
                }
              },
              builder: (context, state) {
                return TextButton(
                  onPressed: () => AuthCubit.get(context).resendCode(),
                  child: AppText(
                    text: isAr ? 'إعادة إرسال الرمز' : 'Resend code',
                    size: 13.sp,
                    color: palette.brand,
                    family: FontFamily.dINArabicBold,
                  ),
                );
              },
            ),
            BlocConsumer<AuthCubit, AuthState>(
              listenWhen: (p, c) => c is OTPSuccess || c is OTPFailure,
              listener: (context, state) {
                if (state is OTPFailure) {
                  showFlashMessage(
                    context: context,
                    type: FlashMessageType.error,
                    message: state.error,
                  );
                } else if (state is OTPSuccess) {
                  Navigator.pop(context);
                  showFlashMessage(
                    context: context,
                    type: FlashMessageType.success,
                    message: LocaleKeys.activatedSuccessfully.tr(),
                  );
                }
              },
              builder: (context, state) {
                return PrimaryButton(
                  text: LocaleKeys.confirm.tr(),
                  icon: Icons.verified_rounded,
                  loading: state is OTPLoading,
                  margin: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 28.h),
                  onPressed: () async {
                    await AuthCubit.get(context).otp(code: otpCode);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/constants/colors.dart';
import 'package:unicourse/core/widgets/primary_button.dart';
import '../../../../core/service/cubit/app_cubit.dart';
import '../../../../core/widgets/app_input.dart';
import '../../../../core/widgets/app_router.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/flash_message.dart';
import '../../../../gen/fonts.gen.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../home_layout.dart';

final _formKey = GlobalKey<FormState>();
final _nameController = TextEditingController();
final _phoneController = TextEditingController();
final _messageController = TextEditingController();

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isAr = context.locale.languageCode == 'ar';
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: CustomAppBar(title: LocaleKeys.contactUs.tr(), isNoti: true),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 30.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 76.w,
                height: 76.w,
                decoration: BoxDecoration(
                  color: palette.brandSoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.headset_mic_rounded,
                    color: palette.brand, size: 36.sp),
              ),
              SizedBox(height: 16.h),
              Text(
                isAr ? 'تواصل معنا' : 'Get in touch',
                style: TextStyle(
                  fontFamily: FontFamily.dINArabicBold,
                  fontSize: 20.sp,
                  color: palette.textPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                isAr
                    ? 'نسعد بخدمتك، اترك رسالتك وسنرد عليك'
                    : "We'd love to hear from you",
                style: TextStyle(fontSize: 13.sp, color: palette.textSecondary),
              ),
              SizedBox(height: 22.h),
              _label(context, LocaleKeys.name.tr()),
              AppInput(
                start: 0,
                end: 0,
                bottom: 16.h,
                filled: true,
                hint: LocaleKeys.fullName.tr(),
                controller: _nameController,
                prefixIcon: Icon(Icons.person_outline,
                    color: palette.brand, size: 22.sp),
                validate: (v) =>
                    v!.isEmpty ? LocaleKeys.nameValidate.tr() : null,
              ),
              _label(context, LocaleKeys.phone.tr()),
              AppInput(
                start: 0,
                end: 0,
                bottom: 16.h,
                filled: true,
                hint: LocaleKeys.phone.tr(),
                inputType: TextInputType.phone,
                controller: _phoneController,
                prefixIcon: Icon(Icons.phone_outlined,
                    color: palette.brand, size: 22.sp),
                validate: (v) =>
                    v!.isEmpty ? LocaleKeys.phoneValidate.tr() : null,
              ),
              _label(context, LocaleKeys.yourMessage.tr()),
              AppInput(
                start: 0,
                end: 0,
                filled: true,
                maxLines: 5,
                hint: LocaleKeys.yourMessage.tr(),
                controller: _messageController,
                validate: (v) =>
                    v!.isEmpty ? LocaleKeys.yourMessage.tr() : null,
              ),
              SizedBox(height: 28.h),
              BlocConsumer<AppCubit, AppState>(
                listenWhen: (p, c) =>
                    c is ContactUsSuccess || c is ContactUsFailure,
                listener: (context, state) {
                  if (state is ContactUsFailure) {
                    showFlashMessage(
                      context: context,
                      type: FlashMessageType.error,
                      message: state.error,
                    );
                  } else if (state is ContactUsSuccess) {
                    AppCubit.get(context).changebottomNavIndex(0);
                    AppRouter.navigateAndFinish(context, const HomeLayout());
                    _nameController.clear();
                    _phoneController.clear();
                    _messageController.clear();
                    showFlashMessage(
                      context: context,
                      type: FlashMessageType.success,
                      message: state.message,
                    );
                  }
                },
                builder: (context, state) {
                  return PrimaryButton(
                    text: LocaleKeys.send.tr(),
                    icon: Icons.send_rounded,
                    width: double.infinity,
                    loading: state is ContactUsLoading,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        AppCubit.get(context).contactUs(
                          name: _nameController.text,
                          email: _phoneController.text,
                          message: _messageController.text,
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

  Widget _label(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: AppText(
        text: text,
        size: 14.sp,
        family: FontFamily.dINArabicBold,
        color: context.palette.textPrimary,
      ),
    );
  }
}

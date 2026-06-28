import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/constants/colors.dart';
import 'package:unicourse/core/widgets/custom_appbar.dart';
import 'package:unicourse/core/widgets/primary_button.dart';
import '../../core/service/cubit/app_cubit.dart';
import '../../gen/fonts.gen.dart';
import '../../generated/locale_keys.g.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  void initState() {
    AppCubit.get(context).paymentIndex = -1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isAr = context.locale.languageCode == 'ar';
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final cubit = AppCubit.get(context);
        return Scaffold(
          appBar: CustomAppBar(title: LocaleKeys.payment.tr(), isNoti: true),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 90.w,
                  height: 90.w,
                  decoration: BoxDecoration(
                    color: palette.brandSoft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.account_balance_wallet_rounded,
                      size: 42.sp, color: palette.brand),
                ),
                SizedBox(height: 18.h),
                Text(
                  LocaleKeys.choosePaymentMethod.tr(),
                  style: TextStyle(
                    fontFamily: FontFamily.dINArabicBold,
                    fontSize: 20.sp,
                    color: palette.textPrimary,
                  ),
                ),
                SizedBox(height: 18.h),
                _method(
                  context,
                  icon: Icons.payments_outlined,
                  title: isAr ? 'كاش' : 'Cash',
                  selected: cubit.paymentIndex == 0,
                  onTap: () => cubit.changePayment(
                      index: cubit.paymentIndex == 0 ? -1 : 0),
                ),
                SizedBox(height: 14.h),
                _method(
                  context,
                  icon: Icons.credit_card_rounded,
                  title: isAr ? 'دفع إلكتروني' : 'Online',
                  selected: cubit.paymentIndex == 1,
                  onTap: () => cubit.changePayment(
                      index: cubit.paymentIndex == 1 ? -1 : 1),
                ),
                SizedBox(height: 30.h),
                PrimaryButton(
                  text: LocaleKeys.confirmOrder.tr(),
                  icon: Icons.lock_rounded,
                  width: double.infinity,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _method(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final palette = context.palette;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: selected ? palette.brandSoft : palette.surface,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: selected ? palette.brand : palette.border,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46.w,
              height: 46.w,
              decoration: BoxDecoration(
                color: (selected ? palette.brand : palette.textMuted)
                    .withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(13.r),
              ),
              child: Icon(icon,
                  color: selected ? palette.brand : palette.textMuted,
                  size: 24.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: FontFamily.dINArabicBold,
                  fontSize: 16.sp,
                  color: palette.textPrimary,
                ),
              ),
            ),
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? palette.brand : palette.border,
                  width: 2,
                ),
                color: selected ? palette.brand : Colors.transparent,
              ),
              child: selected
                  ? Icon(Icons.check_rounded, color: Colors.white, size: 15.sp)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

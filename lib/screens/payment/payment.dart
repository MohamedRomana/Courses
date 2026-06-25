import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/constants/colors.dart';
import 'package:unicourse/core/widgets/app_text.dart';
import 'package:unicourse/core/widgets/custom_appbar.dart';
import 'package:unicourse/core/widgets/custom_bottom_nav.dart';

import '../../core/service/cubit/app_cubit.dart';
import '../../core/widgets/app_button.dart';
import '../../gen/assets.gen.dart';
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
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(title: LocaleKeys.payment.tr(), isNoti: true),
          bottomNavigationBar: const CustomBottomNav(),
          body: Center(
            child: Column(
              children: [
                Image.asset(
                  Assets.img.logo.path,
                  height: 300.h,
                  width: 300.w,
                  fit: BoxFit.fill,
                ),
                SizedBox(height: 20.h),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    if (AppCubit.get(context).paymentIndex == 0) {
                      AppCubit.get(context).changePayment(index: -1);
                    } else {
                      AppCubit.get(context).changePayment(index: 0);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.r),
                    width: 343.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(150),
                          spreadRadius: 1.r,
                          blurRadius: 5.r,
                          offset: Offset(0, 5.r),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 25.w,
                          width: 25.w,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  AppCubit.get(context).paymentIndex == 0
                                      ? AppColors.primary
                                      : Colors.grey,
                              width: 2.w,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            margin: EdgeInsets.all(2.r),
                            height: 25.w,
                            width: 25.w,
                            decoration: BoxDecoration(
                              color:
                                  AppCubit.get(context).paymentIndex == 0
                                      ? AppColors.primary
                                      : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Row(
                          children: [
                            Icon(
                              Icons.payment_outlined,
                              size: 30.sp,
                              color:
                                  AppCubit.get(context).paymentIndex == 0
                                      ? AppColors.primary
                                      : Colors.grey,
                            ),
                            AppText(
                              start: 5.w,
                              text: 'كاش',
                              size: 20.sp,
                              color:
                                  AppCubit.get(context).paymentIndex == 0
                                      ? AppColors.primary
                                      : Colors.grey,
                              family: FontFamily.dINArabicBold,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    if (AppCubit.get(context).paymentIndex == 1) {
                      AppCubit.get(context).changePayment(index: -1);
                    } else {
                      AppCubit.get(context).changePayment(index: 1);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.r),
                    margin: EdgeInsets.only(top: 25.h),
                    width: 343.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(150),
                          spreadRadius: 1.r,
                          blurRadius: 5.r,
                          offset: Offset(0, 5.r),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 25.w,
                          width: 25.w,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  AppCubit.get(context).paymentIndex == 1
                                      ? AppColors.primary
                                      : Colors.grey,
                              width: 2.w,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            margin: EdgeInsets.all(2.r),
                            height: 25.w,
                            width: 25.w,
                            decoration: BoxDecoration(
                              color:
                                  AppCubit.get(context).paymentIndex == 1
                                      ? AppColors.primary
                                      : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Row(
                          children: [
                            Icon(
                              Icons.payments_outlined,
                              size: 30.sp,
                              color:
                                  AppCubit.get(context).paymentIndex == 1
                                      ? AppColors.primary
                                      : Colors.grey,
                            ),
                            AppText(
                              start: 5.w,
                              text: 'Online',
                              size: 20.sp,
                              color:
                                  AppCubit.get(context).paymentIndex == 1
                                      ? AppColors.primary
                                      : Colors.grey,
                              family: FontFamily.dINArabicBold,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                AppButton(
                  top: 30.h,
                  onPressed: () {},
                  child: AppText(text: 'دفع', size: 18.sp, color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

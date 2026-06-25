// ignore_for_file: use_build_context_synchronously
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:unicourse/core/service/cubit/app_cubit.dart';
import 'package:unicourse/core/stripe_payment/stripe_keys.dart';
import 'package:unicourse/generated/locale_keys.g.dart';
import '../models/courses.dart';
import '../widgets/flash_message.dart';

abstract class PaymentManager {
  static Future<void> makePayment({
    required int amount,
    required AppCubit cubit,
    required Course course,
    required BuildContext context,
  }) async {
    // Try to run the Stripe payment flow, but don't block enrollment on it:
    // even if the user dismisses the sheet without entering any payment
    // details, we still enroll them and take them to "My Courses".
    try {
      String clientSecret = await _getClientSecret(
        (amount * 100).toString(),
        "EGP",
      );
      await _initializePaymentSheet(clientSecret);
      await Stripe.instance.presentPaymentSheet();
    } catch (error) {
      debugPrint(error.toString());
    }
    _enrollAndOpenMyCourses(cubit: cubit, course: course, context: context);
  }

  /// Adds the course to the user's courses (if not already there) and
  /// navigates to the "My Courses" tab on the home layout.
  static void _enrollAndOpenMyCourses({
    required AppCubit cubit,
    required Course course,
    required BuildContext context,
  }) {
    if (!cubit.selectedCourses.any((c) => c.title == course.title)) {
      cubit.addOrRemoveSelectedCourse(course);
    }
    cubit.changebottomNavIndex(2); // My Courses tab
    showFlashMessage(
      context: context,
      type: FlashMessageType.success,
      message: LocaleKeys.courseBookedSuccessfully.tr(),
    );
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  static Future<void> _initializePaymentSheet(String clientSecret) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: "Basel",
      ),
    );
  }

  static Future<String> _getClientSecret(String amount, String currency) async {
    Dio dio = Dio();
    var response = await dio.post(
      'https://api.stripe.com/v1/payment_intents',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${ApiKeys.secretKey}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
      data: {'amount': amount, 'currency': currency},
    );
    return response.data["client_secret"];
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_bottom_nav.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../generated/locale_keys.g.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: LocaleKeys.profile.tr()),
      bottomNavigationBar: const CustomBottomNav(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              Image.asset(
                Assets.img.logo.path,
                height: 300.h,
                width: 300.w,
                fit: BoxFit.fill,
              ),
              SizedBox(height: 20.h),
              AppText(
                start: 16.w,
                end: 16.w,
                textAlign: TextAlign.center,
                text:
                    'باستخدام هذا التطبيق، فإنك توافق على الالتزام بجميع الشروط والأحكام المذكورة.يوفر التطبيق محتوى تعليمي متنوع، ويحق لإدارته تعديل أو تحديث هذا المحتوى في أي وقت دون إشعار مسبق.جميع الدورات والمحتويات محمية بحقوق الملكية الفكرية، ويُمنع نسخها أو إعادة استخدامها دون إذن رسمي.يُحظر استخدام التطبيق لأي أغراض غير قانونية أو تتعارض مع أهدافه التعليمية.يحتفظ التطبيق بحق حذف أو تعليق الحسابات التي تنتهك سياسة الاستخدام.إدارة التطبيق غير مسؤولة عن أي خسائر قد تنجم عن استخدام المعلومات أو الاعتماد الكامل عليها.يجب إدخال معلومات دقيقة وصحيحة عند التسجيل لضمان تقديم تجربة تعليمية مناسبة.أي محتوى يتم رفعه من قبل المستخدم يخضع للمراجعة، وقد يتم حذفه إذا لم يكن متوافقًا مع سياسات المنصة.يحتفظ التطبيق بحق إرسال إشعارات تعليمية أو تسويقية للمستخدمين عند الحاجة.باستخدامك للتطبيق، فإنك تقر بأنك قرأت وفهمت هذه الشروط والموافقة عليها بالكامل.',
                lines: 100,
                size: 16.sp,
              ),
              SizedBox(height: 120.h),
            ],
          ),
        ),
      ),
    );
  }
}

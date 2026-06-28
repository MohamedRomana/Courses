import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:unicourse/core/widgets/info_page.dart';
import '../../../../generated/locale_keys.g.dart';

const _aboutText =
    'باستخدام هذا التطبيق، فإنك توافق على الالتزام بجميع الشروط والأحكام المذكورة. يوفر التطبيق محتوى تعليمي متنوع، ويحق لإدارته تعديل أو تحديث هذا المحتوى في أي وقت دون إشعار مسبق. جميع الدورات والمحتويات محمية بحقوق الملكية الفكرية، ويُمنع نسخها أو إعادة استخدامها دون إذن رسمي. يُحظر استخدام التطبيق لأي أغراض غير قانونية أو تتعارض مع أهدافه التعليمية. يحتفظ التطبيق بحق حذف أو تعليق الحسابات التي تنتهك سياسة الاستخدام. إدارة التطبيق غير مسؤولة عن أي خسائر قد تنجم عن استخدام المعلومات أو الاعتماد الكامل عليها. يجب إدخال معلومات دقيقة وصحيحة عند التسجيل لضمان تقديم تجربة تعليمية مناسبة. أي محتوى يتم رفعه من قبل المستخدم يخضع للمراجعة، وقد يتم حذفه إذا لم يكن متوافقًا مع سياسات المنصة. يحتفظ التطبيق بحق إرسال إشعارات تعليمية أو تسويقية للمستخدمين عند الحاجة. باستخدامك للتطبيق، فإنك تقر بأنك قرأت وفهمت هذه الشروط والموافقة عليها بالكامل.';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoPage(
      title: LocaleKeys.aboutus.tr(),
      icon: Icons.info_outline_rounded,
      body: _aboutText,
    );
  }
}

// ignore_for_file: use_build_context_synchronously
import 'dart:typed_data';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gal/gal.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unicourse/core/constants/colors.dart';
import 'package:unicourse/core/service/cubit/app_cubit.dart';
import '../../core/models/courses.dart';
import '../../core/widgets/custom_appbar.dart';
import '../../core/widgets/flash_message.dart';
import '../../gen/assets.gen.dart';
import '../../gen/fonts.gen.dart';
import '../../generated/locale_keys.g.dart';
import 'package:screenshot/screenshot.dart';

class CertificateDetailScreen extends StatefulWidget {
  final Course course;

  const CertificateDetailScreen({super.key, required this.course});

  @override
  State<CertificateDetailScreen> createState() =>
      _CertificateDetailScreenState();
}

class _CertificateDetailScreenState extends State<CertificateDetailScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  Uint8List? _lastCapturedImage;

  Future<void> _saveCertificate() async {
    try {
      final Uint8List? imageBytes = await _screenshotController.capture(
        delay: const Duration(milliseconds: 120),
      );
      if (imageBytes == null) {
        showFlashMessage(
          context: context,
          type: FlashMessageType.error,
          message: LocaleKeys.failedToCaptureCertificate.tr(),
        );
        return;
      }
      _lastCapturedImage = imageBytes;

      // On Android 10+ no permission is needed (MediaStore); on older Android
      // and iOS this shows the system gallery-access dialog.
      if (!await Gal.hasAccess()) {
        final granted = await Gal.requestAccess();
        if (!granted) {
          showFlashMessage(
            context: context,
            type: FlashMessageType.warning,
            message: LocaleKeys.allowStorageFirst.tr(),
          );
          return;
        }
      }

      // Save the PNG to a temp file then hand it to the gallery (most reliable
      // path across devices).
      final tempDir = await getTemporaryDirectory();
      final tempPath =
          '${tempDir.path}/certificate_${widget.course.title.hashCode}.png';
      await File(tempPath).writeAsBytes(imageBytes, flush: true);

      await Gal.putImage(tempPath, album: 'UniCourse Certificates');

      showFlashMessage(
        context: context,
        type: FlashMessageType.success,
        message: LocaleKeys.certificateSavedInGallery.tr(),
      );
    } on GalException catch (e) {
      debugPrint('Gal error saving certificate: ${e.type.message}');
      showFlashMessage(
        context: context,
        type: FlashMessageType.error,
        message: '${LocaleKeys.errorWhileSaving.tr()} (${e.type.name})',
      );
    } catch (e) {
      debugPrint('Error saving certificate: $e');
      showFlashMessage(
        context: context,
        type: FlashMessageType.error,
        message: LocaleKeys.errorWhileSaving.tr(),
      );
    }
  }

  Future<void> _shareCertificate() async {
    try {
      if (_lastCapturedImage == null) {
        showFlashMessage(
          context: context,
          type: FlashMessageType.error,
          message: LocaleKeys.downloadCertificateFirst.tr(),
        );
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final file =
          await File('${tempDir.path}/shared_certificate.png').create();
      await file.writeAsBytes(_lastCapturedImage!);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: "${LocaleKeys.viewMyCertificate.tr()} ${widget.course.title} 🏆",
      );
    } catch (e) {
      debugPrint('Error sharing certificate: $e');
      showFlashMessage(
        context: context,
        type: FlashMessageType.error,
        message: LocaleKeys.errorWhileSharing.tr(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final name =
            (AppCubit.get(context).userModel['first_name'] ?? '').toString();
        return Scaffold(
          appBar: CustomAppBar(title: LocaleKeys.certificate.tr(), isNoti: true),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 30.h),
            child: Column(
              children: [
                Screenshot(
                  controller: _screenshotController,
                  child: _certificate(name),
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(
                      child: _actionButton(
                        icon: Icons.download_rounded,
                        label: LocaleKeys.downloadCertificate.tr(),
                        gradient: [palette.brand, palette.accent],
                        onTap: _saveCertificate,
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: _actionButton(
                        icon: Icons.share_rounded,
                        label: LocaleKeys.share.tr(),
                        gradient: AppColors.goldGradient,
                        textColor: const Color(0xFF3A2A05),
                        onTap: _shareCertificate,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// The certificate document — kept on a light background so it looks right
  /// when downloaded / shared regardless of the app theme.
  Widget _certificate(String name) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: AppColors.goldGradient),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: const Color(0xFFFCFCFD),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: const Color(0xFFE7C977), width: 1.4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(Assets.img.logo.path,
                height: 56.w, fit: BoxFit.contain),
            SizedBox(height: 14.h),
            Container(
              width: 76.w,
              height: 76.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(colors: AppColors.goldGradient),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.5),
                    blurRadius: 16.r,
                  ),
                ],
              ),
              child: Icon(Icons.emoji_events_rounded,
                  size: 42.sp, color: const Color(0xFF3A2A05)),
            ),
            SizedBox(height: 16.h),
            Text(
              LocaleKeys.completionCertificate.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: FontFamily.dINArabicBold,
                fontSize: 22.sp,
                color: const Color(0xFF1A1B2E),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              LocaleKeys.confirmationThat.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF6B6E82)),
            ),
            SizedBox(height: 14.h),
            Text(
              name.isEmpty ? 'UniCourse' : name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: FontFamily.dINArabicBold,
                fontSize: 24.sp,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              LocaleKeys.successfullyCompletedCourse.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF6B6E82)),
            ),
            SizedBox(height: 8.h),
            Text(
              widget.course.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: FontFamily.dINArabicBold,
                fontSize: 18.sp,
                color: const Color(0xFF1A1B2E),
              ),
            ),
            SizedBox(height: 22.h),
            Container(
              height: 1.5,
              margin: EdgeInsets.symmetric(horizontal: 40.w),
              color: const Color(0xFFE7C977),
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.verified_rounded,
                    size: 16.sp, color: AppColors.success),
                SizedBox(width: 6.w),
                Text(
                  LocaleKeys.congratulationsOnAchievement.tr(),
                  style: TextStyle(
                    fontFamily: FontFamily.dINArabicBold,
                    fontSize: 13.sp,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required List<Color> gradient,
    required VoidCallback onTap,
    Color textColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withValues(alpha: 0.35),
              blurRadius: 14.r,
              offset: Offset(0, 6.r),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 19.sp),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontFamily: FontFamily.dINArabicBold,
                fontSize: 14.sp,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

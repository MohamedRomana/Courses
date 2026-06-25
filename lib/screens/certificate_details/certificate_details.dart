// ignore_for_file: use_build_context_synchronously
import 'dart:typed_data';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unicourse/core/constants/colors.dart';
import 'package:unicourse/core/service/cubit/app_cubit.dart';
import '../../core/models/courses.dart';
import '../../core/widgets/custom_appbar.dart';
import '../../core/widgets/custom_bottom_nav.dart';
import '../../core/widgets/flash_message.dart';
import '../../gen/assets.gen.dart';
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
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        showFlashMessage(
          context: context,
          type: FlashMessageType.warning,
          message: LocaleKeys.allowStorageFirst.tr(),
        );
        return;
      }

      final Uint8List? imageBytes = await _screenshotController.capture();
      if (imageBytes == null) {
        showFlashMessage(
          context: context,
          type: FlashMessageType.error,
          message: LocaleKeys.failedToCaptureCertificate.tr(),
        );
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final tempFile =
          await File(
            '${tempDir.path}/certificate_${DateTime.now().millisecondsSinceEpoch}.png',
          ).create();
      await tempFile.writeAsBytes(imageBytes);

      const String saveDirPath = '/storage/emulated/0/DCIM/Certificates';
      final Directory saveDir = Directory(saveDirPath);

      if (!await saveDir.exists()) {
        await saveDir.create(recursive: true);
      }

      final String saveFilePath =
          '$saveDirPath/certificate_${DateTime.now().millisecondsSinceEpoch}.png';
      final File savedFile = await tempFile.copy(saveFilePath);

      _lastCapturedImage = await savedFile.readAsBytes();

      showFlashMessage(
        context: context,
        type: FlashMessageType.success,
        message: LocaleKeys.certificateSavedInGallery.tr(),
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
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(title: LocaleKeys.certificate.tr()),
          bottomNavigationBar: const CustomBottomNav(),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Screenshot(
                  controller: _screenshotController,
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(
                          color: AppColors.secondray,
                          width: 3.w,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 32.h,
                              horizontal: 24.w,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.emoji_events_rounded,
                                  size: 60.sp,
                                  color: Colors.amber,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  LocaleKeys.completionCertificate.tr(),
                                  style: TextStyle(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.secondray,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  LocaleKeys.confirmationThat.tr(),
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  AppCubit.get(context).userModel['first_name'],
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  LocaleKeys.successfullyCompletedCourse.tr(),
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  widget.course.title,
                                  style: TextStyle(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.teal,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 32.h),
                                Divider(
                                  color: AppColors.secondray,
                                  thickness: 1.5,
                                  indent: 50.w,
                                  endIndent: 50.w,
                                ),
                                SizedBox(height: 24.h),
                                Text(
                                  LocaleKeys.congratulationsOnAchievement.tr(),
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PositionedDirectional(
                            top: 0,
                            end: 0,
                            start: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  Assets.img.logo.path,
                                  height: 80.w,
                                  width: 70.w,
                                  fit: BoxFit.cover,
                                ),
                                Image.asset(
                                  Assets.img.logo.path,
                                  height: 80.w,
                                  width: 70.w,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _saveCertificate,
                      icon: const Icon(Icons.download, color: Colors.white),
                      label: Text(
                        LocaleKeys.downloadCertificate.tr(),
                        style: const TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 12.h,
                        ),
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _shareCertificate,
                      icon: const Icon(Icons.share, color: Colors.white),
                      label: Text(
                        LocaleKeys.share.tr(),
                        style: const TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 12.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        );
      },
    );
  }
}

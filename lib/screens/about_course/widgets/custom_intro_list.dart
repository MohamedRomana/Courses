import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/widgets/flash_message.dart';
import 'package:unicourse/generated/locale_keys.g.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../core/cache/cache_helper.dart';
import '../../../core/constants/colors.dart';
import '../../../core/models/courses.dart';
import '../../../core/service/cubit/app_cubit.dart';
import '../../../gen/fonts.gen.dart';
import 'lesson_tile.dart';
import 'section_tile.dart';

class CustomIntroListView extends StatelessWidget {
  final Course course;
  final YoutubePlayerController controller2;

  const CustomIntroListView({
    super.key,
    required this.controller2,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isAr = context.locale.languageCode == 'ar';
    AppCubit cubit = AppCubit.get(context);
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final subscribed =
            cubit.selectedCourses.any((c) => c.title == course.title) &&
                CacheHelper.getUserId() != "";

        return Padding(
          padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Text(
                  isAr ? 'محتوى الدورة الكامل' : 'Full course content',
                  style: TextStyle(
                    fontFamily: FontFamily.dINArabicBold,
                    fontSize: 16.sp,
                    color: palette.textPrimary,
                  ),
                ),
              ),
              ...List.generate(course.payVideos.length, (subindex) {
                final module = course.payVideos[subindex];
                final open = cubit.openList == subindex;
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Column(
                    children: [
                      SectionTile(
                        title: '${subindex + 1}. ${module.title}',
                        subtitle:
                            '${module.payVideos2.length} ${isAr ? "دروس" : "lessons"}',
                        leadingIcon: subscribed
                            ? Icons.folder_open_rounded
                            : Icons.lock_outline_rounded,
                        leadingColor: palette.brand,
                        expanded: open,
                        onTap: () =>
                            cubit.openDesc(index: open ? -1 : subindex),
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        alignment: Alignment.topCenter,
                        child: open
                            ? Column(
                                children: List.generate(
                                  module.payVideos2.length,
                                  (index) {
                                    final video = module.payVideos2[index];
                                    final videoId =
                                        YoutubePlayer.convertUrlToId(video.url);
                                    final isCurrent =
                                        videoId == cubit.currentPlayingVideoUrl;
                                    return Padding(
                                      padding: EdgeInsets.only(top: 10.h),
                                      child: LessonTile(
                                        index: index + 1,
                                        title: video.title,
                                        time: video.time,
                                        isLocked: !subscribed,
                                        isPlaying: isCurrent && subscribed,
                                        onTap: () => _onLessonTap(
                                          context,
                                          cubit,
                                          subscribed,
                                          videoId,
                                          subindex,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                );
              }),
              SizedBox(height: 24.h),
            ],
          ),
        );
      },
    );
  }

  void _onLessonTap(
    BuildContext context,
    AppCubit cubit,
    bool subscribed,
    String? videoId,
    int subindex,
  ) {
    if (subscribed) {
      if (videoId != null) {
        controller2.load(videoId);
        cubit.setCurrentPlayingVideo(videoId);
      }
      if (course.payVideos.length == subindex + 1) {
        cubit.addCompletedCourse(course);
      }
    } else {
      showFlashMessage(
        message: LocaleKeys.pleaseRegisterForCourse.tr(),
        type: FlashMessageType.warning,
        context: context,
      );
    }
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../core/constants/colors.dart';
import '../../../core/models/courses.dart';
import '../../../core/service/cubit/app_cubit.dart';
import '../../../gen/fonts.gen.dart';
import '../../../generated/locale_keys.g.dart';
import 'lesson_tile.dart';
import 'section_tile.dart';

class CustomFreeContentList extends StatefulWidget {
  final Course course;
  final YoutubePlayerController controller;

  const CustomFreeContentList({
    super.key,
    required this.controller,
    required this.course,
  });

  @override
  State<CustomFreeContentList> createState() => _CustomFreeContentListState();
}

class _CustomFreeContentListState extends State<CustomFreeContentList> {
  String? currentVideoId;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onVideoChange);
    currentVideoId = widget.controller.metadata.videoId;
  }

  void _onVideoChange() {
    final id = widget.controller.metadata.videoId;
    if (id != currentVideoId) {
      setState(() {
        currentVideoId = id;
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onVideoChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final expanded = !AppCubit.get(context).hasRead;
        return Padding(
          padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTile(
                title: LocaleKeys.free_course_sample.tr(),
                subtitle:
                    '${widget.course.freeVideos.length} ${isAr ? "دروس مجانية" : "free lessons"}',
                leadingIcon: Icons.lock_open_rounded,
                leadingColor: const Color(0xFF2BB673),
                expanded: expanded,
                onTap: () => AppCubit.get(context).readDesc(),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: expanded
                    ? Column(
                        children: List.generate(
                          widget.course.freeVideos.length,
                          (index) {
                            final video = widget.course.freeVideos[index];
                            final videoId =
                                YoutubePlayer.convertUrlToId(video.url);
                            final isPlaying = videoId == currentVideoId;
                            return Padding(
                              padding: EdgeInsets.only(top: 10.h),
                              child: LessonTile(
                                index: index + 1,
                                title: video.title,
                                time: video.time,
                                isFree: true,
                                isLocked: false,
                                isPlaying: isPlaying,
                                onTap: () {
                                  if (videoId != null) {
                                    widget.controller.load(videoId);
                                    AppCubit.get(context)
                                        .setCurrentPlayingVideo(videoId);
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              SizedBox(height: 16.h),
              GestureDetector(
                onTap: () {
                  final newVideoId = YoutubePlayer.convertUrlToId(
                      widget.course.freeVideos[0].url);
                  if (newVideoId != null) {
                    widget.controller.load(newVideoId);
                    AppCubit.get(context).setCurrentPlayingVideo(newVideoId);
                  }
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: context.palette.brandSoft,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.play_circle_fill_rounded,
                          color: context.palette.brand, size: 22.sp),
                      SizedBox(width: 10.w),
                      Text(
                        LocaleKeys.course_intro.tr(),
                        style: TextStyle(
                          fontFamily: FontFamily.dINArabicBold,
                          fontSize: 14.sp,
                          color: context.palette.brand,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 18.h),
            ],
          ),
        );
      },
    );
  }
}

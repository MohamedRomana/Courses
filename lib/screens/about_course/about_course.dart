import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../core/cache/cache_helper.dart';
import '../../core/constants/colors.dart';
import '../../core/models/courses.dart';
import '../../core/service/cubit/app_cubit.dart';
import '../../core/stripe_payment/payment_manger.dart';
import '../../core/widgets/app_router.dart';
import '../../gen/fonts.gen.dart';
import '../../core/widgets/flash_message.dart';
import '../../generated/locale_keys.g.dart';
import '../auth/views/login/login.dart';
import 'widgets/course_details.dart';
import 'widgets/custom_content.dart';
import 'widgets/custom_course_desc.dart';
import 'widgets/custom_more.dart';

class AboutCourse extends StatefulWidget {
  final Course course;
  const AboutCourse({super.key, required this.course});

  @override
  State<AboutCourse> createState() => _AboutCourseState();
}

class _AboutCourseState extends State<AboutCourse> {
  late final YoutubePlayerController _controller;
  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.course.youTubeLink)!,
      flags: const YoutubePlayerFlags(),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    AppCubit cubit = AppCubit.get(context);
    bool isSubscribed =
        cubit.selectedCourses.any((c) => c.title == widget.course.title) &&
        CacheHelper.getUserId() != "";
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
            return Scaffold(
              bottomNavigationBar:
                  _SubscribeBar(course: widget.course, isSubscribed: isSubscribed),
              body: Column(
                children: [
                  // ── Lazy video stage (thumbnail until played) + back button ──
                  Stack(
                    children: [
                      _VideoStage(
                        controller: _controller,
                        course: widget.course,
                      ),
                      PositionedDirectional(
                        top: MediaQuery.of(context).padding.top + 8.h,
                        start: 12.w,
                        child: _CircleButton(
                          icon: context.locale.languageCode == 'ar'
                              ? Icons.arrow_forward_ios_rounded
                              : Icons.arrow_back_ios_new_rounded,
                          onTap: () => AppRouter.pop(context),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: DefaultTabController(
                      length: isSubscribed ? 3 : 2,
                      child: NestedScrollView(
                        physics: const BouncingScrollPhysics(),
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) => [
                          SliverToBoxAdapter(
                            child: Column(
                              children: [
                                CourseDetails(course: widget.course),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      16.w, 8.h, 16.w, 12.h),
                                  child: Container(
                                    padding: EdgeInsets.all(5.r),
                                    decoration: BoxDecoration(
                                      color: palette.surfaceAlt,
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                    child: TabBar(
                                      labelColor: Colors.white,
                                      dividerColor: Colors.transparent,
                                      unselectedLabelColor:
                                          palette.textSecondary,
                                      labelStyle: TextStyle(
                                        fontFamily: FontFamily.dINArabicBold,
                                        fontSize: 13.sp,
                                      ),
                                      unselectedLabelStyle: TextStyle(
                                        fontFamily: FontFamily.dINArabicMedium,
                                        fontSize: 13.sp,
                                      ),
                                      indicatorSize: TabBarIndicatorSize.tab,
                                      splashBorderRadius:
                                          BorderRadius.circular(12.r),
                                      indicator: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [palette.brand, palette.accent],
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        boxShadow: [
                                          BoxShadow(
                                            color: palette.brand
                                                .withValues(alpha: 0.3),
                                            blurRadius: 8.r,
                                            offset: Offset(0, 3.r),
                                          ),
                                        ],
                                      ),
                                      tabs: [
                                        Tab(
                                            height: 38.h,
                                            text: LocaleKeys.about_course.tr()),
                                        Tab(
                                            height: 38.h,
                                            text: LocaleKeys.content.tr()),
                                        if (isSubscribed)
                                          Tab(
                                              height: 38.h,
                                              text: LocaleKeys.more.tr()),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        body: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            CustomCourseDesc(course: widget.course),
                            CustomContent(
                              course: widget.course,
                              controller: _controller,
                            ),
                            if (isSubscribed) CustomMore(course: widget.course),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
      },
    );
  }
}

/// A lightweight video stage: shows the YouTube thumbnail with a play button
/// and only mounts the (heavy) player webview once the user starts watching or
/// taps a lesson — keeping the course screen fast to open.
class _VideoStage extends StatefulWidget {
  final YoutubePlayerController controller;
  final Course course;
  const _VideoStage({required this.controller, required this.course});

  @override
  State<_VideoStage> createState() => _VideoStageState();
}

class _VideoStageState extends State<_VideoStage> {
  bool _started = false;
  String _thumbId = '';

  @override
  void initState() {
    super.initState();
    _thumbId =
        YoutubePlayer.convertUrlToId(widget.course.youTubeLink) ?? '';
    widget.controller.addListener(_onChange);
  }

  void _onChange() {
    if (!mounted) return;
    final id = widget.controller.metadata.videoId;
    if (id.isNotEmpty && id != _thumbId) {
      setState(() => _thumbId = id);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChange);
    super.dispose();
  }

  void _startWith(String? videoId) {
    setState(() => _started = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (videoId != null && videoId.isNotEmpty) {
        widget.controller.load(videoId);
      } else {
        widget.controller.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return BlocListener<AppCubit, AppState>(
      listenWhen: (p, c) => c is ChangeVideoState,
      listener: (context, state) {
        // A lesson was tapped — reveal the player if it isn't showing yet.
        if (!_started) {
          _startWith(AppCubit.get(context).currentPlayingVideoUrl);
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
        child: SizedBox(
          height: 232.h,
          width: double.infinity,
          child: _started
              ? YoutubePlayer(
                  controller: widget.controller,
                  showVideoProgressIndicator: true,
                  progressColors: ProgressBarColors(
                    playedColor: palette.brand,
                    handleColor: palette.accent,
                  ),
                  bottomActions: const [
                    SizedBox(width: 10),
                    CurrentPosition(),
                    SizedBox(width: 8),
                    ProgressBar(isExpanded: true),
                    SizedBox(width: 8),
                    RemainingDuration(),
                    SizedBox(width: 10),
                  ],
                )
              : _thumbnail(palette),
        ),
      ),
    );
  }

  Widget _thumbnail(AppPalette palette) {
    return GestureDetector(
      onTap: () => _startWith(null),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: 'https://img.youtube.com/vi/$_thumbId/hqdefault.jpg',
            fit: BoxFit.cover,
            fadeInDuration: const Duration(milliseconds: 250),
            placeholder: (_, __) => Container(color: palette.surfaceAlt),
            errorWidget: (_, __, ___) => Image.asset(
              widget.course.image2,
              fit: BoxFit.cover,
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x33000000), Color(0x88000000)],
              ),
            ),
          ),
          Center(
            child: Container(
              width: 66.w,
              height: 66.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [palette.brand, palette.accent]),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(Icons.play_arrow_rounded,
                  color: Colors.white, size: 38.sp),
            ),
          ),
        ],
      ),
    );
  }
}

/// Floating-style bottom action bar: shows the price + a gradient subscribe
/// button, or an "enrolled" state when the user already owns the course.
class _SubscribeBar extends StatelessWidget {
  final Course course;
  final bool isSubscribed;
  const _SubscribeBar({required this.course, required this.isSubscribed});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    if (isSubscribed) {
      return Container(
        color: palette.surface,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
            child: Container(
              height: 54.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: palette.success.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                    color: palette.success.withValues(alpha: 0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified_rounded,
                      color: palette.success, size: 22.sp),
                  SizedBox(width: 8.w),
                  Text(
                    context.locale.languageCode == 'ar'
                        ? 'أنت مشترك في هذه الدورة'
                        : "You're enrolled",
                    style: TextStyle(
                      fontFamily: FontFamily.dINArabicBold,
                      fontSize: 14.sp,
                      color: palette.success,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        boxShadow: [
          BoxShadow(
            color: palette.shadow,
            blurRadius: 20.r,
            offset: Offset(0, -6.r),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    LocaleKeys.price.tr(),
                    style: TextStyle(
                        fontSize: 11.sp, color: palette.textSecondary),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '${course.price}',
                        style: TextStyle(
                          fontFamily: FontFamily.dINArabicBold,
                          fontSize: 22.sp,
                          color: palette.brand,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        LocaleKeys.sar.tr(),
                        style: TextStyle(
                            fontSize: 12.sp, color: palette.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: GestureDetector(
                  onTap: () => _onSubscribe(context),
                  child: Container(
                    height: 54.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient:
                          LinearGradient(colors: [palette.brand, palette.accent]),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: palette.brand.withValues(alpha: 0.4),
                          blurRadius: 16.r,
                          offset: Offset(0, 6.r),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_open_rounded,
                            color: Colors.white, size: 20.sp),
                        SizedBox(width: 8.w),
                        Text(
                          LocaleKeys.subscribe.tr(),
                          style: TextStyle(
                            fontFamily: FontFamily.dINArabicBold,
                            fontSize: 16.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSubscribe(BuildContext context) {
    final cubit = AppCubit.get(context);
    if (CacheHelper.getUserId() == "") {
      showFlashMessage(
        message: LocaleKeys.loginFirst.tr(),
        type: FlashMessageType.warning,
        context: context,
      );
      AppRouter.navigateTo(context, const LogIn());
    } else {
      PaymentManager.makePayment(
        amount: course.price,
        cubit: cubit,
        course: course,
        context: context,
      );
    }
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
        ),
        child: Icon(icon, color: Colors.white, size: 18.sp),
      ),
    );
  }
}

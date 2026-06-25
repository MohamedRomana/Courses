// ignore_for_file: use_build_context_synchronously
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../gen/assets.gen.dart';
import '../../core/constants/colors.dart';
import '../../core/widgets/app_router.dart';
import '../home_layout/home_layout.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  /// Drives the one-shot entrance choreography (logo, text, progress).
  late final AnimationController _entrance;

  /// Continuously animates the ambient background (orbs + gradient drift).
  late final AnimationController _ambient;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _glow;
  late final Animation<double> _textOpacity;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _progressOpacity;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    _setupAnimations();
    _scheduleNavigation();
  }

  void _setupAnimations() {
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _ambient = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _logoScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.6, end: 1.08)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.08, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 30,
      ),
    ]).animate(
      CurvedAnimation(parent: _entrance, curve: const Interval(0.0, 0.55)),
    );

    _logoOpacity = CurvedAnimation(
      parent: _entrance,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    );

    _glow = CurvedAnimation(
      parent: _entrance,
      curve: const Interval(0.25, 0.7, curve: Curves.easeOut),
    );

    _textOpacity = CurvedAnimation(
      parent: _entrance,
      curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entrance,
        curve: const Interval(0.5, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    _progressOpacity = CurvedAnimation(
      parent: _entrance,
      curve: const Interval(0.75, 1.0, curve: Curves.easeOut),
    );

    _entrance.forward();
  }

  void _scheduleNavigation() {
    Future.delayed(const Duration(milliseconds: 2900), () {
      if (!mounted) return;
      AppRouter.navigateAndPop(context, const HomeLayout());
    });
  }

  @override
  void dispose() {
    _entrance.dispose();
    _ambient.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final bool isDark = context.isDark;

    // Premium deep-brand gradient that reads well in both light & dark.
    final List<Color> bgColors = isDark
        ? const [Color(0xFF0B0C18), Color(0xFF1A1838), Color(0xFF241E52)]
        : const [Color(0xFF4338CA), Color(0xFF5A55E0), Color(0xFF3FA0E8)];

    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([_entrance, _ambient]),
        builder: (context, _) {
          final t = _ambient.value;
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-1 + 0.4 * math.sin(t * 2 * math.pi), -1),
                end: Alignment(1, 1 + 0.4 * math.cos(t * 2 * math.pi)),
                colors: bgColors,
              ),
            ),
            child: Stack(
              children: [
                // Floating ambient orbs for depth.
                _orb(
                  top: 80.h + 30.h * math.sin(t * 2 * math.pi),
                  left: -60.w,
                  size: 220.w,
                  color: palette.accent.withValues(alpha: 0.35),
                ),
                _orb(
                  bottom: 120.h + 40.h * math.cos(t * 2 * math.pi),
                  right: -70.w,
                  size: 260.w,
                  color: AppColors.gold.withValues(alpha: 0.22),
                ),
                _orb(
                  top: 260.h - 25.h * math.sin(t * 2 * math.pi),
                  right: 40.w,
                  size: 120.w,
                  color: Colors.white.withValues(alpha: 0.10),
                ),

                // Main content.
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Spacer(flex: 3),
                      _logo(),
                      SizedBox(height: 32.h),
                      _branding(),
                      const Spacer(flex: 3),
                      _progress(),
                      SizedBox(height: 48.h),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _logo() {
    return Opacity(
      opacity: _logoOpacity.value,
      child: Transform.scale(
        scale: _logoScale.value,
        child: Container(
          padding: EdgeInsets.all(26.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.10),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.45 * _glow.value),
                blurRadius: 50 * _glow.value,
                spreadRadius: 6 * _glow.value,
              ),
              BoxShadow(
                color: AppColors.secondary.withValues(alpha: 0.4 * _glow.value),
                blurRadius: 70 * _glow.value,
                spreadRadius: 2 * _glow.value,
              ),
            ],
          ),
          child: Image.asset(
            Assets.img.logo.path,
            height: 120.w,
            width: 120.w,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _branding() {
    return SlideTransition(
      position: _textSlide,
      child: Opacity(
        opacity: _textOpacity.value,
        child: Column(
          children: [
            Text(
              'UniCourse',
              style: TextStyle(
                fontSize: 34.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.5,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 18.w, vertical: 7.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                'تعلّم. أبدع. تميّز',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.white.withValues(alpha: 0.92),
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _progress() {
    return Opacity(
      opacity: _progressOpacity.value,
      child: SizedBox(
        width: 46.w,
        height: 46.w,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 34.w,
              height: 34.w,
              child: CircularProgressIndicator(
                strokeWidth: 2.6,
                valueColor:
                    AlwaysStoppedAnimation(Colors.white.withValues(alpha: 0.9)),
                backgroundColor: Colors.white.withValues(alpha: 0.18),
              ),
            ),
            Container(
              width: 7.w,
              height: 7.w,
              decoration: const BoxDecoration(
                color: AppColors.gold,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _orb({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required Color color,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}

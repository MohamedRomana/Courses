import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../gen/fonts.gen.dart';
import '../constants/colors.dart';

class BottomNavItemData {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const BottomNavItemData({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

/// A modern, animated bottom navigation bar with a sliding pill indicator,
/// expanding active labels and full light/dark theming.
class ModernBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavItemData> items;

  const ModernBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(top: BorderSide(color: palette.border)),
        boxShadow: [
          BoxShadow(
            color: palette.shadow,
            blurRadius: 24.r,
            offset: Offset(0, -6.r),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(items.length, (i) {
              final selected = i == currentIndex;
              return _NavItem(
                data: items[i],
                selected: selected,
                onTap: () => onTap(i),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final BottomNavItemData data;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.data,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: selected ? 16.w : 12.w,
          vertical: 10.h,
        ),
        decoration: BoxDecoration(
          gradient: selected
              ? LinearGradient(colors: [palette.brand, palette.accent])
              : null,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: palette.brand.withValues(alpha: 0.35),
                    blurRadius: 14.r,
                    offset: Offset(0, 5.r),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              selected ? data.activeIcon : data.icon,
              size: 23.sp,
              color: selected ? Colors.white : palette.textMuted,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutCubic,
              child: selected
                  ? Padding(
                      padding: EdgeInsets.only(left: 7.w, right: 1.w),
                      child: Text(
                        data.label,
                        style: TextStyle(
                          fontFamily: FontFamily.dINArabicBold,
                          fontSize: 13.sp,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

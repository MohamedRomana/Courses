// ignore_for_file: use_build_context_synchronously, deprecated_member_use
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../../core/widgets/flash_message.dart';
import '../../../generated/locale_keys.g.dart';
import '../../core/service/cubit/app_cubit.dart';
import '../../core/widgets/modern_bottom_nav.dart';
import '../../core/widgets/will_pop_dialog.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) async {
        bool isConnected = await InternetConnectionChecker().hasConnection;
        if (isConnected == false) {
          showFlashMessage(
            context: context,
            type: FlashMessageType.warning,
            message: LocaleKeys.checkInternet.tr(),
          );
        } else if (state is ServerError) {
          showFlashMessage(
            context: context,
            type: FlashMessageType.error,
            message: LocaleKeys.serverError.tr(),
          );
        } else if (state is Timeoutt) {
          showFlashMessage(
            context: context,
            type: FlashMessageType.warning,
            message: LocaleKeys.checkInternet.tr(),
          );
        }
      },
      builder: (context, state) {
        final cubit = AppCubit.get(context);
        return WillPopScope(
          onWillPop: () async {
            bool? shouldPop = await willPopDialog(context);
            return shouldPop ?? false;
          },
          child: Scaffold(
            extendBody: true,
            bottomNavigationBar: ModernBottomNav(
              currentIndex: cubit.bottomNavIndex,
              onTap: cubit.changebottomNavIndex,
              items: [
                BottomNavItemData(
                  icon: CupertinoIcons.house,
                  activeIcon: CupertinoIcons.house_fill,
                  label: LocaleKeys.home.tr(),
                ),
                BottomNavItemData(
                  icon: CupertinoIcons.search,
                  activeIcon: CupertinoIcons.search,
                  label: LocaleKeys.search.tr(),
                ),
                BottomNavItemData(
                  icon: CupertinoIcons.book,
                  activeIcon: CupertinoIcons.book_fill,
                  label: LocaleKeys.myCourses.tr(),
                ),
                BottomNavItemData(
                  icon: CupertinoIcons.person,
                  activeIcon: CupertinoIcons.person_fill,
                  label: LocaleKeys.profile.tr(),
                ),
              ],
            ),
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.02),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: KeyedSubtree(
                key: ValueKey(cubit.bottomNavIndex),
                child: cubit.bottomNavScreens[cubit.bottomNavIndex],
              ),
            ),
          ),
        );
      },
    );
  }
}

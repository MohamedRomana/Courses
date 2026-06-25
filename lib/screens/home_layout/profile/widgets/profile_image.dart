import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/service/cubit/app_cubit.dart';
import 'package:unicourse/core/widgets/app_cached.dart';
import 'package:unicourse/core/widgets/custom_shimmer.dart';
import '../../../../core/widgets/app_router.dart';
import '../../../profile_edit/profile_edit.dart';

class ProfileImage extends StatefulWidget {
  const ProfileImage({super.key});

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  @override
  void initState() {
    AppCubit.get(context).getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return state is GetUserDataLoading && cubit.userModel.isEmpty
            ? Center(
              child: CustomShimmer(height: 150.w, width: 150.w, radius: 1000.r),
            )
            : InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                AppRouter.navigateTo(context, const ProfileEdit());
              },
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(1000.r),
                  child: AppCachedImage(
                    image: cubit.userModel["avatar"],
                    height: 150.w,
                    width: 150.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
      },
    );
  }
}

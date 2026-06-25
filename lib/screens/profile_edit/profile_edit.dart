// ignore_for_file: deprecated_member_use
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/widgets/app_cached.dart';
import 'package:unicourse/core/widgets/custom_bottom_nav.dart';
import '../../../core/constants/colors.dart';
import '../../../core/service/cubit/app_cubit.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text.dart';
import '../../../generated/locale_keys.g.dart';
import '../../core/widgets/custom_appbar.dart';
import '../../core/widgets/flash_message.dart';
import 'widgets/edit_profile_fields.dart';

final _formKey = GlobalKey<FormState>();
final _nameController = TextEditingController();
final _phoneController = TextEditingController();
final _emailController = TextEditingController();
final _passController = TextEditingController();

class ProfileEdit extends StatelessWidget {
  const ProfileEdit({super.key});

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(
            title: LocaleKeys.editProfile.tr(),
            isNoti: true,
          ),
          bottomNavigationBar: const CustomBottomNav(),
          body: BlocBuilder<AppCubit, AppState>(
            builder: (context, state) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 30.h),
                      cubit.profileImage.isEmpty
                          ? InkWell(
                            onTap: () => cubit.getProfileImage(context),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(1000.r),
                                  child: AppCachedImage(
                                    image: cubit.userModel["avatar"],
                                    height: 120.h,
                                    width: 120.w,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                PositionedDirectional(
                                  end: 0,
                                  child: Icon(
                                    Icons.edit_square,
                                    color: AppColors.primary,
                                    size: 25.sp,
                                  ),
                                ),
                              ],
                            ),
                          )
                          : Stack(
                            children: [
                              Container(
                                height: 120.h,
                                width: 120.w,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: FileImage(cubit.profileImage.first),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              PositionedDirectional(
                                child: InkWell(
                                  onTap:
                                      () =>
                                          AppCubit.get(
                                            context,
                                          ).removeProfileImage(),
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: Icon(
                                    CupertinoIcons.xmark_circle_fill,
                                    color: Colors.red,
                                    size: 25.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      SizedBox(height: 20.h),
                      EditProfileFields(
                        nameController: _nameController,
                        phoneController: _phoneController,
                        emailController: _emailController,
                        passController: _passController,
                      ),
                      BlocConsumer<AppCubit, AppState>(
                        listener: (context, state) {
                          if (state is UpdateProfileSuccess) {
                            Navigator.pop(context);
                            showFlashMessage(
                              context: context,
                              type: FlashMessageType.success,
                              message: state.message,
                            );
                          } else if (state is UpdateProfileFailure) {
                            showFlashMessage(
                              context: context,
                              type: FlashMessageType.error,
                              message: state.error,
                            );
                          }
                        },
                        builder: (context, state) {
                          return AppButton(
                            top: 10.h,
                            onPressed: () {
                              cubit.updateProfile(
                                firstName:
                                    _nameController.text.isEmpty
                                        ? cubit.userModel["first_name"]
                                        : _nameController.text,
                                phone:
                                    _phoneController.text.isEmpty
                                        ? cubit.userModel["phone"]
                                        : _phoneController.text,
                                email:
                                    _emailController.text.isEmpty
                                        ? cubit.userModel["email"]
                                        : _emailController.text,
                                password: _passController.text,
                              );
                            },
                            child:
                                state is UpdateProfileLoading ||
                                        state is UploadImagesLoading
                                    ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                    : AppText(
                                      text: LocaleKeys.save.tr(),
                                      color: Colors.white,
                                    ),
                          );
                        },
                      ),
                      SizedBox(height: 150.h),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

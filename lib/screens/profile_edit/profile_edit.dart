import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicourse/core/constants/colors.dart';
import 'package:unicourse/core/widgets/primary_button.dart';
import '../../../core/service/cubit/app_cubit.dart';
import '../../../generated/locale_keys.g.dart';
import '../../core/widgets/custom_appbar.dart';
import '../../core/widgets/flash_message.dart';
import '../../gen/fonts.gen.dart';
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
    final palette = context.palette;
    AppCubit cubit = AppCubit.get(context);
    return Scaffold(
      appBar: CustomAppBar(title: LocaleKeys.editProfile.tr(), isNoti: true),
      body: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 28.h),
                  GestureDetector(
                    onTap: () => cubit.getProfileImage(context),
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(3.r),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                                colors: [palette.brand, palette.accent]),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(1000.r),
                            child: _avatar(cubit, palette),
                          ),
                        ),
                        PositionedDirectional(
                          end: 4.w,
                          bottom: 4.h,
                          child: Container(
                            padding: EdgeInsets.all(6.r),
                            decoration: BoxDecoration(
                              color: palette.brand,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: palette.background, width: 2),
                            ),
                            child: Icon(
                              cubit.profileImage.isEmpty
                                  ? Icons.edit_rounded
                                  : CupertinoIcons.xmark,
                              color: Colors.white,
                              size: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (cubit.profileImage.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: GestureDetector(
                        onTap: () => cubit.removeProfileImage(),
                        child: Text(
                          context.locale.languageCode == 'ar'
                              ? 'إزالة الصورة'
                              : 'Remove photo',
                          style: TextStyle(
                            fontFamily: FontFamily.dINArabicBold,
                            fontSize: 12.sp,
                            color: palette.error,
                          ),
                        ),
                      ),
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
                      return PrimaryButton(
                        text: LocaleKeys.save.tr(),
                        icon: Icons.check_rounded,
                        loading: state is UpdateProfileLoading ||
                            state is UploadImagesLoading,
                        margin: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 30.h),
                        onPressed: () {
                          cubit.updateProfile(
                            firstName: _nameController.text.isEmpty
                                ? (cubit.userModel["first_name"] ?? '')
                                : _nameController.text,
                            phone: _phoneController.text.isEmpty
                                ? (cubit.userModel["phone"] ?? '')
                                : _phoneController.text,
                            email: _emailController.text.isEmpty
                                ? (cubit.userModel["email"] ?? '')
                                : _emailController.text,
                            password: _passController.text,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _avatar(AppCubit cubit, AppPalette palette) {
    const double size = 120;
    if (cubit.profileImage.isNotEmpty) {
      return Image.file(cubit.profileImage.first,
          height: size.h, width: size.w, fit: BoxFit.cover);
    }
    final avatar = (cubit.userModel["avatar"] ?? '').toString();
    if (avatar.isEmpty) {
      return Container(
        height: size.h,
        width: size.w,
        color: palette.brandSoft,
        child: Icon(Icons.person, color: palette.brand, size: 60.sp),
      );
    }
    if (avatar.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: avatar,
        height: size.h,
        width: size.w,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) =>
            Icon(Icons.person, color: palette.brand, size: 60.sp),
      );
    }
    return Image.file(
      File(avatar),
      height: size.h,
      width: size.w,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) =>
          Icon(Icons.person, color: palette.brand, size: 60.sp),
    );
  }
}

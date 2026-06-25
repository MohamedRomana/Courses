import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../gen/fonts.gen.dart';
import '../constants/colors.dart';

class AppInput extends StatelessWidget {
  final void Function(String?)? onChanged;
  final void Function()? onTap;
  final void Function(String?)? onSubmitted;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validate;
  final bool? read;
  final bool? filled;
  final Widget? prefixIcon;
  final int? maxLines;
  final Widget? suffixIcon;
  final double? start;
  final double? end;
  final double? top;
  final double? bottom;
  final TextInputType? inputType;
  final String? label;
  final String? hint;
  final bool? secureText;
  final bool? isEnabled;
  final bool? autofocus;
  final Color? color;
  final Color? iconColor;
  final Color? hintColor;
  final TextEditingController? controller;
  final Color? borderColorr;
  final double? contentLeft;
  final double? contentRight;
  final double? contentTop;
  final double? contentBottom;
  final Color? outLineInputColorColor;
  final Color? enabledBorderColor;
  final Color? disableBorderColor;
  final Color? errorBorderColor;
  final Color? focusedBorderColor;
  final Color? focusedErrorBorderColor;
  final Color? cursorColor;
  final BoxConstraints? prefixSize;
  final BoxConstraints? suffixSize;
  final double? border;
  final TextInputAction? textInputAction;

  const AppInput({
    super.key,
    this.onChanged,
    this.validate,
    this.prefixIcon,
    this.suffixIcon,
    this.inputType,
    this.label,
    this.hint,
    this.secureText,
    this.onSubmitted,
    this.isEnabled = true,
    this.controller,
    this.color,
    this.onSaved,
    this.autofocus,
    this.iconColor,
    this.borderColorr,
    this.contentLeft,
    this.contentRight,
    this.contentTop,
    this.contentBottom,
    this.start,
    this.end,
    this.top,
    this.bottom,
    this.enabledBorderColor,
    this.maxLines,
    this.border,
    this.outLineInputColorColor,
    this.disableBorderColor,
    this.errorBorderColor,
    this.focusedBorderColor,
    this.focusedErrorBorderColor,
    this.onTap,
    this.read,
    this.prefixSize,
    this.suffixSize,
    this.filled,
    this.hintColor,
    this.textInputAction,
    this.cursorColor,
  });
  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final radius = border ?? 16.r;
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: start ?? 16.w,
        end: end ?? 16.w,
        top: top ?? 0,
        bottom: bottom ?? 0,
      ),
      child: TextFormField(
        readOnly: read ?? false,
        onTap: onTap,
        maxLines: maxLines ?? 1,
        enabled: isEnabled ?? true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        onFieldSubmitted: onSubmitted,
        style: TextStyle(color: palette.textPrimary, fontSize: 15.sp),
        obscureText: secureText ?? false,
        cursorColor: cursorColor ?? palette.brand,
        keyboardType: inputType ?? TextInputType.text,
        textInputAction: textInputAction ?? TextInputAction.next,
        validator: validate,
        onSaved: onSaved,
        autofocus: autofocus ?? false,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(
              color: enabledBorderColor ?? palette.border,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(
                color: focusedBorderColor ?? palette.brand, width: 1.6),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(color: errorBorderColor ?? palette.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(
                color: focusedErrorBorderColor ?? palette.error, width: 1.6),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(color: disableBorderColor ?? palette.border),
          ),
          contentPadding: EdgeInsets.symmetric(
              vertical: contentTop ?? 16.h, horizontal: contentRight ?? 14.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide:
                BorderSide(color: outLineInputColorColor ?? palette.border),
          ),
          filled: filled ?? true,
          fillColor: color ?? palette.surfaceMuted,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 14.sp,
            color: palette.textSecondary,
            fontFamily: FontFamily.dINArabicMedium,
          ),
          hintStyle: TextStyle(
            fontSize: MediaQuery.of(context).size.width >= 600 ? 12.sp : 14.sp,
            color: hintColor ?? palette.textMuted,
            fontFamily: FontFamily.dINArabicMedium,
          ),
          hintText: hint,
        ),
        onChanged: onChanged,
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../../../core/cache/cache_helper.dart';
import '../../../../core/constants/contsants.dart';
import '../../../../generated/locale_keys.g.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  static AuthCubit get(context) => BlocProvider.of(context);

  // ─────────────────────────────────────────────────────────────────────────
  // OFFLINE / DEMO MODE
  // The original backend (enwanal-anaqa.com) is no longer running, so the auth
  // flow runs fully locally: any well-formed input signs the user in, and the
  // register / OTP / reset flows complete without a server. The networked
  // implementations are intentionally bypassed.
  // ─────────────────────────────────────────────────────────────────────────

  /// Local session id used for the offline/demo session.
  static const String _demoUserId = "demo";

  /// Small artificial delay so loading spinners feel natural.
  static const Duration _fakeLatency = Duration(milliseconds: 600);

  void _clearSessionKeepLang() {
    final lang = CacheHelper.getLang() == "en" ? "en" : "ar";
    CacheHelper.clearData();
    CacheHelper.setLang(lang);
  }

  bool isSecureLogIn = true;
  isSecureLogInIcon(isSecuree) {
    isSecureLogIn = isSecuree;
    emit(IsSecureIcon());
  }

  bool isSecureRegister1 = true;
  isSecureRegisterIcon1(isSecuree) {
    isSecureRegister1 = isSecuree;
    emit(IsSecureIcon());
  }

  bool isSecureRegister2 = true;
  isSecureRegisterIcon2(isSecuree) {
    isSecureRegister2 = isSecuree;
    emit(IsSecureIcon());
  }

  bool isSecureNewPass1 = true;
  isSecureNewPassIcon1(isSecuree) {
    isSecureNewPass1 = isSecuree;
    emit(IsSecureIcon());
  }

  bool isSecureNewPass2 = true;
  isSecureNewPassIcon2(isSecuree) {
    isSecureNewPass2 = isSecuree;
    emit(IsSecureIcon());
  }

  bool agreeTerms = false;
  agreeTermsFun() {
    agreeTerms = !agreeTerms;
    emit(AgreeTermsSuccess());
  }

  int membershipTypeIndex = 0;
  void changeMembershipTypeIndex({required int index}) {
    membershipTypeIndex = index;
    emit(IsSecureIcon());
  }

  Future register({
    required String firstName,
    required String phone,
    required String email,
    required String password,
  }) async {
    emit(RegisterLoading());
    await Future.delayed(_fakeLatency);
    await CacheHelper.setUserId(_demoUserId);
    await CacheHelper.setUserProfile(
      name: firstName,
      phone: phone,
      email: email,
    );
    emit(RegisterSuccess(message: LocaleKeys.activatedSuccessfully.tr()));
  }

  Future otp({required String code}) async {
    emit(OTPLoading());
    await Future.delayed(_fakeLatency);
    emit(OTPSuccess());
  }

  Future logIn({required String phone, required String password}) async {
    emit(LogInLoading());
    await Future.delayed(_fakeLatency);
    await CacheHelper.setUserId(_demoUserId);
    await CacheHelper.setUserProfile(phone: phone);
    emit(LogInSuccess());
  }

  Future logOut() async {
    emit(LogOutLoading());
    await Future.delayed(_fakeLatency);
    _clearSessionKeepLang();
    emit(LogOutSuccess(message: LocaleKeys.logout.tr()));
  }

  String resetPassId = "";
  Future forgetPass({required String phoneCode, required String phone}) async {
    emit(ForgetPassLoading());
    await Future.delayed(_fakeLatency);
    resetPassId = _demoUserId;
    emit(ForgetPassSuccess(message: LocaleKeys.enterActivationCode.tr()));
  }

  Future resendCode() async {
    emit(ResendCodeLoading());
    await Future.delayed(_fakeLatency);
    emit(ResendCodeSuccess(message: LocaleKeys.enterActivationCode.tr()));
  }

  Future resetPass({required String code, required String password}) async {
    emit(ResetPassLoading());
    await Future.delayed(_fakeLatency);
    emit(ResetPassSuccess(message: LocaleKeys.activatedSuccessfully.tr()));
  }

  Future deleteAccount() async {
    emit(DeleteAccountLoading());
    await Future.delayed(_fakeLatency);
    _clearSessionKeepLang();
    emit(DeleteAccountSuccess(message: LocaleKeys.deleteAccount.tr()));
  }

  String? identityImageUrl;
  Future uploadIdentityImage({required List<File> identityImage}) async {
    emit(UploadImageLoading());
    final request = http.MultipartRequest(
      'POST',
      Uri.parse("${baseUrl}api/upload-image"),
    );
    request.fields['lang'] = CacheHelper.getLang();

    for (var image in identityImage) {
      var stream = http.ByteStream(image.openRead());
      var length = await image.length();
      var multipartFile = http.MultipartFile(
        'image',
        stream,
        length,
        filename: image.path.split('/').last,
      );
      request.files.add(multipartFile);
    }
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    Map<String, dynamic> data = jsonDecode(responseBody);
    identityImageUrl = data["app_url"];
    debugPrint("imageUrl is $identityImageUrl");

    if (data["key"] == 1) {
      emit(UploadImageSuccess());
    } else {
      emit(UploadImageFailure());
    }
  }

  String? licenseImageUrl;
  Future uploadLicenseImage({required List<File> licenseImage}) async {
    emit(UploadImageLoading());
    final request = http.MultipartRequest(
      'POST',
      Uri.parse("${baseUrl}api/upload-image"),
    );
    request.fields['lang'] = CacheHelper.getLang();

    for (var image in licenseImage) {
      var stream = http.ByteStream(image.openRead());
      var length = await image.length();
      var multipartFile = http.MultipartFile(
        'image',
        stream,
        length,
        filename: image.path.split('/').last,
      );
      request.files.add(multipartFile);
    }
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    Map<String, dynamic> data = jsonDecode(responseBody);
    licenseImageUrl = data["app_url"];
    debugPrint("imageUrl is $licenseImageUrl");

    if (data["key"] == 1) {
      emit(UploadImageSuccess());
    } else {
      emit(UploadImageFailure());
    }
  }

  String? carImageUrl;
  Future uploadCarImage({required List<File> carImage}) async {
    emit(UploadImageLoading());
    final request = http.MultipartRequest(
      'POST',
      Uri.parse("${baseUrl}api/upload-image"),
    );
    request.fields['lang'] = CacheHelper.getLang();

    for (var image in carImage) {
      var stream = http.ByteStream(image.openRead());
      var length = await image.length();
      var multipartFile = http.MultipartFile(
        'image',
        stream,
        length,
        filename: image.path.split('/').last,
      );
      request.files.add(multipartFile);
    }
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    Map<String, dynamic> data = jsonDecode(responseBody);
    carImageUrl = data["app_url"];
    debugPrint("imageUrl is $carImageUrl");

    if (data["key"] == 1) {
      emit(UploadImageSuccess());
    } else {
      emit(UploadImageFailure());
    }
  }
}

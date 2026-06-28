part of 'app_cubit.dart';

@immutable
sealed class AppState {}

final class AppInitial extends AppState {}

final class ServerError extends AppState {}

final class Timeoutt extends AppState {}

final class ChangeBottomNav extends AppState {}

final class SearchUpdated extends AppState {}

final class ChangeIndex extends AppState {}

final class ChooseImageSuccess extends AppState {}

final class RemoveImageSuccess extends AppState {}

final class IsSecureIcon extends AppState {}

final class GetUserDataLoading extends AppState {}

final class GetUserDataSuccess extends AppState {}

final class GetUserDataFailure extends AppState {
  final String error;

  GetUserDataFailure({required this.error});
}

final class UploadImagesLoading extends AppState {}

final class UploadImagesSuccess extends AppState {}

final class UploadImagesFailure extends AppState {}

final class UpdateProfileLoading extends AppState {}

final class UpdateProfileSuccess extends AppState {
  final String message;
  UpdateProfileSuccess({required this.message});
}

final class UpdateProfileFailure extends AppState {
  final String error;
  UpdateProfileFailure({required this.error});
}

final class ContactUsLoading extends AppState {}

final class ContactUsSuccess extends AppState {
  final String message;
  ContactUsSuccess({required this.message});
}

final class ContactUsFailure extends AppState {
  final String error;
  ContactUsFailure({required this.error});
}

final class CourseSelected extends AppState {}

final class CourseCompleted extends AppState {}

final class CourseSaved extends AppState {}

final class ChangeVideoState extends AppState {}

final class RateLoadingState extends AppState {}

final class RateSuccessState extends AppState {}

part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

//!GET USER PROFILE
final class GetUserProfileLoading extends UserState {}

final class GetUserProfileLoaded extends UserState {
  final User user;

  const GetUserProfileLoaded({required this.user});
}

final class GetUserProfileError extends UserState {
  final String message;

  const GetUserProfileError({required this.message});
}

//DELETE ACCOUNT

final class DeleteAccountLoading extends UserState {}

final class DeleteAccountLoaded extends UserState {
  final String message;

  const DeleteAccountLoaded({required this.message});
}

final class DeleteAccountError extends UserState {
  final String message;

  const DeleteAccountError({required this.message});
}

//EDiT PROFLE

final class EditProfileLoading extends UserState {}

final class EditProfileLoaded extends UserState {
  final User user;

  const EditProfileLoaded({required this.user});
}

final class EditProfileError extends UserState {
  final String message;

  const EditProfileError({required this.message});
}

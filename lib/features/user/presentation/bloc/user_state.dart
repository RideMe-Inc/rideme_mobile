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

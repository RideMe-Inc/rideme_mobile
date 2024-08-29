part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

final class GetUserProfileEvent extends UserEvent {
  final Map<String, dynamic> params;

  const GetUserProfileEvent({required this.params});
}

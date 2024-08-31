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

//DELETE ACCOUNT
final class DeleteAccountEvent extends UserEvent {
  final Map<String, dynamic> params;

  const DeleteAccountEvent({required this.params});
}

//EDT PROFLE
final class EditProfileEvent extends UserEvent {
  final Map<String, dynamic> params;
  const EditProfileEvent({required this.params});
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideme_mobile/features/user/domain/entities/user.dart';
import 'package:rideme_mobile/features/user/domain/usecases/delete_account.dart';
import 'package:rideme_mobile/features/user/domain/usecases/edit_profile.dart';
import 'package:rideme_mobile/features/user/domain/usecases/get_user_profile.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserProfile getUserProfile;
  final DeleteAccount deleteAccount;
  final EditProfile editProfile;

  UserBloc({
    required this.getUserProfile,
    required this.deleteAccount,
    required this.editProfile,
  }) : super(UserInitial()) {
    //!GET USER PROFILE
    on<GetUserProfileEvent>((event, emit) async {
      emit(GetUserProfileLoading());
      final response = await getUserProfile(event.params);

      emit(
        response.fold(
          (l) => GetUserProfileError(message: l),
          (r) => GetUserProfileLoaded(user: r),
        ),
      );
    });

    //DELETE ACCOUNT
    on<DeleteAccountEvent>((event, emit) async {
      emit(DeleteAccountLoading());
      final response = await deleteAccount(event.params);

      emit(
        response.fold(
          (errorMessage) => DeleteAccountError(message: errorMessage),
          (response) => DeleteAccountLoaded(message: response),
        ),
      );
    });

    //EDIT PROFILE
    on<EditProfileEvent>((event, emit) async {
      emit(EditProfileLoading());
      final response = await editProfile(event.params);

      emit(
        response.fold(
          (errorMessage) => EditProfileError(message: errorMessage),
          (response) => EditProfileLoaded(user: response),
        ),
      );
    });
  }
}

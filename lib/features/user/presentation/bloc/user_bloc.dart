import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideme_mobile/features/user/domain/entities/user.dart';
import 'package:rideme_mobile/features/user/domain/usecases/get_user_profile.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserProfile getUserProfile;
  UserBloc({
    required this.getUserProfile,
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
  }
}

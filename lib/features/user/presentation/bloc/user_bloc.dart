import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:rideme_mobile/features/user/domain/entities/user.dart';
import 'package:rideme_mobile/features/user/domain/entities/user_object.dart';
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
          (r) => GetUserProfileLoaded(userObject: r),
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

  //user navigation based on activity

  navigateUserBasedOnAccountActivity(Extra? extra, BuildContext context) {
    print(extra?.ongoingTrips);
    if (extra == null || extra.ongoingTrips.isEmpty) {
      context.goNamed('home');
      return;
    }

    if (extra.ongoingTrips.length <= 1) {
      extra.ongoingTrips.first.scheduledTime == null
          ? context.goNamed('tracking', queryParameters: {
              "tripId": extra.ongoingTrips.first.id.toString()
            })
          : context.goNamed('scheduledTracking', queryParameters: {
              "tripId": extra.ongoingTrips.first.id.toString()
            });

      return;
    }

    for (var ongoingTrip in extra.ongoingTrips) {
      if (ongoingTrip.scheduledTime == null) {
        context.goNamed('tracking',
            queryParameters: {"tripId": ongoingTrip.id.toString()});

        return;
      }
    }
  }
}

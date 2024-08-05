import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideme_mobile/core/usecase/usecase.dart';
import 'package:rideme_mobile/features/onboarding/domain/usecases/is_onboarding_viewed.dart';
import 'package:rideme_mobile/features/onboarding/domain/usecases/mark_onboarding_viewed.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final MarkOnboardingViewed markOnboardingViewed;
  final IsOnboardingViewed isOnboardingViewed;

  OnboardingBloc({
    required this.markOnboardingViewed,
    required this.isOnboardingViewed,
  }) : super(OnboardingInitial()) {
    //!MARK AS VIEWD
    on<MarkAsViewedEvent>((event, emit) async {
      final response = await markOnboardingViewed.call(NoParams());

      emit(
        response.fold(
          (l) => MarkAsViewedError(),
          (r) => MarkAsViewedSuccess(),
        ),
      );
    });

    //!IS VIEWED
    on<IsOnboardingViewedEvent>((event, emit) {
      final response = isOnboardingViewed.call(NoParams());

      emit(
        response.fold(
          (l) => IsOnboardingViewedError(),
          (r) => IsOnboardingViewedSuccess(),
        ),
      );
    });
  }
}

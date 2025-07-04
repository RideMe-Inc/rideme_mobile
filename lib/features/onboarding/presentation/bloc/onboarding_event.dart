part of 'onboarding_bloc.dart';

sealed class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

class MarkAsViewedEvent extends OnboardingEvent {}

class IsOnboardingViewedEvent extends OnboardingEvent {}

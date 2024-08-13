import 'package:dartz/dartz.dart';
import 'package:rideme_mobile/core/usecase/usecase.dart';
import 'package:rideme_mobile/features/onboarding/domain/repository/onboarding_repository.dart';

class IsOnboardingViewed {
  final OnboardingRepository repository;

  IsOnboardingViewed({required this.repository});

  Either<String, bool> call(NoParams params) => repository.isOnboardingViewed();
}

import 'package:dartz/dartz.dart';
import 'package:rideme_mobile/core/usecase/usecase.dart';
import 'package:rideme_mobile/features/onboarding/domain/repository/onboarding_repository.dart';

class MarkOnboardingViewed extends UseCases<bool, NoParams> {
  final OnboardingRepository repository;

  MarkOnboardingViewed({required this.repository});
  @override
  Future<Either<String, bool>> call(NoParams params) async =>
      await repository.markOnboardingViewed();
}

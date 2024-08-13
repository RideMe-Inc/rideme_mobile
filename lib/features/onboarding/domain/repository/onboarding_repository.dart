import 'package:dartz/dartz.dart';

abstract class OnboardingRepository {
  //mark onboarding as viewed
  Future<Either<String, bool>> markOnboardingViewed();

  //is onboarding viewed
  Either<String, bool> isOnboardingViewed();
}

import 'package:dartz/dartz.dart';
import 'package:rideme_mobile/features/onboarding/data/datasources/local_ds.dart';
import 'package:rideme_mobile/features/onboarding/domain/repository/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDatasource localDatasource;

  OnboardingRepositoryImpl({required this.localDatasource});
  @override
  Either<String, bool> isOnboardingViewed() {
    try {
      return Right(localDatasource.isOnboardingViewed());
    } catch (e) {
      return const Left('_');
    }
  }

  @override
  Future<Either<String, bool>> markOnboardingViewed() async {
    try {
      final response = await localDatasource.markOnboardingViewed();

      return Right(response);
    } catch (e) {
      return const Left('_');
    }
  }
}

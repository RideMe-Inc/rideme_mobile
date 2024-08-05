import 'package:shared_preferences/shared_preferences.dart';

abstract class OnboardingLocalDatasource {
  //mark onboarding as viewed
  Future<bool> markOnboardingViewed();

  //is onboarding viewed
  bool isOnboardingViewed();
}

class OnboardingLocalDatasourceImpl implements OnboardingLocalDatasource {
  final SharedPreferences sharedPreferences;

  OnboardingLocalDatasourceImpl({required this.sharedPreferences});
  @override
  bool isOnboardingViewed() {
    final onboardingStatus = sharedPreferences.getBool('ONBOARDING_CACHE');

    if (onboardingStatus != null && onboardingStatus) {
      return true;
    }

    throw Exception();
  }

  @override
  Future<bool> markOnboardingViewed() async {
    return await sharedPreferences.setBool('ONBOARDING_CACHE', true);
  }
}

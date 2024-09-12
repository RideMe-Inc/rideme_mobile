import 'package:rideme_mobile/features/user/domain/entities/ongoing_trip.dart';
import 'package:rideme_mobile/features/user/domain/entities/user.dart';

class UserObject {
  final User profile;
  final Extra? extra;

  UserObject({required this.profile, required this.extra});
}

class Extra {
  final List<UserOngoingTrips> ongoingTrips;

  Extra({required this.ongoingTrips});
}

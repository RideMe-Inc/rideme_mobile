import 'package:rideme_mobile/features/user/data/models/ongoing_trip_model.dart';
import 'package:rideme_mobile/features/user/data/models/user_model.dart';
import 'package:rideme_mobile/features/user/domain/entities/user_object.dart';

class UserObjectModel extends UserObject {
  UserObjectModel({
    required super.profile,
    required super.extra,
  });

  //fromJson
  factory UserObjectModel.fromJson(Map<String, dynamic> json) =>
      UserObjectModel(
        profile: UserModel.fromJson(json['profile']),
        extra:
            json["extra"] != null ? ExtraModel.fromJson(json['extra']) : null,
      );
}

class ExtraModel extends Extra {
  ExtraModel({required super.ongoingTrips});

  //fromJson
  factory ExtraModel.fromJson(Map<String, dynamic> json) => ExtraModel(
      ongoingTrips: json['ongoing_trips']
          .map<UserOngoingTripsModel>((e) => UserOngoingTripsModel.fromJson(e))
          .toList());
}

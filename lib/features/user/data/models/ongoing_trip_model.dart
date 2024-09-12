//ONGOING TRIPS
import 'package:rideme_mobile/features/user/domain/entities/ongoing_trip.dart';

class UserOngoingTripsModel extends UserOngoingTrips {
  const UserOngoingTripsModel({
    required super.id,
    required super.status,
    required super.isReleased,
    required super.scheduledTime,
  });

  //fromJson
  factory UserOngoingTripsModel.fromJson(Map<String, dynamic> json) {
    return UserOngoingTripsModel(
      id: json['id'],
      status: json['status'],
      isReleased: json['is_released'],
      scheduledTime: json['schedule_time'],
    );
  }
}

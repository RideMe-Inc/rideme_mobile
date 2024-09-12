//ONGOING TRIPS
import 'package:equatable/equatable.dart';

class UserOngoingTrips extends Equatable {
  final int id;
  final String status;
  final String? scheduledTime;
  final bool? isReleased;

  const UserOngoingTrips({
    required this.id,
    required this.status,
    required this.isReleased,
    required this.scheduledTime,
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "status": status,
        "schedule_time": scheduledTime,
        "is_released": isReleased,
      };

  @override
  List<Object?> get props => [
        id,
        status,
        scheduledTime,
        isReleased,
      ];
}

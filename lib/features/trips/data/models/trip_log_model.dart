import 'package:rideme_mobile/features/trips/domain/entities/trip_log.dart';

class TripLogModel extends TripLogInfo {
  const TripLogModel(
      {required super.message,
      required super.createdAt,
      required super.type,
      required super.extra});

  factory TripLogModel.fromJson(Map<String, dynamic>? json) {
    return TripLogModel(
      message: json?["message"],
      createdAt: json?["created_at"],
      type: json?["type"],
      extra: ExtraModel.fromJson(json?["extra"]),
    );
  }
}

class ExtraModel extends ExtraInfo {
  const ExtraModel({required super.imageURL});

  factory ExtraModel.fromJson(Map<String, dynamic>? json) {
    return ExtraModel(
      imageURL: json?["image_url"],
    );
  }
}

import 'package:equatable/equatable.dart';

class TripLogInfo extends Equatable {
  final String? message, createdAt, type;
  final ExtraInfo? extra;

  const TripLogInfo({
    required this.message,
    required this.createdAt,
    required this.type,
    required this.extra,
  });

  @override
  List<Object?> get props => [
        message,
        createdAt,
        type,
        extra,
      ];

  Map<String, dynamic> toMap() => {
        'message': message,
        'created_at': createdAt,
        'type': type,
        'extra': extra?.toMap(),
      };
}

class ExtraInfo extends Equatable {
  final String? imageURL;

  const ExtraInfo({
    required this.imageURL,
  });
  @override
  List<Object?> get props => [
        imageURL,
      ];

  Map<String, dynamic> toMap() => {
        'image_url': imageURL,
      };
}

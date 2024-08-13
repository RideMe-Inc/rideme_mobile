import 'package:rideme_mobile/features/authentication/data/model/authorization_model.dart';
import 'package:rideme_mobile/features/authentication/domain/entity/authentication.dart';
import 'package:rideme_mobile/features/user/data/models/user_model.dart';

class AuthenticationModel extends Authentication {
  const AuthenticationModel({
    required super.message,
    required super.authorization,
    required super.user,
  });

  factory AuthenticationModel.fromJson(Map<String, dynamic> json) {
    return AuthenticationModel(
      message: json['message'],
      authorization: AuthorizationModel.fromJson(json['authorization']),
      user: UserModel.fromJson(json['user']),
    );
  }
}

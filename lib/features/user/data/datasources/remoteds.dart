import 'package:rideme_mobile/core/enums/endpoints.dart';
import 'package:rideme_mobile/core/mixins/remote_request_mixin.dart';
import 'package:rideme_mobile/core/urls/urls.dart';
import 'package:rideme_mobile/features/user/data/models/user_model.dart';
import 'package:http/http.dart' as http;

abstract class UserRemoteDatasource {
  //get user profile
  Future<UserModel> getUserProfile(Map<String, dynamic> params);

  //delete account
  Future<String> deleteAccount(Map<String, dynamic> params);

  //edit  profile
  Future<UserModel> editProfile(Map<String, dynamic> params);
}

class UserRemoteDatasourceImpl
    with RemoteRequestMixin
    implements UserRemoteDatasource {
  final http.Client client;
  final URLS urls;

  UserRemoteDatasourceImpl({
    required this.client,
    required this.urls,
  });
  @override
  Future<UserModel> getUserProfile(Map<String, dynamic> params) async {
    final decodedResponse = await get(
      client: client,
      urls: urls,
      endpoint: Endpoints.profile,
      params: params,
    );

    return UserModel.fromJson(decodedResponse['profile']);
  }

  //DELETE ACCOUNT

  @override
  Future<String> deleteAccount(Map<String, dynamic> params) async {
    final decodedResponse = await delete(
      client: client,
      urls: urls,
      params: params,
      endpoint: Endpoints.profile,
    );

    return decodedResponse['message'];
  }

  @override
  Future<UserModel> editProfile(Map<String, dynamic> params) async {
    final decodedResponse = await patch(
      client: client,
      urls: urls,
      params: params,
      endpoint: Endpoints.profile,
    );

    return UserModel.fromJson(decodedResponse['profile']);
  }
}

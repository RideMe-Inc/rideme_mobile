import 'package:rideme_mobile/core/enums/endpoints.dart';
import 'package:rideme_mobile/core/location/data/models/geo_hash_model.dart';
import 'package:http/http.dart' as http;
import 'package:rideme_mobile/core/mixins/remote_request_mixin.dart';
import 'package:rideme_mobile/core/urls/urls.dart';

abstract class HomeRemoteDatasource {
  //fetch top places
  Future<List<GeoDataModel>> fetchTopPlaces(Map<String, dynamic> params);
}

class HomeRemoteDatasourceImpl
    with RemoteRequestMixin
    implements HomeRemoteDatasource {
  final URLS urls;
  final http.Client client;

  HomeRemoteDatasourceImpl({required this.urls, required this.client});

  @override
  Future<List<GeoDataModel>> fetchTopPlaces(Map<String, dynamic> params) async {
    final decodedResponse = await get(
      client: client,
      urls: urls,
      params: params,
      endpoint: Endpoints.topPlaces,
    );

    return decodedResponse['places']
        .map<GeoDataModel>((e) => GeoDataModel.fromJson(e))
        .toList();
  }
}

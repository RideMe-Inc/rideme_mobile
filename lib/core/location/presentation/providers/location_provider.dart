import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideme_mobile/assets/images/image_name_constants.dart';
import 'package:rideme_mobile/core/location/domain/entity/geo_hash.dart';
import 'package:rideme_mobile/core/location/domain/usecases/cache_locations.dart';
import 'package:rideme_mobile/core/location/domain/usecases/retrieve_locations.dart';

class LocationProvider extends ChangeNotifier {
  final CacheLocation cacheLocation;
  final RetrieveLocations retrieveLocations;

  GeoData? _geoDataInfo;

  LocationProvider({
    required this.cacheLocation,
    required this.retrieveLocations,
  });

  BitmapDescriptor _customIcon = BitmapDescriptor.defaultMarker;

  BitmapDescriptor get customIcon => _customIcon;

  GeoData? get geoDataInfo => _geoDataInfo;

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  loadCustomIcon() async {
    final markericon =
        await getBytesFromAsset(ImageNameConstants.locationPinIMG, 30);

    _customIcon = BitmapDescriptor.bytes(markericon);
  }

  set updateGeoDataInfo(GeoData value) {
    _geoDataInfo = value;
    notifyListeners();
  }
}

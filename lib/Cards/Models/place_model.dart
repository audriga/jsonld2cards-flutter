library place_model;

import 'dart:convert';

import 'package:jsonld2cards/Cards/Models/thing_model.dart';
import 'package:jsonld2cards/GeoData/geo_data.dart';

/// Special case to provide duplicate hash function for [GeoData].
/// Currently there is no close relation to actual https://schema.org/Place
class Place extends Thing {
  GeoData geoData;

  Place({required this.geoData});

  Place.fromJson(super.json)
      : geoData = GeoData.fromJson(json),
        super.fromJson();

  @override
  Map<String, dynamic> toJson() => jsonDecode(geoData.toJson());

  @override
  int get duplicateHash =>
      'Place'.hashCode ^
      geoData.latLong.hashCode ^
      geoData.addressData.hashCode ^
      geoData.liveUri.hashCode;
}

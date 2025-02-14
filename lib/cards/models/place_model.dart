library;

import 'package:jsonld2cards/cards/models/thing_model.dart';
import 'package:jsonld2cards/geo_data/geo_data.dart';

/// Special case to provide duplicate hash function for [GeoData].
/// Currently there is no close relation to actual https://schema.org/Place
class Place extends Thing {
  GeoData geoData;

  Place({required this.geoData});

  Place.fromJson(super.json)
      : geoData = GeoData.fromJson(json),
        super.fromJson();

  @override
  Map<String, dynamic> toJson() => geoData.toJson();

  @override
  int get duplicateHash =>
      'Place'.hashCode ^
      geoData.latLong.hashCode ^
      geoData.addressData.hashCode ^
      geoData.liveUri.hashCode;
}

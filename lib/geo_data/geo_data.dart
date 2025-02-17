library;

import 'dart:convert';

import '../src/cards/models/action_model.dart';
import 'package:jsonld2cards/app_context.dart';
import 'package:jsonld2cards/util/conversion.dart';
import 'package:logging/logging.dart';

import 'tile_util.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

final log = Logger('jsonld2cards.geo_data');

class GeoData {
  LatLng latLong;
  String? name;
  Uri? imageUrl;
  Uri? imageB64;
  bool? isLive;
  Uri? liveUri;
  String? imgAlt;
  String? imgCopyright;
  Map<String, dynamic>? addressData;
  String? addressString;
  Map<String, dynamic>? extraTags;
  List<Action>? potentialActions;

  GeoData({
    required this.latLong,
    this.name,
    this.imageUrl,
    this.imageB64,
    this.isLive,
    this.liveUri,
    this.imgAlt,
    this.imgCopyright,
    this.addressData,
    this.addressString,
    this.potentialActions,
  }) {
    if (potentialActions == null || potentialActions!.isEmpty) {
      var mapViewUrl =
          globalAppContext?.mapViewUrl ?? 'www.openstreetmap.org';
      potentialActions = [
        Action.fromJson({
          '@type': 'ViewAction',
          'name': 'View',
          'url':
              'https://$mapViewUrl/?mlat=${latLong.latitude}&mlon=${latLong.longitude}',
        }),
        Action.fromJson({
          '@type': 'ViewAction',
          'name': 'Navigate to',
          'url':
              'https://www.google.com/maps/dir/?api=1&destination=${latLong.latitude},${latLong.longitude}',
        }),
      ];
    }
  }

  /// Uses https://nominatim.org/release-docs/develop/api/Output/#addressdetails
  /// and https://nominatim.org/release-docs/develop/api/Reverse/#result-limitation
  /// to determine zoom level
  static int detailKeyToZoomLevel(String detailKey) {
    switch (detailKey) {
      case 'continent':
        return 2;
      case 'country':
      case 'country_code':
        return 3;
      case 'region':
      case 'state':
      case 'state_district':
      case 'county':
      case 'ISO3166-2-lvl':
      case 'ISO3166-2-lvl4':
        return 8;
      case 'municipality':
      case 'city':
      case 'town':
      case 'village':
        return 10;
      case 'city_district':
      case 'district':
      case 'borough':
      case 'suburb':
      case 'subdivision':
        return 12;
      case 'hamlet':
      case 'croft':
      case 'isolated_dwelling':
        return 13;
      case 'neighbourhood':
      case 'allotments':
      case 'quarter':
        return 14;
      case 'city_block':
      case 'residential':
      case 'farm':
      case 'farmyard':
      case 'industrial':
      case 'commercial':
      case 'retail':
        return 15;
      case 'road':
        return 16;
      case 'house_number':
      case 'house_name':
        return 18;
      case 'emergency':
      case 'historic':
      case 'military':
      case 'natural':
      case 'landuse':
      case 'place':
      case 'railway':
      case 'man_made':
      case 'aerialway':
      case 'boundary':
      case 'amenity':
      case 'aeroway':
      case 'club':
      case 'craft':
      case 'leisure':
      case 'office':
      case 'mountain_pass':
      case 'shop':
      case 'tourism':
      case 'bridge':
      case 'tunnel':
      case 'waterway':
        return 18;
      case 'postcode':
        return 12;
    }
    return 18;
  }

  static bool showAsRefineOption(String detailKey) {
    var allowedOptions = <String>[
      'country',
      'region',
      'state',
      'county',
      'city',
      'town',
      'village',
      'city_district',
      'district',
      'borough',
      'suburb',
      'city_block',
      'residential',
      'farm',
      'farmyard',
      'industrial',
      'commercial',
      'retail',
      'road',
      'house_number',
      'house_name',
      'emergency',
      'historic',
      'military',
      'natural',
      'landuse',
      'place',
      'railway',
      'man_made',
      'aerialway',
      'boundary',
      'amenity',
      'aeroway',
      'club',
      'craft',
      'leisure',
      'office',
      'mountain_pass',
      'shop',
      'tourism',
      'bridge',
      'tunnel',
      'waterway',
    ];
    return allowedOptions.contains(detailKey);
  }

  Future<void> downloadImage({int zoom = 18}) async {
    String tileServer =
        globalAppContext?.tileServer ?? 'tile.openstreetmap.org';
    TileNumber tileNr =
        TileNumber.fromLatLong(latLong.latitude, latLong.longitude, zoom);
    imageUrl =
        Uri.parse('https://$tileServer/$zoom/${tileNr.x}/${tileNr.y}.png');
    await http.get(imageUrl!).then((tileResponse) {
      imageB64 = Uri.dataFromBytes(
        tileResponse.bodyBytes,
        mimeType: 'image/png',
      ); //base64Encode(tileResponse.bodyBytes);
      imgAlt = 'Map tile';
      imgCopyright = '\u{a9} ${DateTime.timestamp().year} OpenStreetMap';
      log.info(
        'Done downloading image',
      );
    }).onError((error, stackTrace) {
      log.warning(
        'Error downloading image',
        error,
      );
    });
    log.info(
      'Done waiting to download image',
    );
  }

  Future<void> reverseGeocode({String languageCode = 'en'}) async {
    String geocodingServer =
        globalAppContext?.geocodingServer ?? 'nominatim.openstreetmap.org';
    String url =
        'https://$geocodingServer/reverse?format=json&lat=${latLong.latitude}&lon=${latLong.longitude}&zoom=18&addressdetails=1&extratags=1&namedetails=1&accept-language=$languageCode';
    // todo language as variable
    var response = await http.get(Uri.parse(url));
    var decodedResponse = jsonDecode(response.body);
    log.info('Reverse Geocoded Position, got\n$decodedResponse');
    if (decodedResponse is Map<String, dynamic>) {
      addressString = decodedResponse['display_name'];
      addressData = decodedResponse['address'];
      name = decodedResponse['namedetails']?['name'];
      extraTags = decodedResponse['extratags'];
    } else {
      log.warning('Error decoding reverse geocode request answer');
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      "@context": "https://schema.org",
      "@type": "Place",
      "geo": {
        "@type": "GeoCoordinates",
        "latitude": "${latLong.latitude}",
        "longitude": "${latLong.longitude}"
      },
    };
    if (addressString != null) {
      data["address"] = addressString;
    }
    if (name != null) {
      data["name"] = name;
    } else if (addressString != null) {
      data["name"] = addressString;
    } else {
      data["name"] = "My Current Location is";
    }
    if (imageB64 != null || imageUrl != null) {
      Map<String, dynamic> image = {};
      if (imageB64 != null) {
        image["contentUrl"] = "$imageB64";
      } else if (imageUrl != null) {
        image["url"] = "$imageUrl";
      }
      if (imgAlt != null) {
        image['name'] = imgAlt;
      }
      if (imgCopyright != null) {
        image['copyrightNotice'] = imgCopyright;
      }
      data['image'] = image;
    }
    if (isLive != null && isLive!) {
      data["live"] = true;
    }
    if (liveUri != null && isLive!) {
      data["liveUri"] = "$liveUri";
    }
    if (potentialActions != null) {
      data['potentialAction'] = potentialActions!
          .map<Map<String, dynamic>>(
            (e) => e.toJson()..remove('@context'),
          )
          .toList();
    }
    return data;
  }

  Future<bool> updateLive({bool updateImage = true, updateName = false}) async {
    if (isLive == null || !isLive! || liveUri == null) {
      return Future.error('Not a live location');
    }
    bool updateSuccess =
        await http.get(liveUri!).then((http.Response response) {
      log.warning(
          'Updated location and got response (${response.statusCode}) ${response.body}');
      try {
        String jsonString = response.body;
        Map<String, dynamic> responseJson = jsonDecode(jsonString);
        var geo = responseJson['geo'];
        latLong = LatLng(
            double.parse(geo['latitude']), double.parse(geo['longitude']));
      } on Error catch (e) {
        log.warning('Error updating/ parsing location', e);
        return false;
      }
      return true;
    }).onError((error, stackTrace) {
      log.warning('Error updating location', error);
      return false;
    });
    if (updateSuccess) {
      if (updateImage) {
        await downloadImage();
      }
      if (updateName) {
        await reverseGeocode();
      }
      return true;
    } else {
      return false;
    }
  }

  GeoData.fromJson(Map<String, dynamic> json)
      : latLong = LatLng(double.parse(json['geo']['latitude']),
            double.parse(json['geo']['longitude'])),
        name = json['name'],
        isLive = json['live'] {
    if (json['address'] case String address) {
      addressString = address;
    } else if (json['address'] case Map<String, dynamic> address) {
      addressData = address;
    }
    if (json['image'] case Map<String, dynamic> image) {
      // todo refactor out to method get image, reuse for spotify
      var contentUrl = image['contentUrl'] ?? image['url'];
      if (contentUrl != null) {
        Uri? jsonImageUri = tryCastOrParse(contentUrl);
        if (jsonImageUri != null) {
          var imageUriData = jsonImageUri.data;
          if (imageUriData != null && imageUriData.isBase64) {
            imageB64 = jsonImageUri;
          } else if (['http', 'https'].contains(jsonImageUri.scheme)) {
            imageUrl = jsonImageUri;
          } else {
            log.warning(
                'Unexpected scheme: ${jsonImageUri.scheme}\n$jsonImageUri');
          }
        } else {
          //Unknown scheme
          log.warning('ImageUri is not a uri\nimageUri: $contentUrl');
        }
      }
      if (image['name'] case String imageName) {
        imgAlt = imageName;
      }
      if (image['copyrightNotice'] case String imageCopyrightNotice) {
        imgCopyright = imageCopyrightNotice;
      }
    }

    var liveUriVar = json['liveUri'];
    if (liveUriVar != null) {
      if (liveUriVar is Uri) {
        liveUri = liveUriVar;
      } else if (liveUriVar is String) {
        liveUri = Uri.tryParse(liveUriVar);
      } else {
        log.warning(
          'LiveUri is not a uri or String (${liveUriVar.runtimeType}) liveUriVar: $liveUriVar',
        );
      }
    }
    var potentialActionsVar = json['potentialAction'];
    if (potentialActionsVar is List) {
      potentialActions = potentialActionsVar
          .map(
            (e) => Action.fromJson(e),
          )
          .toList();
    } else if (potentialActionsVar is Map<String, dynamic>) {
      potentialActions = [Action.fromJson(potentialActionsVar)];
    }
  }
}

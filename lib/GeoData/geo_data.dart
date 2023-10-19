library geo_data;

import 'dart:convert';

import 'tile_util.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class GeoData {
  LatLng latLong;
  String? name;
  Uri? imageUrl;
  Uri? imageB64;
  bool? isLive;
  Uri? liveUri;
  Map<String, dynamic>? addressData;
  String? addressString;
  Map<String, dynamic>? extraTags;

  GeoData({
    required this.latLong,
    this.name,
    this.imageUrl,
    this.imageB64,
    this.isLive,
    this.liveUri,
    this.addressData,
    this.addressString,
  });

  /// Uses https://nominatim.org/release-docs/develop/api/Output/#addressdetails
  /// and https://nominatim.org/release-docs/develop/api/Reverse/#result-limitation
  /// to determine zoom level
  static int detailKeyToZoomLevel(String detailKey) {
    switch (detailKey) {
      case 'continent': return 2;
      case 'country': case 'country_code': return 3;
      case 'region': case 'state': case 'state_district': case 'county': case 'ISO3166-2-lvl': case 'ISO3166-2-lvl4': return 8;
      case 'municipality': case 'city': case 'town': case 'village': return 10;
      case 'city_district': case 'district': case 'borough': case 'suburb': case 'subdivision': return 12;
      case 'hamlet': case 'croft':  case 'isolated_dwelling': return 13;
      case 'neighbourhood': case 'allotments': case 'quarter': return 14;
      case 'city_block': case 'residential': case 'farm': case 'farmyard': case 'industrial': case 'commercial': case 'retail': return 15;
      case 'road': return 16;
      case 'house_number': case 'house_name': return 18;
      case 'emergency': case 'historic': case 'military': case 'natural': case 'landuse': case 'place': case 'railway': case 'man_made': case 'aerialway': case 'boundary': case 'amenity': case 'aeroway': case 'club': case 'craft': case 'leisure': case 'office': case 'mountain_pass': case 'shop': case 'tourism': case 'bridge': case 'tunnel': case 'waterway': return 18;
      case 'postcode': return 12;

    }
    return 18;
  }

  static bool showAsRefineOption(String detailKey) {
    var allowedOptions = <String>[
      'country', 'region', 'state', 'county', 'city', 'town', 'village',
      'city_district', 'district', 'borough', 'suburb',
      'city_block', 'residential', 'farm', 'farmyard', 'industrial', 'commercial', 'retail',
      'road',
      'house_number', 'house_name',
      'emergency', 'historic', 'military', 'natural', 'landuse', 'place', 'railway', 'man_made', 'aerialway', 'boundary', 'amenity', 'aeroway', 'club', 'craft', 'leisure', 'office', 'mountain_pass', 'shop', 'tourism', 'bridge', 'tunnel', 'waterway',
    ];
    return allowedOptions.contains(detailKey);
  }

  Future<void> downloadImage({int zoom = 18}) async {
    TileNumber tileNr = TileNumber.fromLatLong(latLong.latitude, latLong.longitude, zoom);
    imageUrl = Uri.parse('https://tile.openstreetmap.org/$zoom/${tileNr.x}/${tileNr.y}.png');
    await http.get(imageUrl!)
        .then((tileResponse) {
      imageB64 = Uri.dataFromBytes(
        tileResponse.bodyBytes,
        mimeType: 'image/png',
      ); //base64Encode(tileResponse.bodyBytes);
      developer.log(
        'Done downloading image',
        name: 'jsonld2cards.geo_data',
      );
    }).onError((error, stackTrace)  {
      developer.log(
        'Error downloading image',
        name: 'jsonld2cards.geo_data',
        error: error,
      );
    });

    developer.log(
      'Done waiting to download image',
      name: 'jsonld2cards.geo_data',
    );
  }

  Future<void> reverseGeocode({String languageCode = 'en'}) async {
    String url =
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=${latLong.latitude}&lon=${latLong.longitude}&zoom=18&addressdetails=1&extratags=1&namedetails=1&accept-language=$languageCode';
    // todo language as variable
    var response = await http.get(Uri.parse(url));
    var decodedResponse = jsonDecode(response.body);
    developer.log(
      'Reverse Geocoded Position, got\n$decodedResponse',
      name: 'jsonld2cards.geo_data',

    );
    if (decodedResponse is Map<String, dynamic>) {
      addressString = decodedResponse['display_name'];
      addressData = decodedResponse['address'];
      name = decodedResponse['namedetails']?['name'];
      extraTags = decodedResponse['extratags'];
    } else {
      developer.log(
        'Error decoding reverse geocode request answer',
        name: 'jsonld2cards.geo_data',
      );
    }
  }


  String toJson() {
    // todo use a map<String, dynamic> instead and call jsonEncode.
    // todo use potentialactions property for view and navigate
    var jsonBuffer = StringBuffer();
    jsonBuffer.write(
'''{
  "@context": "https://schema.org",
  "@type": "Place",
  "geo": {
    "@type": "GeoCoordinates",
    "latitude": "${latLong.latitude}",
    "longitude": "${latLong.longitude}"
  }''',
    );
    if (addressString != null) {
      jsonBuffer.write(
        ''',
  "address": "$addressString"''',
      );
    }
    if (name != null) {
      jsonBuffer.write(
        ''',
  "name": "$name"''',
      );
    } else if (addressString != null) {
      jsonBuffer.write(
        ''',
  "name": "$addressString"''',
      );
    } else {
      jsonBuffer.write(
        ''',
  "name": "My Current Location is"''',
      );
    }
    if (imageB64 != null) {
      jsonBuffer.write(
          ''',
  "image" : {"contentUrl" : "$imageB64" }''',
      );
    } else if (imageUrl != null) {
      jsonBuffer.write(
        ''',
  "image" : {"url" :  "$imageUrl"}''',
      );
    }
    if (isLive != null && isLive!) {
      jsonBuffer.write(
        ''',
  "live" : true''',
      );
    }
    if (liveUri != null && isLive!) {
      jsonBuffer.write(
        ''',
  "liveUri" : "$liveUri"''',
      );
    }
    jsonBuffer.write('''}''');
    return jsonBuffer.toString();
  }
  
  Future<bool> updateLive({bool updateImage = true, updateName = false}) async {
    if (isLive == null || !isLive! || liveUri == null) {
      return Future.error('Not a live location');
    }
    bool updateSuccess = await http.get(liveUri!).then((http.Response response) {
      developer.log(
        'Updated location and got response (${response.statusCode}) ${response.body}',
        name: 'jsonld2cards.geo_data',
      );
      try {
        String jsonString = response.body;
        Map<String, dynamic> responseJson = jsonDecode(jsonString);
        var geo = responseJson['geo'];
        latLong = LatLng(double.parse(geo['latitude']), double.parse(geo['longitude']));
      } on Error catch (e) {
        developer.log(
          'Error updating/ parsing location',
          name: 'jsonld2cards.geo_data',
          error: e,
        );
        return false;
      }
      return true;
    }).onError((error, stackTrace) {
      developer.log(
        'Error updating location',
        name: 'jsonld2cards.geo_data',
        error: error,
      );
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
      : latLong = LatLng(double.parse(json['geo']['latitude']), double.parse(json['geo']['longitude'])),
        addressString = json['address'],
        name = json['name'],
        isLive = json['live'] {
    var image = json['image'];
    if (image != null) {
      // todo refactor out to method get image, reuse for spotify
      var contentUrl = image['contentUrl'] ?? image['url'];
      if (contentUrl!= null) {
        Uri? jsonImageUri;
        if (contentUrl is Uri) {
          jsonImageUri = contentUrl;
        } else if (contentUrl is String) {
          jsonImageUri = Uri.tryParse(contentUrl);
        }
        if (jsonImageUri != null) {
          var imageUriData = jsonImageUri.data;
          if (imageUriData != null && imageUriData.isBase64) {
            imageB64 = jsonImageUri;
          } else if (['http', 'https'].contains(jsonImageUri.scheme)) {
            imageUrl = jsonImageUri;
          } else {
            developer.log(
              'Unexpected scheme: ${jsonImageUri.scheme}\n$jsonImageUri',
              name: 'jsonld2cards.card_rendering',
            );
          }
        } else {
          //Unknown scheme
          developer.log(
            'ImageUri is not a uri\nimageUri: $contentUrl',
            name: 'jsonld2cards.geo_data',
          );
        }
      }
    }

    var liveUriVar = json['liveUri'];
    if (liveUriVar != null) {
      if (liveUriVar is Uri) {
        liveUri = liveUriVar;
      } else if (liveUriVar is String) {
        liveUri = Uri.tryParse(liveUriVar);
      } else {
        developer.log(
          'LiveUri is not a uri or String (${liveUriVar.runtimeType})\liveUriVar: $liveUriVar',
          name: 'jsonld2cards.geo_data',
        );
      }
    }
  }
}
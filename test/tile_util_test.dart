import 'package:latlong2/latlong.dart';
import 'package:jsonld2cards/geo_data/tile_util.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:developer';

void main() {
  test('Test coordinate to tile conversion', () {
    var position = const LatLng(49.00444652615525, 8.42715400814573);
    for (int zoom = 0; zoom < 20; zoom++) {
      TileNumber tileNr = TileNumber.fromLatLong(position.latitude, position.longitude, zoom);
      String tileUrl = 'https://tile.openstreetmap.org/$zoom/${tileNr.x}/${tileNr.y}.png';
      log('$tileUrl\n');
    }
  });
}


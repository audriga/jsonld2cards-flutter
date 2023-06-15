import 'package:latlong2/latlong.dart';
import 'package:markup_cards/GeoData/tile_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test coordinate to tile conversion', () {
    var position = LatLng(49.00444652615525, 8.42715400814573);
    for (int zoom = 0; zoom < 20; zoom++) {
      TileNumber tileNr = TileNumber.fromLatLong(position.latitude, position.longitude, zoom);
      String tileUrl = 'https://tile.openstreetmap.org/$zoom/${tileNr.x}/${tileNr.y}.png';
      print('$tileUrl\n');
    }
  });
}


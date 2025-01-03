library;

import 'dart:math';

const double piOver180 = pi / 180.0;
double toDegrees(double radians) {
  return radians / piOver180;
}

double toRadians(double degrees) {
  return degrees * piOver180;
}

class TileNumber {
  late int x;
  late int y;

  TileNumber(this.x, this.y);

  TileNumber.fromLatLong(double latitude, longitude, int zoom) {
    var latRad = toRadians(latitude);
    x = ((longitude + 180)/ 360 * (1 << zoom) ).floor();
    y = ((1.0 - log(tan(latRad) + 1.0 / cos(latRad)) / pi) / 2 * (1<<zoom)).floor();
    if (x < 0) {
      x = 0;
    }
    if (x >= (1 << zoom)) {
      x= (1 << zoom) - 1;
    }
    if (y < 0) {
      y = 0;
    }
    if (y >= (1 << zoom)) {
      y = (1 << zoom) - 1;
    }
  }
}
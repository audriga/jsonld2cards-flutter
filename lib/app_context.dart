library;

import 'src/cards/building_blocks/potential_actions.dart';
import 'src/cards/place_card.dart';
import 'geo_data/geo_data.dart';

typedef SendEmailCallback = Function(
    {dynamic dataToSend, String? subject, String? recipient});
// todo define this for event/ ical potential actions
typedef EventCallback = Function({Map<String, dynamic> eventData});

AppContext? globalAppContext;

class AppContext {
  /// [confirmCallback] can be set to a function that can send an email without
  /// user-interaction. Used in [PotentialActionButton] to send a confirm/ cancel email
  /// on button press.
  SendEmailCallback? confirmCallback;

  /// [eventCallback] can be set to a function that shares a calender
  /// event. Used in [PotentialActionButton] on button press on ShareAction.
  EventCallback? eventCallback;

  /// [imageProxyUrl] can point to a server that proxies image data.
  /// This can be used for apps deployed on the web, to avoid images not loading
  /// due to CORS.
  /// The url should use the `$IMAGEURL` placeholder (including the dollar symbol).
  /// For example `https://localhost:8080?url=\$IMAGEURL` for testing.
  /// If this is not set images will never be proxied.
  String? imageProxyUrl;

  /// [mapViewUri] is used to create links to locations for the "View" action
  /// of [Place] cards.
  /// This can either be a https url (for example to an OpenStreetMap instance),
  /// or use for example the geo schema: `geo:\$LATITUDE,\$LONGITUDE`.
  /// The uri is assembled in [GeoData]. Use `$LATITUDE` and `$LONGITUDE` as
  /// placeholders for the coordinates (including the dollar symbol).
  /// If this is not set, the view button will not be rendered on Location data.
  String? mapViewUri;

  /// [mapNavigateUri] is used to create links to navigate to a given location.
  /// This is used for the "Navigate to" action of [Place] cards.
  /// Like with [mapViewUri] this can either be a https url, or a uri using a
  /// different scheme. For example on android the `google.navigation` scheme
  /// (`google.navigation:q=\$LATITUDE,\$LONGITUDE`) can be used to trigger
  /// navigation in a variety of apps.
  /// The link is assembled in [GeoData]. Use `$LATITUDE` and `$LONGITUDE` as
  /// placeholders for the coordinates (including the dollar symbol).
  /// If this is not set, the navigate to button will not be rendered on
  /// Location data.
  String? mapNavigateUri;

  /// [tileServer] is the server for map tiles. Used by [GeoData], when refreshing
  /// the image for liveLocation.
  String? tileServer;

  /// [geocodingServer] is the server used for reverse geocoding in [GeoData],
  /// when refreshing a liveLocation.
  String? geocodingServer;

  AppContext({
    this.confirmCallback,
    this.eventCallback,
    this.imageProxyUrl,
    this.mapViewUri,
    this.tileServer,
    this.geocodingServer,
    this.mapNavigateUri,
  });
}

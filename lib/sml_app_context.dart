library;

import 'src/cards/building_blocks/potential_actions.dart';
import 'src/cards/place_card.dart';
import 'geo_data/geo_data.dart';

typedef SendEmailCallback = Function(
    {dynamic dataToSend, String? subject, String? recipient});
// todo define this for event/ ical potential actions
typedef EventCallback = Function({Map<String, dynamic> eventData});

SMLAppContext? globalSMLAppContext;

class SMLAppContext {
  /// [confirmCallback] can be set to a function that can send an email without
  /// user-interaction. Used in [PotentialActionButton] to send a confirm/ cancel email
  /// on button press.
  SendEmailCallback? confirmCallback;

  /// [eventCallback] can be set to a function that shares a calender
  /// event. Used in [PotentialActionButton] on button press on ShareAction.
  EventCallback? eventCallback;

  /// [imageProxyUrl] can point to a server that proxies image data with the
  /// query format `$imageProxyUrl?url=$url`. This can be used for apps deployed
  /// on the web to avoid images not loading due to CORS.
  String? imageProxyUrl;

  /// [mapViewUrl] is used to create links to locations, for the "View" action
  /// of [Place] cards. The link is assembled in [GeoData].
  /// If not set, www.openstreetmap.org will be used.
  /// Note that the "Navigate to" action always uses a google maps url.
  String? mapViewUrl;

  /// [tileServer] is the server for map tiles. Used by [GeoData], when refreshing
  /// the image for liveLocation. If not set tile.openstreetmap.org will be used.
  String? tileServer;

  /// [geocodingServer] is the server used for reverse geocoding in [GeoData],
  /// when refreshing a liveLocation. If not set nominatim.openstreetmap.org
  /// will be used
  String? geocodingServer;

  SMLAppContext({
    this.confirmCallback,
    this.eventCallback,
    this.imageProxyUrl,
    this.mapViewUrl,
    this.tileServer,
    this.geocodingServer,
  });
}

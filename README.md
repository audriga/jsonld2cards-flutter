# jsonld2cards

Renders Markup as Cards.
`lib/card_rendering.dart` is where the actual card rendering happens.

Note that for LiveLocation card, on press on "refresh", API calls to a OpenStreetMap tile server and
a OpenStreetMap Nominatim server are being made.
The urls can be configured via the `globalAppContext` object.

## Example Projects
 * `example` is a complete example project that shows usage of all of the library's features.
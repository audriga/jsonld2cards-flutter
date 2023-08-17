# jsonld2cards

Renders Markup as Cards.
`lib/card_rendering.dart` is where the actual card rendering happens.
Read the comment above `renderCard(...)` in `lib/card_rendering.dart`, and the comment above `postUrl` in
`example/lib/Util/network.dart`.

`CardViewer` in `card_viewer.dart` downloads a json and renders the card~~s as a list~~.

## Example Projects
* `example_cardviewer_standalone` is an example web-only project that uses the `CardViewer` library-part to show a card based on an id.
  * **This is used as the fallback renderer** as specified in https://web.audriga.com/wiki/index.php/SML/Viewer
* `example` is a complete example project that shows usage of all of the library's features. 
  * Mainly `renderCard(...)`, but it also contains a floatingActionButton which will bring up a page containing the `CardViewer`.
* `example_embedding` showcases, how a flutter app can be embedded in a given HTML page, read out the page's Schema.org markup and display that markup 

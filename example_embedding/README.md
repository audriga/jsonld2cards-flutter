# example_embedding

Showcases embedded Cards for web.

Reading out the page's Schema.org markup and displaying that markup as a card.


Note for building: `web/index.php` adds jsonld to the DOM, so that the site itself can be recognized.
In oder for this to work
* Build the app as normal, e.g. `flutter build web --base-href /test/sml-web/`
* Copy `web/index.php` to `build/web/`
* In `build/web/` rename `index.html` to `flutter_index.html`
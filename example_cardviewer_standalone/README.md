# example_cardviewer_standalone

App who's entire purpose is to show the cardViewer.

Used as the fallback renderer for SML emails as specified in https://web.audriga.com/wiki/index.php/SML/Viewer

## Deploy

To deploy the app
* build the app using `flutter build web --base-href /test/sml-web/`
* The result will be in `build/web` folder
* Rename that folder to `sml-web` and upload it to the ftp file server, replacing the old version

To simply run it `flutter run -d chrome`
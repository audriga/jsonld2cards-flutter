library card_samples;

import 'package:flutter/foundation.dart';
import 'package:jsonld2cards/adaptive_multiple_cards.dart';
import 'package:jsonld2cards/card_rendering.dart';
import 'package:jsonld2cards/card_viewer.dart';
import 'package:jsonld2cards/open_card_viewer_dialog.dart';

import 'Util/network.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class CardSamples extends StatefulWidget {
  const CardSamples({Key? key, required this.handleBrightnessChange}) : super(key: key);

  static const String routeName = '/cardSamples';

  final void Function(ThemeMode useLightMode) handleBrightnessChange;

  static const String emailMarkupActionGoto =
      '{'
      '  "@context": "http://schema.org",'
      '  "@type": "EmailMessage",'
      '  "description": "Watch the Avengers movie online",'
      '  "potentialAction": {'
      '    "@type": "ViewAction",'
      '    "url": "https://watch-movies.com/?id=abc123",'
      '    "name": "Watch"'
      '  }'
      '}';


  static const String emailMarkupActionOneClick =
      '{'
      '  "@context": "http://schema.org",'
      '  "@type": "EmailMessage",'
      '  "potentialAction": {'
      '    "@type": "ConfirmAction",'
      '    "name": "Approve Expense",'
      '    "handler": {'
      '      "@type": "HttpActionHandler",'
      '      "url": "https://myexpenses.com/approve?expenseId=abc123"'
      '    }'
      '  },'
      '  "description": "Approval request for John\'s \$10.13 expense for office supplies"'
      '}';


  static const String emailMarkupReservationFlightBasic =
      '{'
      '  "@context": "http://schema.org",'
      '  "@type": "FlightReservation",'
      '  "reservationNumber": "RXJ34P",'
      '  "reservationStatus": "http://schema.org/Confirmed",'
      '  "underName": {'
      '    "@type": "Person",'
      '    "name": "Eva Green"'
      '  },'
      '  "reservationFor": {'
      '    "@type": "Flight",'
      '    "flightNumber": "110",'
      '    "airline": {'
      '      "@type": "Airline",'
      '      "name": "United",'
      '      "iataCode": "UA"'
      '    },'
      '    "departureAirport": {'
      '      "@type": "Airport",'
      '      "name": "San Francisco Airport",'
      '      "iataCode": "SFO"'
      '    },'
      '    "departureTime": "2024-03-04T20:15:00-08:00",'
      '    "arrivalAirport": {'
      '      "@type": "Airport",'
      '      "name": "John F. Kennedy International Airport",'
      '      "iataCode": "JFK"'
      '    },'
      '    "arrivalTime": "2024-03-05T06:30:00-05:00"'
      '  }'
      '}';


  static const String emailMarkupReservationFlight =
      '{'
      '  "@context": "http://schema.org",'
      '  "@type": "FlightReservation",'
      '  "reservationNumber": "RXJ34P",'
      '  "reservationStatus": "http://schema.org/Confirmed",'
      '  "underName": {'
      '    "@type": "Person",'
      '    "name": "Eva Green"'
      '  },'
      '  "reservationFor": {'
      '    "@type": "Flight",'
      '    "flightNumber": "110",'
      '    "airline": {'
      '      "@type": "Airline",'
      '      "name": "United",'
      '      "iataCode": "UA"'
      '    },'
      '    "departureAirport": {'
      '      "@type": "Airport",'
      '      "name": "San Francisco Airport",'
      '      "iataCode": "SFO"'
      '    },'
      '    "departureTime": "2024-03-04T20:15:00-08:00",'
      '    "arrivalAirport": {'
      '      "@type": "Airport",'
      '      "name": "John F. Kennedy International Airport",'
      '      "iataCode": "JFK"'
      '    },'
      '    "arrivalTime": "2024-03-05T06:30:00-05:00"'
      '  },'
      '  "checkinUrl": "http://united.com/onlinecheckin.html",'
      '  "potentialAction": {'
      '    "@type": "CheckInAction",'
      '    "target": "http://united.com/onlinecheckin.html"'
      '  }'
      '}';

  static const String musicAlbumMarkup =
  '''{
  "@context": "http://schema.googleapis.com/",
  "@type": "MusicAlbum",
  "@id": "https://open.spotify.com/album/4F1fUukNCGBD5YjDViOJtu",
  "url": "https://open.spotify.com/album/4F1fUukNCGBD5YjDViOJtu",
  "name": "Semantics",
  "description": "Listen to Semantics on Spotify. St. Emerald · Album · 2022 · 7 songs.",
  "datePublished": "2022-08-19",
  "potentialAction": {
    "@type": "ListenAction",
    "target": [
      {
        "@type": "EntryPoint",
        "urlTemplate": "https://open.spotify.com/album/4F1fUukNCGBD5YjDViOJtu?autoplay=true",
        "actionPlatform": [
          "http://schema.org/DesktopWebPlatform",
          "http://schema.org/IOSPlatform",
          "http://schema.googleapis.com/GoogleAudioCast",
          "http://schema.googleapis.com/GoogleVideoCast"
        ]
      },
      "android-app://com.spotify.music/spotify/album/4F1fUukNCGBD5YjDViOJtu/play"
    ],
    "expectsAcceptanceOf": {
      "@type": "Offer",
      "category": "free",
      "eligibleRegion": [
        {
          "@type": "Country",
          "name": "AD"
        },
        {
          "@type": "Country",
          "name": "ZW"
        }
      ]
    }
  }
}''';

  static const placeMarkup =
  '''{
  "@context": "https://schema.org",
  "@type": "Place",
  "geo": {
    "@type": "GeoCoordinates",
    "latitude": "40.75",
    "longitude": "-73.98"
  },
  "name": "Empire State Building"
}''';


  /*
  			{{ # departureDate }}
			<div>
				{{ departureDate }}
			</div>
			{{ / departureDate }}

						{{ # arrivalDate }}
			<div>
				{{ arrivalDate }}
			</div>
			{{ / arrivalDate }}
   */

  @override
  State<CardSamples> createState() => _CardSamplesState();
}

class _CardSamplesState extends State<CardSamples> {
  int _selectedIndex = 0;
  bool preview = false;
  bool topBar = true;
  bool showSource = false;

  late Map<String, dynamic> emailMarkupActionGoto;
  late Map<String, dynamic> emailMarkupActionOneClick;
  late Map<String, dynamic> emailMarkupReservationFlightBasic;
  late Map<String, dynamic> emailMarkupReservationFlight;
  late Map<String, dynamic> musicAlbumMarkup;
  late Map<String, dynamic> placeMarkup;
  late Future<List<dynamic>> assetMarkups;

  List<String> assetsToUse = [
    'assets/sampleMarkup/spotifyEnriched.json',
    'assets/sampleMarkup/musicSchool.json',
    'assets/sampleMarkup/promotab.json',
    'assets/sampleMarkup/spiegel.json',
    'assets/sampleMarkup/lemonde.json',
    'assets/sampleMarkup/organization_example1.json',
    'assets/sampleMarkup/live_location.json',
    'assets/sampleMarkup/invoice.json',
    'assets/sampleMarkup/order.json',
    'assets/sampleMarkup/parcel_delivery.json',
    'assets/sampleMarkup/array_6440.json',
    'assets/sampleMarkup/array.json',
  ];

  @override
  void initState() {
    super.initState();
    emailMarkupActionGoto = jsonDecode(CardSamples.emailMarkupActionGoto);
    emailMarkupActionOneClick = jsonDecode(CardSamples.emailMarkupActionOneClick);
    emailMarkupReservationFlightBasic = jsonDecode(CardSamples.emailMarkupReservationFlightBasic);
    emailMarkupReservationFlight = jsonDecode(CardSamples.emailMarkupReservationFlight);
    musicAlbumMarkup = jsonDecode(CardSamples.musicAlbumMarkup);
    placeMarkup = jsonDecode(CardSamples.placeMarkup);
    assetMarkups = loadMarkupsFromAssets();
  }

  Future<List<dynamic>> loadMarkupsFromAssets() async {
    List<dynamic> markups = [];


    Iterable<Future<String>> futureAssetStrings = assetsToUse.map((assetPath) => DefaultAssetBundle.of(context).loadString(assetPath));
    for (Future<String> futureAssetString in futureAssetStrings) {
      String assetString = await futureAssetString;
      markups.add(jsonDecode(assetString));
    }
    return markups;
  }

  List<Widget> itemBuilder(List<dynamic> markups) {
    List<Widget> widgets = [];
    var assetNameIter = assetsToUse.iterator;
    for (var markup in markups){
      if (showSource && assetNameIter.moveNext()) widgets.add(Text(assetNameIter.current));
      var card = renderCardOrErrorCard(markup, preview: preview, topBar: topBar);
      widgets.add(card);
    }
    if (showSource) widgets.add(const Text('End of file based markups'));
    return widgets;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isBright = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Templated Cards"),
        actions: [
          IconButton(
            onPressed: (){
              widget.handleBrightnessChange(isBright ? ThemeMode.dark : ThemeMode.light);
              },
            icon: Icon(isBright ? Icons.dark_mode : Icons.light_mode),
          ),
          IconButton(
            onPressed: (){widget.handleBrightnessChange(ThemeMode.system);},
            icon: const Icon(Icons.brightness_auto),
          ),
        ],
      ),
      body: FutureBuilder(
        future: assetMarkups,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch(_selectedIndex) {
              case 0: return ListView(
                children: [
                  ...itemBuilder(snapshot.requireData),
                  renderCardOrErrorCard(emailMarkupActionGoto, preview: preview, topBar: topBar),
                  renderCardOrErrorCard(emailMarkupActionOneClick, preview: preview, topBar: topBar),
                  renderCardOrErrorCard(emailMarkupReservationFlightBasic, preview: preview, topBar: topBar),
                  renderCardOrErrorCard(emailMarkupReservationFlight, preview: preview, topBar: topBar),
                  renderCardOrErrorCard(musicAlbumMarkup, preview: preview, topBar: topBar),
                  renderCardOrErrorCard(placeMarkup, preview: preview, topBar: topBar),
                ],
              );
              case 1: return itemBuilder(snapshot.requireData)[1];
              case 2: return AdaptiveMultipleCards(
                title: 'Adaptive Demo',
                markups: snapshot.requireData[assetsToUse.indexOf('assets/sampleMarkup/array_6440.json')],
                postFunction: postUrl,
              );
              default: return const Placeholder();
            }
          }  else if (snapshot.hasError) {
            return FutureBuilderError(error: snapshot.error,);
          } else {
            return const SizedBox.square(
              dimension: 40,
              child: CircularProgressIndicator(),
            );
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.download),
        onPressed: () => cardViewerDialog(context),

      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Multiple Cards',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Single Card',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_tree),
            label: 'Adaptive View'
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      persistentFooterButtons: [
        TextButton(
            onPressed: (){setState(() {showSource = !showSource;});},
            child: Text('Show source: ${showSource ? 'on' : 'off'}')
        ),
        TextButton(
            onPressed: (){setState(() {preview = !preview;});},
            child: Text('Preview mode: ${preview ? 'on' : 'off'}')
        ),
        TextButton(
            onPressed: (){setState(() {topBar = !topBar;});},
            child: Text('Top bar mode: ${topBar ? 'on' : 'off'}')
        ),
      ],
    );
  }

}

Widget renderCardOrErrorCard(
  dynamic markup, {
  bool preview = false,
  bool topBar = false,
}) {
  try {
    var card = mustRenderCard(markup,
        postFunction: postUrl, preview: preview, topBar: topBar);
    return card;
  } catch (e, st) {
    return Card(
      surfaceTintColor: Colors.redAccent,
      child: ListTile(
        leading: const Icon(Icons.error),
        title: const Text('Error rendering card'),
        subtitle: Text(e.toString()),
        onTap: () {
          if (kDebugMode) {
            print(st);
          }
        },
      ),
    );
  }
}

class FutureBuilderError extends StatelessWidget {
  final Object? error;

  const FutureBuilderError({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 60,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text('Error: $error'),
        ),
      ],
    );
  }
}

void cardViewerDialog(BuildContext context) {
  Future<String?> futureParameters = showDialog<String?>(
    context: context,
    builder: (BuildContext context) => OpenCardViewerDialog(),
  );

  futureParameters.then((cardId) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => CardViewer(cardId: cardId, postFunction: postUrl),
    ));
  });
}
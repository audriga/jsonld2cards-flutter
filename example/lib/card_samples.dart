library card_samples;

import 'package:markup_cards/card_rendering.dart';
import 'package:markup_cards/card_viewer.dart';
import 'package:markup_cards/open_card_viewer_dialog.dart';

import 'Util/network.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class CardSamples extends StatefulWidget {
  const CardSamples({Key? key}) : super(key: key);

  static const String routeName = '/cardSamples';

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
  late Map<String, dynamic> emailMarkupActionGoto;
  late Map<String, dynamic> emailMarkupActionOneClick;
  late Map<String, dynamic> emailMarkupReservationFlightBasic;
  late Map<String, dynamic> emailMarkupReservationFlight;
  late Map<String, dynamic> musicAlbumMarkup;
  late Map<String, dynamic> placeMarkup;
  late Future<List<dynamic>> assetMarkups;

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
    final musicSchoolString = DefaultAssetBundle.of(context).loadString('assets/sampleMarkup/musicSchool.json');
    final promotabString = DefaultAssetBundle.of(context).loadString('assets/sampleMarkup/promotab.json');
    final musicSchoolMarkup = jsonDecode(await musicSchoolString);
    final promotabMarkup = jsonDecode(await promotabString);
    markups.add(musicSchoolMarkup);
    markups.add(promotabMarkup);
    return markups;
  }

  List<Widget> itemBuilder(List<dynamic> markups) {
    List<Widget> widgets = [];
    for (var markup in markups){
      var card = renderCard(markup, postFunction: postUrl);
      if (card != null) {
        widgets.add(card);
      }
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Templated Cards"),
      ),
      body: FutureBuilder(
        future: assetMarkups,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: [
                renderCard(emailMarkupActionGoto, postFunction: postUrl) ?? const Placeholder(),
                renderCard(emailMarkupActionOneClick, postFunction: postUrl) ?? const Placeholder(),
                renderCard(emailMarkupReservationFlightBasic, postFunction: postUrl) ?? const Placeholder(),
                renderCard(emailMarkupReservationFlight, postFunction: postUrl) ?? const Placeholder(),
                renderCard(musicAlbumMarkup, postFunction: postUrl) ?? const Placeholder(),
                renderCard(placeMarkup, postFunction: postUrl) ?? const Placeholder(),
                ...itemBuilder(snapshot.requireData)
              ],
            );
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
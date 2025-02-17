library;

import 'package:flutter/foundation.dart';
import 'package:jsonld2cards/adaptive_multiple_cards.dart';
import 'package:jsonld2cards/card_data.dart';
import 'package:jsonld2cards/card_rendering.dart';

import 'util/network.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class CardSamples extends StatefulWidget {
  const CardSamples({super.key, required this.handleBrightnessChange});

  static const String routeName = '/cardSamples';

  final void Function(ThemeMode useLightMode) handleBrightnessChange;

  static const placeMarkup = '''{
  "@context": "https://schema.org",
  "@type": "Place",
  "geo": {
    "@type": "GeoCoordinates",
    "latitude": "40.75",
    "longitude": "-73.98"
  },
  "name": "Empire State Building"
}''';

  @override
  State<CardSamples> createState() => _CardSamplesState();
}

class _CardSamplesState extends State<CardSamples> {
  int _selectedScreenIndex = 0;
  bool preview = false;
  bool topBar = true;
  bool showSource = false;
  late int _selectedAssetIndex;

  late Map<String, dynamic> placeMarkup;
  late Future<List<dynamic>> assetMarkups;

  List<String> assetsToUse = [
    // 'assets/sampleMarkup/zeit_homepage.json', //todo look into fix for this
    'assets/sampleMarkup/invoice_complex.json',
    'assets/sampleMarkup/simplePollUnfilled.json',
    'assets/sampleMarkup/simplePollUpdate2Answers.json',
    'assets/sampleMarkup/multi_media_news_article.json',
    'assets/sampleMarkup/invoice_contract.json',
    'assets/sampleMarkup/invoice_order.json',
    'assets/sampleMarkup/event_basic.json',
    'assets/sampleMarkup/event_complex.json',
    'assets/sampleMarkup/discountoffer_variations/discountoffer_description_discountcode_start_end.json',
    'assets/sampleMarkup/discountoffer_variations/discountoffer_description.json',
    'assets/sampleMarkup/discountoffer_variations/discountoffer_discountcode.json',
    'assets/sampleMarkup/discountoffer_variations/discountoffer_start.json',
    'assets/sampleMarkup/discountoffer_variations/discountoffer_end.json',
    'assets/sampleMarkup/discountoffer_variations/discountoffer_empty.json',
    'assets/sampleMarkup/promotab_variations/promotab_web_de.json',
    'assets/sampleMarkup/promotab.json',
    'assets/sampleMarkup/promotab_variations/promotab_email_discount_promo.json',
    'assets/sampleMarkup/promotab_variations/promotab_discount_promo.json',
    'assets/sampleMarkup/promotab_variations/promotab_only_discount.json',
    'assets/sampleMarkup/promotab_variations/promotab_only_promo.json',
    'assets/sampleMarkup/bakeries.json',
    'assets/sampleMarkup/person.json',
    'assets/sampleMarkup/clipboard_6714.json',
    'assets/sampleMarkup/action.json',
    'assets/sampleMarkup/arrayBlogPosting.json',
    'assets/sampleMarkup/arrayBlogPosting2.json',
    'assets/sampleMarkup/ikea.json',
    'assets/sampleMarkup/blogPosting.json', // todo fix rendering of this
    'assets/sampleMarkup/spiegel_homepage.json',
    'assets/sampleMarkup/spotifyEnriched.json',
    'assets/sampleMarkup/musicSchool.json',
    'assets/sampleMarkup/spiegel.json',
    'assets/sampleMarkup/lemonde.json',
    'assets/sampleMarkup/organization_example1.json',
    'assets/sampleMarkup/live_location.json',
    'assets/sampleMarkup/invoice.json',
    'assets/sampleMarkup/order.json',
    'assets/sampleMarkup/parcel_delivery.json',
    'assets/sampleMarkup/array_6440.json',
    'assets/sampleMarkup/array.json',
    'assets/sampleMarkup/flight_multi_passenger.json',
    'assets/sampleMarkup/flight_multi_segment.json',
    'assets/sampleMarkup/zeit.json',
    'assets/sampleMarkup/emailMarkupActionGoto.json',
    'assets/sampleMarkup/emailMarkupActionOneClick.json',
    'assets/sampleMarkup/emailMarkupReservationFlightBasic.json',
    'assets/sampleMarkup/emailMarkupReservationFlight.json',
    'assets/sampleMarkup/musicAlbum.json',
  ];

  List<DropdownMenuItem<int>> get assetDropdownItems {
    return List<DropdownMenuItem<int>>.generate(assetsToUse.length, (index) {
      return DropdownMenuItem<int>(
          value: index, child: Text(assetsToUse[index]));
    });
  }

  @override
  void initState() {
    super.initState();
    placeMarkup = jsonDecode(CardSamples.placeMarkup);
    assetMarkups = loadMarkupsFromAssets();
    _selectedAssetIndex =
        assetsToUse.indexOf('assets/sampleMarkup/array_6440.json');
  }

  Future<List<dynamic>> loadMarkupsFromAssets() async {
    List<dynamic> markups = [];

    Iterable<Future<String>> futureAssetStrings = assetsToUse.map(
        (assetPath) => DefaultAssetBundle.of(context).loadString(assetPath));
    for (Future<String> futureAssetString in futureAssetStrings) {
      String assetString = await futureAssetString;
      markups.add(jsonDecode(assetString));
    }
    return markups;
  }

  List<Widget> itemBuilder(List<dynamic> markups) {
    List<Widget> widgets = [];
    var assetNameIter = assetsToUse.iterator;
    for (var markup in markups) {
      // Add text widgets on the first screen showing the source of file based markups
      if (showSource && _selectedScreenIndex == 0 && assetNameIter.moveNext()) {
        widgets.add(Text(assetNameIter.current));
      }
      var card =
          renderCardOrErrorCard(markup, preview: preview, topBar: topBar);
      widgets.add(card);
    }
    if (showSource && _selectedScreenIndex == 0) {
      widgets.add(const Text('End of file based markups'));
    }
    return widgets;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedScreenIndex = index;
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
            onPressed: () {
              widget.handleBrightnessChange(
                  isBright ? ThemeMode.dark : ThemeMode.light);
            },
            icon: Icon(isBright ? Icons.dark_mode : Icons.light_mode),
          ),
          IconButton(
            onPressed: () {
              widget.handleBrightnessChange(ThemeMode.system);
            },
            icon: const Icon(Icons.brightness_auto),
          ),
        ],
      ),
      body: FutureBuilder(
          future: assetMarkups,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (_selectedScreenIndex) {
                case 0:
                  return ListView(
                    children: [
                      ...itemBuilder(snapshot.requireData),
                      renderCardOrErrorCard(placeMarkup,
                          preview: preview, topBar: topBar),
                    ],
                  );
                case 1:
                  return itemBuilder(snapshot.requireData)[_selectedAssetIndex];
                case 2:
                  return AdaptiveMultipleCards(
                    title: 'Adaptive Demo',
                    markups: snapshot.requireData[_selectedAssetIndex],
                    postFunction: postUrl,
                  );
                default:
                  return const Placeholder();
              }
            } else if (snapshot.hasError) {
              return FutureBuilderError(
                error: snapshot.error,
              );
            } else {
              return const SizedBox.square(
                dimension: 40,
                child: CircularProgressIndicator(),
              );
            }
          }),
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
              icon: Icon(Icons.account_tree), label: 'Adaptive View')
        ],
        currentIndex: _selectedScreenIndex,
        onTap: _onItemTapped,
      ),
      persistentFooterButtons: [
        if ([0, 3].contains(_selectedScreenIndex))
          TextButton(
              onPressed: () {
                setState(() {
                  showSource = !showSource;
                });
              },
              child: Text('Show source: ${showSource ? 'on' : 'off'}')),
        TextButton(
            onPressed: () {
              setState(() {
                preview = !preview;
              });
            },
            child: Text('Preview mode: ${preview ? 'on' : 'off'}')),
        if (_selectedScreenIndex < 2)
          TextButton(
              onPressed: () {
                setState(() {
                  topBar = !topBar;
                });
              },
              child: Text('Top bar mode: ${topBar ? 'on' : 'off'}')),
        if (_selectedScreenIndex > 0 && _selectedScreenIndex < 3)
          DropdownButton(
            value: _selectedAssetIndex,
            items: assetDropdownItems,
            onChanged: (newIndex) => setState(() {
              _selectedAssetIndex = newIndex!;
            }),
          )
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
    var card = mustRenderCardFromCardData(CardData(markup,
        postFunction: postUrl, preview: preview, topBar: topBar));
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

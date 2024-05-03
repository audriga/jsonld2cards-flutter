library card_samples;

import 'package:jsonld2cards/card_rendering.dart';
import 'package:jsonld2cards/card_viewer.dart';
import 'package:jsonld2cards/open_card_viewer_dialog.dart';

import 'Util/network.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:html2jsonld_dart/html2jsonld_dart.dart' as ht2j;
// Web embedding is web only :)
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class CardSamples extends StatefulWidget {
  const CardSamples({super.key});



  @override
  State<CardSamples> createState() => _CardSamplesState();
}

class _CardSamplesState extends State<CardSamples> {

  late Future<List<dynamic>> assetMarkups;

  @override
  void initState() {
    super.initState();
    assetMarkups = loadMarkupsFromAssets();
  }

  Future<List<dynamic>> loadMarkupsFromAssets() async {
    List<dynamic> markups = [];
    // todo for now manually fixed compilation error in jsonLdFromHtml...  need to request upstream update
    ht2j.SchemaOrgExtractor schemaOrg = ht2j.SchemaOrgExtractor();
    Future<Object?> a = schemaOrg.extractJsonLdFromHtml(html.document.head?.innerHtml?? '');
    markups.insert(0, jsonDecode((await a).toString()));
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
      body: FutureBuilder(
        future: assetMarkups,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: [
                ...itemBuilder(snapshot.requireData),
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
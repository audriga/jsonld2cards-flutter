import 'package:jsonld2cards/Cards/BuildingBlocks/potential_actions.dart';
import 'package:jsonld2cards/adaptive_multiple_cards.dart';
import 'package:jsonld2cards/Util/conversion.dart';
import 'package:flutter/material.dart';
import 'package:html2jsonld_dart/html2jsonld_dart.dart' as ht2j;
import 'package:jsonld2cards/card_rendering.dart';
import 'dart:developer' as developer;

import 'package:jsonld2cards/card_viewer.dart';



class ExternalCardViewer extends StatefulWidget {
  const ExternalCardViewer({
    super.key,
    this.source,
    this.single = false,
    this.audrigaAuthority = 'www.audriga.eu',
    this.phpPathBase = '/test/data/',
    required this.postFunction,
  });

  final String audrigaAuthority;
  final String phpPathBase;
  final String? source;
  /// If set, json should be rendered as a single card.
  /// If false, will render it using  [AdaptiveMultipleCards] feed-view
  final bool single;
  final PostFunction postFunction;

  static const String routeName = '/external';

  @override
  State<ExternalCardViewer> createState() => _ExternalCardViewerState();
}

class _ExternalCardViewerState extends State<ExternalCardViewer> {
  String title = "Demo";
  List<Map<String, dynamic>> formContent = [];
  late Future<String?> futureMarkup;

  @override
  void initState() {
    super.initState();
    futureMarkup = fetchMarkup();
  }

  @override
  Widget build(BuildContext context) {
      return FutureCards(
        title: title,
        futureMarkup: futureMarkup,
        single: widget.single,
        postFunction: widget.postFunction,
    );

  }

  Future<String?> fetchMarkup() async {
    Uri sourceUri;
    if (widget.source != null) {
      sourceUri = Uri.https(
        widget.audrigaAuthority,
        '${widget.phpPathBase}proxyHtml.php',
        {'url': widget.source},
      );
    } else {
      // No markup to fetch given
      return null;
    }

    try {
      // todo maybe use other library function that gives back more
      String? extractedSchema = await ht2j.SchemaOrg().extractJsonLdFromUrl(sourceUri.toString());
      // http.Response response = await http.get(sourceUri);
      developer.log(
        'Requested markup at $sourceUri and got schema ($extractedSchema)',
        name: 'jsonld2cards.external_viewer',
      );
      if (extractedSchema == null) {
        return Future.error('Schema empty');
      }
      return extractedSchema;

    } on Error catch (e, st) {
      developer.log(
        'Error requesting markup $e',
        name: 'jsonld2cards.external_viewer',
        error: e,
        stackTrace: st,
      );
      return Future.error(e, st);
    }
  }
}

class FutureCards extends StatelessWidget {

  const FutureCards({
    super.key,
    this.title, required this.futureMarkup, this.single = false, required this.postFunction,
  });

  final String? title;
  final Future<String?> futureMarkup;
  final bool single;
  final PostFunction postFunction;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureMarkup,
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.hasData) {
          String? markupString = snapshot.data;
          if (markupString != null && markupString.isNotEmpty) {
            var decodedMarkup = tryDecode(markupString);
            if (single) {
              return singleCardDisplay(decodedMarkup);
            }
            if (decodedMarkup is List<dynamic>) {
              return AdaptiveMultipleCards(title: title, markups: decodedMarkup, postFunction: postFunction);
            } else if (decodedMarkup is Map<String, dynamic>) {
              return AdaptiveMultipleCards(title: title, markups: [decodedMarkup], postFunction: postFunction);
            }
            return const Text('Card has unexpected format');
          } else {
            return const Text('Empty Response…');
          }
        } else if (snapshot.hasError) {
          var children = <Widget>[
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Error: ${snapshot.error}'),
            ),
          ];
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        } else {
          return const SizedBox.square(
            dimension: 40,
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  LayoutBuilder singleCardDisplay(decodedMarkup) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return constraints.maxWidth > 400
            ? Center(
          child: ClipRect(
            child: SizedBox(
              width: 400,
              child: renderCard(decodedMarkup, postFunction: postFunction) ??
                displayErrorMessage('Could not load card')
            ),
          ),
        )
            : renderCard(decodedMarkup, postFunction: postFunction) ?? displayErrorMessage('Could not load card');
      },
    );
  }
}



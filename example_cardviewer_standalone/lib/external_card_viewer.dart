import 'dart:convert';

import 'package:example_cardviewer_standalone/single_card_display.dart';
import 'package:http/http.dart' as http;
import 'package:jsonld2cards/Cards/BuildingBlocks/potential_actions.dart';
import 'package:jsonld2cards/adaptive_multiple_cards.dart';
import 'package:jsonld2cards/Util/conversion.dart';
import 'package:flutter/material.dart';
import 'package:html2jsonld_dart/html2jsonld_full.dart' as ht2j;
import 'dart:developer' as developer;

class ExternalCardViewer extends StatefulWidget {
  const ExternalCardViewer({
    super.key,
    this.source,
    this.single = false,
    this.audrigaAuthority = 'www.audriga.eu',
    this.phpPathBase = '/test/data/',
    required this.postFunction,
    this.visualDebug = false,
  });

  final String audrigaAuthority;
  final String phpPathBase;
  final String? source;

  /// If set, json should be rendered as a single card.
  /// If false, will render it using  [AdaptiveMultipleCards] feed-view
  final bool single;
  final PostFunction postFunction;
  final bool visualDebug;

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
      visualDebug: widget.visualDebug,
      sourceUri: Uri.https(
        widget.audrigaAuthority,
        '${widget.phpPathBase}proxyHtml.php',
        {'url': widget.source},
      ),
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
      String? extractedSchema =
          await ht2j.SchemaOrgExtractor().extractJsonLdFromUrl(sourceUri.toString());
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
    this.title,
    required this.futureMarkup,
    this.single = false,
    required this.postFunction,
    this.visualDebug = false,
    this.sourceUri
  });

  final String? title;
  final Future<String?> futureMarkup;
  final bool single;
  final PostFunction postFunction;
  final bool visualDebug;
  /// Just for debugging purposes
  final Uri? sourceUri;

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: futureMarkup,
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.hasData) {
          String? markupString = snapshot.data;
          if (markupString != null && markupString.isNotEmpty) {
            var decodedMarkup = tryDecode(markupString);
            var mainWidget = singleCardOrFeed(decodedMarkup);
            JsonEncoder encoder = const JsonEncoder.withIndent('  ');
            String encodedJson = encoder.convert(decodedMarkup);
            if (visualDebug) {
              return Scaffold(
                body: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                    return Row(
                      children: [
                        SizedBox(
                            width: constraints.maxWidth /2 - 20,
                            child: mainWidget
                        ),
                        const Divider(),
                        SizedBox(
                          width: constraints.maxWidth /2 - 20,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SelectableText(encodedJson ),
                          ),
                        ),
                      ],
                    );
                  }
                ),
              );
            } else {
              return mainWidget;
            }
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
          if (visualDebug && sourceUri != null) {
            children.add(DebugRequest(sourceUri: sourceUri!));
          }
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
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

  Widget singleCardOrFeed(decodedMarkup) {
    if (single) {
      return Scaffold(
        body: SingleCardDisplay(
          decodedMarkup: decodedMarkup,
          postFunction: postFunction,
        ),
      );
    }
    if (decodedMarkup is List<dynamic>) {
      return AdaptiveMultipleCards(
          title: title, markups: decodedMarkup, postFunction: postFunction);
    } else if (decodedMarkup is Map<String, dynamic>) {
      return AdaptiveMultipleCards(
          title: title, markups: [decodedMarkup], postFunction: postFunction);
    }
    return const Text('Card has unexpected format');
  }
}

class DebugRequest extends StatefulWidget {
  const DebugRequest({super.key, required this.sourceUri});

  final Uri sourceUri;

  @override
  State<DebugRequest> createState() => _DebugRequestState();
}

class _DebugRequestState extends State<DebugRequest> {
  String? result = 'No request yet';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            TextButton(onPressed: () async {
              http.Response response = await http.get(widget.sourceUri);
              developer.log(
                'Requested markup at $widget.sourceUri and got response (${response.statusCode}) ${response.body}',
                name: 'jsonld2cards.card_viewer',
              );
              setState(() {
                result = 'response.statusCode: ${response.statusCode}\n'
                    'response.body:\n${response.body}';
              });
            }, child: const Text('http.get')),
            TextButton(onPressed: () async {
              String? response = await ht2j.SchemaOrgExtractor().extractSchemaOrgAggregateFromURL(widget.sourceUri.toString());

              setState(() {
                result = response;
              });
            }, child: const Text('SchemaOrg().extractSchemaOrgAggregateFromURL')),
          ],
        ),
        const Divider(),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SelectableText(result ?? 'null'),
        )
      ],
    );
  }
}

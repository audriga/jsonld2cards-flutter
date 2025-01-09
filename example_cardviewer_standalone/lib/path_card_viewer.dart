import 'package:example_cardviewer_standalone/single_card_display.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/potential_actions.dart';
import 'package:jsonld2cards/adaptive_multiple_cards.dart';
import 'package:jsonld2cards/Util/conversion.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

final log = Logger('jsonld2cardsExample.cardViewer.path_card_viewer');

class PathCardViewer extends StatefulWidget {
  const PathCardViewer({
    super.key,
    this.cardPath,
    this.single = false,
    this.liveLocationAuthority = 'www.audriga.eu',
    this.liveLocationPathBase = '/test/data/',
    required this.postFunction,
  });

  final String liveLocationAuthority;
  final String liveLocationPathBase;
  final String? cardPath;

  /// If set, json should be rendered as a single card.
  /// If false, will render it using  [AdaptiveMultipleCards] feed-view
  final bool single;
  final PostFunction postFunction;

  static const String routeName = '/card_getter';

  @override
  State<PathCardViewer> createState() => _PathCardViewerState();
}

class _PathCardViewerState extends State<PathCardViewer> {
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
    if (widget.cardPath != null) {
      sourceUri = Uri.https(
        widget.liveLocationAuthority,
        '${widget.liveLocationPathBase}pathBased.php',
        {'path': widget.cardPath},
      );
    } else {
      // No markup to fetch given
      return null;
    }

    try {
      http.Response response = await http.get(sourceUri);
      log.info(
        'Requested markup at $sourceUri and got response (${response.statusCode}) ${response.body}',
      );
      if (response.statusCode >= 400) {
        return Future.error(
            'Server responded with status code ${response.statusCode}');
      }
      return response.body;
    } on Error catch (e, st) {
      log.warning('Error requesting markup', e, st);
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
  });

  final String? title;
  final Future<String?> futureMarkup;
  final bool single;
  final Function(Uri uriToPost, {dynamic dataToPost, String successMessage})
      postFunction;

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
              return SingleCardDisplay(
                decodedMarkup: decodedMarkup,
                postFunction: postFunction,
              );
            }
            if (decodedMarkup is List<dynamic>) {
              return AdaptiveMultipleCards(
                  title: title,
                  markups: decodedMarkup,
                  postFunction: postFunction);
            } else if (decodedMarkup is Map<String, dynamic>) {
              return AdaptiveMultipleCards(
                  title: title,
                  markups: [decodedMarkup],
                  postFunction: postFunction);
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
}

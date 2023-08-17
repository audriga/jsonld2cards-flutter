import 'package:jsonld2cards/Cards/BuildingBlocks/potential_actions.dart';
import 'package:jsonld2cards/adaptive_multiple_cards.dart';
import 'package:jsonld2cards/Util/conversion.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;



class PathCardViewer extends StatefulWidget {
  const PathCardViewer({
    super.key,
    this.cardPath,
    this.liveLocationAuthority = 'www.audriga.eu',
    this.liveLocationPathBase = '/test/data/',
    required this.postFunction,
  });

  final String liveLocationAuthority;
  final String liveLocationPathBase;
  final String? cardPath;
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
      developer.log(
        'Requested markup at $sourceUri and got response (${response.statusCode}) ${response.body}',
        name: 'jsonld2cards.card_viewer',
      );
      if (response.statusCode >= 400) {
        return Future.error('Server responded with status code ${response.statusCode}');
      }
      return response.body;

    } on Error catch (e, st) {
      developer.log(
        'Error requesting markup $e',
        name: 'jsonld2cards.card_viewer',
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
    this.title, required this.futureMarkup, required this.postFunction,
  });

  final String? title;
  final Future<String?> futureMarkup;
  final Function(Uri uriToPost, {dynamic dataToPost, String successMessage}) postFunction;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureMarkup,
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.hasData) {
          String? markupString = snapshot.data;
          if (markupString != null && markupString.isNotEmpty) {
            var decodedMarkup = tryDecode(markupString);
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
}



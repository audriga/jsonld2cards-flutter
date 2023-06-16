library card_viewer;

import 'card_rendering.dart';
import 'Util/conversion.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

// import '../Common/constants.dart';

/// Displays a single card or list of cards, based on the json-ld markup returned
/// by the http resource (called in fetchMarkup)
class CardViewer extends StatefulWidget {
  const CardViewer({
    super.key,
    this.cardId,
    this.liveLocationAuthority = 'www.audriga.eu',
    this.liveLocationPathBase = '/test/data/',
    this.maxWidth = 480,
    required this.postFunction,
  });

  final double maxWidth;
  final String liveLocationAuthority;
  final String liveLocationPathBase;
  final String? cardId;
  final Function(Uri uriToPost, {dynamic dataToPost, String successMessage}) postFunction;

  static const String routeName = '/cardViewer';

  @override
  State<CardViewer> createState() => _CardViewerState();
}

class _CardViewerState extends State<CardViewer> {
  String title = "Card Viewer";
  List<Map<String, dynamic>> formContent = [];
  late Future<String?> futureMarkup;

  @override
  void initState() {
    super.initState();
    futureMarkup = fetchMarkup();
  }

  // todo get arguments of modal route (Minor/ nice to have, maybe add at some point)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return constraints.maxWidth > widget.maxWidth
              ? Center(
                  child: ClipRect(
                    child: SizedBox(
                      width: widget.maxWidth,
                      child: FuturePreviews(futureMarkup: futureMarkup, postFunction: widget.postFunction),
                    ),
                  ),
                )
              : FuturePreviews(futureMarkup: futureMarkup, postFunction: widget.postFunction);
        },
      ),
    );
  }

  Future<String?> fetchMarkup() async {
    var sourceUri = Uri.https(
      widget.liveLocationAuthority,
      '${widget.liveLocationPathBase}${widget.cardId}.json',
    );
    return await http.get(sourceUri).then<String?>((http.Response response) {
      developer.log(
        'Requested markup at $sourceUri and got response (${response.statusCode}) ${response.body}',
        name: 'jsonld2cards.card_viewer',
      );
      return response.body;
    }).onError((error, stackTrace) {
      developer.log(
        'Error requesting markup $error',
        name: 'jsonld2cards.geo_data',
        error: error,
      );
      return null;
    });
  }
}

class FuturePreviews extends StatelessWidget {
  const FuturePreviews({
    super.key,
    required this.futureMarkup, required this.postFunction,
  });

  final Future<String?> futureMarkup;
  final Function(Uri uriToPost, {dynamic dataToPost, String successMessage}) postFunction;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureMarkup,
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.hasData) {
          String? markupString = snapshot.data;
          if (markupString != null) {
            var decodedMarkup = tryDecode(markupString);
            // if (decodedMarkup is List<Map<String, dynamic>>) {
            /// If we have multiple markups, this branch renders them individually
            /// and display them in a list.
            /// Commented-out for now as we want to let renderCard handle
            /// the List directly. (So that it can render promoCards).
            //   return ListView.builder(
            //     //shrinkWrap: true,
            //     itemCount: decodedMarkup.length * 2,
            //     padding: const EdgeInsets.all(16.0),
            //     itemBuilder: (context, i) {
            //       if (i.isOdd) return const Divider();
            //       final index = i ~/ 2;
            //       return renderCard(decodedMarkup[index], postFunction: postFunction);
            //     },
            //   );
            // } else
              if (decodedMarkup is List<Map<String, dynamic>> || decodedMarkup is Map<String, dynamic>) {
              return renderCard(decodedMarkup, postFunction: postFunction) ??
                  const Text('Could not load card');
              // todo this is an error case, so treat it like the other error cases too/ give more info
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
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
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

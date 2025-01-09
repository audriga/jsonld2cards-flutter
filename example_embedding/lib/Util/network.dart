library;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import 'globals.dart';

final log = Logger('jsonld2cardsExample.embedding.network');

/// Posts given data to given URI, and shows a success message in snackbar on success
/// This is copied over from SMLApp, where it is also used for FormRendering Purposes.
/// This should not be included in the library itself because `snackBarKey`
/// is the Global Key for the ScaffoldMessengerState of which there should only be one per app
/// Basically the root problem is that in order to display some feedback to the user,
/// after the (async) post we need such a `GlobalKey<ScaffoldMessengerState>`
///
/// Making the caller supply a function like this one solves this problem, but I'm not
/// sure if it is the nicest solution to this problem.
void postUrl(Uri uriToPost,
    {String successMessage = 'Sent data', dynamic dataToPost}) {
  try {
    Future<http.Response> resp;
    if (dataToPost == null) {
      resp = http.post(
        uriToPost,
      );
    } else {
      var encodedPostData = jsonEncode(dataToPost);
      resp = http.post(
        uriToPost,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: encodedPostData,
      );
    }

    log.info('Sent post request');
    resp.then((value) => {
          log.info('Received response${value.body}'),
        });
    snackBarKey.currentState?.showSnackBar(SnackBar(
      content: Text(successMessage),
    ));
  } on Error catch (e) {
    log.warning('Received error posting', e);
    snackBarKey.currentState?.showSnackBar(const SnackBar(
      content: Text('Error sending content to server'),
    ));
  }
}

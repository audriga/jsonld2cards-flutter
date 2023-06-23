library default_markup_card;

import 'package:jsonld2cards/Cards/uri_image.dart';
import 'potential_actions.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:developer' as developer;


class DefaultMarkupCard extends StatelessWidget {


  const DefaultMarkupCard({
    super.key, required this.markup, required this.postFunction,
  });

  final Map<String, dynamic> markup;
  final Function(Uri uriToPost, {dynamic dataToPost, String successMessage}) postFunction;

  @override
  Widget build(BuildContext context) {

    // Properties the Card might have
    var url = markup['url'];
    String? name = markup['name'];
    String? description = markup['description'];
    var image  = markup['image'];
    var potentialAction = markup['potentialAction'];

    // Setting title and subtitle, depending on available information
    String? titleText;
    String? subtitleText;
    if (name != null) {
      titleText = name;
      if (description != null) {
        subtitleText = description;
      }
    }  else if (description != null) {
      titleText = description;
    }

    // Look for images in markup
    Widget? leadingImage;
    if (image != null) {
      try {
        if (image is List<dynamic>) {
          // For array of URLs, unconventional, but used by zeit
          leadingImage = UriImage(content: image.first, fit: BoxFit.scaleDown,);
        } else if (image is Map<String, dynamic>) {
          // image is an ImageObject (https://schema.org/ImageObject)
          var contentUrl = image['contentUrl'] ?? image['url'];
          leadingImage = UriImage(content: contentUrl, fit: BoxFit.scaleDown,);
        } else {
          // Probably URL, so flutter type of String or URI
          leadingImage = UriImage(content: image, fit: BoxFit.scaleDown,);
        }
      } on FormatException catch (_) {
        // Tried giving something that isn't a uri or can't be parsed to a uri to UriImage.
      }
    }

    var cardContents = <Widget>[
      ListTile(
        leading: leadingImage,
        title: titleText != null ? Text(titleText) : null,
        subtitle: subtitleText != null ? Text(subtitleText) : null,
      ),
    ];

    // Showing Buttons for Potential Actions
    if (potentialAction != null) {
      cardContents.add(PotentialActionRow(
        potentialAction: potentialAction,
        postFunction: postFunction,));
    }

    // Adding a row with a view button if there was a URL
    if (url != null) {
      Map<String, dynamic> viewUrlActionMarkup = {
        "@type": "ViewAction",
        "url": url,
        "name": "View"
      };
      cardContents.add(
          PotentialActionRow(
            potentialAction: viewUrlActionMarkup,
            postFunction: postFunction,
          ),
      );
    }


    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: cardContents,
      ),
    );
  }

  Future<String?> getImageSource(Uri? uri) async {
    if (uri == null) return null;
    http.Response response =  await http.get(uri);
    var parsedResponse = parse(response.body);
    var head = parsedResponse.head;
    if (head != null) {
      var metaTags = head.getElementsByTagName('meta');
      var imageUrls = metaTags.where((script) => script.attributes['name'] == 'twitter:image');
      if (imageUrls.length > 1) {
        developer.log(
          'Got more image urls than expected:\n$imageUrls',
          name: 'jsonld2cards.card',
        );
      }
      if (imageUrls.isNotEmpty) return imageUrls.first.attributes['content'];
    }
    return null;
  }
}
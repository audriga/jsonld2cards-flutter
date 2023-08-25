library default_markup_card;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/simple_card.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/uri_image.dart';
import 'package:jsonld2cards/Cards/markup_card.dart';
import 'package:jsonld2cards/Util/conversion.dart';
import 'BuildingBlocks/potential_actions.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class DefaultMarkupCard extends StatelessWidget implements MarkupCard {
  const DefaultMarkupCard({
    super.key,
    required this.markup,
    required this.postFunction,
    this.preview = false,
  });


  final Map<String, dynamic> markup;
  final PostFunction postFunction;
  final bool preview;

  @override
  Widget build(BuildContext context) {
    // Properties the Card might have
    var url = markup['url'];
    String? name = markup['headline'] ?? markup['name'];
    String? description = markup['description'];
    var image = markup['image'] ?? markup['logo'];
    var potentialAction = markup['potentialAction'];

    // Setting title and subtitle, depending on available information
    String? titleText;
    String? subtitleText;
    if (name != null) {
      titleText = name;
      if (description != null) {
        subtitleText = description;
      }
    } else if (description != null) {
      titleText = description;
    }

    // Look for images in markup
    Widget? leadingImage;
    if (image != null) {
      try {
        if (image is List<dynamic>) {
          // For array of URLs, unconventional, but used by zeit
          Uri? imageUri;
          if (image.first is Map<String, dynamic>) {
            imageUri = tryCastOrParse(image.first['contentUrl'] ?? image.first['url']);
          } else {
            imageUri = tryCastOrParse(image.first);
          }
          if (imageUri != null) {
            leadingImage = UriImage(
              content: imageUri,
              height: 32.0,
              width:  32.0,
              fit: BoxFit.scaleDown,
              errorWidget: imageErrorWidget,
            );
          }

        } else if (image is Map<String, dynamic>) {
          // image is an ImageObject (https://schema.org/ImageObject)
          var contentUrl = image['contentUrl'] ?? image['url'];
          leadingImage = UriImage(
            content: contentUrl,
            height: 32.0,
            width:  32.0,
            fit: BoxFit.scaleDown,
            errorWidget: imageErrorWidget,
          );
        } else {
          // Probably URL, so flutter type of String or URI
          var imageAsUri = tryCastOrParse(image);
          if (imageAsUri != null ) {
            leadingImage = UriImage(
              content: image,
              height: 32.0,
              width:  32.0,
              fit: BoxFit.scaleDown,
              errorWidget: imageErrorWidget,
            );
          }
        }
      } on FormatException catch (_) {
        // Tried giving something that isn't a uri or can't be parsed to a uri to UriImage.
      }
    }

    bool showDefaultViewAction = (url != null);
    return SimpleCard(
      leadingImage: leadingImage,
      titleText: titleText,
      subtitleText: subtitleText,
      potentialAction: potentialAction,
      potentialActionPostFunction: postFunction,
      secondaryPotentialAction: showDefaultViewAction
          ? {"@type": "ViewAction", "url": url, "name": "Visit"}
          : null,
      secondaryPotentialActionPostFunction: postFunction,
      preview: preview,
    );
  }


  // todo use html2jsonld  version of this instead of own function
  // todo make downloading of missing images optional!
  Future<String?> getImageSource(Uri? uri) async {
    if (uri == null) return null;
    http.Response response = await http.get(uri);
    var parsedResponse = parse(response.body);
    var head = parsedResponse.head;
    if (head != null) {
      var metaTags = head.getElementsByTagName('meta');
      var imageUrls = metaTags
          .where((script) => script.attributes['name'] == 'twitter:image');
      if (imageUrls.length > 1) {
        developer.log(
          'Got more image urls than expected:\n$imageUrls',
          name: 'jsonld2cards.default_card',
        );
      }
      if (imageUrls.isNotEmpty) return imageUrls.first.attributes['content'];
    }
    return null;
  }

  Widget imageErrorWidget(context, url, error) {
    developer.log(
      'Error rendering leading Image',
      name: 'jsonld2cards.default_card',
      error: error,
    );
    return const SizedBox(width: 0,);
  }

  @override
  IconData get tabIcon => Icons.credit_card;

  @override
  String get tabName => 'Default';
}

library default_markup_card;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/simple_card.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/uri_image.dart';
import 'package:jsonld2cards/Cards/markup_card.dart';
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
    String? name = markup['headline'] ?? markup['name'];
    String? description = markup['description'];
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
    Widget? leadingImage = findLeadingImage(markup,
      imageErrorWidget: logAndShowNoImage,
      size: 32.0, // todo: Maybe find a way to dynamically determine the size?
    );

    return SimpleCard(
      leadingImage: leadingImage,
      titleText: titleText,
      subtitleText: subtitleText,
      potentialAction: potentialAction,
      potentialActionPostFunction: postFunction,
      preview: preview,
    );
  }



  @Deprecated('use html2jsonld version of this instead of own function')
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

  @override
  IconData get tabIcon => Icons.credit_card;

  @override
  String get tabName => 'Default';
}

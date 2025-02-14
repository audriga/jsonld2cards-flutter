library;

import 'package:flutter/material.dart'; //?
import 'package:jsonld2cards/cards/building_blocks/simple_card.dart';
import 'package:jsonld2cards/cards/building_blocks/uri_image.dart';
import 'package:jsonld2cards/cards/models/schema_types.dart';
import 'package:jsonld2cards/cards/markup_card.dart';
import 'package:jsonld2cards/card_data.dart';

class BlogPostingCard extends StatelessWidget implements MarkupCard {
  const BlogPostingCard(this.cardData, {super.key});

  final CardData cardData;

  @override
  Widget build(BuildContext context) {
    // Properties the Card might have
    String? name = cardData.markup['headline'] ?? cardData.markup['name'];
    //String? name = cardData.markup['headline'] ?? cardData.markup['name'];
    String? description = cardData.markup['description'];
    var potentialAction = cardData.markup['potentialAction'];

    // Setting title and subtitle, depending on available information
    String? titleText;
    String? subtitleText;
    titleText = name;
    /*
    if (name != null) {
      titleText = name;
      if (description != null) {
        subtitleText = description;
      }
    } else if (description != null) {
      titleText = description;
    }
     */
    if (description != null) {
      subtitleText = description;
    }

    // Look for images in cardData.markup
    Widget? leadingImage = findLeadingImage(
      cardData.markup,
      imageErrorWidget: logAndShowNoImage,
      size: 32.0, // todo: Maybe find a way to dynamically determine the size?
    );

    return SimpleCard(
      leadingImage: leadingImage,
      titleText: titleText,
      subtitleText: subtitleText,
      potentialAction: potentialAction,
      cardData: cardData,
    );
  }

  SchemaType get cardType => SchemaType.blogPosting;

  @override
  IconData get tabIcon => cardType.icon!;

  @override
  String get tabName => cardType.tabName;
}

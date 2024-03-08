library blog_posting_card;

import 'package:flutter/material.dart'; //?
import 'package:jsonld2cards/Cards/BuildingBlocks/simple_card.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/uri_image.dart';
import 'package:jsonld2cards/Cards/Models/schema_types.dart';
import 'package:jsonld2cards/Cards/markup_card.dart';
import 'BuildingBlocks/potential_actions.dart';
import 'dart:developer' as developer;

class BlogPostingCard extends StatelessWidget implements MarkupCard {
  const BlogPostingCard({
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
    
    // TODO
      developer.log(
      'ay caramba',
      name: 'jsonld2cards.default_card',
    );
    String? name = 'ayCaramba';
    //String? name = markup['headline'] ?? markup['name'];
    String? description = markup['description'];
    var potentialAction = markup['potentialAction'];

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




  SchemaType get cardType => SchemaType.blogPosting;

  @override
  IconData get tabIcon => cardType.icon!;

  @override
  String get tabName => cardType.tabName;
}

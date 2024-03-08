library template_card;

import 'package:flutter/widgets.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/simple_card.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/uri_image.dart';
import 'package:jsonld2cards/Cards/Models/schema_types.dart';
import 'package:jsonld2cards/Cards/markup_card.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/potential_actions.dart';
import 'package:jsonld2cards/Templates/title_subtitle_templates.dart';
import 'package:mustache_template/mustache.dart';

/// Created a simple Title+Subtitle card via templating strings.
class SimpleTemplateCard extends StatelessWidget implements MarkupCard {
  SimpleTemplateCard({
    super.key,
    required this.markup,
    required this.postFunction,
    this.preview = false,
  }): cardType = getCardType(markup['@type'])!;

  final SchemaType cardType;
  final Map<String, dynamic> markup;
  final PostFunction postFunction;
  final bool preview;

  @override
  Widget build(BuildContext context) {
    String titleSource = titleSourceTemplate(cardType);
    String subTitleSource = subTitleSourceTemplate(cardType);

    var titleTemplate = Template(
      htmlEscapeValues: false,
      titleSource,
      lenient: true,
    );
    var subTitleTemplate = Template(
      htmlEscapeValues: false,
      subTitleSource,
      lenient: true,
    );
    // Setting title and subtitle, depending on available information
    String titleText = titleTemplate.renderString(markup);
    String subtitleText = subTitleTemplate.renderString(markup);
    Widget? leadingImage = findLeadingImage(markup) ?? Icon(tabIcon, size: 32.0,);



    return SimpleCard(
      leadingImage: leadingImage,
      titleText: titleText,
      subtitleText: subtitleText,
      potentialAction: markup['potentialAction'],
      potentialActionPostFunction: postFunction,
      preview: preview,
    );
  }


  @override
  IconData get tabIcon => cardType.icon!;

  @override
  String get tabName => cardType.tabName;
}


// todo not implemented yet (copy-paste from above)
/// Created a simple Title+Subtitle card via templating strings.
class ThreeColumnTemplateCard extends StatelessWidget implements MarkupCard {
  ThreeColumnTemplateCard({
    super.key,
    required this.markup,
    required this.postFunction,
    this.preview = false,
  }): cardType = getCardType(markup['@type'])!;

  final SchemaType cardType;
  final Map<String, dynamic> markup;
  final PostFunction postFunction;
  final bool preview;

  @override
  Widget build(BuildContext context) {
    String titleSource = titleSourceTemplate(cardType);
    String subTitleSource = subTitleSourceTemplate(cardType);

    var titleTemplate = Template(
      htmlEscapeValues: false,
      titleSource,
      lenient: true,
    );
    var subTitleTemplate = Template(
      htmlEscapeValues: false,
      subTitleSource,
      lenient: true,
    );
    // Setting title and subtitle, depending on available information
    String titleText = titleTemplate.renderString(markup);
    String subtitleText = subTitleTemplate.renderString(markup);
    Widget? leadingImage = findLeadingImage(markup) ?? Icon(tabIcon, size: 32.0,);



    return SimpleCard(
      leadingImage: leadingImage,
      titleText: titleText,
      subtitleText: subtitleText,
      potentialAction: markup['potentialAction'],
      potentialActionPostFunction: postFunction,
      preview: preview,
    );
  }


  @override
  IconData get tabIcon => cardType.icon!;

  @override
  String get tabName => cardType.tabName;
}

library;

import 'package:flutter/widgets.dart';
import 'simple_card.dart';
import 'uri_image.dart';
import '../models/schema_types.dart';
import '../markup_card.dart';
import '../../templates/title_subtitle_templates.dart';
import 'package:jsonld2cards/card_data.dart';
import 'package:mustache_template/mustache.dart';

/// Created a simple Title+Subtitle card via templating strings.
class SimpleTemplateCard extends StatelessWidget implements MarkupCard {
  SimpleTemplateCard(this.cardData, {super.key})
      : cardType = getCardType(cardData.markup['@type'])!;

  final SchemaType cardType;
  final CardData cardData;

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
    String titleText = titleTemplate.renderString(cardData.markup);
    String subtitleText = subTitleTemplate.renderString(cardData.markup);
    Widget? leadingImage = findLeadingImage(cardData.markup) ??
        Icon(
          tabIcon,
          size: 32.0,
        );

    return SimpleCard(
      leadingImage: leadingImage,
      titleText: titleText,
      subtitleText: subtitleText,
      potentialAction: cardData.markup['potentialAction'],
      cardData: cardData,
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
  ThreeColumnTemplateCard(this.cardData, {super.key})
      : cardType = getCardType(cardData.markup['@type'])!;

  final SchemaType cardType;
  final CardData cardData;

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
    String titleText = titleTemplate.renderString(cardData.markup);
    String subtitleText = subTitleTemplate.renderString(cardData.markup);
    Widget? leadingImage = findLeadingImage(cardData.markup) ??
        Icon(
          tabIcon,
          size: 32.0,
        );

    return SimpleCard(
      leadingImage: leadingImage,
      titleText: titleText,
      subtitleText: subtitleText,
      potentialAction: cardData.markup['potentialAction'],
      cardData: cardData,
    );
  }

  @override
  IconData get tabIcon => cardType.icon!;

  @override
  String get tabName => cardType.tabName;
}

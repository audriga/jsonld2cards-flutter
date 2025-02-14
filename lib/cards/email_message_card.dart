library;

import 'package:jsonld2cards/cards/building_blocks/simple_card.dart';
import 'package:jsonld2cards/cards/models/schema_types.dart';
import 'package:jsonld2cards/card_data.dart';

import 'package:flutter/widgets.dart';

import 'markup_card.dart';

class EmailMessage extends StatelessWidget implements MarkupCard {
  const EmailMessage(
    this.cardData, {
    super.key,
  });

  final CardData cardData;

  @override
  Widget build(BuildContext context) {
    String? name = cardData.markup['name'];
    String? description = cardData.markup['description'];
    var potentialAction = cardData.markup['potentialAction'];

    return SimpleCard(
      titleText: name ?? description,
      subtitleText: (name != null) ? description : null,
      potentialAction: potentialAction,
      cardData: cardData,
    );
  }

  SchemaType get cardType => SchemaType.emailMessage;

  @override
  IconData get tabIcon => cardType.icon!;

  @override
  String get tabName => cardType.tabName;
}

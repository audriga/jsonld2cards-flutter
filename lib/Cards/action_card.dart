library;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/simple_card.dart';
import 'package:jsonld2cards/Cards/Models/schema_types.dart';
import 'package:jsonld2cards/Cards/markup_card.dart';
import 'package:jsonld2cards/card_data.dart';
import 'package:flutter/widgets.dart';

import 'Models/action_model.dart' as action_model;

class ActionCard extends StatelessWidget implements MarkupCard {
  const ActionCard(this.cardData, {super.key});

  final CardData cardData;

  @override
  Widget build(BuildContext context) {
    var action = action_model.Action.fromJson(cardData.markup);

    // Setting title and subtitle, depending on available information
    String? titleText;
    String? subtitleText;
    Widget? leadingImage;
    var titleTextBuffer = StringBuffer();
    if (action.name != null) {
      titleTextBuffer.write('${action.name}');
    }
    if (action.actionStatus != null) {
      titleTextBuffer.write(' ${action_model.actionStatusToVerbString(action.actionStatus!)}');
    }

    titleText = titleTextBuffer.toString();
    subtitleText = action.verb;
    
    leadingImage = Icon(action.icon);


    return SimpleCard(
      leadingImage: leadingImage,
      titleText: titleText,
      subtitleText: subtitleText,
      potentialAction: action.potentialAction,
      cardData: cardData,
    );
  }

  SchemaType get cardType => SchemaType.action;

  @override
  IconData get tabIcon => cardType.icon!;

  @override
  String get tabName => cardType.tabName;
}

library email_message_card;

import 'package:jsonld2cards/Cards/BuildingBlocks/simple_card.dart';
import 'package:jsonld2cards/Cards/Models/schema_types.dart';

import 'BuildingBlocks/potential_actions.dart';
import 'package:flutter/widgets.dart';

import 'markup_card.dart';

class EmailMessage extends StatelessWidget implements MarkupCard {
  const EmailMessage({
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
    String description = markup['description'];
    var potentialAction = markup['potentialAction'];


    return SimpleCard(
      titleText: description,
      potentialAction: potentialAction,
      potentialActionPostFunction: postFunction,
      preview: preview,
    );
  }

  SchemaType get cardType => SchemaType.emailMessage;

  @override
  IconData get tabIcon => cardType.icon!;

  @override
  String get tabName => cardType.tabName;
}
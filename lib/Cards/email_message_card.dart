library email_message_card;

import 'package:jsonld2cards/Cards/BuildingBlocks/simple_card.dart';

import 'BuildingBlocks/potential_actions.dart';
import 'package:flutter/material.dart';

class EmailMessage extends StatelessWidget {
  const EmailMessage({
    super.key,
    required this.markup,
    required this.postFunction,
  });

  final Map<String, dynamic> markup;
  final PostFunction postFunction;


  @override
  Widget build(BuildContext context) {
    String description = markup['description'];
    Map<String, dynamic>  potentialAction = markup['potentialAction'];


    return SimpleCard(
      titleText: description,
      potentialAction: potentialAction,
      potentialActionPostFunction: postFunction,
    );
  }
}
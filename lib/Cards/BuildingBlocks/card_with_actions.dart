library card_with_actions;

import 'package:flutter/material.dart';

import 'potential_actions.dart';

// todo replace all possible material imports with  import 'package:flutter/widgets.dart';

class CardWithActions extends StatelessWidget {
  const CardWithActions(
      {super.key,
      required this.cardContents,
      this.potentialAction,
      this.secondaryPotentialAction,
      this.potentialActionPostFunction,
      this.secondaryPotentialActionPostFunction});

  final List<Widget> cardContents;

  final dynamic potentialAction;

  /// If null a dummy function will be used instead
  final PostFunction? potentialActionPostFunction;

  /// case for place cards and default card.
  final dynamic secondaryPotentialAction;
  final PostFunction? secondaryPotentialActionPostFunction;

  @override
  Widget build(BuildContext context) {
    // Showing Buttons for Potential Actions
    if (potentialAction != null) {
      cardContents.add(PotentialActionRow(
        potentialAction: potentialAction,
        postFunction: potentialActionPostFunction ??
            (_, {dynamic dataToPost, String? successMessage}) {},
      ));
    }
    if (secondaryPotentialAction != null) {
      cardContents.add(PotentialActionRow(
        potentialAction: secondaryPotentialAction,
        postFunction: secondaryPotentialActionPostFunction ??
            (_, {dynamic dataToPost, String? successMessage}) {},
      ));
    }
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: cardContents,
      ),
    );
  }
}

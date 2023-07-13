library simple_card.dart;

import 'package:flutter/material.dart';
import 'potential_actions.dart';

class SimpleCard extends StatelessWidget {
  const SimpleCard(
      {super.key,
      this.leadingImage,
      this.titleText,
      this.subtitleText,
      this.potentialAction,
      this.secondaryPotentialAction,
      this.potentialActionPostFunction,
      this.secondaryPotentialActionPostFunction});

  final Widget? leadingImage;
  final String? titleText;
  final String? subtitleText;

  // todo isMultiline to set ListTiles isThreeLine? for f.e. spotify descriptions
  // final PotentialActionRow? potentialActionRow;
  final dynamic potentialAction;
  /// If null a dummy function will be used instead
  final PostFunction? potentialActionPostFunction;

  /// case for place cards and default card.
  final dynamic secondaryPotentialAction;
  final PostFunction? secondaryPotentialActionPostFunction;

  @override
  Widget build(BuildContext context) {
    var cardContents = <Widget>[
      ListTile(
        leading: leadingImage,
        title: titleText != null ? Text(titleText!) : null,
        subtitle: subtitleText != null ? Text(subtitleText!) : null,
      ),
    ];

    // Showing Buttons for Potential Actions
    if (potentialAction != null) {
      cardContents.add(PotentialActionRow(
        potentialAction: potentialAction,
        postFunction: potentialActionPostFunction ?? (_ , {dynamic dataToPost, String? successMessage}) {},
      ));
    }
    if (secondaryPotentialAction != null) {
      cardContents.add(PotentialActionRow(
        potentialAction: secondaryPotentialAction,
        postFunction: secondaryPotentialActionPostFunction ?? (_ , {dynamic dataToPost, String? successMessage}) {},
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

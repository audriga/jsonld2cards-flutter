library;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/card_data.dart';
import 'card_with_actions.dart';
import 'potential_actions.dart';

/// Represents a card with a simple layout,
/// consisting of a [leadingImage] to the left, a [titleText] rendered in a
/// larger font, a [subtitleText] rendered in a smaller font below that and
/// up to two button rows via two [PotentialActionRow]s
class SimpleCard extends StatelessWidget {
  const SimpleCard({
    super.key,
    this.leadingImage,
    this.titleText,
    this.subtitleText,
    this.potentialAction,
    // this.secondaryPotentialAction,
    // this.secondaryPotentialActionPostFunction,
    required this.cardData,
  });

  final Widget? leadingImage;
  final String? titleText;
  final String? subtitleText;
  final CardData cardData;
  // todo isMultiline to set ListTiles isThreeLine? for f.e. spotify descriptions

  // final PotentialActionRow? potentialActionRow;
  /// Markup representing potential buttons to be shown in a [PotentialActionRow]
  /// if present.
  /// Expected to be eiter [Map<String, dynamic>] to represent
  /// a single [PotentialActionButton], or a
  /// [List<Map<String, dynamic>>] to represent multiple buttons.
  final dynamic potentialAction;
  // /// If null a dummy function will be used instead
  // final PostFunction? potentialActionPostFunction;

  // /// Markup representing potential buttons to be shown in a secondary
  // /// [PotentialActionRow] if present.
  // /// This is currently used for place cards and default card.
  // final dynamic secondaryPotentialAction;
  // final PostFunction? secondaryPotentialActionPostFunction;

  @override
  Widget build(BuildContext context) {
    var cardContent = SimpleCardContent(
      leadingImage: leadingImage,
      titleText: titleText,
      subtitleText: subtitleText,
    );

    return CardWithActions(
      cardContents: [cardContent],
      potentialAction: potentialAction,
      // secondaryPotentialAction: secondaryPotentialAction,
      // secondaryPotentialActionPostFunction:  secondaryPotentialActionPostFunction,
      cardData: cardData,
    );
  }
}

/// The main content of a card with a simple Layout.
/// Currently returns a ListTile, but has been made its own widget to enable
/// future style changes.
class SimpleCardContent extends StatelessWidget {
  const SimpleCardContent({
    super.key,
    this.leadingImage,
    this.titleText,
    this.subtitleText,
  });

  /// Image shown on the left of the card.
  /// This can be Map Tile in [Place] or an Album Cover in a [MusicCard]
  final Widget? leadingImage;

  /// Top level text to render in a larger font
  final String? titleText;

  /// Secondary text to render in a smaller font
  final String? subtitleText;

  @override
  Widget build(BuildContext context) {
    var cardContents = ListTile(
      leading: leadingImage,
      title: titleText != null ? Text(titleText!) : null,
      subtitle: subtitleText != null
          ? Text(
              subtitleText!,
              maxLines: 5,
              overflow: TextOverflow.fade,
            )
          : null,
    );
    return cardContents;
  }
}

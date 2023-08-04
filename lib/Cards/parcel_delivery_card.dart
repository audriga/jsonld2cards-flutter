library parcel_delivery_card;

import 'package:flutter/material.dart';

import 'BuildingBlocks/card_with_actions.dart';
import 'BuildingBlocks/potential_actions.dart';
import 'BuildingBlocks/three_column_card_content.dart';
import 'Models/parcel_delivery_model.dart';

class ParcelDeliveryCard extends StatelessWidget {
  const ParcelDeliveryCard({
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
    ThemeData theme = Theme.of(context);

    var parcelDelivery = ParcelDelivery.fromJson(markup);

    List<Widget> childrenInLeftColumn = [];
    var origin = parcelDelivery.originAddress;
    if (origin != null) {
      if (origin.name != null) {
        childrenInLeftColumn.add(Text(
          origin.name!,
          style: theme.textTheme.headlineLarge,
        ));
      }
      if (origin.streetAddress != null) {
        childrenInLeftColumn.add(Text(
          origin.streetAddress!,
          style: theme.textTheme.bodySmall,
        ));
      }
      if (origin.addressLocality != null) {
        childrenInLeftColumn.add(Text(
          origin.addressLocality!,
          style: theme.textTheme.bodySmall,
        ));
      }
      if (origin.addressRegion != null) {
        childrenInLeftColumn.add(Text(
          origin.name!,
          style: theme.textTheme.bodySmall,
        ));
      }
    }
    List<Widget> childrenInRightColumn = [];
    var destination = parcelDelivery.deliveryAddress;
    if (destination != null) {
      if (destination.name != null) {
        childrenInRightColumn.add(Text(
          destination.name!,
          style: theme.textTheme.headlineLarge,
        ));
      }
      if (destination.streetAddress != null) {
        childrenInRightColumn.add(Text(
          destination.streetAddress!,
          style: theme.textTheme.bodySmall,
        ));
      }
      if (destination.addressLocality != null) {
        childrenInRightColumn.add(Text(
          destination.addressLocality!,
          style: theme.textTheme.bodySmall,
        ));
      }
      if (destination.addressRegion != null) {
        childrenInRightColumn.add(Text(
          destination.name!,
          style: theme.textTheme.bodySmall,
        ));
      }
    }
    
    var leftColumn = Column(
      children: childrenInLeftColumn,
    );

    List<Widget> childrenInMiddleColumn = [
      const Icon(Icons.local_post_office)
    ];

    var item = parcelDelivery.itemShipped;
    if (item != null && item.name != null) {
      childrenInMiddleColumn.add(Text(
        item.name!,
        style: theme.textTheme.labelLarge,
      ));
    }
    if (parcelDelivery.carrier != null && parcelDelivery.carrier!.name != null) {
      childrenInMiddleColumn.add(Text(
        parcelDelivery.carrier!.name!,
        style: theme.textTheme.labelMedium,
      ));
    }


    var middleColumn = Column(
      children: childrenInMiddleColumn,
    );

    var rightColumn = Column(
      children: childrenInRightColumn,
    );
    var parcelView = ThreeColumnCardContent(
        leftColumn: leftColumn,
        middleColumn: middleColumn,
        rightColumn: rightColumn);

    return CardWithActions(
      cardContents: [parcelView],
      potentialAction: parcelDelivery.potentialAction,
      potentialActionPostFunction: postFunction,
      preview: preview,
    );
  }
}


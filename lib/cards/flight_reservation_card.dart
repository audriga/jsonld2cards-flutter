library;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/cards/models/schema_types.dart';
import 'package:jsonld2cards/cards/markup_card.dart';
import 'package:jsonld2cards/card_data.dart';

import 'building_blocks/card_with_actions.dart';
import 'building_blocks/three_column_card_content.dart';

class FlightReservationCard extends StatelessWidget implements MarkupCard {
  const FlightReservationCard(this.cardData, {super.key});

  final CardData cardData;

  @override
  Widget build(BuildContext context) {
    FlightReservationWidget flightView =
        FlightReservationWidget(markup: cardData.markup);
    var potentialAction = cardData.markup['potentialAction'];

    return CardWithActions(
      cardContents: [flightView],
      potentialAction: potentialAction,
      cardData: cardData,
    );
  }

  SchemaType get cardType => SchemaType.flightReservation;

  @override
  IconData get tabIcon => cardType.icon!;

  @override
  String get tabName => cardType.tabName;
}

class FlightReservationWidget extends StatelessWidget {
  const FlightReservationWidget({
    super.key,
    required this.markup,
  });

  final Map<String, dynamic> markup;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var reservationFor = markup['reservationFor'];
    var departureAirport = reservationFor['departureAirport'];
    var arrivalAirport = reservationFor['arrivalAirport'];

    var leftColumn = Column(
      children: [
        Text(
          departureAirport['iataCode'],
          style: theme.textTheme.headlineLarge,
        ),
        Text(
          departureAirport['name'],
          style: theme.textTheme.bodyLarge,
          softWrap: true,
        ),
        Text(
          reservationFor['departureTime'],
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );

    var middleColumn = Column(
      children: [
        Text(
            '${reservationFor['airline']['iataCode']} ${reservationFor['flightNumber']}'),
        const Icon(Icons.flight),
      ],
    );

    var rightColumn = Column(
      children: [
        Text(
          arrivalAirport['iataCode'],
          style: theme.textTheme.headlineLarge,
        ),
        Text(
          arrivalAirport['name'],
          style: theme.textTheme.bodyLarge,
          softWrap: true,
        ),
        Text(
          reservationFor['arrivalTime'],
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
    var flightView = ThreeColumnCardContent(
        leftColumn: leftColumn,
        middleColumn: middleColumn,
        rightColumn: rightColumn);
    return flightView;
  }
}

library flight_reservation_card;

import 'package:flutter/material.dart';

import 'BuildingBlocks/card_with_actions.dart';
import 'BuildingBlocks/potential_actions.dart';
import 'BuildingBlocks/three_column_card_content.dart';

class FlightReservationCard extends StatelessWidget {
  const FlightReservationCard({
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
    FlightReservationWidget flightView =
        FlightReservationWidget(markup: markup);
    var potentialAction = markup['potentialAction'];

    return CardWithActions(
      cardContents: [flightView],
      potentialAction: potentialAction,
      potentialActionPostFunction: postFunction,
      preview: preview,
    );
  }
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
        Text(reservationFor['airline']['iataCode'] +
            ' ' +
            reservationFor['flightNumber']),
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

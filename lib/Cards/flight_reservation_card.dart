library flight_reservation_card;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/Cards/potential_actions.dart';

class FlightReservationCard extends StatelessWidget {
  const FlightReservationCard({
    super.key,required this.markup,
    required this.postFunction,
  });

  final Map<String, dynamic> markup;
  final Function(Uri uriToPost, {dynamic dataToPost, String successMessage}) postFunction;


  @override
  Widget build(BuildContext context) {
    FlightReservationWidget flightView = FlightReservationWidget(markup: markup);
    var potentialAction = markup['potentialAction'];

    var cardContents = <Widget>[
      ListTile(
        title: flightView,
      ),
    ];
    if (potentialAction != null) {
      cardContents.add(PotentialActionRow(
        potentialAction: potentialAction,
        postFunction: postFunction,
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

class FlightReservationWidget extends StatelessWidget {

  const FlightReservationWidget({
    super.key, required this.markup,
  });

  final Map<String, dynamic> markup;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var reservationFor = markup['reservationFor'];
    var departureAirport = reservationFor['departureAirport'];
    var arrivalAirport = reservationFor['arrivalAirport'];
    var flightView = Row(
      children: [
        Expanded(
          child: Column(
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
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(reservationFor['airline']['iataCode'] + ' ' + reservationFor['flightNumber']),
              const Icon(Icons.flight),
            ],
          ),
        ),
        Expanded(
          child: Column(
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
          ),
        ),
      ],
    );
    return flightView;
  }
}
library;

import 'package:jsonld2cards/Cards/BuildingBlocks/simple_card.dart';
import 'package:jsonld2cards/Cards/Models/schema_types.dart';
import 'package:jsonld2cards/Cards/markup_card.dart';
import 'package:jsonld2cards/card_data.dart';
import 'package:flutter/widgets.dart';

import 'Models/event_model.dart';

class EventCard extends StatelessWidget implements MarkupCard {
  const EventCard(this.cardData, {super.key});

  final CardData cardData;

  @override
  Widget build(BuildContext context) {
    var event = Event.fromJson(cardData.markup);

    // Setting title and subtitle, depending on available information
    String? titleText;
    String? subtitleText;
    Widget? leadingImage;
    var titleTextBuffer = StringBuffer(event.name ?? 'Event');


    var subTitleTextBuffer = StringBuffer();
    if (event.description != null) {
      subTitleTextBuffer.write('${event.description}. ');
    }
    var hasStart = event.startDate != null;
    var hasEnd = event.endDate != null;
    if (hasStart) {
      subTitleTextBuffer.write('From ${event.startDate!.toIso8601String()}');
      if (hasEnd) {
        subTitleTextBuffer.write(' to ${event.endDate!.toIso8601String()}');
      }
    } else if (hasEnd) {
      subTitleTextBuffer.write('Ends ${event.endDate!.toIso8601String()}');
    }
    if (event.location is Map<String, dynamic>) {
      var locationName = event.location['name'];
      if (locationName != null) {
        subTitleTextBuffer.write(' at $locationName');
      }
    }

    // todo attendance, organizers

    titleText = titleTextBuffer.toString();
    subtitleText = subTitleTextBuffer.toString();


    return SimpleCard(
      leadingImage: leadingImage,
      titleText: titleText,
      subtitleText: subtitleText,
      potentialAction: event.potentialAction,
      cardData: cardData,
    );
  }

  SchemaType get cardType => SchemaType.event;

  @override
  IconData get tabIcon => cardType.icon!;

  @override
  String get tabName => cardType.tabName;
}

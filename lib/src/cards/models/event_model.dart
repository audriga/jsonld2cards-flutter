library;

import 'thing_model.dart';
import 'organization_model.dart';

class Event extends Thing {
  // Thing? about;
  // // Person? actor
  // Map<String, dynamic>? actor;
  // // AggregateRating> aggregateRating;
  // Map<String, dynamic>? aggregateRating;
  // Map<String, dynamic>? attendee;
  // Map<String, dynamic>? audience;
  // Map<String, dynamic>? composer;
  // Map<String, dynamic>? contributor;
  // Map<String, dynamic>? director;
  // Map<String, dynamic>? doorTime;
  // Map<String, dynamic>? duration;
  // Map<String, dynamic>? endDate;
  // Map<String, dynamic>? eventAttendanceMode;
  // Map<String, dynamic>? eventSchedule;
  // Map<String, dynamic>? eventStatus;
  // Map<String, dynamic>? funder;
  // Map<String, dynamic>? inLanguage;
  // bool? isAccessibleForFree;
  // Map<String, dynamic>? keywords;
  // Map<String, dynamic>? location;
  // int? maximumAttendeeCapacity;
  // int? maximumPhysicalAttendeeCapacity;
  // int? maximumVirtualAttendeeCapacity;
  // Map<String, dynamic>? offers;
  // Map<String, dynamic>? organizer;
  // ...

  //  todo this is not a full model, just for what is currently used/ displayed in a card
  // According to documentation is Place  or PostalAddress  or Text  or VirtualLocation. Not modelling that
  dynamic location;
  DateTime? startDate;
  DateTime? endDate;
  // Organization or Person
  dynamic organizer;
  // Organization or Person
  dynamic attendee;

  // Map<String, dynamic>? originalJson;

  Event(this.location, this.startDate, this.endDate, this.organizer,
      this.attendee);

  Event.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    location = json['location'];
    var untypedStartDate = json['startDate'];
    if (untypedStartDate is String) {
      startDate = DateTime.tryParse(untypedStartDate);
    }
    var untypedEndDate = json['endDate'];
    if (untypedEndDate is String) endDate = DateTime.tryParse(untypedEndDate);
    var untypedOrganizer = json['organizer'];
    // todo handle lists too, same goes for attendee
    organizer = (untypedOrganizer != null &&
            (untypedOrganizer is Map<String, dynamic>) &&
            untypedOrganizer['@type'] == 'Organization')
        ? Organization.fromJson(untypedOrganizer)
        : untypedOrganizer;
    var untypedAttendee = json['attendee'];
    attendee = (untypedAttendee != null &&
            (untypedAttendee is Map<String, dynamic>) &&
            untypedOrganizer['@type'] == 'Organization')
        ? Organization.fromJson(untypedAttendee)
        : untypedAttendee;
    // originalJson = json;
  }

  @override
  Map<String, dynamic> toJson() {
    // if (originalJson != null) return originalJson!;
    final data = super.toJson();
    data['@type'] = 'Event';
    data['@context'] = 'http://schema.org';
    data['location'] = location;
    // this might add a time of midnight to entries that were just dates before
    data['startDate'] = startDate?.toIso8601String();
    data['endDate'] = endDate?.toIso8601String();
    data['organizer'] =
        organizer is Organization ? organizer.toJson() : organizer;
    data['organizer'] = attendee is Organization ? attendee.toJson() : attendee;
    return data;
  }
}

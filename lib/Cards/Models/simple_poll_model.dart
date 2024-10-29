library simple_poll_model;

import 'package:jsonld2cards/Cards/Models/thing_model.dart';
import 'package:jsonld2cards/Util/conversion.dart';

import 'organization_model.dart';

class Person extends Thing {
  Person.fromJson(super.json) : super.fromJson();
}

class SimplePollOption extends Thing {
  SimplePollOption.fromJson(super.json) : super.fromJson();
}

class ChooseAction extends Thing {
  Person? agent;
  String? actionOption;

  ChooseAction({this.agent, this.actionOption, super.potentialAction});

  ChooseAction.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['agent'] case Map<String, dynamic> agentJson) {
      agent = Person.fromJson(agentJson);
    }
    if (json['actionOption'] case String actionOptionJson) {
      actionOption = actionOptionJson;
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['@context'] = 'http://schema.org';
    data['@type'] = type;
    if (agent != null) {
      data['agent'] = agent!.toJson();
    }
    if (actionOption != null) {
      data['actionOption'] = actionOption;
    }
    return data;
  }
}

// todo probably a good idea to create a mixin for the update mechanism.
class SimplePoll extends Thing {
  bool? selectMultiple;
  bool? canResubmit;
  bool? closed;
  Thing?
      organizer; // In example this is a person, but maybe we want to allow organization too.
  List<SimplePollOption>? options;
  DateTime? dateCreated;
  DateTime? expires;
  List<ChooseAction>? choices;
  Uri? liveUri;

  SimplePoll({
    this.selectMultiple,
    this.canResubmit,
    this.closed,
    this.organizer,
    this.options,
    this.dateCreated,
    this.expires,
    this.choices,
    this.liveUri,
    super.potentialAction,
  });

  SimplePoll.fromJson(Map<String, dynamic> json)
      : selectMultiple = json['selectMultiple'],
        canResubmit = json['canResubmit'],
        closed = json['closed'],
        super.fromJson(json) {
    if (json['organizer'] case Map<String, dynamic> organizerJson) {
      var organizerType = organizerJson['@type'];
      if (organizerType is String) {
        organizer = switch (organizerType) {
          'Person' => Person.fromJson(organizerJson),
          'Organization' => Organization.fromJson(organizerJson),
          String() => Thing.fromJson(organizerJson),
        };
      }
    }
    if (json['options'] case List<dynamic> optionsJson) {
      options = optionsJson
          .whereType<Map<String, dynamic>>()
          .map((e) => SimplePollOption.fromJson(e))
          .toList();
    }
    dateCreated = DateTime.tryParse(json['paymentDue'] ?? '');
    expires = DateTime.tryParse(json['expires'] ?? '');
    if (json['choices'] case List<dynamic> choicesJson) {
      choices = choicesJson
          .whereType<Map<String, dynamic>>()
          .map((e) => ChooseAction.fromJson(e))
          .toList();
    }
    liveUri = tryCastOrParse(json['liveUri']);
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['selectMultiple'] = selectMultiple;
    data['canResubmit'] = canResubmit;
    data['closed'] = closed;
    data['organizer'] = organizer?.toJson();
    if (options != null && options!.isNotEmpty) {
      data['options'] = options?.map((e) => e.toJson()).toList();
    }
    if (choices != null && choices!.isNotEmpty) {
      data['choices'] = choices?.map((e) => e.toJson()).toList();
    }
    data['dateCreated'] = dateCreated?.toIso8601String();
    data['expires'] = expires?.toIso8601String();
    data['liveUri'] = liveUri?.toString();

    return data;
  }

  // Ignoring choices and closed for equals check.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SimplePoll &&
          type == other.type &&
          name == other.name &&
          runtimeType == other.runtimeType &&
          selectMultiple == other.selectMultiple &&
          canResubmit == other.canResubmit &&
          organizer == other.organizer &&
          options == other.options &&
          dateCreated == other.dateCreated &&
          expires == other.expires &&
          liveUri == other.liveUri;

  @override
  int get hashCode =>
      type.hashCode ^
      name.hashCode ^
      selectMultiple.hashCode ^
      canResubmit.hashCode ^
      organizer.hashCode ^
      options.hashCode ^
      dateCreated.hashCode ^
      expires.hashCode ^
      liveUri.hashCode;
}

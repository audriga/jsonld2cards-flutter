library;

import 'package:flutter/material.dart';
import 'thing_model.dart';

enum ActionStatus {
  activeActionStatus,
  completedActionStatus,
  failedActionStatus,
  potentialActionStatus,
}

ActionStatus? actionStatusFromString(String? actionStatusAsString) {
  if (actionStatusAsString == null) return null;
  var actionStatusAsUri = Uri.tryParse(actionStatusAsString);
  if (actionStatusAsUri != null) {
    actionStatusAsString = actionStatusAsUri.path;
  }
  switch (actionStatusAsString) {
    case 'ActiveActionStatus':
      return ActionStatus.activeActionStatus;
    case 'CompletedActionStatus':
      return ActionStatus.completedActionStatus;
    case 'FailedActionStatus':
      return ActionStatus.failedActionStatus;
    case 'PotentialActionStatus':
      return ActionStatus.potentialActionStatus;
    default:
      return null;
  }
}

String actionStatusToString(ActionStatus status) {
  return switch (status) {
    ActionStatus.activeActionStatus => 'ActiveActionStatus',
    ActionStatus.completedActionStatus => 'CompletedActionStatus',
    ActionStatus.failedActionStatus => 'FailedActionStatus',
    ActionStatus.potentialActionStatus => 'PotentialActionStatus',
  };
}

String actionStatusToVerbString(ActionStatus status) {
  return switch (status) {
    ActionStatus.activeActionStatus => 'is active',
    ActionStatus.completedActionStatus => 'is complete',
    ActionStatus.failedActionStatus => 'has failed',
    ActionStatus.potentialActionStatus => 'is potential action',
  };
}

class Action extends Thing {
  /// The specific subtype of action
  late final String _type;
  ActionStatus? actionStatus;

  /// Either url or Entry point. Can also be list of those
  dynamic target;

  String get verb {
    return switch (_type) {
      'ConfirmAction' => 'Confirmed',
      'CancelAction' => 'Cancelled',
      _ => _type,
    };
  }

  IconData get icon {
    return switch (_type) {
      'ConfirmAction' => Icons.check_circle,
      'CancelAction' => Icons.cancel,
      _ => Icons.directions_run,
    };
  }

  Action.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    _type = json['@type'];
    // There are many action subtypes
    // assert(json['@type'] == 'Action', 'Type of Action should always be Action');

    actionStatus = actionStatusFromString(json['actionStatus']?.toString());
    target = json['target'];
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['@context'] = 'http://schema.org';
    data['@type'] = _type;

    if (actionStatus != null) {
      data['actionStatus'] = actionStatusToString(actionStatus!);
    }
    data['target'] = target;
    return data
      ..removeWhere(
        (key, value) => value == null,
      );
  }
}

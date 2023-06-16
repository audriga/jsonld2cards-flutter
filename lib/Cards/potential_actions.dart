library potential_actions;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PotentialActionRow extends StatelessWidget {
  const PotentialActionRow({
    super.key, required this.potentialAction, required this.postFunction,
  });

  final dynamic potentialAction;
  final Function(Uri uriToPost, {dynamic dataToPost, String successMessage}) postFunction;

  @override
  Widget build(BuildContext context) {
    if (potentialAction is Map<String, dynamic>) {
      Widget button = PotentialActionButton(
        potentialAction : potentialAction,
        postFunction: postFunction,
      );
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          button ,
          const SizedBox(width: 8),
        ],
      );
    } else if (potentialAction is List<dynamic>) {
      List<Widget> actionButtons = [];
      for (Map<String, dynamic> action in potentialAction) {
        actionButtons.add(
          PotentialActionButton(
            potentialAction: action,
            postFunction: postFunction,
          ),
        );
      }
      actionButtons.add(const SizedBox(width: 8));
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: actionButtons,
      );
    }
    throw FormatException('Potential action is no map or list of maps', potentialAction);
  }
}

class PotentialActionButton extends StatelessWidget {
  const PotentialActionButton({
    super.key, required this.potentialAction, required this.postFunction,
  });

  final Map<String, dynamic> potentialAction;
  final Function(Uri uriToPost, {dynamic dataToPost, String successMessage}) postFunction;

  @override
  Widget build(BuildContext context) {
    Widget button = const Placeholder();
    String actionType = potentialAction['@type'];
    var actionTarget = potentialAction['target'];
    switch (actionType) {
      case 'ViewAction': {
        button = TextButton(
          onPressed: () {

            Uri? uriToLaunch = Uri.tryParse(potentialAction['url']);
            if (uriToLaunch != null) {
              launchUrl(uriToLaunch);
            }
          },
          child: Text(potentialAction['name']),
        );
        return button;
      }
      case 'ConfirmAction': {
        //todo dynamically support different fillings of ConfirmAction
        Map<String, dynamic>? handler = potentialAction['handler'];
        String confirmUri = actionTarget ?? '';
        if (handler != null) {
          // todo switch depending on handler type?
          confirmUri = handler['url'];
        }
        button = TextButton(
          onPressed: () {

            Uri? uriToPost = Uri.tryParse(confirmUri);
            if (uriToPost != null) {
              postFunction(uriToPost, successMessage: 'Sent Confirmation');
            }
          },
          child: Text(potentialAction['name'] ?? 'Confirm'),
        );
        return button;
      }
      case 'CancelAction' : {
        button = TextButton(
          onPressed: () {
            Uri? uriToPost = Uri.tryParse(actionTarget);
            if (uriToPost != null) {
              postFunction(uriToPost, successMessage: 'Sent Cancellation');
            }
          },
          child: Text(potentialAction['name'] ?? 'Cancel'),
        );
        return button;
      }
      case 'EditAction' : {
        button = TextButton(
          onPressed: () {
            Uri? uriToLaunch = Uri.tryParse(actionTarget);
            if (uriToLaunch != null) {
              launchUrl(uriToLaunch);
            }
          },
          child: Text(potentialAction['name'] ?? 'Edit'),
        );
        return button;
      }
      case 'CheckInAction': {
        button = TextButton(
          onPressed: () {

            Uri? uriToPost = Uri.tryParse(actionTarget);
            if (uriToPost != null) {
              postFunction(uriToPost, successMessage: 'Sent Check-In');
            }
          },
          child: const Text('Check In'),
        );
        return button;
      }
      case 'ListenAction': {
        button = TextButton(
          onPressed: () {

            Uri? uriToLaunch = defaultTargetPlatform == TargetPlatform.android
                ? Uri.tryParse(actionTarget[1])
                : actionTarget[0]['urlTemplate'];
            if (uriToLaunch != null) {
              launchUrl(uriToLaunch);
            }
          },
          child: const Text('Listen Now'),
        );
        return button;
      }
    }
    return button;
  }
}
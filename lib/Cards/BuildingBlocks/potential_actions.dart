library potential_actions;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Util/conversion.dart';

// Todo make String nullable?
typedef PostFunction = Function(Uri uriToPost, {dynamic dataToPost, String successMessage});

class PotentialActionRow extends StatelessWidget {
  const PotentialActionRow({
    super.key,
    required this.potentialAction,
    required this.postFunction,
    this.preview = false,
  });

  final dynamic potentialAction;
  final PostFunction postFunction;
  final bool preview;

  @override
  Widget build(BuildContext context) {
    if (potentialAction is Map<String, dynamic>) {
      Widget button = PotentialActionButton(
        potentialAction : potentialAction,
        postFunction: postFunction,
        preview: preview,
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
            preview: preview,
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
// todo enum for actiontypes
class PotentialActionButton extends StatelessWidget {
  const PotentialActionButton({
    super.key,
    required this.potentialAction,
    required this.postFunction,
    this.preview = false,
  });

  final Map<String, dynamic> potentialAction;
  final PostFunction postFunction;
  final bool preview;

  @override
  Widget build(BuildContext context) {
    Widget button = const Placeholder();
    String actionType = potentialAction['@type'];
    var actionTarget = potentialAction['target'];
    switch (actionType) {
      case 'ViewAction': {
        button = TextButton(
          onPressed: preview ? () {} : () {
            Uri? uriToLaunch = tryCastOrParse(potentialAction['url']);
            if (uriToLaunch != null) {
              launchUrl(uriToLaunch);
            }
          },
          child: Text(potentialAction['name'] ?? 'View'),
        );
        return button;
      }
      case 'TrackAction': {
        button = TextButton(
          onPressed: preview ? () {} : () {
            Uri? uriToLaunch = tryCastOrParse(potentialAction['url']);
            if (uriToLaunch != null) {
              launchUrl(uriToLaunch);
            }
          },
          child: Text(potentialAction['name'] ?? 'Track'),
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
          onPressed: preview ? () {} : () {
            Uri? uriToPost = tryCastOrParse(confirmUri);
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
          onPressed: preview ? () {} : () {
            Uri? uriToPost = tryCastOrParse(actionTarget);
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
          onPressed: preview ? () {} : () {
            Uri? uriToLaunch = tryCastOrParse(actionTarget);
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
          onPressed: preview ? () {} : () {
            Uri? uriToPost = tryCastOrParse(actionTarget);
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
          onPressed: preview ? () {} : () {

            // TODO this assumes an order! replace with string prefix search
            Uri? uriToLaunch = defaultTargetPlatform == TargetPlatform.android
                ? tryCastOrParse(actionTarget[1])
                : tryCastOrParse(actionTarget[0]['urlTemplate']);
            if (uriToLaunch != null) {
              launchUrl(uriToLaunch);
            }
          },
          child: const Text('Listen Now'),
        );
        return button;
      }
      /// Special Case for Live Location
      case 'UpdateAction': {
        button = IconButton(
          onPressed: preview ? () {} : () async {
            // Misusing postFunction to call update function.
            postFunction(Uri.base);
          },
          icon: const Icon(Icons.refresh),
        );
        return button;
      }
    }
    return button;
  }
}
library potential_actions;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jsonld2cards/sml_app_context.dart';
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
    // this.smlAppContext,
  });

  final dynamic potentialAction;
  final PostFunction postFunction;
  final bool preview;
  // final SMLAppContext? smlAppContext;

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
// todo enum for action types
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
    Widget button = const SizedBox();
    String actionType = potentialAction['@type'];
    var actionTarget = potentialAction['target'];
    switch (actionType) {
      case 'ViewAction': {
        button = TextButton(
          onPressed: preview ? null : () {
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
          onPressed: preview ? null : () {
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
        var actionName = potentialAction['name'] ?? 'Confirm';
        button = TextButton(
          onPressed: preview ? null : () {
            Uri? uriToPost = tryCastOrParse(confirmUri);
            if (uriToPost != null) {
              if (uriToPost.scheme == 'mailto' && globalSMLAppContext?.confirmCallback != null) {
                potentialAction['@context'] = 'https://schema.org';
                potentialAction['actionStatus'] = 'CompletedActionStatus';
                globalSMLAppContext!.confirmCallback!(subject: 'Action $actionName', dataToSend: potentialAction, recipient: uriToPost.path);
              } else {
                postFunction(uriToPost, successMessage: 'Sent Confirmation');
              }
            }
          },
          child: Text(actionName),
        );
        return button;
      }
      case 'CancelAction' : {
        var actionName = potentialAction['name'] ?? 'Cancel';
        button = TextButton(
          onPressed: preview ? null : () {
            Uri? uriToPost = tryCastOrParse(actionTarget);
            if (uriToPost != null) {
              if (uriToPost.scheme == 'mailto' && globalSMLAppContext?.confirmCallback != null) {
                potentialAction['@context'] = 'https://schema.org';
                potentialAction['actionStatus'] = 'CompletedActionStatus';
                globalSMLAppContext!.confirmCallback!(subject: 'Action $actionName', dataToSend: potentialAction, recipient: uriToPost.path);
              } else {
                postFunction(uriToPost, successMessage: 'Sent Cancellation');
              }
            }
          },
          child: Text(actionName),
        );
        return button;
      }
      case 'EditAction' : {
        button = TextButton(
          onPressed: preview ? null : () {
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
          onPressed: preview ? null : () {
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
          onPressed: preview ? null : () {

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
          onPressed: preview ? null : () async {
            // Misusing postFunction to call update function.
            postFunction(Uri.base);
          },
          icon: const Icon(Icons.refresh),
        );
        return button;
      }
      case 'SearchAction': {
        button = IconButton(
          onPressed: preview ? null : () {
            Uri? uriToLaunch = tryCastOrParse(actionTarget);
            // todo should query for search... But this might be difficult to implement
            if (uriToLaunch != null) {
              launchUrl(uriToLaunch);
            }
          },
          icon: const Icon(Icons.search),
        );
      }
    }
    return button;
  }
}
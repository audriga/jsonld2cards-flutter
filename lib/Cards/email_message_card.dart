library email_message_card;

import '../Cards/potential_actions.dart';
import 'package:flutter/material.dart';

class EmailMessage extends StatelessWidget {
  const EmailMessage({
    super.key,
    required this.markup,
    required this.postFunction,
  });

  final Map<String, dynamic> markup;
  final Function(Uri uriToPost, {dynamic dataToPost, String successMessage}) postFunction;


  @override
  Widget build(BuildContext context) {
    String description = markup['description'];
    Map<String, dynamic>  potentialAction = markup['potentialAction'];
    Widget button = PotentialActionButton(
      potentialAction : potentialAction,
      postFunction: postFunction,
    );
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(description),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              button,
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}
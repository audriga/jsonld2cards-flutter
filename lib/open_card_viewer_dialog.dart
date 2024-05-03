library open_card_viewe_dialog;

import 'package:flutter/material.dart';


class OpenCardViewerDialog extends StatelessWidget {
  OpenCardViewerDialog({
    super.key,
  });

  final TextEditingController uidTextController =  TextEditingController();


  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Enter the id for the card you want to render'),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextFormField(
            controller: uidTextController,
            decoration: const InputDecoration(
              labelText: 'cardId',
              hintText: '6479f4f7ab5a9',
            ),
          ),
        ),
        SimpleDialogOption(
          onPressed: (){ Navigator.pop(context, null); },
          child: Text(
            'Cancel',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
        ),
        SimpleDialogOption(
          onPressed: (){
            Navigator.pop(
              context,
              uidTextController.text,
            );},
          child: const Text('View Card'),
        ),
      ],
    );
  }
}
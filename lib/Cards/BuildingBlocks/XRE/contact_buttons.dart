library contact_buttons;

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/trading_party.dart';

class EditContactButton extends StatelessWidget {
  const EditContactButton({
    super.key,
    required this.contact,
    required this.postEditCallback,
  });

  final Contact contact;
  final Function(Contact? contact) postEditCallback;

  @override
  Widget build(BuildContext context) => TextButton(
        onPressed: () {
          FlutterContacts.openExternalEdit(contact.id).then(postEditCallback);
        },
        child: const Text('Kontakt bearbeiten'),
      );
}

class AddContactButton extends StatelessWidget {
  const AddContactButton({
    super.key,
    required this.personData,
    required this.postAddCallback,
  });

  final PartyData? personData;
  final Function(Contact? contact) postAddCallback;

  @override
  Widget build(BuildContext context) => TextButton(
        onPressed: () {
          FlutterContacts.openExternalInsert(
            Contact(
                displayName: personData?.contact.point ?? '',
                // name: Name(first: personData?.contact.point ?? ''),
                organizations: [
                  Organization(company: personData?.name ?? ''),
                ],
                emails: [
                  Email(personData?.contact.emailAddress ?? '',
                      customLabel: 'xrechnung-seller-person'),
                  Email(personData?.electronicAddress ?? '',
                      customLabel: 'xrechnung-seller'),
                ]),
          ).then(postAddCallback);
        },
        child: const Text('Zu Kontakten hinzufügen'),
      );
}

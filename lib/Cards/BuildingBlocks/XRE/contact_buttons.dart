library contact_buttons;

import 'dart:typed_data';

import 'package:enough_mail/src/mail_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/trading_party.dart';
import 'package:http/http.dart' as http;

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
    required this.tryFavIcon,
    required this.senderAddress,
  });

  final PartyData? personData;
  final Function(Contact? contact) postAddCallback;
  final bool tryFavIcon;
  final MailAddress? senderAddress;

  @override
  Widget build(BuildContext context) => TextButton(
        onPressed: () async {
          Uint8List? iconBytes;
          if (tryFavIcon && senderAddress != null) {
            var hostName = senderAddress!.hostName;
            var ico = Uri.tryParse('https://icons.duckduckgo.com/ip3/$hostName.ico');
            if (ico != null) {
              var response = await http.get(ico);
              if (response.statusCode == 200) {
                iconBytes = response.bodyBytes;
              }
            }
          }
          var contactPointName = personData?.contact.point;
          var contactPointNameParts = contactPointName?.split(' ');
          var first = contactPointNameParts?.firstOrNull;
          String? last;
          String? middle;
          if ((contactPointNameParts?.length?? 0) > 1) {
            last = contactPointNameParts!.last;
            if (contactPointNameParts > 2) {
              middle = contactPointNameParts.sublist(1, contactPointNameParts.length -1).join(' ');
            }
          }
          var contact = Contact(
                photo: iconBytes,
                displayName: contactPointName ?? '',
                name: Name(first: first ?? '', middle: middle??'', last: last??''),
                organizations: [
                  Organization(company: personData?.name ?? ''),
                ],
                emails: [
                  Email(personData?.contact.emailAddress ?? '',
                      customLabel: 'xrechnung-seller-person'),
                  Email(personData?.electronicAddress ?? '',
                      // todo make this equivalent for buyer
                      customLabel: 'xrechnung-seller'),
                ],
          );
          var inserted = await FlutterContacts.insertContact(contact);
          FlutterContacts.openExternalEdit(inserted.id,).then(postAddCallback);
        },
        child: const Text('Zu Kontakten hinzufügen'),
      );
}

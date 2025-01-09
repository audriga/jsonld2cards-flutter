library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:enough_mail/codecs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/trading_party.dart';
import 'package:http/http.dart' as http;
import 'package:jsonld2cards/l10n/app_localizations.dart';
import 'package:logging/logging.dart';

final log = Logger('jsonld2cards.contact_buttons');

class EditContactButton extends StatelessWidget {
  const EditContactButton({
    super.key,
    required this.contact,
    required this.postEditCallback,
  });

  final Contact contact;
  final Function(Contact? contact) postEditCallback;

  @override
  Widget build(BuildContext context) {
    AppLocalizations l = AppLocalizations.of(context);
    return TextButton(
      onPressed: () {
        FlutterContacts.openExternalEdit(contact.id).then(postEditCallback);
      },
      child: Text(l.editContact),
    );
  }
}


class ViewContactButton extends StatelessWidget {
  const ViewContactButton({
    super.key,
    required this.contact,
    required this.postViewCallback,
  });

  final Contact contact;
  final Null Function(dynamic value)  postViewCallback;

  @override
  Widget build(BuildContext context) {
    AppLocalizations l = AppLocalizations.of(context);
    return TextButton(
      onPressed: () {
        FlutterContacts.openExternalView(contact.id).then(postViewCallback);
      },
      child: Text(l.viewContact),
    );
  }
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
  Widget build(BuildContext context) {
    AppLocalizations l = AppLocalizations.of(context);
    return TextButton(
      onPressed: () async {
        Uint8List? iconBytes;
        if (tryFavIcon && senderAddress != null) {
          var hostName = senderAddress!.hostName;
          var ico = Uri.tryParse(
              'https://icons.duckduckgo.com/ip3/$hostName.ico');
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
        if ((contactPointNameParts?.length ?? 0) > 1) {
          last = contactPointNameParts!.last;
          if (contactPointNameParts.length > 2) {
            middle = contactPointNameParts.sublist(
                1, contactPointNameParts.length - 1).join(' ');
          }
        }
        var contact = Contact(
            photo: iconBytes,
            displayName: contactPointName ?? '',
            name: Name(
                first: first ?? '', middle: middle ?? '', last: last ?? ''),
            organizations: [
              Organization(company: personData?.name ?? ''),
            ],
            emails: [
              Email(personData?.contact.emailAddress ?? '',
                  label: EmailLabel.custom,
                  customLabel: 'xrechnung-${personData?.party.name}'),
              Email(personData?.electronicAddress ?? '',
                  label: EmailLabel.custom,
                  // todo make this equivalent for buyer
                  customLabel: 'xrechnung-${personData?.party.name}'),
            ],
            groups: [Group('', 'xrechnung-seller')],
            sourceId: 'xre',
            notes: [Note('XRE ${personData?.party.name}')]
        );
        var inserted = await FlutterContacts.insertContact(contact);
        var c = await FlutterContacts.getContact(
            inserted.id, deduplicateProperties: false,
            withGroups: true,
            withProperties: true,
            withAccounts: true,
            withPhoto: true,
            withThumbnail: true);
        JsonEncoder encoder = const JsonEncoder.withIndent('  ');
        String prettyprint = encoder.convert(c?.toJson());
        log.fine('Saving contact with these parameters $prettyprint');
        FlutterContacts.openExternalEdit(inserted.id,).then(postAddCallback);
      },
      child: Text(l.addToContacts),
    );
  }
}

library contact_avatar;

import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/trading_party.dart';

class ContactAvatar extends StatelessWidget {
  const ContactAvatar(
      {super.key,
      required this.contacts,
      required this.partyData,
      required this.fallback,
      required this.tryFavIcon,
      this.senderAddress,
      });

  // todo: warning, if email isn't same as smime validated email
  final List<Contact> contacts;
  final PartyData? partyData;
  final Widget fallback;
  final bool tryFavIcon; // try to use favicon from mail address
  final MailAddress? senderAddress;

  @override
  Widget build(BuildContext context) {
    if (partyData == null) {
      return fallback;
    }
    for (var contact in contacts) {
      Iterable<String> contactMailAddresses =
          contact.emails.map((m) => m.address);
      if (contactMailAddresses.contains(partyData!.electronicAddress) ||
          contactMailAddresses.contains(partyData!.contact.emailAddress)) {
        // todo fetch photo here as opposed to loading all contacts with photos
        if (contact.photoOrThumbnail != null) {
          return CircleAvatar(
            backgroundImage: MemoryImage(contact.photoOrThumbnail!),
          );
        }
      }
    }
    if (tryFavIcon && senderAddress != null) {
      var hostName = senderAddress!.hostName;
      var ico = 'https://icons.duckduckgo.com/ip3/$hostName.ico';
      return CircleAvatar(
        backgroundImage: NetworkImage(ico),
      );
        }
    return fallback;
  }
}

library;

import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/trading_party.dart';
import 'package:jsonld2cards/card_data.dart';
import 'package:jsonld2cards/sml_app_context.dart';
import 'package:logging/logging.dart';

final log = Logger('jsonld2cards.cards.xre.contact_avatar');

class ContactAvatar extends StatelessWidget {
  const ContactAvatar({
    super.key,
    required this.contacts,
    required this.partyData,
    required this.fallback,
    // required this.tryFavIcon,
    this.senderAddress,
  });

  // todo: warning, if email isn't same as smime validated email
  final List<Contact> contacts;
  final PartyData? partyData;
  final Widget fallback;
  // final bool tryFavIcon; // try to use favicon from mail address
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
    return getFavIconAvatar();
  }

  Widget getFavIconAvatar() {
    String? ico = getFavIconAddress(partyData!);
    if (ico != null) {
      try {
        return CircleAvatar(
          backgroundImage: NetworkImage(ico),
        );
      } catch (e) {
        log.warning('Failed networkImage, falling back', e);
        return fallback;
      }
    }
    return fallback;
  }
}

class MailAvatar extends StatefulWidget {
  const MailAvatar({super.key, required this.cardData});
  final CardData cardData;

  @override
  State<MailAvatar> createState() => _MailAvatarState();
}

class _MailAvatarState extends State<MailAvatar> {
  late Future<Contact?> futureContact = _findContact();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var textStyle = theme.textTheme.bodySmall;
    double fontSize = textStyle?.fontSize ?? 12;
    var avatarRadius = fontSize / 2;
    // var senderDKIMValid = dkimHeaderValid(widget.message);
    var senders = widget.cardData.message!.decodeSender();
    var sender = senders.firstOrNull;
    var personalName = sender?.personalName;
    Widget avatarBase;
    if (personalName != null) {
      var nameAbbr =
      personalName.split(' ').map((e) => e.substring(0, 1)).join();
      if (nameAbbr.length > 3) {
        nameAbbr = nameAbbr.substring(0, 4);
      }
      avatarBase = Text(
        nameAbbr,
        style: TextStyle(fontSize: avatarRadius * 1.2

          /// nameAbbr.length,
        ),
      );
    } else {
      avatarBase = Icon(
        Icons.person,
        size: avatarRadius * 1.2,
      );
    }
    var fallbackAvatar = CircleAvatar(
      backgroundColor: theme.hintColor,
      radius: avatarRadius,
      child: avatarBase,
    );
    var dkimValid = widget.cardData.dkimValid;
    var sMimeNotInvalid = !widget.cardData.sMimeInvalid;
    var sMimeValid = widget.cardData.sMimeValid;
    var dkimNotInvalid = !widget.cardData.dkimInvalid;
    if (((dkimValid && sMimeNotInvalid) || (sMimeValid && dkimNotInvalid))  && sender != null) {
      return FutureBuilder(
        future: futureContact,
        builder: (context, snapshot) =>
        switch (snapshot.connectionState) {
          ConnectionState.done =>
              Builder(builder: (context) {
                var contact = snapshot.data;
                if (contact != null && contact.photoOrThumbnail != null) {
                  return CircleAvatar(
                    backgroundImage: MemoryImage(contact.photoOrThumbnail!),
                    radius: avatarRadius,
                  );
                }
                if (['rechnungsversand@lexoffice.de', 'noreply@sevdesk.de'].contains(sender.email)) {
                  var hostName = sender.hostName;
                  var ico = 'https://icons.duckduckgo.com/ip3/$hostName.ico';
                  try {
                    return CircleAvatar(
                      backgroundImage: NetworkImage(ico),
                      radius: avatarRadius,
                    );
                  } catch (e) {
                    log.warning('Failed networkImage, falling back', e);
                    return fallbackAvatar;
                  }
                } else {
                  return fallbackAvatar;
                }
              }),
          _ => fallbackAvatar
        },
      );
    } else {
      return fallbackAvatar;
    }
  }

  Future<Contact?> _findContact() async {
    var senders = widget.cardData.message!.decodeSender();
    var sender = senders.firstOrNull;
    if (sender == null ||
        globalSMLAppContext == null ||
        globalSMLAppContext!.contactList == null) {
      return null;
    }
    var contacts = await globalSMLAppContext!.contactList!();
    for (var contact in contacts) {
      Iterable<String> contactMailAddresses =
      contact.emails.map((m) => m.address);
      if (contactMailAddresses.contains(sender.email)) {
        // todo potentially load photo for avatar here
        return contact;
      }
    }
    return null;
  }
}


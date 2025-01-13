library;

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/contact_avatar.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/contact_buttons.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/trading_party.dart';
import 'package:jsonld2cards/card_data.dart';
import 'package:jsonld2cards/sml_app_context.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonTile extends StatefulWidget {
  const PersonTile({
    super.key,
    required this.title,
    // required this.organization,
    required this.personData,
    required this.subCardColor,
    required this.descriptionPadding,
    this.big = true,
    this.invoiceId,
    required this.cardData,
  });

  final String title;

  // final Organization? organization;
  final PartyData? personData;
  final Color subCardColor;
  final EdgeInsetsGeometry descriptionPadding;
  final bool big;
  final String? invoiceId;
  final CardData cardData;

  @override
  State<PersonTile> createState() => _PersonTileState();
}

class _PersonTileState extends State<PersonTile> {
  late Future<Contact?> contact = _findContact();

  // for mailto
  @override
  Widget build(BuildContext context) {
    // todo MOCK put bool smime valid into carddata
    // bool smimeValid = true;
    // todo detect if empty?
    var theme = Theme.of(context);
    Widget? nameRendered;
    String? nameAbbr;
    Widget avatarBase;
    if (widget.personData?.name != null) {
      var name = '${widget.personData?.name}';
      String? tradingName = widget.personData?.tradingName;
      nameRendered = Text.rich(
          TextSpan(children: [
            TextSpan(
              text: name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (tradingName != null) TextSpan(text: '\n($tradingName)')
          ]),
          style: widget.big
              ? theme.textTheme.titleMedium
              : theme.textTheme.titleSmall);
      nameAbbr = name.split(' ').map((e) => e.substring(0, 1)).join();
      if (nameAbbr.length > 3) {
        nameAbbr = nameAbbr.substring(0, 4);
      }
      avatarBase = Text(
        nameAbbr,
        style: widget.big ? null : theme.textTheme.labelSmall,
        overflow: TextOverflow.clip,
        softWrap: false,
        maxLines: 1,
      );
    } else {
      avatarBase = Icon(
        Icons.person,
        size: widget.big ? null : theme.textTheme.labelSmall?.fontSize,
      );
    }
    Widget fallbackAvatar = CircleAvatar(
      backgroundColor: Colors.blue,
      maxRadius:
          widget.big ? null : (theme.textTheme.labelSmall?.fontSize ?? 16) + 4,
      child: avatarBase,
    );
    Widget avatar;

    var isSeller = widget.personData?.party == PartyType.seller;
    var isBuyer = widget.personData?.party == PartyType.buyer;
    var dkimValid = widget.cardData.dkimValid;
    var sMimeNotInvalid = !widget.cardData.sMimeInvalid;
    var sMimeValid = widget.cardData.sMimeValid;
    var dkimNotInvalid = !widget.cardData.dkimInvalid;
    var tryFavIcon = ((dkimValid && sMimeNotInvalid) || (sMimeValid && dkimNotInvalid));
    if ((isSeller || isBuyer) && tryFavIcon) {
      var pictureAvatar = FutureBuilder(
        future: contact,
        builder: (context, snapshot) => switch (snapshot.connectionState) {
          ConnectionState.done => ContactAvatar(
                  contacts: [snapshot.data].nonNulls.toList(),
                  partyData: widget.personData,
                  fallback: fallbackAvatar,
                  senderAddress: widget.cardData.message?.decodeSender().firstOrNull,
                ),
          _ => fallbackAvatar
        },
      );
      avatar = pictureAvatar;
      // Removed Verified badge for now
      // if (isValidSeller) {
      //   avatar = Badge(
      //     label: const Icon(Icons.verified),
      //     backgroundColor: Colors.transparent,
      //     child: pictureAvatar,
      //   );
      // } else {
      //   avatar = pictureAvatar;
      // }
    } else {
      avatar = fallbackAvatar;
    }
    Widget? addressRendered;
    String? addressText;
    if (widget.personData?.postalAddress != null) {
      // List<TextSpan> sellerSpans = [];
      addressText = renderAddressText(widget.personData!.postalAddress);
      addressRendered = Text.rich(TextSpan(text: addressText.trim()));
    }

    return Card(
      elevation: 0,
      color: widget.subCardColor,
      // surfaceTintColor: Colors.green,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: widget.descriptionPadding,
            child: Text(widget.title, style: TextStyle(color: theme.hintColor)),
          ),
          widget.big
              ? ExpansionTile(
                  leading: avatar,
                  title: nameRendered ?? const Text(''),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  expandedAlignment: Alignment.topLeft,
                  children: [
                    if (widget.personData?.contact.telephoneNumber
                        case String telephone)
                      InkWell(
                        onTap: () {
                          launchUrl(Uri(scheme: 'tel', path: telephone));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(telephone),
                        ),
                      ),
                    if (widget.personData?.contact.emailAddress
                        case String email)
                      InkWell(
                        onTap: () {
                          launchUrl(Uri(
                            scheme: 'mailto',
                            path: email,
                            queryParameters: (widget.invoiceId != null)
                                ? {'subject': widget.invoiceId}
                                : null,
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(email),
                        ),
                      ),
                    if (addressRendered != null) InkWell(
                      onTap: (){
                        launchUrl(Uri(
                          scheme: 'geo',
                          queryParameters: {
                            'q': addressText,
                          }
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: addressRendered,
                      ),
                    ),
                    if ([PartyType.seller, PartyType.buyer].contains(widget.personData?.party))
                      FutureBuilder(
                        future: contact,
                        builder: (context, snapshot) =>
                            switch (snapshot.connectionState) {
                          ConnectionState.done => snapshot.hasData
                              ? ViewContactButton(
                                  contact: snapshot.data!,
                                  postViewCallback: (value) => refreshContact(null),
                                )
                              : AddContactButton(
                                  personData: widget.personData,
                                  tryFavIcon: tryFavIcon,
                                  postAddCallback: refreshContact),
                          _ => AddContactButton(
                              personData: widget.personData,
                              tryFavIcon: tryFavIcon,
                              postAddCallback: refreshContact)
                        },
                      ),
                  ],
                )
              : ListTile(
                  leading: avatar,
                  title: nameRendered ?? const Text(''),
                ),
          // if (big) Align(
          //   alignment: Alignment.topRight,
          //   child: Wrap(
          //     alignment: WrapAlignment.end,
          //     children: <Widget>[
          //       IconButton(
          //           onPressed: () {}, icon: const Icon(Icons.add_circle)),
          //       if (personData?.contact.telephoneNumber case String telephone)
          //         IconButton(
          //             onPressed: () {
          //               launchUrl(Uri(scheme: 'tel', path: telephone));
          //             },
          //             icon: const Icon(Icons.call)),
          //       if (personData?.contact.emailAddress case String email)
          //         IconButton(
          //             onPressed: () {
          //               launchUrl(Uri(
          //                 scheme: 'mailto',
          //                 path: email,
          //                 queryParameters: (invoiceId != null )? {'subject': invoiceId} : null,
          //               ));
          //             },
          //             icon: const Icon(Icons.email)),
          //     ],
          //   ),
          // ),
          // PotentialActionRow(potentialAction: potentialAction, postFunction: postFunction)
        ],
      ),
    );
  }

  refreshContact(editedContact) {
    // refresh whole of globalContext.refreshContacts?
    if (globalSMLAppContext?.reloadContacts != null) {
      globalSMLAppContext!.reloadContacts!();
    }
    if (editedContact == null) {
      setState(() {
        contact = _findContact();
      });
      return;
    }
    setState(() {
      contact = FlutterContacts.getContact(editedContact.id,
          deduplicateProperties: false,
          withThumbnail: true,
          withGroups: true,
          withProperties: true,
          withAccounts: true,
          withPhoto: true);
    });
  }

  Future<Contact?> _findContact() async {
    var partyData = widget.personData;
    if (partyData == null ||
        globalSMLAppContext == null ||
        globalSMLAppContext!.contactList == null) {
      return null;
    }
    var contacts = await globalSMLAppContext!.contactList!();
    for (var contact in contacts) {
      Iterable<String> contactMailAddresses =
          contact.emails.map((m) => m.address);
      if (contactMailAddresses.contains(partyData.electronicAddress) ||
          contactMailAddresses.contains(partyData.contact.emailAddress)) {
        // todo potentially load photo for avatar here
        return contact;
      }
    }
    return null;
  }
}

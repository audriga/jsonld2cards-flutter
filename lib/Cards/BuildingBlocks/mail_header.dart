library mail_header;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/card_data.dart';

class MailHeader extends StatelessWidget {
  const MailHeader(this.cardData, {super.key});

  final CardData cardData;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    const insets = EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0);
    var senders = cardData.message?.decodeSender();
    var sender = senders?.firstOrNull;
    var personalName = sender?.personalName;
    Widget avatarBase;
    if (personalName != null) {
      var nameAbbr =
          personalName.split(' ').map((e) => e.substring(0, 1)).join();
      avatarBase = Text(nameAbbr, style: const TextStyle(fontSize: 12),);
    } else {
      avatarBase = const Icon(Icons.person, size: 12,);
    }
    var avatar = Padding(
      padding: insets,
      child: CircleAvatar(
        backgroundColor: theme.hintColor,
        radius: 10,
        child: avatarBase,
      ),
    );

    Widget? senderRendered;
    Widget? senderWithAvatar;

    String? senderMail = sender?.email;
    if (senderMail != null) {
      if (personalName != null && personalName != senderMail) {
        senderRendered = Flexible(child: Text('$personalName<$senderMail>', overflow: TextOverflow.ellipsis,));
      } else {
        senderRendered = Flexible(child: Text(senderMail, overflow: TextOverflow.ellipsis,));
      }
      senderWithAvatar = Padding(
        padding: insets,
        child: Row(children: [avatar, senderRendered],),
      );
    }

    Widget? subjectRendered;
    if (cardData.message?.decodeSubject() case String subject) {
      subjectRendered = Padding(
        padding: insets,
        child: Text(subject, overflow: TextOverflow.ellipsis,maxLines: 1,),
      );
    }

    Widget? dateRendered;
    if (cardData.message?.decodeDate() case DateTime date) {
      dateRendered = Padding(
        padding: insets,
        child: Text('${date.day}.${date.month}.${date.year}'),
      );
    }


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Padding(
              padding: insets,
              child: Icon(Icons.mail),
            ),
            if (dateRendered != null) dateRendered,
            if (senderWithAvatar!= null) Flexible(child: senderWithAvatar),
            // if (subjectRendered != null) subjectRendered,
          ],
        ),
        if (subjectRendered != null) subjectRendered,
        // if (senderWithAvatar!= null) senderWithAvatar,
      ],
    );
  }
}

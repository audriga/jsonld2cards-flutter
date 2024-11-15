library mail_header;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/card_data.dart';

class MailHeader extends StatelessWidget {
  const MailHeader(this.cardData, {super.key});

  final CardData cardData;

  @override
  Widget build(BuildContext context) {
    const insets = EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0);
    var senders = cardData.message?.decodeSender();
    var sender = senders?.firstOrNull;
    var personalName = sender?.personalName;
    Widget avatarBase;
    if (personalName != null) {
      var nameAbbr =
          personalName.split(' ').map((e) => e.substring(0, 1)).join();
      avatarBase = Text(nameAbbr);
    } else {
      avatarBase = const Icon(Icons.person);
    }
    var avatar = Padding(
      padding: insets,
      child: CircleAvatar(
        backgroundColor: Colors.blue,
        maxRadius: 12,
        child: avatarBase,
      ),
    );

    Widget? senderRendered;
    Widget? senderWithAvatar;

    String? senderMail = sender?.email;
    if (senderMail != null) {
      if (personalName != null && personalName != senderMail) {
        senderRendered = Expanded(child: Text('$personalName<$senderMail>', overflow: TextOverflow.fade,));
      } else {
        senderRendered = Text(senderMail, overflow: TextOverflow.fade,);
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
        child: Text(subject, overflow: TextOverflow.fade,),
      );
    }

    Widget? dateRendered;
    if (cardData.message?.decodeDate() case DateTime date) {
      dateRendered = Padding(
        padding: insets,
        child: Text('${date.day}.${date.month}.${date.year}'),
      );
    }


    return Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          alignment: WrapAlignment.start,
          clipBehavior: Clip.hardEdge,
          children: [
            const Padding(
              padding: insets,
              child: Icon(Icons.mail),
            ),
            if (subjectRendered != null) subjectRendered,
            if (senderWithAvatar!= null) senderWithAvatar,
            if (dateRendered != null) dateRendered,
          ],
        ));
  }
}

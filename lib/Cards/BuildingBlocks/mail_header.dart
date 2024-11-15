library mail_header;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/card_data.dart';

class MailHeader extends StatefulWidget {
  const MailHeader(this.cardData, {super.key, this.expandable = false});

  final CardData cardData;
  final bool expandable;

  @override
  State<MailHeader> createState() => _MailHeaderState();
}

class _MailHeaderState extends State<MailHeader> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var textStyle =
        _expanded ? theme.textTheme.titleLarge : theme.textTheme.bodySmall;
    // var iconStyle = theme.ico
    double fontSize = textStyle?.fontSize ?? 12;
    var avatarRadius = fontSize / 2;
    const insets = EdgeInsets.symmetric(horizontal: 4.0, vertical: 0);
    var senders = widget.cardData.message?.decodeSender();
    var sender = senders?.firstOrNull;
    var personalName = sender?.personalName;
    Widget avatarBase;
    if (personalName != null) {
      var nameAbbr =
          personalName.split(' ').map((e) => e.substring(0, 1)).join();
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
    var avatar = Padding(
      padding: insets,
      child: CircleAvatar(
        backgroundColor: theme.hintColor,
        radius: avatarRadius,
        child: avatarBase,
      ),
    );

    Widget? senderRendered;
    Widget? senderWithAvatar;

    String? senderMail = sender?.email;
    if (senderMail != null) {
      if (personalName != null && personalName != senderMail) {
        senderRendered = Flexible(
          child: Text(
            '$personalName<$senderMail>',
            overflow: _expanded? null : TextOverflow.ellipsis,
            style: textStyle,
            softWrap: _expanded,
          ),
        );
      } else {
        senderRendered = Flexible(
          child: Text(
            senderMail,
            overflow: _expanded? null : TextOverflow.ellipsis,
            style: textStyle,
            softWrap: _expanded,
          ),
        );
      }
      senderWithAvatar = Padding(
        padding: insets,
        child: Row(
          children: [avatar, senderRendered],
        ),
      );
    }

    Widget? subjectRendered;
    if (widget.cardData.message?.decodeSubject() case String subject) {
      subjectRendered = Padding(
        padding: insets,
        child: Text(
          subject,
          overflow: _expanded? null : TextOverflow.ellipsis,
          maxLines: _expanded ? null : 1,
          style: textStyle,
          softWrap: _expanded,
        ),
      );
    }

    Widget? dateRendered;
    if (widget.cardData.message?.decodeDate() case DateTime date) {
      dateRendered = Padding(
        padding: insets,
        child: Text(
          '${date.day}.${date.month}.${date.year}',
          style: textStyle,
        ),
      );
    }

    return InkWell(
      onTap: () => setState(() {
        _expanded = !_expanded;
      }),
      child: _expanded
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: insets,
                      child: Icon(
                        Icons.mail,
                        size: fontSize + 2,
                      ),
                    ),
                    if (dateRendered != null) dateRendered,

                    // if (subjectRendered != null) subjectRendered,
                  ],
                ),if (senderWithAvatar != null) senderWithAvatar,
                if (subjectRendered != null) subjectRendered,
                // if (senderWithAvatar!= null) senderWithAvatar,
              ],
            )
          : SmallMailHeader(
              insets: insets,
              fontSize: fontSize,
              dateRendered: dateRendered,
              senderWithAvatar: senderWithAvatar,
              subjectRendered: subjectRendered,
            ),
    );
  }
}

class SmallMailHeader extends StatelessWidget {
  const SmallMailHeader({
    super.key,
    required this.insets,
    required this.fontSize,
    required this.dateRendered,
    required this.senderWithAvatar,
    required this.subjectRendered,
  });

  final EdgeInsets insets;
  final double fontSize;
  final Widget? dateRendered;
  final Widget? senderWithAvatar;
  final Widget? subjectRendered;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: insets,
                child: Icon(
                  Icons.mail,
                  size: fontSize + 2,
                ),
              ),
              if (dateRendered != null) dateRendered!,
              if (senderWithAvatar != null) Flexible(child: senderWithAvatar!),
              // if (subjectRendered != null) subjectRendered,
            ],
          ),
          if (subjectRendered != null) subjectRendered!,
          // if (senderWithAvatar!= null) senderWithAvatar,
        ],
      ),
    );
  }
}

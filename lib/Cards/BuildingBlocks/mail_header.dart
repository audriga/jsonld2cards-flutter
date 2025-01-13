library;

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/contact_avatar.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/hints.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/split_button.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/attachment_header.dart';
import 'package:jsonld2cards/card_data.dart';
import 'package:jsonld2cards/sml_app_context.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MailHeader extends StatefulWidget {
  const MailHeader(this.cardData,
      {super.key,
      this.expandable = false,
      this.constraints = const BoxConstraints(maxHeight: 200),
      this.fullDisplay = false});

  final CardData cardData;
  final bool expandable;
  final BoxConstraints? constraints;
  final bool fullDisplay; // can only be expanded,

  @override
  State<MailHeader> createState() => _MailHeaderState();
}

class _MailHeaderState extends State<MailHeader> {
  late bool _expanded = widget
      .fullDisplay; // starting with false, except when full display is wanted
  late final WebViewController? controller;
  late final String? plainText;

  @override
  void initState() {
    super.initState();
    var htmlPart = widget.cardData.message?.decodeTextHtmlPart();
    plainText = widget.cardData.message?.decodeTextPlainPart();
    if (htmlPart != null &&
        !kIsWeb &&
        (Platform.isAndroid || Platform.isIOS || Platform.isMacOS)) {
      controller = WebViewController()
        ..loadHtmlString(
          htmlPart,
        );
    } else {
      controller = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var footerButtons = [
      if (widget.cardData.message != null)
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
              onPressed: () async {
                await deleteMessage(widget.cardData.message!, context);
              },
              icon: const Icon(Icons.delete)),
        ),
      if (widget.cardData.message != null)
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
              onPressed: () async {
                await archiveMessage(widget.cardData.message!, context);
              },
              icon: const Icon(Icons.archive)),
        ),
    ];
    ThemeData theme = Theme.of(context);
    var textStyle = theme.textTheme.bodySmall;
    // var textStyle = _expanded ? theme.textTheme.titleLarge : theme.textTheme.bodySmall;

    double fontSize = textStyle?.fontSize ?? 12;
    const insets = EdgeInsets.symmetric(horizontal: 4.0, vertical: 0);
    var senders = widget.cardData.message?.decodeSender();
    var sender = senders?.firstOrNull;
    Widget? avatar;
    if (widget.cardData.message != null) {
      avatar = Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: MailAvatar(cardData: widget.cardData, ),
      );
    }

    Widget? senderRendered;
    Widget? senderWithAvatar;

    String? senderMail = sender?.email;
    if (senderMail != null) {
      // if (personalName != null && personalName != senderMail) {
      //   senderRendered = Flexible(
      //     child: Text(
      //       '$personalName<$senderMail>',
      //       overflow: _expanded ? null : TextOverflow.ellipsis,
      //       style: textStyle,
      //       softWrap: _expanded,
      //     ),
      //   );
      // } else {
        senderRendered = Flexible(
          child: Text(
            senderMail,
            overflow: _expanded ? null : TextOverflow.ellipsis,
            style: textStyle,
            softWrap: _expanded,
          ),
        );
      // }
        Widget? sMimeLock;
        if (widget.cardData.sMimeValid) {
          sMimeLock = Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: Icon(Icons.lock, size: fontSize * 0.6,),
          );
        }
      senderWithAvatar = Padding(
        padding: insets,
        child: Row(
          children: [avatar, sMimeLock, senderRendered].nonNulls.toList(),
        ),
      );
    }

    Widget? subjectRendered;
    if (widget.cardData.message?.decodeSubject() case String subject) {
      subjectRendered = Padding(
        padding: insets,
        child: Text(
          subject,
          overflow: _expanded ? null : TextOverflow.ellipsis,
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
    bool showWebView = (controller != null);
    bool showPlainText = (!showWebView && plainText != null);
    var smallMailHeader = SmallMailHeader(
      insets: insets,
      fontSize: fontSize,
      dateRendered: dateRendered,
      senderWithAvatar: senderWithAvatar,
      subjectRendered: subjectRendered,
      cardData: widget.cardData,
    );
    var bigMailHeader = LayoutBuilder(builder: (context, constraints) {
      var smaller = BoxConstraints(
          maxWidth: constraints.maxWidth,
          maxHeight: constraints.maxHeight - 200);
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
                if (dateRendered != null) dateRendered,
                // if (subjectRendered != null) subjectRendered,
              ],
            ),
            if (senderWithAvatar != null) senderWithAvatar,
            if (subjectRendered != null) subjectRendered,
            HintsHeader(hints: widget.cardData.hints),
            if (widget.cardData.otherAttachments != null) HintsHeader(hints: widget.cardData.otherAttachments!.expand((o) => o.hints).toList()),
            const Divider(),
            if (widget.cardData.otherAttachments != null)
              AttachmentHeader(
                sourceFile: null,
                otherAttachments: widget.cardData.otherAttachments,
              ),
            // if (senderWithAvatar!= null) senderWithAvatar,
            if (showWebView)
              ConstrainedBox(
                constraints: widget.constraints ?? smaller,
                child: WebViewWidget(controller: controller!),
              ),
            if (showPlainText) Text(plainText!),
            const Divider(),
            Row(children: footerButtons),
            ForwardButton(
              onTap: (e) {
                forwardMessage(e,widget.cardData.message!, context);
              },
            )
          ],
        ),
      );
    });
    return widget.fullDisplay
        ? bigMailHeader
        : widget.expandable
            ? InkWell(
                onTap: () => setState(() {
                  _expanded = !_expanded;
                }),
                child: _expanded ? bigMailHeader : smallMailHeader,
              )
            : smallMailHeader;
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
    required this.cardData,
  });

  final EdgeInsets insets;
  final double fontSize;
  final Widget? dateRendered;
  final Widget? senderWithAvatar;
  final Widget? subjectRendered;
  final CardData cardData;

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

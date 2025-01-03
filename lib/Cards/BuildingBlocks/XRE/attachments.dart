library attachments;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/card_data.dart';
import 'package:jsonld2cards/sml_app_context.dart';
import 'package:jsonld2cards/l10n/app_localizations.dart';

List<Widget> renderAttachments(CardData cardData, BuildContext context) {
  List<Widget> attachments = [];
  AppLocalizations l = AppLocalizations.of(context);

  if (cardData.markup['bg_24_additional_supporting_documents']
      case List bg24AdditionalSupportingDocuments) {
    Iterable<Map<String, dynamic>> attachmentMaps =
        bg24AdditionalSupportingDocuments
            .whereType<Map<String, dynamic>>()
            .map((e) => e['bt_125_attached_document'])
            .whereType<Map<String, dynamic>>();
    for (Map<String, dynamic> attachmentMap in attachmentMaps) {
      var fileName = attachmentMap['bt_125_2_filename'];
      var bt125Content = attachmentMap['bt_125_content'];
      var bt1251MimeCode = attachmentMap['bt_125_1_mime_code'];
      var attachmentActions = <Widget>[
        if (bt125Content is String && bt125Content.isNotEmpty)
          IconButton(
              onPressed: () {
                globalSMLAppContext!.shareFileCallback!(
                    bt125Content, bt1251MimeCode, fileName);
              },
              icon: const Icon(Icons.share, size: 16)),
        if (bt125Content is String && bt125Content.isNotEmpty)
          IconButton(
              onPressed: () => globalSMLAppContext!.saveFileCallback!(
                  bt125Content, bt1251MimeCode, fileName),
              icon: const Icon(Icons.download, size: 16)),
        IconButton(
            onPressed: () => apiFeedbackDialog(context),
            icon: const Icon(Icons.cloud_upload, size: 16)),
        IconButton(
            onPressed: () {
              if (globalSMLAppContext?.forwardFileCallback != null) {
                globalSMLAppContext!.forwardFileCallback!(bt125Content, bt1251MimeCode, fileName);
              }
            },
            icon: const Icon(Icons.forward_to_inbox, size: 16)),
      ];
      attachments.add(LayoutBuilder(
        builder: (context, constraints) {
          // only 60% for text part
          var filenameConstraints = BoxConstraints(maxWidth:  constraints.maxWidth -  170);
          return Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ConstrainedBox(
                constraints: filenameConstraints,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(fileName, overflow: TextOverflow.ellipsis,),
                ),
              ),
              const Spacer(),
              ...attachmentActions,
            ],
          );
        }
      ));
    }
    for (Attachment attachment in cardData.otherAttachments ?? []) {
      var filename = attachment.filename;
      var attachmentActions = <Widget>[
        if (attachment.data != null)
          IconButton(
              onPressed: () {
                globalSMLAppContext!.shareFileCallback!(
                    attachment.data, attachment.mimeType, filename);
              },
              icon: const Icon(Icons.share, size: 16)),
        if (attachment.data != null)
          IconButton(
              onPressed: () => globalSMLAppContext!.saveFileCallback!(
                  attachment.data, attachment.mimeType, filename),
              icon: const Icon(Icons.download, size: 16)),
        IconButton(
            onPressed: () => apiFeedbackDialog(context),
            icon: const Icon(Icons.cloud_upload, size: 16)),
        IconButton(
            onPressed: () {
              if (globalSMLAppContext?.forwardFileCallback != null) {
                globalSMLAppContext!.forwardFileCallback!(attachment.data, attachment.mimeType, filename);
              }
            },
            icon: const Icon(Icons.forward_to_inbox, size: 16)),
      ];
      attachments.add(Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(filename ?? l.noFileName),
          ),
          const Spacer(),
          ...attachmentActions,
        ],
      ));
    }
  }

  return attachments;
}
void apiFeedbackDialog(BuildContext context) {
  AppLocalizations l = AppLocalizations.of(context);
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l.noApiConfigured),
      content: Text(l.uploadInvoiceToApi),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, l.cancel),
            child: Text(l.cancel)),
        if (globalSMLAppContext?.feedbackCallback != null)
          TextButton(
              onPressed: () {
                globalSMLAppContext!.feedbackCallback!(
                    body: l.apiRequest);
              },
              child: Text(l.sendFeedback))
      ],
    ),
  );
}

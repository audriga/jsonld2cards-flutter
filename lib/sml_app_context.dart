library sml_app_context;

import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

typedef SendEmailCallback = Function(
    {dynamic dataToSend, String? subject, String? recipient});
// todo define this for event/ ical potential actions
typedef EventCallback = Function({Map<String, dynamic> eventData});

typedef ShareAttachmentCallback = Function(int uid, Uri cidOrFetchId,
    {Map<String, dynamic> callbackData});
typedef SaveAttachmentCallback = Function(int uid, Uri cidOrFetchId,
    {Map<String, dynamic> callbackData});
typedef ShareFileCallback = Function(
    dynamic fileData, String? mimeType, String? fileName);
typedef SaveFileCallback = Function(
    dynamic fileData, String? mimeType, String? fileName);
typedef ForwardFileCallback = Function(
    dynamic fileData, String? mimeType, String? fileName);
typedef ForwardEmailAddresses = Future<List<String>> Function();
typedef ForwardEmailCallback = Function(
    String address, MimeMessage emailToForward);
typedef ReloadContacts = Function();
typedef ContactList = Future<List<Contact>> Function();
typedef FeedbackCallback = Function({String? body});
typedef ArchiveMessageCallback = Future<bool> Function(MimeMessage message);
typedef DeleteMessageCallback = Future<DeleteResult> Function(
    MimeMessage message);
typedef RemoveFromMailListCallback = Future<void> Function(MimeMessage message);

SMLAppContext? globalSMLAppContext;

class SMLAppContext {
  // todo document this better
  SendEmailCallback? confirmCallback;
  EventCallback? eventCallback;
  ShareAttachmentCallback? shareAttachmentCallback;
  SaveAttachmentCallback? saveAttachmentCallback;
  ShareFileCallback? shareFileCallback;
  SaveFileCallback? saveFileCallback;
  ForwardFileCallback? forwardFileCallback;
  ForwardEmailAddresses? forwardEmailAddresses;
  ReloadContacts? reloadContacts;
  ContactList? contactList;
  ForwardEmailCallback? forwardEmailCallback;
  FeedbackCallback? feedbackCallback;
  ArchiveMessageCallback? archiveMessageCallback;
  DeleteMessageCallback? deleteMessageCallback;
  RemoveFromMailListCallback? removeFromMailListCallback;

  SMLAppContext({
    this.confirmCallback,
    this.eventCallback,
    this.shareAttachmentCallback,
    this.saveAttachmentCallback,
    this.shareFileCallback,
    this.saveFileCallback,
    this.forwardFileCallback,
    this.forwardEmailAddresses,
    this.forwardEmailCallback,
    this.reloadContacts,
    this.contactList,
    this.feedbackCallback,
    this.archiveMessageCallback,
    this.deleteMessageCallback,
  });
}

void forwardMessage(
    String emailAddress, MimeMessage message, BuildContext context) {
  globalSMLAppContext!.forwardEmailCallback!(emailAddress, message);
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nachricht weitergeleitet')));
  }
  if (globalSMLAppContext?.removeFromMailListCallback != null) {
    globalSMLAppContext!.removeFromMailListCallback!(message);
  }
  if (context.mounted) {
    Navigator.of(context).pop();
  }
}

Future<void> archiveMessage(MimeMessage message, BuildContext context) async {
  if (globalSMLAppContext?.archiveMessageCallback != null) {
    await globalSMLAppContext!.archiveMessageCallback!(message);
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Nachricht archiviert')));
    }
    if (globalSMLAppContext?.removeFromMailListCallback != null) {
      globalSMLAppContext!.removeFromMailListCallback!(message);
    }
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}

Future<void> deleteMessage(MimeMessage message, BuildContext context) async {
  if (globalSMLAppContext?.deleteMessageCallback != null) {
    await globalSMLAppContext!.deleteMessageCallback!(message);
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Nachricht gelöscht')));
    }
    if (globalSMLAppContext?.removeFromMailListCallback != null) {
      globalSMLAppContext!.removeFromMailListCallback!(message);
    }
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}

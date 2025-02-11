library;

import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import 'l10n/app_localizations.dart';

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
typedef ForwardEmailCallback = Future<bool> Function(
    String address, MimeMessage emailToForward);
typedef ReloadContacts = Function();
typedef ContactList = Future<List<Contact>> Function();
typedef FeedbackCallback = Function({String? body});
typedef ArchiveMessageCallback = Future<bool> Function(MimeMessage message);
typedef DeleteMessageCallback = Future<DeleteResult> Function(
    MimeMessage message);
typedef MoveMessageToInboxCallback = Future<bool> Function(MimeMessage message);
typedef RemoveFromMailListCallback = void Function(MimeMessage message);
typedef APIUploadFileCallback = Future<APIUploadResult> Function(
    dynamic fileData,
    String? mimeType,
    String? fileName,
    Map<String, dynamic> invoice);

enum APIUploadResultType { noAPIConfigured, success, failure }

enum APIUploadKnownErrorType {
  badRequest,
  authenticationRequired,
  validationError,
  serverError,
  fileNull,
  //Reason is misconfigured api or one that is not supported by this version yet.
  misconfiguredApi,
}

class APIUploadResult {
  final APIUploadResultType resultType;
  final Object? error;
  final APIUploadKnownErrorType? knownErrorType;

  APIUploadResult(this.resultType, [this.error, this.knownErrorType]);
}

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
  MoveMessageToInboxCallback? moveMessageToInboxCallback;
  RemoveFromMailListCallback? removeFromMailListCallback;
  APIUploadFileCallback? apiUploadFileCallback;

  SMLAppContext(
      {this.confirmCallback,
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
      this.moveMessageToInboxCallback,
      this.deleteMessageCallback,
      this.apiUploadFileCallback});
}

Future<void> forwardMessage(
    String emailAddress, MimeMessage message, BuildContext context) async {
  var forwardSuccess =
      await globalSMLAppContext!.forwardEmailCallback!(emailAddress, message);
  if (context.mounted) {
    AppLocalizations l = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text(forwardSuccess ? l.forwardedEmail : l.couldNotForwardEmail)));
  }
  if (globalSMLAppContext?.removeFromMailListCallback != null) {
    globalSMLAppContext!.removeFromMailListCallback!(message);
  }
  if (context.mounted) {
    Navigator.of(context).pop();
  }
}

Future<void> moveMessageToInbox(
    MimeMessage message, BuildContext context) async {
  if (globalSMLAppContext?.moveMessageToInboxCallback != null) {
    var moveSuccess =
        await globalSMLAppContext!.moveMessageToInboxCallback!(message);
    if (context.mounted) {
      AppLocalizations l = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              moveSuccess ? l.movedMailToInbox : l.couldNotMoveMailToInbox)));
    }
    if (context.mounted) {
      Navigator.of(context).pop();
    }
    if (globalSMLAppContext?.removeFromMailListCallback != null) {
      globalSMLAppContext!.removeFromMailListCallback!(message);
    }
  }
}

Future<void> archiveMessage(MimeMessage message, BuildContext context,
    {bool? snackBar = true}) async {
  if (globalSMLAppContext?.archiveMessageCallback != null) {
    var archiveSuccess =
        await globalSMLAppContext!.archiveMessageCallback!(message);
    if (snackBar ?? true) {
      if (context.mounted) {
        AppLocalizations l = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                archiveSuccess ? l.archivedEmail : l.couldNotArchiveEmail)));
      }
    }
    if (context.mounted) {
      Navigator.of(context).pop();
    }
    if (globalSMLAppContext?.removeFromMailListCallback != null) {
      globalSMLAppContext!.removeFromMailListCallback!(message);
    }
  }
}

Future<void> deleteMessage(MimeMessage message, BuildContext context) async {
  if (globalSMLAppContext?.deleteMessageCallback != null) {
    await globalSMLAppContext!.deleteMessageCallback!(message);
    if (context.mounted) {
      AppLocalizations l = AppLocalizations.of(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.deletedEmail)));
    }
    if (globalSMLAppContext?.removeFromMailListCallback != null) {
      globalSMLAppContext!.removeFromMailListCallback!(message);
    }
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}

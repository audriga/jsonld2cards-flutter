library;

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
typedef ReloadContacts = Function();
typedef ContactList = Future<List<Contact>> Function();
typedef FeedbackCallback = Function({String? body});

SMLAppContext? globalSMLAppContext;

class SMLAppContext {
  // todo document this better
  SendEmailCallback? confirmCallback;
  EventCallback? eventCallback;

  SMLAppContext({
    this.confirmCallback,
    this.eventCallback
  });
}

library sml_app_context;

import 'package:enough_mail/codecs.dart';

typedef SendEmailCallback = Function({dynamic dataToSend, String? subject, String? recipient});
// todo define this for event/ ical potential actions
typedef EventCallback = Function({Map<String, dynamic> eventData});

typedef ShareAttachmentCallback = Function(int uid, Uri cidOrFetchId, {Map<String, dynamic> callbackData});
typedef ShareFileCallback = Function(dynamic fileData, String? mimeType, String? fileName);
typedef SaveFileCallback = Function(dynamic fileData, String? mimeType, String? fileName);
typedef ForwardEmailAddresses = Future<List<String>> Function();
typedef ForwardEmailCallback = Function(String address, MimeMessage emailToForward);

SMLAppContext? globalSMLAppContext;

class SMLAppContext {
  // todo document this better
  SendEmailCallback? confirmCallback;
  EventCallback? eventCallback;
  ShareAttachmentCallback? shareAttachmentCallback;
  ShareFileCallback? shareFileCallback;
  SaveFileCallback? saveFileCallback;
  ForwardEmailAddresses? forwardEmailAddresses;
  ForwardEmailCallback? forwardEmailCallback;

  SMLAppContext({
    this.confirmCallback,
    this.eventCallback,
    this.shareAttachmentCallback,
    this.shareFileCallback,
    this.saveFileCallback,
    this.forwardEmailAddresses,
    this.forwardEmailCallback,
  });
}

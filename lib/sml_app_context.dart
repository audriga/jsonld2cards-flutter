library sml_app_context;

typedef SendEmailCallback = Function({dynamic dataToSend, String? subject, String? recipient});
// todo define this for event/ ical potential actions
typedef EventCallback = Function({Map<String, dynamic> eventData});

typedef ShareAttachmentCallback = Function(int uid, Uri cidOrFetchId, {Map<String, dynamic> callbackData});
typedef ShareFileCallback = Function(dynamic fileData, String? mimeType, String? fileName);
typedef SaveFileCallback = Function(dynamic fileData, String? mimeType, String? fileName);

SMLAppContext? globalSMLAppContext;

class SMLAppContext {
  // todo document this better
  SendEmailCallback? confirmCallback;
  EventCallback? eventCallback;
  ShareAttachmentCallback? shareAttachmentCallback;
  ShareFileCallback? shareFileCallback;
  SaveFileCallback? saveFileCallback;

  SMLAppContext({
    this.confirmCallback,
    this.eventCallback,
    this.shareAttachmentCallback,
    this.shareFileCallback,
    this.saveFileCallback,
  });
}

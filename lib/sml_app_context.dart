library sml_app_context;

typedef SendEmailCallback = Function({dynamic dataToSend, String? subject, String? recipient});
// todo define this for event/ ical potential actions
typedef EventCallback = Function({Map<String, dynamic> eventData});

typedef ShareAttachmentCallback = Function(int uid, String cid, {Map<String, dynamic> callbackData});

SMLAppContext? globalSMLAppContext;

class SMLAppContext {
  // todo document this better
  SendEmailCallback? confirmCallback;
  EventCallback? eventCallback;
  ShareAttachmentCallback? shareAttachmentCallback;

  SMLAppContext({
    this.confirmCallback,
    this.eventCallback,
    this.shareAttachmentCallback,
  });
}

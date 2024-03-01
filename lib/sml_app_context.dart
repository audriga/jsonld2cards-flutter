library sml_app_context;

typedef SendEmailCallback = Function({dynamic dataToSend, String? subject, String? recipient});

SMLAppContext? globalSMLAppContext;

class SMLAppContext {
  // todo document this better
  SendEmailCallback? confirmCallback;

  SMLAppContext({
    this.confirmCallback,
  });
}
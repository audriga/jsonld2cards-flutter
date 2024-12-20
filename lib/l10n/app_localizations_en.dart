import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get forwardButtonLabel => 'Forward';

  @override
  String get noAddressesConfigured => 'No addresses configured';

  @override
  String get reloadContacts => 'Reload contacts';

  @override
  String get ok => 'OK';

  @override
  String get noTargetsConfiguredMessage => 'Invoices can be forwarded to contacts that have an xrechnung email address. Please configure this by adding an email address with the label xrechnung to a contact and allow this app to access contacts.';

  @override
  String get errorTitleNoTargetsConfigured => 'No targets configured';
}

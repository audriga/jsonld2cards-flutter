import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get forwardButtonLabel => 'Nach vorne';

  @override
  String get noAddressesConfigured => 'Keine Adressen konfiguriert';

  @override
  String get reloadContacts => 'Kontakte neu laden';

  @override
  String get ok => 'OK';

  @override
  String get noTargetsConfiguredMessage => 'Rechnungen können an Kontakte weitergeleitet werden, die über eine xrechnung-E-Mail-Adresse verfügen. Bitte konfigurieren Sie dies, indem Sie einem Kontakt eine E-Mail-Adresse mit der Bezeichnung „xrechnung“ hinzufügen und dieser App den Zugriff auf Kontakte erlauben.';

  @override
  String get errorTitleNoTargetsConfigured => 'Keine Ziele konfiguriert';
}

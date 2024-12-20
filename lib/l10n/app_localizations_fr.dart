import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get forwardButtonLabel => 'Transférer';

  @override
  String get noAddressesConfigured => 'Aucune adresse configurée';

  @override
  String get reloadContacts => 'Recharger les contacts';

  @override
  String get ok => 'D‘accord';

  @override
  String get noTargetsConfiguredMessage => 'Les factures peuvent être envoyées à des contacts ayant une adresse e-mail xrechnung. Configurez cela en ajoutant une adresse e-mail avec le label xrechnung à un contact et autorisez cette application à accéder aux contacts.';

  @override
  String get errorTitleNoTargetsConfigured => 'Aucun destinataire configuré';
}

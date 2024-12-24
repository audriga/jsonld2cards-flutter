import 'package:intl/intl.dart' as intl;

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

  @override
  String bt130_IE(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Personnes',
      one: 'Personne',
    );
    return '$_temp0';
  }

  @override
  String bt130_10(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Groupes',
      one: 'Groupe',
    );
    return '$_temp0';
  }

  @override
  String bt130_ROM(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Chambres',
      one: 'Chambre',
    );
    return '$_temp0';
  }

  @override
  String bt130_B17(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Crédits',
      one: 'Crédit',
    );
    return '$_temp0';
  }

  @override
  String bt130_PR(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Paires',
      one: 'Paire',
    );
    return '$_temp0';
  }

  @override
  String bt130_13(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rations',
      one: 'Ration',
    );
    return '$_temp0';
  }

  @override
  String bt130_14(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tirs',
      one: 'Tir',
    );
    return '$_temp0';
  }

  @override
  String bt130_H87(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pièces',
      one: 'Pièce',
    );
    return '$_temp0';
  }

  @override
  String bt130_SET(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ensembles',
      one: 'Ensemble',
    );
    return '$_temp0';
  }

  @override
  String bt130_SG(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Segments',
      one: 'Segment',
    );
    return '$_temp0';
  }

  @override
  String bt130_C62(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Uns',
      one: 'Un',
    );
    return '$_temp0';
  }

  @override
  String bt130_XPP(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Articles en vrac',
      one: 'Article en vrac',
    );
    return '$_temp0';
  }

  @override
  String bt130_NAR(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nombre d\'articles',
      one: 'Nombre d\'article',
    );
    return '$_temp0';
  }

  @override
  String bt130_ZZ(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Définis mutuellement',
      one: 'Défini mutuellement',
    );
    return '$_temp0';
  }

  @override
  String bt130_MMK(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Millimètres carrés',
      one: 'Millimètre carré',
    );
    return '$_temp0';
  }

  @override
  String bt130_MTK(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mètres carrés',
      one: 'Mètre carré',
    );
    return '$_temp0';
  }

  @override
  String bt130_KMK(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kilomètres carrés',
      one: 'Kilomètre carré',
    );
    return '$_temp0';
  }

  @override
  String bt130_INK(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pouces carrés',
      one: 'Pouce carré',
    );
    return '$_temp0';
  }

  @override
  String bt130_C37(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kilobits',
      one: 'Kilobit',
    );
    return '$_temp0';
  }

  @override
  String bt130_INH(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pouces',
      one: 'Pouce',
    );
    return '$_temp0';
  }

  @override
  String bt130_MMT(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Millimètres',
      one: 'Millimètre',
    );
    return '$_temp0';
  }

  @override
  String bt130_MTR(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mètres',
      one: 'Mètre',
    );
    return '$_temp0';
  }

  @override
  String bt130_KMT(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kilomètres',
      one: 'Kilomètre',
    );
    return '$_temp0';
  }

  @override
  String bt130_YRD(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Yards',
      one: 'Yard',
    );
    return '$_temp0';
  }

  @override
  String bt130_MLT(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Millilitres',
      one: 'Millilitre',
    );
    return '$_temp0';
  }

  @override
  String bt130_LTR(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Litres',
      one: 'Litre',
    );
    return '$_temp0';
  }

  @override
  String bt130_HLT(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hectolitres',
      one: 'Hectolitre',
    );
    return '$_temp0';
  }

  @override
  String bt130_AMH(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ampères-heures',
      one: 'Ampère-heure',
    );
    return '$_temp0';
  }

  @override
  String bt130_KWH(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kilowatts-heures',
      one: 'Kilowatt-heure',
    );
    return '$_temp0';
  }

  @override
  String bt130_KWT(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kilowatts',
      one: 'Kilowatt',
    );
    return '$_temp0';
  }

  @override
  String bt130_MAW(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mégawatts',
      one: 'Mégawatt',
    );
    return '$_temp0';
  }

  @override
  String bt130_C26(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Millisecondes',
      one: 'Milliseconde',
    );
    return '$_temp0';
  }

  @override
  String bt130_SEC(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Secondes',
      one: 'Seconde',
    );
    return '$_temp0';
  }

  @override
  String bt130_MIN(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Minutes',
      one: 'Minute',
    );
    return '$_temp0';
  }

  @override
  String bt130_HUR(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Heures',
      one: 'Heure',
    );
    return '$_temp0';
  }

  @override
  String bt130_DAY(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jours',
      one: 'Jour',
    );
    return '$_temp0';
  }

  @override
  String bt130_WEE(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Semaines',
      one: 'Semaine',
    );
    return '$_temp0';
  }

  @override
  String bt130_MON(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mois',
      one: 'Mois',
    );
    return '$_temp0';
  }

  @override
  String bt130_ANN(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ans',
      one: 'An',
    );
    return '$_temp0';
  }

  @override
  String bt130_MMQ(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Millimètres cubes',
      one: 'Millimètre cube',
    );
    return '$_temp0';
  }

  @override
  String bt130_MTQ(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mètres cubes',
      one: 'Mètre cube',
    );
    return '$_temp0';
  }

  @override
  String bt130_INQ(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pouces cubes',
      one: 'Pouce cube',
    );
    return '$_temp0';
  }

  @override
  String bt130_MC(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Microgrammes',
      one: 'Microgramme',
    );
    return '$_temp0';
  }

  @override
  String bt130_MGM(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Milligrammes',
      one: 'Milligramme',
    );
    return '$_temp0';
  }

  @override
  String bt130_GRM(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Grammes',
      one: 'Gramme',
    );
    return '$_temp0';
  }

  @override
  String bt130_KGM(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kilogrammes',
      one: 'Kilogramme',
    );
    return '$_temp0';
  }

  @override
  String bt130_TNE(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tonnes',
      one: 'Tonne',
    );
    return '$_temp0';
  }

  @override
  String bt130_KTN(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kilotonnes',
      one: 'Kilotonne',
    );
    return '$_temp0';
  }

  @override
  String get noApiConfigured => 'Aucune API configurée pour le moment.';

  @override
  String get uploadInvoiceToApi => 'Avec ce bouton, vous pouvez télécharger directement la facture sur l\'API de votre système de facturation. Envoyez-nous vos commentaires et dites-nous quel système de facturation vous souhaitez voir disponible ici.';

  @override
  String get cancel => 'Annuler.';

  @override
  String get apiRequest => 'requête API.';

  @override
  String get sendFeedback => 'Envoyer des commentaires.';

  @override
  String get noFileName => 'Pas de nom de fichier.';

  @override
  String get viewContact => 'Voir le contact.';

  @override
  String get editContact => 'Modifier le contact.';

  @override
  String get addToContacts => 'Ajouter aux contacts.';

  @override
  String get to => 'À';

  @override
  String get deliveryDate => 'Date de livraison';

  @override
  String get invoice => 'Facture';

  @override
  String attachments(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pièces jointes',
      one: 'Pièce jointe',
    );
    return '$_temp0';
  }

  @override
  String get details => 'Détails';

  @override
  String get buyer => 'Acheteur';

  @override
  String get delivery => 'Livraison';

  @override
  String get seller => 'Vendeur';

  @override
  String get servicePeriodFrom => 'Service period from';

  @override
  String get servicePeriodTill => 'Service period until';

  @override
  String get servicePeriod => 'Service Period';

  @override
  String get service => 'Service';

  @override
  String get invoiceItems => 'Invoice items';

  @override
  String get minimize => 'Minimize';

  @override
  String get readMore => 'Read more';

  @override
  String get save => 'save';

  @override
  String get share => 'Share';

  @override
  String get close => 'close';

  @override
  String get additionalInformation => 'Additional Information';

  @override
  String get theXMLFileNotValidXRechnung => 'The XML file is not a valid XRechnung';

  @override
  String get thePDFContainsAnXMLButNotValidXRechnung => 'The PDF contains an XML attachment, but it is not a valid XRechnung';

  @override
  String get thePDFContainsNoAttachments => 'The PDF contains no attachments';

  @override
  String get theEmailContainsNoXRechnungAttachments => 'The email contains no XRechnung attachments';

  @override
  String get theEmailContainsNoXRechnung => 'The email contains no XRechnung';

  @override
  String get theEmailContainsMultipleXRechnungOnlyOneDisplayed => 'The email contains multiple XRechnungen, only one of them is displayed';

  @override
  String get xRechnungTypeBT3Not380 => 'XRechnung type (BT-3) not 380 (Goods/Commercial Invoice)';

  @override
  String get xRechnungSpecificationBT24UnknownUnsupported => 'XRechnung specification (BT-24) unknown or unsupported value';

  @override
  String get xRechnungInUBLFormatNotSupported => 'The XRechnung is in UBL format, which we do not yet support';

  @override
  String get number => 'No.';

  @override
  String get dated => 'dated';

  @override
  String get paid => 'Paid';

  @override
  String get collected => 'Will be collected';

  @override
  String get transfer => 'Transfer';

  @override
  String get open => 'Open';

  @override
  String get other => 'Other';

  @override
  String get refund => 'Refund';

  @override
  String get missing => 'Missing';

  @override
  String get couldNotParseToNumber => 'Could not get parsed to number!';

  @override
  String get notSet => 'Not set!';

  @override
  String get no => 'No';

  @override
  String get couldNotParse => 'Could not parse';

  @override
  String get isMissing => 'is missing';
}

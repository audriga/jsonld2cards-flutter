import 'package:intl/intl.dart' as intl;

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

  @override
  String bt130_IE(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Personen',
      one: 'Person',
    );
    return '$_temp0';
  }

  @override
  String bt130_10(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Gruppen',
      one: 'Gruppe',
    );
    return '$_temp0';
  }

  @override
  String bt130_ROM(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zimmer',
      one: 'Zimmer',
    );
    return '$_temp0';
  }

  @override
  String bt130_B17(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kredite',
      one: 'Kredit',
    );
    return '$_temp0';
  }

  @override
  String bt130_PR(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Paare',
      one: 'Paar',
    );
    return '$_temp0';
  }

  @override
  String bt130_13(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rationen',
      one: 'Ration',
    );
    return '$_temp0';
  }

  @override
  String bt130_14(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Schüsse',
      one: 'Schuss',
    );
    return '$_temp0';
  }

  @override
  String bt130_H87(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Stücke',
      one: 'Stück',
    );
    return '$_temp0';
  }

  @override
  String bt130_SET(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sätze',
      one: 'Satz',
    );
    return '$_temp0';
  }

  @override
  String bt130_SG(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Segmente',
      one: 'Segment',
    );
    return '$_temp0';
  }

  @override
  String bt130_C62(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Einser',
      one: 'Eins',
    );
    return '$_temp0';
  }

  @override
  String bt130_XPP(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lose unverpackte Einheiten',
      one: 'Lose unverpackte Einheit',
    );
    return '$_temp0';
  }

  @override
  String bt130_NAR(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Artikelanzahlen',
      one: 'Artikelanzahl',
    );
    return '$_temp0';
  }

  @override
  String bt130_ZZ(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Gemeinsam definiert',
      one: 'Gemeinsam definiert',
    );
    return '$_temp0';
  }

  @override
  String bt130_MMK(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Quadratmillimeter',
      one: 'Quadratmillimeter',
    );
    return '$_temp0';
  }

  @override
  String bt130_MTK(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Quadratmeter',
      one: 'Quadratmeter',
    );
    return '$_temp0';
  }

  @override
  String bt130_KMK(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Quadratkilometer',
      one: 'Quadratkilometer',
    );
    return '$_temp0';
  }

  @override
  String bt130_INK(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Quadratzoll',
      one: 'Quadratzoll',
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
      other: 'Zoll',
      one: 'Zoll',
    );
    return '$_temp0';
  }

  @override
  String bt130_MMT(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Millimeter',
      one: 'Millimeter',
    );
    return '$_temp0';
  }

  @override
  String bt130_MTR(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Meter',
      one: 'Meter',
    );
    return '$_temp0';
  }

  @override
  String bt130_KMT(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kilometer',
      one: 'Kilometer',
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
      other: 'Milliliter',
      one: 'Milliliter',
    );
    return '$_temp0';
  }

  @override
  String bt130_LTR(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Liter',
      one: 'Liter',
    );
    return '$_temp0';
  }

  @override
  String bt130_HLT(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hektoliter',
      one: 'Hektoliter',
    );
    return '$_temp0';
  }

  @override
  String bt130_AMH(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Amperestunden',
      one: 'Amperestunde',
    );
    return '$_temp0';
  }

  @override
  String bt130_KWH(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kilowattstunden',
      one: 'Kilowattstunde',
    );
    return '$_temp0';
  }

  @override
  String bt130_KWT(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kilowatt',
      one: 'Kilowatt',
    );
    return '$_temp0';
  }

  @override
  String bt130_MAW(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Megawatt',
      one: 'Megawatt',
    );
    return '$_temp0';
  }

  @override
  String bt130_C26(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Millisekunden',
      one: 'Millisekunde',
    );
    return '$_temp0';
  }

  @override
  String bt130_SEC(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sekunden',
      one: 'Sekunde',
    );
    return '$_temp0';
  }

  @override
  String bt130_MIN(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Minuten',
      one: 'Minute',
    );
    return '$_temp0';
  }

  @override
  String bt130_HUR(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Stunden',
      one: 'Stunde',
    );
    return '$_temp0';
  }

  @override
  String bt130_DAY(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tage',
      one: 'Tag',
    );
    return '$_temp0';
  }

  @override
  String bt130_WEE(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wochen',
      one: 'Woche',
    );
    return '$_temp0';
  }

  @override
  String bt130_MON(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Monate',
      one: 'Monat',
    );
    return '$_temp0';
  }

  @override
  String bt130_ANN(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jahre',
      one: 'Jahr',
    );
    return '$_temp0';
  }

  @override
  String bt130_MMQ(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kubikmillimeter',
      one: 'Kubikmillimeter',
    );
    return '$_temp0';
  }

  @override
  String bt130_MTQ(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kubikmeter',
      one: 'Kubikmeter',
    );
    return '$_temp0';
  }

  @override
  String bt130_INQ(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kubikzoll',
      one: 'Kubikzoll',
    );
    return '$_temp0';
  }

  @override
  String bt130_MC(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mikrogramm',
      one: 'Mikrogramm',
    );
    return '$_temp0';
  }

  @override
  String bt130_MGM(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Milligramm',
      one: 'Milligramm',
    );
    return '$_temp0';
  }

  @override
  String bt130_GRM(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Gramm',
      one: 'Gramm',
    );
    return '$_temp0';
  }

  @override
  String bt130_KGM(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kilogramm',
      one: 'Kilogramm',
    );
    return '$_temp0';
  }

  @override
  String bt130_TNE(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tonnen',
      one: 'Tonne',
    );
    return '$_temp0';
  }

  @override
  String bt130_KTN(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kilotonnen',
      one: 'Kilotonne',
    );
    return '$_temp0';
  }

  @override
  String get noApiConfigured => 'Noch keine API Konfiguriert.';

  @override
  String get uploadInvoiceToApi => 'Mit diesen Button könnten Sie die Rechnunng direkt an die API Ihres Rechnungssystem hochladen. Schicken Sie uns Feedback, und sagen Sie uns welches Rechnungssystem Sie hier verfügbar haben wollen.';

  @override
  String get cancel => 'Abbrechen.';

  @override
  String get apiRequest => 'API wunsch.';

  @override
  String get sendFeedback => 'Feedback senden.';

  @override
  String get noFileName => 'Kein Dateiname.';

  @override
  String get viewContact => 'Kontakt ansehen.';

  @override
  String get editContact => 'Kontakt bearbeiten.';

  @override
  String get addToContacts => 'Zu Kontakten hinzufügen.';

  @override
  String get to => 'An';

  @override
  String get deliveryDate => 'Lieferdatum';

  @override
  String get invoice => 'Rechnung';

  @override
  String attachments(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Anhänge',
      one: 'Anhang',
    );
    return '$_temp0';
  }

  @override
  String furtherAttachments(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Weitere Anhänge',
      one: 'Weiterer Anhang',
    );
    return '$_temp0';
  }

  @override
  String get details => 'Details';

  @override
  String get buyer => 'Käufer';

  @override
  String get delivery => 'Lieferung';

  @override
  String get seller => 'Verkäufer';

  @override
  String get servicePeriodFrom => 'Leistungszeitraum von';

  @override
  String get servicePeriodTill => 'Leistungszeitraum bis';

  @override
  String get servicePeriod => 'Leistungsdatum';

  @override
  String get service => 'Leistung';

  @override
  String get invoiceItems => 'Rechnungsposten';

  @override
  String get minimize => 'Minimieren';

  @override
  String get readMore => 'Weiterlesen';

  @override
  String get save => 'Speichern';

  @override
  String get share => 'Teilen';

  @override
  String get close => 'Schließen';

  @override
  String get additionalInformation => 'Zusätzliche Informationen';

  @override
  String get theXMLFileNotValidXRechnung => 'XML datei ist keine gültige XRechung';

  @override
  String get thePDFContainsAnXMLButNotValidXRechnung => 'PDF enthält xml anhang, aber keine gültige XRechnung';

  @override
  String get thePDFContainsNoAttachments => 'PDF enthält keine Anhänge';

  @override
  String get theEmailContainsNonXRechnungAttachments => 'Mail enthält nicht-XRechnung Anhänge';

  @override
  String get theEmailContainsNoXRechnung => 'Mail enthält keine XRechnung';

  @override
  String get theEmailContainsMultipleXRechnungOnlyOneDisplayed => 'Mail enthält mehre XRechnungen, nur eine davon wird angezeigt';

  @override
  String get xRechnungTypeBT3Not380 => 'XRechnungs Typ (BT-3) nicht 380 (Waren-/ Handelsrechnung)';

  @override
  String get xRechnungSpecificationBT24UnknownUnsupported => 'XRechnungs Spezifikation (BT-24) Unbekannter oder nicht unterstützter Wert';

  @override
  String get xRechnungInUBLFormatNotSupported => 'XRechnung ist im UBL-Format, welches wir noch nicht vollständig unterstützen';

  @override
  String get number => 'Nr.';

  @override
  String get dated => 'vom';

  @override
  String get paid => 'Bezahlt';

  @override
  String get collected => 'Wird eingezogen';

  @override
  String get transfer => 'Überweisen';

  @override
  String get open => 'Offen';

  @override
  String get other => 'Anders';

  @override
  String get refund => 'Rückzahlung';

  @override
  String get missing => 'Fehlend';

  @override
  String get couldNotParseToNumber => 'Konnte nicht in eine Zahl umgewandelt werden!';

  @override
  String get notSet => 'Nicht gesetzt!';

  @override
  String get no => 'Nein';

  @override
  String get couldNotParse => 'Konnte nicht geparst werden';

  @override
  String get isMissing => 'fehlt';

  @override
  String get errorInSkontoCalculation => 'Fehler bei der Skontoberechnung';

  @override
  String get dueIn => 'Fällig in ';

  @override
  String get days => 'Tagen';

  @override
  String get willBeCollectedByCard => 'Wird eingezogen von Karte';

  @override
  String get willBeCollectedByAccount => 'Wird eingezogen von Konto';

  @override
  String get cashPayment => 'Barzahlung';

  @override
  String get chequePayment => 'Scheckzahlung';

  @override
  String get paymentToBankAccount => 'Zahlung an Bankkonto';

  @override
  String get existingAgreement => 'Bestehende Vereinbarung';

  @override
  String get onlinePayment => 'Online Zahlung';

  @override
  String get betweenPartnersClarified => 'Zwischen Partnern geklärt';

  @override
  String get mutuallyDefined => 'Einvernehmlich definiert';

  @override
  String get payment => 'Zahlung';

  @override
  String get amountTooHigh => 'Betrag zu hoch';

  @override
  String get noticeXREGeneratedFromPDF => 'Diese Rechnung wurde aus einen Anhang extrahiert';

  @override
  String get sMimeInvalid => 'S/MIME Signatur ist vorhanden, aber ungültig';

  @override
  String get noDKIM => 'Kein DKIM header gefunden';

  @override
  String get forwardedEmail => 'Email weitergeleitet';

  @override
  String get couldNotForwardEmail => 'Konnte Email nicht weiterleiten';

  @override
  String get archivedEmail => 'Emaiil Archiviert';

  @override
  String get couldNotArchiveEmail => 'Konnte Email nicht archivieren';

  @override
  String get deletedEmail => 'Email gelöscht';

  @override
  String get couldNotDeleteEmail => 'Konnte Email nicht löschen';
}

import 'package:intl/intl.dart' as intl;

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

  @override
  String bt130_IE(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Persons',
      one: 'Person',
    );
    return '$_temp0';
  }

  @override
  String bt130_10(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Groups',
      one: 'Group',
    );
    return '$_temp0';
  }

  @override
  String bt130_ROM(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rooms',
      one: 'Room',
    );
    return '$_temp0';
  }

  @override
  String bt130_B17(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Credits',
      one: 'Credit',
    );
    return '$_temp0';
  }

  @override
  String bt130_PR(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pairs',
      one: 'Pair',
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
      other: 'Shots',
      one: 'Shot',
    );
    return '$_temp0';
  }

  @override
  String bt130_H87(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pieces',
      one: 'Piece',
    );
    return '$_temp0';
  }

  @override
  String bt130_SET(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sets',
      one: 'Set',
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
      other: 'Ones',
      one: 'One',
    );
    return '$_temp0';
  }

  @override
  String bt130_XPP(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Loose unpacked articles',
      one: 'Loose unpacked article',
    );
    return '$_temp0';
  }

  @override
  String bt130_NAR(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Number of articles',
      one: 'Number of article',
    );
    return '$_temp0';
  }

  @override
  String bt130_ZZ(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mutually defined',
      one: 'Mutually defined',
    );
    return '$_temp0';
  }

  @override
  String bt130_MMK(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Square millimeters',
      one: 'Square millimeter',
    );
    return '$_temp0';
  }

  @override
  String bt130_MTK(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Square meters',
      one: 'Square meter',
    );
    return '$_temp0';
  }

  @override
  String bt130_KMK(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Square kilometers',
      one: 'Square kilometer',
    );
    return '$_temp0';
  }

  @override
  String bt130_INK(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Square inches',
      one: 'Square inch',
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
      other: 'Inches',
      one: 'Inch',
    );
    return '$_temp0';
  }

  @override
  String bt130_MMT(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Millimeters',
      one: 'Millimeter',
    );
    return '$_temp0';
  }

  @override
  String bt130_MTR(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Meters',
      one: 'Meter',
    );
    return '$_temp0';
  }

  @override
  String bt130_KMT(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kilometers',
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
      other: 'Milliliters',
      one: 'Milliliter',
    );
    return '$_temp0';
  }

  @override
  String bt130_LTR(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Liters',
      one: 'Liter',
    );
    return '$_temp0';
  }

  @override
  String bt130_HLT(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hectoliters',
      one: 'Hectoliter',
    );
    return '$_temp0';
  }

  @override
  String bt130_AMH(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ampere hours',
      one: 'Ampere hour',
    );
    return '$_temp0';
  }

  @override
  String bt130_KWH(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kilowatt hours',
      one: 'Kilowatt hour',
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
      other: 'Megawatts',
      one: 'Megawatt',
    );
    return '$_temp0';
  }

  @override
  String bt130_C26(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Milliseconds',
      one: 'Millisecond',
    );
    return '$_temp0';
  }

  @override
  String bt130_SEC(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Seconds',
      one: 'Second',
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
      other: 'Hours',
      one: 'Hour',
    );
    return '$_temp0';
  }

  @override
  String bt130_DAY(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Days',
      one: 'Day',
    );
    return '$_temp0';
  }

  @override
  String bt130_WEE(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Weeks',
      one: 'Week',
    );
    return '$_temp0';
  }

  @override
  String bt130_MON(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Months',
      one: 'Month',
    );
    return '$_temp0';
  }

  @override
  String bt130_ANN(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Years',
      one: 'Year',
    );
    return '$_temp0';
  }

  @override
  String bt130_MMQ(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Cubic millimeters',
      one: 'Cubic millimeter',
    );
    return '$_temp0';
  }

  @override
  String bt130_MTQ(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Cubic meters',
      one: 'Cubic meter',
    );
    return '$_temp0';
  }

  @override
  String bt130_INQ(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Cubic inches',
      one: 'Cubic inch',
    );
    return '$_temp0';
  }

  @override
  String bt130_MC(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Micrograms',
      one: 'Microgram',
    );
    return '$_temp0';
  }

  @override
  String bt130_MGM(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Milligrams',
      one: 'Milligram',
    );
    return '$_temp0';
  }

  @override
  String bt130_GRM(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Grams',
      one: 'Gram',
    );
    return '$_temp0';
  }

  @override
  String bt130_KGM(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kilograms',
      one: 'Kilogram',
    );
    return '$_temp0';
  }

  @override
  String bt130_TNE(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tons',
      one: 'Ton',
    );
    return '$_temp0';
  }

  @override
  String bt130_KTN(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kilotons',
      one: 'Kiloton',
    );
    return '$_temp0';
  }
}

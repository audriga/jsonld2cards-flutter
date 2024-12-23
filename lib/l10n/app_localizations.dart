import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @forwardButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Forward'**
  String get forwardButtonLabel;

  /// No description provided for @noAddressesConfigured.
  ///
  /// In en, this message translates to:
  /// **'No addresses configured'**
  String get noAddressesConfigured;

  /// No description provided for @reloadContacts.
  ///
  /// In en, this message translates to:
  /// **'Reload contacts'**
  String get reloadContacts;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @noTargetsConfiguredMessage.
  ///
  /// In en, this message translates to:
  /// **'Invoices can be forwarded to contacts that have an xrechnung email address. Please configure this by adding an email address with the label \'xrechnung\' to a contact and allow this app to access contacts.'**
  String get noTargetsConfiguredMessage;

  /// No description provided for @errorTitleNoTargetsConfigured.
  ///
  /// In en, this message translates to:
  /// **'No targets configured'**
  String get errorTitleNoTargetsConfigured;

  /// No description provided for @bt130_IE.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Person} other {Persons}}'**
  String bt130_IE(num count);

  /// No description provided for @bt130_10.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Group} other {Groups}}'**
  String bt130_10(num count);

  /// No description provided for @bt130_ROM.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Room} other {Rooms}}'**
  String bt130_ROM(num count);

  /// No description provided for @bt130_B17.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Credit} other {Credits}}'**
  String bt130_B17(num count);

  /// No description provided for @bt130_PR.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Pair} other {Pairs}}'**
  String bt130_PR(num count);

  /// No description provided for @bt130_13.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Ration} other {Rations}}'**
  String bt130_13(num count);

  /// No description provided for @bt130_14.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Shot} other {Shots}}'**
  String bt130_14(num count);

  /// No description provided for @bt130_H87.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Piece} other {Pieces}}'**
  String bt130_H87(num count);

  /// No description provided for @bt130_SET.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Set} other {Sets}}'**
  String bt130_SET(num count);

  /// No description provided for @bt130_SG.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Segment} other {Segments}}'**
  String bt130_SG(num count);

  /// No description provided for @bt130_C62.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{One} other {Ones}}'**
  String bt130_C62(num count);

  /// No description provided for @bt130_XPP.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Loose unpacked article} other {Loose unpacked articles}}'**
  String bt130_XPP(num count);

  /// No description provided for @bt130_NAR.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Number of article} other {Number of articles}}'**
  String bt130_NAR(num count);

  /// No description provided for @bt130_ZZ.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Mutually defined} other {Mutually defined}}'**
  String bt130_ZZ(num count);

  /// No description provided for @bt130_MMK.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Square millimeter} other {Square millimeters}}'**
  String bt130_MMK(num count);

  /// No description provided for @bt130_MTK.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Square meter} other {Square meters}}'**
  String bt130_MTK(num count);

  /// No description provided for @bt130_KMK.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Square kilometer} other {Square kilometers}}'**
  String bt130_KMK(num count);

  /// No description provided for @bt130_INK.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Square inch} other {Square inches}}'**
  String bt130_INK(num count);

  /// No description provided for @bt130_C37.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Kilobit} other {Kilobits}}'**
  String bt130_C37(num count);

  /// No description provided for @bt130_INH.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Inch} other {Inches}}'**
  String bt130_INH(num count);

  /// No description provided for @bt130_MMT.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Millimeter} other {Millimeters}}'**
  String bt130_MMT(num count);

  /// No description provided for @bt130_MTR.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Meter} other {Meters}}'**
  String bt130_MTR(num count);

  /// No description provided for @bt130_KMT.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Kilometer} other {Kilometers}}'**
  String bt130_KMT(num count);

  /// No description provided for @bt130_YRD.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Yard} other {Yards}}'**
  String bt130_YRD(num count);

  /// No description provided for @bt130_MLT.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Milliliter} other {Milliliters}}'**
  String bt130_MLT(num count);

  /// No description provided for @bt130_LTR.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Liter} other {Liters}}'**
  String bt130_LTR(num count);

  /// No description provided for @bt130_HLT.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Hectoliter} other {Hectoliters}}'**
  String bt130_HLT(num count);

  /// No description provided for @bt130_AMH.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Ampere hour} other {Ampere hours}}'**
  String bt130_AMH(num count);

  /// No description provided for @bt130_KWH.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Kilowatt hour} other {Kilowatt hours}}'**
  String bt130_KWH(num count);

  /// No description provided for @bt130_KWT.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Kilowatt} other {Kilowatts}}'**
  String bt130_KWT(num count);

  /// No description provided for @bt130_MAW.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Megawatt} other {Megawatts}}'**
  String bt130_MAW(num count);

  /// No description provided for @bt130_C26.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Millisecond} other {Milliseconds}}'**
  String bt130_C26(num count);

  /// No description provided for @bt130_SEC.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Second} other {Seconds}}'**
  String bt130_SEC(num count);

  /// No description provided for @bt130_MIN.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Minute} other {Minutes}}'**
  String bt130_MIN(num count);

  /// No description provided for @bt130_HUR.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Hour} other {Hours}}'**
  String bt130_HUR(num count);

  /// No description provided for @bt130_DAY.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Day} other {Days}}'**
  String bt130_DAY(num count);

  /// No description provided for @bt130_WEE.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Week} other {Weeks}}'**
  String bt130_WEE(num count);

  /// No description provided for @bt130_MON.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Month} other {Months}}'**
  String bt130_MON(num count);

  /// No description provided for @bt130_ANN.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Year} other {Years}}'**
  String bt130_ANN(num count);

  /// No description provided for @bt130_MMQ.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Cubic millimeter} other {Cubic millimeters}}'**
  String bt130_MMQ(num count);

  /// No description provided for @bt130_MTQ.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Cubic meter} other {Cubic meters}}'**
  String bt130_MTQ(num count);

  /// No description provided for @bt130_INQ.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Cubic inch} other {Cubic inches}}'**
  String bt130_INQ(num count);

  /// No description provided for @bt130_MC.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Microgram} other {Micrograms}}'**
  String bt130_MC(num count);

  /// No description provided for @bt130_MGM.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Milligram} other {Milligrams}}'**
  String bt130_MGM(num count);

  /// No description provided for @bt130_GRM.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Gram} other {Grams}}'**
  String bt130_GRM(num count);

  /// No description provided for @bt130_KGM.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Kilogram} other {Kilograms}}'**
  String bt130_KGM(num count);

  /// No description provided for @bt130_TNE.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Ton} other {Tons}}'**
  String bt130_TNE(num count);

  /// No description provided for @bt130_KTN.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Kiloton} other {Kilotons}}'**
  String bt130_KTN(num count);

  /// No description provided for @noApiConfigured.
  ///
  /// In en, this message translates to:
  /// **'No API configured yet.'**
  String get noApiConfigured;

  /// No description provided for @uploadInvoiceToApi.
  ///
  /// In en, this message translates to:
  /// **'With this button, you can upload the invoice directly to the API of your billing system. Send us feedback and let us know which billing system you would like to have available here.'**
  String get uploadInvoiceToApi;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel.'**
  String get cancel;

  /// No description provided for @apiRequest.
  ///
  /// In en, this message translates to:
  /// **'API request.'**
  String get apiRequest;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send feedback.'**
  String get sendFeedback;

  /// No description provided for @noFileName.
  ///
  /// In en, this message translates to:
  /// **'No file name.'**
  String get noFileName;

  /// No description provided for @viewContact.
  ///
  /// In en, this message translates to:
  /// **'View contact.'**
  String get viewContact;

  /// No description provided for @editContact.
  ///
  /// In en, this message translates to:
  /// **'Edit contact.'**
  String get editContact;

  /// No description provided for @addToContacts.
  ///
  /// In en, this message translates to:
  /// **'Add to contacts.'**
  String get addToContacts;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @deliveryDate.
  ///
  /// In en, this message translates to:
  /// **'Delivery date'**
  String get deliveryDate;

  /// No description provided for @invoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invoice;

  /// No description provided for @attachments.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Attachment} other {Attachments}}'**
  String attachments(num count);

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @buyer.
  ///
  /// In en, this message translates to:
  /// **'Buyer'**
  String get buyer;

  /// No description provided for @delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get delivery;

  /// No description provided for @seller.
  ///
  /// In en, this message translates to:
  /// **'Seller'**
  String get seller;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

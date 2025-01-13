library;

import 'package:enough_mail/codecs.dart';
import 'package:logging/logging.dart';

final log = Logger('jsonld2cards.xre.trading_party');

enum PartyType {
  seller(
    bgKey: 'bg_4_seller',
    nameKey: 'bt_27_name',
    tradingNameKey: 'bt_28_trading_name',
    identifierKey: 'bt_29_identifier',
    legalRegistrationIdentifierKey: 'bt_30_legal_registration_identifier',
    vatIdentifierKey: 'bt_31_vat_identifier',
    additionalLegalInformationKey: 'bt_33_seller_additional_legal_information',
    electronicAddressKey: 'bt_34_electronic_address',
    addressKey: 'bg_5_seller_postal_address',
    addressKeys: AddressKeys(
      addressLine1Key: 'bt_35_address_line_1',
      addressLine2Key: 'bt_36_address_line_2',
      addressLine3Key: 'bt_162_address_line_3',
      cityKey: 'bt_37_city',
      postalCodeKey: 'bt_38_postal_code',
      countryCodeKey: 'bt_40_country_code',
    ),
    contactKey: 'bg_6_contact',
    contactKeys: ContactKeys(
      pointKey: 'bt_41_point',
      telephoneNumberKey: 'bt_42_telephone_number',
      emailAddressKey: 'bt_43_email_address',
    ),
  ),
  buyer(
    bgKey: 'bg_7_buyer',
    nameKey: 'bt_44_name',
    tradingNameKey: 'bt_45_buyer_trading_name',
    identifierKey: 'bt_46_identifier',
    legalRegistrationIdentifierKey: 'bt_47_legal_registration_identifier',
    vatIdentifierKey: 'bt_48_vat_identifier',
    electronicAddressKey: 'bt_49_electronic_address',
    addressKey: 'bg_8_buyer_postal_address',
    addressKeys: AddressKeys(
      addressLine1Key: 'bt_50_address_line_1',
      addressLine2Key: 'bt_51_address_line_2',
      addressLine3Key: 'bt_163_address_line_3',
      cityKey: 'bt_52_city',
      postalCodeKey: 'bt_53_postal_code',
      countryCodeKey: 'bt_55_country_code',
    ),
    contactKey: 'bg_9_contact',
    contactKeys: ContactKeys(
      pointKey: 'bt_56_point',
      telephoneNumberKey: 'bt_57_telephone_number',
      emailAddressKey: 'bt_58_email_address',
    ),
  ),
  payee(
    bgKey: 'bg_10_payee',
    nameKey: 'bt_59_name',
    identifierKey: 'bt_60_identifier',
    legalRegistrationIdentifierKey: 'bt_61_legal_registration_identifier',
  ),
  ;

  const PartyType({
    required this.bgKey,
    required this.nameKey,
    this.tradingNameKey,
    required this.identifierKey,
    required this.legalRegistrationIdentifierKey,
    this.vatIdentifierKey,
    this.additionalLegalInformationKey,
    this.electronicAddressKey,
    this.addressKey,
    this.addressKeys,
    this.contactKey,
    this.contactKeys,
  });

  final String bgKey;
  final String nameKey;
  final String? tradingNameKey;
  final String identifierKey;
  final String legalRegistrationIdentifierKey;
  final String? vatIdentifierKey;
  final String? additionalLegalInformationKey;
  final String? electronicAddressKey;
  final String? addressKey;
  final AddressKeys? addressKeys;
  final String? contactKey;
  final ContactKeys? contactKeys;
}

class AddressKeys {
  const AddressKeys({
    required this.addressLine1Key,
    required this.addressLine2Key,
    required this.addressLine3Key,
    required this.cityKey,
    required this.postalCodeKey,
    required this.countryCodeKey,
  });

  final String addressLine1Key;
  final String addressLine2Key;
  final String addressLine3Key;
  final String cityKey;
  final String postalCodeKey;
  final String countryCodeKey;
}

class ContactKeys {
  const ContactKeys({
    required this.pointKey,
    required this.telephoneNumberKey,
    required this.emailAddressKey,
  });

  final String pointKey;
  final String telephoneNumberKey;
  final String emailAddressKey;
}

/// Person or Organization for XRechnung
class PartyData {
  String? name;
  String? tradingName;
  late List<String> identifier;
  String? legalRegistrationIdentifier;
  String? vatIdentifier;
  String? additionalLegalInformation;
  String? electronicAddress;
  PostalAddress postalAddress;
  PartyContact contact;
  PartyType party;

  PartyData({
    this.name,
    this.tradingName,
    identifier,
    this.legalRegistrationIdentifier,
    this.vatIdentifier,
    this.additionalLegalInformation,
    this.electronicAddress,
    postalAddress,
    contact,
    required this.party,
  })  : identifier = identifier ?? [],
        postalAddress = postalAddress ?? PostalAddress(),
        contact = contact ?? PartyContact();

  PartyData.fromJson(Map<String, dynamic> json, this.party)
      : postalAddress = PostalAddress.fromJson(json, party),
        contact = PartyContact.fromJson(json, party) {
    identifier = [];
    if (json[party.bgKey] case Map<String, dynamic> partyMap) {
      if (partyMap[party.nameKey] case String nameJ) {
        name = nameJ;
      }
      if (partyMap[party.tradingNameKey] case String tradingNameJ) {
        tradingName = tradingNameJ;
      }
      if (partyMap[party.identifierKey] case List identifier) {
        this.identifier = identifier.whereType<String>().toList();
      } else if (partyMap[party.identifierKey] case String identifier) {
        this.identifier = [identifier];
      }
      if (partyMap[party.legalRegistrationIdentifierKey]
          case String legalRegistrationIdentifierJ) {
        legalRegistrationIdentifier = legalRegistrationIdentifierJ;
      }
      if (partyMap[party.vatIdentifierKey] case String vatIdentifier) {
        this.vatIdentifier = vatIdentifier;
      }
      if (partyMap[party.additionalLegalInformationKey]
          case String additionalLegalInformation) {
        this.additionalLegalInformation = additionalLegalInformation;
      }
      if (partyMap[party.electronicAddressKey] case String electronicAddress) {
        this.electronicAddress = electronicAddress;
      }
    }
  }
}

/// Postal Address for XRechnung
class PostalAddress {
  PostalAddress({
    this.addressLine1,
    this.addressLine2,
    this.addressLine3,
    this.city,
    this.postalCode,
    this.countryCode,
  });

  String? addressLine1;
  String? addressLine2;
  String? addressLine3;
  String? city;
  String? postalCode;
  String? countryCode;

  PostalAddress.fromJson(Map<String, dynamic> json, PartyType party) {
    if (json[party.bgKey] case Map<String, dynamic> partyMap) {
      if (partyMap[party.addressKey] case Map<String, dynamic> addressMap) {
        if (addressMap[party.addressKeys?.addressLine1Key]
            case String addressLine1) {
          this.addressLine1 = addressLine1;
        }
        if (addressMap[party.addressKeys?.addressLine2Key]
            case String addressLine2) {
          this.addressLine2 = addressLine2;
        }
        if (addressMap[party.addressKeys?.addressLine3Key]
            case String addressLine3) {
          this.addressLine3 = addressLine3;
        }
        if (addressMap[party.addressKeys?.cityKey] case String city) {
          this.city = city;
        }
        if (addressMap[party.addressKeys?.postalCodeKey]
            case String postalCode) {
          this.postalCode = postalCode;
        }
        if (addressMap[party.addressKeys?.countryCodeKey]
            case String countryCode) {
          this.countryCode = countryCode;
        }
      }
    }
  }
}

class PartyContact {
  PartyContact({
    this.point,
    this.telephoneNumber,
    this.emailAddress,
  });

  String? point;
  String? telephoneNumber;
  String? emailAddress;

  PartyContact.fromJson(Map<String, dynamic> json, PartyType party) {
    if (json[party.bgKey] case Map<String, dynamic> partyMap) {
      if (partyMap[party.contactKey] case Map<String, dynamic> contactMap) {
        if (contactMap[party.contactKeys?.pointKey] case String point) {
          this.point = point;
        }
        if (contactMap[party.contactKeys?.telephoneNumberKey]
            case String telephoneNumber) {
          this.telephoneNumber = telephoneNumber;
        }
        if (contactMap[party.contactKeys?.emailAddressKey]
            case String emailAddress) {
          this.emailAddress = emailAddress;
        }
      }
    }
  }
}

String renderAddressText(PostalAddress address) {
  var line1Buffer = StringBuffer();
  line1Buffer.write(address.addressLine1 ?? '');
  // var line2Buffer = StringBuffer();
  // line2Buffer.writeAll([address.addressLine2 ?? '', address.addressLine3 ?? ''], ' ');
  var line4Buffer = StringBuffer();
  line4Buffer.writeAll(
      [address.postalCode ?? '', address.city ?? '', address.countryCode ?? ''],
      ' ');
  var addressBuffer = StringBuffer();
  var line1 = line1Buffer.toString().trim();
  if (line1.isNotEmpty) {
    addressBuffer.writeln(line1);
  }
  // var line2 = line2Buffer.toString().trim();
  var line2 = address.addressLine2?.trim();
  if (line2 != null && line2.isNotEmpty) {
    addressBuffer.writeln(line2);
  }
  var line3 = address.addressLine3?.trim();
  if (line3 != null && line3.isNotEmpty) {
    addressBuffer.writeln(line3);
  }

  var line4 = line4Buffer.toString().trim();
  if (line4.isNotEmpty) {
    addressBuffer.write(line4);
  }
  var addressText = addressBuffer.toString();
  return addressText;
}

String? getFavIconAddress(PartyData partyData) {
  MailAddress? partyAddress;
  if (partyData.electronicAddress != null) {
    try {
      partyAddress = MailAddress.parse(partyData.electronicAddress!);
    } catch (e, st) {
      log.warning('Error occurred trying to parse party email', e, st);
    }
  } else if (partyData.contact.emailAddress != null) {
    try {
      partyAddress = MailAddress.parse(partyData.contact.emailAddress!);
    } catch (e, st) {
      log.warning('Error occurred trying to parse party contact point email', e, st);
    }
  }


  if (partyAddress != null) {
    var hostName = partyAddress.hostName;
    if ([
      'gmail.com', 'googlemail.com',
      'gmx.de', 'gmx.net',
      'web.de',
      't-online.de',
      'freenet.de',
      'mailbox.org',
      'posteo.de', 'posteo.com',
    ].contains(hostName)) {
      // skip fetching the favicon from freemailers
      return null;
    }
    var ico = 'https://icons.duckduckgo.com/ip3/$hostName.ico';
    return ico;
  }
  return null;
}
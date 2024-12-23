library ordered_items;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/xre_format_utils.dart';
import 'package:jsonld2cards/Util/conversion.dart';
import 'package:jsonld2cards/l10n/app_localizations.dart';

List<Widget> renderOrderedItems(Map<String, dynamic> json, BuildContext context) {
  AppLocalizations l = AppLocalizations.of(context);
  List<Widget> orderedItems = [];
  String? currencyCode;
  if (json['bt_6_vat_accounting_currency_code']
      case String bt6VatAccountingCurrencyCode) {
    currencyCode = bt6VatAccountingCurrencyCode;
  }
  if (json['bt_5_invoice_currency_code'] case String bt5InvoiceCurrencyCode) {
    currencyCode = bt5InvoiceCurrencyCode;
  }
  if (json['bg_25_invoice_line'] case List<dynamic> invoiceLines) {
    for (var line in invoiceLines.whereType<Map<String, dynamic>>()) {
      String? id;
      if (line['bt_126_identifier'] case String bt126Identifier) {
        id = bt126Identifier;
      }
      String? name;
      if (line['bg_31_item_information']
          case Map<String, dynamic> bg31ItemInformation) {
        if (bg31ItemInformation['bt_153_name'] case String bt153Name) {
          name = bt153Name;
        }
      }
      var nameOrId = name ?? id;
      if (nameOrId == null) {
        continue;
      }
      var nameBuffer = StringBuffer();

      bool plural = false;
      if (line['bt_129_quantity'] case String bt129Quantity) {
        if (bt129Quantity.trim().isNotEmpty) {
          var numberQ = tryCastOrParseNum(bt129Quantity.trim());
          if (numberQ != null && numberQ != 1) {
            plural = true;
          }
          nameBuffer.write('$bt129Quantity ');
        }
      }
      if (line['bt_130_quantity_unit_of_measure']
          case String bt130QuantityUnitOfMeasure) {
        if (bt130QuantityUnitOfMeasure.trim().isNotEmpty) {
          String localizedUnit = localizeUnit(bt130QuantityUnitOfMeasure.trim(), plural, context, l);
          nameBuffer.write('$localizedUnit ');
        }
      }
      nameBuffer.write(nameOrId);

      String? price;
      if (line['bt_131_net_amount'] case String bt131NetAmount) {
        price = priceInCurrency(bt131NetAmount, currencyCode);
      }

      String? oid;
      if (line['bt_128_object_identifier'] case String bt128ObjectIdentifier) {
        oid = bt128ObjectIdentifier;
      }
      String? note;
      if (line['bt_127_note'] case String bt127Note) {
        note = bt127Note;
      }
      orderedItems.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(nameBuffer.toString().trim()),
                if (price != null) Text(price),
              ],
            ),
            if (oid != null)
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(oid),
              ),
            if (note != null)
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(note),
              ),
          ],
        ),
      ));
    }
  }
  // if (invoice.referencesOrder != null) {
  //   for (var order in invoice.referencesOrder!) {
  //     String? name = order.name ?? order.orderedItem?.name;
  //     String? price = order.price ?? order.acceptedOffer?.price;
  //     if (name == null || price == null) {
  //       continue;
  //     }
  //     orderedItems.add(Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(name),
  //         Text('$price€'),
  //       ],
  //     ));
  //   }
  //   // if (invoice.totalPaymentDue != null) {
  //   //   orderedItems.add(const Divider());
  //   //   orderedItems.add(Row(
  //   //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //   //     children: [
  //   //       const Text('Total'),
  //   //       Text(invoice.totalPaymentDue.toString()),
  //   //     ],
  //   //   ));
  //   // }
  // }
  return orderedItems;
}

// TODO: Localize the codes from https://web.audriga.com/wiki/index.php/XRechnung/BT-130#Codes
// Use bt130-<CODE> as the corresponding keys for i18n.
// for example here the i18n keys should be
// bt130-IE, and bt130-10
// Also use plural feature of i18n
String localizeUnit(String code, bool plural, BuildContext context, AppLocalizations l) => switch(code) {
  'IE' => plural? l.bt130_IE(2): l.bt130_IE(1),
  '10' => plural? l.bt130_10(2): l.bt130_10(1),
  'ROM' => plural? l.bt130_ROM(2): l.bt130_ROM(1),
  'B17' => plural? l.bt130_B17(2): l.bt130_B17(1),
  'PR' => plural? l.bt130_PR(2): l.bt130_PR(1),
  '13' => plural? l.bt130_13(2): l.bt130_13(1),
  '14' => plural? l.bt130_14(2): l.bt130_14(1),
  'H87' => plural? l.bt130_H87(2): l.bt130_H87(1),
  'SET' => plural? l.bt130_SET(2): l.bt130_SET(1),
  'SG' => plural? l.bt130_SG(2): l.bt130_SG(1),
  'C62' => plural? l.bt130_C62(2): l.bt130_C62(1),
  'XPP' => plural? l.bt130_XPP(2): l.bt130_XPP(1),
  'NAR' => plural? l.bt130_NAR(2): l.bt130_NAR(1),
  'ZZ' => plural? l.bt130_ZZ(2): l.bt130_ZZ(1),
  'MMK' => plural? l.bt130_MMK(2): l.bt130_MMK(1),
  'MTK' => plural? l.bt130_MTK(2): l.bt130_MTK(1),
  'KMK' => plural? l.bt130_KMK(2): l.bt130_KMK(1),
  'INK' => plural? l.bt130_INK(2): l.bt130_INK(1),
  'C37' => plural? l.bt130_C37(2): l.bt130_C37(1),
  'INH' => plural? l.bt130_INH(2): l.bt130_INH(1),
  'MMT' => plural? l.bt130_MMT(2): l.bt130_MMT(1),
  'MTR' => plural? l.bt130_MTR(2): l.bt130_MTR(1),
  'KMT' => plural? l.bt130_KMT(2): l.bt130_KMT(1),
  'YRD' => plural? l.bt130_YRD(2): l.bt130_YRD(1),
  'MLT' => plural? l.bt130_MLT(2): l.bt130_MLT(1),
  'LTR' => plural? l.bt130_LTR(2): l.bt130_LTR(1),
  'HLT' => plural? l.bt130_HLT(2): l.bt130_HLT(1),
  'AMH' => plural? l.bt130_AMH(2): l.bt130_AMH(1),
  'KWH' => plural? l.bt130_KWH(2): l.bt130_KWH(1),
  'KWT' => plural? l.bt130_KWT(2): l.bt130_KWT(1),
  'MAW' => plural? l.bt130_MAW(2): l.bt130_MAW(1),
  'C26' => plural? l.bt130_C26(2): l.bt130_C26(1),
  'SEC' => plural? l.bt130_SEC(2): l.bt130_SEC(1),
  'MIN' => plural? l.bt130_MIN(2): l.bt130_MIN(1),
  'HUR' => plural? l.bt130_HUR(2): l.bt130_HUR(1),
  'DAY' => plural? l.bt130_DAY(2): l.bt130_DAY(1),
  'WEE' => plural? l.bt130_WEE(2): l.bt130_WEE(1),
  'MON' => plural? l.bt130_MON(2): l.bt130_MON(1),
  'ANN' => plural? l.bt130_ANN(2): l.bt130_ANN(1),
  'MMQ' => plural? l.bt130_MMQ(2): l.bt130_MMQ(1),
  'MTQ' => plural? l.bt130_MTQ(2): l.bt130_MTQ(1),
  'INQ' => plural? l.bt130_INQ(2): l.bt130_INQ(1),
  'MC' => plural? l.bt130_MC(2): l.bt130_MC(1),
  'MGM' => plural? l.bt130_MGM(2): l.bt130_MGM(1),
  'GRM' => plural? l.bt130_GRM(2): l.bt130_GRM(1),
  'KGM' => plural? l.bt130_KGM(2): l.bt130_KGM(1),
  'TNE' => plural? l.bt130_TNE(2): l.bt130_TNE(1),
  'KTN' => plural? l.bt130_KTN(2): l.bt130_KTN(1),
  _ => code,
};

// static
library ordered_items;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/xre_format_utils.dart';
import 'package:jsonld2cards/Util/conversion.dart';

List<Widget> renderOrderedItems(Map<String, dynamic> json, BuildContext context) {
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
          String localizedUnit = localizeUnit(bt130QuantityUnitOfMeasure.trim(), plural, context);
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
String localizeUnit(String code, bool plural, BuildContext context) => switch(code) {
  'IE' => plural? 'Person': 'Personen',
  '10' => plural? 'Gruppe': 'Gruppen',
  _ => code,
};

// static
library amunt_due;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/xre_format_utils.dart';
import 'package:jsonld2cards/Util/conversion.dart';
import 'package:jsonld2cards/Cards/Models/invoice_model.dart';

Widget? renderAmountDue(dynamic json) {
  if (json case Map<String, dynamic> map) {
    if (map['bg_22_document_totals']
        case Map<String, dynamic> bg22DocumentTotals) {
      if (bg22DocumentTotals['bt_115_amount_due_for_payment']
          case String bt115AmountDueForPayment) {
        String? currencyCode;
        if (json['bt_6_vat_accounting_currency_code']
            case String bt6VatAccountingCurrencyCode) {
          currencyCode = bt6VatAccountingCurrencyCode;
        }
        if (json['bt_5_invoice_currency_code']
            case String bt5InvoiceCurrencyCode) {
          currencyCode = bt5InvoiceCurrencyCode;
        }
        var ammountDueInCurrency =
            priceInCurrency(bt115AmountDueForPayment, currencyCode);
        if (ammountDueInCurrency != null) {
          return Text.rich(
            TextSpan(
                text: ammountDueInCurrency,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            style: const TextStyle(fontSize: 18),
          );
        }
      }
    }
  }
  return null;
}

class AmountDueAndCurrency {
  num bt115AmountDueForPayment;
  String currencyCode;

  bool get isNonZero => bt115AmountDueForPayment.abs() > 0;

  String get epcAmount =>
      '$currencyCode${bt115AmountDueForPayment.toStringAsFixed(2)}';

  AmountDueAndCurrency(this.bt115AmountDueForPayment, this.currencyCode);
}

AmountDueAndCurrency? amountDueForEPC(dynamic json) {
  if (json case Map<String, dynamic> map) {
    if (map['bg_22_document_totals']
        case Map<String, dynamic> bg22DocumentTotals) {
      var bt115AmountDueForPayment =
          bg22DocumentTotals['bt_115_amount_due_for_payment'];
      var bt115AmountDueForPaymentNum =
          tryCastOrParseNum(bt115AmountDueForPayment);
      if (bt115AmountDueForPaymentNum != null) {
        String? currencyCode;
        if (json['bt_6_vat_accounting_currency_code']
            case String bt6VatAccountingCurrencyCode) {
          currencyCode = bt6VatAccountingCurrencyCode;
        }
        if (json['bt_5_invoice_currency_code']
            case String bt5InvoiceCurrencyCode) {
          currencyCode = bt5InvoiceCurrencyCode;
        }
        if (currencyCode?.isNotEmpty ?? false) {
          return AmountDueAndCurrency(
              bt115AmountDueForPaymentNum, currencyCode!);
        }
      }
    }
  }
  return null;
}

Widget? renderAmount(Invoice invoice) {
  Widget? amountRendered;
  if (invoice.totalPaymentDue != null) {
    var invoiceAmountValue = invoice.totalPaymentDue.toString();
    amountRendered = Text.rich(
      TextSpan(
          text: invoiceAmountValue,
          style: const TextStyle(fontWeight: FontWeight.bold)),
      style: const TextStyle(fontSize: 18),
    );
  }
  return amountRendered;
}

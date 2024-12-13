library amunt_due;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/xre_format_utils.dart';
import 'package:jsonld2cards/Cards/Models/invoice_model.dart';
import 'package:jsonld2cards/Util/conversion.dart';

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
        var amountDueInCurrency =
            priceInCurrency(bt115AmountDueForPayment, currencyCode);
        if (amountDueInCurrency != null) {
          return Text.rich(
            TextSpan(
                text: amountDueInCurrency,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            style: const TextStyle(fontSize: 18),
          );
        }
      }
    }
  }
  return null;
}

class AmountAndCurrency {
  // usually bt115AmountDueForPayment, but this class might be used for other monetary amounts as well
  num amountPayment;
  String currencyCode;

  bool get isNonZero => amountPayment.abs() > 0;

  String get epcAmount => '$currencyCode${amountPayment.toStringAsFixed(2)}';

  AmountAndCurrency(this.amountPayment, this.currencyCode);
}

AmountAndCurrency? amountDueAndCurrency(dynamic json) {
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
          return AmountAndCurrency(bt115AmountDueForPaymentNum, currencyCode!);
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

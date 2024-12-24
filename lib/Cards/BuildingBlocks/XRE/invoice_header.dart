library invoice_header;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/Cards/Models/invoice_model.dart';
import 'package:jsonld2cards/l10n/app_localizations.dart';

Widget? renderInvoiceHeader(Invoice invoice, BuildContext context) {
  AppLocalizations l = AppLocalizations.of(context);
  var confirmationNumber = invoice.identifier ?? invoice.confirmationNumber;
  Widget? invoiceNrRendered;
  TextSpan? invoiceNrSpan;
  if (confirmationNumber != null) {
    var invoiceNr = ' $confirmationNumber';
    invoiceNrSpan = TextSpan(
      text: '${l.number}$invoiceNr',
      // style: const TextStyle(fontWeight: FontWeight.bold),
    );
    invoiceNrRendered = Text.rich(invoiceNrSpan);
  }
  Widget? invoiceDateRendered;
  TextSpan? invoiceDateSpan;
  if (invoice.dateIssued != null) {
    var dateIssued = invoice.dateIssued;
    invoiceDateSpan = TextSpan(
      text: '${dateIssued?.day}.${dateIssued?.month}.${dateIssued?.year} ',
    );
    invoiceDateRendered = Text.rich(invoiceDateSpan);
  } else if (invoice.json['bt_2_invoice_issue_date']
      case String dateIssuedText) {
    var dateIssued = DateTime.tryParse(dateIssuedText);
    if (dateIssued != null) {
      invoiceDateSpan = TextSpan(
        text: '${dateIssued.day}.${dateIssued.month}.${dateIssued.year} ',
      );
    } else {
      invoiceDateSpan = TextSpan(text: dateIssuedText);
    }
  }
  Widget? invoiceNrPlusDateRendered;
  if (invoiceNrSpan != null && invoiceDateSpan != null) {
    invoiceNrPlusDateRendered = Text.rich(TextSpan(children: [
      invoiceNrSpan,
      TextSpan(text: l.dated),
      invoiceDateSpan
    ]));
  }

  Widget? invoiceHeader =
      invoiceNrPlusDateRendered ?? invoiceNrRendered ?? invoiceDateRendered;
  return invoiceHeader;
}

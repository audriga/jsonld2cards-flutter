library;

import 'package:flutter/material.dart';
// import 'package:jsonld2cards/Cards/BuildingBlocks/mail_header.dart';
// import 'package:jsonld2cards/Cards/BuildingBlocks/uri_image.dart';
// import 'package:jsonld2cards/Cards/Models/invoice_model.dart';
import 'package:jsonld2cards/Cards/Models/schema_types.dart';
import 'package:jsonld2cards/Cards/markup_card.dart';
import 'package:jsonld2cards/card_data.dart';
// import 'package:jsonld2cards/l10n/app_localizations.dart';
import 'package:logging/logging.dart';

final log = Logger('jsonld2cards.cards.invoice');

// TODO XRE Invoice has been moved to a separate class called EInvoice.
// Should this file be reverted back to support schema.org invoices?
class InvoiceCard extends StatefulWidget implements MarkupCard {
  const InvoiceCard(this.cardData, {super.key});

  final CardData cardData;

  @override
  State<InvoiceCard> createState() => _InvoiceCardState();

  SchemaType get cardType => SchemaType.invoice;

  @override
  IconData get tabIcon => cardType.icon!;

  @override
  String get tabName => cardType.tabName;
}

class _InvoiceCardState extends State<InvoiceCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    // AppLocalizations l = AppLocalizations.of(context);
    // var invoice = Invoice.fromJson(widget.cardData.markup);
    return Card(); // todo revert to schema.org
  }
}
// todo we are temporarily breaking invoices that don't have xre format data.

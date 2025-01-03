library e_invoice_card;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/detail_invoice_page.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/invoice_header.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/leistung_card.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/paid_badge.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/person_tile.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/trading_party.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/mail_header.dart';
import 'package:jsonld2cards/Cards/Models/schema_types.dart';
import 'package:jsonld2cards/Cards/markup_card.dart';
import 'package:jsonld2cards/card_data.dart';
import 'dart:developer' as developer;
import 'package:jsonld2cards/l10n/app_localizations.dart';

class EInvoiceCard extends StatefulWidget implements MarkupCard {
  const EInvoiceCard(this.cardData, {super.key});

  final CardData cardData;

  @override
  State<EInvoiceCard> createState() => _EInvoiceCardState();

  SchemaType get cardType => SchemaType.invoice;

  @override
  IconData get tabIcon => cardType.icon!;

  @override
  String get tabName => cardType.tabName;
}

class _EInvoiceCardState extends State<EInvoiceCard> {
  // bool expanded = false;

  @override
  Widget build(BuildContext context) {
    AppLocalizations l = AppLocalizations.of(context);
    // var invoice = Invoice.fromJson(widget.cardData.markup);

    // Setting title and subtitle, depending on available information
    // String? titleText;
    // String? subtitleText;
    // var confirmationNumber = invoice.identifier ?? invoice.confirmationNumber;
    List<TextSpan> titleTextSpans = <TextSpan>[
       TextSpan(
          text: l.invoice, style: const TextStyle(fontWeight: FontWeight.bold))
    ]; //createTitleTextSpans(invoice);

    // List<TextSpan> subTitleTextSpans =
    //     createSubtitleTextSpans(confirmationNumber, invoice);

    // Widget? sellerAndOrCustomer = sellerAndOrCustomerSpansWrapped(invoice);

    // List<Widget> orderedItems = renderOrderedItems(invoice);

    // Widget? payee;
    // if (invoice.paymentMethod != null && invoice.paymentMethodId != null) {
    //   payee = Text.rich(TextSpan(children: [
    //     const TextSpan(
    //       text: 'Payee: ',
    //     ),
    //     (TextSpan(
    //       text: '${invoice.paymentMethodId}',
    //       style: const TextStyle(fontWeight: FontWeight.bold),
    //     ))
    //   ]));
    // }
    // if (invoice.totalPaymentDue != null) {
    //   subTitleTextBuffer.write('\nTotal payment due: ${invoice.totalPaymentDue.toString()}');
    // }

    // No potential Actions in this card
    // List<Map<String, dynamic>> potentialAction;
    // if (invoice.potentialAction case List pAs) {
    //   // todo this a lazy workaround to only have the share XRechnung button in the small card
    //   potentialAction = pAs
    //       .whereType<Map<String, dynamic>>()
    //       .where((m) => m['muid']?.toString().isNotEmpty ?? false)
    //       .toList();
    // } else {
    //   potentialAction = [];
    // }

    // todo: placeholder for actual CID property
    /*if (invoice.url case Uri uri) {
      if (uri.scheme == 'cid') {
        var cidAction = {
          '@type': 'ViewAction',
          'url': uri,
          'name': 'Open PDF',
        };
        if (potentialAction == null) {
          potentialAction = cidAction;
        } else if (potentialAction is List) {
          potentialAction = [cidAction, ...potentialAction];
        } else {
          potentialAction = [cidAction, potentialAction];
        }
      }
    }*/

    // titleText = titleTextBuffer.toString();
    // subtitleText = subTitleTextBuffer.toString().trim();
    // subTitleTextSpans.first.text?.trimLeft();
    // subTitleTextSpans.last.text?.trimRight();
    if (!widget.cardData.markupIsMap) {
      // todo error handle this
      if (widget.cardData.markupIsList) {

      }
    }
    Map<String, dynamic> json = widget.cardData.markup;
    Widget? invoiceHeader = renderEInvoiceHeader(json, context);

    // var numberOfItems = invoice.referencesOrder?.length ?? 0;
    var theme = Theme.of(context);
    var descriptionPadding = const EdgeInsets.fromLTRB(8.0, 8.0, 0, 0);
    var subCardColor = theme.canvasColor;

    /// If this should blend in, use theme.cardTheme.color ?? theme.colorScheme.surfaceContainerLow;
    Widget? paidBadge;
    try {
      paidBadge = PaidBadge(json: json, context: context);
    } catch (e) {
      developer.log(
        'Error rendering paid badge',
        error: e,
        name: 'jsonld2cards.invoice',
      );
      // todo error widget
    }
    Widget cardContent = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Flexible(
                child: Row(
                  children: [
                    Text.rich(
                      textAlign: TextAlign.start,
                      TextSpan(children: titleTextSpans),
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: paidBadge,
                    ),
                  ],
                ),
              ),
              // const Spacer(flex: 1,),
              // Icon(expanded ? Icons.expand_less : Icons.expand_more)
            ]),
            if (invoiceHeader != null) invoiceHeader,
            PersonTile(
                title: l.seller,
                personData:
                    PartyData.fromJson(json, PartyType.seller),
                subCardColor: subCardColor,
                descriptionPadding: descriptionPadding,
                big: false,
                cardData: widget.cardData,
            ),
            LeistungCard(
                subCardColor: subCardColor,
                descriptionPadding: descriptionPadding,
                cardData: widget.cardData,
                big: false),
            // Text.rich(
            //     textAlign: TextAlign.left,
            //     TextSpan(children: subTitleTextSpans)),
            // if (expanded && sellerAndOrCustomer != null) sellerAndOrCustomer,
            // if (expanded)
            //   ...orderedItems
            // else if ((numberOfItems) > 0)
            //   Text('$numberOfItems Items'),
          ],
        ));
    // cardContent = ;
    // var cardContent = ListTile(
    //   leading: leadingImage,
    //   title: Text.rich(
    //     TextSpan(children: titleTextSpans),
    //     style: const TextStyle(fontSize: 18),
    //   ),
    //   subtitle: Text.rich(
    //     TextSpan(children: subTitleTextSpans)
    //   ),
    // );
    var cardContents = [
      cardContent,
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     TextButton(
      //         onPressed: () =>
      //             openDetailView(context, invoice, widget.cardData),
      //         child: const Text('Detailansicht'))
      //   ],
      // )
    ];
    if (widget.cardData.showMessageHeader) {
      var messageHeader = MailHeader(
        widget.cardData,
        expandable: false,
      );
      cardContents.insertAll(0, [messageHeader, const Divider()]);
    }
    return InkWell(
      onTap: () => openDetailView(context, widget.cardData),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: cardContents,
        ),
      ),
    );
  }
}

void openDetailView(BuildContext context, CardData cardData) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => DetailInvoicePage(
      cardData: cardData,
    ),
  ));
}
// todo we are temporarily breaking invoices that don't have xre format data.

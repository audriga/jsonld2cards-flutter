library leistung_card;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/delivery_information.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/ordered_items.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/xre_format_utils.dart';
import 'package:jsonld2cards/Cards/Models/invoice_model.dart';
import 'package:jsonld2cards/card_data.dart';
import 'package:jsonld2cards/l10n/app_localizations.dart';

class LeistungCard extends StatefulWidget {
  const LeistungCard({
    super.key,
    required this.subCardColor,
    required this.descriptionPadding,
    required this.cardData,
    required this.invoice,
    this.big = true,
  });

  final Color subCardColor;
  final EdgeInsets descriptionPadding;
  final CardData cardData;
  final Invoice invoice;
  final bool big;

  @override
  State<LeistungCard> createState() => _LeistungCardState();
}

class _LeistungCardState extends State<LeistungCard> {
  // late final controller = ExpansionTileController();
  bool _expandNotes = false;

  @override
  Widget build(BuildContext context) {
    Widget? amountRendered; // = renderAmount(invoice);
    AppLocalizations l = AppLocalizations.of(context);

    if (widget.cardData.markup['bg_22_document_totals']
        case Map<String, dynamic> bg22DocumentTotals) {
      var bt112InvoiceTotalAmountWithVat =
          bg22DocumentTotals['bt_112_invoice_total_amount_with_vat'];
      amountRendered = Text.rich(
        TextSpan(
            text: priceInCurrencyFromJson(
                bt112InvoiceTotalAmountWithVat, widget.cardData.markup),
            style: const TextStyle(fontWeight: FontWeight.bold)),
        style: const TextStyle(fontSize: 18),
      );
    }

    final label = Text(l.service);
    // if (!big) {
    //   return Card(
    //   elevation: 0,
    //   color: subCardColor,
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Padding(
    //         padding: descriptionPadding,
    //         // todo what if small and no ammountRendered?
    //         child: label,
    //       ),
    //       if (amountRendered != null) ListTile(
    //         title: amountRendered,
    //       )
    //   ]
    //   ),
    // );
    // }
    String? noteText = renderNote(widget.cardData.markup);
    bool noteTooLong = (noteText?.length ?? 0) > 160;

    String? shortNoteText;
    if (noteTooLong) {
      shortNoteText = '${noteText!.substring(0, 159)}…';
    } else {
      shortNoteText = noteText;
    }
    String? noteTextToDisplay = _expandNotes? noteText : shortNoteText;
    DeliveryInformation? deliveryInformation =
        renderDeliveryInformation(widget.cardData.markup, context);
    String? invoicingPeriodText = deliveryInformation?.invoicingPeriodText;
    List<Widget> orderedItems = renderOrderedItems(widget.cardData.markup, context);
    var numberOfItems = widget.invoice.referencesOrder?.length ?? 0;
    var subtitle = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (invoicingPeriodText != null) Text(invoicingPeriodText),
        // if (widget.big && noteText != null && noteText.isNotEmpty)
        //   Text(
        //     noteText,
        //     maxLines: _expandNotes ? 1000 : 2,
        //     softWrap: true,
        //     overflow: TextOverflow.ellipsis,
        //   ),
        if (widget.big && (numberOfItems) > 0)
          Text('$numberOfItems ${l.invoiceItems}'),
      ],
    );
    return Card(
      elevation: 0,
      color: widget.subCardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: widget.descriptionPadding,
            child: label,
          ),
          if (amountRendered != null)
            widget.big
                ? ExpansionTile(
                    title: amountRendered,
                    subtitle: subtitle,
                    childrenPadding: widget.descriptionPadding,
                    children: [
                      if (widget.big && (noteTextToDisplay?.isNotEmpty ?? false))
                        Text(
                          noteTextToDisplay!,
                          softWrap: true,
                        ),
                      if (noteTooLong) TextButton(onPressed: (){
                         setState(() {
                            _expandNotes = !_expandNotes;
                          });
                      }, child: Text(_expandNotes ? l.minimize : l.readMore)),
                      ...orderedItems
                    ],
                    // onExpansionChanged: (value) {
                    //   setState(() {
                    //     _expandNotes = value;
                    //   });
                    // },
                  )
                : ListTile(
                    title: amountRendered,
                    subtitle: subtitle,
                  ),
          // PotentialActionRow(potentialAction: potentialAction, postFunction: postFunction)
        ],
      ),
    );
  }
}

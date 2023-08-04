library invoice_card;

import 'package:jsonld2cards/Cards/BuildingBlocks/simple_card.dart';
import 'BuildingBlocks/potential_actions.dart';
import 'package:flutter/widgets.dart';

import 'Models/invoice_model.dart';

class InvoiceCard extends StatelessWidget {
  const InvoiceCard({
    super.key,
    required this.markup,
    required this.postFunction,
    this.preview = false,
  });

  final Map<String, dynamic> markup;
  final PostFunction postFunction;
  final bool preview;

  @override
  Widget build(BuildContext context) {
    var invoice = Invoice.fromJson(markup);

    // Setting title and subtitle, depending on available information
    String? titleText;
    String? subtitleText;
    Widget? leadingImage;
    var titleTextBuffer = StringBuffer('Invoice');
    if (invoice.provider?.name != null) {
      titleTextBuffer.write(' from ${invoice.provider?.name}');
    }
    if (invoice.paymentStatus != null) {
      titleTextBuffer.write(': ${invoice.paymentStatus}');
    }

    var subTitleTextBuffer = StringBuffer();
    var due = invoice.paymentDue;
    if (due != null) {
      subTitleTextBuffer.write('Due on ${due.day}.${due.month}.${due.year}');
    }
    if (invoice.minimumPaymentDue?.price != null) {
      subTitleTextBuffer.write('\nMinimum payment due: ${invoice.minimumPaymentDue?.price}');
    }
    if (invoice.totalPaymentDue?.price != null) {
      subTitleTextBuffer.write('\nTotal payment due: ${invoice.totalPaymentDue?.price}');
    }

    titleText = titleTextBuffer.toString();
    subtitleText = subTitleTextBuffer.toString();

    return SimpleCard(
      leadingImage: leadingImage,
      titleText: titleText,
      subtitleText: subtitleText,
      potentialAction: invoice.potentialAction,
      potentialActionPostFunction: postFunction,
      preview: preview,
    );
  }
}

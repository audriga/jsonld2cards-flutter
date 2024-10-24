library invoice_card;

import 'package:jsonld2cards/Cards/BuildingBlocks/simple_card.dart';
import 'package:jsonld2cards/Cards/Models/schema_types.dart';
import 'package:jsonld2cards/Cards/markup_card.dart';
import 'BuildingBlocks/potential_actions.dart';
import 'package:flutter/widgets.dart';

import 'Models/invoice_model.dart';

class InvoiceCard extends StatelessWidget implements MarkupCard{
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
    var titleTextBuffer = StringBuffer('');
    if (invoice.broker?.name != null) {
      titleTextBuffer.write('${invoice.broker?.name} ');
    }
    if (invoice.provider?.name != null) {
      titleTextBuffer.write('${invoice.provider?.name} ');
    }
    titleTextBuffer.write('Invoice');
    if (invoice.confirmationNumber != null) {
      titleTextBuffer.write(' ${invoice.confirmationNumber}');
    }
    if (invoice.paymentStatus != null) {
      titleTextBuffer.write(': ${invoice.paymentStatus}');
    }

    var subTitleTextBuffer = StringBuffer();
    if (invoice.confirmationNumber != null) {
      subTitleTextBuffer.write('\nConfirmation number: ${invoice.confirmationNumber}');
    }
    if (invoice.totalPaymentDue != null) {
      subTitleTextBuffer.write('\nInvoice Amount: ');
      subTitleTextBuffer.write(invoice.totalPaymentDue.toString());
    }
    if (invoice.accountId != null) {
      subTitleTextBuffer.write('\nContract Number: ${invoice.accountId}');
    }
    if (invoice.referencesOrder?.orderNumber case String orderNr) {
      subTitleTextBuffer.write('\nOrder Number: $orderNr');
    }
    var due = invoice.paymentDue;
    if (due != null) {
      subTitleTextBuffer.write('\nDue on ${due.day}.${due.month}.${due.year}');
    }
    if (invoice.minimumPaymentDue?.price != null) {
      subTitleTextBuffer.write('\nMinimum payment due: ${invoice.minimumPaymentDue?.price}');
    }
    // if (invoice.totalPaymentDue != null) {
    //   subTitleTextBuffer.write('\nTotal payment due: ${invoice.totalPaymentDue.toString()}');
    // }

    titleText = titleTextBuffer.toString();
    subtitleText = subTitleTextBuffer.toString().trim();

    return SimpleCard(
      leadingImage: leadingImage,
      titleText: titleText,
      subtitleText: subtitleText,
      potentialAction: invoice.potentialAction,
      potentialActionPostFunction: postFunction,
      preview: preview,
    );
  }

  SchemaType get cardType => SchemaType.invoice;

  @override
  IconData get tabIcon => cardType.icon!;

  @override
  String get tabName => cardType.tabName;
}

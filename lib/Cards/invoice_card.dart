library invoice_card;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/Cards/Models/schema_types.dart';
import 'package:jsonld2cards/Cards/markup_card.dart';
import 'BuildingBlocks/card_with_actions.dart';
import 'BuildingBlocks/potential_actions.dart';

import 'BuildingBlocks/uri_image.dart';
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
    // String? titleText;
    // String? subtitleText;
    Widget? leadingImage;
    var titleTextBuffer = StringBuffer('');
    var titleTextSpans = <TextSpan>[];
    if (invoice.broker?.name != null) {
      var brokerName = '${invoice.broker?.name} ';
      titleTextBuffer.write(brokerName);
      titleTextSpans.add(TextSpan(
          text: brokerName,
          style: const TextStyle(fontWeight: FontWeight.bold)
      ));
    }
    if (invoice.provider?.name != null) {
      var providerName = '${invoice.provider?.name} ';
      titleTextBuffer.write(providerName);
      titleTextSpans.add(TextSpan(
          text: providerName,
          style: const TextStyle(fontWeight: FontWeight.bold)
      ));
    }
    titleTextBuffer.write('Invoice');
    titleTextSpans.add(const TextSpan(text: 'Invoice'));
    if (invoice.confirmationNumber != null) {
      var invoiceNr = ' ${invoice.confirmationNumber}';
      titleTextBuffer.write(invoiceNr);
      titleTextSpans.add(TextSpan(
          text: invoiceNr,
          style: const TextStyle(fontWeight: FontWeight.bold)
      ));
    }
    if (invoice.paymentStatus != null) {
      var paymentStatus = ': ${invoice.paymentStatus}';
      titleTextBuffer.write(paymentStatus);
      titleTextSpans.add(TextSpan(
          text: paymentStatus,
      ));
    }

    var subTitleTextBuffer = StringBuffer();
    var subTitleTextSpans = <TextSpan>[];
    if (invoice.confirmationNumber != null) {
      var confirmationNr = 'Confirmation number: ${invoice.confirmationNumber}\n';
      subTitleTextBuffer.write(confirmationNr);
      subTitleTextSpans.add(TextSpan(
        text: confirmationNr,
      ));
    }
    if (invoice.accountId != null) {
      var contractNr = 'Contract Number: ${invoice.accountId}\n';
      subTitleTextBuffer.write(contractNr);
      subTitleTextSpans.add(TextSpan(
        text: contractNr,
      ));
    }
    if (invoice.referencesOrder?.orderNumber case String orderNr) {
      var orderNrText = 'Order Number: $orderNr\n';
      subTitleTextBuffer.write(orderNrText);
      subTitleTextSpans.add(TextSpan(
        text: orderNrText,
      ));
    }
    var due = invoice.paymentDue;
    if (due != null) {
      var dueText = 'Due on ${due.day}.${due.month}.${due.year}\n';
      subTitleTextBuffer.write(dueText);
      subTitleTextSpans.add(TextSpan(
        text: dueText,
      ));
    }
    if (invoice.minimumPaymentDue?.price != null) {
      var minimumDue = 'Minimum payment due: ${invoice.minimumPaymentDue?.price}\n';
      subTitleTextBuffer.write(minimumDue);
      subTitleTextSpans.add(TextSpan(
        text: minimumDue,
      ));
    }
    if (invoice.totalPaymentDue != null) {
      var invoiceAmountDescr = 'Invoice Amount: ';
      subTitleTextBuffer.write(invoiceAmountDescr);
      subTitleTextSpans.add(TextSpan(
        text: invoiceAmountDescr,
      ));
      var invoiceAmountValue = invoice.totalPaymentDue.toString();
      subTitleTextBuffer.write(invoiceAmountValue);
      subTitleTextSpans.add(TextSpan(
          text: invoiceAmountValue,
          style: const TextStyle(fontWeight: FontWeight.bold)
      ));
    }
    // if (invoice.totalPaymentDue != null) {
    //   subTitleTextBuffer.write('\nTotal payment due: ${invoice.totalPaymentDue.toString()}');
    // }
    var potentialAction = invoice.potentialAction;
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

    if ((invoice.broker ?? invoice.provider)?.logo case Uri logo){
      leadingImage = UriImage(
            content: logo,
            height: 32.0,
            width:  32.0,
            fit: BoxFit.scaleDown,
          );    }

    // titleText = titleTextBuffer.toString();
    // subtitleText = subTitleTextBuffer.toString().trim();
    // subTitleTextSpans.first.text?.trimLeft();
    // subTitleTextSpans.last.text?.trimRight();

    var cardContent = ListTile(
      leading: leadingImage,
      title: Text.rich(
        TextSpan(children: titleTextSpans),
        style: const TextStyle(fontSize: 18),
      ),
      subtitle: Text.rich(
        TextSpan(children: subTitleTextSpans)
      ),
    );
    return CardWithActions(
      cardContents: [cardContent],
      potentialAction: potentialAction,
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

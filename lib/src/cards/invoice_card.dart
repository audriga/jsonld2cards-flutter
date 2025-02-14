library;

import 'package:flutter/material.dart';
import 'models/invoice_model.dart';
import 'models/schema_types.dart';
import 'markup_card.dart';
import 'package:jsonld2cards/card_data.dart';
import 'package:logging/logging.dart';

import 'building_blocks/uri_image.dart';

final log = Logger('jsonld2cards.cards.invoice');

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
    var invoice = Invoice.fromJson(widget.cardData.markup);

    Widget? leadingImage;
    var confirmationNumber = invoice.identifier ?? invoice.confirmationNumber;
    List<TextSpan> titleTextSpans = createTitleTextSpans(invoice);

    List<TextSpan> subTitleTextSpans =
        createSubtitleTextSpans(confirmationNumber, invoice);

    Widget? sellerAndOrCustomer = sellerAndOrCustomerSpansWrapped(invoice);

    if ((invoice.broker ?? invoice.provider)?.logo case Uri logo) {
      leadingImage = UriImage(
        content: logo,
        height: 32.0,
        width: 32.0,
        fit: BoxFit.scaleDown,
      );
    }
    Widget cardContent = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              if (leadingImage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: leadingImage,
                ),
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
                  ],
                ),
              ),
            ]),
            if (expanded && invoice.description != null)
              Text(
                invoice.descriptionString!,
                softWrap: true,
              ),
            Text.rich(
                textAlign: TextAlign.left,
                TextSpan(children: subTitleTextSpans)),
            if (expanded && sellerAndOrCustomer != null) sellerAndOrCustomer,
            // if (expanded)
            //   ...orderedItems
            // else if ((numberOfItems) > 0)
            //   Text('$numberOfItems Items'),
          ],
        ));

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [cardContent],
      ),
    );
  }
}

Widget? sellerAndOrCustomerSpansWrapped(Invoice invoice) {
  Widget? seller;
  if (invoice.provider != null) {
    List<TextSpan> sellerSpans = [];
    sellerSpans.add(const TextSpan(text: 'Seller: '));
    if (invoice.provider!.name != null) {
      sellerSpans.add(TextSpan(
          text: '${invoice.provider!.name}\n',
          style: const TextStyle(fontWeight: FontWeight.bold)));
    }
    if (invoice.provider!.address != null) {
      var address = invoice.provider!.address!;
      sellerSpans.add(TextSpan(
          text: '\t\t${address.streetAddress}\n'
              '\t\t${address.postalCode} ${address.addressLocality} ${address.addressCountry}'));
    }
    seller = Text.rich(TextSpan(children: sellerSpans));
  }
  Widget? customer;
  if (invoice.customer != null) {
    List<TextSpan> customerSpans = [];
    customerSpans.add(const TextSpan(text: 'Customer: '));
    if (invoice.customer!.name != null) {
      customerSpans.add(TextSpan(
          text: '${invoice.customer!.name}\n',
          style: const TextStyle(fontWeight: FontWeight.bold)));
    }
    if (invoice.customer!.address != null) {
      var address = invoice.customer!.address!;
      customerSpans.add(TextSpan(
          text: '\t\t${address.streetAddress}\n'
              '\t\t${address.postalCode} ${address.addressLocality} ${address.addressCountry}'));
    }
    customer = Text.rich(TextSpan(children: customerSpans));
  }
  Widget? sellerAndOrCustomer;
  if (seller != null && customer != null) {
    sellerAndOrCustomer = Wrap(
      alignment: WrapAlignment.spaceEvenly,
      children: [seller, customer],
    );
  } else {
    sellerAndOrCustomer = seller ?? customer;
  }
  return sellerAndOrCustomer;
}

List<TextSpan> createSubtitleTextSpans(
    String? confirmationNumber, Invoice invoice) {
  var subTitleTextSpans = <TextSpan>[];
  if (confirmationNumber != null) {
    var confirmationNr = 'Confirmation number: $confirmationNumber\n';
    subTitleTextSpans.add(TextSpan(
      text: confirmationNr,
    ));
  }
  if (invoice.accountId != null) {
    var contractNr = 'Contract Number: ${invoice.accountId}\n';
    subTitleTextSpans.add(TextSpan(
      text: contractNr,
    ));
  }
  if (invoice.purchase?.orderNumber case String orderNr) {
    var orderNrText = 'Order Number: $orderNr\n';
    subTitleTextSpans.add(TextSpan(
      text: orderNrText,
    ));
  }
  var due = invoice.paymentDue;
  if (due != null) {
    var dueText = 'Due on ${due.day}.${due.month}.${due.year}\n';
    subTitleTextSpans.add(TextSpan(
      text: dueText,
    ));
  }
  if (invoice.minimumPaymentDue?.price != null) {
    var minimumDue =
        'Minimum payment due: ${invoice.minimumPaymentDue?.price}\n';
    subTitleTextSpans.add(TextSpan(
      text: minimumDue,
    ));
  }
  if (invoice.totalPaymentDue != null) {
    var invoiceAmountDescr = 'Invoice Amount: ';
    subTitleTextSpans.add(TextSpan(
      text: invoiceAmountDescr,
    ));
    var invoiceAmountValue = invoice.totalPaymentDue.toString();
    subTitleTextSpans.add(TextSpan(
        text: invoiceAmountValue,
        style: const TextStyle(fontWeight: FontWeight.bold)));
  }

  var paymentDueDate = invoice.paymentDueDate;
  if (paymentDueDate != null) {
    bool overdue = paymentDueDate.isBefore(DateTime.now());
    subTitleTextSpans.add(TextSpan(
        text:
            '\nDue ${paymentDueDate.day}.${paymentDueDate.month}.${paymentDueDate.year}', // todo forced format
        style: TextStyle(
          color: overdue ? Colors.red : Colors.green,
        )));
  }
  return subTitleTextSpans;
}

List<TextSpan> createTitleTextSpans(Invoice invoice) {
  var titleTextSpans = <TextSpan>[];
  if (invoice.broker?.name != null) {
    var brokerName = '${invoice.broker?.name} ';
    titleTextSpans.add(TextSpan(
        text: brokerName, style: const TextStyle(fontWeight: FontWeight.bold)));
  }
  if (invoice.provider?.name != null) {
    var providerName = '${invoice.provider?.name} ';
    titleTextSpans.add(TextSpan(
        text: providerName,
        style: const TextStyle(fontWeight: FontWeight.bold)));
  }
  titleTextSpans.add(const TextSpan(text: 'Rechnung'));
// if (confirmationNumber != null) {
//   var invoiceNr = ' $confirmationNumber';
//   titleTextSpans.add(TextSpan(
//       text: invoiceNr,
//       style: const TextStyle(fontWeight: FontWeight.bold)));
// }
  if (invoice.paymentStatus != null) {
    var paymentStatus = ': ${invoice.paymentStatus}';
    titleTextSpans.add(TextSpan(
      text: paymentStatus,
    ));
  }

  if (invoice.dateIssued != null) {
    var dateIssued = invoice.dateIssued;
    titleTextSpans.add(TextSpan(
      text: ' ${dateIssued?.day}.${dateIssued?.month}.${dateIssued?.year} ',
    ));
  }
  return titleTextSpans;
}

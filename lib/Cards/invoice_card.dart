library invoice_card;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/Cards/Models/schema_types.dart';
import 'package:jsonld2cards/Cards/markup_card.dart';
import 'BuildingBlocks/card_with_actions.dart';
import 'BuildingBlocks/potential_actions.dart';

import 'BuildingBlocks/uri_image.dart';
import 'Models/invoice_model.dart';

class InvoiceCard extends StatefulWidget implements MarkupCard {
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
    var invoice = Invoice.fromJson(widget.markup);

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
    var confirmationNumber = invoice.identifier ?? invoice.confirmationNumber;
    if (confirmationNumber != null) {
      var invoiceNr = ' $confirmationNumber';
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

    if (invoice.dateIssued != null) {
      var dateIssued = invoice.dateIssued;
      titleTextSpans.add(TextSpan(
        text: ' ${dateIssued?.day}.${dateIssued?.month}.${dateIssued?.year} ',
      ));
    }

    var subTitleTextBuffer = StringBuffer();
    var subTitleTextSpans = <TextSpan>[];
    if (confirmationNumber != null) {
      var confirmationNr = 'Confirmation number: $confirmationNumber\n';
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
    if (invoice.purchase?.orderNumber case String orderNr) {
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

    var paymentDueDate = invoice.paymentDueDate;
    if (paymentDueDate != null) {
      bool overdue = paymentDueDate.isBefore(DateTime.now());
      subTitleTextSpans.add(
        TextSpan(
          text: '\nDue ${paymentDueDate.day}.${paymentDueDate.month}.${paymentDueDate.year}', // todo forced format
          style: TextStyle(
            color: overdue? Colors.red : Colors.green,
          )
        )
      );
    }

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
      seller = Text.rich(
          TextSpan(
              children: sellerSpans
          )
      );
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
      customer = Text.rich(
          TextSpan(
              children: customerSpans
          )
      );
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

    List<Widget> orderedItems = [];
    if (invoice.referencesOrder != null) {
      for (var order in invoice.referencesOrder!) {
        String? name = order.name ?? order.orderedItem?.name;
        String? price = order.price ?? order.acceptedOffer?.price;
        if (name == null || price == null) {
          continue;
        }
        orderedItems.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name),
            Text('$price€'),
          ],
        ));
        // orderedItems.add(ListTile(
        //   subtitle: Text(name),
        //   trailing:   Text('$price€'),
        // ));
      }
      if (invoice.totalPaymentDue != null) {
        orderedItems.add(const Divider());
        orderedItems.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total'),
            Text(invoice.totalPaymentDue.toString()),
          ],
        )
            // ListTile(
            //   title: const Text('Total'),
            //   trailing: Text(invoice.totalPaymentDue.toString()),
            // )
            );
      }
    }

    Widget? payee;
    if (invoice.paymentMethod != null && invoice.paymentMethodId != null) {
      payee = Text.rich(TextSpan(children: [
        const TextSpan(
          text: 'Payee: ',
        ),
        (TextSpan(
          text: '${invoice.paymentMethodId}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ))
      ]));
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

    var numberOfItems = invoice.referencesOrder?.length ?? 0;
    Widget cardContent = InkWell(
      onTap: () {
        setState(() {
          expanded = !expanded;
        });
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                if (leadingImage != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: leadingImage,
                  ),
                Text.rich(
                  textAlign: TextAlign.start,
                  TextSpan(children: titleTextSpans),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                    const Spacer(             ),
                    Icon(expanded? Icons.expand_less : Icons.expand_more)
              ]),
              if (expanded && invoice.description!= null) Text(invoice.description!, softWrap: true,),
              Text.rich(
                  textAlign: TextAlign.left,
                  TextSpan(children: subTitleTextSpans)),
              if (expanded && sellerAndOrCustomer != null) sellerAndOrCustomer,
              if (expanded)
                ...orderedItems
              else if ((numberOfItems) > 0)
                Text('$numberOfItems Items'),
              if (payee != null) payee,
            ],
          )),
    );
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
    return CardWithActions(
      cardContents: [cardContent],
      potentialAction: potentialAction,
      potentialActionPostFunction: widget.postFunction,
      preview: widget.preview,
    );
  }

}

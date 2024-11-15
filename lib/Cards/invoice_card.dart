library invoice_card;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/mail_header.dart';
import 'package:jsonld2cards/Cards/Models/organization_model.dart';
import 'package:jsonld2cards/Cards/Models/schema_types.dart';
import 'package:jsonld2cards/Cards/markup_card.dart';
import 'package:jsonld2cards/card_data.dart';
import 'BuildingBlocks/card_with_actions.dart';

import 'BuildingBlocks/uri_image.dart';
import 'Models/invoice_model.dart';

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
          style: const TextStyle(fontWeight: FontWeight.bold)));
    }
    if (invoice.provider?.name != null) {
      var providerName = '${invoice.provider?.name} ';
      titleTextBuffer.write(providerName);
      titleTextSpans.add(TextSpan(
          text: providerName,
          style: const TextStyle(fontWeight: FontWeight.bold)));
    }
    titleTextBuffer.write('Invoice');
    titleTextSpans.add(const TextSpan(text: 'Invoice'));
    var confirmationNumber = invoice.identifier ?? invoice.confirmationNumber;
    if (confirmationNumber != null) {
      var invoiceNr = ' $confirmationNumber';
      titleTextBuffer.write(invoiceNr);
      titleTextSpans.add(TextSpan(
          text: invoiceNr,
          style: const TextStyle(fontWeight: FontWeight.bold)));
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
      var minimumDue =
          'Minimum payment due: ${invoice.minimumPaymentDue?.price}\n';
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

    List<Widget> orderedItems = renderOrderedItems(invoice);

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

    if ((invoice.broker ?? invoice.provider)?.logo case Uri logo) {
      leadingImage = UriImage(
        content: logo,
        height: 32.0,
        width: 32.0,
        fit: BoxFit.scaleDown,
      );
    }

    // titleText = titleTextBuffer.toString();
    // subtitleText = subTitleTextBuffer.toString().trim();
    // subTitleTextSpans.first.text?.trimLeft();
    // subTitleTextSpans.last.text?.trimRight();

    var numberOfItems = invoice.referencesOrder?.length ?? 0;
    Widget cardContent = InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DetailInvoicePage(
            invoice: invoice,
            cardData: widget.cardData,
          ),
        ));
        // setState(() {
        //   expanded = !expanded;
        // });
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                if (leadingImage != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: leadingImage,
                  ),
                Flexible(
                  child: Text.rich(
                    textAlign: TextAlign.start,
                    TextSpan(children: titleTextSpans),
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // const Spacer(flex: 1,),
                Icon(expanded ? Icons.expand_less : Icons.expand_more)
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
      cardData: widget.cardData,
    );
  }
}

List<Widget> renderOrderedItems(Invoice invoice) {
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
  return orderedItems;
}

List<Widget> renderAttachments(Invoice invoice) {
  List<Widget> attachments = [];
  var attachmentFileNames = ['protokoll.pdf', 'foo.txt', 'bar.json'];
  var attachmentActions = <Widget>[
    IconButton(onPressed: () {}, icon: const Icon(Icons.download, size: 16)),
    IconButton(
        onPressed: () {}, icon: const Icon(Icons.cloud_upload, size: 16)),
    IconButton(
        onPressed: () {}, icon: const Icon(Icons.forward_to_inbox, size: 16)),
  ];
  for (String fileName in attachmentFileNames) {
    attachments.add(Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(fileName),
        const Spacer(),
        ...attachmentActions,
      ],
    ));
  }
  return attachments;
}

class DetailInvoicePage extends StatefulWidget {
  const DetailInvoicePage({
    super.key,
    required this.invoice,
    required this.cardData,
  });

  final Invoice invoice;
  final CardData cardData;

  @override
  State<DetailInvoicePage> createState() => _DetailInvoicePageState();
}

class _DetailInvoicePageState extends State<DetailInvoicePage> {
  @override
  Widget build(BuildContext context) {
    Widget? amountRendered;
    if (widget.invoice.totalPaymentDue != null) {
      var invoiceAmountValue = widget.invoice.totalPaymentDue.toString();
      amountRendered = Text.rich(
        TextSpan(
            text: invoiceAmountValue,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        style: const TextStyle(fontSize: 18),
      );
    }

    List<Widget> orderedItems = renderOrderedItems(widget.invoice);
    var numberOfItems = widget.invoice.referencesOrder?.length ?? 0;
    List<Widget> attachments = renderAttachments(widget.invoice);
    var numberOfAttachments = attachments.length; // ?? 0;
    var confirmationNumber =
        widget.invoice.identifier ?? widget.invoice.confirmationNumber;
    Widget? invoiceNrRendered;
    TextSpan? invoiceNrSpan;
    if (confirmationNumber != null) {
      var invoiceNr = ' $confirmationNumber';
      invoiceNrSpan = TextSpan(
        text: invoiceNr,
        // style: const TextStyle(fontWeight: FontWeight.bold),
      );
      invoiceNrRendered = Text.rich(invoiceNrSpan);
    }
    Widget? invoiceDateRendered;
    TextSpan? invoiceDateSpan;
    if (widget.invoice.dateIssued != null) {
      var dateIssued = widget.invoice.dateIssued;
      invoiceDateSpan = TextSpan(
        text: '${dateIssued?.day}.${dateIssued?.month}.${dateIssued?.year} ',
      );
      invoiceDateRendered = Text.rich(invoiceDateSpan);
    }
    Widget? invoiceNrPlusDateRendered;
    if (invoiceNrSpan != null && invoiceDateSpan != null) {
      invoiceNrPlusDateRendered = Text.rich(TextSpan(children: [
        invoiceNrSpan,
        const TextSpan(text: ' vom '),
        invoiceDateSpan
      ]));
    }
    // Widget? paymentStatusRendered;//todo?
    // if (widget.invoice.paymentStatus != null) {
    //   var paymentStatus = ': ${widget.invoice.paymentStatus}';
    //   paymentStatusRendered = Text.rich(TextSpan(
    //     text: paymentStatus,
    //   ));
    // }

    Text? deliveryToRendered;
    Text? deliveryDateRendered;
    if (widget.invoice.referencesOrder != null) {
      // todo replace with delivery to thing
      var deliveryToName = 'Mustermann Gmbh';
      deliveryToRendered = Text.rich(
        TextSpan(
          children: [
            const TextSpan(text: 'Lieferung an: '),
            TextSpan(
                text: deliveryToName,
                style: const TextStyle(fontWeight: FontWeight.bold))
          ],
        ),
      );
      var deliveryDate = '02.12.2024';
      deliveryDateRendered = Text.rich(TextSpan(children: [
        const TextSpan(text: 'Lieferdatum: '),
        TextSpan(
          text: deliveryDate,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ]));
    }

    var theme = Theme.of(context);
    var descriptionPadding = const EdgeInsets.fromLTRB(8.0, 8.0, 0, 0);
    var subCardColor = theme.canvasColor;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Card(
        child: ListView(
          children: [
            MailHeader(widget.cardData, expandable: true),
            Divider(),
            ListTile(
              title: const Text.rich(
                TextSpan(
                  text: 'Rechnung',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              subtitle: invoiceNrPlusDateRendered ??
                  invoiceNrRendered ??
                  invoiceDateRendered,
            ),
            PersonTile(
              title: 'Seller',
              organization: widget.invoice.provider,
              subCardColor: subCardColor,
              descriptionPadding: descriptionPadding,
            ),
            Card(
              elevation: 0,
              color: subCardColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: descriptionPadding,
                    child: const Text('Leistung'),
                  ),
                  if (amountRendered != null)
                    ExpansionTile(
                      title: amountRendered,
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Note\nLeistungszeitraum von bis',
                          ),
                          if ((numberOfItems) > 0)
                            Text('$numberOfItems Rechnungsposten'),
                        ],
                      ),
                      trailing: const Card(
                        elevation: 0,
                        color: Colors.green,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Bezahlt',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      children: orderedItems,
                    ),
                  // PotentialActionRow(potentialAction: potentialAction, postFunction: postFunction)
                ],
              ),
            ),
            Card(
              elevation: 0,
              color: subCardColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: descriptionPadding,
                    child: Text('Zahlung', style: TextStyle(color: theme.hintColor)),
                  ),
                  if (amountRendered != null)
                    ExpansionTile(
                      title: amountRendered,
                      subtitle: const Text(
                        'Wird eingezogen',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      children: const [
                        ListTile(
                          title: Text("This is some extra info"),
                        ),
                      ],
                    ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      children: <Widget>[
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.credit_card)),
                      ],
                    ),
                  ),
                  // PotentialActionRow(potentialAction: potentialAction, postFunction: postFunction)
                ],
              ),
            ),
            PersonTile(
              title: 'Käufer',
              organization: widget.invoice.customer,
              subCardColor: subCardColor,
              descriptionPadding: descriptionPadding,
            ),
            Card(
              elevation: 0,
              color: subCardColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: descriptionPadding,
                    child: Text('Lieferung', style: TextStyle(color: theme.hintColor)),
                  ),
                  if (deliveryToRendered != null)
                    ExpansionTile(
                      title: deliveryToRendered,
                      subtitle: deliveryDateRendered,
                      children: const [
                        ListTile(
                          title: Text("This is some extra info"),
                        ),
                      ],
                    ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      children: <Widget>[
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.map)),
                      ],
                    ),
                  ),
                  // PotentialActionRow(potentialAction: potentialAction, postFunction: postFunction)
                ],
              ),
            ),
            Card(
              elevation: 0,
              color: subCardColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: descriptionPadding,
                    child: Text('Anhänge', style: TextStyle(color: theme.hintColor)),
                  ),
                  if (numberOfAttachments > 0)
                    ExpansionTile(
                      title: Text('$numberOfAttachments Anhänge'),
                      children: attachments,
                    ),
                ],
              ),
            ),
            Row(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.topCenter,
                  child: Wrap(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.add_comment)),
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.filter_alt)),
                    ],
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.topRight,
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    children: <Widget>[
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.download)),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.cloud_upload)),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.forward_to_inbox)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PersonTile extends StatelessWidget {
  const PersonTile({
    super.key,
    required this.title,
    required this.organization,
    required this.subCardColor,
    required this.descriptionPadding,
  });

  final String title;
  final Organization? organization;
  final Color subCardColor;
  final EdgeInsetsGeometry descriptionPadding;

  @override
  Widget build(BuildContext context) {
    Widget? nameRendered;
    String? nameAbbr;
    Widget avatarBase;
    if (organization?.name != null) {
      var name = '${organization?.name}';
      nameRendered = Text.rich(
        TextSpan(
          text: name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        style: const TextStyle(
          fontSize: 18,
        ),
      );
      nameAbbr = name.split(' ').map((e) => e.substring(0, 1)).join();
      avatarBase = Text(nameAbbr);
    } else {
      avatarBase = const Icon(Icons.person);
    }
    var avatar = CircleAvatar(
      backgroundColor: Colors.blue,
      child: avatarBase,
    );
    Widget? addressRendered;
    if (organization != null) {
      List<TextSpan> sellerSpans = [];
      if (organization!.address != null) {
        var address = organization!.address!;
        sellerSpans.add(TextSpan(
            text: '\t\t${address.streetAddress}\n'
                '\t\t${address.postalCode} ${address.addressLocality} ${address.addressCountry}'));
      }
      addressRendered = Text.rich(TextSpan(children: sellerSpans));
    }

    var theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: subCardColor,
      // surfaceTintColor: Colors.green,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: descriptionPadding,
            child: Text(title, style: TextStyle(color: theme.hintColor)),
          ),
          ExpansionTile(
            leading: avatar,
            title: nameRendered ?? const Text(''),
            children: [
              ListTile(
                title: addressRendered,
              ),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Wrap(
              alignment: WrapAlignment.end,
              children: <Widget>[
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.add_circle)),
                //todo why cancel?
                IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.message)),
              ],
            ),
          ),
          // PotentialActionRow(potentialAction: potentialAction, postFunction: postFunction)
        ],
      ),
    );
  }
}

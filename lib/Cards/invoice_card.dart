library invoice_card;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/mail_header.dart';

// import 'package:jsonld2cards/Cards/Models/organization_model.dart';
import 'package:jsonld2cards/Cards/Models/schema_types.dart';
import 'package:jsonld2cards/Cards/markup_card.dart';
import 'package:jsonld2cards/card_data.dart';
import 'package:jsonld2cards/sml_app_context.dart';
import 'package:url_launcher/url_launcher.dart';
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

    List<Map<String, dynamic>> potentialAction;
    if (invoice.potentialAction case List pAs) {
      // todo this a lazy workaround to only have the share XRechnung button in the small card
      potentialAction = pAs
          .whereType<Map<String, dynamic>>()
          .where((m) => m['muid']?.toString().isNotEmpty ?? false)
          .toList();
    } else {
      potentialAction = [];
    }
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
              // if (payee != null) payee,
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

List<Widget> renderAttachments(Invoice invoice, CardData cardData) {
  List<Widget> attachments = [];

  if (invoice.json['bg_24_additional_supporting_documents']
      case List bg24AdditionalSupportingDocuments) {
    Iterable<Map<String, dynamic>> attachmentMaps =
        bg24AdditionalSupportingDocuments
            .whereType<Map<String, dynamic>>()
            .map((e) => e['bt_125_attached_document'])
            .whereType<Map<String, dynamic>>();
    for (Map<String, dynamic> attachmentMap in attachmentMaps) {
      var fileName = attachmentMap['bt_125_2_filename'];
      var bt125Content = attachmentMap['bt_125_content'];
      var bt1251MimeCode = attachmentMap['bt_125_1_mime_code'];
      var attachmentActions = <Widget>[
        if (bt125Content is String && bt125Content.isNotEmpty)
          IconButton(
              onPressed: () {
                globalSMLAppContext!.shareFileCallback!(
                    bt125Content, bt1251MimeCode, fileName);
              },
              icon: const Icon(Icons.share, size: 16)),
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.download, size: 16)),
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.cloud_upload, size: 16)),
        IconButton(
            onPressed: () {},
            icon: const Icon(Icons.forward_to_inbox, size: 16)),
      ];
      attachments.add(Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(fileName),
          ),
          const Spacer(),
          ...attachmentActions,
        ],
      ));
    }
    for (Attachment attachment in cardData.otherAttachments ?? []) {
      var filename = attachment.filename;
      var attachmentActions = <Widget>[
        if (attachment.data != null)
          IconButton(
              onPressed: () {
                globalSMLAppContext!.shareFileCallback!(
                    attachment.data, attachment.mimeType, filename);
              },
              icon: const Icon(Icons.share, size: 16)),
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.download, size: 16)),
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.cloud_upload, size: 16)),
        IconButton(
            onPressed: () {},
            icon: const Icon(Icons.forward_to_inbox, size: 16)),
      ];
      attachments.add(Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(filename ?? '(No file name)'),
          ),
          const Spacer(),
          ...attachmentActions,
        ],
      ));
    }
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
    Uri? uri = widget.invoice.url;
    int? muid;
    bool canShareXRechnung = false;
    if (uri != null) {
      if (['cid', 'fetchid'].contains(uri.scheme) &&
          globalSMLAppContext?.shareAttachmentCallback != null) {
        if (widget.cardData.markup['muid'] case int uid) {
          muid = uid;
          canShareXRechnung = true;
        }
      }
    }

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
    List<Widget> attachments =
        renderAttachments(widget.invoice, widget.cardData);
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
    } else if (widget.invoice.json['bt_2_invoice_issue_date']
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

    String? invoicingPeriodText;
    String? deliveryDateText;
    String? deliveryPartyName;
    Widget? deliveryAddressDetails;
    if (widget.invoice.json['bg_13_delivery_information']
        case Map<String, dynamic> bg13DeliveryInformation) {
      if (bg13DeliveryInformation['bg_14_invoicing_period']
          case Map<String, dynamic> invoicingPeriod) {
        var startDate = invoicingPeriod['bt_73_start_date'];
        var endDate = invoicingPeriod['bt_74_end_date'];
        // todo I think I should do some date parsing here?
        if (startDate != null && endDate != null) {
          invoicingPeriodText = 'Leistungszeitraum von $startDate bis $endDate';
        } else if (startDate != null) {
          invoicingPeriodText = 'Leistungszeitraum ab $startDate';
        } else if (endDate != null) {
          invoicingPeriodText = 'Leistungszeitraum bis $endDate';
        }
      }
      if (bg13DeliveryInformation['bt_72_actual_delivery_date']
          case String bt72ActualDeliveryDate) {
        deliveryDateText = bt72ActualDeliveryDate;
      }
      if (bg13DeliveryInformation['bt_70_deliver_to_party_name']
          case String bt70DeliverToPartyName) {
        deliveryPartyName = bt70DeliverToPartyName;
      }
      if (bg13DeliveryInformation['bg_15_deliver_to_address']
          case Map<String, dynamic> bg15DeliverToAddress) {
        var bt75AddressLine1 = bg15DeliverToAddress['bt_75_address_line1'];
        var bt76AddressLine2 = bg15DeliverToAddress['bt_76_address_line2'];
        var bt77City = bg15DeliverToAddress['bt_77_city'];
        var bt78PostalCode = bg15DeliverToAddress['bt_78_postal_code'];
        var bt80CountryCode = bg15DeliverToAddress['bt_80_country_code'];
        deliveryAddressDetails = Text('$bt75AddressLine1\n'
            '$bt76AddressLine2\n'
            '$bt78PostalCode $bt77City ($bt80CountryCode)');
      }
    }

    Text? deliveryToRendered;
    Text? deliveryDateRendered;
    if (widget.invoice.referencesOrder != null) {
      deliveryToRendered = Text.rich(
        TextSpan(
          children: [
            const TextSpan(text: 'Lieferung an: '),
            TextSpan(
                text: deliveryPartyName,
                style: const TextStyle(fontWeight: FontWeight.bold))
          ],
        ),
      );
      if (deliveryDateText != null) {
        deliveryDateRendered = Text.rich(TextSpan(children: [
          const TextSpan(text: 'Lieferdatum: '),
          TextSpan(
            text: deliveryDateText,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ]));
      }
    }
    String? noteText;
    if (widget.invoice.json['bg_1_invoice_note'] case List bg1InvoiceNote) {
      noteText = bg1InvoiceNote
          .whereType<Map<String, dynamic>>()
          .map(
            (e) => e['bt_22_content'],
          )
          .whereType<String>()
          .join('\n');
    }
    String? paymentMeansText;
    Widget? paymentDetails;
    if (widget.invoice.json['bg_16_payment_instructions']
        case Map<String, dynamic> bg16PaymentInstructions) {
      var bt82PaymentMeansText =
          bg16PaymentInstructions['bt_82_payment_means_text'];
      if (bt82PaymentMeansText is String) {
        paymentMeansText = bt82PaymentMeansText;
      }
      var bt83RemittanceInformation =
          bg16PaymentInstructions['bt_83_remittance_information'];
      // if(bg16PaymentInstructions['bg_17_credit_transfer'] case Map<String, dynamic> bg17CreditTransfer) {
      //   var bt84PaymentId = bg16PaymentInstructions['bt_84_payment_id'];
      //   var bt85PaymentAccountName = bg16PaymentInstructions['bt_85_payment_account_name'];
      //   var bt86PaymentServiceProviderIdentifier = bg16PaymentInstructions['bt_86_payment_service_provider_identifier'];
      // }
      if (bt83RemittanceInformation != null) {
        paymentDetails = Text('($bt83RemittanceInformation)');
      }
    }

    var seller = widget.invoice.provider;
    if (widget.invoice.json['bg_4_seller']
        case Map<String, dynamic> bg4Seller) {
      var bt34ElectronicAddress = bg4Seller['bt_34_electronic_address'];
      if (bt34ElectronicAddress is String) {
        seller?.email = bt34ElectronicAddress;
      }
      if (bg4Seller['bg_6_contact'] case Map<String, dynamic> bg6Contact) {
        var bt42TelephoneNumber = bg6Contact['bt_42_telephone_number'];
        if (bt42TelephoneNumber is String) {
          seller?.telephone = bt42TelephoneNumber;
        }
      }
    }
    var customer = widget.invoice.customer;
    if (widget.invoice.json['bg_7_buyer'] case Map<String, dynamic> bg7Buyer) {
      var bt49ElectronicAddress = bg7Buyer['bt_49_electronic_address'];
      if (bt49ElectronicAddress is String) {
        customer?.email = bt49ElectronicAddress;
      }
      if (bg7Buyer['bg_9_contact'] case Map<String, dynamic> bg9Contact) {
        var bt57TelephoneNumber = bg9Contact['bt_57_telephone_number'];
        if (bt57TelephoneNumber is String) {
          customer?.telephone = bt57TelephoneNumber;
        }
      }
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
            if (widget.cardData.message != null)
              MailHeader(widget.cardData, expandable: true),
            if (widget.cardData.message != null) const Divider(),
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
              trailing: PaidBadge(json: widget.invoice.json),
            ),
            PersonTile(
              title: 'Seller',
              personData:
                  PartyData.fromJson(widget.invoice.json, PartyType.seller),
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
                          if (noteText != null) Text(noteText),
                          if (invoicingPeriodText != null)
                            Text(invoicingPeriodText),
                          if ((numberOfItems) > 0)
                            Text('$numberOfItems Rechnungsposten'),
                        ],
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
                    child: Text('Zahlung',
                        style: TextStyle(color: theme.hintColor)),
                  ),
                  if (amountRendered != null)
                    ExpansionTile(
                      title: amountRendered,
                      subtitle: (paymentMeansText != null)
                          ? Text(
                              paymentMeansText,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )
                          : null,
                      children: [
                        ListTile(
                          title: paymentDetails,
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
              personData:
                  PartyData.fromJson(widget.invoice.json, PartyType.buyer),
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
                    child: Text('Lieferung',
                        style: TextStyle(color: theme.hintColor)),
                  ),
                  if (deliveryToRendered != null)
                    ExpansionTile(
                      title: deliveryToRendered,
                      subtitle: deliveryDateRendered,
                      children: [
                        ListTile(
                          title: deliveryAddressDetails,
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
                    child: Text('Anhänge',
                        style: TextStyle(color: theme.hintColor)),
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
                  child: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.delete)),
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
                      if (canShareXRechnung)
                        IconButton(
                            onPressed: () {
                              if (muid != null && uri != null) {
                                globalSMLAppContext!.shareAttachmentCallback!(
                                    muid, uri);
                              }
                            },
                            icon: const Icon(Icons.share)),
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

class PaidBadge extends StatelessWidget {
  const PaidBadge({
    super.key,
    required this.json,
  });

  final Map<String, dynamic> json;

  @override
  Widget build(BuildContext context) {
    bool fullyPaid = false;
    bool partiallyPaid = false;
    String? paidAmount;
    if (json['bg_22_document_totals']
        case Map<String, dynamic> bg22DocumentTotals) {
      var bt112InvoiceTotalAmountWithVat =
          bg22DocumentTotals['bt_112_invoice_total_amount_with_vat'];
      var bt113PaidAmount = bg22DocumentTotals['bt_113_paid_amount'];
      fullyPaid = bt112InvoiceTotalAmountWithVat == bt113PaidAmount;
      if (bt113PaidAmount is String && bt113PaidAmount.isNotEmpty) {
        paidAmount = bt113PaidAmount;
        partiallyPaid = true;
      } else if (bt113PaidAmount is num && bt113PaidAmount > 0) {
        paidAmount = bt113PaidAmount.toString();
        partiallyPaid = true;
      }
    }
    return Card(
      elevation: 0,
      color: fullyPaid
          ? Colors.green
          : partiallyPaid
              ? Colors.orange
              : Colors.deepOrange,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          fullyPaid
              ? 'Bezahlt'
              : partiallyPaid
                  ? '$paidAmount gezahlt'
                  : 'Offen',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

enum PartyType {
  seller(
    bgKey: 'bg_4_seller',
    nameKey: 'bt_27_name',
    tradingNameKey: 'bt_28_trading_name',
    identifierKey: 'bt_29_identifier',
    legalRegistrationIdentifierKey: 'bt_30_legal_registration_identifier',
    vatIdentifierKey: 'bt_31_vat_identifier',
    additionalLegalInformationKey: 'bt_33_seller_additional_legal_information',
    electronicAddressKey: 'bt_34_electronic_address',
    addressKey: 'bg_5_seller_postal_address',
    addressKeys: AddressKeys(
      addressLine1Key: 'bt_35_address_line1',
      addressLine2Key: 'bt_36_address_line2',
      addressLine3Key: 'bt_162_address_line3',
      cityKey: 'bt_162_address_line3',
      postalCodeKey: 'bt_162_address_line3',
      countryCodeKey: 'bt_40_country_code',
    ),
    contactKey: 'bg_6_contact',
    contactKeys: ContactKeys(
      pointKey: 'bt_41_point',
      telephoneNumberKey: 'bt_42_telephone_number',
      emailAddressKey: 'bt_41_point',
    ),
  ),
  buyer(
    bgKey: 'bg_7_buyer',
    nameKey: 'bt_44_name',
    tradingNameKey: 'bt_45_buyer_trading_name',
    identifierKey: 'bt_46_identifier',
    legalRegistrationIdentifierKey: 'bt_46_identifier',
    vatIdentifierKey: 'bt_48_vat_identifier',
    electronicAddressKey: 'bt_49_electronic_address',
    addressKey: 'bg_8_buyer_postal_address',
    addressKeys: AddressKeys(
      addressLine1Key: 'bt_50_address_line1',
      addressLine2Key: 'bt_51_address_line2',
      addressLine3Key: 'bt_51_address_line2',
      cityKey: 'bt_52_city',
      postalCodeKey: 'bt_52_city',
      countryCodeKey: 'bt_52_city',
    ),
    contactKey: 'bg_9_contact',
    contactKeys: ContactKeys(
      pointKey: 'bg_6_contact',
      telephoneNumberKey: 'bg_6_contact',
      emailAddressKey: 'bt_58_email_address',
    ),
  ),
  payee(
    bgKey: 'bg_10_payee',
    nameKey: 'bt_59_name',
    identifierKey: 'bt_60_identifier',
    legalRegistrationIdentifierKey: 'bt_61_legal_registration_identifier',
  ),
  ;

  const PartyType({
    required this.bgKey,
    required this.nameKey,
    this.tradingNameKey,
    required this.identifierKey,
    required this.legalRegistrationIdentifierKey,
    this.vatIdentifierKey,
    this.additionalLegalInformationKey,
    this.electronicAddressKey,
    this.addressKey,
    this.addressKeys,
    this.contactKey,
    this.contactKeys,
  });

  final String bgKey;
  final String nameKey;
  final String? tradingNameKey;
  final String identifierKey;
  final String legalRegistrationIdentifierKey;
  final String? vatIdentifierKey;
  final String? additionalLegalInformationKey;
  final String? electronicAddressKey;
  final String? addressKey;
  final AddressKeys? addressKeys;
  final String? contactKey;
  final ContactKeys? contactKeys;
}

class AddressKeys {
  const AddressKeys({
    required this.addressLine1Key,
    required this.addressLine2Key,
    required this.addressLine3Key,
    required this.cityKey,
    required this.postalCodeKey,
    required this.countryCodeKey,
  });

  final String addressLine1Key;
  final String addressLine2Key;
  final String addressLine3Key;
  final String cityKey;
  final String postalCodeKey;
  final String countryCodeKey;
}

class ContactKeys {
  const ContactKeys({
    required this.pointKey,
    required this.telephoneNumberKey,
    required this.emailAddressKey,
  });

  final String pointKey;
  final String telephoneNumberKey;
  final String emailAddressKey;
}

/// Person or Organization for XRechnung
class PartyData {
  String? name;
  String? tradingName;
  late List<String> identifier;
  String? legalRegistrationIdentifier;
  String? vatIdentifier;
  String? additionalLegalInformation;
  String? electronicAddress;
  PostalAddress postalAddress;
  PartyContact contact;

  PartyData({
    this.name,
    this.tradingName,
    identifier,
    this.legalRegistrationIdentifier,
    this.vatIdentifier,
    this.additionalLegalInformation,
    this.electronicAddress,
    postalAddress,
    contact,
  })  : identifier = identifier ?? [],
        postalAddress = postalAddress ?? PostalAddress(),
        contact = contact ?? PartyContact();

  PartyData.fromJson(Map<String, dynamic> json, PartyType party)
      : postalAddress = PostalAddress.fromJson(json, party),
        contact = PartyContact.fromJson(json, party) {
    identifier = [];
    if (json[party.bgKey] case Map<String, dynamic> partyMap) {
      if (partyMap[party.nameKey] case String nameJ) {
        name = nameJ;
      }
      if (partyMap[party.tradingNameKey] case String tradingNameJ) {
        tradingName = tradingNameJ;
      }
      if (partyMap[party.identifierKey] case List identifier) {
        this.identifier = identifier.whereType<String>().toList();
      } else if (partyMap[party.identifierKey] case String identifier) {
        this.identifier = [identifier];
      }
      if (partyMap[party.legalRegistrationIdentifierKey]
          case String legalRegistrationIdentifierJ) {
        legalRegistrationIdentifier = legalRegistrationIdentifierJ;
      }
      if (partyMap[party.vatIdentifierKey] case String vatIdentifier) {
        this.vatIdentifier = vatIdentifier;
      }
      if (partyMap[party.additionalLegalInformationKey]
          case String additionalLegalInformation) {
        this.additionalLegalInformation = additionalLegalInformation;
      }
      if (partyMap[party.electronicAddressKey] case String electronicAddress) {
        this.electronicAddress = electronicAddress;
      }
    }
  }
}

/// Postal Address for XRechnung
class PostalAddress {
  PostalAddress({
    this.addressLine1,
    this.addressLine2,
    this.addressLine3,
    this.city,
    this.postalCode,
    this.countryCode,
  });

  String? addressLine1;
  String? addressLine2;
  String? addressLine3;
  String? city;
  String? postalCode;
  String? countryCode;

  PostalAddress.fromJson(Map<String, dynamic> json, PartyType party) {
    if (json[party.bgKey] case Map<String, dynamic> partyMap) {
      if (partyMap[party.addressKey] case Map<String, dynamic> addressMap) {
        if (addressMap[party.addressKeys?.addressLine1Key]
            case String addressLine1) {
          this.addressLine1 = addressLine1;
        }
        if (addressMap[party.addressKeys?.addressLine1Key]
            case String addressLine1) {
          this.addressLine1 = addressLine1;
        }
        if (addressMap[party.addressKeys?.addressLine2Key]
            case String addressLine2) {
          this.addressLine2 = addressLine2;
        }
        if (addressMap[party.addressKeys?.addressLine3Key]
            case String addressLine3) {
          this.addressLine3 = addressLine3;
        }
        if (addressMap[party.addressKeys?.cityKey] case String city) {
          this.city = city;
        }
        if (addressMap[party.addressKeys?.postalCodeKey]
            case String postalCode) {
          this.postalCode = postalCode;
        }
        if (addressMap[party.addressKeys?.countryCodeKey]
            case String countryCode) {
          this.countryCode = countryCode;
        }
      }
    }
  }
}

class PartyContact {
  PartyContact({
    this.point,
    this.telephoneNumber,
    this.emailAddress,
  });

  String? point;
  String? telephoneNumber;
  String? emailAddress;

  PartyContact.fromJson(Map<String, dynamic> json, PartyType party) {
    if (json[party.bgKey] case Map<String, dynamic> partyMap) {
      if (partyMap[party.contactKey] case Map<String, dynamic> contactMap) {
        if (contactMap[party.contactKeys?.pointKey] case String point) {
          this.point = point;
        }
        if (contactMap[party.contactKeys?.telephoneNumberKey]
            case String telephoneNumber) {
          this.telephoneNumber = telephoneNumber;
        }
        if (contactMap[party.contactKeys?.emailAddressKey]
            case String emailAddress) {
          this.emailAddress = emailAddress;
        }
      }
    }
  }
}

class PersonTile extends StatelessWidget {
  const PersonTile({
    super.key,
    required this.title,
    // required this.organization,
    required this.personData,
    required this.subCardColor,
    required this.descriptionPadding,
  });

  final String title;

  // final Organization? organization;
  final PartyData? personData;
  final Color subCardColor;
  final EdgeInsetsGeometry descriptionPadding;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    Widget? nameRendered;
    String? nameAbbr;
    Widget avatarBase;
    if (personData?.name != null) {
      var name = '${personData?.name}';
      String? tradingName = personData?.tradingName;
      nameRendered = Text.rich(
          TextSpan(children: [
            TextSpan(
              text: name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (tradingName != null) TextSpan(text: '\n($tradingName)')
          ]),
          style: theme.textTheme.titleMedium);
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
    if (personData != null) {
      List<TextSpan> sellerSpans = [];
      var address = personData!.postalAddress;
      sellerSpans.add(TextSpan(
          text: '${address.addressLine1}\n'
              '${address.addressLine2} ${address.addressLine3}'
              '${address.postalCode} ${address.city} ${address.countryCode}'));
      addressRendered = Text.rich(TextSpan(children: sellerSpans));
    }

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
                if (personData?.contact.telephoneNumber case String telephone)
                  IconButton(
                      onPressed: () {
                        launchUrl(Uri(scheme: 'tel', path: telephone));
                      },
                      icon: const Icon(Icons.call)),
                if (personData?.contact.emailAddress case String email)
                  IconButton(
                      onPressed: () {
                        launchUrl(Uri(scheme: 'mailto', path: email));
                      },
                      icon: const Icon(Icons.message)),
              ],
            ),
          ),
          // PotentialActionRow(potentialAction: potentialAction, postFunction: postFunction)
        ],
      ),
    );
  }
}

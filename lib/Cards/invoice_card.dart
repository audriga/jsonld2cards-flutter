library invoice_card;

import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/mail_header.dart';

// import 'package:jsonld2cards/Cards/Models/organization_model.dart';
import 'package:jsonld2cards/Cards/Models/schema_types.dart';
import 'package:jsonld2cards/Cards/markup_card.dart';
import 'package:jsonld2cards/Util/conversion.dart';
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
    // var confirmationNumber = invoice.identifier ?? invoice.confirmationNumber;
    List<TextSpan> titleTextSpans = <TextSpan>[
      const TextSpan(
          text: 'Rechnung', style: TextStyle(fontWeight: FontWeight.bold))
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
    Widget? invoiceHeader = renderInvoiceHeader(invoice);

    // var numberOfItems = invoice.referencesOrder?.length ?? 0;
    var theme = Theme.of(context);
    var descriptionPadding = const EdgeInsets.fromLTRB(8.0, 8.0, 0, 0);
    var subCardColor = theme.canvasColor;

    /// If this should blend in, use theme.cardTheme.color ?? theme.colorScheme.surfaceContainerLow;
    Widget cardContent = InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DetailInvoicePage(
            invoice: invoice,
            cardData: widget.cardData,
          ),
        ));
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
                        child: PaidBadge(json: invoice.json),
                      ),
                    ],
                  ),
                ),
                // const Spacer(flex: 1,),
                Icon(expanded ? Icons.expand_less : Icons.expand_more)
              ]),
              if (invoiceHeader != null) invoiceHeader,
              if (expanded && invoice.description != null)
                Text(
                  invoice.descriptionString!,
                  softWrap: true,
                ),
              PersonTile(
                  title: 'Seller',
                  personData:
                      PartyData.fromJson(invoice.json, PartyType.seller),
                  subCardColor: subCardColor,
                  descriptionPadding: descriptionPadding,
                  big: false),
              LeistungCard(
                  subCardColor: subCardColor,
                  descriptionPadding: descriptionPadding,
                  cardData: widget.cardData,
                  invoice: invoice,
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
    var cardContents = [
          cardContent,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DetailInvoicePage(
                        invoice: invoice,
                        cardData: widget.cardData,
                      ),
                    ));
                  },
                  child: const Text('Detailansicht'))
            ],
          )
        ];
    if (widget.cardData.showMessageHeader) {
      var messageHeader = MailHeader(widget.cardData, expandable: false,);
      cardContents.insertAll(0, [messageHeader,const Divider()]);
    }
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: cardContents,
      ),
    );
  }
}
// todo we are temporarily breaking invoices that don't have xre format data.

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

List<Widget> renderOrderedItems(Map<String, dynamic> json) {
  List<Widget> orderedItems = [];
  String? currencyCode;
  if (json['bt_6_vat_accounting_currency_code']
      case String bt6VatAccountingCurrencyCode) {
    currencyCode = bt6VatAccountingCurrencyCode;
  }
  if (json['bt_5_invoice_currency_code'] case String bt5InvoiceCurrencyCode) {
    currencyCode = bt5InvoiceCurrencyCode;
  }
  if (json['bg_25_invoice_line'] case List<dynamic> invoiceLines) {
    for (var line in invoiceLines.whereType<Map<String, dynamic>>()) {
      String? id;
      if (line['bt_126_identifier'] case String bt126Identifier) {
        id = bt126Identifier;
      }
      String? name;
      if (line['bg_31_item_information']
          case Map<String, dynamic> bg31ItemInformation) {
        if (bg31ItemInformation['bt_153_name'] case String bt153Name) {
          name = bt153Name;
        }
      }
      var nameOrId = name ?? id;
      if (nameOrId == null) {
        continue;
      }
      var nameBuffer = StringBuffer();

      if (line['bt_129_quantity'] case String bt129Quantity) {
        nameBuffer.write('$bt129Quantity ');
      }
      nameBuffer.write(nameOrId);
      String? price;
      if (line['bt_131_net_amount'] case String bt131NetAmount) {
        price = priceInCurrency(bt131NetAmount, currencyCode);
      }

      String? oid;
      if (line['bt_128_object_identifier'] case String bt128ObjectIdentifier) {
        oid = bt128ObjectIdentifier;
      }
      String? note;
      if (line['bt_127_note'] case String bt127Note) {
        note = bt127Note;
      }
      orderedItems.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(nameBuffer.toString().trim()),
                if (price != null) Text(price),
              ],
            ),
            if (oid != null)
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(oid),
              ),
            if (note != null)
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(note),
              ),
          ],
        ),
      ));
    }
  }
  // if (invoice.referencesOrder != null) {
  //   for (var order in invoice.referencesOrder!) {
  //     String? name = order.name ?? order.orderedItem?.name;
  //     String? price = order.price ?? order.acceptedOffer?.price;
  //     if (name == null || price == null) {
  //       continue;
  //     }
  //     orderedItems.add(Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(name),
  //         Text('$price€'),
  //       ],
  //     ));
  //   }
  //   // if (invoice.totalPaymentDue != null) {
  //   //   orderedItems.add(const Divider());
  //   //   orderedItems.add(Row(
  //   //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //   //     children: [
  //   //       const Text('Total'),
  //   //       Text(invoice.totalPaymentDue.toString()),
  //   //     ],
  //   //   ));
  //   // }
  // }
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
        if (bt125Content is String && bt125Content.isNotEmpty)
          IconButton(
              onPressed: () => saveB64File(fileName, bt125Content),
              icon: const Icon(Icons.download, size: 16)),
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
        if (attachment.data != null)
          IconButton(
              onPressed: () => saveFile(filename, attachment.data!),
              icon: const Icon(Icons.download, size: 16)),
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

saveB64File(String? fileName, String encodedContent) =>
    saveFile(fileName, base64Decode(encodedContent));

saveFile(String? fileName, Uint8List content) async {
  String? _ = await FilePicker.platform.saveFile(
    // dialogTitle: 'Please select an output file:',
    fileName: fileName ?? 'attachment',
    bytes: content,
  );
  //
  // if (outputFile == null) {
  //   // User canceled the picker
  // }
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
    Future<List<String>>? forwardAddresses;
    var forwardAddressesFunc = globalSMLAppContext?.forwardEmailAddresses;
    if (forwardAddressesFunc != null) {
      forwardAddresses = forwardAddressesFunc();
    }

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

    List<Widget> attachments =
        renderAttachments(widget.invoice, widget.cardData);
    var numberOfAttachments = attachments.length; // ?? 0;
    Widget? invoiceHeader = renderInvoiceHeader(widget.invoice);
    // Widget? paymentStatusRendered;//todo?
    // if (widget.invoice.paymentStatus != null) {
    //   var paymentStatus = ': ${widget.invoice.paymentStatus}';
    //   paymentStatusRendered = Text.rich(TextSpan(
    //     text: paymentStatus,
    //   ));
    // }

    DeliveryInformation? deliveryInformation =
        renderDeliveryInformation(widget.cardData.markup);
    String? deliveryDateText = deliveryInformation?.deliveryDateText;
    String? deliveryPartyName = deliveryInformation?.deliveryPartyName;
    Widget? deliveryAddressDetails =
        deliveryInformation?.deliveryAddressDetails;

    Text? deliveryToRendered;
    Text? deliveryDateRendered;
    if (deliveryPartyName != null) {
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
    }
    if (deliveryDateText != null) {
      deliveryDateRendered = Text.rich(TextSpan(children: [
        const TextSpan(text: 'Lieferdatum: '),
        TextSpan(
          text: deliveryDateText,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ]));
    }
    // String? noteText = renderNote(widget.cardData.markup);

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

    var globalButtons = [
      Align(
        alignment: Alignment.topLeft,
        child: IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
      ),
      // const Spacer(),
      // Align(
      //   alignment: Alignment.topCenter,
      //   child: Wrap(
      //     children: [
      //       IconButton(
      //           onPressed: () {},
      //           icon: const Icon(Icons.add_comment)),
      //       IconButton(
      //           onPressed: () {}, icon: const Icon(Icons.filter_alt)),
      //     ],
      //   ),
      // ),
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
                      globalSMLAppContext!.shareAttachmentCallback!(muid, uri);
                    }
                  },
                  icon: const Icon(Icons.share)),
            IconButton(
                onPressed: () {
                  // todo this does not work yet
                  if (widget.cardData.sourceFile?.data case Uint8List data) {
                    String? fileName = widget.cardData.sourceFile?.filename;
                    saveFile(fileName, data);
                  }
                },
                icon: const Icon(Icons.download)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.cloud_upload)),
            // IconButton(
            //     onPressed: () {},
            //     icon: const Icon(Icons.forward_to_inbox)),
          ],
        ),
      ),
    ];
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
              subtitle: invoiceHeader,
              trailing: PaidBadge(json: widget.invoice.json),
            ),
            PersonTile(
              title: 'Seller',
              personData:
                  PartyData.fromJson(widget.invoice.json, PartyType.seller),
              subCardColor: subCardColor,
              descriptionPadding: descriptionPadding,
              invoiceId: widget.invoice.identifier,
            ),
            LeistungCard(
              subCardColor: subCardColor,
              descriptionPadding: descriptionPadding,
              cardData: widget.cardData,
              invoice: widget.invoice,
            ),
            Payment(
                subCardColor: subCardColor,
                descriptionPadding: descriptionPadding,
                json: widget.cardData.markup),
            PersonTile(
              title: 'Käufer',
              personData:
                  PartyData.fromJson(widget.invoice.json, PartyType.buyer),
              subCardColor: subCardColor,
              descriptionPadding: descriptionPadding,
            ),
            if (deliveryToRendered != null ||
                deliveryDateRendered != null// ||
                // deliveryAddressDetails != null
            )
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
                    (deliveryAddressDetails != null) ? ExpansionTile(
                        title: deliveryToRendered ?? deliveryDateRendered ?? const Text(''),
                        subtitle: (deliveryToRendered != null)? deliveryDateRendered : null,
                        children: [
                          ListTile(
                            title: deliveryAddressDetails,
                          ),
                        ],
                      ) : ListTile(
                      title: deliveryToRendered ?? deliveryDateRendered ?? const Text(''),
                      subtitle: (deliveryToRendered != null)? deliveryDateRendered : null,
                    ),
                    // Align(
                    //   alignment: Alignment.topRight,
                    //   child: Wrap(
                    //     alignment: WrapAlignment.end,
                    //     children: <Widget>[
                    //       IconButton(
                    //           onPressed: () {}, icon: const Icon(Icons.edit)),
                    //       IconButton(
                    //           onPressed: () {}, icon: const Icon(Icons.map)),
                    //     ],
                    //   ),
                    // ),
                    // PotentialActionRow(potentialAction: potentialAction, postFunction: postFunction)
                  ],
                ),
              ),
            if (numberOfAttachments > 0)
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
                    ExpansionTile(
                      title: Text('$numberOfAttachments Anhänge'),
                      children: attachments,
                    ),
                  ],
                ),
              ),
            Row(
              children: globalButtons,
            ),
            if (widget.cardData.message != null &&
                forwardAddresses != null &&
                globalSMLAppContext?.forwardEmailCallback != null)
              FutureBuilder<List<String>>(
                future: forwardAddresses,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return SplitButton(
                      options: snapshot.data ?? [],
                      onTap: (e) => globalSMLAppContext!.forwardEmailCallback!(
                          e, widget.cardData.message!),
                    );
                  } else {
                    return Container();
                  }
                },
              )
          ],
        ),
      ),
    );
  }
}

class Payment extends StatelessWidget {
  const Payment(
      {super.key,
      required this.subCardColor,
      required this.descriptionPadding,
      required this.json});

  final Color subCardColor;
  final EdgeInsets descriptionPadding;
  final Map<String, dynamic> json;

  @override
  Widget build(BuildContext context) {
    Widget? amountRendered;
    if (json['bg_22_document_totals']
        case Map<String, dynamic> bg22DocumentTotals) {
      var bt115AmountDueForPayment =
          bg22DocumentTotals['bt_115_amount_due_for_payment'];
      amountRendered = Text.rich(
        TextSpan(
            text: priceInCurrencyFromJson(bt115AmountDueForPayment, json),
            style: const TextStyle(fontWeight: FontWeight.bold)),
        style: const TextStyle(fontSize: 18),
      );
    }
    String? bt82PaymentMeans;
    Text? bt83RemittanceInformation;
    List<Widget> bankTransferInfo = [];
    var payee = PartyData.fromJson(json, PartyType.payee);
    var seller = PartyData.fromJson(json, PartyType.seller);
    var paymentReceiver = payee.name ?? seller.name ?? seller.tradingName;
    if (paymentReceiver != null) {
      bankTransferInfo.add(Text(paymentReceiver));
    }
    if (payee.identifier.isNotEmpty) {
      bankTransferInfo.addAll(payee.identifier.map<Text>((id) => Text(id)));
    }

    if (json['bg_16_payment_instructions']
        case Map<String, dynamic> bg16PaymentInstructions) {
      if (bg16PaymentInstructions['bt_82_payment_means_text']
          case String bt82PaymentMeansText) {
        bt82PaymentMeans = bt82PaymentMeansText;
      }
      var bt83RemittanceInformationText =
          bg16PaymentInstructions['bt_83_remittance_information'];
      var bt81PaymentMeansTypeCode =
          bg16PaymentInstructions['bt_81_payment_means_type_code'];
      if (bg16PaymentInstructions['bg_17_credit_transfer']
          case List bg17CreditTransfer) {
        bg17CreditTransfer.whereType<Map<String, dynamic>>().forEach((ct) {
          if (ct['bt_84_payment_id'] case String bt84PaymentId) {
            bankTransferInfo.add(Text(bt84PaymentId));
          }
          if (ct['bt_85_payment_account_name']
              case String bt85PaymentAccountName) {
            bankTransferInfo.add(Text(bt85PaymentAccountName));
          }
          if (ct['bt_86_payment_service_provider_identifier']
              case String bt86PaymentServiceProviderIdentifier) {
            bankTransferInfo.add(Text(bt86PaymentServiceProviderIdentifier));
          }
        });
      }
      if (bt83RemittanceInformationText != null) {
        bt83RemittanceInformation = Text('($bt83RemittanceInformationText)');
      }
    }
    // bankeinzug
    var directDebitInfos = <Widget>[];
    if (json['bg_19_direct_debit'] case Map<String, dynamic> bg19DirectDebit) {
      if (bg19DirectDebit['bt_89_mandate_reference_identifier']
          case String bt89MandateReferenceIdentifier) {
        directDebitInfos.add(Text(bt89MandateReferenceIdentifier));
      }
      if (bg19DirectDebit['bt_90_bank_assigned_creditor_identifier']
          case String bt90BankAssignedCreditorIdentifier) {
        directDebitInfos.add(Text(bt90BankAssignedCreditorIdentifier));
      }
      if (bg19DirectDebit['bt_91_debited_account_identifier']
          case String bt91DebitedAccountIdentifier) {
        directDebitInfos.add(Text(bt91DebitedAccountIdentifier));
      }
    }
    // credit card
    var creditInfos = <Widget>[];
    if (json['bg_18_payment_card_information']
        case Map<String, dynamic> bg18PaymentCardInformation) {
      if (bg18PaymentCardInformation['bt_87_primary_account_number']
          case String bt87PrimaryAccountNumber) {
        creditInfos.add(Text(bt87PrimaryAccountNumber));
      }
      if (json['bt_88_holder_name'] case String bt88HolderName) {
        creditInfos.add(Text('($bt88HolderName)'));
      }
    }

    var theme = Theme.of(context);
    var details = [
      ...directDebitInfos,
      ...creditInfos,
      ...bankTransferInfo,
      if (bt83RemittanceInformation != null) bt83RemittanceInformation,
    ];
    if (details.isEmpty && amountRendered == null && bt82PaymentMeans == null) {
      return Container();
    }
    return Card(
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
              subtitle: (bt82PaymentMeans != null)
                  ? Text(
                      bt82PaymentMeans,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  : null,
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: details,
            ),
          // Align(
          //   alignment: Alignment.topRight,
          //   child: Wrap(
          //     alignment: WrapAlignment.end,
          //     children: <Widget>[
          //       IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
          //       IconButton(
          //           onPressed: () {}, icon: const Icon(Icons.credit_card)),
          //     ],
          //   ),
          // ),
          // PotentialActionRow(potentialAction: potentialAction, postFunction: postFunction)
        ],
      ),
    );
  }
}

Widget? renderInvoiceHeader(Invoice invoice) {
  var confirmationNumber = invoice.identifier ?? invoice.confirmationNumber;
  Widget? invoiceNrRendered;
  TextSpan? invoiceNrSpan;
  if (confirmationNumber != null) {
    var invoiceNr = ' $confirmationNumber';
    invoiceNrSpan = TextSpan(
      text: 'Nr.$invoiceNr',
      // style: const TextStyle(fontWeight: FontWeight.bold),
    );
    invoiceNrRendered = Text.rich(invoiceNrSpan);
  }
  Widget? invoiceDateRendered;
  TextSpan? invoiceDateSpan;
  if (invoice.dateIssued != null) {
    var dateIssued = invoice.dateIssued;
    invoiceDateSpan = TextSpan(
      text: '${dateIssued?.day}.${dateIssued?.month}.${dateIssued?.year} ',
    );
    invoiceDateRendered = Text.rich(invoiceDateSpan);
  } else if (invoice.json['bt_2_invoice_issue_date']
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

  Widget? invoiceHeader =
      invoiceNrPlusDateRendered ?? invoiceNrRendered ?? invoiceDateRendered;
  return invoiceHeader;
}

String? renderDate(dynamic inDate) {
  if (inDate is String) {
    var parsed = DateTime.tryParse(inDate);
    if (parsed != null) {
      return '${parsed.day}.${parsed.month}.${parsed.year}';
    }
    return inDate;
  } else {
    var parsed = DateTime.tryParse(inDate.toString());
    if (parsed != null) {
      return '${parsed.day}.${parsed.month}.${parsed.year}';
    }
    return null;
  }
}

DeliveryInformation? renderDeliveryInformation(dynamic json) {
  if (json case Map<String, dynamic> map) {
    if (map['bg_13_delivery_information']
        case Map<String, dynamic> bg13DeliveryInformation) {
      String? invoicingPeriodText;
      String? deliveryDateText;
      String? deliveryPartyName;
      Widget? deliveryAddressDetails;
      if (bg13DeliveryInformation['bg_14_invoicing_period']
          case Map<String, dynamic> invoicingPeriod) {
        String? startDate = renderDate(invoicingPeriod['bt_73_start_date']);
        var endDate = renderDate(invoicingPeriod['bt_74_end_date']);
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
        deliveryDateText = renderDate(bt72ActualDeliveryDate);
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
      return DeliveryInformation(
        invoicingPeriodText: invoicingPeriodText,
        deliveryDateText: deliveryDateText,
        deliveryPartyName: deliveryPartyName,
        deliveryAddressDetails: deliveryAddressDetails,
      );
    }
  }

  return null;
}

class DeliveryInformation {
  String? invoicingPeriodText;
  String? deliveryDateText;
  String? deliveryPartyName;
  Widget? deliveryAddressDetails;

  DeliveryInformation(
      {this.invoicingPeriodText,
      this.deliveryDateText,
      this.deliveryPartyName,
      this.deliveryAddressDetails});
}

String? renderNote(dynamic json) {
  String? noteText;
  if (json case Map<String, dynamic> map) {
    if (map['bg_1_invoice_note'] case List bg1InvoiceNote) {
      noteText = bg1InvoiceNote
          .whereType<Map<String, dynamic>>()
          .map(
            (e) => e['bt_22_content'],
          )
          .whereType<String>()
          .join('\n');
    }
  }
  return noteText;
}

String? priceInCurrency(String? price, String? currency) =>
    (currency != null && price != null)
        ? switch (currency) {
            'EUR' => '$price $currency',
            'USD' => '$currency $price',
            _ => '$price $currency',
          }
        : price;

String? priceInCurrencyFromJson(String price, Map<String, dynamic> json) {
  String? currencyCode;
  if (json['bt_6_vat_accounting_currency_code']
      case String bt6VatAccountingCurrencyCode) {
    currencyCode = bt6VatAccountingCurrencyCode;
  }
  if (json['bt_5_invoice_currency_code'] case String bt5InvoiceCurrencyCode) {
    currencyCode = bt5InvoiceCurrencyCode;
  }
  return priceInCurrency(price, currencyCode);
}

Widget? renderAmountDue(dynamic json) {
  if (json case Map<String, dynamic> map) {
    if (map['bg_22_document_totals']
        case Map<String, dynamic> bg22DocumentTotals) {
      if (bg22DocumentTotals['bt_115_amount_due_for_payment']
          case String bt115AmountDueForPayment) {
        String? currencyCode;
        if (json['bt_6_vat_accounting_currency_code']
            case String bt6VatAccountingCurrencyCode) {
          currencyCode = bt6VatAccountingCurrencyCode;
        }
        if (json['bt_5_invoice_currency_code']
            case String bt5InvoiceCurrencyCode) {
          currencyCode = bt5InvoiceCurrencyCode;
        }
        var ammountDueInCurrency =
            priceInCurrency(bt115AmountDueForPayment, currencyCode);
        if (ammountDueInCurrency != null) {
          return Text.rich(
            TextSpan(
                text: ammountDueInCurrency,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            style: const TextStyle(fontSize: 18),
          );
        }
      }
    }
  }
  return null;
}

Widget? renderAmount(Invoice invoice) {
  Widget? amountRendered;
  if (invoice.totalPaymentDue != null) {
    var invoiceAmountValue = invoice.totalPaymentDue.toString();
    amountRendered = Text.rich(
      TextSpan(
          text: invoiceAmountValue,
          style: const TextStyle(fontWeight: FontWeight.bold)),
      style: const TextStyle(fontSize: 18),
    );
  }
  return amountRendered;
}

class LeistungCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    Widget? amountRendered; // = renderAmount(invoice);

    if (cardData.markup['bg_22_document_totals']
        case Map<String, dynamic> bg22DocumentTotals) {
      var bt112InvoiceTotalAmountWithVat =
          bg22DocumentTotals['bt_112_invoice_total_amount_with_vat'];
      amountRendered = Text.rich(
        TextSpan(
            text: priceInCurrencyFromJson(
                bt112InvoiceTotalAmountWithVat, cardData.markup),
            style: const TextStyle(fontWeight: FontWeight.bold)),
        style: const TextStyle(fontSize: 18),
      );
    }

    const label = Text('Leistung');
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
    String? noteText = renderNote(cardData.markup);
    DeliveryInformation? deliveryInformation =
        renderDeliveryInformation(cardData.markup);
    String? invoicingPeriodText = deliveryInformation?.invoicingPeriodText;
    List<Widget> orderedItems = renderOrderedItems(cardData.markup);
    var numberOfItems = invoice.referencesOrder?.length ?? 0;
    var subtitle = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (invoicingPeriodText != null) Text(invoicingPeriodText),
        if (noteText != null && noteText.isNotEmpty)
          Text(
            noteText,
            maxLines: big ? null : 3,
            overflow: TextOverflow.ellipsis,
          ),
        if (big && (numberOfItems) > 0) Text('$numberOfItems Rechnungsposten'),
      ],
    );
    return Card(
      elevation: 0,
      color: subCardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: descriptionPadding,
            child: label,
          ),
          if (amountRendered != null)
            big
                ? ExpansionTile(
                    title: amountRendered,
                    subtitle: subtitle,
                    children: orderedItems,
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

class PaidBadge extends StatelessWidget {
  const PaidBadge({
    super.key,
    required this.json,
    this.big = true,
  });

  final Map<String, dynamic> json;
  final bool big;

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
      num? paidAmountNum = tryCastOrParseNum(bt113PaidAmount);
      if (paidAmountNum == null || paidAmountNum > 0.0 || paidAmountNum < 0.0) {
        // only render some paertial amount if it is not zero
        if (bt113PaidAmount is String && bt113PaidAmount.isNotEmpty) {
          paidAmount = priceInCurrencyFromJson(bt113PaidAmount, json);
          partiallyPaid = true;
        } else if (bt113PaidAmount is num && bt113PaidAmount > 0) {
          paidAmount =
              priceInCurrencyFromJson(bt113PaidAmount.toString(), json);
          partiallyPaid = true;
        }
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
            // fontSize: big? null : 3,
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
      cityKey: 'bt_37_city',
      postalCodeKey: 'bt_38_postal_code',
      countryCodeKey: 'bt_40_country_code',
    ),
    contactKey: 'bg_6_contact',
    contactKeys: ContactKeys(
      pointKey: 'bt_41_point',
      telephoneNumberKey: 'bt_42_telephone_number',
      emailAddressKey: 'bt_43_email_address',
    ),
  ),
  buyer(
    bgKey: 'bg_7_buyer',
    nameKey: 'bt_44_name',
    tradingNameKey: 'bt_45_buyer_trading_name',
    identifierKey: 'bt_46_identifier',
    legalRegistrationIdentifierKey: 'bt_47_legal_registration_identifier',
    vatIdentifierKey: 'bt_48_vat_identifier',
    electronicAddressKey: 'bt_49_electronic_address',
    addressKey: 'bg_8_buyer_postal_address',
    addressKeys: AddressKeys(
      addressLine1Key: 'bt_50_address_line1',
      addressLine2Key: 'bt_51_address_line2',
      addressLine3Key: 'bt_163_address_line3',
      cityKey: 'bt_52_city',
      postalCodeKey: 'bt_53_postal_code',
      countryCodeKey: 'bt_55_country_code',
    ),
    contactKey: 'bg_9_contact',
    contactKeys: ContactKeys(
      pointKey: 'bt_56_point',
      telephoneNumberKey: 'bt_57_telephone_number',
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
  const PersonTile(
      {super.key,
      required this.title,
      // required this.organization,
      required this.personData,
      required this.subCardColor,
      required this.descriptionPadding,
      this.big = true,
      this.invoiceId});

  final String title;

  // final Organization? organization;
  final PartyData? personData;
  final Color subCardColor;
  final EdgeInsetsGeometry descriptionPadding;
  final bool big;
  final String? invoiceId; // for mailto

  @override
  Widget build(BuildContext context) {
    // todo detect if empty?
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
          style:
              big ? theme.textTheme.titleMedium : theme.textTheme.titleSmall);
      nameAbbr = name.split(' ').map((e) => e.substring(0, 1)).join();
      avatarBase = Text(
        nameAbbr,
        style: big ? null : theme.textTheme.labelSmall,
      );
    } else {
      avatarBase = Icon(
        Icons.person,
        size: big ? null : theme.textTheme.labelSmall?.fontSize,
      );
    }
    var avatar = CircleAvatar(
      backgroundColor: Colors.blue,
      maxRadius: big ? null : (theme.textTheme.labelSmall?.fontSize ?? 16) + 4,
      child: avatarBase,
    );
    Widget? addressRendered;
    if (personData?.postalAddress != null) {
      // List<TextSpan> sellerSpans = [];
      String addressText = renderAddressText(personData!.postalAddress);
      addressRendered = Text.rich(TextSpan(text: addressText.trim()));
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
          big
              ? ExpansionTile(
                  leading: avatar,
                  title: nameRendered ?? const Text(''),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (personData?.contact.telephoneNumber
                        case String telephone)
                      InkWell(
                        onTap: () {
                          launchUrl(Uri(scheme: 'tel', path: telephone));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(telephone),
                        ),
                      ),
                    if (personData?.contact.emailAddress case String email)
                      InkWell(
                        onTap: () {
                          launchUrl(Uri(
                            scheme: 'mailto',
                            path: email,
                            queryParameters: (invoiceId != null)
                                ? {'subject': invoiceId}
                                : null,
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(email),
                        ),
                      ),
                    ListTile(
                      title: addressRendered,
                    ),
                  ],
                )
              : ListTile(
                  leading: avatar,
                  title: nameRendered ?? const Text(''),
                ),
          // if (big) Align(
          //   alignment: Alignment.topRight,
          //   child: Wrap(
          //     alignment: WrapAlignment.end,
          //     children: <Widget>[
          //       IconButton(
          //           onPressed: () {}, icon: const Icon(Icons.add_circle)),
          //       if (personData?.contact.telephoneNumber case String telephone)
          //         IconButton(
          //             onPressed: () {
          //               launchUrl(Uri(scheme: 'tel', path: telephone));
          //             },
          //             icon: const Icon(Icons.call)),
          //       if (personData?.contact.emailAddress case String email)
          //         IconButton(
          //             onPressed: () {
          //               launchUrl(Uri(
          //                 scheme: 'mailto',
          //                 path: email,
          //                 queryParameters: (invoiceId != null )? {'subject': invoiceId} : null,
          //               ));
          //             },
          //             icon: const Icon(Icons.email)),
          //     ],
          //   ),
          // ),
          // PotentialActionRow(potentialAction: potentialAction, postFunction: postFunction)
        ],
      ),
    );
  }
}

String renderAddressText(PostalAddress address) {
  var line1Buffer = StringBuffer();
  line1Buffer.write(address.addressLine1 ?? '');
  var line2Buffer = StringBuffer();
  line2Buffer
      .writeAll([address.addressLine2 ?? '', address.addressLine3 ?? ''], ' ');
  var line3Buffer = StringBuffer();
  line3Buffer.writeAll(
      [address.postalCode ?? '', address.city ?? '', address.countryCode ?? ''],
      ' ');
  var addressBuffer = StringBuffer();
  var line1 = line1Buffer.toString().trim();
  if (line1.isNotEmpty) {
    addressBuffer.writeln(line1);
  }
  var line2 = line2Buffer.toString().trim();
  if (line2.isNotEmpty) {
    addressBuffer.writeln(line2);
  }
  var line3 = line3Buffer.toString().trim();
  if (line3.isNotEmpty) {
    addressBuffer.write(line3);
  }
  var addressText = addressBuffer.toString();
  return addressText;
}

typedef SplitButtonCallback = Function(String option);

class SplitButton extends StatefulWidget {
  final SplitButtonCallback onTap;
  final List<String> options;

  const SplitButton({super.key, required this.onTap, required this.options});

  @override
  State<SplitButton> createState() => _SplitButtonState();
}

class _SplitButtonState extends State<SplitButton> {
  late String? dropdownValue = widget.options.firstOrNull;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.forward_to_inbox),
        if (dropdownValue != null)
          TextButton(
              onPressed: () => widget.onTap(dropdownValue!),
              child: Text(dropdownValue!)),
        widget.options.isNotEmpty
            ? MenuBar(
                children: [
                  SubmenuButton(
                    menuChildren: widget.options
                        .map<MenuItemButton>((v) => MenuItemButton(
                              child: Text(v),
                              onPressed: () {
                                setState(() {
                                  dropdownValue = v;
                                });
                              },
                            ))
                        .toList(),
                    child: const Icon(Icons.arrow_drop_down),
                  ),
                ],
              )
            : const Text('Dieses Menü wird Addressen zum weiterleiten Zeigen'),
        // DropdownMenu(
        //
        //   onSelected: (String? value){
        //     setState(() {
        //       dropdownValue = value!;
        //     });
        //   },
        //   dropdownMenuEntries: widget.options.map<DropdownMenuEntry<String>>((String value) {
        //     return DropdownMenuEntry<String>(
        //       value: value,
        //       // child: Text(value),
        //       // labelWidget: TextButton(onPressed: (){}, child: Text(value)),
        //       label: value,
        //     );
        //   }).toList(),
        //
        // ),
      ],
    );
  }
}

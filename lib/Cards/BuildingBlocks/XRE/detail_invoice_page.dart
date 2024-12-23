library detail_invoice_page;

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/attachments.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/delivery_information.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/invoice_header.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/leistung_card.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/paid_badge.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/payent.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/person_tile.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/split_button.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/trading_party.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/attachment_header.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/mail_header.dart';
import 'package:jsonld2cards/Cards/Models/invoice_model.dart';
import 'package:jsonld2cards/card_data.dart';
import 'package:jsonld2cards/sml_app_context.dart';
import 'dart:developer' as developer;
import 'package:jsonld2cards/l10n/app_localizations.dart';

import 'hints.dart';

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
    AppLocalizations l = AppLocalizations.of(context);
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
        renderAttachments(widget.invoice, widget.cardData, context);
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
        renderDeliveryInformation(widget.cardData.markup, context);
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
            TextSpan(text: '${l.to}: '),
            TextSpan(
                text: deliveryPartyName,
                style: const TextStyle(fontWeight: FontWeight.bold))
          ],
        ),
      );
    }
    if (deliveryDateText != null) {
      deliveryDateRendered = Text.rich(TextSpan(children: [
        TextSpan(text: '${l.deliveryDate}: '),
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

    var footerButtons = [
      if (widget.cardData.message != null)
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
              onPressed: () async {
                await deleteMessage(widget.cardData.message!, context);
              },
              icon: const Icon(Icons.delete)),
        ),
      if (widget.cardData.message != null)
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
              onPressed: () async {
                await archiveMessage(widget.cardData.message!, context);
              },
              icon: const Icon(Icons.archive)),
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
                  if (widget.cardData.sourceFile?.data case Uint8List data) {
                    String? fileName = widget.cardData.sourceFile?.filename;
                    String? mimeType = widget.cardData.sourceFile?.mimeType;
                    globalSMLAppContext!.saveFileCallback!(
                        data, mimeType, fileName);
                    // saveFile(fileName, data);
                  } else if (muid != null && uri != null) {
                    globalSMLAppContext!.saveAttachmentCallback!(muid, uri);
                  }
                },
                icon: const Icon(Icons.download)),
            IconButton(
                onPressed: () => apiFeedbackDialog(context),
                icon: const Icon(Icons.cloud_upload)),
            // IconButton(
            //     onPressed: () {},
            //     icon: const Icon(Icons.forward_to_inbox)),
          ],
        ),
      ),
    ];
    var renderMessageHeader = widget.cardData.message != null;
    var sourceFile = widget.cardData.sourceFile;
    var otherAttachments = widget.cardData.otherAttachments;
    var renderAttachmentsHeader =
        sourceFile != null || (otherAttachments?.isNotEmpty ?? false);
    Widget? paidBadge;
    try {
      paidBadge = PaidBadge(json: widget.invoice.json);
    } catch (e) {
      developer.log(
        'Error rendering paid badge',
        error: e,
        name: 'jsonld2cards.invoice',
      );
      // todo error widget
    }
    // todo for i18n need to use plural/ singular for attachment(s), flutter i18n supports this directly
    String attachmentTileTitle = (attachments.length > 1) ? l.attachments(2): l.attachments(1);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.details),
      ),
      body: Card(
        child: ListView(
          children: [
            if (renderMessageHeader)
              MailHeader(widget.cardData, expandable: true),
            if (renderAttachmentsHeader)
              AttachmentHeader(
                  sourceFile: sourceFile, otherAttachments: otherAttachments),
            HintsHeader(hints: widget.cardData.hints),
            if (widget.cardData.otherAttachments != null) HintsHeader(hints: widget.cardData.otherAttachments!.expand((o) => o.hints).toList()),
            if (renderMessageHeader || renderAttachmentsHeader) const Divider(),
            ListTile(
              title:  Text.rich(
                TextSpan(
                  text: l.invoice,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                style: const TextStyle(
                  fontSize: 22,
                ),
              ),
              subtitle: invoiceHeader,
              trailing: paidBadge,
            ),
            PersonTile(
              title: l.seller,
              personData:
                  PartyData.fromJson(widget.invoice.json, PartyType.seller),
              subCardColor: subCardColor,
              descriptionPadding: descriptionPadding,
              invoiceId: widget.invoice.identifier,
              cardData: widget.cardData,
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
              title: l.buyer,
              personData:
                  PartyData.fromJson(widget.invoice.json, PartyType.buyer),
              subCardColor: subCardColor,
              descriptionPadding: descriptionPadding,
              cardData: widget.cardData,
            ),
            if (deliveryToRendered != null || deliveryAddressDetails != null)
              Card(
                elevation: 0,
                color: subCardColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: descriptionPadding,
                      child: Text(l.delivery,
                          style: TextStyle(color: theme.hintColor)),
                    ),
                    (deliveryAddressDetails != null)
                        ? ExpansionTile(
                            title: deliveryToRendered ??
                                deliveryDateRendered ??
                                const Text(''),
                            subtitle: (deliveryToRendered != null)
                                ? deliveryDateRendered
                                : null,
                            children: [
                              ListTile(
                                title: deliveryAddressDetails,
                              ),
                            ],
                          )
                        : ListTile(
                            title: deliveryToRendered ??
                                deliveryDateRendered ??
                                const Text(''),
                            subtitle: (deliveryToRendered != null)
                                ? deliveryDateRendered
                                : null,
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
                      child: Text(l.attachments(2),
                          style: TextStyle(color: theme.hintColor)),
                    ),
                    ExpansionTile(
                      title: Text('$numberOfAttachments $attachmentTileTitle'),
                      children: attachments,
                    ),
                  ],
                ),
              ),
            Row(
              children: footerButtons,
            ),
            if (renderMessageHeader &&
                globalSMLAppContext?.forwardEmailCallback != null)
              ForwardButton(
                onTap: (e) {
                  forwardMessage(e,widget.cardData.message!, context);
                },
              )
          ],
        ),
      ),
    );
  }
}

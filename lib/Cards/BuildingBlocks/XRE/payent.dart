library payment;

import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/amount_due.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/epc_qr.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/skonto.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/trading_party.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/xre_format_utils.dart';

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
    SkontoInfo? skontoInfo;
    try {
      skontoInfo = SkontoInfo.skontoInfoFromJson(json);
    } catch (e) {
      // potentially show error to user?
      developer.log('Error in Skonto calculation',
          name: 'jsonld2cards.xre.payment');
    }
    if (skontoInfo != null) {
      amountRendered = Text.rich(
        TextSpan(
            text:
                '${skontoInfo.toPayInCurrency} (${skontoInfo.bt115AmountDueAndCurrency.amountInCurrency} abzgl. Skonto)',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        style: const TextStyle(fontSize: 18),
      );
    } else if (json['bg_22_document_totals']
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

    List<CreditTransferInfo> ctInfos = [];
    String? epcQrVersion;
    String? epcQrRemittanceText;
    // EpcQrIdentification? epcQrIdentification;
    if (json['bg_16_payment_instructions']
        case Map<String, dynamic> bg16PaymentInstructions) {
      if (bg16PaymentInstructions['bt_82_payment_means_text']
          case String bt82PaymentMeansText) {
        bt82PaymentMeans = bt82PaymentMeansText;
      }
      var bt83RemittanceInformationText =
          bg16PaymentInstructions['bt_83_remittance_information'];
      // Todo use to determine transaction type
      var bt81PaymentMeansTypeCode =
          bg16PaymentInstructions['bt_81_payment_means_type_code'];

      if (bt81PaymentMeansTypeCode == '30') {
        // Credit transfer (non-SEPA)
        epcQrVersion = '001';
      } else if (bt81PaymentMeansTypeCode == '58') {
        // Credit transfer SEPA
        // SCT
        epcQrVersion = '002';
        // epcQrIdentification = EpcQrIdentification.sct;
      }
      if (bg16PaymentInstructions['bg_17_credit_transfer']
          case List bg17CreditTransfer) {
        bg17CreditTransfer.whereType<Map<String, dynamic>>().forEach((ct) {
          String? iban;
          String? accountName;
          String? bic;
          if (ct['bt_84_payment_id'] case String bt84PaymentId) {
            iban = bt84PaymentId;
            bankTransferInfo.add(Text(bt84PaymentId));
          }
          if (ct['bt_85_payment_account_name']
              case String bt85PaymentAccountName) {
            accountName = bt85PaymentAccountName;
            bankTransferInfo.add(Text(bt85PaymentAccountName));
          }
          if (ct['bt_86_payment_service_provider_identifier']
              case String bt86PaymentServiceProviderIdentifier) {
            bic = bt86PaymentServiceProviderIdentifier;
            bankTransferInfo.add(Text(bt86PaymentServiceProviderIdentifier));
          }
          if (iban?.isNotEmpty ?? false) {
            ctInfos.add(
                CreditTransferInfo(iban: iban!, name: accountName, bic: bic));
          }
        });
      }
      if (bt83RemittanceInformationText != null) {
        epcQrRemittanceText = bt83RemittanceInformationText;
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

    var qrCodes = <Widget>[];
    AmountAndCurrency? epcQrAmount = skontoInfo?.toPayAmountAndCurrency ?? amountDueAndCurrency(json);
    if ((epcQrAmount?.isNonZero ?? false) && ctInfos.isNotEmpty) {
      for (var ctInfo in ctInfos) {
        var name =
            ctInfo.name ?? payee.name ?? seller.tradingName ?? seller.name;
        if (name == null) {
          continue;
        }
        qrCodes.add(EpcQr(
          version: epcQrVersion ?? '002',
          identification: EpcQrIdentification.sct,
          //todo MOCK
          bic: ctInfo.bic,
          name: name,
          iban: ctInfo.iban,
          amount: epcQrAmount!.epcAmount,
          purpose: EpcQrPurpose.gdds,
          // todo MOCK,
          remittanceText: epcQrRemittanceText,
        ));
      }
    }

    // var qr = EpcQr();

    var theme = Theme.of(context);
    var details = [
      if (bt82PaymentMeans != null) Text(bt82PaymentMeans),
      ...directDebitInfos,
      ...creditInfos,
      ...bankTransferInfo,
      if (bt83RemittanceInformation != null) bt83RemittanceInformation,
      if (qrCodes.isNotEmpty) qrCodes.first,
      // if (qr != null) qr,
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
              subtitle: const Text(
                'TODO MOCKDATA Wird eigezoven von Kreditkarte',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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

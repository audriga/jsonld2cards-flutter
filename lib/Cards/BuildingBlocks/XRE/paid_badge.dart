library paid_badge;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/Util/conversion.dart';

enum PaymentStatus {
  paid, toPayAutomatic, toPayManual, toPayUnknown, refund;
}

class PaidBadge extends StatelessWidget {
  PaidBadge({
    super.key,
    required this.json,
    this.big = true,
  }) : inferredPaymentStatus = inferPaymentStatus(json);

  final Map<String, dynamic> json;
  final bool big;
  final PaymentStatus inferredPaymentStatus;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? bg16PaymentInstructions;
    // bool hasBG18PaymentCard = false;
    // bool hasBG19DirectDebit = false;
    bool hasBG17CreditTransfer = false;
    if (json['bg_16_payment_instructions'] case Map<String, dynamic> bg16) {
      bg16PaymentInstructions = bg16;
      // var bg18 = json['bg_18_payment_card_information']; //karte, auto
      // var bg19 = json['bg_19_direct_debit']; // lastschrift, auto
      var bg17 = bg16PaymentInstructions['bg_17_credit_transfer']; //konto des verkäufers, manual
      // hasBG18PaymentCard = (bg18 is Map<String, dynamic> && bg18.isNotEmpty);
      // hasBG19DirectDebit = (bg19 is Map<String, dynamic> && bg19.isNotEmpty);
      hasBG17CreditTransfer = (bg17 is Map<String, dynamic> && bg17.isNotEmpty);
    }
    bool overdue;
    if (json['bt_9_payment_due_date'] case String bt9PaymentDueDate){
      var dueDate = DateTime.tryParse(bt9PaymentDueDate);
      if (dueDate == null) {
        throw const FormatException('Could not parse BT-9');
      }
      var now = DateTime.timestamp();
      overdue = now.isAfter(dueDate);
    } else {
      // no due date. or should I throw?
      overdue = false;
    }
    Color color = switch(inferredPaymentStatus) {
      PaymentStatus.paid => Colors.green,
      PaymentStatus.toPayAutomatic => Colors.blue,
      PaymentStatus.toPayManual => overdue? Colors.red : Colors.orange,
      PaymentStatus.toPayUnknown => overdue? Colors.red : Colors.orange,
      PaymentStatus.refund => Colors.grey,
    };
    // See https://web.audriga.com/wiki/index.php/XRE/Implementation#Payment_badge
    String label = switch(inferredPaymentStatus) {
      PaymentStatus.paid => 'Bezahlt',
      PaymentStatus.toPayAutomatic => 'Wird eingezogen',
      PaymentStatus.toPayManual => hasBG17CreditTransfer?  'Überweisen' : 'Offen',
      PaymentStatus.toPayUnknown => 'Anders',
      PaymentStatus.refund => 'Rückzahlung',
    };

    var theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: theme.textTheme.labelSmall?.fontSize ?? 8,
            // fontSize: big? null : 3,
          ),
        ),
      ),
    );
  }
}

  PaymentStatus inferPaymentStatus(Map<String, dynamic> json) {
    PaymentStatus inferredPaymentStatus;
    if (json['bg_22_document_totals']
        case Map<String, dynamic> bg22DocumentTotals) {
      var bt115AmountDueForPayment = bg22DocumentTotals['bt_115_amount_due_for_payment'];
      if (bt115AmountDueForPayment == null) {
        throw const FormatException('BT-115 is missing!');
      }
      num? bt115AmountDueForPaymentNum = tryCastOrParseNum(bt115AmountDueForPayment);
      if (bt115AmountDueForPaymentNum == null) {
        throw const FormatException('BT-115 could not get parsed to number!');
      }
      if (bt115AmountDueForPaymentNum > 0.0) {
        if (json['bg_16_payment_instructions'] case Map<String, dynamic> bg16PaymentInstructions){
         if (bg16PaymentInstructions['bt_81_payment_means_type_code'] case String bt81PaymentMeansTypeCode) {
           if (['48', '54' ,'55', '59'].contains(bt81PaymentMeansTypeCode)) {
             inferredPaymentStatus = PaymentStatus.toPayAutomatic;
           } else if (['30', '58'].contains(bt81PaymentMeansTypeCode)) {
             inferredPaymentStatus = PaymentStatus.toPayManual;
           } else {
             var bg18 = json['bg_18_payment_card_information']; //karte, auto
             var bg19 = json['bg_19_direct_debit']; // lastschrift, auto
             var bg17 = bg16PaymentInstructions['bg_17_credit_transfer']; //konto des verkäufers, manual
             if (bg18 is Map<String, dynamic> && bg18.isNotEmpty) {
               inferredPaymentStatus = PaymentStatus.toPayAutomatic;
             } else if (bg19 is Map<String, dynamic> && bg19.isNotEmpty) {
               inferredPaymentStatus = PaymentStatus.toPayAutomatic;
             } else if (bg17 is Map<String, dynamic> && bg17.isNotEmpty) {
               inferredPaymentStatus = PaymentStatus.toPayManual;
             } else {
               // todo what now?
               inferredPaymentStatus = PaymentStatus.toPayUnknown;
             }
           }
         } else  {
           throw const FormatException('BT-81 not set!');
         }
        } else  {
          throw const FormatException('BG-16 not set!');
        }
      } else  if (bt115AmountDueForPaymentNum < 0.0) {
        inferredPaymentStatus = PaymentStatus.refund;
      } else {
        inferredPaymentStatus = PaymentStatus.paid;
      }
    } else {
      throw const FormatException('No BG-9!');
    }
    return inferredPaymentStatus;
  }


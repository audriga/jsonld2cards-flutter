library paid_badge;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/xre_format_utils.dart';
import 'package:jsonld2cards/Util/conversion.dart';

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

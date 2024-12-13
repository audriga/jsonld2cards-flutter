library skonto;

import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/amount_due.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/xre_format_utils.dart';

class SkontoInfo {
  String get skontoAmountInCurrency => priceInCurrency(
      skontoAmount.toStringAsFixed(2), bt115AmountDueAndCurrency.currencyCode)!;

  String get toPayInCurrency => priceInCurrency(
      toPay.toStringAsFixed(2), bt115AmountDueAndCurrency.currencyCode)!;

  DateTime skontoDate;
  num skontoAmount;
  num toPay;
  int daysLeft;

  // not really part of skonto info itself, but needs to get grabbed for calculation
  // regardless and is displayed alongside skonto info anyways.
  AmountAndCurrency bt115AmountDueAndCurrency;

  SkontoInfo({
    required this.skontoDate,
    required this.skontoAmount,
    required this.toPay,
    required this.daysLeft,
    required this.bt115AmountDueAndCurrency,
  });

  // Wiki: If TO_PAY_MANUAL and Skonto is defined and in time, we can reduce the amount to pay
  static SkontoInfo? skontoInfoFromJson(dynamic json) {
    if (json case Map<String, dynamic> map) {
      List<SkontoSegments>? allSkontoSegments;
      DateTime? dateIssued;
      AmountAndCurrency? bt115AmountDueAndCurrency = amountDueAndCurrency(json);
      if (map['bt_20_payment_terms'] case String bt20PaymentTerms) {
        var skontoExp = RegExp(
            r'(#SKONTO#TAGE=[0-9]+#PROZENT=[0-9]+\.[0-9]{2}(#BASISBETRAG=[0-9]+\.[0-9]{2})?#)');
        var allMatches = skontoExp.allMatches(bt20PaymentTerms);
        allSkontoSegments = allMatches
            .map((m) => SkontoSegments.parseSkontoSegments(m.group(0) ?? ''))
            .nonNulls
            .toList()
          ..sort((a, b) => a.skontoDays - b.skontoDays);
      } else {
        return null;
      }
      if (map['bt_2_invoice_issue_date'] case String dateIssuedText) {
        dateIssued = DateTime.tryParse(dateIssuedText);
      }
      // if (map['bg_16_payment_instructions'] case Map<String, dynamic> bg16PaymentInstructions){
      //
      // }
      if (allSkontoSegments.isEmpty ||
          dateIssued == null ||
          bt115AmountDueAndCurrency == null) {
        return null;
      }
      int daysSince = DateTime.timestamp().difference(dateIssued).inDays;
      // DateTime.timestamp() is utc.
      // Could also use DateTime.now(), but I think .now() could throw if
      // locale is not initialized.
      // newerDate.difference(olderDate) is positive.
      // What if the invoice was issued for the future and this becomes negative?
      SkontoSegments skontoSegmentsToUse = allSkontoSegments.firstWhere(
        (sks) => (sks.skontoDays - daysSince) >= 0,
        orElse: () => allSkontoSegments!.last,
      );
      int daysLeft = skontoSegmentsToUse.skontoDays - daysSince;

      num skontoAmount;
      num skontoToPay;
      if (skontoSegmentsToUse.baseAmount != null) {
        // Liegt dem zu berechnenden Betrag nicht "Amount due for payment" (BT-115)
        // zugrunde, sondern nur ein Teil des fälligen Betrags der Rechnung,
        // ist der Grundwert zur Berechnung von Skonto als viertes Segment
        // „BASISBETRAG=n“ gemäß dem semantischen Datentypen Amount anzugeben.
        if (skontoSegmentsToUse.baseAmount! >
            bt115AmountDueAndCurrency.amountPayment) {
          throw const SkontoException('Amount too high');
        }
        // cutting off after two digits.
        skontoAmount = ((skontoSegmentsToUse.baseAmount! *
                        skontoSegmentsToUse.percentage) *
                    100)
                .floorToDouble() /
            100;
        skontoToPay = bt115AmountDueAndCurrency.amountPayment - skontoAmount;
      } else {
        // Use full bt-20
        skontoAmount = ((bt115AmountDueAndCurrency.amountPayment *
                        skontoSegmentsToUse.percentage) *
                    100)
                .floorToDouble() /
            100;
        skontoToPay = bt115AmountDueAndCurrency.amountPayment - skontoAmount;
      }
      return SkontoInfo(
          skontoDate: dateIssued,
          skontoAmount: skontoAmount,
          toPay: skontoToPay,
          daysLeft: daysLeft,
          bt115AmountDueAndCurrency: bt115AmountDueAndCurrency);
    }
    return null;
  }
}

class SkontoException extends FormatException {
  const SkontoException([super.message = "", super.source, super.offset]);
}

class SkontoSegments {
  int skontoDays;
  num percentage;
  num? baseAmount;

  SkontoSegments({
    required this.skontoDays,
    required this.percentage,
    required this.baseAmount,
  }); // optional

  static SkontoSegments? parseSkontoSegments(String bt20PaymentTerms) {
    int? skontoDays;
    num? percentage;
    num? baseAmount; // optional
    var segments = bt20PaymentTerms.split('#');
    // starts and ends with #,, so first and last segments will be empty.
    // first actual segment should be "SKONTO"
    // There should be 3-4 actual segment,
    // so including the empty segments, generated by splitting,
    // the list should be 5-6 elements long
    if (segments.length < 5 ||
        segments.first.isNotEmpty ||
        segments.last.isNotEmpty ||
        segments[1] != 'SKONTO') {
      return null;
    }
    if (segments[2].startsWith('TAGE=')) {
      skontoDays = int.tryParse(segments[2].split('TAGE=').last);
    }
    if (segments[3].startsWith('PROZENT=')) {
      percentage = num.tryParse(segments[3].split('PROZENT=').last);
    }
    if (segments[4].isNotEmpty && segments[4].startsWith('BASISBETRAG=')) {
      baseAmount = num.tryParse(segments[4].split('BASISBETRAG=').last);
    }
    if (skontoDays != null && percentage != null) {
      return SkontoSegments(
          skontoDays: skontoDays,
          percentage: percentage,
          baseAmount: baseAmount);
    }
    return null;
  }
}

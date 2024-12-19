library delivery_information;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/XRE/xre_format_utils.dart';
import 'package:url_launcher/url_launcher.dart';

DeliveryInformation? renderDeliveryInformation(dynamic json) {
  if (json case Map<String, dynamic> map) {
    if (map['bg_13_delivery_information']
        case Map<String, dynamic> bg13DeliveryInformation) {
      String? invoicingPeriodText;
      String? deliveryDateText;
      String? deliveryPartyName;
      Widget? deliveryAddressDetails;
      if (bg13DeliveryInformation['bt_72_actual_delivery_date']
          case String bt72ActualDeliveryDate) {
        deliveryDateText = renderDate(bt72ActualDeliveryDate);
      }
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
      if (invoicingPeriodText == null && deliveryDateText != null) {
        invoicingPeriodText = 'Leistungsdatum: $deliveryDateText';
      }
      if (bg13DeliveryInformation['bt_70_deliver_to_party_name']
          case String bt70DeliverToPartyName) {
        deliveryPartyName = bt70DeliverToPartyName;
      }
      if (bg13DeliveryInformation['bg_15_deliver_to_address']
          case Map<String, dynamic> bg15DeliverToAddress) {
        var bt75AddressLine1 = bg15DeliverToAddress['bt_75_address_line1'];
        var bt76AddressLine2 = bg15DeliverToAddress['bt_76_address_line2'];
        var bt165addressLine3 = bg15DeliverToAddress['bt_165_address_line3'];
        var bt77City = bg15DeliverToAddress['bt_77_city'];
        var bt78PostalCode = bg15DeliverToAddress['bt_78_postal_code'];
        var bt80CountryCode = bg15DeliverToAddress['bt_80_country_code'];
        String? countryCodeInBrackets;
        if (bt80CountryCode is String && bt80CountryCode.trim().isNotEmpty) {
          countryCodeInBrackets = '($bt80CountryCode)';
        }
        var deliveryAddressBuffer = StringBuffer();
        if (bt75AddressLine1 is String && bt75AddressLine1.trim().isNotEmpty) {
          deliveryAddressBuffer.writeln(bt75AddressLine1);
        }
        if (bt76AddressLine2 is String && bt76AddressLine2.trim().isNotEmpty) {
          deliveryAddressBuffer.writeln(bt76AddressLine2);
        }
        if (bt165addressLine3 is String &&
            bt165addressLine3.trim().isNotEmpty) {
          deliveryAddressBuffer.writeln(bt165addressLine3);
        }
        var line4Buffer = StringBuffer();
        var line4Elements = [bt78PostalCode, bt77City, countryCodeInBrackets]
            .whereType<String>()
            .where((s) => s.trim().isNotEmpty);
        line4Buffer.writeAll(line4Elements, ' ');
        var line4 = line4Buffer.toString();
        if (line4.trim().isNotEmpty) {
          deliveryAddressBuffer.write(line4);
        }
        var deliveryAddressText = deliveryAddressBuffer.toString().trim();
        deliveryAddressDetails = InkWell(
            onTap: (){
              launchUrl(Uri(
                  scheme: 'geo',
                  queryParameters: {
                    'q': deliveryAddressText,
                  }
              ));
            },

            child: Text(deliveryAddressText));
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

library invoice_model;

import 'package:jsonld2cards/Cards/Models/thing_model.dart';

import 'organization_model.dart';


class PriceSpecification {
/*
{
  "@type": "PriceSpecification",
  "price": "$70.00"
}
*/

  String? price;

  PriceSpecification({
    this.price,
  });

  PriceSpecification.fromJson(Map<String, dynamic> json) {
    price = json['price']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['@type'] = 'PriceSpecification';
    data['price'] = price;
    return data;
  }
}

class Invoice extends Thing {
/*
{
  "@context": "http://schema.org",
  "@type": "Invoice",
  "accountId": "123-456-789",
  "minimumPaymentDue": {
    "@type": "PriceSpecification",
    "price": "$70.00"
  },
  "paymentDue": "2013-11-22T08:00:00+00:00",
  "paymentStatus": "PaymentAutomaticallyApplied",
  "provider": {
    "@type": "Organization",
    "name": "Mountain View Utilities"
  },
  "totalPaymentDue": {
    "@type": "PriceSpecification",
    "price": "$70.00"
  }
}
*/

  String? accountId;
  PriceSpecification? minimumPaymentDue;
  DateTime? paymentDue;
  String? paymentStatus;
  Organization? provider;
  PriceSpecification? totalPaymentDue;
  // dynamic potentialAction;


  Invoice({
    this.accountId,
    this.minimumPaymentDue,
    this.paymentDue,
    this.paymentStatus,
    this.provider,
    this.totalPaymentDue,
    super.potentialAction,
  });

  Invoice.fromJson(Map<String, dynamic> json) : super.fromJson(json){
    accountId = json['accountId']?.toString();
    minimumPaymentDue = (json['minimumPaymentDue'] != null &&
        (json['minimumPaymentDue'] is Map))
        ? PriceSpecification.fromJson(json['minimumPaymentDue'])
        : null;
    paymentDue = DateTime.tryParse(json['paymentDue']);
    paymentStatus = json['paymentStatus']?.toString();
    // todo replace organization.fromJson with something that can also handle a list?

    provider = (json['provider'] != null && (json['provider'] is Map))
        ? Organization.fromJson(json['provider'])
        : null;
    totalPaymentDue =
    (json['totalPaymentDue'] != null && (json['totalPaymentDue'] is Map))
        ? PriceSpecification.fromJson(json['totalPaymentDue'])
        : null;
    potentialAction = json['potentialAction'];
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['@context'] = 'http://schema.org';
    data['@type'] = 'Invoice';
    data['accountId'] = accountId;
    if (minimumPaymentDue != null) {
      data['minimumPaymentDue'] = minimumPaymentDue!.toJson();
    }
    data['paymentDue'] = paymentDue?.toIso8601String();
    data['paymentStatus'] = paymentStatus;
    if (provider != null) {
      data['provider'] = provider!.toJson();
    }
    if (totalPaymentDue != null) {
      data['totalPaymentDue'] = totalPaymentDue!.toJson();
    }
    if (potentialAction != null) {
      data['potentialAction'] = potentialAction!.toJson();
    }
    return data;
  }
}
library;

import 'package:jsonld2cards/Cards/Models/thing_model.dart';

import 'order_model.dart';
import 'organization_model.dart';


class MonetaryAmount extends Thing {

  String? currency;
  String? value;
  // todo missing properties

  MonetaryAmount({
    this.currency,
    this.value,
  });

  MonetaryAmount.fromJson(Map<String, dynamic> json): super.fromJson(json) {
    currency = json['currency']?.toString();
    value = json['value']?.toString();
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['@type'] = 'MonetaryAmount';
    data['value'] = value;
    data['currency'] = currency;
    return data;
  }

  @override
  String toString() {
    return switch (currency) {
      'EUR' => '$value€',
      'USD' => '\$$value',
      String() => '$value $currency',
      null => value ?? '',
    };
  }
}

// todo this is defined twice, combine both versions
class PriceSpecification extends Thing {
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

  PriceSpecification.fromJson(Map<String, dynamic> json): super.fromJson(json) {
    price = json['price']?.toString();
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['@type'] = 'PriceSpecification';
    data['price'] = price;
    return data;
  }

  @override
  String toString() {
    return price ?? '';
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

  Map<String, dynamic> json;
  String? accountId;
  PriceSpecification? minimumPaymentDue;
  DateTime? paymentDue;
  String? paymentStatus;
  Organization? provider;
  Organization? broker;
  // Organization? seller;
  Organization? customer;
  Thing? totalPaymentDue; // MonetaryAmount or PriceSpecification
  String? confirmationNumber;
  List<Order>? referencesOrder;
  Order? purchase;
  String? paymentMethod;
  String? paymentMethodId;
  DateTime? dateIssued;
  DateTime? paymentDueDate;


  Invoice({
    required this.json,
    this.accountId,
    this.minimumPaymentDue,
    this.paymentDue,
    this.paymentStatus,
    this.provider,
    // this.seller,
    this.customer,
    this.totalPaymentDue,
    this.confirmationNumber,
    this.referencesOrder,
    this.purchase,
    this.paymentMethod,
    this.paymentMethodId,
    this.dateIssued,
    this.paymentDueDate,
    super.potentialAction,
  });

  Invoice.fromJson(this.json) : super.fromJson(json){
    accountId = json['accountId']?.toString();
    minimumPaymentDue = (json['minimumPaymentDue'] != null &&
        (json['minimumPaymentDue'] is Map))
        ? PriceSpecification.fromJson(json['minimumPaymentDue'])
        : null;
    paymentDue = DateTime.tryParse(json['paymentDue'] ?? '');
    paymentStatus = json['paymentStatus']?.toString();
    // todo replace organization.fromJson with something that can also handle a list?

    broker = (json['broker'] != null && (json['broker'] is Map))
        ? Organization.fromJson(json['broker'])
        : null;
    // seller = (json['seller'] != null && (json['seller'] is Map))
    //     ? Organization.fromJson(json['seller'])
    //     : null;
    customer = (json['customer'] != null && (json['customer'] is Map))
        ? Organization.fromJson(json['customer'])
        : null;
    provider = (json['provider'] != null && (json['provider'] is Map))
        ? Organization.fromJson(json['provider'])
        : null;
    if (json['totalPaymentDue'] case Map<String, dynamic> totalPaymentEncoded) {
      var totalPaymentType = totalPaymentEncoded['@type'];
      if (totalPaymentType is String) {
        totalPaymentDue = switch (totalPaymentType) {
          'PriceSpecification' => PriceSpecification.fromJson(totalPaymentEncoded),
          'MonetaryAmount' => MonetaryAmount.fromJson(totalPaymentEncoded),
          String() => Thing.fromJson(totalPaymentEncoded),
        };
      }
    }
    // totalPaymentDue =
    // (json['totalPaymentDue'] != null && (json['totalPaymentDue'] is Map))
    //     ? PriceSpecification.fromJson(json['totalPaymentDue'])
    //     : null;
    confirmationNumber = (json['confirmationNumber'] is String) ? json['confirmationNumber'] : null;
    if (json['purchase'] case Map<String, dynamic> purchaseMap) {
      purchase = Order.fromJson(purchaseMap);
    }
    if (json['referencesOrder'] case List referencesOrderJson) {
      referencesOrder = referencesOrderJson.whereType<Map<String,dynamic>>().map(Order.fromJson).toList();
    }
    if (json['paymentMethod'] case String paymentMethodJ) {
      paymentMethod = paymentMethodJ;
    }
    if (json['paymentMethodId'] case String paymentMethodIdJ) {
      paymentMethodId = paymentMethodIdJ;
    }
    if (json['paymentDueDate'] case String paymentDueDateJ) {
      paymentDueDate = DateTime.tryParse(paymentDueDateJ);
    }
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
    // if (seller != null) {
    //   data['seller'] = seller!.toJson();
    // }
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    if (broker != null) {
      data['broker'] = provider!.toJson();
    }
    if (provider != null) {
      data['provider'] = provider!.toJson();
    }
    if (totalPaymentDue != null) {
      data['totalPaymentDue'] = totalPaymentDue!.toJson();
    }
    if (potentialAction != null) {
      data['potentialAction'] = potentialAction!.toJson();
    }
    if (confirmationNumber != null) {
      data['confirmationNumber'] = confirmationNumber;
    }
    if (purchase != null) {
      data['purchase'] = purchase!.toJson();
    }
    if (referencesOrder != null) {
      data['referencesOrder'] = referencesOrder!.map((e) => e.toJson).toList();
    }
    return data;
  }
}
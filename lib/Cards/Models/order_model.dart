library order_model;

import 'package:jsonld2cards/Cards/Models/thing_model.dart';
import 'package:jsonld2cards/Util/conversion.dart';

import 'organization_model.dart';
import 'product_model.dart';

///
/// Used code generator (https://ashamp.github.io/jsonToDartModel/)
/// But much customization was neccessary.
/// See https://docs.flutter.dev/data-and-backend/serialization/json for more
/// sensible approaches in Future
///

class QuantitativeValue {
/*
{
  "@type": "QuantitativeValue",
  "value": "1"
}
*/

  num? value;

  QuantitativeValue({
    this.value,
  });

  QuantitativeValue.fromJson(Map<String, dynamic> json) {
    value = num.tryParse(json['value']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['@type'] = 'QuantitativeValue';
    data['value'] = value.toString();
    return data;
  }
}



class Offer {
/*
{
  "@type": "Offer",
  "itemOffered": {
    "@type": "Product",
    "name": "Google Chromecast",
    "sku": "B00DR0PDNE",
    "url": "http://www.amazon.com/Google-Chromecast-Streaming-Media-Player/dp/B00DR0PDNE/",
    "image": "http://ecx.images-amazon.com/images/I/811nvG%2BLgML._SY550_.jpg"
  },
  "price": "29.99",
  "priceCurrency": "USD",
  "eligibleQuantity": {
    "@type": "QuantitativeValue",
    "value": "1"
  }
}
*/

  Product? itemOffered;
  String? price;
  String? priceCurrency;
  QuantitativeValue? eligibleQuantity;

  Offer({
    this.itemOffered,
    this.price,
    this.priceCurrency,
    this.eligibleQuantity,
  });

  Offer.fromJson(Map<String, dynamic> json) {
    itemOffered = (json['itemOffered'] != null && (json['itemOffered'] is Map))
        ? Product.fromJson(json['itemOffered'])
        : null;
    price = json['price']?.toString();
    priceCurrency = json['priceCurrency']?.toString();
    eligibleQuantity = (json['eligibleQuantity'] != null &&
        (json['eligibleQuantity'] is Map))
        ? QuantitativeValue.fromJson(json['eligibleQuantity'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['@type'] = 'Offer';
    if (itemOffered != null) {
      data['itemOffered'] = itemOffered!.toJson();
    }
    data['price'] = price;
    data['priceCurrency'] = priceCurrency;
    if (eligibleQuantity != null) {
      data['eligibleQuantity'] = eligibleQuantity!.toJson();
    }
    return data;
  }
}


// todo this is defined twice, combine both
class PriceSpecification {
/*
{
  "@type": "PriceSpecification",
  "validFrom": "2024-12-07T23:30:00-08:00"
}
*/

  DateTime? validFrom;

  PriceSpecification({
    this.validFrom,
  });

  PriceSpecification.fromJson(Map<String, dynamic> json) {
    validFrom = DateTime.tryParse(json['validFrom']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['@type'] = 'PriceSpecification';
    data['validFrom'] = validFrom?.toIso8601String();
    return data;
  }
}


enum OrderStatus {
  orderCancelled,
  orderDelivered,
  orderInTransit,
  orderPaymentDue,
  orderPickupAvailable,
  orderProblem,
  orderProcessing,
  orderReturned,
}

OrderStatus? orderStatusFromString(String? orderStatusAsString) {
  if (orderStatusAsString == null) return null;
  var orderStatusAsUri = Uri.tryParse(orderStatusAsString);
  if (orderStatusAsUri != null) {
    orderStatusAsString = orderStatusAsUri.path;
  }
  switch (orderStatusAsString) {
    case 'OrderCancelled':
      return OrderStatus.orderCancelled;
    case 'OrderDelivered':
      return OrderStatus.orderDelivered;
    case 'OrderInTransit':
      return OrderStatus.orderInTransit;
    case 'OrderPaymentDue':
      return OrderStatus.orderPaymentDue;
    case 'OrderPickupAvailable':
      return OrderStatus.orderPickupAvailable;
    case 'OrderProblem':
      return OrderStatus.orderProblem;
    case 'OrderProcessing':
      return OrderStatus.orderProcessing;
    case 'OrderReturned':
      return OrderStatus.orderReturned;
    default:
      return null;
  }
}

String orderStatusToString(OrderStatus status) {
  switch(status) {
    case OrderStatus.orderCancelled: 'http://schema.org/OrderDelivered';
    case OrderStatus.orderInTransit: 'http://schema.org/OrderInTransit';
    case OrderStatus.orderPaymentDue: 'http://schema.org/OrderPaymentDue';
    case OrderStatus.orderPickupAvailable: 'http://schema.org/OrderPickupAvailable';
    case OrderStatus.orderProblem: 'http://schema.org/OrderProblem';
    case OrderStatus.orderProcessing: 'http://schema.org/OrderProcessing';
    case OrderStatus.orderReturned: 'http://schema.org/OrderReturned';
    default: return '';
  }
  return '';
}
String orderStatusToVerbString(OrderStatus status) {
  switch(status) {
    case OrderStatus.orderCancelled: 'is delivered';
    case OrderStatus.orderInTransit: 'is in transit';
    case OrderStatus.orderPaymentDue: 'payment is due';
    case OrderStatus.orderPickupAvailable: 'pickup is available';
    case OrderStatus.orderProblem: 'has a problem';
    case OrderStatus.orderProcessing: 'is processing';
    case OrderStatus.orderReturned: 'is returned';
    default: return '';
  }
  return '';
}

// todo this does not extend Thing. Why?
class Order extends Thing {
/*
{
  "@context": "http://schema.org",
  "@type": "Order",
  "merchant": {
    "@type": "Organization",
    "name": "Amazon.com"
  },
  "orderNumber": "123-4567890-1234567",
  "orderStatus": "http://schema.org/OrderProcessing",
  "priceCurrency": "USD",
  "price": "29.99",
  "priceSpecification": {
    "@type": "PriceSpecification",
    "validFrom": "2024-12-07T23:30:00-08:00"
  },
  "acceptedOffer": {
    "@type": "Offer",
    "itemOffered": {
      "@type": "Product",
      "name": "Google Chromecast",
      "sku": "B00DR0PDNE",
      "url": "http://www.amazon.com/Google-Chromecast-Streaming-Media-Player/dp/B00DR0PDNE/",
      "image": "http://ecx.images-amazon.com/images/I/811nvG%2BLgML._SY550_.jpg"
    },
    "price": "29.99",
    "priceCurrency": "USD",
    "eligibleQuantity": {
      "@type": "QuantitativeValue",
      "value": "1"
    }
  },
  "url": "https://www.amazon.ca/gp/css/summary/edit.html/orderID=123-4567890-1234567",
  "potentialAction": {
    "@type": "ViewAction",
    "url": "https://www.amazon.ca/gp/css/summary/edit.html/orderID=123-4567890-1234567"
  }
}
*/

  Organization? merchant;
  String? orderNumber;

  ///  Is an enum, see https://schema.org/OrderStatus
  ///  Members are
  /// OrderCancelled
  /// OrderDelivered
  /// OrderInTransit
  /// OrderPaymentDue
  /// OrderPickupAvailable
  /// OrderProblem
  /// OrderProcessing
  /// OrderReturned

  OrderStatus? orderStatus;
  Product? orderedItem;
  String? priceCurrency;
  String? price;
  PriceSpecification? priceSpecification;
  Offer? acceptedOffer;
  // Uri? url;
  // dynamic potentialAction;

  Order({
    this.merchant,
    this.orderNumber,
    this.orderedItem,
    this.orderStatus,
    this.priceCurrency,
    this.price,
    this.priceSpecification,
    this.acceptedOffer,
    super.url,
    super.potentialAction,
  });

  Order.fromJson(Map<String, dynamic> json) : super.fromJson(json){
    // Verifying of context is skipped, as it is already done by renderCard function
    assert(json['@type'] == 'Order', 'Type of Order should always be Order');
    orderedItem = (json['orderedItem'] != null && (json['orderedItem'] is Map))
        ? Product.fromJson(json['orderedItem'])
        : null;
    merchant = (json['merchant'] != null && (json['merchant'] is Map))
        ? Organization.fromJson(json['merchant'])
        : null;
    orderNumber = json['orderNumber']?.toString();
    orderStatus = orderStatusFromString(json['orderStatus']?.toString());
    priceCurrency = json['priceCurrency']?.toString();
    price = json['price']?.toString();
    priceSpecification = (json['priceSpecification'] != null &&
        (json['priceSpecification'] is Map))
        ? PriceSpecification.fromJson(json['priceSpecification'])
        : null;
    acceptedOffer =
    (json['acceptedOffer'] != null && (json['acceptedOffer'] is Map))
        ? Offer.fromJson(json['acceptedOffer'])
        : null;
    url = tryCastOrParse(json['url']);
    potentialAction = json['potentialAction'];
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['@context'] = 'http://schema.org';
    data['@type'] = 'Order';
    if (merchant != null) {
      data['merchant'] = merchant!.toJson();
    }
    if (orderedItem != null) {
      data['orderedItem'] = orderedItem!.toJson();
    }
    data['orderNumber'] = orderNumber;
    if (orderStatus != null) {
      data['orderStatus'] = orderStatusToString(orderStatus!);
    }
    data['priceCurrency'] = priceCurrency;
    data['price'] = price;
    if (priceSpecification != null) {
      data['priceSpecification'] = priceSpecification!.toJson();
    }
    if (acceptedOffer != null) {
      data['acceptedOffer'] = acceptedOffer!.toJson();
    }
    data['url'] = url;
    if (potentialAction != null) {
      data['potentialAction'] = potentialAction!.toJson();
    }
    return data;
  }
}

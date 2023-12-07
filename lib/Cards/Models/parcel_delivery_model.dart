library parcel_delivery;


// Note: This is a "quick and dirty" model, to make creation of the card easier.
// Not to be taken as the model to be.
import 'package:jsonld2cards/Cards/Models/order_model.dart';
import 'package:jsonld2cards/Cards/Models/thing_model.dart';

import 'organization_model.dart';
import 'product_model.dart';


// Part of the https://schema.org/DeliveryMethod enum.
class ParcelService {
/*
{
  "@type": "ParcelService",
  "name": "http://schema.org/ParcelService"
}
*/

  String? name;

  ParcelService({
    this.name,
  });

  ParcelService.fromJson(Map<String, dynamic> json) {
    name = json['name']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['@type'] = 'ParcelService';
    data['name'] = name;
    return data;
  }
}

class PostalAddress {
/*
{
  "@type": "PostalAddress",
  "name": "John Frank",
  "streetAddress": "25 Willie Mays Plaza",
  "addressLocality": "San Francisco",
  "addressRegion": "CA",
  "addressCountry": "US",
  "postalCode": "94107"
}
*/

  String? name;
  String? streetAddress;
  String? addressLocality;
  String? addressRegion;
  String? addressCountry;
  String? postalCode;

  PostalAddress({
    this.name,
    this.streetAddress,
    this.addressLocality,
    this.addressRegion,
    this.addressCountry,
    this.postalCode,
  });

  PostalAddress.fromJson(Map<String, dynamic> json) {
    name = json['name']?.toString();
    streetAddress = json['streetAddress']?.toString();
    addressLocality = json['addressLocality']?.toString();
    addressRegion = json['addressRegion']?.toString();
    addressCountry = json['addressCountry']?.toString();
    postalCode = json['postalCode']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['@type'] = 'PostalAddress';
    data['name'] = name;
    data['streetAddress'] = streetAddress;
    data['addressLocality'] = addressLocality;
    data['addressRegion'] = addressRegion;
    data['addressCountry'] = addressCountry;
    data['postalCode'] = postalCode;
    return data;
  }
}

class ParcelDelivery extends Thing {
/*
{
  "@context": "http://schema.org",
  "@type": "ParcelDelivery",
  "deliveryAddress": {
    "@type": "PostalAddress",
    "name": "John Frank",
    "streetAddress": "24 Willie Mays Plaza",
    "addressLocality": "San Francisco",
    "addressRegion": "CA",
    "addressCountry": "US",
    "postalCode": "94107"
  },
  "originAddress": {
    "@type": "PostalAddress",
    "name": "John Frank",
    "streetAddress": "25 Willie Mays Plaza",
    "addressLocality": "San Francisco",
    "addressRegion": "CA",
    "addressCountry": "US",
    "postalCode": "94107"
  },
  "expectedArrivalFrom": "2024-03-10T12:00:00-08:00",
  "expectedArrivalUntil": "2024-03-12T12:00:00-08:00",
  "carrier": {
    "@type": "Organization",
    "name": "FedEx",
    "url": "http://fedex.com/"
  },
  "itemShipped": {
    "@type": "Product",
    "name": "iPod Mini",
    "url": "http://apple.com/ipad32gb",
    "image": "http://apple.com/images/ipad32gb.jpg",
    "sku": "B00DR0PDNE",
    "description": "iPod Mini 32Gb White",
    "brand": {
      "@type": "Brand",
      "name": "Apple"
    },
    "color": "white"
  },
  "trackingNumber": "3453291231",
  "trackingUrl": "http://fedex.com/track/3453291231",
  "potentialAction": {
    "@type": "TrackAction",
    "url": "http://fedex.com/track/3453291231"
  },
  "hasDeliveryMethod": {
    "@type": "ParcelService",
    "name": "http://schema.org/ParcelService"
  },
  "partOfOrder": {
    "@type": "Order",
    "orderNumber": "176057",
    "merchant": {
      "@type": "Organization",
      "name": "Bob Dole",
      "sameAs": "http://www.freebase.com/m/0fhkx"
    },
    "orderStatus": "http://schema.org/OrderInTransit"
  }
}
*/

  PostalAddress? deliveryAddress;
  PostalAddress? originAddress;
  String? expectedArrivalFrom;
  String? expectedArrivalUntil;
  Organization? carrier;
  Product? itemShipped;
  String? trackingNumber;
  String? trackingUrl;
  // dynamic potentialAction;
  ParcelService? hasDeliveryMethod;
  Order? partOfOrder;

  ParcelDelivery({
    this.deliveryAddress,
    this.originAddress,
    this.expectedArrivalFrom,
    this.expectedArrivalUntil,
    this.carrier,
    this.itemShipped,
    this.trackingNumber,
    this.trackingUrl,
    super.potentialAction,
    this.hasDeliveryMethod,
    this.partOfOrder,
  });

  ParcelDelivery.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    deliveryAddress =
        (json['deliveryAddress'] != null && (json['deliveryAddress'] is Map))
            ? PostalAddress.fromJson(json['deliveryAddress'])
            : null;
    originAddress =
        (json['originAddress'] != null && (json['originAddress'] is Map))
            ? PostalAddress.fromJson(json['originAddress'])
            : null;
    expectedArrivalFrom = json['expectedArrivalFrom']?.toString();
    expectedArrivalUntil = json['expectedArrivalUntil']?.toString();
    carrier = (json['carrier'] != null && (json['carrier'] is Map))
        ? Organization.fromJson(json['carrier'])
        : null;
    itemShipped = (json['itemShipped'] != null && (json['itemShipped'] is Map))
        ? Product.fromJson(json['itemShipped'])
        : null;
    trackingNumber = json['trackingNumber']?.toString();
    trackingUrl = json['trackingUrl']?.toString();
    potentialAction = json['potentialAction'];
    hasDeliveryMethod = (json['hasDeliveryMethod'] != null &&
            (json['hasDeliveryMethod'] is Map))
        ? ParcelService.fromJson(json['hasDeliveryMethod'])
        : null;
    partOfOrder = (json['partOfOrder'] != null && (json['partOfOrder'] is Map))
        ? Order.fromJson(json['partOfOrder'])
        : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['@type'] = 'ParcelDelivery';
    if (deliveryAddress != null) {
      data['deliveryAddress'] = deliveryAddress!.toJson();
    }
    if (originAddress != null) {
      data['originAddress'] = originAddress!.toJson();
    }
    data['expectedArrivalFrom'] = expectedArrivalFrom;
    data['expectedArrivalUntil'] = expectedArrivalUntil;
    if (carrier != null) {
      data['carrier'] = carrier!.toJson();
    }
    if (itemShipped != null) {
      data['itemShipped'] = itemShipped!.toJson();
    }
    data['trackingNumber'] = trackingNumber;
    data['trackingUrl'] = trackingUrl;
    if (potentialAction != null) {
      data['potentialAction'] = potentialAction!.toJson();
    }
    if (hasDeliveryMethod != null) {
      data['hasDeliveryMethod'] = hasDeliveryMethod!.toJson();
    }
    if (partOfOrder != null) {
      data['partOfOrder'] = partOfOrder!.toJson();
    }
    return data;
  }
}

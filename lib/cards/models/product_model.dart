library;

import 'package:jsonld2cards/util/conversion.dart';

class Brand {
/*
{
  "@type": "Brand",
  "name": "Apple"
}
*/

  String? name;

  Brand({
    this.name,
  });

  Brand.fromJson(Map<String, dynamic> json) {
    name = json['name']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['@type'] = 'Brand';
    data['name'] = name;
    return data;
  }
}

class Product {
/*
{
  "@type": "Product",
  "name": "Google Chromecast",
  "sku": "B00DR0PDNE",
  "url": "http://www.amazon.com/Google-Chromecast-Streaming-Media-Player/dp/B00DR0PDNE/",
  "image": "http://ecx.images-amazon.com/images/I/811nvG%2BLgML._SY550_.jpg"
}

{
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
}
*/

  String? name;
  String? sku;
  Uri? url;
  Uri? image;
  String? description;
  Brand? brand;
  String? color;

  Product({
    this.name,
    this.sku,
    this.url,
    this.image,
  });

  Product.fromJson(Map<String, dynamic> json) {
    name = json['name']?.toString();
    sku = json['sku']?.toString();
    url = tryCastOrParse(json['url']);
    var jsonImage = json['image'];
    if (jsonImage != null) {
      image = tryCastOrParse(jsonImage);
    }
    description = json['description']?.toString();
    brand = (json['brand'] != null && (json['brand'] is Map)) ? Brand.fromJson(json['brand']) : null;
    color = json['color']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['@type'] = 'Product';
    data['name'] = name;
    data['sku'] = sku;
    data['url'] = url;
    data['image'] = image;
    data['description'] = description;
    if (brand != null) {
      data['brand'] = brand!.toJson();
    }
    data['color'] = color;
    return data;
  }
}

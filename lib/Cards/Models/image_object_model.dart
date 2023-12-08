library image_object_model;

import 'thing_model.dart';

class ImageObject extends Thing{
/*
{
   "@type": "ImageObject",
  "url": "https://static.zeit.de/p/zeit.web/images/structured-data-publisher-logo-zon.png",
  "width": 565,
  "height": 60
}
*/


  // Todo still missing contentUrl
  num? width;
  num? height;

  ImageObject({
    this.width,
    this.height,
  });

  ImageObject.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    width = json['width'];
    height = json['height'];
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['@type'] = 'ImageObject';
    data['width'] = width;
    data['height'] = height;
    return data;
  }
}
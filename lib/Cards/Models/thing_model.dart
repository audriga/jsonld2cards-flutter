library thing_model;

import 'package:jsonld2cards/Util/conversion.dart';

import 'image_object_model.dart';

class Thing {
  Uri? id;
  String? alternateName;
  // todo can also be a https://schema.org/TextObject instead
  String? description;
  ///  image is either [ImageObject]  or URL
  Uri? imageUri;
  ImageObject? imageImgObj;
  String? name;
  dynamic potentialAction;
  Uri? url;

  Thing({
    this.id,
    this.alternateName,
    this.description,
    this.imageUri,
    this.imageImgObj,
    this.name,
    this.potentialAction,
    this.url
  });

  Thing.fromJson(Map<String, dynamic> json) {
    id = json['@id'];
    alternateName = json['alternateName'];
    description = json['description'];
    var image = json['image'];
    if (image is Map<String, dynamic>) {
      imageImgObj = ImageObject.fromJson(image);
    } else if (image != null) {
      imageUri = tryCastOrParse(image);
    }
    name = json['name'];
    potentialAction = json['potentialAction'];
    url = tryCastOrParse(json['url']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['@type'] = 'Thing';
    data['@id'] = id?.toString();
    data['alternateName'] = alternateName;
    data['description'] = description;
    if (imageImgObj != null) {
      data['image'] = imageImgObj!.toJson();
    } else {
      data['image'] = imageUri?.toString();
    }
    data['name'] = name;
    if (potentialAction != null) {
      data['potentialAction'] = potentialAction!.toJson();
    }
    data['url'] = url?.toString();
    return data;
  }
}
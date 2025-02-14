library;

import 'package:jsonld2cards/util/conversion.dart';

import 'image_object_model.dart';

class Thing {
  /// The type of the Schema.org Thing. If we modelled all things this would be
  /// superfluous as the runtime type could stand in for this property. But as it
  /// stands, when a json for a type we don't know yet is cast into [Thing] we want
  /// to save the original type.
  /// Alternatively we could make Thing abstract to avoid this.
  String type;
  Uri? id;
  String? alternateName;
  // todo can also be a https://schema.org/TextObject instead
  dynamic description; // List or String
  ///  image is either [ImageObject]  or URL
  Uri? imageUri;
  ImageObject? imageImgObj;
  String? name;
  dynamic potentialAction;
  Uri? url;
  String? identifier;

  int get duplicateHash =>
      type.hashCode ^
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      url.hashCode;
  String? get descriptionString => (description is List)
      ? (description as List).whereType<String>().join('\n')
      : description.toString();

  Thing({
    this.id,
    this.type = 'Thing',
    this.alternateName,
    this.description,
    this.imageUri,
    this.imageImgObj,
    this.name,
    this.potentialAction,
    this.url,
    this.identifier,
  });

  Thing.fromJson(Map<String, dynamic> json) : type = json['@type'] ?? 'Thing' {
    id = tryCastOrParse(json['@id']);
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
    if (json['identifier'] case String jsonIdentifier) {
      identifier = jsonIdentifier;
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['@context'] = 'https://schema.org';
    data['@type'] = type;
    data['@id'] = id?.toString();
    data['alternateName'] = alternateName;
    data['description'] = description;
    data['identifier'] = identifier;
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
    return data
      ..removeWhere(
        (key, value) => value == null,
      );
  }
}

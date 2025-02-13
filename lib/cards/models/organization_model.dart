library;

import 'package:jsonld2cards/cards/models/parcel_delivery_model.dart';
import 'package:jsonld2cards/cards/models/thing_model.dart';
import 'package:jsonld2cards/util/conversion.dart';

import 'image_object_model.dart';

class Organization extends Thing {
/*
{
  "@type": "Organization",
  "name": "Bob Dole",
  "sameAs": "http://www.freebase.com/m/0fhkx"
}
*/


  String? legalName;
  Uri? sameAs;
  PostalAddress? address;
  /// logo is an associated logo. Is either [ImageObject]  or URL
  Uri? logoUri;
  ImageObject? logoImgObj;

  Uri? get logo {
    return logoImgObj?.url ?? logoUri;
  }
  String? telephone;
  String? email;


  Organization({
    this.sameAs,
    this.address,
    this.legalName,
    this.logoImgObj,
    this.logoUri,
    this.telephone,
    this.email,
  });

  Organization.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    sameAs = tryCastOrParse(json['sameAs']);
    if (json['address'] case Map<String,dynamic> addressMap) {
      address = PostalAddress.fromJson(addressMap);
    }
    legalName = json['legalName'];
    var logoAttr = json['logo'];
    if (logoAttr is Map<String, dynamic>) {
      logoImgObj = ImageObject.fromJson(logoAttr);
    } else if (logoAttr != null) {
      logoUri = tryCastOrParse(logoAttr);
    }
    if (json['telephone'] case String jTelephone) {
      telephone = jTelephone;
    }
    if (json['email'] case String jEmail) {
      email = jEmail;
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['@type'] = 'Organization';
    data['sameAs'] = sameAs?.toString();
    data['address'] = address?.toJson();
    data['legalName'] = legalName;
    if (logoImgObj != null) {
      data['logo'] = logoImgObj!.toJson();
    } else {
      data['logo'] = logoUri?.toString();
    }
    data['telephone'] = telephone;
    data['email'] = email;
    return data;
  }
}
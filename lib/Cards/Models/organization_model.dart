library organization_model;

import 'package:jsonld2cards/Cards/Models/thing_model.dart';
import 'package:jsonld2cards/Util/conversion.dart';

import 'image_object_model.dart';

// todo there's some overlap with Organization from promo_tab_card
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
  /// logo is an associated logo. Is either [ImageObject]  or URL
  Uri? logoUri;
  ImageObject? logoImgObj;

  Uri? get logo {
    return logoImgObj?.url ?? logoUri;
  }


  Organization({
    this.sameAs,
    this.legalName,
    this.logoImgObj,
    this.logoUri,
  });

  Organization.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    sameAs = tryCastOrParse(json['sameAs']);
    legalName = json['legalName'];
    var logoAttr = json['logo'];
    if (logoAttr is Map<String, dynamic>) {
      logoImgObj = ImageObject.fromJson(logoAttr);
    } else if (logoAttr != null) {
      logoUri = tryCastOrParse(logoAttr);
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['@type'] = 'Organization';
    data['sameAs'] = sameAs?.toString();
    data['legalName'] = legalName;
    if (logoImgObj != null) {
      data['logo'] = logoImgObj!.toJson();
    } else {
      data['logo'] = logoUri?.toString();
    }
    return data;
  }
}
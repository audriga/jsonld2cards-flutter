library organization_model;

import 'package:jsonld2cards/Util/conversion.dart';

// todo there's some overlap with Organization from promo_tab_card
class Organization {
/*
{
  "@type": "Organization",
  "name": "Bob Dole",
  "sameAs": "http://www.freebase.com/m/0fhkx"
}
*/

  String? name;
  Uri? sameAs;

  Organization({
    this.name,
    this.sameAs,
  });

  Organization.fromJson(Map<String, dynamic> json) {
    name = json['name']?.toString();
    sameAs = tryCastOrParse(json['sameAs']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['@type'] = 'Organization';
    data['name'] = name;
    data['sameAs'] = sameAs?.toString();
    return data;
  }
}
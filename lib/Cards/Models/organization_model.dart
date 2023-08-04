library organization_model;

// todo there's some overlap with Organization from promo_tab_card
class Organization {
/*
{
  "@type": "Organization",
  "name": "Amazon.com"
}
*/

  String? name;

  Organization({
    this.name,
  });

  Organization.fromJson(Map<String, dynamic> json) {
    name = json['name']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['@type'] = 'Organization';
    data['name'] = name;
    return data;
  }
}
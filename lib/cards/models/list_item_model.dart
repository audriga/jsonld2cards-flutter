library;

import 'package:jsonld2cards/cards/models/thing_model.dart';

class ListItem extends Thing {
  Thing? item;
  ListItem? nextItem;
  num? position;
  ListItem? previousItem;

  ListItem({this.item, this.nextItem, this.position, this.previousItem});

  ListItem.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    var jsonItem = json['item'];
    if (jsonItem != null) {
      /*
      {
        "@type": "ListItem",
        "position": 1,
        "item": {
          "@id": "https://www.zeit.de/index",
          "name": "ZEIT ONLINE"
        }

        vs

        {
        "@type": "ListItem",
        "position": 2,
        "name": "Aufbewahrung &amp; Organisation",
        "item": "https://www.ikea.com/de/de/cat/aufbewahrungsmoebel-organisation-st001/"
      }
       */
      if (jsonItem is Map<String, dynamic>) {
        item = Thing.fromJson(jsonItem);
      }
    }
    var jsonPosition = json['position'];
    if (jsonPosition is num) {
      position = jsonPosition;
    } else if (jsonPosition is String) {
      position = num.tryParse(jsonPosition);
    }
    var jsonNextItem = json['nextItem'];
    if (jsonNextItem != null) {
      nextItem = ListItem.fromJson(jsonNextItem);
    }
    var jsonPreviousItem = json['previousItem'];
    if (jsonPreviousItem != null) {
      previousItem = ListItem.fromJson(jsonPreviousItem);
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['@type'] = 'ListItem';
    if (item != null) data['item'] = item?.toJson();
    if (nextItem != null) data['nextItem'] = nextItem?.toJson();
    data['position'] = position;
    if (previousItem != null) data['previousItem'] = previousItem?.toJson();

    return data;
  }
}

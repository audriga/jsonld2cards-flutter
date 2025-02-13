library;

import 'package:jsonld2cards/cards/models/thing_model.dart';
import 'package:jsonld2cards/util/conversion.dart';
import 'list_item_model.dart';


class ItemList extends Thing {

  /// Array of [ListItem]  or Text (String)  or [Thing]
  List<dynamic>? itemListElement;
  // todo currently ignoring
  // https://schema.org/ItemListOrderType or String
  //  itemListOrder
  num? numberOfItems;


  ItemList({this.itemListElement, this.numberOfItems});

  ItemList.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    var jsonItemListElement = json['itemListElement'];
    if (jsonItemListElement is List<dynamic>) {
      itemListElement = jsonItemListElement
          .map((e) {
            if (e is String) return e;
            if (e is Map<String, dynamic>) {
              var typeOfE = e['@type'];
              if (typeOfE != null) {
                if (typeOfE == 'ListItem'){
                  return ListItem.fromJson(e);
                }
                // todo this is a bit ugly, it casts items of the type listItem, but doesn't
                // parse other Things.
                // return Thing.fromJson(e);
              }
            }
            return e;
      }).toList();

    } else if (jsonItemListElement != null) {
      itemListElement = [jsonItemListElement];
    }
    numberOfItems = tryCastOrParseNum(json['numberOfItems']);

  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['@type'] = 'ItemList';
    final itemListElement = this.itemListElement;
    if (itemListElement != null) {
      data['itemListElement'] = itemListElement.map((e) {
      if (e is Thing) return e.toJson();
    });
    }
    data['numberOfItems'] = numberOfItems;
    return data;
  }
}
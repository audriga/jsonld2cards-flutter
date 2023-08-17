library item_list_model;

import 'package:jsonld2cards/Cards/Models/thing_model.dart';
import 'package:jsonld2cards/Util/conversion.dart';

import 'image_object_model.dart';


class ItemList extends Thing {

  /// [ListItem]  or Text (String)  or [Thing]
  List<dynamic>? itemListElement;
  // todo currently ignoring
  // https://schema.org/ItemListOrderType or String
  //  itemListOrder
  num? numberOfItems;


  ItemList({this.itemListElement, this.numberOfItems});

  ItemList.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    var jsonItemListElement = json['itemListElement'];
    if (jsonItemListElement is List<dynamic>) {
      itemListElement = jsonItemListElement;
    } else if (jsonItemListElement != null) {
      itemListElement = [jsonItemListElement];
    }
    numberOfItems = json['numberOfItems'];

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
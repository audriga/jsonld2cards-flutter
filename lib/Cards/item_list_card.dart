library item_list_card;

import 'package:jsonld2cards/Cards/Models/item_list_model.dart';
import 'package:jsonld2cards/Cards/Models/list_item_model.dart';
import 'package:jsonld2cards/Cards/Models/schema_types.dart';
import 'package:jsonld2cards/Cards/markup_card.dart';
import 'package:jsonld2cards/tabbed_cards.dart';
import 'BuildingBlocks/potential_actions.dart';
import 'package:flutter/widgets.dart';

class ItemListCard extends StatelessWidget implements MarkupCard {
  const ItemListCard({
    super.key,
    required this.markup,
    required this.postFunction,
    this.preview = false,
  });

  final Map<String, dynamic> markup;
  final PostFunction postFunction;
  final bool preview;

  @override
  Widget build(BuildContext context) {
    var itemList = ItemList.fromJson(markup);

    List<Map<String, dynamic>> internalMarkup = [];
    for (var element in itemList.itemListElement!) {
      if (element is ListItem) {
        var item = element.item;
        if (item != null) {
          internalMarkup.add(item.toJson());
        } else if (element.url != null) {

        }
      } else if (element is Map<String, dynamic>) {
        internalMarkup.add(element);
      }
    }

    if (internalMarkup.isEmpty) throw FormatException('Could not get any valid internal cards!', internalMarkup);
    // todo zeit homepage won't work
    return NestedMultiCard(markupList: internalMarkup,
      postFunction: postFunction,
      preview: preview,);
  }

  SchemaType get cardType => SchemaType.itemList;

  @override
  IconData get tabIcon => cardType.icon!;

  @override
  String get tabName => cardType.tabName;
}

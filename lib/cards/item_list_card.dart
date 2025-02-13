library;

import 'package:jsonld2cards/cards/models/item_list_model.dart';
import 'package:jsonld2cards/cards/models/list_item_model.dart';
import 'package:jsonld2cards/cards/models/schema_types.dart';
import 'package:jsonld2cards/cards/markup_card.dart';
import 'package:jsonld2cards/card_data.dart';
import 'package:jsonld2cards/tabbed_cards.dart';
import 'package:flutter/widgets.dart';

class ItemListCard extends StatelessWidget implements MarkupCard {
  const ItemListCard(this.cardData, {super.key});

  final CardData cardData;

  @override
  Widget build(BuildContext context) {
    var itemList = ItemList.fromJson(cardData.markup);

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

    if (internalMarkup.isEmpty) {
      throw FormatException(
        'Could not get any valid internal cards!', internalMarkup);
    }
    // todo zeit homepage won't work
    return NestedMultiCard(
        CardData.fromOther(cardData, markup: internalMarkup)
    );
  }

  SchemaType get cardType => SchemaType.itemList;

  @override
  IconData get tabIcon => cardType.icon!;

  @override
  String get tabName => cardType.tabName;
}

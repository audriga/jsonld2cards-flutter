library card_context;

import 'package:flutter/widgets.dart';

import 'Cards/BuildingBlocks/potential_actions.dart';

class CardData {
  dynamic markup; // List<Map<String,dynamic>> or Map<String, dynamic>
  PostFunction? postFunction;
  bool preview;
  bool topBar;
  List<Widget>? additionalButtons;

  CardData(
    this.markup, {
    this.postFunction,
    this.preview = false,
    this.topBar = false,
    this.additionalButtons,
  });

  bool get markupIsList => (markup is List<dynamic>) || (markup is List<Map<String, dynamic>>);
  List get markupList => markupIsList? markup : [markup];
  List<Map<String,dynamic>> get typeFilteredMarkupList => markupList.whereType<Map<String,dynamic>>().toList();
  bool get markupIsMap => markup is Map<String, dynamic>;

  /// Creates a card data from some other card data, overriding the set properties.
  CardData.fromOther(CardData o, {
    dynamic markup,
    PostFunction? postFunction,
    bool? preview,
    bool? topBar,
    List<Widget>? additionalButtons,
  }) :
    markup = markup ?? o.markup,
    postFunction = postFunction ?? o.postFunction,
    preview = preview ?? o.preview,
    topBar = topBar ?? o.topBar,
    additionalButtons = additionalButtons ?? o.additionalButtons;
}

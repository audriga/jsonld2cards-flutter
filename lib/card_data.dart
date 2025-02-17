library;

import 'package:flutter/widgets.dart';

import 'src/cards/building_blocks/potential_actions.dart';

typedef PostFunction = Function(Uri uriToPost,
    {dynamic dataToPost, String successMessage});

/// Wrapper object around the schema markup, includes additional data about
/// how to render it.
class CardData {
  /// The schema markup to be rendered.
  /// Should be either `List<Map<String,dynamic>>` or `Map<String, dynamic>`
  dynamic markup;

  /// The function which is used to post data on action
  // buttons that post data (f.e. ConfirmAction button). Can be set to a dummy function if not needed.
  PostFunction? postFunction;

  /// Whether the card should be rendered in preview mode. This disables ActionButtons.
  bool preview;

  /// Whether to show a bar on top of the card, indicating the type of the card.
  bool topBar;

  /// Additional buttons that can be rendered after the action buttons.
  /// Not actually used yet.
  List<Widget>? additionalButtons;

  CardData(
    this.markup, {
    this.postFunction,
    this.preview = false,
    this.topBar = false,
    this.additionalButtons,
  });

  bool get markupIsList =>
      (markup is List<dynamic>) || (markup is List<Map<String, dynamic>>);

  List get markupList => markupIsList ? markup : [markup];

  List<Map<String, dynamic>> get typeFilteredMarkupList =>
      markupList.whereType<Map<String, dynamic>>().toList();

  bool get markupIsMap => markup is Map<String, dynamic>;

  /// Creates a card data from some other card data, overriding the set properties.
  CardData.fromOther(
    CardData o, {
    dynamic markup,
    PostFunction? postFunction,
    bool? preview,
    bool? topBar,
    List<Widget>? additionalButtons,
  })  : markup = markup ?? o.markup,
        postFunction = postFunction ?? o.postFunction,
        preview = preview ?? o.preview,
        topBar = topBar ?? o.topBar,
        additionalButtons = additionalButtons ?? o.additionalButtons;
}

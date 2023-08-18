library tabbed_cards;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/Cards/markup_card.dart';
import 'package:jsonld2cards/card_rendering.dart';

import 'Cards/BuildingBlocks/potential_actions.dart';

class TabbedMultiCard extends StatefulWidget implements MarkupCard {
  const TabbedMultiCard({
    super.key,
    required this.markupList,
    required this.postFunction,
    this.preview = false,
    this.topBar = false,
  });

  /// Should either contain List<Map<String,dynamic>> or Map<String,dynamic>
  final List<dynamic> markupList;
  final PostFunction postFunction;
  final bool preview;

  /// Only used in the case where the the list only contains one element
  final bool topBar;

  @override
  State<TabbedMultiCard> createState() => _TabbedMultiCardState();

  @override
  IconData get tabIcon => Icons.list;

  @override
  String get tabName => 'Multi';
}

class _TabbedMultiCardState extends State<TabbedMultiCard> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.markupList.isEmpty) {
      throw FormatException('Cannot render empty list', widget.markupList);
    }
    // if (widget.markupList.length == 1) {
    //   return mustRenderCard(widget.markupList.single,
    //       postFunction: widget.postFunction,
    //       preview: widget.preview,
    //       topBar: widget.topBar);
    // }

    var tabs = <Tab>[];
    var views = <Widget>[];
    for (var markup in widget.markupList) {

      // todo this uses the fact that mustRenderCard will return a [MarkupCard] if topBar is false.
      // However this is quite unclean interface usage. Consider factoring out a method that always returns MarkupCard instead
      MarkupCard card = mustRenderCard(markup, postFunction: widget.postFunction, preview: widget.preview, topBar: false) as MarkupCard;
      if (card is TabbedMultiCard) {
        card = NestedMultiCard(
          markupList: card.markupList.whereType<Map<String,dynamic>>().toList(),
          postFunction: widget.postFunction,
        );
      }
      views.add(card);
      tabs.add(Tab(child: getTabContents(card),));

    }

    var tabbedCard = Card(
      child: DefaultTabController(
        length: widget.markupList.length,
        child: Column(
          children: [
            TabBar.secondary(
              onTap: (index) {
                setState(() {
                  _selectedTab = index;
                });
              },
                tabs: tabs,),
            views[_selectedTab],
            // TabBarView(children: views),
          ],
        ),
      ),
    );
    return tabbedCard;
  }
}


class NestedMultiCard extends StatefulWidget implements MarkupCard  {
  const NestedMultiCard({
    super.key,
    required this.markupList,
    required this.postFunction,
    this.preview = false,
  });

  final List<Map<String,dynamic>> markupList;
  final PostFunction postFunction;
  final bool preview;

  @override
  State<NestedMultiCard> createState() => _NestedMultiCardState();

  @override
  IconData get tabIcon => Icons.list;

  @override
  String get tabName => 'Multi';
}

class _NestedMultiCardState extends State<NestedMultiCard> {
  int _selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var tabs = <TextButton>[];
    var views = <Widget>[];
    for (int i = 0; i < widget.markupList.length; i++) {
      MarkupCard card = mustRenderCard(widget.markupList[i], postFunction: widget.postFunction, preview: widget.preview, topBar: false) as MarkupCard;
      views.add(card);
      tabs.add(TextButton(
        onPressed: (){setState(() {
          _selectedTab = i;
        });},
        style: (_selectedTab == i)?  TextButton.styleFrom(backgroundColor: theme.highlightColor) : null,
        child: Text(card.tabName),
      ));
    }
    return Column(children: [
      views[_selectedTab],
      Row(children: tabs,),
    ],);
  }
}

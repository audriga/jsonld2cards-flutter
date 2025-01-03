library;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/Cards/markup_card.dart';
import 'package:jsonld2cards/card_data.dart';
import 'package:jsonld2cards/card_rendering.dart';

// import 'Cards/BuildingBlocks/potential_actions.dart';

class TabbedMultiCard extends StatefulWidget implements MarkupCard {
  const TabbedMultiCard(
    this.cardData, {
    super.key,
  })
      // : markupList = cardData.markupList,
      //   postFunction = cardData.postFunction,
      //   preview = cardData.preview,
      //   topBar = cardData.topBar
  ;

  final CardData cardData;

  // /// Should either contain List<Map<String,dynamic>> or Map<String,dynamic>
  // final List<dynamic> markupList;
  // final PostFunction postFunction;
  // final bool preview;
  //
  // /// Only used in the case where the the list only contains one element
  // final bool topBar;

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
    if (widget.cardData.markupList.isEmpty) {
      throw FormatException('Cannot render empty list', widget.cardData.markupList);
    }
    // if (widget.markupList.length == 1) {
    //   return mustRenderCard(widget.markupList.single,
    //       postFunction: widget.postFunction,
    //       preview: widget.preview,
    //       topBar: widget.topBar);
    // }

    var tabs = <Tab>[];
    var smallTabs = <Tab>[];
    var views = <Widget>[];
    for (var markup in widget.cardData.markupList) {
      // todo this uses the fact that mustRenderCard will return a [MarkupCard] if topBar is false.
      // However this is quite unclean interface usage. Consider factoring out a method that always returns MarkupCard instead
      // Or better yet, make it so that the top bar is part of the card.
      MarkupCard card = mustRenderCardFromCardData(CardData.fromOther(
        widget.cardData,
        markup: markup,
        topBar: false,
      )) as MarkupCard;
      if (card is TabbedMultiCard) {
        card = NestedMultiCard(CardData.fromOther(card.cardData,
          markup: card.cardData.typeFilteredMarkupList,
          postFunction: widget.cardData.postFunction, //todo I think this constructor call can be replaced with just card.cardData
        ));
      }
      views.add(card);
      tabs.add(Tab(
        child: getTabContents(card),
      ));
      smallTabs.add(Tab(
        icon: Icon(card.tabIcon),
      ));
    }

    var tabbedCard = Card(
      child: DefaultTabController(
        length: widget.cardData.markupList.length,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LayoutBuilder(builder: (context, constraints) {
              int maxSizePerTab = 150;
              bool useSmall = constraints.maxWidth / widget.cardData.markupList.length <
                  maxSizePerTab;
              return TabBar.secondary(
                onTap: (index) {
                  setState(() {
                    _selectedTab = index;
                  });
                },
                tabs: useSmall ? smallTabs : tabs,
              );
            }),
            views[_selectedTab],
            // TabBarView(children: views),
          ],
        ),
      ),
    );
    return tabbedCard;
  }
}

class NestedMultiCard extends StatefulWidget implements MarkupCard {
  const NestedMultiCard(this.cardData, {
    super.key,
    // required this.markupList,
    // required this.postFunction,
    // this.preview = false,
  });

  final CardData cardData;
  // final List<Map<String, dynamic>> markupList;
  // final PostFunction postFunction;
  // final bool preview;

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
    for (int i = 0; i < widget.cardData.markupList.length; i++) {
      MarkupCard card = mustRenderCardFromCardData(CardData.fromOther(widget.cardData,
          markup: widget.cardData.markupList[i],
          topBar: false,)) as MarkupCard;
      views.add(card);
      tabs.add(TextButton(
        onPressed: () {
          setState(() {
            _selectedTab = i;
          });
        },
        style: (_selectedTab == i)
            ? TextButton.styleFrom(backgroundColor: theme.highlightColor)
            : null,
        child: Text(card.tabName),
      ));
    }
    return Column(
      children: [
        views[_selectedTab],
        Row(
          children: tabs,
        ),
      ],
    );
  }
}

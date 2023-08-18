library tabbed_cards;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/card_rendering.dart';

import 'Cards/BuildingBlocks/potential_actions.dart';

class TabbedMultiCard extends StatefulWidget {
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
}

class _TabbedMultiCardState extends State<TabbedMultiCard> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.markupList.isEmpty) {
      throw FormatException('Cannot render empty list', widget.markupList);
    }
    if (widget.markupList.length == 1) {
      return mustRenderCard(widget.markupList.single,
          postFunction: widget.postFunction,
          preview: widget.preview,
          topBar: widget.topBar);
    }

    var tabs = <Tab>[];
    var views = <Widget>[];
    for (var markup in widget.markupList) {
      views.add(mustRenderCard(markup, postFunction: widget.postFunction, preview: widget.preview, topBar: false));
      if (markup is Map<String, dynamic>) {
        String typeName = markup['@type'];
        var type = getCardType(typeName);
        var iconToUse = type?.icon ?? Icons.mail;
        var nameToUse = type?.tabName ?? 'Default';
        tabs.add(Tab(icon: Icon(iconToUse), text:  nameToUse,));
      } else {
        tabs.add(const Tab(icon: Icon(Icons.list), text: 'Multi',));
      }
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

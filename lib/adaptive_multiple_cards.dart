library adaptive_multiple_cards;

import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/potential_actions.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/uri_image.dart';
import 'package:jsonld2cards/Cards/Models/item_list_model.dart';
import 'package:jsonld2cards/Cards/Models/list_item_model.dart';
import 'package:jsonld2cards/Cards/Models/organization_model.dart';
import 'package:jsonld2cards/Cards/Models/thing_model.dart';
import 'package:jsonld2cards/card_rendering.dart';
import 'package:jsonld2cards/Util/modify_markup.dart';

class AdaptiveMultipleCards extends StatelessWidget {
  final String? title;
  final List<dynamic> markups;
  final PostFunction postFunction;

  const AdaptiveMultipleCards({
    super.key,
    this.title,
    required this.markups,
    required this.postFunction,
  });


  @override
  Widget build(BuildContext context) {
    var types = markups.whereType<Map<String,dynamic>>().map((e) => e['@type']);
    Organization? organization;
    Uri? orgLogo;
    Widget? orgLogoWidget;
    if (types.contains('Organization')) {
      organization = Organization.fromJson(markups.firstWhere((element) => element['@type'] == 'Organization'));
      orgLogo = organization.logo;
      // markups.removeWhere((element) => element['@type'] == 'Organization');
    } else if (types.contains('NewsMediaOrganization')) {
      organization = Organization.fromJson(markups.firstWhere((element) => element['@type'] == 'NewsMediaOrganization'));
      orgLogo = organization.logo;
    }
    if (orgLogo != null) {
      orgLogoWidget = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: UriImage(
          content: orgLogo,
          fit: BoxFit.scaleDown,
        ),
      );
    }

    List<Widget>? breadCrumbButtons;
    if (types.contains('BreadcrumbList')) {
      var breadCrumbList = ItemList.fromJson(markups.firstWhere((element) => element['@type'] == 'BreadcrumbList'));
      // markups.removeWhere((element) => element['@type'] == 'BreadcrumbList');
      var breadCrumbListElement = breadCrumbList.itemListElement;

      if (breadCrumbListElement != null && breadCrumbListElement.isNotEmpty) {
        breadCrumbButtons = List<Widget>.generate(breadCrumbListElement.length * 2 - 1,  (int index) {
          if (index.isOdd) return const Text('/');
          final actualIndex = index ~/ 2;
          var crumb = breadCrumbListElement[actualIndex];
          String buttonText;
          /// Maybe not necessary to be so diligent with the cases as a BreadcrumbList should only
          /// contain [ListItem]s containing schema.org/WebPage
          if (crumb is ListItem) {
            var crumbItem = crumb.item;
            if (crumbItem != null) {
              buttonText = crumbItem.name ?? crumbItem.id?.pathSegments.last ?? '';
            } else {
              buttonText = crumb.name ?? crumb.position?.toString() ?? '';

            }
          } else if (crumb is Thing) {
            buttonText = crumb.name ?? crumb.id?.pathSegments.last ?? '';
          } else if (crumb is String) {
            buttonText = crumb;
          } else {
            buttonText = '';
          }
          return TextButton(
              onPressed: (){},
              child: Text(buttonText, maxLines: 2, overflow: TextOverflow.ellipsis,),
          );
        });
      }
    }

    AppBar? appBar;
    if (breadCrumbButtons != null) {
      appBar = AppBar(leading: orgLogoWidget, title: Row(mainAxisSize: MainAxisSize.min, children: breadCrumbButtons),);
    } else if (title != null) {
      appBar = AppBar(leading: orgLogoWidget, title: Text(title!),);
    }


    final List<Widget> children;

    if (types.contains('ItemList')) {
      var itemList = ItemList.fromJson(markups.firstWhere((element) => element['@type'] == 'ItemList'));
      var itemListElement  = itemList.itemListElement;
      if (itemListElement != null) {
        children = List<Widget>.generate(itemListElement.length, (int index) {
          return renderCard(itemListElement[index], postFunction: postFunction) ?? const Text('Could not load card');
        });
      } else {
        // what if there is an item list and remaining array elements?
        children = List<Widget>.generate(markups.length, (int index) {
          return renderCard(markups[index], postFunction: postFunction) ?? const Text('Could not load card');
        });
      }
    } else {
      var filteredMarkups = removeMarkupClutter(markups);
      children = List<Widget>.generate(filteredMarkups.length, (int index) {
        return renderCard(filteredMarkups[index], postFunction: postFunction) ?? const Text('Could not load card');
      });
    }



    return Scaffold(
        appBar: appBar,
        body: AdaptiveLayout(
          // Body switches between a ListView and a GridView from small to medium
          // breakpoints and onwards.
          body: SlotLayout(
            config: <Breakpoint, SlotLayoutConfig>{
              Breakpoints.small: SlotLayout.from(
                key: const Key('Body Small'),
                builder: (_) => ListView.builder(
                  itemCount: children.length,
                  itemBuilder: (BuildContext context, int index) =>
                  children[index],
                ),
              ),
              Breakpoints.mediumAndUp: SlotLayout.from(
                key: const Key('Body Medium'),
                builder: (_) =>
                    LayoutBuilder(
                        builder: (context, constraints) {
                          return GridView.count(crossAxisCount: 2,childAspectRatio: constraints.maxWidth / constraints.maxHeight, children: children);
                      }
                    ),
              )
            },
          ),
        ));
  }
}
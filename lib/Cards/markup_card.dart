library;

import 'package:flutter/widgets.dart';

abstract class MarkupCard extends Widget{
  const MarkupCard({super.key});

  IconData get tabIcon;
  String get tabName;
}

Widget getTabContents(MarkupCard card) {
  return Row(children:
  [
    Padding(
      padding: const EdgeInsets.symmetric(horizontal:  4.0),
      child: Icon(card.tabIcon),),
    Text(card.tabName),
  ]);
}


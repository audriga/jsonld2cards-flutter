library;

import 'package:flutter/widgets.dart';

/// The main content of a card with a three column Layout.
class ThreeColumnCardContent extends StatelessWidget {
  const ThreeColumnCardContent({
    super.key,
    required this.leftColumn,
    required this.middleColumn,
    required this.rightColumn,
  });

  final Column leftColumn, middleColumn, rightColumn;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: leftColumn,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: middleColumn,
        ),
        Expanded(
          child: rightColumn,
        ),
      ],
    );
  }
}

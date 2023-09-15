import 'package:jsonld2cards/Cards/BuildingBlocks/potential_actions.dart';
import 'package:flutter/material.dart';
import 'package:jsonld2cards/card_rendering.dart';

import 'package:jsonld2cards/card_viewer.dart';

class SingleCardDisplay extends StatelessWidget {
  const SingleCardDisplay({
    super.key,
    required this.decodedMarkup,
    this.maxWidth = 480,
    required this.postFunction,
  });

  final dynamic decodedMarkup;
  final double maxWidth;
  final PostFunction postFunction;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return constraints.maxWidth > maxWidth
            ? Center(
                child: ClipRect(
                  child: SizedBox(
                      width: maxWidth,
                      child: renderCard(decodedMarkup,
                              postFunction: postFunction) ??
                          displayErrorMessage('Could not load card')),
                ),
              )
            : renderCard(decodedMarkup, postFunction: postFunction) ??
                displayErrorMessage('Could not load card');
      },
    );
  }
}

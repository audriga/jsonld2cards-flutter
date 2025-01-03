library;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/Cards/Models/schema_types.dart';
import 'package:jsonld2cards/Cards/markup_card.dart';
import 'package:jsonld2cards/card_data.dart';
import 'BuildingBlocks/card_with_actions.dart';

// import 'BuildingBlocks/uri_image.dart';
import 'Models/simple_poll_model.dart';

class SimplePollCard extends StatelessWidget implements MarkupCard {
  const SimplePollCard(this.cardData, {super.key});

  final CardData cardData;

  @override
  Widget build(BuildContext context) {
    var simplePoll = SimplePoll.fromJson(cardData.markup);

    // Widget? leadingImage;

    // Setting title and subtitle, depending on available information
    var titleTextBuffer = StringBuffer('');
    var titleTextSpans = <TextSpan>[];
    String pollName = 'Poll';
    if (simplePoll.name != null) {
      pollName = '${simplePoll.name}';
    }
    titleTextBuffer.write(pollName);
    titleTextSpans.add(TextSpan(
        text: pollName, style: const TextStyle(fontWeight: FontWeight.bold)));

    var potentialAction = simplePoll.potentialAction;

    List<Widget> pollOptions = List<Widget>.generate(
      simplePoll.options?.length ?? 0,
      (index) {
        var optionName = simplePoll.options![index].name ?? 'Option $index';
        bool hasVotes = simplePoll.choices?.isNotEmpty ?? false;
        int totalVotes = -1;
        Iterable<ChooseAction>? votesForThis;
        Widget? percentIndicator;
        Widget? voterIndicator;
        if (hasVotes) {
          totalVotes = simplePoll.choices!.length;
          votesForThis = simplePoll.choices!.where((element) => element.actionOption == optionName,);
          percentIndicator = LinearProgressIndicator(value: votesForThis.length / totalVotes,);
          voterIndicator = Text('${votesForThis.length}');
        }
        var pollTile =  (simplePoll.selectMultiple ?? false)
            ? CheckboxListTile(controlAffinity: ListTileControlAffinity.leading,
                title: Text(optionName),
                subtitle: percentIndicator,
                secondary: voterIndicator,
                value: false,
                onChanged: (value) {},
              )
            : RadioListTile(
                title: Text(optionName),
                subtitle: percentIndicator,
                secondary: voterIndicator,
                value: false,
                groupValue: false,
                onChanged: (value) {},
              );
        return pollTile;
      },
    );

    // titleText = titleTextBuffer.toString();
    // subtitleText = subTitleTextBuffer.toString().trim();
    // subTitleTextSpans.first.text?.trimLeft();
    // subTitleTextSpans.last.text?.trimRight();

    var cardContent = Column(
      // leading: leadingImage, // no image for poll(?)
      children: [
        Text.rich(
          TextSpan(children: titleTextSpans),
          style: const TextStyle(fontSize: 18),
        ),
        ...pollOptions,
      ],
    );
    return CardWithActions(
      cardContents: [cardContent],
      potentialAction: potentialAction,
      cardData: cardData,
    );
  }

  SchemaType get cardType => SchemaType.simplePoll;

  @override
  IconData get tabIcon => cardType.icon!;

  @override
  String get tabName => cardType.tabName;
}

library order_card;

import 'package:jsonld2cards/Cards/BuildingBlocks/simple_card.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/uri_image.dart';
import 'package:jsonld2cards/Cards/Models/schema_types.dart';
import 'package:jsonld2cards/Cards/markup_card.dart';
import 'package:jsonld2cards/card_data.dart';
import 'package:flutter/widgets.dart';

import 'Models/order_model.dart';

class OrderCard extends StatelessWidget implements MarkupCard {
  const OrderCard(this.cardData, {super.key});

  final CardData cardData;


  @override
  Widget build(BuildContext context) {
    var order = Order.fromJson(cardData.markup);

    // Setting title and subtitle, depending on available information
    String? titleText;
    String? subtitleText;
    Widget? leadingImage;
    var titleTextBuffer = StringBuffer('Order');
    if (order.merchant?.name != null) {
      titleTextBuffer.write(' from ${order.merchant?.name}');
    }
    if (order.orderStatus != null) {
      titleTextBuffer.write(' ${orderStatusToVerbString(order.orderStatus!)}.');
    }

    var subTitleTextBuffer = StringBuffer();
    if (order.acceptedOffer != null) {
      var itemOffered = order.acceptedOffer!.itemOffered;
      if (itemOffered != null) {
        if (itemOffered.name != null){
          subTitleTextBuffer.writeln(itemOffered.name);
        }
        if (itemOffered.image != null) {
          leadingImage = UriImage(
            content: itemOffered.image,
            height: 32.0,
            width:  32.0,
            fit: BoxFit.scaleDown,
          );
        }
      }
      if (order.acceptedOffer!.price != null) {
        subTitleTextBuffer.write(order.acceptedOffer!.price);
      }
      if (order.acceptedOffer!.priceCurrency != null) {
        subTitleTextBuffer.write(' ${order.acceptedOffer!.priceCurrency}');
      }
    }

    titleText = titleTextBuffer.toString();
    subtitleText = subTitleTextBuffer.toString();


    return SimpleCard(
      leadingImage: leadingImage,
      titleText: titleText,
      subtitleText: subtitleText,
      potentialAction: order.potentialAction,
      cardData: cardData,
    );
  }

  SchemaType get cardType => SchemaType.order;

  @override
  IconData get tabIcon => cardType.icon!;

  @override
  String get tabName => cardType.tabName;
}

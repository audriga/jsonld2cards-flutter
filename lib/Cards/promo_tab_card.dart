library promo_tab_card;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/Cards/uri_image.dart';


class PromoTabData {
  Organization organization;
  EmailMessageData emailMessage;
  DiscountOffer discountOffer;
  List<PromotionCardData> promotionCards;

  PromoTabData.fromJsonList(List<Map<String, dynamic>> markupList)
      : organization = Organization.fromJson(
      markupList.firstWhere((element) => element['@type'] == 'Organization')),
        emailMessage = EmailMessageData.fromJson(
            markupList.firstWhere((element) =>
            element['@type'] ==
                'EmailMessage')),
        discountOffer = DiscountOffer.fromJson(
            markupList.firstWhere((element) =>
            element['@type'] ==
                'DiscountOffer')),
        promotionCards = [] {
    var promoMarkupList = markupList.where((element) =>
    element['@type'] == 'PromotionCard').toList()
      ..sort((a, b) => (a['position'] as int).compareTo(b['position'] as int),);
    promotionCards.addAll(promoMarkupList.map(PromotionCardData.fromJson));
  }
}

class Organization {
  Uri logo;

  Organization.fromJson(Map<String, dynamic> json)
      : logo = (json['logo'] is Uri) ? json['logo'] : Uri.parse(json['logo']);
}

class EmailMessageData {
  String subjectLine;

  EmailMessageData.fromJson(Map<String, dynamic> json)
      : subjectLine = json['subjectLine'];
}

class DiscountOffer {
  String description;
  String discountCode;
  DateTime availabilityStarts;
  DateTime availabilityEnds;

  // DateTimeRange get availabilityRange =>
  //     DateTimeRange(start: availabilityStarts, end: availabilityEnds);

  DiscountOffer.fromJson(Map<String, dynamic> json)
      : description = json['description'],
        discountCode = json['discountCode'],
        availabilityStarts = DateTime.parse(json['availabilityStarts']),
        availabilityEnds = DateTime.parse(json['availabilityEnds']);
}

class PromotionCardData {
  Uri image;
  Uri url;
  String headline;
  num price;
  String priceCurrency;
  num discountValue;
  
  String get priceInCurrency {
    return formatCurrency(price, priceCurrency);
  }

  String get discountedPriceInCurrency {
    var discountedPrice = price - discountValue;
    // var discountedPrice = price * (100 - discountValue) / 100.0;
    return formatCurrency(discountedPrice, priceCurrency);
  }

  static String formatCurrency(num price, String priceCurrency) {
    switch (priceCurrency) {
      case 'USD': return '\$$price';
      case 'EUR': return '$price€';
      default: return '$price $priceCurrency';
    }
  }

  PromotionCardData.fromJson(Map<String, dynamic> json)
      : image = (json['image'] is Uri) ? json['image'] : Uri.parse(
      json['image']),
        url = (json['url'] is Uri) ? json['url'] : Uri.parse(json['url']),
        headline = json['headline'],
        price = json['price'],
        priceCurrency = json['priceCurrency'],
        discountValue = json['discountValue'];
}

/// if height is not set, the card will be rendered in a 3:4 aspect ratio
class PromoTabCard extends StatelessWidget {
  const PromoTabCard({
    super.key,
    required this.markupList,
    this.height
  });
  // todo Ideally height should be determined by contents but that is tricky with
  //  horizontally scrolling content. See also https://stackoverflow.com/questions/49307677/how-can-i-get-the-height-of-a-widget/60868972#60868972 and
  //  https://stackoverflow.com/questions/54512171/horizontal-listview-inside-a-vertical-scrollview-in-flutter/67556125#67556125

  // todo check if web scrolling is problematic like described here https://stackoverflow.com/questions/69154468/horizontal-listview-not-scrolling-on-web-but-scrolling-on-mobile

  final List<Map<String, dynamic>> markupList;
  final double? height;

  // todo
  // Minor niceties
  //  [] get format of text just right
  //  [] Three letter currency to symbol, and treat according to standard, e.g. $15 vs 15€
  //  [x] Apply discount value to price
  //  [] Make entire card clickable
  // Better error handling
  //  [] Error handling for image
  //  [] handle expected attributes not being present
  //  [x] make its own widget or function

  // var promoMarkupList = markupList.where((element) => element['@type'] == 'PromotionCard').toList();
  // var organization = markupList.firstWhere((element) => element['@type'] == 'Organization');
  // var emailMessage = markupList.firstWhere((element) => element['@type'] == 'EmailMessage');
  // var discountOffer = markupList.firstWhere((element) => element['@type'] == 'DiscountOffer');

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var promoTabData = PromoTabData.fromJsonList(markupList);
    String expiryString = 'Expired';
    var now = DateTime.now();
    if (promoTabData.discountOffer.availabilityStarts.isAfter(now)) {
      var difference = promoTabData.discountOffer.availabilityStarts.difference(now);
      expiryString = 'Starts in ${difference.inHours} hours';
    } else if (promoTabData.discountOffer.availabilityEnds.isAfter(now)) {
      var difference = promoTabData.discountOffer.availabilityEnds.difference(now);
      expiryString = 'Expires in ${difference.inHours} hours';
    }

    const promoCardPerScreen = 3;
    const viewportFractionPerItem = 1.0 / promoCardPerScreen;

    return LayoutBuilder(
        builder: (context, constraints) {
          final itemSize = constraints.maxWidth * viewportFractionPerItem;
          // Alternatively Specify Aspect Ratio? But in the nested listview, neither height nor width are restricted.

          double heightResult;
          if (constraints.maxHeight != double.infinity) {
            heightResult = height ?? constraints.maxHeight - 100; // todo find a better way to do this
          } else {
            heightResult = height ?? 3.0 * constraints.maxWidth / 4.0;
          }
          return Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      UriImage(
                          content: promoTabData.organization.logo,
                          height: 32.0,
                          width:  32.0,
                          fit: BoxFit.scaleDown
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            expiryString,
                            style: theme.textTheme.labelLarge,
                          ),
                          Text(
                            promoTabData.emailMessage.subjectLine,
                            style: theme.textTheme.titleMedium,
                            softWrap: true,
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.lightGreen,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 2),
                                  child: Text(
                                    promoTabData.discountOffer.description,
                                  ),
                                ),
                              ),
                              const Text(' Code '),
                              Container(
                                decoration: BoxDecoration(
                                  color: theme.highlightColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 2),
                                  child: Text(promoTabData.discountOffer.discountCode),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  ConstrainedBox(
                    // width: itemSize,
                    constraints: BoxConstraints(maxHeight: heightResult),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      //shrinkWrap: true,
                      itemCount: promoTabData.promotionCards.length * 2,
                      padding: const EdgeInsets.all(16.0), // Do i need padding AND divider?
                      itemBuilder: (context, i) {
                        if (i.isOdd) return const Divider();
                        final index = i ~/ 2;
                        var currentPromo = promoTabData.promotionCards[index];
                        return PromoItem(width: itemSize, promoCardData: currentPromo);
                        // return renderCard(markupList[index], postFunction: postFunction);
                      },
                    ),
                  ),
                ],
              )
          );
        }
    );
  }
}

class PromoItem extends StatelessWidget {
  const PromoItem({
    super.key,
    required this.width,
    required this.promoCardData,
  });

  final double width;
  final PromotionCardData promoCardData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      // height: itemSize,
      child: Card(
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            UriImage(
                content: promoCardData.image,
                placeholder: (context, url) => const CircularProgressIndicator(),
                fit: BoxFit.scaleDown
            ),
            ListTile(
              title: Text(promoCardData.headline, softWrap: true),
              subtitle: Text.rich(TextSpan(
                children: [
                  TextSpan(
                    text: promoCardData.priceInCurrency,
                    style: const TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  TextSpan(
                    text: ' ${promoCardData.discountedPriceInCurrency}',
                  ),
                ],
              )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
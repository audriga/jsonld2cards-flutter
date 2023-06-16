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

class PromoTabCard extends StatelessWidget {
  const PromoTabCard({
    super.key,
    required this.markupList,
  });

  final List<Map<String, dynamic>> markupList;

  // todo
  //  [] get format of text just right
  //  [] Three letter currency to symbol, and treat according to standard, e.g. $15 vs 15€
  //  [] Apply discount value to price
  //  [] Make entire card clickable
  //  [] Error handling for image
  //  [] handle expected attributes not being present
  //  [] make its own widget or function

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
          return Card(
              child: Column(
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
                  SizedBox(
                    // width: itemSize,
                    height: constraints.maxWidth * 2.0 / 3.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      //shrinkWrap: true,
                      itemCount: promoTabData.promotionCards.length * 2,
                      padding: const EdgeInsets.all(16.0), // Do i need padding AND divider?
                      itemBuilder: (context, i) {
                        if (i.isOdd) return const Divider();
                        final index = i ~/ 2;
                        var currentPromo = promoTabData.promotionCards[index];
                        return SizedBox(
                          width: itemSize,
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
                                    content: currentPromo.image,
                                    fit: BoxFit.scaleDown
                                ),
                                ListTile(
                                  title: Text(currentPromo.headline),
                                  subtitle: Text.rich(TextSpan(
                                    children: [
                                      TextSpan(
                                        text: currentPromo.priceInCurrency,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' ${currentPromo.discountedPriceInCurrency}',
                                      ),
                                    ],
                                  )
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
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
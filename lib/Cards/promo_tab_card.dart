library promo_tab_card;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/uri_image.dart';
import 'package:jsonld2cards/Cards/markup_card.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Models/organization_model.dart';


class PromoTabData {
  Organization? organization;
  EmailMessageData? emailMessage;
  DiscountOffer? discountOffer;
  List<PromotionCardData> promotionCards;

  PromoTabData.fromJsonList(List<Map<String, dynamic>> markupList)
      : organization = tryOrganization(markupList),
        emailMessage = tryEmailMessageData(markupList),
        discountOffer = tryDiscountOffer(markupList),
        promotionCards = tryPromotionCards(markupList);

  static Organization? tryOrganization(List<Map<String, dynamic>> markupList) {
    var organizationMarkup = markupList.firstWhere((element) => element['@type'] == 'Organization', orElse: () => {});
    if (organizationMarkup.isEmpty) return null;
    return Organization.fromJson(organizationMarkup);
  }

  static EmailMessageData? tryEmailMessageData(List<Map<String, dynamic>> markupList) {
    var emailMessageMarkup = markupList.firstWhere(
        (element) => element['@type'] == 'EmailMessage',
        orElse: () => {});
    if (emailMessageMarkup.isEmpty) return null;
    return EmailMessageData.fromJson(emailMessageMarkup);
  }

  static DiscountOffer? tryDiscountOffer(List<Map<String, dynamic>> markupList) {
    var discountOfferMarkup = markupList.firstWhere(
        (element) => element['@type'] == 'DiscountOffer',
        orElse: () => {});
    if (discountOfferMarkup.isEmpty) return null;
    return DiscountOffer.fromJson(
        discountOfferMarkup);
  }

  static List<PromotionCardData> tryPromotionCards(List<Map<String, dynamic>> markupList) {
    var promoMarkupList = markupList.where((element) =>
    element['@type'] == 'PromotionCard').toList()
      ..sort((a, b) => (a['position'] as int).compareTo(b['position'] as int),);
    return promoMarkupList.map(PromotionCardData.fromJson).toList();
  }
  
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


class PromoTabCard extends StatelessWidget implements MarkupCard {
  PromoTabCard({
    super.key,
    required this.markupList,
    this.preview = false,
  });

  final List<Map<String, dynamic>> markupList;
  final bool preview;
  final ScrollController _vertical = ScrollController();

  // todo
  // Minor niceties
  //  [] get format of text just right
  //  [] Three letter currency to symbol, and treat according to standard, e.g. $15 vs 15€
  //  [x] Apply discount value to price
  //  [x] Make entire card clickable
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
    var discountOffer = promoTabData.discountOffer;


    const promoCardPerScreen = 3;
    const viewportFractionPerItem = 1.0 / promoCardPerScreen;

    return LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth * viewportFractionPerItem;
          final itemImageHeight = constraints.maxHeight != double.infinity ? constraints.maxHeight -200 : null;
          var emailMessage = promoTabData.emailMessage;
          var organization = promoTabData.organization;
          var promotionCards = promoTabData.promotionCards;
          return Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      if (organization != null) UriImage(
                          content: organization.logo,
                          height: 32.0,
                          width:  32.0,
                          fit: BoxFit.scaleDown
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (emailMessage != null) Text(
                            emailMessage.subjectLine,
                            style: theme.textTheme.titleMedium,
                            softWrap: true,
                          ),
                          if (discountOffer != null) Row(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.lightGreen,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 2),
                                  child: Text(
                                    discountOffer.description,
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
                                  child: Text(discountOffer.discountCode),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  getExpiryText(discountOffer),
                                  style: theme.textTheme.labelLarge,
                                ),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  if (promotionCards.isNotEmpty) Scrollbar(
                    controller: _vertical,
                    child: SingleChildScrollView(
                      controller: _vertical,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (int i = 0; i < promotionCards.length * 2; ++i)
                            (i.isOdd) ? const Divider() : PromoItem(
                              width: itemWidth,
                              imageHeight: itemImageHeight,
                              promoCardData: promotionCards[i ~/ 2],
                              preview: preview,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
          );
        }
    );
  }

  String getExpiryText(DiscountOffer discountOffer) {
    String expiryString = 'Expired';
    var now = DateTime.now();
    if (discountOffer.availabilityStarts.isAfter(now)) {
      var difference = discountOffer.availabilityStarts.difference(now);
      expiryString = 'Starts in ${difference.inHours} hours';
    } else if (discountOffer.availabilityEnds.isAfter(now)) {
      var difference = discountOffer.availabilityEnds.difference(now);
      expiryString = 'Expires in ${difference.inHours} hours';
    }
    return expiryString;
  }

  @override
  IconData get tabIcon => Icons.local_offer;

  @override
  String get tabName => 'Promotion';
}

class PromoItem extends StatelessWidget {
  const PromoItem({
    super.key,
    required this.width,
    required this.imageHeight,
    required this.promoCardData,
    this.preview = false,
  });

  final double width;
  final double? imageHeight;
  final PromotionCardData promoCardData;
  final bool preview;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: preview ? () {} : () => launchUrl(promoCardData.url),
      child: SizedBox(
        width: width,
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
              imageHeight != null ?
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: imageHeight!),
                child: UriImage(
                    content: promoCardData.image,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    fit: BoxFit.scaleDown,
                ),
              ) : UriImage(
                content: promoCardData.image,
                placeholder: (context, url) => const CircularProgressIndicator(),
                fit: BoxFit.scaleDown,
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
      ),
    );
  }
}
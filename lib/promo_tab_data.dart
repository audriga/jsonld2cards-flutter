library promo_tab_data;


class PromoTabData {
  Organization organization;
  EmailMessage emailMessage;
  DiscountOffer discountOffer;
  List<PromotionCardData> promotionCards;

  PromoTabData.fromJsonList(List<Map<String, dynamic>> markupList)
      : organization = Organization.fromJson(
      markupList.firstWhere((element) => element['@type'] == 'Organization')),
        emailMessage = EmailMessage.fromJson(
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

class EmailMessage {
  String subjectLine;

  EmailMessage.fromJson(Map<String, dynamic> json)
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
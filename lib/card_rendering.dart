library card_rendering;


import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'Cards/BuildingBlocks/potential_actions.dart';
import 'Cards/BuildingBlocks/uri_image.dart';
import 'Cards/action_card.dart';
import 'Cards/item_list_card.dart';
import 'Cards/markup_card.dart';
import 'tabbed_cards.dart';
import 'Cards/Models/schema_types.dart';
import 'Cards/invoice_card.dart';
import 'Cards/order_card.dart';
import 'Cards/promo_tab_card.dart';
import 'Cards/default_markup_card.dart';
import 'Cards/email_message_card.dart';
import 'Cards/flight_reservation_card.dart';
import 'Cards/music_card.dart';
import 'Cards/parcel_delivery_card.dart';
import 'Cards/blog_posting_card.dart';
import 'Cards/place_card.dart';
import 'Cards/Models/organization_model.dart' as org_model;
import 'Util/modify_markup.dart';
// Need material instead of widgets, to get Icons.
// import 'package:flutter/widgets.dart';

/// Renders a card, based on the given markup.
///
/// Assumes [markup] is either a single Map<String, dynamic>, or a List<Map<String, dynamic>>
///
/// [postFunction] is the function which is used to post data on action
///  buttons that post data (f.e. ConfirmAction button). Can be set to a dummy function if not needed.
///
/// If [preview] is set to true, the card will be rendered in preview mode. So any buttons will be disabled.
///
/// Returns the card if it was successfully created and null if the card could not
///  be rendered.
/// This is to enable the caller to do quickly provide an alternative widget to display
/// for example like so: widget = renderCard(...) ?? alternativeWidget
///
/// See [mustRenderCard] for a function that behaves like this, but always returns a widget.
Widget? renderCard(
  dynamic markup, {
  required PostFunction postFunction,
  bool preview = false,
  bool topBar = false,
}) {
  try {
    return mustRenderCard(
      markup,
      postFunction: postFunction,
      preview: preview,
      topBar: topBar,
    );
  } catch (e) {
    return null;
  }
}

/// Same as [renderCard], but always returns a card, or throws an exception on error.
Widget mustRenderCard(
    dynamic markup,
    {
      required PostFunction postFunction,
      bool preview = false,
      bool topBar = false,
    }
    ) {
  if ((markup is List<dynamic>) || (markup is List<Map<String, dynamic>>)) {
    return renderCardMulti(
      markup,
      postFunction: postFunction, preview: preview,
      topBar: topBar,
    );
  }  else if (markup is Map<String, dynamic>) {
    return renderCardSingle(
      markup,
      postFunction: postFunction,
      preview: preview,
      topBar: topBar,
    );
  }
  throw FormatException(
    'markup should either be Map<String, dynamic> or a list of those',
    markup,
  );
}

/// Renders a Card consisting of multiple elements
/// Can always be expected to return a single card or null.
/// Will *not* return a ListView of multiple cards.
///
/// Note: Cards are often Displayed within ListViews.
/// This means there will likely be infinite space in the vertical direction
/// So returning another Widget that is Scrollable in the same direction
/// here is probably not a great idea.
Widget renderCardMulti(
    List<dynamic> markupList,
    {
      required PostFunction postFunction,
      bool preview = false,
      bool topBar = false,
    }
    ) {
  List<Map<String, dynamic>> typeFilteredMarkupList = markupList.whereType<Map<String,dynamic>>().toList();
  var types = typeFilteredMarkupList.map((e) => e['@type']);
  if (types.contains('Organization')
      && types.contains('EmailMessage')
      && types.contains('DiscountOffer')
      && types.contains('PromotionCard')
  ) {
    var card = PromoTabCard(markupList: typeFilteredMarkupList, preview: preview);
    if (topBar) {
      return surroundWithTopBar(card);
    } else {
      return card;
    }
  }

  org_model.Organization? organization;
  Uri? orgLogo;
  if (types.contains('Organization')) {
    organization = org_model.Organization.fromJson(
        markupList.firstWhere((element) => element is Map<String,dynamic> && element['@type'] == 'Organization')
    );
    orgLogo = organization.logo;
  } else if (types.contains('NewsMediaOrganization')) {
    organization = org_model.Organization.fromJson(
        markupList.firstWhere((element) => element is Map<String,dynamic> && element['@type'] == 'NewsMediaOrganization')
    );
  }

  // Removing things we don't want to render in the card
  markupList = removeMarkupClutter(markupList);

  // Now markupList should contain
  // Any single item (MusicAlbum, NewsArticle, etc.)
  // A list of items (multi-content case; email only)
  // Any itemList (0006422)


  switch (markupList.length) {
    case 0: {
      throw FormatException(
        'markup does not contain any valid cards',
        markupList,
      );
    }
    case 1 :
      var subCard = renderCardSingle(
        markupList.first,
        postFunction: postFunction,
        preview: preview,
        topBar: topBar && orgLogo == null, // only show one top bar, org logo takes priority
      );
      if (topBar && orgLogo != null) {
        return surroundWithLogoTopBar(UriImage(content: orgLogo, height: 16), organization?.name, subCard);
      } else {
        return subCard;
      }
    default: {
      return TabbedMultiCard(
        markupList: markupList,
        preview: preview,
        postFunction: postFunction,
      );
    }
  }
}

Widget? tryRenderCardSingle(
    Map<String, dynamic> markup,
    {
      required PostFunction postFunction,
      bool preview = false,
      bool topBar = false,
    }
    )  {
  try {
    return renderCardSingle(
      markup,
      postFunction: postFunction,
      preview: preview,
      topBar: topBar,
    );
  } catch (e) {
    return null;
  }
}

Widget renderCardSingle(
    Map<String, dynamic> markup,
    {
      required PostFunction postFunction,
      bool preview = false,
      bool topBar = false,
    }
    ) {
  String context = markup['@context'];
  if (!['http://schema.org', 'http://schema.org/', 'https://schema.org', 'https://schema.org/', 'http://schema.googleapis.com/'].contains(context)) {
    developer.log(
      'Warning Markup does not contain context tag, or context tag does not contain one of the known schema contexts like http://schema.org\n$markup',
      name: 'jsonld2cards.card_rendering',
    );
  }

  /// Look through markup for phone numbers and emails and add corresponding potential actions
  markup = enrichMarkupWithEmailAndPhoneActions(markup);

  String typeName = markup['@type'];
  var type = getCardType(typeName);
  late MarkupCard card;
  switch (type) {
    case SchemaType.emailMessage: {
      card =  EmailMessage(markup: markup, postFunction: postFunction, preview: preview);
    }
    case SchemaType.place: {
      card =  Place(markup: markup, postFunction: postFunction, preview: preview);
    }
    case SchemaType.musicRecording: {
      // Song
      card =  MusicCard(markup: markup, musicType: MusicType.song, postFunction: postFunction, preview: preview);
    }
    case SchemaType.musicGroup: {
      // Playlist or Artist
      card =  MusicCard(markup: markup, musicType: MusicType.playlist, postFunction: postFunction, preview: preview);
    }
    case SchemaType.musicAlbum: {
      card =  MusicCard(markup: markup, musicType: MusicType.album, postFunction: postFunction, preview: preview);
    }
    case SchemaType.flightReservation: {
      card =  FlightReservationCard(markup: markup, postFunction: postFunction, preview: preview);
    }
    case SchemaType.order: {
      card =  OrderCard(markup: markup, postFunction: postFunction, preview: preview);
    }
    case SchemaType.invoice: {
      card =  InvoiceCard(markup: markup, postFunction: postFunction, preview: preview);
    }
    case SchemaType.parcelDelivery: {
      card =  ParcelDeliveryCard(markup: markup, postFunction: postFunction, preview: preview);
    }
    case SchemaType.blogPosting: {
      card =  BlogPostingCard(markup: markup, postFunction: postFunction, preview: preview);
    }
    case SchemaType.itemList: {
      card =  ItemListCard(markup: markup, postFunction: postFunction, preview: preview);
    }
    case SchemaType.confirmAction: {
      card =  ActionCard(markup: markup, postFunction: postFunction, preview: preview);
    }
    case SchemaType.cancelAction: {
      card =  ActionCard(markup: markup, postFunction: postFunction, preview: preview);
    }
    default: {
      card =  DefaultMarkupCard(markup: markup, postFunction: postFunction, preview: preview);
    }
  }
  if (topBar) {
  return surroundWithTopBar(card);
  } else {
    return card;
  }
}



Card surroundWithTopBar(MarkupCard card) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          getTabContents(card),
          card,
        ],
      ),
    ),
  );
}
Card surroundWithLogoTopBar(Widget logoToUse, String? nameToUse, Widget card) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          Row(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:  4.0),
              child: logoToUse,),
            Text(nameToUse ?? ''),],),
          card,
        ],
      ),
    ),
  );
}

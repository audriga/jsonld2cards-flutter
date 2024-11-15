library card_rendering;

import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:jsonld2cards/Cards/event_card.dart';
import 'package:jsonld2cards/Cards/simple_poll_card.dart';
import 'package:jsonld2cards/card_data.dart';
import 'Cards/BuildingBlocks/potential_actions.dart';
import 'Cards/BuildingBlocks/template_card.dart';
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
// @Deprecated('Use tryRenderCardFromCardData instead')
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
// @Deprecated('Use mustRenderCardFromCardData instead')
Widget mustRenderCard(
  dynamic markup, {
  required PostFunction postFunction,
  bool preview = false,
  bool topBar = false,
}) =>
    mustRenderCardFromCardData(CardData(
      markup,
      postFunction: postFunction,
      preview: preview,
      topBar: topBar,
    ));

Widget? tryRenderCardFromCardData(CardData cardData) {
  // todo think about error behavior
  try {
    return mustRenderCardFromCardData(cardData);
  } catch (e) {
    return null;
  }
}

Widget mustRenderCardFromCardData(CardData cardData) {
  if (cardData.markupIsList) {
    return renderCardMulti(cardData);
  } else if (cardData.markupIsMap) {
    if (cardData.markup['@graph'] case List<dynamic> graph) {
      cardData.markup = graph;
      return renderCardMulti(cardData);
    } else {
      return renderCardSingle(cardData);
    }
  }
  throw FormatException(
    'markup should either be Map<String, dynamic> or a list of those',
    cardData.markup,
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
Widget renderCardMulti(CardData cardData) {
  // List<Map<String, dynamic>> typeFilteredMarkupList = (cardData.markup as List).whereType<Map<String,dynamic>>().toList();
  var types = cardData.typeFilteredMarkupList.map((e) => e['@type']);
  if (types.contains('DiscountOffer') || types.contains('PromotionCard')) {
    var card = PromoTabCard(cardData: cardData);
    if (cardData.topBar) {
      return surroundWithTopBar(card);
    } else {
      return card;
    }
  }

  org_model.Organization? organization;
  Uri? orgLogo;
  if (types.contains('Organization')) {
    organization = org_model.Organization.fromJson(cardData.markupList
        .firstWhere((element) =>
            element is Map<String, dynamic> &&
            element['@type'] == 'Organization'));
    orgLogo = organization.logo;
  } else if (types.contains('NewsMediaOrganization')) {
    organization = org_model.Organization.fromJson(cardData.markupList
        .firstWhere((element) =>
            element is Map<String, dynamic> &&
            element['@type'] == 'NewsMediaOrganization'));
  }

  // Removing things we don't want to render in the card
  cardData.markup = removeMarkupClutter(cardData.markupList);

  // Now markupList should contain
  // Any single item (MusicAlbum, NewsArticle, etc.)
  // A list of items (multi-content case; email only)
  // Any itemList (0006422)

  switch (cardData.markupList.length) {
    case 0:
      {
        throw FormatException(
          'markup does not contain any valid cards',
          cardData.markupList,
        );
      }
    case 1:
      var subCard = renderCardSingle(CardData.fromOther(
        cardData,
        markup: cardData.markupList.first,
        topBar: cardData.topBar &&
            orgLogo == null, // only show one top bar, org logo takes priority
      ));
      if (cardData.topBar && orgLogo != null) {
        return surroundWithLogoTopBar(UriImage(content: orgLogo, height: 16),
            organization?.name, subCard);
      } else {
        return subCard;
      }
    default:
      {
        return TabbedMultiCard(cardData);
      }
  }
}

Widget? tryRenderCardSingle(CardData cardData) {
  try {
    return renderCardSingle(cardData);
  } catch (e) {
    return null;
  }
}

Widget renderCardSingle(CardData cardData) {
  String? context = cardData.markup['@context'];
  if (![
    'http://schema.org',
    'http://schema.org/',
    'https://schema.org',
    'https://schema.org/',
    'http://schema.googleapis.com/'
  ].contains(context ?? '')) {
    developer.log(
      'Warning Markup does not contain context tag, '
          'or context tag does not contain one of the known schema contexts '
          'like http://schema.org\n${cardData.markup}',
      name: 'jsonld2cards.card_rendering',
    );
  }

  /// Look through markup for phone numbers and emails and add corresponding potential actions
  cardData.markup = enrichMarkupWithEmailAndPhoneActions(cardData.markup);

  /// Add default ViewAction "Visit" to cards that have a url.
  cardData.markup = addDefaultViewActionToMarkup(cardData.markup);
  cardData.markup = addSpecialViewActionToMarkup(cardData.markup);

  String typeName = cardData.markup['@type'];
  var type = getCardType(typeName);
  if (type != SchemaType.place) {
    // Append "Navigate to" and "View" Actions to cards that contain GeoCoordinates.
    // Don't do this for place cards, as they already add these actions themselves.
    // (Especially for liveLocation cards we cant to avoid buttons pointing to stale locations).
    cardData.markup = enrichMarkupWithNavigationActions(cardData.markup);
  }
  if (type == SchemaType.event) {
    /// On event markups, add potentialAction to share the event
    cardData.markup = enrichMarkupWithShareEventAction(cardData.markup);
  }
  late MarkupCard card;
  switch (type) {
    case SchemaType.emailMessage:
      {
        card = EmailMessage(cardData);
      }
    // case SchemaType.bakery:
    case SchemaType.place:
      {
        card = Place(cardData);
      }
    case SchemaType.musicRecording:
      {
        // Song
        card = MusicCard(cardData, musicType: MusicType.song);
      }
    case SchemaType.musicGroup:
      {
        // Playlist or Artist
        card = MusicCard(cardData, musicType: MusicType.playlist);
      }
    case SchemaType.musicAlbum:
      {
        card = MusicCard(cardData, musicType: MusicType.album);
      }
    case SchemaType.flightReservation:
      {
        card = FlightReservationCard(cardData);
      }
    case SchemaType.order:
      {
        card = OrderCard(cardData);
      }
    case SchemaType.invoice:
      {
        card = InvoiceCard(cardData);
      }
    case SchemaType.parcelDelivery:
      {
        card = ParcelDeliveryCard(cardData);
      }
    case SchemaType.blogPosting:
      {
        card = BlogPostingCard(cardData);
      }
    case SchemaType.itemList:
      {
        card = ItemListCard(cardData);
      }
    case SchemaType.confirmAction:
      {
        card = ActionCard(cardData);
      }
    case SchemaType.cancelAction:
      {
        card = ActionCard(cardData);
      }
    case SchemaType.event:
      {
        card = EventCard(cardData);
      }
    case SchemaType.promotionCard:
      {
        card = PromoTabCard(cardData: cardData);
      }
    case SchemaType.simplePoll:
      {
        card = SimplePollCard(cardData);
      }
    default:
      {
        if (type?.isSimpleTemplatedType ?? false) {
          card = SimpleTemplateCard(cardData);
        } else if (type?.isThreeColumnTemplatedType ?? false) {
          card = ThreeColumnTemplateCard(cardData);
        } else {
          card = DefaultMarkupCard(cardData);
        }
      }
  }
  if (cardData.topBar) {
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
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: logoToUse,
              ),
              Text(nameToUse ?? ''),
            ],
          ),
          card,
        ],
      ),
    ),
  );
}

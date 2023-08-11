library card_rendering;


import 'package:jsonld2cards/Cards/BuildingBlocks/potential_actions.dart';

import 'Cards/invoice_card.dart';
import 'Cards/order_card.dart';
import 'Cards/promo_tab_card.dart';
import 'Cards/default_markup_card.dart';
import 'Cards/email_message_card.dart';
import 'Cards/flight_reservation_card.dart';
import 'Cards/music_card.dart';
import 'Cards/parcel_delivery_card.dart';
import 'Cards/place_card.dart';
import 'package:flutter/material.dart';
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
  if (markup is List<Map<String, dynamic>>) {
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
  } else if (markup is List<dynamic>) {
    List<Map<String, dynamic>> recastMarkup = [];
    markup.map((element) => recastMarkup
        .add(element as Map<String, dynamic>))
        .toList();
    return renderCardMulti(
      recastMarkup,
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
    List<Map<String, dynamic>> markupList,
    {
      required PostFunction postFunction,
      bool preview = false,
      bool topBar = false,
    }
    ) {
  var types = markupList.map((e) => e['@type']);
  if (types.contains('Organization')
      && types.contains('EmailMessage')
      && types.contains('DiscountOffer')
      && types.contains('PromotionCard')
  ) {
    var card = PromoTabCard(markupList: markupList, preview: preview);
    if (topBar) {
      return surroundWithTopBar(Icons.local_offer, 'Promotion', card);
    } else {
      return card;
    }
  }

  // Fallback: Render the first usable card that can be found
  for (var markup in markupList) {
    var subCard = tryRenderCardSingle(
      markup,
      postFunction: postFunction,
      preview: preview,
      topBar: topBar,
    );
    if (subCard != null) return subCard;
  }

  throw FormatException(
    'markup does not contain any valid cards',
    markupList,
  );
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
// todo find a good way to use enums instead of strings in switch below
enum SchemaType {
  emailMessage,
  place,
  musicRecording,
  musicGroup,
  musicAlbum,
  flightReservation,
  order,
  invoice,
  parcelDelivery,
}

SchemaType? getCardType(String typeName) {
  return switch (typeName) {
    'EmailMessage' => SchemaType.emailMessage,
    'Place' => SchemaType.place,
    'MusicRecording' => SchemaType.musicRecording,
    'MusicGroup' => SchemaType.musicGroup,
    'MusicAlbum' => SchemaType.musicAlbum,
    'FlightReservation' => SchemaType.flightReservation,
    'Order' => SchemaType.order,
    'Invoice' => SchemaType.invoice,
    'ParcelDelivery' => SchemaType.parcelDelivery,
    _ => null
  };
}

extension SchemaTypeName on SchemaType {

  // String get name {
  //   switch(this) {
  //     case SchemaType.emailMessage: return 'EmailMessage';
  //     case SchemaType.place: return 'Place';
  //
  //     default: return "";
  //   }
  // }

  String get tabName {
    return switch(this) {
      SchemaType.emailMessage => 'Email Message',
      SchemaType.place => 'Place',
      SchemaType.musicRecording => 'Song',
      SchemaType.musicGroup => 'Music',
      SchemaType.musicAlbum => 'Album',
      SchemaType.flightReservation => 'Flight Reservation',
      SchemaType.order => 'Order',
      SchemaType.invoice => 'Invoice',
      SchemaType.parcelDelivery => 'Parcel'
    };
  }

  IconData? get icon {
    return switch(this) {
      SchemaType.emailMessage => Icons.mail,
      SchemaType.place => Icons.place,
      SchemaType.musicRecording => Icons.music_note,
      SchemaType.musicGroup => Icons.queue_music,
      SchemaType.musicAlbum => Icons.album,
      SchemaType.flightReservation => Icons.flight,
      SchemaType.order => Icons.shopping_bag,
      SchemaType.invoice => Icons.receipt,
      SchemaType.parcelDelivery => Icons.local_shipping
    };
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
  if (!['http://schema.org', 'http://schema.org/', 'https://schema.org', 'http://schema.googleapis.com/'].contains(context)) {
    throw FormatException(
      'Markup does not contain context tag, or context tag does not contain one of the known schema contexts like http://schema.org',
      markup,
    );
  }
  String typeName = markup['@type'];
  var type = getCardType(typeName);
  late Widget card;
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
    default: {
      card =  DefaultMarkupCard(markup: markup, postFunction: postFunction, preview: preview);
    }
  }
  if (topBar) {
  var iconToUse = type?.icon ?? Icons.mail;
  var nameToUse = type?.tabName ?? 'Shared Semantic';
  return surroundWithTopBar(iconToUse, nameToUse, card);
  } else {
    return card;
  }
}

Card surroundWithTopBar(IconData iconToUse, String nameToUse, Widget card) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          Row(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:  4.0),
              child: Icon(iconToUse),),
            Text(nameToUse),],),
          card,
        ],
      ),
    ),
  );
}

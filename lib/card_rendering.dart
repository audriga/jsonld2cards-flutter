library card_rendering;

import 'package:jsonld2cards/Cards/promo_tab_card.dart';
import 'Cards/default_markup_card.dart';
import 'Cards/email_message_card.dart';
import 'Cards/flight_reservation_card.dart';
import 'Cards/music_card.dart';
import 'Cards/place_card.dart';
import 'package:flutter/material.dart';

/// Renders a card, based on the given markup.
///
/// Assumes `markup` is either a single Map<String, dynamic>, or a `List<Map<String, dynamic>>`
///
/// postFunction is the function which is used to post data on action
///  buttons that post data (f.e. ConfirmAction button). Can be set to a dummy function if not needed.
///
/// Returns the card if it was successfully created and null if the card could not
///  be rendered.
///
/// For now the form of a nullable function was chosen, as the caller can
///  decide themselves what alternative widget to return.
Widget? renderCard(
    dynamic markup,
    {
      required Function(Uri uriToPost, {dynamic dataToPost, String successMessage}) postFunction,
    }
    ) {
  try {
    return mustRenderCard(markup, postFunction: postFunction);
  } catch (e) {
    return null;
  }
}


/// Same as renderCard, but always returns a card, or throws an exception.
Widget mustRenderCard(
    dynamic markup,
    {
      required Function(Uri uriToPost, {dynamic dataToPost, String successMessage}) postFunction,
    }
    ) {
  if (markup is List<Map<String, dynamic>>) {
    return renderCardMulti(markup, postFunction: postFunction);
  }  else if (markup is Map<String, dynamic>) {
    return renderCardSingle(markup, postFunction: postFunction);
  } else if (markup is List<dynamic>) {
    List<Map<String, dynamic>> recastMarkup = [];
    markup.map((element) => recastMarkup
        .add(element as Map<String, dynamic>))
        .toList();
    return renderCardMulti(recastMarkup, postFunction: postFunction);
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
      required Function(Uri uriToPost, {dynamic dataToPost, String successMessage}) postFunction,
    }
    ) {
  var types = markupList.map((e) => e['@type']);
  if (types.contains('Organization')
      && types.contains('EmailMessage')
      && types.contains('DiscountOffer')
      && types.contains('PromotionCard')
  ) {
    return PromoTabCard(markupList: markupList,);
  }

  // Fallback: Render the first usable card that can be found
  for (var markup in markupList) {
    var subCard = tryRenderCardSingle(markup, postFunction: postFunction);
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
      required Function(Uri uriToPost, {dynamic dataToPost, String successMessage}) postFunction,
    }
    )  {
  try {
    return renderCardSingle(markup, postFunction: postFunction);
  } catch (e) {
    return null;
  }
}

Widget renderCardSingle(
    Map<String, dynamic> markup,
    {
      required Function(Uri uriToPost, {dynamic dataToPost, String successMessage}) postFunction,
    }
    ) {
  String context = markup['@context'];
  if (!['http://schema.org', 'http://schema.org/', 'https://schema.org', 'http://schema.googleapis.com/'].contains(context)) {
    throw FormatException(
      'Markup does not contain context tag, or context tag does not contain one of the known schema contexts like http://schema.org',
      markup,
    );
  }
  String type = markup['@type'];
  switch (type) {
    case 'EmailMessage': {
      return EmailMessage(markup: markup, postFunction: postFunction);
    }
    case 'Place': {
      return Place(markup: markup, postFunction: postFunction);
    }
    case 'MusicRecording': {
      // Song
      return MusicCard(markup: markup, musicType: MusicType.song, postFunction: postFunction);
    }
    case 'MusicGroup': {
      // Playlist or Artist
      return MusicCard(markup: markup, musicType: MusicType.playlist, postFunction: postFunction);
    }
    case 'MusicAlbum': {
      return MusicCard(markup: markup, musicType: MusicType.album, postFunction: postFunction);
    }
    case 'FlightReservation': {
      return FlightReservationCard(markup: markup, postFunction: postFunction);
    }
    default: {
      return DefaultMarkupCard(markup: markup, postFunction: postFunction);
    }
  }
}

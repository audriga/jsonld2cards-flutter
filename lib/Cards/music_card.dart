library;

import 'package:jsonld2cards/Cards/BuildingBlocks/simple_card.dart';
import 'package:jsonld2cards/Cards/Models/schema_types.dart';
import 'package:jsonld2cards/Cards/markup_card.dart';
import 'package:jsonld2cards/card_data.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'BuildingBlocks/uri_image.dart';

final log = Logger('jsonld2cards.cards.music');

enum MusicType {album, playlist, song}
class MusicCard extends StatelessWidget implements MarkupCard {
  final MusicType musicType;

  const MusicCard(this.cardData, {
    super.key,
    this.musicType = MusicType.album,
  });

  final CardData cardData;


  @override
  Widget build(BuildContext context) {
    // Uri? uri = Uri.tryParse(markup['url']);
    IconData defaultIcon;
    switch (musicType) {
      case MusicType.album:
        defaultIcon = Icons.album;
        break;
      case MusicType.playlist:
        defaultIcon = Icons.playlist_play;
        break;
      case MusicType.song:
        defaultIcon = Icons.music_note;
        break;
    }
    Widget defaultAlbumCover =  Icon(defaultIcon);
    UriImage? albumCover = findLeadingImage(cardData.markup);
    Widget leadingImage = albumCover ?? defaultAlbumCover;


    var potentialAction = cardData.markup['potentialAction'];

    return SimpleCard(
      leadingImage: leadingImage,
      titleText: cardData.markup['name'],
      subtitleText: cardData.markup['description'],
      potentialAction: potentialAction,
      cardData: cardData,
    );
  }

  Future<String?> getImageSource(Uri? uri) async {
    if (uri == null) return null;
    http.Response response =  await http.get(uri);
    var parsedResponse = parse(response.body);
    var head = parsedResponse.head;
    if (head != null) {
      var metaTags = head.getElementsByTagName('meta');
      var imageUrls = metaTags.where((script) => script.attributes['name'] == 'twitter:image');
      if (imageUrls.length > 1) {
        log.warning(
          'Got more image urls than expected:\n$imageUrls'
        );
      }
      if (imageUrls.isNotEmpty) return imageUrls.first.attributes['content'];
    }
    return null;
  }

  SchemaType get cardType => switch (musicType) {
    MusicType.album => SchemaType.musicAlbum,
    MusicType.playlist => SchemaType.musicGroup,
    MusicType.song => SchemaType.musicRecording,
  };

  @override
  IconData get tabIcon => cardType.icon!;

  @override
  String get tabName => cardType.tabName;
}
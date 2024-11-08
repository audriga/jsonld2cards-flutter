library music_card;

import 'package:jsonld2cards/Cards/BuildingBlocks/simple_card.dart';
import 'package:jsonld2cards/Cards/Models/schema_types.dart';
import 'package:jsonld2cards/Cards/markup_card.dart';
// import '../Util/conversion.dart';
import 'BuildingBlocks/potential_actions.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'BuildingBlocks/uri_image.dart';

enum MusicType {album, playlist, song}
class MusicCard extends StatelessWidget implements MarkupCard {
  final MusicType musicType;

  const MusicCard({
    super.key,
    required this.markup,
    this.musicType = MusicType.album,
    required this.postFunction,
    this.preview = false,
  });

  final Map<String, dynamic> markup;
  final PostFunction postFunction;
  final bool preview;

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
    UriImage? albumCover = findLeadingImage(markup);
    Widget leadingImage = albumCover ?? defaultAlbumCover;


    var potentialAction = markup['potentialAction'];

    return SimpleCard(
      leadingImage: leadingImage,
      titleText: markup['name'],
      subtitleText: markup['description'],
      potentialAction: potentialAction,
      potentialActionPostFunction: postFunction,
      preview: preview,
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
        developer.log(
          'Got more image urls than expected:\n$imageUrls',
          name: 'jsonld2cards.card',
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
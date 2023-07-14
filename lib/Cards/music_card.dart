library music_card;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:jsonld2cards/Cards/BuildingBlocks/simple_card.dart';
import 'BuildingBlocks/potential_actions.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'BuildingBlocks/uri_image.dart';

enum MusicType {album, playlist, song}
class MusicCard extends StatelessWidget {
  final MusicType musicType;

  const MusicCard({
    super.key, required this.markup, this.musicType = MusicType.album, required this.postFunction,
  });

  final Map<String, dynamic> markup;
  final PostFunction postFunction;

  @override
  Widget build(BuildContext context) {
    Uri? uri = Uri.tryParse(markup['url']);
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
    Widget albumCover = FutureBuilder<String?>(
      future: getImageSource(uri),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        // List<Widget> children;
        if (snapshot.hasData) {
          String? imageUrl = snapshot.data;
          developer.log(
            'Got image url:$imageUrl',
            name: 'jsonld2cards.card',
          );
          return imageUrl != null
              ? UriImage(
            placeholder: (context, url) => const CircularProgressIndicator(),
            content: snapshot.data!,
            fit: BoxFit.contain,
          )
              : defaultAlbumCover; //const Icon(Icons.album);
        } else if (snapshot.hasError) {
          developer.log(
            'Error loading image source',
            name: 'jsonld2cards.music_card',
            error: snapshot.error,
          );
          return Icon(
            defaultIcon,
            color: Colors.red,
          );
          // todo actually check how these error states look
          // or replace with generic album icon and just log error
          // children = <Widget>[
          //   const Icon(
          //     Icons.error_outline,
          //     color: Colors.red,
          //     size: 10,
          //   ),
          //   Padding(
          //     padding: const EdgeInsets.only(top: 16),
          //     child: Text('Error: ${snapshot.error}'),
          //   ),
          // ];
        } else {
          // children = const <Widget>[SizedBox.square(dimension: 10, child: CircularProgressIndicator(),)];
          developer.log(
            'Loading image source',
            name: 'jsonld2cards.card',
          );
          return const CircularProgressIndicator();
        }
        // return Center(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: children,
        //   ),
        // );
      },
    );



    var potentialAction = markup['potentialAction'];

    return SimpleCard(
      leadingImage: albumCover,
      titleText: markup['name'],
      subtitleText: markup['description'],
      potentialAction: potentialAction,
      potentialActionPostFunction: postFunction,
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
}
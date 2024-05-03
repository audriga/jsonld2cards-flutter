library music_model;

import 'package:jsonld2cards/Cards/Models/thing_model.dart';
// import 'package:jsonld2cards/Cards/music_card.dart';

/// Special case to provide duplicate hash function for jsonld rendered by [MusicCard]


class MusicAlbum extends Thing {
  @override
  int get duplicateHash => type.hashCode ^ name.hashCode ^ description.hashCode ^ url.hashCode;

  /// Expects [name], [description], and [url] to be given (but all provided by superclass).
  MusicAlbum({super.name, super.description, super.url});

  MusicAlbum.fromJson(super.json) : super.fromJson();

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['@type'] = 'MusicAlbum';
    return data;
  }
}

/// Playlist or Artist Page
class MusicGroup extends Thing {
  @override
  int get duplicateHash => type.hashCode ^ name.hashCode ^ description.hashCode ^ url.hashCode;

  /// Expects [name], [description], and [url] to be given (but all provided by superclass).
  MusicGroup({super.name, super.description, super.url});

  MusicGroup.fromJson(super.json) : super.fromJson();

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['@type'] = 'MusicGroup';
    return data;
  }
}

/// A single song
class MusicRecording extends Thing {
  @override
  int get duplicateHash => type.hashCode ^ name.hashCode ^ description.hashCode ^ url.hashCode;

  /// Expects [name], [description], and [url] to be given (but all provided by superclass).
  MusicRecording({super.name, super.description, super.url});

  MusicRecording.fromJson(super.json) : super.fromJson();

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['@type'] = 'MusicRecording';
    return data;
  }
}
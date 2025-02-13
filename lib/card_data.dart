library;

import 'dart:typed_data';
import 'package:flutter/widgets.dart';

import 'cards/building_blocks/potential_actions.dart';

class Attachment {
  Uint8List? data;
  String? filename;
  String? mimeType;
  String? source;
  String? description;

  Attachment(
      {this.data,
      this.filename,
      this.mimeType,
      this.source,
      this.description,
      });
}

class CardData {
  dynamic markup; // List<Map<String,dynamic>> or Map<String, dynamic>
  PostFunction? postFunction;
  bool preview;
  bool topBar;
  List<Widget>? additionalButtons;
  bool showMessageHeader;
  Attachment? sourceFile;
  List<Attachment>? otherAttachments;

  /// True, of sMime valid, false means either sMime invalid or not present.
  bool sMimeValid;

  // True means sMime invalid, false means either sMime valid, or not present.
  bool sMimeInvalid;
  bool dkimValid;
  bool dkimInvalid;
  bool isArchived;
  bool isDeleted;

  CardData(
    this.markup, {
    this.postFunction,
    this.preview = false,
    this.topBar = false,
    this.additionalButtons,
    this.showMessageHeader = false,
    this.sourceFile,
    this.otherAttachments,
    this.sMimeValid = false,
    this.sMimeInvalid = false,
    this.dkimValid = false,
    this.dkimInvalid = false,
    this.isArchived = false,
    this.isDeleted = false,
  });

  bool get markupIsList =>
      (markup is List<dynamic>) || (markup is List<Map<String, dynamic>>);

  List get markupList => markupIsList ? markup : [markup];

  List<Map<String, dynamic>> get typeFilteredMarkupList =>
      markupList.whereType<Map<String, dynamic>>().toList();

  bool get markupIsMap => markup is Map<String, dynamic>;

  /// Creates a card data from some other card data, overriding the set properties.
  CardData.fromOther(
    CardData o, {
    dynamic markup,
    PostFunction? postFunction,
    bool? preview,
    bool? topBar,
    List<Widget>? additionalButtons,
    bool? showMessageHeader,
    Attachment? sourceFile,
    List<Attachment>? otherAttachments,
    bool? sMimeValid,
    bool? sMimeInvalid,
    bool? dkimValid,
    bool? dkimInvalid,
    bool? isArchived,
    bool? isDeleted,
  })  : markup = markup ?? o.markup,
        postFunction = postFunction ?? o.postFunction,
        preview = preview ?? o.preview,
        topBar = topBar ?? o.topBar,
        additionalButtons = additionalButtons ?? o.additionalButtons,
        showMessageHeader = showMessageHeader ?? o.showMessageHeader,
        sourceFile = sourceFile ?? o.sourceFile,
        otherAttachments = otherAttachments ?? o.otherAttachments,
        sMimeValid = sMimeValid ?? o.sMimeValid,
        sMimeInvalid = sMimeInvalid ?? o.sMimeInvalid,
        dkimValid = dkimValid ?? o.dkimValid,
        dkimInvalid = dkimInvalid ?? o.dkimInvalid,
        isArchived = isArchived ?? o.isArchived,
        isDeleted = isDeleted ?? o.isDeleted;
}

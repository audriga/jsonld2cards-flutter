library uri_image;

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

/// Renders an image based on the given Uri.
/// When URI is a http/ https URL pointing to a web resource, returns the corresponding network image
/// When URI is a data URI containing a B64 encoded image, renders that image
/// todo use this function for geo cards, as this is duplicated from there
class UriImage extends StatelessWidget {
  const UriImage({
    super.key,
    required this.content,
    this.placeholder,
    this.width,
    this.height,
    this.color,
    this.colorBlendMode,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.matchTextDirection = false,
    this.filterQuality = FilterQuality.low,
  });

  final dynamic content;
  final PlaceholderWidgetBuilder? placeholder;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Alignment alignment;
  final ImageRepeat repeat;
  final bool matchTextDirection;
  final Color? color;
  final BlendMode? colorBlendMode;
  final FilterQuality filterQuality;


  @override
  Widget build(BuildContext context) {
    Uri? jsonImageUri;
    // Uri? imageB64;
    Uri? imageUrl;
    if (content is Uri) {
      jsonImageUri = content;
    } else if (content is String) {
      jsonImageUri = Uri.tryParse(content);
    }
    if (jsonImageUri != null) {
      var imageUriData = jsonImageUri.data;
      if (imageUriData != null && imageUriData.isBase64) {
        // imageB64 = jsonImageUri;
        return Image.memory(
          base64Decode(imageUriData.contentText),
          width: width,
          height: height,
          color: color,
          colorBlendMode: colorBlendMode,
          fit: fit,
          alignment: alignment,
          repeat: repeat,
          matchTextDirection: matchTextDirection,
          filterQuality: filterQuality,
        );
      } else if (['http', 'https'].contains(jsonImageUri.scheme)) {
        imageUrl = jsonImageUri;
        return CachedNetworkImage(
          imageUrl: imageUrl.toString(),
          placeholder: placeholder,
          width: width,
          height: height,
          color: color,
          colorBlendMode: colorBlendMode,
          fit: fit,
          alignment: alignment,
          repeat: repeat,
          matchTextDirection: matchTextDirection,
          filterQuality: filterQuality,
        );
      } else {
        throw FormatException('Unexpected scheme: ${jsonImageUri.scheme}', content);
      }
    } else {
      //Unknown scheme
      throw FormatException('Content is not a uri', content);
    }
  }
}
library;

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jsonld2cards/app_context.dart';
import 'package:jsonld2cards/util/conversion.dart';
import 'package:logging/logging.dart';

final log = Logger('jsonld2cards.cards.buildingBlocks.uriImage');

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
    this.errorWidget = brokenImageErrorWidget,
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

  /// Widget displayed while the target failed loading.
  final LoadingErrorWidgetBuilder? errorWidget;

  @override
  Widget build(BuildContext context) {
    Uri? jsonImageUri;
    // Uri? imageB64;
    Uri? imageUrl;
    if (content is Uri) {
      jsonImageUri = content;
    } else if (content is String && (content as String).isNotEmpty) {
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
      } else if (['http', 'https', ''].contains(jsonImageUri.scheme)) {
        if (jsonImageUri.scheme == '') {
          jsonImageUri = Uri.parse('https://${jsonImageUri.toString()}');
        }

        imageUrl = jsonImageUri;

        bool attemptToProxy = false;
        if (kIsWeb &&
            Uri.base.origin != imageUrl.origin &&
            globalSMLAppContext?.imageProxyUrl != null) {
          attemptToProxy = true;
        }

        String imageUrlString = imageUrl.toString();
        return CachedNetworkImage(
          imageUrl: imageUrlString,
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
          errorWidget: attemptToProxy ? proxiedImage : errorWidget,
        );
      } else {
        var unexpectedSchemeError = FormatException(
            'Unexpected scheme: ${jsonImageUri.scheme}', content);
        if (errorWidget != null) {
          return errorWidget!(context, content, unexpectedSchemeError);
        } else {
          throw unexpectedSchemeError;
        }
      }
    } else {
      //Unknown scheme
      var notAnUriError = FormatException('Content is not a uri', content);
      if (errorWidget != null) {
        return errorWidget!(context, content, notAnUriError);
      } else {
        throw notAnUriError;
      }
    }
  }

  Widget proxiedImage(BuildContext context, String url, error) {
    String? proxyUrl = globalSMLAppContext?.imageProxyUrl;
    return CachedNetworkImage(
      imageUrl: '$proxyUrl?url=$url',
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
  }
}

/// Finds image or logo in given [markup] and returns the corresponding [UriImage]
/// Returns null if no image or logo is found.
/// [LoadingErrorWidgetBuilder] is a function which controls what is done and
/// which widget is displayed, if the image failed loading.
/// [size] is the height and width of the bounding box in which the image will
/// be scaled down to fit in
UriImage? findLeadingImage(Map<String, dynamic> markup,
    {LoadingErrorWidgetBuilder? imageErrorWidget, double size = 32.0}) {
  var image = markup['image'] ?? markup['logo'];
  UriImage? leadingImage;
  if (image != null) {
    try {
      if (image is List<dynamic>) {
        // For array of URLs, unconventional, but used by zeit
        Uri? imageUri;
        if (image.first is Map<String, dynamic>) {
          imageUri =
              tryCastOrParse(image.first['contentUrl'] ?? image.first['url']);
        } else {
          imageUri = tryCastOrParse(image.first);
        }
        if (imageUri != null) {
          leadingImage = UriImage(
            content: imageUri,
            height: size,
            width: size,
            fit: BoxFit.scaleDown,
            errorWidget: imageErrorWidget,
          );
        }
      } else if (image is Map<String, dynamic>) {
        // image is an ImageObject (https://schema.org/ImageObject)
        var contentUrl =
            image['contentUrl'] ?? image['url'] ?? image['embedUrl'];
        leadingImage = UriImage(
          content: contentUrl,
          height: size,
          width: size,
          fit: BoxFit.scaleDown,
          errorWidget: imageErrorWidget,
        );
      } else {
        // Probably URL, so flutter type of String or URI
        var imageAsUri = tryCastOrParse(image);
        if (imageAsUri != null) {
          leadingImage = UriImage(
            content: image,
            height: size,
            width: size,
            fit: BoxFit.scaleDown,
            errorWidget: imageErrorWidget,
          );
        }
      }
    } on FormatException catch (_) {
      // Tried giving something that isn't a uri or can't be parsed to a uri to UriImage.
    }
  }
  return leadingImage;
}

LoadingErrorWidgetBuilder logAndShowNoImage = (context, url, error) {
  log.warning('Error rendering leading Image', error);
  return const SizedBox(
    width: 0,
  );
};

Widget brokenImageErrorWidget(context, url, error) => IconButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Url: $url\nError: ${error.toString()}')));
      },
      icon: const Icon(Icons.broken_image),
    );

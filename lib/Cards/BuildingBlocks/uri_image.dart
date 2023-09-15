library uri_image;

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
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
    this.errorWidget,
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
      } else if (['http', 'https', ''].contains(jsonImageUri.scheme)) {
        if (jsonImageUri.scheme == '') {
          jsonImageUri = Uri.parse('https://${jsonImageUri.toString()}');
        }

        imageUrl = jsonImageUri;

        bool attemptToProxy = false;
        if (kIsWeb && Uri.base.origin != imageUrl.origin) {
          attemptToProxy = true;
        }

        String imageUrlString  = imageUrl.toString();
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
        var unexpectedSchemeError = FormatException('Unexpected scheme: ${jsonImageUri.scheme}', content);
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
    return CachedNetworkImage(
      imageUrl: 'https://www.audriga.eu/test/data/proxyImg.php?url=$url',
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
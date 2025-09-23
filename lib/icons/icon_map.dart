import 'package:embed_annotation/embed_annotation.dart';
import 'package:flutter/material.dart';


part 'icon_map.g.dart';

@EmbedLiteral("data/icon_map.json")
const Map<String, int?> iconMap = _$iconMap;

IconData iconFromSchemaType(String schemaType) {
  if(iconMap[schemaType] case int codepoint) {
    return IconData(codepoint, fontFamily: 'MaterialIcons');
  } else {
    return Icons.credit_card;
  }
}
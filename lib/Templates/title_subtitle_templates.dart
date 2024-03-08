library title_subtitle_templates;

import 'package:jsonld2cards/Cards/Models/schema_types.dart';

String titleSourceTemplate(SchemaType type) => switch(type) {
  SchemaType.bakery => '''{{name}}''',
  _ => throw UnimplementedError('This type doesn\'t have a template')
};
String subTitleSourceTemplate(SchemaType type) => switch(type) {
  SchemaType.bakery => '''{{#address.streetAddress}}{{.}}{{/address.streetAddress}}
hat brötchen''',
  _ => throw UnimplementedError('''This type doesn't have a template''')
};
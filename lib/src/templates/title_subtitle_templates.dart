library;

import 'package:jsonld2cards/cards/models/schema_types.dart';

String titleSourceTemplate(SchemaType type) => switch (type) {
      SchemaType.bakery => '''{{name}}''',
      SchemaType.cafeOrCoffeeShop => '''{{name}}''',
      SchemaType.iceCreamShop => '''{{name}}''',
      _ => throw UnimplementedError('This type doesn\'t have a template')
    };
String subTitleSourceTemplate(SchemaType type) => switch (type) {
      SchemaType.bakery =>
        '''{{#address.streetAddress}}{{.}}{{/address.streetAddress}}
hat brötchen''',
      SchemaType.cafeOrCoffeeShop =>
        '''{{#address.streetAddress}}{{.}}{{/address.streetAddress}}''',
      SchemaType.iceCreamShop =>
        '''{{#address.streetAddress}}{{.}}{{/address.streetAddress}}''',
      _ => throw UnimplementedError('''This type doesn't have a template''')
    };

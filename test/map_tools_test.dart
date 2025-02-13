// import 'dart:convert';
// import 'dart:io';


import 'package:flutter_test/flutter_test.dart';
import 'package:jsonld2cards/util/map_tools.dart';

void main() {
  // test('Test Map Flattening', () {
  //   Map<dynamic, dynamic> nestedMap = {
  //     'first': 'value',
  //     'second': {
  //       'foo': 'bar',
  //       'yes': 'ok',
  //       'map': {'some': 'value'},
  //       'list': [
  //         {
  //           'map': 'in',
  //           'list': 'in',
  //           'further': 'map'
  //         },
  //         {
  //           'another': 'map'
  //         }
  //       ]
  //     }
  //   };
  //   var flatMap = flattenMap(nestedMap);
  //   print(flatMap);
  //   print(nestedMap);
  // });

  test('Test Find Recursive', () {
    Map<String, dynamic> nestedMap = {
      'first': 'value',
      'second': {
        'foo': 'bar',
        'yes': 'ok',
        'map': {'some': 'value'},
        'list': [
          {
            'map': 'in',
            'list': 'in',
            'further': 'map'
          },
          {
            'another': 'map'
          }
        ]
      }
    };
    var results = findAllRecursive(nestedMap, 'map');
    expect(results, [{'some': 'value'}, 'in']);
    expect(results.whereType<String>().isNotEmpty, true);
    var results2 = findAllRecursive(nestedMap, 'another');
    expect(results2, ['map']);
    var results3 = findAllRecursive(nestedMap, 'another', excluded: ['second']);
    expect(results3, []);
  });
}
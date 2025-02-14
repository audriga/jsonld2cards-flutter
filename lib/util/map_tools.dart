library;

// Based on https://stackoverflow.com/a/75978633
// note this changes the original map
// Map<String, dynamic> flattenMap(Map<dynamic, dynamic> map) {
//   for (var key in map.keys) {
//     if (map[key] is Map) {
//       map[key] = flattenMap(map[key]);
//     } else if (map[key] is List) {
//       map[key] = map[key].map((e) => (e is Map)? flattenMap(e) : e).toList();
//     }
//   }
//   return Map<String, dynamic>.from(map);
// }

const emptyList = <String>[];

/// Finds all occurrences of [searchKey] in [map].
/// Performs a depth-first recursive search to do so.
/// Returns the corresponding values.
/// [excluded] contains keys for which the search does not enter the value/ disregards the value completely.
List<dynamic> findAllRecursive(Map<String, dynamic> map, String searchKey,
    {List<String> excluded = emptyList}) {
  var collectedResults = [];
  for (var key in map.keys) {
    if (excluded.contains(key)) continue;
    var value = map[key];
    if (key == searchKey) {
      collectedResults.add(value);
    } else if (value is Map<String, dynamic>) {
      var ret = findAllRecursive(value, searchKey, excluded: excluded);
      collectedResults.addAll(ret);
    } else if (value is List) {
      for (var element in value) {
        if (element is Map<String, dynamic>) {
          collectedResults
              .addAll(findAllRecursive(element, searchKey, excluded: excluded));
        }
      }
    }
  }
  return collectedResults;
}

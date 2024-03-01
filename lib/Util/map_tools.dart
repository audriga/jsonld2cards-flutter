library map_tools;

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
List<dynamic> findAllRecursive(Map<String, dynamic> map, String searchKey, {List<String> excluded = emptyList}) {
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
          collectedResults.addAll(findAllRecursive(element, searchKey, excluded: excluded));
        }
      }
    }
  }
  return collectedResults;
}

// todo should probably be in a separate library for enriching markup
Map<String, dynamic> appendPotentialActions(Map<String, dynamic> markup, List<Map<String, dynamic>> generatedPotentialActions) {
  var originalActions = markup['potentialAction'];
  // Create a (shallow) copy before appending stuff to it to prevent appending more and more
  // potential actions on repeated renders
  Map<String, dynamic> markupCopy = {}..addAll(markup);
  if (originalActions == null) {
    markupCopy['potentialAction'] = generatedPotentialActions;
  } else if (originalActions is List) {
    markupCopy['potentialAction'] = [...originalActions, ...generatedPotentialActions];
  } else {
    markupCopy['potentialAction'] = [originalActions, ...generatedPotentialActions];
  }
  return markupCopy;
}
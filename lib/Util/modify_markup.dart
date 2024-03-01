library modify_markup;

import 'map_tools.dart';


/// Removing things we don't want to render in the card
List<dynamic> removeMarkupClutter(List<dynamic> markupList) {
  List<String> elementsToRemove = [
    // Used for icon only, not in rendered card
    'Organization',
    // Sub-type of Organization
    'NewsMediaOrganization',
    // WebSite ignore for now
    'WebSite',
    // BreadcrumbList for path based backend
    'BreadcrumbList',
    // WebPage ignore for now
    'WebPage'
  ];

  return markupList.where((element) => element is! Map<String,dynamic> || !elementsToRemove.contains(element['@type'])).toList();
}

/// Creates a new markup (via shallow copy) that has the given [generatedPotentialActions] appended to the potential action row.
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

/// Finds telephone and email attributes in [markup] and returns a markup with corresponding actions added to it.
/// Note this performs a shallow copy where the returned map has a new reference, but any value beside the one for
/// potentialActions will be the same reference as the input [markup].
/// See also https://www.woolha.com/tutorials/dart-copy-clone-list-shallow-deep-examples
Map<String, dynamic> enrichMarkupWithEmailAndPhoneActions(Map<String, dynamic> markup) {
  var phones = findAllRecursive(markup, 'telephone', excluded: ['potentialAction']).whereType<String>();
  var emails = findAllRecursive(markup, 'email', excluded: ['potentialAction']).whereType<String>();
  if (phones.isNotEmpty || emails.isNotEmpty) {
    var potentialTelActions = phones.map<Map<String, dynamic>>((e) => {
      '@type': 'CommunicateAction',
      'name': 'Call $e',
      'url': 'tel:$e',
    });
    var potentialMailtoActions = emails.map<Map<String, dynamic>>((e) {
      var mail = e.replaceFirst('mailto:', '');
      return {
        '@type': 'CommunicateAction',
        'name': 'Email $mail',
        'url': 'mailto:$mail',
      };
    });
    List<Map<String,dynamic>> generatedPotentialActions = [...potentialTelActions, ...potentialMailtoActions];
    return appendPotentialActions(markup, generatedPotentialActions);
  }
  return markup;
}
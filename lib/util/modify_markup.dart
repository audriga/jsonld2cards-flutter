library;

import 'package:jsonld2cards/util/conversion.dart';

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

/// Creates a new markup that has the given [generatedPotentialActions] appended to the potential action row.
/// Note this performs a shallow copy where the returned map has a new reference, but any value beside the one for
/// potentialActions will be the same reference as the input [markup].
/// See https://www.woolha.com/tutorials/dart-copy-clone-list-shallow-deep-examples for more information on shallow cloning in dart.
Map<String, dynamic> appendPotentialActions(Map<String, dynamic> markup, List<Map<String, dynamic>> generatedPotentialActions) {
  // Do noting if the list of potential actions is empty
  if (generatedPotentialActions.isEmpty) return markup;
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
/// This uses [appendPotentialActions]. See its note on shallow copy.
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

/// Finds geo in [markup] and returns a markup with corresponding actions added to it.
/// This uses [appendPotentialActions]. See its note on shallow copy.
Map<String, dynamic> enrichMarkupWithNavigationActions(
    Map<String, dynamic> markup) {
  var locations = findAllRecursive(markup, 'geo', excluded: ['potentialAction'])
      .whereType<Map<String, dynamic>>()
      .where((element) => element['@type'] == 'GeoCoordinates')
      .toList();
  if (locations.isNotEmpty) {
    var potentialNavActions = List<Map<String, dynamic>?>.generate(
      locations.length * 2,
      (index) {
        final i = index ~/ 2;
        num? latitude = tryCastOrParseNum(locations[i]['latitude']);
        num? longitude = tryCastOrParseNum(locations[i]['longitude']);
        if (latitude == null || longitude == null) return null;
        return index.isEven
            ? navigationPotentialAction(latitude, longitude)
            : viewGeoPotentialAction(latitude, longitude);
      },
    ).whereType<Map<String, dynamic>>().toList();
    return appendPotentialActions(markup, potentialNavActions);
  }
  return markup;
}

Map<String, dynamic> viewGeoPotentialAction(num latitude, num longitude) => {
      '@type': 'ViewAction',
      'url': 'geo:$latitude,$longitude', //todo android special handling
      'name': 'View',
    };

Map<String, dynamic> navigationPotentialAction(num latitude, num longitude) => {
      '@type': 'ViewAction',
      'url': 'google.navigation:q=$latitude,$longitude',
      'name': 'Navigate to',
    };

/// When [markup] has a url, returns a markup with a ViewAction "Visit" added to it.
/// This uses [appendPotentialActions]. See its note on shallow copy.
Map<String, dynamic> addDefaultViewActionToMarkup(Map<String, dynamic> markup) {
  // todo potentially only add this when there is no potentialAction already
  var url = markup['url'];
  if (url == null) return markup;
  // Don't add an action for cid urls. We do that in invoice class.
  var visitAction = {"@type": "ViewAction", "url": url, "name": "Visit"};
  return appendPotentialActions(markup, [visitAction]);
}


/// When [markup] has uris for stories, video or audio, add corresponding actions to it.
/// This uses [appendPotentialActions]. See its note on shallow copy.
Map<String, dynamic> addSpecialViewActionToMarkup(Map<String, dynamic> markup) {
  // todo potentially only add this when there is no potentialAction already
  List<Map<String, dynamic>> addedActions = [];
  var webStory = markup['webStoryUri'];
  if (webStory != null) {
    var storyAction = {
      '@type': 'ReadStoryAction', //ReadAction is real, ReadStoryAction is invented by us
      'url': webStory,
      // 'variant': 'WebStory', // this is not real markup
      'name': 'View Story',
    };
    addedActions.add(storyAction);
  }
  var video = markup['videoUri'];
  if (video != null) {
    var videoAction = {
      '@type': 'WatchAction',
      'url': video,
      // 'variant': 'Video', // this is not real markup
      'name': 'Watch',
    };
    addedActions.add(videoAction);
  }
  var audio = markup['audioUri'];
  if (audio != null) {
    var audioAction = {
      '@type': 'ListenAction',
      'url': audio,
      // 'variant': 'Audio', // this is not real markup
      'name': 'Listen',
    };
    addedActions.add(audioAction);
  }

  return appendPotentialActions(markup, addedActions);
}


/// Returns markup with action to share it added to it.
/// This is meant for events that get converted to iCalender files.
/// This uses [appendPotentialActions]. See its note on shallow copy.
Map<String, dynamic> enrichMarkupWithShareEventAction(Map<String, dynamic> markup) {
  if (markup['@type'] != 'Event') return markup;
    List<Map<String,dynamic>> generatedPotentialActions = [
      {
        '@type': 'ShareAction',
        'name': 'Export Event',
        'object': markup,
        // could also add SML app as target here, similar to this snippet
        // the target could then contain information as to how to process the object
        // 'target': {
        //   '@type': 'EntryPoint',
        //   'urlTemplate': 'urbanspoon://r/6/92204',
        //   'actionApplication': {
        //     '@type': 'SoftwareApplication',
        //     '@id': '5b23b738-bb64-4829-9296-5bcb59bb0d2d',
        //     'name': 'Windows Phone App',
        //     'operatingSystem': 'Windows Phone 8'
        //   }
        // }
      }
    ];
    return appendPotentialActions(markup, generatedPotentialActions);
}

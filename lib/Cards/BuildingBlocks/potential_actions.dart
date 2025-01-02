library potential_actions;

// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jsonld2cards/MultiMedia/video_popup.dart';
import 'package:jsonld2cards/sml_app_context.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:simple_audio/simple_audio.dart';

import '../../Util/conversion.dart';

// Todo make String nullable?
typedef PostFunction = Function(Uri uriToPost, {dynamic dataToPost, String successMessage});

class PotentialActionRow extends StatelessWidget {
  const PotentialActionRow({
    super.key,
    required this.potentialAction,
    required this.postFunction,
    this.preview = false,
    // this.smlAppContext,
  });

  final dynamic potentialAction;
  final PostFunction postFunction;
  final bool preview;
  // final SMLAppContext? smlAppContext;

  @override
  Widget build(BuildContext context) {
    if (potentialAction is Map<String, dynamic>) {
      Widget button = PotentialActionButton(
        potentialAction : potentialAction,
        postFunction: postFunction,
        preview: preview,
      );
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          button ,
          const SizedBox(width: 8),
        ],
      );
    } else if (potentialAction is List<dynamic>) {
      List<Widget> actionButtons = [];
      for (Map<String, dynamic> action in potentialAction) {
        actionButtons.add(
          PotentialActionButton(
            potentialAction: action,
            postFunction: postFunction,
            preview: preview,
          ),
        );
      }
      actionButtons.add(const SizedBox(width: 8));
      return Align(
        alignment: Alignment.topRight,
        child: Wrap(
          alignment: WrapAlignment.end,
          children: actionButtons,
        ),
      );
    }
    throw FormatException('Potential action is no map or list of maps', potentialAction);
  }
}
// todo enum for action types
class PotentialActionButton extends StatelessWidget {
  const PotentialActionButton({
    super.key,
    required this.potentialAction,
    required this.postFunction,
    this.preview = false,
  });

  final Map<String, dynamic> potentialAction;
  final PostFunction postFunction;
  final bool preview;

  @override
  Widget build(BuildContext context) {
    Widget button = const Text('Unsupported Action');
    String actionType = potentialAction['@type'];
    var actionTarget = potentialAction['target'];
    switch (actionType) {
      case 'CommunicateAction':
      case 'ViewAction': {
        button = TextButton(
          onPressed: preview ? null : () {
            Uri? uriToLaunch = tryCastOrParse(potentialAction['url']);
            if (uriToLaunch != null) {
              if (['cid', 'fetchid'].contains(uriToLaunch.scheme) && globalSMLAppContext?.shareAttachmentCallback != null) {
                if (potentialAction['muid'] case int uid) {
                  globalSMLAppContext!.shareAttachmentCallback!(uid, uriToLaunch);
                }
              } else {
                launchUrl(uriToLaunch);
              }
            }
          },
          child: Text(potentialAction['name'] ?? 'View'),
        );
        return button;
      }
      case 'TrackAction': {
        button = TextButton(
          onPressed: preview ? null : () {
            Uri? uriToLaunch = tryCastOrParse(potentialAction['url']);
            if (uriToLaunch != null) {
              launchUrl(uriToLaunch);
            }
          },
          child: Text(potentialAction['name'] ?? 'Track'),
        );
        return button;
      }
      case 'ConfirmAction': {
        //todo dynamically support different fillings of ConfirmAction
        Map<String, dynamic>? handler = potentialAction['handler'];
        String confirmUri = actionTarget ?? '';
        if (handler != null) {
          // todo switch depending on handler type?
          confirmUri = handler['url'];
        }
        var actionName = potentialAction['name'] ?? 'Confirm';
        button = TextButton(
          onPressed: preview ? null : () {
            Uri? uriToPost = tryCastOrParse(confirmUri);
            if (uriToPost != null) {
              if (uriToPost.scheme == 'mailto' && globalSMLAppContext?.confirmCallback != null) {
                potentialAction['@context'] = 'https://schema.org';
                potentialAction['actionStatus'] = 'CompletedActionStatus';
                globalSMLAppContext!.confirmCallback!(subject: 'Action $actionName', dataToSend: potentialAction, recipient: uriToPost.path);
              } else {
                postFunction(uriToPost, successMessage: 'Sent Confirmation');
              }
            }
          },
          child: Text(actionName),
        );
        return button;
      }
      case 'CancelAction' : {
        var actionName = potentialAction['name'] ?? 'Cancel';
        button = TextButton(
          onPressed: preview ? null : () {
            Uri? uriToPost = tryCastOrParse(actionTarget);
            if (uriToPost != null) {
              if (uriToPost.scheme == 'mailto' && globalSMLAppContext?.confirmCallback != null) {
                potentialAction['@context'] = 'https://schema.org';
                potentialAction['actionStatus'] = 'CompletedActionStatus';
                globalSMLAppContext!.confirmCallback!(subject: 'Action $actionName', dataToSend: potentialAction, recipient: uriToPost.path);
              } else {
                postFunction(uriToPost, successMessage: 'Sent Cancellation');
              }
            }
          },
          child: Text(actionName),
        );
        return button;
      }
      case 'EditAction' : {
        button = TextButton(
          onPressed: preview ? null : () {
            Uri? uriToLaunch = tryCastOrParse(actionTarget);
            if (uriToLaunch != null) {
              launchUrl(uriToLaunch);
            }
          },
          child: Text(potentialAction['name'] ?? 'Edit'),
        );
        return button;
      }
      case 'CheckInAction': {
        button = TextButton(
          onPressed: preview ? null : () {
            Uri? uriToPost = tryCastOrParse(actionTarget);
            if (uriToPost != null) {
              postFunction(uriToPost, successMessage: 'Sent Check-In');
            }
          },
          child: const Text('Check In'),
        );
        return button;
      }
      // case 'ListenAction': {
      //   button = AudioActionButton(preview: preview, potentialAction: potentialAction, actionTarget: actionTarget);
      //   return button;
      // }
      /// Special Case for Live Location
      case 'UpdateAction': {
        button = IconButton(
          onPressed: preview ? null : () async {
            // Misusing postFunction to call update function.
            postFunction(Uri.base);
          },
          icon: const Icon(Icons.refresh),
        );
        return button;
      }
      case 'SearchAction': {
        button = IconButton(
          onPressed: preview ? null : () {
            Uri? uriToLaunch = tryCastOrParse(actionTarget);
            // todo should query for search... But this might be difficult to implement
            if (uriToLaunch != null) {
              launchUrl(uriToLaunch);
            }
          },
          icon: const Icon(Icons.search),
        );
        return button;
      }
      case 'CopyToClipboardAction' : {
        String nameOfCode = potentialAction['name'] ?? 'Copy';
        String codeToCopy = potentialAction['description'];
        button = TextButton.icon(
          onPressed: preview ? null : () async {
            await Clipboard.setData(ClipboardData(text: codeToCopy));
          },
          label: Text('$nameOfCode: $codeToCopy'),
          icon: const Icon(Icons.copy),
        );
        return button;
      }
      case 'ShareAction': {
        var actionName = potentialAction['name'] ?? 'Cancel';
        button = TextButton(
          onPressed: (preview || globalSMLAppContext?.confirmCallback == null) ? null : () {
            var object = potentialAction['object'];
            if (object is Map<String, dynamic>  && globalSMLAppContext?.eventCallback != null) {
              globalSMLAppContext!.eventCallback!(eventData: object);
            }
          },
          child: Text(actionName),
        );
       return button;
      }
      case 'ReadStoryAction': {
        Uri? uriToLaunch = tryCastOrParse(potentialAction['url']);
        if (uriToLaunch != null) {
          button = TextButton.icon(onPressed: () {
            var controller = WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..setNavigationDelegate(
                NavigationDelegate(
                  onProgress: (int progress) {
                    // Update loading bar.
                  },
                  onPageStarted: (String url) {},
                  onPageFinished: (String url) {},
                  onHttpError: (HttpResponseError error) {},
                  onWebResourceError: (WebResourceError error) {},
                ),
              )
              ..loadRequest(uriToLaunch);
            Navigator.of(context).push(
             MaterialPageRoute(builder: (context) => Scaffold(
               appBar: AppBar(title: const Text('Story')),
               body: WebViewWidget(controller: controller),
             ),)
            );
          },
            label: const Text('View Story'),
            // icon: const Icon(Icons.read),
          );
        }
      }
      case 'WatchAction': {
        Uri? uriToLaunch = tryCastOrParse(potentialAction['url']);
        if (uriToLaunch != null) {
          button = TextButton.icon(onPressed: () {
           showDialog(context: context, builder: (context) => VideoPlayerDialog(source: uriToLaunch,),);
          },
            label: const Text('Watch'),
            icon: const Icon(Icons.play_circle),
          );
        }
      }
    }
    return button;
  }
}

// class AudioActionButton extends StatefulWidget {
//   const AudioActionButton({
//     super.key,
//     required this.preview,
//     required this.potentialAction,
//     required this.actionTarget,
//   });
//
//   final bool preview;
//   final Map<String, dynamic> potentialAction;
//   final dynamic actionTarget;
//
//   @override
//   State<AudioActionButton> createState() => _AudioActionButtonState();
// }
//
// class _AudioActionButtonState extends State<AudioActionButton> {
//   SimpleAudio? player;
//   bool currentlyPlaying = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return TextButton.icon(
//         onPressed: widget.preview ? null : () async {
//           Uri? uriToLaunch = tryCastOrParse(widget.potentialAction['url']);
//           if (uriToLaunch != null && uriToLaunch.path.endsWith('.mp3')) {
//             // todo make list of supported formats
//             if (player == null) {
//               await SimpleAudio.init();
//               player = SimpleAudio(shouldNormalizeVolume: false);
//               player!.open(uriToLaunch.toString());
//               setState(() {
//                 currentlyPlaying = true;
//               });
//             } else {
//               if (currentlyPlaying) {
//                 player!.stop();
//                 setState(() {
//                   currentlyPlaying = false;
//                 });
//               } else {
//                 player!.play();
//                 setState(() {
//                   currentlyPlaying = true;
//                 });
//               }
//             }
//           }
//           // Spotify
//           // TODO this assumes an order! replace with string prefix search
//            uriToLaunch = defaultTargetPlatform == TargetPlatform.android
//               ? tryCastOrParse(widget.actionTarget[1])
//               : tryCastOrParse(widget.actionTarget[0]['urlTemplate']);
//           if (uriToLaunch != null) {
//             launchUrl(uriToLaunch);
//           }
//         },
//         label: Text(widget.potentialAction['name']??'Listen Now'),
//         icon: currentlyPlaying ? const Icon(Icons.stop) : const Icon(Icons.music_note),
//       );
//   }
// }
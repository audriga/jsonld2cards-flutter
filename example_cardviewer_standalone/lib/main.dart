import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:developer' as developer;

import 'package:jsonld2cards/card_viewer.dart';

import 'Util/globals.dart';
import 'Util/network.dart';
import 'external_card_viewer.dart';
import 'path_card_viewer.dart';

void main() {
  final String fullURL = Uri.base.toString();
  final String? cardIdParameter = Uri.base.queryParameters['cardId'];
  runApp(MyApp(fullURL: fullURL, cardIdParameter: cardIdParameter,));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.fullURL, this.cardIdParameter});

  final String fullURL;
  final String? cardIdParameter;

  // Logo Colors
  static const _darkRed = Color(0xFFAD2300);
  static const _orange = Color(0xFFE14B00);
  static const _brightOrange = Color(0xFFFF6600);
  // static const _brightRed = Color(0xFFd50000);
  static const _darkBlue = Color(0xFF00286c);
  // static const _reddishBrown = Color(0xFF330000);

  // Additional Colors
  static const _brightOrangeAlt = Color(0xFFf39c12);

  @override
  Widget build(BuildContext context) {
    final ColorScheme audrigaSchemeLight = ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: _orange,
      primary: _orange,
      secondary: _darkRed,
    );

    final ColorScheme audrigaSchemeDark = ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: _darkBlue,
      primary: _brightOrange,
      secondary: _brightOrangeAlt,
    );

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: homePageBuilder,
        ),
        GoRoute(
          path: CardViewer.routeName,
          builder: cardViewerBuilder
        ),
        GoRoute(
          path: ExternalCardViewer.routeName,
          builder: externalViewerBuilder
        ),
        GoRoute(
          path: '/card_getter',
          builder: (context, state) {
            developer.log('stateQueryParams: ${state.uri.queryParameters.toString()} (${state.uri.queryParameters.runtimeType})',
              name: 'card_viewer_standalone.routing',
            );
            bool single = parseSingleArg(state);

            return PathCardViewer(cardPath: state.uri.queryParameters['path'], single: single, postFunction: postUrl);
            },
          routes: [
            GoRoute(
              path: ':pathSeg1',
              builder: (context, state) {
                final cardPath = state.pathParameters['pathSeg1']!;
                developer.log('cardPath: $cardPath',
                  name: 'card_viewer_standalone.routing',
                );
                return PathCardViewer(cardPath: cardPath, postFunction: postUrl);
              },
            )
          ]
        ),
      ],
    );


    return MaterialApp.router(
      title: 'Card Viewer',
      theme: ThemeData(
        fontFamily: 'Rajdhani',
        colorScheme: audrigaSchemeLight,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        fontFamily: 'Rajdhani',
        colorScheme: audrigaSchemeDark,
        useMaterial3: true,
      ),
      routerConfig: router,
      scaffoldMessengerKey: snackBarKey,
    );
  }

  Widget cardViewerBuilder(BuildContext context, GoRouterState state) {
    String? cardId;
    var modalRoute = ModalRoute.of(context);
    var modalRouteArguments = modalRoute?.settings.arguments;

    /// In case cardId is set in multiple places, set priority to
    /// Modal Route > cardIdParameter
    /// Especially since cardIdParameter can be persistent on reload with different parameters
    if (cardIdParameter != null) {
      cardId = cardIdParameter;
    }
    if (modalRoute != null) {
      if (modalRouteArguments is String) {
        cardId = modalRouteArguments;
      } else if (modalRouteArguments is Map<String, String>) {
        var modalRouteArgumentsCardId = modalRouteArguments['cardId'];
        if (modalRouteArgumentsCardId is String) {
          cardId = modalRouteArgumentsCardId;
        }
      }
    }
    developer.log(
      'modalRouteArguments: ${modalRouteArguments.toString()} (${modalRouteArguments.runtimeType})',
      name: 'card_viewer_standalone.routing',
    );
    developer.log(
      'stateQueryParams: ${state.uri.queryParameters.toString()} (${state.uri.queryParameters.runtimeType})',
      name: 'card_viewer_standalone.routing',
    );
    developer.log(
      'cardIdParameter: ${cardIdParameter.toString()} (${cardIdParameter.runtimeType})',
      name: 'card_viewer_standalone.routing',
    );
    developer.log(
      'cardId: ${cardId.toString()}',
      name: 'card_viewer_standalone.routing',
    );
    return CardViewer(cardId: cardId, postFunction: postUrl);
  }

  Widget homePageBuilder (BuildContext context, GoRouterState state) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Card Viewer')),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Welcome to the Card Viewer', style: theme.textTheme.titleMedium,),
              Text('You can use this to display SML cards someone sent you in your browser!', style: theme.textTheme.bodyMedium,),
              TextButton(
                onPressed: () {context.go(Uri(path: CardViewer.routeName, queryParameters: {'cardId': '647a21b24a917'}).toString());},
                child: const Text('Try it out. Click here to go to a LiveLocation Card!'),),
            ],
          )
      ),
    );
  }


  Widget externalViewerBuilder(BuildContext context, GoRouterState state) {
    developer.log('stateQueryParams: ${state.uri.queryParameters.toString()} (${state.uri.queryParameters.runtimeType})',
      name: 'card_viewer_standalone.routing',
    );
    bool single = parseSingleArg(state);
    bool visualDebug = parseVisualDebugArg(state);

    return ExternalCardViewer(source: state.uri.queryParameters['source'], single: single, postFunction: postUrl, visualDebug: visualDebug);
  }

  /// Gets the value of the boolean query parameter 'single'
  bool parseSingleArg(GoRouterState state) {
    var singleArg = state.uri.queryParameters['single'];
    bool single = false;
    if (singleArg != null) {
      single = bool.tryParse(singleArg) ?? false;
    }
    return single;
  }

  /// Gets the value of the boolean query parameter 'visual_debug'
  bool parseVisualDebugArg(GoRouterState state) {
    var singleArg = state.uri.queryParameters['visual_debug'];
    bool single = false;
    if (singleArg != null) {
      single = bool.tryParse(singleArg) ?? false;
    }
    return single;
  }
}

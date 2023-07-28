import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:developer' as developer;

import 'package:jsonld2cards/card_viewer.dart';

import 'Util/globals.dart';
import 'Util/network.dart';

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
          redirect: (context, state) => CardViewer.routeName,
        ),
        GoRoute(
          path: CardViewer.routeName,
          builder: cardViewerBuilder
        ),
        GoRoute(
          path: '/card_getter/:cardPath',
          builder: (context, state) {
              final cardPath = state.pathParameters['cardPath']!;
              developer.log('cardPath: $cardPath}',
                name: 'card_viewer_standalone.routing',
              );
              return CardViewer(cardPath: cardPath, postFunction: postUrl);
            },
        ),
      ],
      errorBuilder: (context, state) {
        final Uri cardPath = state.uri;
        developer.log('cardPath: ${cardPath}',
          name: 'card_viewer_standalone.error_routing',
        );
          var segments = cardPath.pathSegments;
          if (segments[0] == 'card_getter') {
            segments.toList().removeAt(0);
            return CardViewer(cardPath: segments.join('/'), postFunction: postUrl);
          }
        // context.go('/');
        return cardViewerBuilder(context, state);
      },
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
          developer.log('modalRouteArguments: ${modalRouteArguments.toString()} (${modalRouteArguments.runtimeType})',
            name: 'card_viewer_standalone.routing',
          );
          developer.log('stateQueryParams: ${state.uri.queryParameters.toString()} (${state.uri.queryParameters.runtimeType})',
            name: 'card_viewer_standalone.routing',
          );
          developer.log('cardIdParameter: ${cardIdParameter.toString()} (${cardIdParameter.runtimeType})',
            name: 'card_viewer_standalone.routing',
          );
          developer.log('cardId: ${cardId.toString()}',
            name: 'card_viewer_standalone.routing',
          );
          return CardViewer(cardId: cardId, postFunction: postUrl);
        }
}

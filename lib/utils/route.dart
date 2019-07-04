import 'package:fluro/fluro.dart';
import 'dart:convert';

import 'package:ai_video/home.dart';

class Routes {
  static Router router;
  static String home = '/';

  static void configureRoutes(Router router) {
    router.define(
        home,
        handler: Handler(handlerFunc: (context, params) => MyHomePage()),
        transitionType: TransitionType.inFromRight
    );
  }
}
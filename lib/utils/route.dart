import 'package:fluro/fluro.dart';
import 'dart:convert';

import 'package:ai_video/home.dart';
import 'package:ai_video/pages/video_info.dart';
import 'package:ai_video/pages/sources.dart';

import 'package:ai_video/pages/error.dart';

class Routes {
  static Router router;
  static String home = '/';
  static String videoInfo = '/video/info/:data';
  static String source = '/source';

  static String error = '/error';

  static void configureRoutes(Router router) {
    router.define(
        home,
        handler: Handler(handlerFunc: (context, params) => MyHomePage()),
        transitionType: TransitionType.inFromRight
    );
    router.define(
        videoInfo,
        handler: Handler(handlerFunc: (context, params) {
          Map<String, dynamic> map = json.decode(params['data'][0]);
          return VideoInfoPage(id: map['id'], sourceName: map['sourceName'], sourceUrl: Uri.decodeComponent(map['sourceUrl']),);
        }),
        transitionType: TransitionType.inFromRight
    );

    router.define(source,
        handler: Handler(handlerFunc: (context, params) => SourcesPage()),
        transitionType: TransitionType.inFromRight
    );

    router.define(error,
        handler: Handler(handlerFunc: (context, params) => ErrorPage()),
        transitionType: TransitionType.inFromRight
    );

    Routes.router = router;
  }
}
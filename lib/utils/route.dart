import 'package:fluro/fluro.dart';
import 'dart:convert';

import 'package:ai_video/home.dart';
import 'package:ai_video/pages/video_info.dart';

class Routes {
  static Router router;
  static String home = '/';
  static String videoInfo = '/video/info/:data';

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

    Routes.router = router;
  }
}
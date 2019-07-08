import 'package:fluro/fluro.dart';
import 'dart:convert';

import 'package:ai_video/home.dart';
import 'package:ai_video/pages/video_info.dart';

class Routes {
  static Router router;
  static String home = '/';
  static String videoInfo = '/video/info';

  static void configureRoutes(Router router) {
    router.define(
        home,
        handler: Handler(handlerFunc: (context, params) => MyHomePage()),
        transitionType: TransitionType.inFromRight
    );
    router.define(
        videoInfo,
        handler: Handler(handlerFunc: (context, params) {
          print(params);
          print("xxxxxxxxxxxxxxx");
//          Map<String, dynamic> map = json.decode(params['data'][0]);
//          return VideoInfoPage(id: map['id'], sourceName: map['sourceName'], sourceUrl: map['sourceUrl'],);
          return VideoInfoPage(id: "92372", sourceUrl: "https://www.qtmovie.com", sourceName: "晴天影视",);
        }),
        transitionType: TransitionType.inFromRight
    );

    Routes.router = router;
  }
}
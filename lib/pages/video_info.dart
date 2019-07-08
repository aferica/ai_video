import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:ai_video/components/Loading.dart';
import 'package:ai_video/components/VideoPlayer.dart';

import 'package:ai_video/utils/request.dart';
import 'package:ai_video/utils/shared_pres.dart';

class VideoInfoPage extends StatefulWidget {
  final String id;
  final String sourceName;
  final String sourceUrl;
  const VideoInfoPage({Key key, this.id, this.sourceName, this.sourceUrl}):super(key: key);

  @override
  State<StatefulWidget> createState() => VideoInfoState(id: this.id, sourceName: this.sourceName, sourceUrl: this.sourceUrl);
}

class VideoInfoState extends State<VideoInfoPage> {
  String id;
  String sourceName;
  String sourceUrl;

  Map<String, dynamic> videoInfo;
  var sourceInfo;

  VideoInfoState({Key key, this.id, this.sourceName, this.sourceUrl});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVideoInfo();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (videoInfo == null) {
      return Scaffold(
        body: Center(
          child: Loading(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(videoInfo['vod_name']),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.height),
          child: Column(
            children: <Widget>[
//              VideoPlayer(videoSrc: 'https://letv.com-t-letv.com/20190506/723_5da10c44/index.m3u8'),
            ],
          ),
        ),
      ),
    );
  }

  getVideoInfo() async {
    String vdBaseUrl = await SharedPres.get('videoDetailBaseUrl') ?? '/api.php/provide/vod/?ac=detail';
    String url = sourceUrl + vdBaseUrl + '&ids=' + id;
    print(url);
    String videoInfoStr = await Request.get(url, context);
    Map<String, dynamic> videoInfoMap = json.decode(videoInfoStr);
    Map<String, dynamic> tempVideoInfo = videoInfoMap['list'][0];
    String videoPlayUrlStr = tempVideoInfo['vod_play_url'];
//    videoInfoMap['vod_play_url'];
    var videoPlayUrlMain = videoPlayUrlStr.split('\$\$\$');
    videoPlayUrlMain.forEach((main) {
      print(main);
    });
    setState(() {
      videoInfo = tempVideoInfo;
    });
  }
}
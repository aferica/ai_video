import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

import 'package:ai_video/components/Loading.dart';
//import 'package:ai_video/components/VideoPlayer.dart';

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
  IjkMediaController controller = IjkMediaController();

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
    // 销毁视频controller，避免后台继续播放
    controller.dispose();
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
    controller.setNetworkDataSource(
      'https://letv.com-t-letv.com/share/39e4973ba3321b80f37d9b55f63ed8b8',
      autoPlay: true
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(videoInfo['vod_name']),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.height),
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.width / 16 * 9,
                child: IjkPlayer(mediaController: controller),
              ),
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
    List<dynamic> videoPlayUrls = [];
    videoPlayUrlMain.forEach((main) {
      var videoPlayUrlList = main.split('#');
      var videoPlayMapList = [];
      videoPlayUrlList.forEach((list) {
        Map<String, String> videoPlayUrl = new Map();
        videoPlayUrl['name'] = list.split('\$')[0].toString();
        videoPlayUrl['url'] = list.split('\$')[1].toString();
        videoPlayMapList.add(videoPlayUrl);
      });
      videoPlayUrls.add(videoPlayMapList);
    });
    print(videoPlayUrls);
    setState(() {
      videoInfo = tempVideoInfo;
    });
  }
}
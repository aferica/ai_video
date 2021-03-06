import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

import 'package:aferica_flutter_components/aferica_flutter_components.dart';

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
  var videoPlayUrl;
  List<String> videoServes;
  int selectPlayFrom = 0;
  String selectPlayUrl = '';
  bool hasError = false;

  IjkMediaController controller = IjkMediaController();

  VideoInfoState({Key key, this.id, this.sourceName, this.sourceUrl});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      getVideoInfo();
    });
    controller.setIjkPlayerOptions([TargetPlatform.android], createIJKOptions());
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
    if (hasError) {
      return Scaffold(
        appBar: AppBar(
          title: Text('影片信息'),
        ),
        body: Center(
          child: ExceptionMessage(
            type: 'net',
          ),
        ),
      );
    }

    if (videoInfo == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('影片信息'),
        ),
        body: Center(
          child: Loading(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(videoInfo['vod_name']),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0.0,
              right: 0.0,
              height: MediaQuery.of(context).size.width / 16 * 9,
              child: Container(
                height: MediaQuery.of(context).size.width / 16 * 9,
                child: IjkPlayer(mediaController: controller),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.width / 16 * 9 + 10,
              bottom: 0,
              left: 0.0,
              right: 0.0,
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.height - MediaQuery.of(context).size.width / 16 * 9 - 10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              height: MediaQuery.of(context).size.width * 0.25 * 1.33,
                              margin: EdgeInsets.all(10.0),
                              child: MyNetWorkImage(src: videoInfo['vod_pic']),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.75 - 100,
                              height: MediaQuery.of(context).size.width * 0.25 * 1.33,
                              margin: EdgeInsets.all(0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(videoInfo['vod_name'], textAlign: TextAlign.left, style: TextStyle(fontSize: 20.0, height: 1.2), maxLines: 1,),
                                  Row(
                                    children: <Widget>[
                                      Icon(IconData(0xe7a0, fontFamily: 'aliIconFont'), size: 16.0, color: Colors.black54,),
                                      Text('  ' + videoInfo['vod_hits'].toString() + '次' + '    ', style: TextStyle(fontSize: 12.0, height: 1.3, color: Colors.black54,),),
                                      Icon(IconData(0xe71a, fontFamily: 'aliIconFont'), size: 16.0, color: Colors.black54,),
                                      Text('  ' + videoInfo['vod_down'].toString() + '次', style: TextStyle(fontSize: 12.0, height: 1.3, color: Colors.black54,),)
                                    ],
                                  ),
                                  Text('更新日期：' + videoInfo['vodvod_time_up'], style: TextStyle(fontSize: 12.0, color: Colors.black54, height: 1.5), maxLines: 1,),
                                  Text(videoInfo['vod_content'], style: TextStyle(fontSize: 12.0, color: Colors.black54,), maxLines: 2,)
                                ],
                              ),
                            ),
                            Container(
                              width: 60,
                              height: MediaQuery.of(context).size.width * 0.25 * 1.33,
                              margin: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  ButtonTag(
                                      text: '追剧',
                                      size: 'small',
                                      type: 'error',
                                      radius: 4.0
                                  ),
//                          Container(
//                            height: 30,
//                            width: 60,
//                            decoration: BoxDecoration(
//                              color: Colors.deepOrange,
//                              borderRadius: BorderRadius.all(Radius.circular(3.0))
//                            ),
//                            child: Center(child: Row(
//                              children: <Widget>[
//                                Icon(IconData(0xe71a, fontFamily: 'aliIconFont'), size: 16.0, color: Colors.white,),
//                                Text('追剧', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.white),),
//                                IconButton
//                              ]
//                            ),),
//                          ),
                                  BlankRow(color: Theme.of(context).canvasColor, height: 35.0,),
                                  Text(videoInfo['vod_score'], textAlign: TextAlign.center, style: TextStyle(fontSize: 28.0, color: Colors.redAccent),),
                                  Text(videoInfo['vod_score_num'].toString() + '人', style: TextStyle(fontSize: 12.0, color: Colors.black54,), maxLines: 1,),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      BlankRow(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 6.0, bottom: 6.0),
                            child: Text('选择来源', style: TextStyle(fontSize: 14.0, color: Colors.black54),),
                          ),
                          Divider(height: 1.0,),
                          Container(
                            padding: EdgeInsets.all(5.0),
                            height: 60.0,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                primary: false,
                                //确定每一个item的宽度 会让item加载更加高效
                                itemExtent: 80,
                                //内容适配
                                shrinkWrap: true,
                                //item 数量
                                itemCount: videoInfo['vod_play_from'].length,
                                itemBuilder: (BuildContext _content,int i){
                                  if(i < videoInfo['vod_play_from'].length) {
                                    return Center(
                                      child: ButtonTag(
                                        size: 'small',
                                        type: selectPlayFrom == i ? 'error' : 'default',
                                        hairline: true,
                                        text: '来源' +  i.toString(),
                                        onClick: () {
                                          setState(() {
                                            selectPlayFrom = i;
                                          });
                                        },
                                      ),
                                    );
                                  }
                                }
                            ),
                          )
                        ],
                      ),
                      BlankRow(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 6.0, bottom: 6.0),
                            child: Text('来源' + selectPlayFrom.toString(), style: TextStyle(fontSize: 14.0, color: Colors.black54),),
                          ),
                          Divider(height: 1.0,),
                          Container(
                            padding: EdgeInsets.all(5.0),
                            height: (videoInfo['vod_play_url'][selectPlayFrom].length / 4 + 1) * ((MediaQuery.of(context).size.width - 30) / 8 + 4),
                            width: MediaQuery.of(context).size.width,
                            child: GridView.count(
                              physics: NeverScrollableScrollPhysics(),
                              primary: false,
                              crossAxisCount: 4,
                              mainAxisSpacing: 6.0,
                              crossAxisSpacing: 6.0,
                              childAspectRatio: 2.0,
                              padding: const EdgeInsets.all(4.0),
                              children: videoInfo['vod_play_url'][selectPlayFrom].map<Widget>((urlItem) {
                                return Container(
                                  child: ButtonTag(
                                    size: 'small',
                                    type: selectPlayUrl == urlItem['url'] ? 'error' : 'default',
                                    hairline: true,
                                    text: urlItem['name'].toString(),
                                    onClick: () async {
                                      String playUrl = urlItem['url'];
                                      if (playUrl.indexOf('.m3u8') < 0) {
                                        playUrl = 'http://api.keletj.com/?url=' + playUrl;
                                      }
                                      setState(() {
                                        selectPlayUrl = playUrl;
                                      });
                                      await controller.reset();
                                      controller.setNetworkDataSource(
                                          playUrl,
                                          autoPlay: false
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  getVideoInfo() async {
    String url = 'https://common.aferica.site/common/video/mac/detail?baseUrl=' + Uri.encodeComponent(sourceUrl) + '&id=' + id;
    print(url);
    Map<String, dynamic> videoInfoMap = await Request.get(url, context);
    print(videoInfoMap);
    if (videoInfoMap == null || videoInfoMap == {} || videoInfoMap['data'] == null) {
      setState(() {
        hasError = true;
      });
      return;
    }
    videoInfoMap['data']['vod_content'] = videoInfoMap['data']['vod_content'].replaceAll(new RegExp(r' '), '').replaceAll(new RegExp(r'\u3000'), '');
    String playUrl = videoInfoMap['data']['vod_play_url'][0][0]['url'];
    if (playUrl.indexOf('.m3u8') < 0) {
      playUrl = 'http://api.keletj.com/?url=' + playUrl;
    }
    videoInfoMap['data']['last_time'] = new DateTime.now().millisecondsSinceEpoch;
    List<String> history = await SharedPres.getList('historyList') ?? [];
    print(history);
    history.add(jsonEncode(videoInfoMap['data']));
    // 去重
    history.toSet().toList();
    await SharedPres.setList('historyList', history);
    setState(() {
      videoInfo = videoInfoMap['data'];
      selectPlayUrl = playUrl;
    });

    await controller.setNetworkDataSource(
      selectPlayUrl,
      autoPlay: true
    );
  }
}

Set<IjkOption> createIJKOptions() {
  return <IjkOption>[
    IjkOption(IjkOptionCategory.player, "mediacodec", 0),
    IjkOption(IjkOptionCategory.player, "opensles", 0),
    IjkOption(IjkOptionCategory.player, "overlay-format", 0x32335652),
    IjkOption(IjkOptionCategory.player, "framedrop", 1),
    IjkOption(IjkOptionCategory.player, "start-on-prepared", 0),
    IjkOption(IjkOptionCategory.format, "http-detect-range-support", 0),
    IjkOption(IjkOptionCategory.codec, "skip_loop_filter", 48),
    IjkOption(IjkOptionCategory.format, "dns_cache_clear", 1),
  ].toSet();
}
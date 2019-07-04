import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:flutter/services.dart';

import 'package:ai_video/components/Loading.dart';

import 'package:ai_video/utils/request.dart';


class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  IjkMediaController controller = IjkMediaController();

  ChewieController chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    getHomePageData();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text('主页'),
        ),
        drawer: Drawer(

        ),
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.width / 16 * 9,
            child: IjkPlayer(mediaController: controller),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.play_arrow),
          onPressed: () async {
            await controller.setNetworkDataSource(
                'http://app.baiduoos.cn:2019/vip/cache/youkuNO/020b833ee405652c2de876f8d3f62286.m3u8?token=346442dcf25f266b3fb9674bc9bb39d5',
                autoPlay: true);
            print("set data source success");
            // controller.playOrPause();
          },
        ),
      ),
      onWillPop: _onPressBack,
    );
  }

  Future<bool> _onPressBack() {
    showDialog<Null>(
      context: context,
      builder: (_) => new AlertDialog(
          content: new Text('退出app'),
          actions: <Widget>[
            FlatButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
                return new Future.value(false);
              }
            ),
            FlatButton(
              onPressed: () {
                SystemNavigator.pop();
//                return new Future.value(true);
              },
              child: new Text('确定'),
            ),
          ]
      ),
    );
  }

  getHomePageData() {
    Request.get('https://google.com').then((res) {
      print('yyyyyyyyyyyyy');
    });
  }
}
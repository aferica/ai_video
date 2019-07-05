import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:ai_video/components/Loading.dart';
import 'package:ai_video/components/GiggyDialog.dart';

import 'package:ai_video/utils/request.dart';
import 'package:ai_video/utils/shared_pres.dart';


class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List leftDrawerMenuVideo = [
    {'name': '视频源列表', 'value': 'VideoSource', 'path': 'VideoSource', 'icon': 0xe781},
    {'name': '当前视频源', 'value': 'VideoSource', 'path': 'VideoSource', 'icon': 0xe780}
  ];

  List leftDrawerMenuMain = [
    {'name': '搜索影片', 'value': 'VideoSource', 'path': 'VideoSource', 'icon': 0xe73b},
    {'name': '历史记录', 'value': 'VideoSource', 'path': 'VideoSource', 'icon': 0xe73a},
    {'name': '我的收藏', 'value': 'Setting', 'path': 'Setting', 'icon': 0xe7e2},
    {'name': '我的追更', 'value': 'Setting', 'path': 'Setting', 'icon': 0xe7e1},
    {'name': '我的下载', 'value': 'Setting', 'path': 'Setting', 'icon': 0xe71a},
  ];

  List leftDrawerMenuSetting = [
    {'name': '设置', 'value': 'Setting', 'path': 'Setting', 'icon': 0xe74d},
    {'name': '关于', 'value': 'About', 'path': 'About', 'icon': 0xe772},
    {'name': '打赏', 'value': 'Reward', 'path': 'Reward', 'icon': 0xe75b},
  ];

  var currentSource;
  String currentSourceTitle = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHomePageData();
  }

//  @override
//  void didChangeDependencies() {
//    // TODO: implement didChangeDependencies
//    super.didChangeDependencies();
//    showLoadingDialog();
//  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(currentSourceTitle),
        ),
        drawer: Drawer(
          child: SingleChildScrollView(
            child: new ConstrainedBox(
              constraints: new BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 160,
                    child: Center(
                      child: Text('爱看影视'),
                    ),
                  ),
                  Divider(height: 1.0),
                  Container(
                    height: leftDrawerMenuVideo.length * 60.0,
                    child: ListView.builder(
                      primary: false,
                      padding: EdgeInsets.all(0.0),
                      itemBuilder: (BuildContext context, int index) {
                        final Map item = leftDrawerMenuVideo[index];
                        return ListTile(
                          leading: Icon(IconData(item['icon'], fontFamily: 'aliIconFont'), size: 24.0,),
                          isThreeLine: false,
                          title: Text(item['name']),
                          contentPadding: EdgeInsets.only(left: 15.0,),
                        );
                      },
                      itemCount: leftDrawerMenuVideo.length
                    )
                  ),
                  Divider(height: 1.0),
                  Container(
                    height: leftDrawerMenuMain.length * 60.0,
                    child: ListView.builder(
                      primary: false,
                      padding: EdgeInsets.all(0.0),
                      itemBuilder: (BuildContext context, int index) {
                        final Map item = leftDrawerMenuMain[index];
                        return ListTile(
                          leading: Icon(IconData(item['icon'], fontFamily: 'aliIconFont'), size: 24.0,),
                          isThreeLine: false,
                          title: Text(item['name']),
                          contentPadding: EdgeInsets.only(left: 15.0,),
                        );
                      },
                      itemCount: leftDrawerMenuMain.length
                    )
                  ),
                  Divider(height: 1.0),
                  Container(
                    height: leftDrawerMenuSetting.length * 60.0,
                    child: ListView.builder(
                      primary: false,
                      padding: EdgeInsets.all(0.0),
                      itemBuilder: (BuildContext context, int index) {
                        final Map item = leftDrawerMenuSetting[index];
                        return ListTile(
                          leading: Icon(IconData(item['icon'], fontFamily: 'aliIconFont'), size: 24.0,),
                          isThreeLine: false,
                          title: Text(item['name']),
                          contentPadding: EdgeInsets.only(left: 15.0,),
                        );
                      },
                      itemCount: leftDrawerMenuSetting.length
                    )
                  )
                ],
              ),
            ),
          ),
        ),
        body: Center(
          child: Loading(),
        ),
      ),
      onWillPop: _onPressBack,
    );
  }

  Future<bool> _onPressBack() {
    showDialog<Null>(
      context: context,
      builder: (_) => CloseAppDialog(
        onConfirm: () {
          SystemNavigator.pop();
        },
      )
    );
  }

  Future<bool> showLoadingDialog () {
    showDialog<Null>(
      context: context,
      builder: (_) => LoadingDialog()
    );
  }

  getHomePageData() async {
    Map<String, dynamic> csInfoMap;
    String csInfo = await SharedPres.get('currectSourceInfo') ?? '';
    String csList = await SharedPres.get('currectSourceList') ?? '';
    if (csList == '') {
      csList = await Request.get('https://moonbegonia.github.io/Source/fangyuan/fullScore.json', context, closeLoading: false);
      await SharedPres.set('currectSourceList', csList);
    }
    if (csInfo == '') {
      List<dynamic> csListMap = json.decode(csList);
      csInfoMap = csListMap[0];
      csInfo = csListMap[0].toString();
      await SharedPres.set('currectSourceInfo', csInfo);
      await SharedPres.setInt('currentSourceId', csInfoMap['id']);
    } else {
      csInfoMap = json.decode(csInfo);
    }
//    int csId = await SharedPres.getInt('currentSourceId') ?? 0;
    setState(() {
      currentSource = csInfoMap;
      currentSourceTitle = csInfoMap['title'];
    });
//    Request.get(result['baseUrl'], ).then((res) {
//      print('yyyyyyyyyyyyy');
//    });
    await Request.get(csInfoMap['baseUrl'], context, showLoading: false, css: csInfoMap['chapterFind']);

  }

}
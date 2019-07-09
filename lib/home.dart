import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:ai_video/components/Loading.dart';
import 'package:ai_video/components/Dialog.dart';

import 'package:ai_video/utils/request.dart';
import 'utils/route.dart';
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
  var homeData;

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
        body: _buildBody(context),
      ),
      onWillPop: _onPressBack,
    );
  }

  Widget _buildBody(BuildContext context) {
    if(homeData == null) {
      return Center(child: Loading(),);
    }

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.height),
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 0.575,
              child: Swiper(
                autoplay: false,
                itemCount: homeData['swiper'].length,
                itemBuilder: (BuildContext context,int index) {
                  return Image(image: new CachedNetworkImageProvider(homeData['swiper'][index]['vod_pic_slide']), fit: BoxFit.fitHeight,);
                },
                pagination: new SwiperPagination(
                  builder: DotSwiperPaginationBuilder(
                    color: Colors.black54,
                    activeColor: Colors.white,
                  )
                ),
                onTap: (index) {
                  print(Uri.encodeComponent(currentSource['baseUrl']));
                  String bodyJson = '{"id":"${homeData['swiper'][index]['vod_id']}","sourceUrl":"${Uri.encodeComponent(currentSource['baseUrl'])}","sourceName":"${currentSource['title']}"}';
                  Routes.router.navigateTo(context, '/video/info/' + bodyJson);
                },
              ),
            )
          ],
        ),
      ),
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
    String vaInfo = await SharedPres.get('videoApiInfo') ?? '';
    if (vaInfo == '') {
      vaInfo = await Request.get('https://common.aferica.site/common/video/index', context, closeLoading: false);
      Map<String, dynamic> tempVaInfoMap = json.decode(vaInfo);
      vaInfo = json.encode(tempVaInfoMap['data']);
      await SharedPres.set('videoApiInfo', vaInfo);
    }
    Map<String, dynamic> vaInfoMap = json.decode(vaInfo);

    String vdBaseUrl = vaInfoMap['detail']['mainUrl'];
    await SharedPres.set('videoDetailBaseUrl', vdBaseUrl);
    if (csInfo == '') {
      csInfoMap = vaInfoMap['source'][0];
      csInfo = csInfoMap.toString();
      await SharedPres.set('currectSourceInfo', csInfo);
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
    String url = 'https://common.aferica.site/common/video/mac/home?baseUrl=' + Uri.encodeComponent(csInfoMap['baseUrl']);
    String homeDataStr = await Request.get(url, context, showLoading: false);
//    await Request.get(csInfoMap['baseUrl'] + vaInfoMap['list']['mainUrl'], context, showLoading: false);
    setState(() {
      homeData = json.decode(homeDataStr)['data'];
    });

  }

}
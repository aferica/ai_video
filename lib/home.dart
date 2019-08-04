import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:aferica_flutter_components/aferica_flutter_components.dart';

import 'package:ai_video/utils/request.dart';
import 'utils/route.dart';
import 'package:ai_video/utils/shared_pres.dart';


class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List leftDrawerMenuVideo = [
    {'name': '视频源列表', 'value': 'VideoSource', 'path': '/source', 'icon': 0xe781},
    {'name': '', 'value': 'VideoSource', 'path': 'VideoSource', 'icon': 0xe780}
  ];

  List leftDrawerMenuMain = [
    {'name': '搜索影片', 'value': 'VideoSource', 'path': 'VideoSource', 'icon': 0xe73b},
    {'name': '历史记录', 'value': 'VideoSource', 'path': '/history', 'icon': 0xe73a},
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
  bool hasError = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    getHomePageData();
    WidgetsBinding.instance.addPostFrameCallback((_){
      getHomePageData();
    });
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
    leftDrawerMenuVideo[1]['name'] = '当前视频源（' + currentSourceTitle + '）';
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
                          onTap: () {
                            Navigator.of(context).pop();
                            Routes.router.navigateTo(context, item['path']);
                          },
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
                          onTap: () {
                            Navigator.of(context).pop();
                            Routes.router.navigateTo(context, item['path']);
                          },
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
                          onTap: () {
                            Navigator.of(context).pop();
                            Routes.router.navigateTo(context, item['path']);
                          },
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
    if (hasError) {
      return Center(
        child: ExceptionMessage(
          type: 'net',
        ),
      );
    }

    if(homeData == null) {
      return Center(child: Loading(),);
    }

    return Container(
      color: Theme.of(context).canvasColor,
      child: SingleChildScrollView(
        child: new ConstrainedBox(
          constraints: new BoxConstraints(
            minHeight: 120.0,
          ),
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.575,
                child: Swiper(
                  autoplay: false,
                  itemCount: homeData['swiper'].length,
                  itemBuilder: (BuildContext context,int index) {
                    return MyNetWorkImage(src: homeData['swiper'][index]['vod_pic_slide']);
//                    return Image(
//                      image: CachedNetworkImageProvider(homeData['swiper'][index]['vod_pic_slide']),
//                      fit: BoxFit.fitHeight,
//                      width: MediaQuery.of(context).size.width,
//                    );
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
              ),
              BlankRow(),
              MoreInfoContainer(
                title: '院线热映',
                needMore: true,
                child: Container(
                  height: 200,
                  child: Center(
                    child: _buildVideoItem(context, homeData['hot']),
                  ),
                ),
              ),
              BlankRow(),
              MoreInfoContainer(
                title: '最新',
                needMore: true,
                child: Container(
                  height: 200,
                  child: Center(
                    child: _buildVideoItem(context, homeData['new']),
                  ),
                ),
              ),
              BlankRow(),
              MoreInfoContainer(
                title: '电影',
                needMore: true,
                child: Container(
                  height: 200,
                  child: Center(
                    child: _buildVideoItem(context, homeData['dianying']),
                  ),
                ),
              ),
              BlankRow(),
              MoreInfoContainer(
                title: '电视剧',
                needMore: true,
                child: Container(
                  height: 200,
                  child: Center(
                    child: _buildVideoItem(context, homeData['dianshiju']),
                  ),
                ),
              ),
              BlankRow(),
              MoreInfoContainer(
                title: '综艺',
                needMore: true,
                child: Container(
                  height: 200,
                  child: Center(
                    child: _buildVideoItem(context, homeData['zongyi']),
                  ),
                ),
              ),
              BlankRow(),
              MoreInfoContainer(
                title: '动漫',
                needMore: true,
                child: Container(
                  height: 200,
                  child: Center(
                    child: _buildVideoItem(context, homeData['dongman']),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoItem(BuildContext context, var data) {
    return Container(
      child: new ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(0.0),
        primary: false,
        //确定每一个item的高度 会让item加载更加高效
        itemExtent: MediaQuery.of(context).size.width / 3,
        //内容适配
        shrinkWrap: true,
        //item 数量
        itemCount: data.length,
        itemBuilder: (BuildContext _content,int i) {
          if(i < data.length) {
            return new GestureDetector(
              onTap: () {
                String bodyJson = '{"id":"${data[i]['id']}","sourceUrl":"${Uri.encodeComponent(currentSource['baseUrl'])}","sourceName":"${currentSource['title']}"}';
                Routes.router.navigateTo(context, '/video/info/' + bodyJson);
              },
              child: Container(
                width: 100,
                height: 250,
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: new Column(
                  children: <Widget>[
                    new Align(
                      child: MyNetWorkImage(
                        width: 100,
                        height: 150,
                        fit: BoxFit.cover,
                        src: data[i]['vod_pic']
                      ),
                    ),
                    new Text(data[i]['vod_name'],
                      style: new TextStyle(fontSize: 14, height: 1.5),
                      maxLines: 1,)
                  ],
                ),
              ),
            );
          };
        }
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
    showDialog<Null>(
      context: context,
      builder: (_) => LoadingDialog()
    );
    Map<String, dynamic> csInfoMap;
    String csInfo = await SharedPres.get('currectSourceInfo') ?? '';
    String vaInfo = await SharedPres.get('videoApiInfo') ?? '';
    print(await SharedPres.get('videoApiInfo'));
    if (vaInfo == '') {
      Map<String, dynamic> tempVaInfoMap = await Request.get('https://common.aferica.site/common/video/index', context, showLoading: false, closeLoading: false);
      vaInfo = json.encode(tempVaInfoMap['data']);
      await SharedPres.set('videoApiInfo', vaInfo);
    }
    Map<String, dynamic> vaInfoMap = json.decode(vaInfo);

    String vdBaseUrl = vaInfoMap['detail']['mainUrl'];
    await SharedPres.set('videoDetailBaseUrl', vdBaseUrl);
    if (csInfo == '') {
      csInfoMap = vaInfoMap['source'][0];
      csInfo =json.encode(csInfoMap);
      await SharedPres.set('currectSourceInfo', csInfo);
      await SharedPres.setInt('currentSourceId', 0);
    } else {
      csInfoMap = json.decode(csInfo);
    }
//    int csId = await SharedPres.getInt('currentSourceId') ?? 0;
    setState(() {
      currentSource = csInfoMap;
      currentSourceTitle = csInfoMap['title'];
    });
    String url = 'https://common.aferica.site/common/video/mac/home?baseUrl=' + Uri.encodeComponent(csInfoMap['baseUrl']);
    Map<String, dynamic> homeDataMap = await Request.get(url, context, showLoading: false, closeLoading: true);
    if (homeDataMap == null && homeDataMap == {}) {
      return;
    }
//    await Request.get(csInfoMap['baseUrl'] + vaInfoMap['list']['mainUrl'], context, showLoading: false);
    homeDataMap['data']['swiper'] = homeDataMap['data']['swiper'].take(5).toList();
//    print(homeDataMap['data']['swiper'].length);
    setState(() {
      homeData = homeDataMap['data'];
      hasError = false;
    });

  }

}
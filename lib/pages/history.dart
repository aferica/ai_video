import 'dart:convert';
import 'package:ai_video/utils/shared_pres.dart';
import 'package:ai_video/utils/route.dart';
import 'package:flutter/material.dart';

import 'package:aferica_flutter_components/aferica_flutter_components.dart';

class HistoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HistoryPageState();
  }
}

class HistoryPageState extends State<HistoryPage> {

  var currentSource;
  List history;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHistory();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('历史记录'),
      ),
      body: _buildBody()
    );
  }

  Widget _buildBody() {
    if (history == null) {
      return Center(
        child: Loading(),
      );
    }
    if (history.length == 0) {
      return Center(
        child: ExceptionMessage(
          type: 'find',
          msg: '暂无历史记录',
        ),
      );
    }

    return SingleChildScrollView(
      child: new ConstrainedBox(
        constraints: new BoxConstraints(
          minHeight: 200,
        ),
        child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          padding: EdgeInsets.all(0.0),
          itemCount: history.length,
          itemBuilder: (BuildContext context, int index) {
            var info = json.decode(history[index]);
            print(info);
            return ListTile(
              onTap: () {
                String bodyJson = '{"id":"${info['vod_id']}","sourceUrl":"${Uri.encodeComponent(currentSource['baseUrl'])}","sourceName":"${currentSource['title']}"}';
                Routes.router.navigateTo(context, '/video/info/' + bodyJson);
              },
              isThreeLine: true,
              leading: MyNetWorkImage(
                src: info['vod_pic'],
                height: 60.0,
                width: 40.0,
              ),
//              isThreeLine: false,
              title: Text(info['vod_name'] ?? ''),
              subtitle: Text(info['vod_actor'], maxLines: 1,),
//              contentPadding: EdgeInsets.only(left: 15.0,),
            );
          },
        ),
      ),
    );
  }

  getHistory() async {
    List historyList = await SharedPres.getList('historyList');
    String csInfo = await SharedPres.get('currectSourceInfo') ?? '';
    Map<String, dynamic> csInfoMap = json.decode(csInfo);
    setState(() {
      history = historyList;
      currentSource = csInfoMap;
    });
  }
}
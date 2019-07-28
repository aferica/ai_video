import 'dart:convert';
import 'package:aferica_flutter_components/aferica_flutter_components.dart';
import 'package:flutter/material.dart';

import 'package:ai_video/utils/shared_pres.dart';

class SourcesPage extends StatefulWidget {

  @override
  SourcesPageState createState() => SourcesPageState();
}

class SourcesPageState extends State<SourcesPage> {

  List sourcesList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSourcesListByStorage();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('视频源列表'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if(sourcesList == null) {
      return Center(
        child: Loading(),
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
          itemCount: sourcesList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
//              leading: Icon(IconData(sourcesList['source'][index]['icon'], fontFamily: 'aliIconFont'), size: 24.0,),
//              isThreeLine: false,
              title: Text(sourcesList[index]['title']),
//              contentPadding: EdgeInsets.only(left: 15.0,),
            );
          },
        ),
      ),
    );
  }

  getSourcesListByStorage() async {

    String csInfo = await SharedPres.get('currectSourceInfo') ?? '';
    String vaInfo = await SharedPres.get('videoApiInfo') ?? '';
    int currentSourceId = await SharedPres.getInt('currentSourceId') ?? 0;
    print(csInfo);
    print(vaInfo);
    setState(() {
      sourcesList = json.decode(vaInfo)['source'];
    });
  }
}
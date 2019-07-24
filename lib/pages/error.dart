import 'package:flutter/material.dart';

import 'package:aferica_flutter_components/components/ExceptionMessage.dart';

class ErrorPage extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
//        title: Text('发生错误，请返回重试'),
      ),
      body: Center(
        child: ExceptionMessage(
          type: 'net',
        ),
      )
    );
  }
}
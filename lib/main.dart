import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

import 'utils/request.dart';
import 'utils/route.dart';

void main() {
  IjkConfig.isLog = true;
//  IjkConfig.level = LogLevel.verbose;
  IjkManager.initIJKPlayer();

  // 强制竖屏
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  // 添加路由
  final router = new Router();
  Routes.configureRoutes(router);
  Routes.router = router;
  // 添加dio拦截器
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (RequestOptions options) {
      print('请求地址：' + options.uri.toString());
      DioError e;
      return e;
//      return options;
    },
    onResponse: (Response response) {
      print(response.data.toString());
      // 对返回数据JSON数据处理
      // 例如`[{"":""},{"":""},{"":""}]`
      // 需要使用`{}`处理后才可以转为Map
      String tempRes = response.data.toString();
      if(tempRes[0] == '[') {
        tempRes = '{"reslut":' + tempRes + '}';
      }
      Map<String, dynamic> result = json.decode(tempRes.toString());
      response.data = result;
      return response;
    },
    onError: (DioError e) {
      if(e.type == DioErrorType.CONNECT_TIMEOUT || e.type == DioErrorType.RECEIVE_TIMEOUT || e.type == DioErrorType.SEND_TIMEOUT) {
        Fluttertoast.showToast(msg: '网络请求超时，请检查网络后重试', backgroundColor: Colors.black54, fontSize: 12.0);
      }
      if(e.type == DioErrorType.CANCEL) {
        Fluttertoast.showToast(msg: '用户取消请求', backgroundColor: Colors.black54, fontSize: 12.0);
      }
      return false;
    }
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '爱看影视',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
//        primarySwatch: Colors.teal,
        primaryColor: Color(0xffffffff),
        backgroundColor: Color(0xffffffff)
      ),
      onGenerateRoute: Routes.router.generator,
    );
  }
}


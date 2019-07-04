import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'utils/request.dart';
import 'utils/route.dart';

void main() {
  // 添加路由
  final router = new Router();
  Routes.configureRoutes(router);
  Routes.router = router;
  // 添加dio拦截器
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (RequestOptions options) async {
      print('请求地址：' + options.uri.toString().replaceAll(new RegExp(r'\n'), ''));
      return options;
    },
    onResponse: (Response response) async {
      print(response.data.toString());
      return response;
    },
    onError: (DioError e) {
      if(e.type == DioErrorType.CONNECT_TIMEOUT || e.type == DioErrorType.RECEIVE_TIMEOUT || e.type == DioErrorType.SEND_TIMEOUT) {
        Fluttertoast.showToast(msg: '网络请求超时，请检查网络后重试', backgroundColor: Colors.black54, fontSize: 12.0);
      }
      if(e.type == DioErrorType.CANCEL) {
        Fluttertoast.showToast(msg: '用户取消请求', backgroundColor: Colors.black54, fontSize: 12.0);
      }
      return e;
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


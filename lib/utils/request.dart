import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
//import 'package:html/parser.dart' as parse;
//import 'package:html/dom.dart';
//import 'dart:convert';

import 'package:ai_video/components/GiggyDialog.dart';

BaseOptions options = new BaseOptions(
  connectTimeout: 5000,
  receiveTimeout: 3000,
  responseType: ResponseType.plain
);
Dio dio = new Dio(options);

class Request {
  static Future<String> get(String url, BuildContext context,{ bool showLoading = true, bool closeLoading = true, String css, }) async {
    if (showLoading) {
      showDialog<Null>(
        context: context,
        builder: (_) => LoadingDialog()
      );
    }
    Response res = await dio.get(url);
    if (css != null) {

    }

    if (closeLoading) {
      Navigator.pop(context);
    }
    return res.data;
  }
}
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
//import 'package:html/parser.dart' as parse;
//import 'package:html/dom.dart';
//import 'dart:convert';

import 'package:ai_video/components/Dialog.dart';

import 'package:ai_video/utils/route.dart';

BaseOptions options = new BaseOptions(
  connectTimeout: 5000,
  receiveTimeout: 10000,
  responseType: ResponseType.plain
);
Dio dio = new Dio(options);

class Request {
  ///
  /// @require url 请求地址
  /// @require context 请求页BuildContext对象
  /// showLoading 是否显示加载提示框
  /// closeLoading 是否关闭加载提示框
  /// 这两个通常配合使用
  ///
  /// 当连续请求，如首页加载过多信息时，可以通过设置第一次显示提示框，不关闭
  /// 最后一次只关闭，不显示，中间不显示不关闭来避免多次闪烁的问题
  ///
  static Future<Map<String, dynamic>> get(String url, BuildContext context,{ bool showLoading = true, bool closeLoading = true}) async {
    if (showLoading) {
      showDialog<Null>(
        context: context,
        builder: (_) => LoadingDialog()
      );
    }
    Response res = await dio.get(url);

    if (closeLoading) {
      Navigator.pop(context);
      if (res.statusCode != 200) {
        Routes.router.navigateTo(context, '/error');
        return {};
      }
    }
    return res.data;
  }
}
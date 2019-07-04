import 'package:dio/dio.dart';

BaseOptions options = new BaseOptions(
  connectTimeout: 5000,
  receiveTimeout: 3000,
  responseType: ResponseType.plain
);
Dio dio = new Dio(options);

class Request {
  static Future<String> get(String url) async {
    Response res = await dio.get(url);
    print('xxxxxxxxx');
    return res.data;
  }
}
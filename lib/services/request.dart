import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import './api.dart';
import '../common/global.dart';

class Request {
  //超时时间
  static const int CONNECT_TIMEOUT = 10000;
  static const int RECEIVE_TIMEOUT = 5000;
  static final Map<String, dynamic> headers = {
    'version': Global.version,
    'Authorization': 'token',
  };

  final Dio _dio = Dio();

  Request.init() {
    _dio.options.headers = headers;
    _dio.options.baseUrl = Api.api_prefix;
    _dio.options.connectTimeout = CONNECT_TIMEOUT;
    _dio.options.receiveTimeout = RECEIVE_TIMEOUT;
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      // 在请求被发送之前做一些事情
      return options; //continue
      // 如果你想完成请求并返回一些自定义数据，可以返回一个`Response`对象或返回`dio.resolve(data)`。
      // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义数据data.
      //
      // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象，或返回`dio.reject(errMsg)`，
      // 这样请求将被中止并触发异常，上层catchError会被调用。
    }, onResponse: (Response response) async {
      // 在返回响应数据之前做一些预处理
      return response; // continue
    }, onError: (DioError e) async {
      // 当请求失败时做一些预处理
      print(e);
      return e; //continue
    }));
  }

  //get
  Future<Response> httpGet(String path) {
    return request(path, 'get', null);
  }

  //post
  Future<Response> httpPost(String path, dynamic postData) {
    return request(path, 'post', postData);
  }

  Future<Response> request(String path, String method, dynamic postData) async {
    Response response;
    try {
      switch (method) {
        case 'get':
          response = await _dio.get(path);
          return response;
        case 'post':
          //做一层json 转换
          response = await _dio.post<Map<String, dynamic>>(path,
              data: json.encode(postData));
      }
    } on DioError catch (exception) {
      print('请求出错：${exception.toString()}');
    } catch (error) {
      print('请求出错：${error.toString()}');
    }
    return response;
  }

  static Request _instance;
  static Request getInstance() {
    if (_instance == null) {
      _instance = Request.init();
    }
    return _instance;
  }
}

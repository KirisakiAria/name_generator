//核心库
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
//api
import './api.dart';
//common
import '../common/global.dart';
//组件
import '../widgets/loading_dialog.dart';
//model
import '../model/user.dart';

class Request {
  //超时时间
  static const int CONNECT_TIMEOUT = 10000;
  static const int RECEIVE_TIMEOUT = 10000;

  final Dio _dio = Dio();

  Request({
    BuildContext context,
    bool showLoadingDialog = true,
  }) {
    _dio.options.headers = {
      'appname': 'bianzizai',
      'packagename': Global.packageName,
      'version': Global.version,
      'buildnumber': Global.buildNumber,
      'authorization': context.read<UserProvider>().token,
      'secret': API.secret,
    };
    _dio.options.baseUrl = API.api_prefix;
    _dio.options.connectTimeout = CONNECT_TIMEOUT;
    _dio.options.receiveTimeout = RECEIVE_TIMEOUT;
    //解决https证书不通过的问题（实际上是允许所有https证书，不安全，找到更好的办法后会更新）
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    //添加cookie
    CookieJar cookieJar = CookieJar();
    _dio.interceptors.add(CookieManager(cookieJar));
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options) async {
          if (showLoadingDialog) {
            showGeneralDialog(
              context: context,
              pageBuilder: (
                BuildContext context,
                Animation<double> anim1,
                Animation<double> anim2,
              ) {
                return LoadingDialog();
              },
              barrierDismissible: false,
              barrierLabel: '',
              barrierColor: Colors.transparent,
              transitionDuration: Duration(milliseconds: 300),
              transitionBuilder: (
                BuildContext context,
                Animation<double> anim1,
                Animation<double> anim2,
                Widget child,
              ) {
                return Transform.scale(
                  scale: anim1.value,
                  child: child,
                );
              },
            );
          }
          return options; //continue
        },
        onResponse: (Response response) async {
          if (showLoadingDialog) {
            if (response.data['code'] != '1000') {
              final SnackBar snackBar =
                  SnackBar(content: Text(response.data['message']));
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            Navigator.pop(context);
          }
          return response;
        },
        onError: (DioError e) {
          if (showLoadingDialog) {
            final SnackBar snackBar = SnackBar(
              content: const Text('服务器开小差了，请稍后再试~'),
              duration: Duration(seconds: 2),
            );
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  //get
  Future<Response> httpGet(String path) {
    return request(path, 'get', null);
  }

  //post
  Future<Response> httpPost(String path, dynamic data) {
    return request(path, 'post', data);
  }

  Future<Response> httpPut(String path, dynamic data) {
    return request(path, 'put', data);
  }

  Future<Response> httpDelete(String path) {
    return request(path, 'delete', null);
  }

  Future<Response> request(String path, String method, dynamic data) async {
    Response response;
    try {
      switch (method) {
        case 'get':
          response = await _dio.get(path);
          return response;
        case 'post':
          response = await _dio.post<Map<String, dynamic>>(path, data: data);
          return response;
        case 'put':
          response = await _dio.put<Map<String, dynamic>>(path, data: data);
          return response;
        case 'delete':
          response = await _dio.delete(path);
          return response;
      }
    } on DioError catch (exception) {
      print('请求出错：${exception.toString()}');
    } catch (error) {
      print('请求出错：${error.toString()}');
    }
    return response;
  }
}

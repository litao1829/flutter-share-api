import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';
import '../view/login/login.dart';
import 'logs_Interceptor.dart';

class DioUtils{
  late Dio _dio;

  //单例
  static DioUtils? _instance;

  static DioUtils get instance => _getInstance();

  factory DioUtils()=>_getInstance();

  //私有命名构造函数
  DioUtils._internal(){
    BaseOptions options =BaseOptions();

    //设置连接请求时间
    options.connectTimeout=const Duration(seconds: 20);

    //设置接收超时时间
    options.receiveTimeout=const Duration(seconds: 20);

    //设置发送超时时间
    options.sendTimeout=const Duration(seconds: 20);

    //初始化
    _dio=Dio(options);
    //当App运行在Release环境时，inProduction为true
    //当App运行在Debug和Profile环境时，inProduction为false
    bool inProduction =const bool.fromEnvironment("dart.vm.product");
    if(!inProduction){
      debugFunction();
    }
  }

  //创建实例
  static DioUtils _getInstance(){
      //创建实例
     print(DioUtils._internal());
     _instance ??=DioUtils._internal();
     return _instance!;
  }

  //debug模式下，执行log拦截
  void debugFunction(){
    //添加log拦截器
    _dio.interceptors.add(LogsInterceptors());
  }

  //get请求
  Future<ResponseInfo> getRequest(
      {required String url,
      Map<String,dynamic>? params,
      CancelToken? cancelToken})async{
      try{
          Response response=await _dio.get(url,queryParameters: params,cancelToken: cancelToken);
          //响应数据
          dynamic responseData=response.data;

          //数据解析
        if(responseData is Map<String,dynamic>){
            bool success =responseData['success'];
            if(success){
                //请求成功，处理返回值
              dynamic data=responseData['data'];
              String message=responseData['message'];
              return ResponseInfo(data:data,message:message);
            }else{
              //业务代码异常
              return ResponseInfo.error(message:responseData['message']);
            }
        }else{
          return ResponseInfo.error(message:"未知异常");
        }
      }catch(e,s){
          return errorController(e,s);
      }
  }

  Future<ResponseInfo> postRequest(
      {required String url,
        Map<String,dynamic> ? formDataMap,
        Map<String,dynamic> ? data,
        CancelToken? cancelToken
      })async{
      FormData? form;
      if(formDataMap !=null){
          form=FormData.fromMap(formDataMap);
      }

      //发送请求
      try{
        Response response=
          await _dio.post(url,data:form ?? data!,cancelToken: cancelToken);

        //接收响应内容
        dynamic responseData =response.data;

        if(data is Map){
          Map response =responseData;
          print("请求响应参数"+response.toString());
          if(response['success']){
            //处理正常业务
            dynamic data =responseData['data'];
            return ResponseInfo(data:data,message:response['message']);
          }else{
            return ResponseInfo.error(code:-1,message:response['message']);
          }
        }
        else{
          return ResponseInfo.error(code:-1,message:"返回数据格式异常");
        }
      }catch(e,s){
        return errorController(e,s);
      }
  }

  //上传文件
  Future<ResponseInfo> upload(String localFilePath,String url)async{
    Map<String,dynamic> map=Map();
    map['file']=await MultipartFile.fromFile(localFilePath,
    filename: localFilePath.substring(localFilePath.indexOf(".")));
    //构建formdata
    FormData formData=FormData.fromMap(map);
    //发送post请求
    try{
      Response response=await _dio.post(url,data:formData,
      onSendProgress: (count,total){
        print("当前进度：$count总进度：$total");
      });
      var data=response.data;
      if(data is Map){
        if(data['success']){
            return ResponseInfo(data: data['data'],message: data['message']);
        }
        else{
          return ResponseInfo.error(message: data['message']);
        }
      }
      else{
        return ResponseInfo.error(message: data['message']);
      }
    }catch(e,s){
      return errorController(e,s);
    }
  }


  //构建异常处理控制器
  Future<ResponseInfo> errorController(e,StackTrace s){
    ResponseInfo responseInfo=ResponseInfo();
    responseInfo.success=false;

    //网络处理错误
    if(e is DioException){
      DioException dioError = e;
      switch (dioError.type) {
        case DioExceptionType.connectionTimeout:
          responseInfo.message = "连接超时";
          break;
        case DioExceptionType.sendTimeout:
          responseInfo.message = "请求超时";
          break;
        case DioExceptionType.receiveTimeout:
          responseInfo.message = "响应超时";
          break;
        case DioExceptionType.badResponse:
        // 响应错误
          responseInfo.message = "响应错误";
          break;
        case DioExceptionType.cancel:
        // 取消操作
          responseInfo.message = "已取消";
          break;
        case DioExceptionType.unknown:
        // 默认⾃定义其他异常
          responseInfo.message = "⽹络请求异常";
          break;
        case DioExceptionType.badCertificate:
          responseInfo.message = "⽹络证书异常";
          break;
        case DioExceptionType.connectionError:
          responseInfo.message = "⽹络连接异常";
          break;
      }
    }else{
      //其他错误
      responseInfo.message = "未知错误";
      Fluttertoast.showToast(
        msg: e.message!,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }

    if (e.message.toString().contains("401")) {
      navigatorKey.currentState!.push(MaterialPageRoute(builder: (context
          ) {
        return LoginPage();
      }));
      responseInfo.message = "登录失效";
    }
    Fluttertoast.showToast(
      msg: responseInfo.message!,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
    responseInfo.success = false;
    responseInfo.code = -1;
    return Future.value(responseInfo);
  }

}

class ResponseInfo {
  bool? success;
  String? message;
  dynamic data;
  int code;
  ResponseInfo({this.success = true, this.code = 200, this.data, this.message});
  ResponseInfo.error(
 {this.success = false, this.code = 201, this.message = "请求异常"});
}

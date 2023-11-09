import 'package:dio/dio.dart';

import '../db/sp_utils.dart';

class LogsInterceptors extends InterceptorsWrapper{
    @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // TODO: implement onRequest
    super.onRequest(options, handler);
    String token = SpUtils.getInstance().get("token", "")!;
    if (token != "") {
      options.headers = {"token": token};
    }
    print("\n================== 请求数据 ==========================");
    print("|请求url：${options.path}");
    print('|请求头: ' + options.headers.toString());
    print('|请求参数: ' + options.queryParameters.toString());
    print('|请求⽅法: ' + options.method);
    print("|contentType = ${options.contentType}");
    print('|请求时间: ' + DateTime.now().toString());
    if (options.data != null) {
      print('|请求数据: ' + options.data.toString());
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: implement onResponse
    super.onResponse(response, handler);
    print("\n|================== 响应数据 ==========================");
    // ignore: unnecessary_null_comparison
    if (response != null) {
      print("|url = ${response.realUri.path}");
      print("|code = ${response.statusCode}");
      print("|data = ${response.data}");
      print('|返回时间: ' + DateTime.now().toString());
      print("\n");
    } else {
      print("|data = 请求错误 E409");
      print('|返回时间: ' + DateTime.now().toString());
      print("\n");
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // TODO: implement onError
    super.onError(err, handler);
    print("\n================== 错误响应数据 ======================");
    print("|type = ${err.type}");
    print("|message = ${err.message}");
    print('|response = ${err.response}');
    print("\n");
  }
}
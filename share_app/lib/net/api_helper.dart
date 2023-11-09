class ApiHelper {
  /// 基础url
  static const String BASE_URL = "http://10.22.242.105:8000/";
  // static const String BASE_URL = "http://10.21.25.0:8000/";
  /// 登录
  static const String login = BASE_URL + "user-service/user/login";
  /// 我的投稿
  static const String contribute = BASE_URL + "content-service/share/my-contribute";

  ///投稿
  static const String tocontribute= BASE_URL + "content-service/share/contribute";

  ///我的兑换
  static const String myexchange = BASE_URL + "content-service/share/myexchange";
  //文件上传
  static const String uploadAvatar=BASE_URL+"user-service/user/upload";

  //首页分享列表查询
  static const String shareList=BASE_URL+"content-service/share/list";
  ///查询分享的详细信息
  static const String shareDetail=BASE_URL+"content-service/share/";
  ///兑换分享
  static const String exchangeShare=BASE_URL+"content-service/share/exchange";


  ///查询积分明细
  static const String scoredetail=BASE_URL+"user-service/user/logs/";

  ///签到
  static const String usersigin=BASE_URL + "user-service/user/sigin";
}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


import '../../common/constant.dart';
import '../../db/sp_utils.dart';
import '../../model/login_model.dart';
import '../../net/api_helper.dart';
import '../../net/dio_utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _psdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    /// 初始化账号密码
    _phoneController.text =
    SpUtils.getInstance().get(Constant.USER_ACCOUNT, "13951905171")!;
    _psdController.text =
    SpUtils.getInstance().get(Constant.USER_PASSWORD, "123123")!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/login_bg.jpg"),
              fit: BoxFit.fill)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("知识分享",
              style: TextStyle(fontSize: 28,
              color: Color(0xffbf6b3f),
              fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 70,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("账号：",
                style: TextStyle(color: Constant.black,fontSize: 20),),
                const SizedBox(width:10,),
                SizedBox(
                  width:260,
                  height:30,
                  child: TextField(
                    style:TextStyle(color:Constant.black,fontSize:16),
                    decoration:InputDecoration(),
                    controller:_phoneController,
                  ),
                )
              ],
            ),
            const SizedBox(
              height:20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("密码：",
                  style: TextStyle(color: Constant.black,fontSize: 20),),
                const SizedBox(width:10,),
                SizedBox(
                  width:260,
                  height:30,
                  child: TextField(
                    obscureText: true,
                    style:TextStyle(color:Constant.black,fontSize:16),
                    decoration:InputDecoration(),
                    controller:_psdController,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 60,
            ),
            GestureDetector(
              onTap: (){
                //登录
                _login();
              },
              child: Container(
                width: 320,
                height: 40,
                color: const Color(0xffbf6b3f),
                alignment: Alignment.center,
                child: Text(
                  "登录",
                  style: TextStyle(color: Constant.white,fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 登录接⼝
  void _login() async {
    var result = await DioUtils.instance.postRequest(
        url: ApiHelper.login,
        data: {
          "phone": _phoneController.text,
          "password": _psdController.text
        });
    print(result.data.toString());
    if (result.success == true) {
      LoginModel model = LoginModel.fromJson(result.data);
      /// 将user信息转成字符串进⾏存储
      SpUtils.getInstance()
          .setData(Constant.USER_INFO, json.encode(model.toJson()));
      SpUtils.getInstance().setData(Constant.TOKEN, model.token);
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, "index");
    } else {
      Fluttertoast.showToast(
        msg: "${result.message}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }
}

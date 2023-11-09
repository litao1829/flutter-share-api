import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:share_app/common/constant.dart';
import 'package:share_app/common/global.dart';
import 'package:share_app/db/sp_utils.dart';
import 'package:share_app/model/login_model.dart';
import 'package:share_app/net/api_helper.dart';
import 'package:share_app/net/dio_utils.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {

  LoginModel? model;
  User? user;

  List menus=[
    {"name":"我的兑换","icon":"assets/images/exchange.png","route_name":"my_exchange"},
    {"name":"积分明细","icon":"assets/images/account_detail.png","route_name":"score_detail"},
    {"name":"我的投稿","icon":"assets/images/submission.png","route_name":"my_submission"},
    {"name":"帮助","icon":"assets/images/help.png","route_name":"help"},
    {"name":"设置","icon":"assets/images/setting.png","route_name":"setting"}
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(SpUtils.getInstance().get(Constant.USER_INFO, "")!=''){
        print("GGGGGGGGGGGGGGGGGGGG");
        model=LoginModel.fromJson(json.decode(SpUtils.getInstance().get(Constant.USER_INFO, "")!));
        user=model!.user;
    }
    else{
      print("Dddddddddddddddddddddd");
      user=User(id:1,phone:"",password:"",nickname:"",
          roles:"",avatarUrl:"",bonus:0,createTime:"",updateTime:"");
      model=LoginModel(user: user,token: '');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constant.miancolor,
        title: Text("我的",
        style: TextStyle(color: Constant.white,fontSize: 24,fontWeight: FontWeight.bold),),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _builderHead(),
          const SizedBox(
            height: 40,
          ),
          Expanded(child: _buildGridView())
        ],
      ),
    );
  }

  Widget _builderHead(){
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
         GestureDetector(
           onTap: (){
             _updateAvatar();
           },
           child: CircleAvatar(
            backgroundImage: NetworkImage(user!.avatarUrl!),
            radius: 40,
        ),
         ),
        const SizedBox(
          height: 10,
        ),
         Text("积分:${user!.bonus!}"),
        const SizedBox(
          height: 10,
        ),
       Row(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           GestureDetector(
             onTap: (){
               userSigin();
             },
             child: Container(
               color: Constant.miancolor,
               padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
               child: Text("签到",
                 style: TextStyle(color: Constant.white,fontSize: 16),),
             ),
           ),
           SizedBox(
             width: 10,
           ),
           GestureDetector(
             onTap: (){
               Navigator.pushNamed(context, "login");
             },
             child: Container(
               color: Constant.miancolor,
               padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
               child: Text("退出",
                 style: TextStyle(color: Constant.white,fontSize: 16),),
             ),
           ),
         ],
       )
      ],
    );
  }

  Widget _buildGridView(){
    return GridView.builder(
      ///内边距
      padding: const EdgeInsets.all(5),

      ///用于配置网格的布局方式
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(

        ///表示网格的列数
        crossAxisCount: 4,

        ///表示每个子部件的宽高比，可以控制子部件的大小
        childAspectRatio: 1,

        ///表示主轴（通常是垂直轴）上的间距
        mainAxisSpacing: 5,

        ///表示交叉轴（通常是水平轴）上的间距
        crossAxisSpacing: 2
      ),
      itemCount: menus.length,
      itemBuilder: (context,index){
          var item=menus[index];
          return GestureDetector(
            onTap: (){
              Navigator.pushNamed(context,item['route_name'],arguments: item['name']);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  item['icon'],
                  width: 40,
                  height: 40,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  item['name'],
                  style: const TextStyle(fontSize: 16),
                )
              ],
            ),
          );
      },
    );
  }

  //更新头像
  void _updateAvatar() async{
    FilePickerResult? result=await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type:FileType.custom,
      allowedExtensions: ['jpg','png','jpeg']);
    if(result!=null){
      String path=result.files.single.path!;
      var resoponse=await DioUtils.instance.upload(path, ApiHelper.uploadAvatar);
      if(resoponse.code==200){
        print(resoponse.data);
        user!.avatarUrl=resoponse.data;
      }
      setState(() {});
      //更新本地用户信息
      SpUtils.getInstance().setData(Constant.USER_INFO, json.encode(model!));

    }
  }

  void userSigin()async{
    var result=await DioUtils.instance.getRequest(url: ApiHelper.usersigin,);
    if(result.success==true){
      Fluttertoast.showToast(msg: result.message!);
      setState(() {
       user!.bonus=(user!.bonus??0)+15;
      });
    }else{
      Fluttertoast.showToast(msg:result.message!);
    }
  }
}
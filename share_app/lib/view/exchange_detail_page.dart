import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:share_app/common/constant.dart';
import 'package:share_app/db/sp_utils.dart';
import 'package:share_app/model/ArticleDetail.dart';
import 'package:share_app/model/article_model.dart';
import 'package:share_app/model/login_model.dart';
import 'package:share_app/net/api_helper.dart';
import 'package:share_app/net/dio_utils.dart';
import 'package:share_app/provider/list_item_notification.dart';
import 'package:share_app/view/index.dart';
import 'package:share_app/view/notice_detail_page.dart';

class ExchangeDetailPage extends StatefulWidget {
  final String id;
  ExchangeDetailPage(this.id,{super.key});

  @override
  State<ExchangeDetailPage> createState() => _ExchangeDetailPageState();
}

class _ExchangeDetailPageState extends State<ExchangeDetailPage> {
  ArticleDetail model=ArticleDetail();
  LoginModel loginModel=LoginModel();

  bool isExchange=false;
  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    if(SpUtils.getInstance().get(Constant.USER_INFO, "")!=''){
      loginModel=LoginModel.fromJson(json.decode(SpUtils.getInstance().get(Constant.USER_INFO, "")!));
    }else{
      loginModel=LoginModel();
      loginModel.user=User();
      loginModel.user!.avatarUrl="";
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("兑换",style: TextStyle(fontSize: 24,color: Constant.white),),
        backgroundColor: Constant.miancolor,
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.done){
            if(snapshot.hasError){
                return Text("请求异常：${snapshot.error}");
            }
            else{
              return _buildBody();
            }
          }else{
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  ///获取item详情页
 Future<void> getData() async{
    var result=await DioUtils.instance.getRequest(url: ApiHelper.shareDetail+widget.id);
    if(result.success==true){
        model=ArticleDetail.fromJson(result.data);
    }else{
      Fluttertoast.showToast(msg: "获取异常");
    }
 }

 ///兑换资源
  void exchangeResource(ListItemNotification value) async{
    var result=await DioUtils.instance.postRequest(
      url: ApiHelper.exchangeShare,
      data: {"userId":loginModel.user!.id,"shareId":model.share!.id}
    );

    if(result.success==true){
        Fluttertoast.showToast(msg: "兑换成功");
        value.updateStatusById(model.share!.id!.toString(),true);
        isExchange=true;
        setState(() {});
        getData();
    }else{
      Fluttertoast.showToast(msg:result.message!);
    }
  }

  Widget _buildBody() {
    return Container(
      color: Constant.white,
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(model.share!.title!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Constant.black
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("作者：${model.share!.author}",
                    style: TextStyle(fontSize: 14),),
                    Text("发布人：${model.nickname}",
                      style: TextStyle(fontSize: 14),),
                    Text("下载次数：${model.share!.buyCount}",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 10,
            color: Constant.grey,
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Image(
              image: NetworkImage(model.share!.cover!),
            ),
          ),
          Expanded(
              child: Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(10),
                child: Text(
                  model.share!.summary ?? "",
                  style: TextStyle(fontSize: 14),
                ),
              ),
          ),
          Container(
            decoration: BoxDecoration(color: Constant.white,boxShadow: [
              BoxShadow(color: Constant.grey,offset: Offset(0,-2))
            ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                visible: !isExchange
                    ,child: Text(
                  "积分",
                  style: TextStyle(
                    color: Constant.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,),
                ),
                ),
                Visibility(
                    visible: !isExchange
                    ,child: Text(
                  "￥${model.share!.price}",
                  style: TextStyle(
                    color: Constant.miancolor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14
                  ),
                ),)
                ,const SizedBox(
                  width: 10,
                ),
                !isExchange?
                    Consumer<ListItemNotification>(
                        builder: (BuildContext context,
                            ListItemNotification value,Widget? child){
                          return GestureDetector(
                            onTap: (){
                              ///兑换
                              exchangeResource(value);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 45,
                              width: 100,
                              color: Constant.miancolor,
                              child: Text(
                                "兑换",
                                style: TextStyle(
                                  color: Constant.white,
                                  fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        }
                    ):
                    GestureDetector(
                      onTap: (){
                        ///替换当前路由栈
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context){
                              return NoticeDetailPage(model.share!.id!.toString());
                            }));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 45,
                        width: 100,
                        color: Constant.miancolor,
                        child: Text(
                          "去下载",
                          style: TextStyle(
                            color: Constant.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    )
              ],
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:share_app/common/constant.dart';
import 'package:share_app/db/sp_utils.dart';
import 'package:share_app/model/article_model.dart';
import 'package:share_app/model/knowledge_model.dart';
import 'package:share_app/provider/list_item_notification.dart';
import 'package:share_app/view/exchange_detail_page.dart';
import 'package:share_app/view/home.dart';
import 'package:share_app/view/home/Knowledge_detail.dart';
import 'package:share_app/view/login/login.dart';
import 'package:share_app/view/mine.dart';
import 'package:share_app/view/notice_detail_page.dart';


class ItemCard extends StatefulWidget {
  ArticleModel model;

   ItemCard(this.model,{super.key});

  @override
  State<ItemCard> createState() => _ItemCardState();
}


class _ItemCardState extends State<ItemCard> {
  bool isLogin=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
      },
      child:  Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Constant.lineColor,width: .5,style: BorderStyle.solid)),
        ),
        child: Row(
          children: [
            SizedBox(width: 10,),
            Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(widget.model.cover!,scale: 1),
                ),
                Offstage(
                  offstage: widget.model.isOriginal!=true ,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(6, 2, 5, 2),
                    color: Constant.miancolor,
                    child: Text("原创",style: TextStyle(fontSize: 12,color: Constant.white),),
                  ),
                ),Offstage(
                  offstage: widget.model.isOriginal!=false ,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(6, 2, 5, 2),
                    color: Colors.green,
                    child: Text("转载",style: TextStyle(fontSize: 12,color: Constant.white),),
                  ),
                )
              ],
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  Text(widget.model.title!,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Constant.black),),
                  SizedBox(height: 5,),
                  Text(widget.model.summary!,style: TextStyle(
                    fontSize: 14,
                    color: Constant.black,
                    ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,),
                  SizedBox(height: 10,),
                ],
              ),
            ),
            // Offstage(
            //   offstage: widget.model.downloadUrl==null ,
            //   child: Column(
            //     mainAxisSize: MainAxisSize.min,
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       Text(widget.model.price!.toString()+"积分"),
            //       Text("兑换",style: TextStyle(fontSize: 14,color: Constant.black),)
            //     ],
            //   ),
            // ),
            // Offstage(
            //   offstage: widget.model.downloadUrl!=null,
            //   child: Container(
            //     width: 50,
            //     child: Column(
            //       mainAxisSize: MainAxisSize.min,
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         Text(widget.model.price!.toString()+"积分"),
            //         Text("下载",style: TextStyle(fontSize: 14,color: Constant.black))
            //       ],
            //     ),
            //   ),
            // ),
            Consumer<ListItemNotification>(
                builder:(context,value,Widget? child){
                  if(value.id == widget.model.id!.toString() && value.isExchange){
                    return TextButton(
                        onPressed: ()=> jumpToDownload(),
                        child: const Text(
                          "下载",
                          style: TextStyle(fontSize: 14),
                        )
                    );
                  }
                  return Container(
                    child: ((widget.model.downloadUrl==null||!isLogin))
                    ? TextButton(
                        onPressed: (){
                          if(isLogin){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return ExchangeDetailPage(widget.model.id!.toString());
                            })
                            );
                          }
                          else{
                            Fluttertoast.showToast(msg: "当前没有登录");
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return LoginPage();
                            })
                            );
                          }
                        },
                        child: const Text("兑换",
                          style: TextStyle(fontSize: 14),)
                    )
                        :TextButton(onPressed: ()=>jumpToDownload(),
                        child: const Text(
                          "下载",
                        style: TextStyle(fontSize: 14),))
                  );
                }
            ),
            SizedBox(width: 20,)
          ],
        ),
      ),
    );
  }

  ///初始化数据
  void initData(){
    var token=SpUtils.getInstance().get(Constant.TOKEN, "");
    if(token!.isEmpty){
      isLogin=false;
    }else{
      isLogin=true;
    }
  }

  ///跳转到下载列表
  void jumpToDownload(){
    Navigator.push(context, MaterialPageRoute(builder: (context){
        return NoticeDetailPage(widget.model!.id!.toString());
    }));
  }
}

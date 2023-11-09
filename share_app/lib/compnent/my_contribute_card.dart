import 'package:flutter/material.dart';
import 'package:share_app/common/constant.dart';
import 'package:share_app/model/article_model.dart';
import 'package:share_app/model/knowledge_model.dart';
import 'package:share_app/view/home/Knowledge_detail.dart';

import '../view/notice_detail_page.dart';


class MyContributeItem extends StatefulWidget {
  ArticleModel model;

  MyContributeItem(this.model,{super.key});

  @override
  State<MyContributeItem> createState() => _MyContributeItemState();
}


class _MyContributeItemState extends State<MyContributeItem> {


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
            SizedBox(width: 5,),
            Stack(
              children: [

                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(widget.model.cover!,scale: 1),
                ),
              ],
            ),
            const SizedBox(width: 10,),
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
                  SizedBox(height: 10,)
                ],
              ),
            ),
            Container(
              width: 50,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(widget.model.price!.toString()+"积分"),
                  GestureDetector(
                      onTap: (){
                        print("YYYYYYYYYYYYYYYYYY");
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return NoticeDetailPage(widget.model!.id!.toString());
                        }));
                      },
                      child: Text("下载",style: TextStyle(fontSize: 14,color: Constant.black)))
                ],
              ),
            ),
            SizedBox(width: 20,)
          ],
        ),
      ),
    );
  }
}
